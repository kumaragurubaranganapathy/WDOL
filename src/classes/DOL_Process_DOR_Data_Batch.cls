/**
* User Story: 2298
* Class Name: DOL_Process_DOR_Data_Batch
* Test Class Name: ****
* Description: Batch to process the DOR records from DOL_Integration_Batch_Input__c
* Date:        Developer/Company                    Description
* ------------------------------------------------------------------------------------------------*
* 07/08/2019   Laltu Banerjee/Deloitte           Initial Creation
**/
global class DOL_Process_DOR_Data_Batch implements Database.Batchable<sObject>, 
                                                    Database.Stateful,
                                                    Database.AllowsCallouts {

    private Map<Id,MUSW__License2__c> licenceMap;
    global List<DOR_Response> dorResponses = new List<DOR_Response>(); // To collect the DOR response and send it to Mulesoft
    
    // Record type for DOR Interface
    private Id accountRecTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('DOR Business Account').getRecordTypeId();
    private Id licenseRecTypeId = Schema.SObjectType.MUSW__License2__c.getRecordTypeInfosByName().get('DOR Licenses').getRecordTypeId();
    private Id parcelRecTypeId = Schema.SObjectType.MUSW__Parcel__c.getRecordTypeInfosByName().get('DOR Parcels').getRecordTypeId();
    private Id accConRecTypeId = Schema.SObjectType.MUSW__Account_Contact__c.getRecordTypeInfosByName().get('DOR Account Contacts').getRecordTypeId();

    private List<DOR_Professional_Code_Mapping__mdt> profCodeMappingMdt = [ select License_Type__c, Professional_Code__c, Program__c from DOR_Professional_Code_Mapping__mdt ];
    private List<DOR_License_Status_Mapping__mdt> dorLicenseStatusMdt = [ select DOR_License_Status__c, Salesforce_License_Status__c from DOR_License_Status_Mapping__mdt ];

    private Boolean updateFound;

    global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator([ select id, INFO__c, Input__c, File_Name__c, Status__c, Input_Type__c from DOL_Integration_Batch_Input__c where Status__c = 'UNPROCESSED' and Input_Type__c = 'DOR' ]);
    }
    
    global void execute(Database.BatchableContext BC, List<DOL_Integration_Batch_Input__c> records){
        List<Id> polarisIds = new List<Id>();
        Map<Id,DOL_DOR_Input> dorInputMap = new Map<Id,DOL_DOR_Input>();
        DOL_DOR_Input tempDorInput;
        DOR_Response tempDorResponse;

        MUSW__License2__c tempExistingLicenseRecord;
        MUSW__License2__c tempUpdatedLicense;
        Account tempUpdatedAccount;
        MUSW__Account_Contact__c tempUpdatedAccContact;
        MUSW__Parcel__c tempPhysicalParcel;
        MUSW__Parcel__c tempMailingParcel;
        DOR_sObject tempDORsObject;

        // Here polaris Id is Licence Id
        // creating List of Polaris Id to query DB
        // Creating Map of Parsed Records to process in the next for loop
        // Creating MAP because we don't need to parse the "batchInput.Input__c" again
        System.debug('First for Loop reached');  
        for(DOL_Integration_Batch_Input__c batchInput : records){
            batchInput.INFO__c = '';
            try{
                tempDorInput = DOL_DOR_Input.parse(batchInput.Input__c);
                if(! String.isBlank(tempDorInput.polarisID))
                    polarisIds.add(tempDorInput.polarisID);
                dorInputMap.put(batchInput.Id,tempDorInput );
            }catch(Exception error){
                System.debug('error occured :- '+error.getMessage()+' stack trace '+error.getStackTraceString());
                batchInput.INFO__c = 'error occured :- '+error.getMessage()+' stack trace '+error.getStackTraceString();
            }
        }
        System.debug('Map size = '+dorInputMap.size());
        System.debug('Creation of License Map');
        // Bulk query to get all related info regarding the Licenses
        if(polarisIds.isEmpty())
            licenceMap = new Map<Id,MUSW__License2__c>();
        else{
            String licenseQuery = 'select Id, MUSW__Primary_Licensee__c,'
                                    +'( select id, Physical__c, Mailing__c, MUSW__License2__c, MUSW__Parcel__c from MUSW__License2_Parcels__r where Physical__c != null OR Mailing__c != null),'
                                    +'( select id from Account_Contacts__r )'
                                    +'from MUSW__License2__c where Id IN :polarisIds';
            licenceMap = new Map<Id,MUSW__License2__c>( (List<MUSW__License2__c>) Database.query(licenseQuery) );
        }
            //licenceMap = new Map<Id,MUSW__License2__c>([ select id, MUSW__Primary_Licensee__c, MUSW__Parcel__c, ( select id from Account_Contacts__r ) from MUSW__License2__c where id IN :polarisIds ]);
        
        // Iterate through the records and get the updated
        // MUSW__License2__c, Account, MUSW__Account_Contact__c, MUSW__Parcel__c
        // calling upsertDORInputs to upsert the record
        System.debug('second for loop reached');
        for(DOL_Integration_Batch_Input__c batchInput : records){
            try{
                tempExistingLicenseRecord = null;
                tempDorInput = dorInputMap.get(batchInput.Id);
                if( tempDorInput != null ){
                    // get the updated records from DOR 
                    tempUpdatedLicense = getUpdatedLicense(tempDorInput);
                    tempUpdatedAccount = getUpdatedAccount(tempDorInput);
                    tempPhysicalParcel = getUpdatedPhysicalParcel(tempDorInput);
                    tempMailingParcel = getUpdatedMailingParcel(tempDorInput);
                    tempUpdatedAccContact = getUpdatedAccountContact(tempDorInput);
                    // get the existing license record
                    if(! String.isBlank(tempDorInput.polarisID))
                        tempExistingLicenseRecord = licenceMap.get(Id.valueOf(tempDorInput.polarisID));
                    // Initiate DOR_sObject and setSobjects and update with sfdcID
                    tempDORsObject = new DOR_sObject();
                    tempDORsObject.setSobjects(tempUpdatedLicense, tempUpdatedAccount, tempUpdatedAccContact, 
                                                tempPhysicalParcel, tempMailingParcel, tempExistingLicenseRecord);
                    tempDORsObject.validateRequiredData();
                    tempDORsObject.updateSFDCIdInRecords();
                    // save records to DB
                    saveSFDCObjects(tempDORsObject);
                    
                    batchInput.INFO__C += 'Successfully Completed';
                    batchInput.Status__c = 'SUCCESSFUL';
                    // Create DOR response and add in List
                    tempDorResponse = new DOR_Response();
                    tempDorResponse.setResponse(tempDorInput,tempDORsObject.license.Id,'SUCCESS');
                    dorResponses.add(tempDorResponse);
                }
                else{
                    batchInput.Status__c = 'FAILED';
                    batchInput.INFO__C += 'Some error occured during parsing';
                }
            }catch(Exception error){
                batchInput.Status__c = 'FAILED';
                batchInput.INFO__c += ' '+'error occured :- '+error.getMessage()+' stack trace '+error.getStackTraceString();
                tempDorResponse = new DOR_Response();
                tempDorResponse.setResponse(tempDorInput,tempDorInput.polarisID,'error occured :- '+error.getMessage()+' stack trace '+error.getStackTraceString());
                dorResponses.add(tempDorResponse);
                DOL_CreateErrorLog_Exception.logApplicationError(error);
            }
        }
        DOL_Dao.save(records);
    }
    
    global void finish(Database.BatchableContext BC){
        try{
            // API call to send DOR result
            if(dorResponses != null && ! dorResponses.isEmpty()){
                Map<String,String> headerMap = new  Map<String,String>();
                headerMap.put('Content-Type','application/json');
                String url = 'callout:DOL_Mule_API/v1/dorUpload';
                //String url = 'https://dol-polaris-exp-dev.us-e2.cloudhub.io/api/v1/dorUpload';
                HttpResponse httpResp = DOL_HTTP_Utility.doHttpRequest(url,
                                                        'POST',
                                                        JSON.serialize(dorResponses),
                                                        null,headerMap);
                System.debug(httpResp.getStatusCode());
                System.debug(httpResp.getBody());
            }
        }
        catch(Exception error){
            System.debug('error occured :- '+error.getMessage()+' stack trace '+error.getStackTraceString());
            DOL_CreateErrorLog_Exception.logApplicationError(error, 'DOL_Process_DOR_Data_Batch', 'finish');
        }
    }
    
    /**
    * method 		: getUpdatedLicense
    * @description 	: Creating the License Object DOL_DOR_Input
    * @author 		: Laltu Banerjee
    * @param dorInput DOR Input
    * @return MUSW__License2__c
    * Date          : 07/08/2019 
    * */

    private MUSW__License2__c getUpdatedLicense(DOL_DOR_Input dorInput){
        updateFound = false;
        MUSW__License2__c license = new MUSW__License2__c();
        if(! String.isBlank(dorInput.dorLicenseStatus)){
            license.MUSW__Status__c = getSalesforceLicenseStatus(dorInput.dorLicenseStatus);
            updateFound = true;
        }   
        if(! String.isBlank(dorInput.dolProfCode)){
            DOR_Professional_Code_Mapping__mdt profCodeMdt = getProfCodeMapMdt(dorInput.dolProfCode);
            license.Profession_Code__c = dorInput.dolProfCode;
            license.Application_Type__c = profCodeMdt.Program__c;
            license.Credential_Type__c = profCodeMdt.License_Type__c;
            updateFound = true;
        }
        if(! String.isBlank(dorInput.dorLicenseFirstIssuanceDate)){
            license.Original_Issue_Date__c =  DOL_AppUtility.getDate(dorInput.dorLicenseFirstIssuanceDate,'YYYYMMDD');
            updateFound = true;
        }
        if(! String.isBlank(dorInput.dorLicenseExpirationDate)){
            license.MUSW__Expiration_Date__c = DOL_AppUtility.getDate(dorInput.dorLicenseExpirationDate,'YYYYMMDD');
            updateFound = true;
        }
        if(! String.isBlank(dorInput.dorLicenseNumber)){
            license.Pre_License_Number__c = dorInput.dorLicenseNumber;
            updateFound = true;
        }
        if(! String.isBlank(dorInput.polarisID)){
            updateFound = true;
        }
        if(updateFound){
             license.RecordTypeId = licenseRecTypeId;
            license.Name = 'System Number';
            return license;
        }
       return null;
    }

    /**
    * method 		: getProfCodeMapMdt
    * @description 	: get DOR_Professional_Code_Mapping__mdt by Professional_Code__c value
    * @author 		: Laltu Banerjee
    * @param profCode Input from DOR File
    * @return DOR_Professional_Code_Mapping__mdt, Throw error in case of input prof code not matching or Blank.
    * Date          : 07/10/2019 
    * */

    private DOR_Professional_Code_Mapping__mdt getProfCodeMapMdt(String profCode){
        if(! String.isBlank(profCode)){
            for(DOR_Professional_Code_Mapping__mdt profCodeMetadata : profCodeMappingMdt ){
                if( profCode == profCodeMetadata.Professional_Code__c ){
                    return profCodeMetadata;
                }
            }
        }
        throw new CustomException('Prof Code '+profCode+' is empty or not found in DOR_Professional_Code_Mapping__mdt');
    }

    /**
    * method 		: getSalesforceLicenseStatus
    * @description 	: get Salesforce License Status by Dor License Status
    * @author 		: Laltu Banerjee
    * @param dorLicenseStatus Input from DOR File
    * @return Salesforce license status, null in case of dor license status is not matching
    * Date          : 07/10/2019 
    * */

    private String getSalesforceLicenseStatus(String dorLicenseStatus){
        System.debug('Input licence status = '+dorLicenseStatus);
        if(! String.isBlank(dorLicenseStatus)){
            for(DOR_License_Status_Mapping__mdt licenseStatusMdt : dorLicenseStatusMdt ){
                if( dorLicenseStatus == licenseStatusMdt.DOR_License_Status__c)
                    return licenseStatusMdt.Salesforce_License_Status__c;
            }
        }
        throw new CustomException('Input DOR license status '+dorLicenseStatus+' is not matching with DOR_License_Status_Mapping__mdt');
    }
    
    /**
    * method 		: getUpdatedAccount
    * @description 	: Creation of Account Object from DOL_DOR_Input
    * @author 		: Laltu Banerjee
    * @param dorInput DOR Input
    * @return Account object
    * Date          : 07/08/2019 
    * */

    private Account getUpdatedAccount(DOL_DOR_Input dorInput){
        updateFound = false;
        Account acc = new Account();
        if(! String.isBlank(dorInput.dorLicenseUBI)){
            acc.UBI_Number__c = dorInput.dorLicenseUBI;
            updateFound = true;
        }	
        if(! String.isBlank(dorInput.dorLicenseBusID) && DOL_AppUtility.isValidDecimalValue(dorInput.dorLicenseBusID)){
            acc.Bus_Id__c = String.valueOf(dorInput.dorLicenseBusID);
            updateFound = true;
        }
        if(! String.isBlank(dorInput.dorLicenseLocID) && DOL_AppUtility.isValidDecimalValue(dorInput.dorLicenseLocID)){
            acc.Loc_Id__c = String.valueOf(dorInput.dorLicenseLocID);
            updateFound = true;
        }	
        if(! String.isBlank(dorInput.dorBusinessType)){
            acc.Business_Structure__c = dorInput.dorBusinessType;
            updateFound = true;
        }
        if(! String.isBlank(dorInput.dorEntityName)){
            acc.Name = dorInput.dorEntityName;
            updateFound = true;
        } 
        if(! String.isBlank(dorInput.dorBusinessName)){
            acc.Business_Name__c = dorInput.dorBusinessName;
            updateFound = true;
        }   
        if(! String.isBlank(dorInput.dorOwnerFirstName)){
            acc.First_Name_Primary_Contact__c = dorInput.dorOwnerFirstName;
            updateFound = true;
        }   
        if(! String.isBlank(dorInput.dorOwnerLastName)){
            acc.Last_Name_Primary_Contact__c = dorInput.dorOwnerLastName;
            updateFound = true;
        }   
        if(! String.isBlank(dorInput.dorTradeName)){
            acc.DBA_Name__c = dorInput.dorTradeName;
            updateFound = true;
        }
        if(updateFound){
            acc.RecordTypeId = accountRecTypeId;
            return acc;
        }
        return null;
    }

    /**
    * method 		: getUpdatedAccountContact
    * @description 	: Creation of MUSW__Account_Contact__c Object from DOL_DOR_Input
    * @author 		: Laltu Banerjee
    * @param dorInput DOR Input
    * @return MUSW__Account_Contact__c object
    * Date          : 07/08/2019 
    * */

    private MUSW__Account_Contact__c getUpdatedAccountContact(DOL_DOR_Input dorInput){
        MUSW__Account_Contact__c accContact = new MUSW__Account_Contact__c();
        updateFound = false;
        if(! String.isBlank(dorInput.dorGovPerFirstName)){
            accContact.First_Name__c = dorInput.dorGovPerFirstName;
            updateFound = true;
        }
        if(! String.isBlank(dorInput.dorGovPerLastName)){
            accContact.Last_Name__c = dorInput.dorGovPerLastName;
            updateFound = true;
        }
        if(! String.isBlank(dorInput.dorGovPerMiddleName)){
            accContact.Middle_Name__c = dorInput.dorGovPerMiddleName;
            updateFound = true;
        }
        if(updateFound){
            accContact.RecordTypeId = accConRecTypeId;
            return accContact;
        }
        return null;
    }

    /**
    * method 		: getUpdatedParcel
    * @description 	: Creation of MUSW__Parcel__c Object from DOL_DOR_Input
    * @author 		: Laltu Banerjee
    * @param dorInput DOR Input
    * @return MUSW__Parcel__c object
    * Date          : 07/08/2019 
    * */

    private MUSW__Parcel__c getUpdatedPhysicalParcel(DOL_DOR_Input dorInput){
        MUSW__Parcel__c parcel = new MUSW__Parcel__c();
        updateFound = false;
        if(! String.isBlank(dorInput.dorLocPhysicalAddr1)){
            if(dorInput.dorLocPhysicalAddr1.length() > 15) 
                parcel.MUSW__Street_Number__c = dorInput.dorLocPhysicalAddr1.substring(0,14);
            else
                parcel.MUSW__Street_Number__c = dorInput.dorLocPhysicalAddr1;
            updateFound = true;
        }
        if(! String.isBlank(dorInput.dorLocPhysicalAddr2)){
            parcel.MUSW__Street2__c = dorInput.dorLocPhysicalAddr2;
            updateFound = true;
        }  
        if(! String.isBlank(dorInput.dorLocPhysicalCity)){
            parcel.MUSW__City__c = dorInput.dorLocPhysicalCity;
            updateFound = true;
        }
        if(! String.isBlank(dorInput.dorLocPhysicalState)){
            parcel.MUSW__State__c = dorInput.dorLocPhysicalState;
            updateFound = true;
        }
       if(! String.isBlank(dorInput.dorLocPhysicalZip)){
           parcel.MUSW__Post_Zip_Code__c = dorInput.dorLocPhysicalZip;
           updateFound = true;
       }
       if(updateFound){
            parcel.RecordTypeId = parcelRecTypeId;
            return parcel;
        }
        return null;
    }

    private MUSW__Parcel__c getUpdatedMailingParcel(DOL_DOR_Input dorInput){
        MUSW__Parcel__c parcel = new MUSW__Parcel__c();
        updateFound = false;
        if(! String.isBlank(dorInput.dorLocMailAddr1)){
            if(dorInput.dorLocMailAddr1.length() > 15) 
                parcel.MUSW__Street_Number__c = dorInput.dorLocMailAddr1.substring(0,14);
            else
                parcel.MUSW__Street_Number__c = dorInput.dorLocMailAddr1;
            updateFound = true;
        }
        if(! String.isBlank(dorInput.dorLocMailAddr2)){
            parcel.MUSW__Street2__c = dorInput.dorLocMailAddr2;
            updateFound = true;
        }
        if(! String.isBlank(dorInput.dorLocMailCity)){
            parcel.MUSW__City__c = dorInput.dorLocMailCity;
            updateFound = true;
        }
        if(! String.isBlank(dorInput.dorLocMailState)){
            parcel.MUSW__State__c = dorInput.dorLocMailState;
            updateFound = true;
        } 
        if(! String.isBlank(dorInput.dorLocMailZip)){
            parcel.MUSW__Post_Zip_Code__c = dorInput.dorLocMailZip;
            updateFound = true;
        }
        if(updateFound){
            parcel.RecordTypeId = parcelRecTypeId;
            return parcel;
        }
        return null;
    }

    class DOR_sObject{
        MUSW__License2__c license;
        Account acc;
        MUSW__Parcel__c physicalParcel;
        MUSW__Parcel__c mailParcel;
        MUSW__License2__c existingLicenseRecord;
        MUSW__Account_Contact__c accContact;

        public void setSobjects(MUSW__License2__c license, Account acc,
                                MUSW__Account_Contact__c accContact,MUSW__Parcel__c physicalParcel, 
                                MUSW__Parcel__c mailParcel, MUSW__License2__c existingLicenseRecord ){
            this.license = license;
            this.acc = acc;
            this.physicalParcel = physicalParcel;
            this.mailParcel = mailParcel;
            this.existingLicenseRecord = existingLicenseRecord;
            this.accContact = accContact;
        }

        public void validateRequiredData(){
            if(license == null)
                throw new CustomException('License Data not found, so not able to process the record');
        }

        public void updateSFDCIdInRecords(){
            if(existingLicenseRecord != null ){
                if( license != null )
                    license.Id = existingLicenseRecord.Id;
                if( acc != null )
                    acc.Id = existingLicenseRecord.MUSW__Primary_Licensee__c;
                if(accContact != null){
                    List<MUSW__Account_Contact__c> accContactList = existingLicenseRecord.Account_Contacts__r;
                    if(accContactList != null && !accContactList.isEmpty())
                        accContact.Id = accContactList.get(0).Id;
                }
                List<MUSW__License_Parcel__c> licenseParcelRecords = existingLicenseRecord.MUSW__License2_Parcels__r;
                if( licenseParcelRecords != null && ! licenseParcelRecords.isEmpty() ){
                    for( MUSW__License_Parcel__c licenseParcel : licenseParcelRecords ){
                        if( licenseParcel.Physical__c && physicalParcel != null ){
                            physicalParcel.Id = licenseParcel.MUSW__Parcel__c;
                        }else if( licenseParcel.Mailing__c && mailParcel != null ){
                            mailParcel.Id = licenseParcel.MUSW__Parcel__c;
                        }
                    }
                }
            }
        }

        public List<MUSW__Parcel__c> getParcels(){
            List<MUSW__Parcel__c> parcelList = new List<MUSW__Parcel__c>();
            if(physicalParcel != null)
                parcelList.add(physicalParcel);
            if( mailParcel != null )
                parcelList.add(mailParcel);
            return parcelList;
        }

        public List<MUSW__License_Parcel__c> getLicenseParcelRecordForUpdate(){
            List<MUSW__License_Parcel__c> licenseParcelForInsert = new List<MUSW__License_Parcel__c>();
            MUSW__License_Parcel__c tempLicenseParcel;
            Boolean physicalLicParcelExist = false;
            Boolean mailingLicParcelExist = false;
            if(existingLicenseRecord != null ){
                List<MUSW__License_Parcel__c> licenseParcelRecords = existingLicenseRecord.MUSW__License2_Parcels__r;
                if( licenseParcelRecords != null && ! licenseParcelRecords.isEmpty() ){
                    for( MUSW__License_Parcel__c licenseParcel : licenseParcelRecords ){
                        if( licenseParcel.Physical__c )
                            physicalLicParcelExist = true;
                        else if( licenseParcel.Mailing__c )
                            mailingLicParcelExist = true;
                    }
                }
            }
            if( !physicalLicParcelExist ){
                if(license != null && physicalParcel != null ){
                    tempLicenseParcel = new MUSW__License_Parcel__c();
                    tempLicenseParcel.Physical__c = true;
                    tempLicenseParcel.Mailing__c = false;
                    tempLicenseParcel.MUSW__License2__c = license.Id;
                    tempLicenseParcel.MUSW__Parcel__c = physicalParcel.Id;
                    licenseParcelForInsert.add(tempLicenseParcel);
                }
            }
            if( !mailingLicParcelExist ){
                if(license != null && mailParcel != null ){
                    tempLicenseParcel = new MUSW__License_Parcel__c();
                    tempLicenseParcel.Physical__c = false;
                    tempLicenseParcel.Mailing__c = true;
                    tempLicenseParcel.MUSW__License2__c = license.Id;
                    tempLicenseParcel.MUSW__Parcel__c = mailParcel.Id;
                    licenseParcelForInsert.add(tempLicenseParcel);
                }
            }
            return licenseParcelForInsert;
        }
    }

    /**
    * method 		: saveSFDCObjects
    * @description 	: Upsert license, account, accContact and parcel object
    * @author 		: Laltu Banerjee
    * @param license updated License object, acc update account object, 
    *         accContact update accountContact object, parcel updated parcel object
    * @return void
    * Date          : 07/19/2019 
    * */

    private void saveSFDCObjects(DOR_sObject dorSObject){
        Savepoint sp;
        try{
            sp = Database.setSavepoint();
            if(dorSObject.acc != null )
                upsert dorSObject.acc;
            if(dorSObject.license != null){
                if( dorSObject.acc != null )
                    dorSObject.license.MUSW__Primary_Licensee__c = dorSObject.acc.Id;
                upsert dorSObject.license;
            }
            if(dorSObject.accContact != null){
                if(dorSObject.acc != null )
                    dorSObject.accContact.MUSW__Account__c = dorSObject.acc.Id;
                if(dorSObject.license != null)
                    dorSObject.accContact.License__c = dorSObject.license.Id;
                upsert dorSObject.accContact;
            }
            List<MUSW__Parcel__c> parcelList = dorSObject.getParcels();
            if( !parcelList.isEmpty()){
                upsert parcelList;
                List<MUSW__License_Parcel__c> licenseParcels = dorSObject.getLicenseParcelRecordForUpdate();
                if( !licenseParcels.isEmpty())
                    upsert licenseParcels;
            }
                
        }catch(Exception error){
            if(sp != null) 
                Database.rollback(sp);
            throw new CustomException('error occured '+error.getMessage()+' stackTrace '+error.getStackTraceString());
        }
    }

    
    
    class DOR_Response{
        String polarisID;
        String dorLicenseFullUBI;
        String dorLicenseUBI;
        String dorLicenseBusID;
        String dorLicenseLocID;
        String dorReponseSuccFail;
        String dorLicenseCode;

        public void setResponse(DOL_DOR_Input dorInput, 
                                String pId, 
                                String successFailMsg ){
            polarisID = pId;
            dorLicenseFullUBI = dorInput.dorLicenseFullUBI;
            dorLicenseUBI = dorInput.dorLicenseUBI;
            dorLicenseBusID = dorInput.dorLicenseBusID;
            dorLicenseLocID = dorInput.dorLicenseLocID;
            dorLicenseCode = dorInput.dorLicenseCode;
            dorReponseSuccFail = successFailMsg;
        }

    }
    
}