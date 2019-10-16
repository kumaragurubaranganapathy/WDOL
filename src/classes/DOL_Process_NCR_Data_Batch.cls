/************************************************************************************************************
** Name             : DOL_Process_NCR_Data_Batch
** Description   	: NCR Batch, create renewal and reinstatement application for the given license and 
                        pay the fees for the same.
** Version          : 1.0
**-------------------------------------
** Revision History:
**---------------------------
** [Laltu Banerjee]: Created
*************************************************************************************************************/
global class DOL_Process_NCR_Data_Batch implements Database.Batchable<sObject>{

    private DOL_NCR_Input tempNCRInput;
    private DOL_Dao dolDao = new DOL_Dao();
    private Renewal_Application__c tempRenewalApplication;
    private DOL_Integration_Batch_Input__c tempNCRFileData;

    global DOL_Process_NCR_Data_Batch(){}
    
    global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator([ select id, INFO__c, Input__c, File_Name__c, Status__c, Input_Type__c 
                                        from DOL_Integration_Batch_Input__c 
                                        where Status__c = 'UNPROCESSED' and Input_Type__c = 'NCR' 
                                        ]);
    }

    /*
    * In this transaction we need to process each record individually because
    * in each transaction payment processing is required.
    * And if any record failed we will do the rollback for that record only.
    */
    global void execute(Database.BatchableContext BC, List<DOL_Integration_Batch_Input__c> records){
        Savepoint sp = null;
        if(records != null && records.size() > 0 ){
            MUSW__License2__c tempLicenseRecord;
            // to get all the failed records
            List<NCRFailedRecord> ncrFailedRecords = new List<NCRFailedRecord>();
            NCRFailedRecord tempFailedRecord;
            for(DOL_Integration_Batch_Input__c rec : records){
                sp = null;
                tempNCRFileData = rec;
                tempLicenseRecord = null;
                try{
                    tempNCRFileData.INFO__C = ' ';
                    // parsing the json string
                    tempNCRInput = DOL_NCR_Input.parse(tempNCRFileData.Input__c);
                    // get the license information and renewal record info
                    tempLicenseRecord = getLicenseRecord(tempNCRInput);
                    // Check if we can create renewal record
                    isEligibleForRenewalRecordCreation(tempLicenseRecord);
                    // setting the SavePoint
                    sp = Database.setSavePoint();
                    // create renewalApplication Record
                    createRenewalApplication(tempLicenseRecord);
                    // create submission record
                    createSubmissionRecord();
                    // intiate payment for renewal application
                    doPaymentForRenewalApplication(tempLicenseRecord);
                    // update the status of the record
                    tempNCRFileData.INFO__C += ' Data processed successfully ';
                    tempNCRFileData.Status__c = ' SUCCESSFUL';
                }catch(Exception error){
                    // get the error message into record
                     tempNCRFileData.INFO__c += ' error occured :- '+error.getMessage()+' stack trace '+error.getStackTraceString();
                    // update the status
                     tempNCRFileData.Status__c = ' Failed';
                     if(sp != null){
                         // do rollback if any exception occured
                         Database.rollback(sp);
                         tempNCRFileData.INFO__c += ' Rollback Done';
                     }
                     // store the failed record in list
                     ncrFailedRecords.add(new NCRFailedRecord(tempNCRInput,
                                                tempLicenseRecord,
                                                tempNCRFileData.INFO__c)
                                            );
                }
            }
            // save Dol_Integration_Batch_Input__c record
            DOL_Dao.save(records);
            if(ncrFailedRecords.size() > 0 ){
                try{
                    List<NCR_Failed_Record__c> recordsToBeSaved = new List<NCR_Failed_Record__c>();
                    // Iterate through the failed records and the required object NCR_Failed_Record__c
                    // Save all records of NCR_Failed_Record__c to SFDC
                    for(NCRFailedRecord r : ncrFailedRecords)
                        recordsToBeSaved.add(r.getFailedRecordData());
                    insert recordsToBeSaved;
                }catch(Exception e){
                    DOL_CreateErrorLog_Exception.logApplicationError(e);
                }
            }
        }
    }

    /*
    * get MUSW__License2__c record for given PolarisRecordID OR LicenseNumber
    */
    private MUSW__License2__c getLicenseRecord(DOL_NCR_Input ncrInput){
        MUSW__License2__c license;
        if(String.isNotBlank(ncrInput.PolarisRecordID) )
            license = dolDao.getLicenseAndRenewalRecordByLicenseId(ncrInput.PolarisRecordID);
        else if(String.isNotBlank(ncrInput.LicenseNumber))
            license = dolDao.getLicenseAndRenewalRecordByLicenseNumber(ncrInput.LicenseNumber,ncrInput.ProfCode);
        else{
            throw new CustomException('PolarisRecordID and LicenseNumber both are blank');
        }
        if(license == null){
            throw new CustomException('No license record found for given PolarisRecordID = '+ncrInput.PolarisRecordID+', OR LicenseNumber = '+ncrInput.LicenseNumber);
        }
        return license;
    }

    /*
    * To check if license record is eligible for renewal record creation
    */
    private void isEligibleForRenewalRecordCreation(MUSW__License2__c licenseRecord){
        if( licenseRecord == null ){
            throw new CustomException('License record not found');
        }
        // Is_Renewal_Eligible__c or Is_Reinstatement_Eligible__c need to be true
        if(! ( licenseRecord.Is_Renewal_Eligible__c || licenseRecord.Is_Reinstatement_Eligible__c ) ){
            throw new CustomException('MUSW__License2__c record with Id '+licenseRecord.Id+' is not eligible for Renewal');
        }
        // license can have multiple renewal application
        List<Renewal_Application__c> renewalApps =  licenseRecord.Renewal_Applications__r;
        if(renewalApps.size() == 0){
            return ;
        }
        // If renewal App status belongs to below list then don't create renewal application
        List<String> statusList = new List<String>(); 
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

    /*
    * Function to create renewal Application
    */
    private void createRenewalApplication(MUSW__License2__c licenseRecord){
        tempRenewalApplication = new Renewal_Application__c();
        tempRenewalApplication.Applicant__c = licenseRecord.MUSW__Applicant__c;
        tempRenewalApplication.Application_Type__c = licenseRecord.Application_Type__c;
        tempRenewalApplication.Phone__c = licenseRecord.Phone__c;
        tempRenewalApplication.Credential_Type__c = licenseRecord.Credential_Type__c;
        tempRenewalApplication.Credential__c = licenseRecord.Credential_Type__c;
        tempRenewalApplication.Licensee__c = licenseRecord.MUSW__Primary_Licensee__c;
        tempRenewalApplication.License__c = licenseRecord.Id;
        tempRenewalApplication.Online_or_Paper_Application__c = DOL_AppConstants.NULL_EMPTY_STRING+'Online'; 
        tempRenewalApplication.Renewal_Status__c = DOL_AppConstants.NULL_EMPTY_STRING+'Generate Fee';
        if(licenseRecord.Is_Renewal_Eligible__c)
            tempRenewalApplication.Renewal_Reinstatement_Type__c = DOL_AppConstants.NULL_EMPTY_STRING+'Renewal';
        else
            tempRenewalApplication.Renewal_Reinstatement_Type__c = DOL_AppConstants.NULL_EMPTY_STRING+'Reinstatement';
        tempRenewalApplication.RecordTypeId = getRenewalAppRecordTypeId(licenseRecord.RecordType.Name);
        // below are exception Application Type
        if(licenseRecord.Application_Type__c == 'Camping Resorts'){
            tempRenewalApplication.Camping_Resorts__c = licenseRecord.Camping_Resorts__c;
            tempRenewalApplication.Initial_Contracts__c = licenseRecord.Initial_Contracts__c;
        }else if(licenseRecord.Application_Type__c == 'Timeshares'){
            tempRenewalApplication.Timeshare_Projects__c = licenseRecord.Timeshare_Projects__c;
            tempRenewalApplication.Apartment_Units__c = licenseRecord.Apartment_Units__c;
            tempRenewalApplication.Interval_fees__c = licenseRecord.Interval_fees__c;
            tempRenewalApplication.Advertising_Fees__c = licenseRecord.Advertising_Fees__c;
            tempRenewalApplication.Pieces_of_Personal_Property__c = licenseRecord.Pieces_of_Personal_Property__c;
        }
        DOL_Dao.save(tempRenewalApplication);
        tempNCRFileData.INFO__C += ' Renewal_Application__c created '+tempRenewalApplication.Id;
    }

    /*
    * Function to create submission record
    */
    private void createSubmissionRecord(){
        MUSW__Submission__c submission = new MUSW__Submission__c();
        submission.Name = tempNCRInput.ImageName;
        submission.SAN_Image_URL__c = tempNCRInput.ncrFileImageURL;
        submission.SAN_Image_Name__c = tempNCRInput.ImageName;
        submission.License_Renewal__c = tempRenewalApplication.Id;
		submission.SAN_Image_Type__c = DOL_AppConstants.NULL_EMPTY_STRING+'NCR Revenue';
        insert submission;
        tempNCRFileData.INFO__C += ' Submission Record created '+submission.Id;
    }

    /*
    * Function to get renewal application record type
    */
    private Id getRenewalAppRecordTypeId(String recordTypeName){
        return Schema.SObjectType.Renewal_Application__c.getRecordTypeInfosByName().get(recordTypeName).getRecordTypeId();
    }

    /*
    * Do payment for renewal application
    */
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
        // BUG - 5598 Intake and Payment Method must be NCR for NCR transaction
        ncrReceipt.MUSW__Payment_Method__c = 'NCR';
        ncrReceipt.Intake_Method__c = 'NCR';
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

    class NCRFailedRecord{
        DOL_NCR_Input ncrInput;
        MUSW__License2__c license;
        String errorMsg;
        public NCRFailedRecord(DOL_NCR_Input ncrInput, 
                                MUSW__License2__c license,
                                String errorMsg){
            this.ncrInput = ncrInput;
            this.license = license;
            this.errorMsg = errorMsg;
        }

        public NCR_Failed_Record__c getFailedRecordData(){
            NCR_Failed_Record__c record = new NCR_Failed_Record__c();
            if(ncrInput != null ){
                record.Licensee_Number__c = ncrInput.LicenseNumber;
                record.Profession_Code__c = ncrInput.ProfCode;
                record.Validation_Amount__c = ncrInput.ValidationAmount;
                record.Validation_Date__c = ncrInput.ValidationDate;
                record.Validation_Item_Number__c = ncrInput.ValidationItemNum;
                record.Validation_Sequence_Number__c = ncrInput.ValidationSeqNum;
            }
            if(license != null){
                record.Licensee_Name__c = license.Name_on_Certificate__c;
                record.Profession_Name__c = license.Credential_Type__c;
            }
            record.Error_message__c = errorMsg;
            return record;
        }
    }

    global void finish(Database.BatchableContext BC){ }
}