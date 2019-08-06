global class DOL_Process_NCR_Data_Batch implements Database.Batchable<sObject>{

    private DOL_NCR_Input tempNCRInput;
    private DOL_Dao dolDao = new DOL_Dao();
    private Renewal_Application__c tempRenewalApplication;
    private DOL_Integration_Batch_Input__c tempNCRFileData;

    global DOL_Process_NCR_Data_Batch(){}
    
    global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator([ select id, INFO__c, Input__c, File_Name__c, Status__c, Input_Type__c from DOL_Integration_Batch_Input__c where Status__c = 'UNPROCESSED' and Input_Type__c = 'NCR' ]);
    }

    global void execute(Database.BatchableContext BC, List<DOL_Integration_Batch_Input__c> records){
        Savepoint sp = null;
        if(records != null && records.size() > 0 ){
            String tempSfdcLicenceId = '';
            MUSW__License2__c tempLicenseRecord;
            for(DOL_Integration_Batch_Input__c rec : records){
                sp = null;
                tempNCRFileData = rec;
                try{
                    tempNCRFileData.INFO__C = ' ';
                    tempNCRInput = DOL_NCR_Input.parse(tempNCRFileData.Input__c);
                    tempSfdcLicenceId = tempNCRInput.PolarisRecordID;
                    if(tempSfdcLicenceId != null && tempSfdcLicenceId != '' ){
                        tempLicenseRecord = dolDao.getLicenseAndRenewalRecordByLicenseId(tempSfdcLicenceId);
                        isEligibleForRenewalRecordCreation(tempLicenseRecord);
                        sp = Database.setSavePoint();
                        createRenewalApplication(tempLicenseRecord);
                        createSubmissionRecord();
                        doPaymentForRenewalApplication(tempLicenseRecord);
                        tempNCRFileData.INFO__C += ' Data processed successfully ';
                        tempNCRFileData.Status__c = ' SUCCESSFUL';
                    }
                    else{
                         throw new CustomException('Polaris Id is null or Blank in the input');
                    }
                }catch(Exception error){
                     tempNCRFileData.INFO__c += ' error occured :- '+error.getMessage()+' stack trace '+error.getStackTraceString();
                     tempNCRFileData.Status__c = ' Failed';
                     if(sp != null){
                         Database.rollback(sp);
                         tempNCRFileData.INFO__c += ' Rollback Done';
                     }   
                }
            }
            DOL_Dao.save(records);
        }
    }

    private void isEligibleForRenewalRecordCreation(MUSW__License2__c licenseRecord){
        if( licenseRecord == null ){
            throw new CustomException('License record not found');
        }
        if(! ( licenseRecord.Is_Renewal_Eligible__c || licenseRecord.Is_Late_Renewal_Eligible__c ) ){
            throw new CustomException('MUSW__License2__c record with Id '+licenseRecord.Id+' is not eligible for Renewal');
        }
        List<Renewal_Application__c> renewalApps =  licenseRecord.Renewal_Applications__r;
        if(renewalApps.size() == 0){
            return ;
        }
        List<String> statusList = new List<String>(); // If renewal App status belongs to this list then don't create renewal application.
        statusList.add('Draft');
        statusList.add('Generate Fee');
        statusList.add('In-Review');
        statusList.add('Pending Payment');
        for(Renewal_Application__c renewApp : renewalApps){
            if(statusList.contains(renewApp.Renewal_Status__c)){
                throw new CustomException('Renewal APP id = '+renewApp.id+' already exist with status = '+renewApp.Renewal_Status__c);
            }            
        }
    }

    private void createRenewalApplication(MUSW__License2__c licenseRecord){
        tempRenewalApplication = new Renewal_Application__c();
        tempRenewalApplication.Applicant__c = licenseRecord.MUSW__Applicant__c;
        tempRenewalApplication.Application_Type__c = licenseRecord.Application_Type__c;
        tempRenewalApplication.Phone__c = licenseRecord.Phone__c;
        tempRenewalApplication.Credential_Type__c = licenseRecord.Credential_Type__c;
        tempRenewalApplication.Credential__c = licenseRecord.Credential_Type__c;
        tempRenewalApplication.Licensee__c = licenseRecord.MUSW__Primary_Licensee__c;
        tempRenewalApplication.License__c = licenseRecord.Id;
        tempRenewalApplication.Renewal_Status__c = 'Generate Fee';
        tempRenewalApplication.Renewal_Reinstatement_Type__c = 'Renewal';
        tempRenewalApplication.RecordTypeId = getRenewalAppRecordTypeId(licenseRecord.RecordType.Name);
        DOL_Dao.save(tempRenewalApplication);
        tempNCRFileData.INFO__C += ' Renewal_Application__c created '+tempRenewalApplication.Id;
    }

    private void createSubmissionRecord(){
        MUSW__Submission__c submission = new MUSW__Submission__c();
        submission.Name = tempNCRInput.ImageName;
        submission.SAN_Image_URL__c = tempNCRInput.ncrFileImageURL;
        submission.SAN_Image_Name__c = tempNCRInput.ImageName;
        submission.License_Renewal__c = tempRenewalApplication.Id;
        insert submission;
        tempNCRFileData.INFO__C += ' Submission Record created '+submission.Id;
    }

    private Id getRenewalAppRecordTypeId(String recordTypeName){
        return Schema.SObjectType.Renewal_Application__c.getRecordTypeInfosByName().get(recordTypeName).getRecordTypeId();
    }

    private void doPaymentForRenewalApplication(MUSW__License2__c licenseRecord){
        Renewal_Application__c renewalApp = dolDao.getRenewalApplicationAndFees(tempRenewalApplication.Id);
        List<MUSW__Fee__c> allCreatedFees = renewalApp.Fees__r;
        if( allCreatedFees != null && allCreatedFees.isEmpty() ){
            throw new CustomException(' No Fees are got Created for Renewal Application');
        }
        List<String> feeIdList = new List<String>();
        for(MUSW__Fee__c fee : allCreatedFees){
            feeIdList.add(fee.Id);
        }
        MUSW__Receipt__c ncrReceipt = new MUSW__Receipt__c();
        ncrReceipt.MUSW__Payment_Method__c = 'NCR Payment';
        ncrReceipt.MUSW__Paid_By__c = licenseRecord.MUSW__Primary_Licensee__c;
        ncrReceipt.MUSW__Receipt_Paid_by__c = licenseRecord.MUSW__Applicant__c;
        ncrReceipt.Selected_Fees__c = String.join(feeIdList, ',');
        insert ncrReceipt;
        tempNCRFileData.INFO__C += ' Receipt Created = '+ncrReceipt.Id;
        // Here cartId is null , as we are not creating any cart
        DOL_ProcessPayment processPayment = new DOL_ProcessPayment(licenseRecord.MUSW__Applicant__c,
                                                                    null,
                                                                    feeIdList,
                                                                    ncrReceipt,
                                                                    Decimal.valueOf(tempNCRInput.ValidationAmount)
                                                                    );
        processPayment.doPaymentForNCR();
        
    }

    global void finish(Database.BatchableContext BC){   
    
    }
}