/************************************************************************************************************
** Name             : DOL_Dao
** Description   	: Data access class, Dol database operations.
** Version          : 1.0
**-------------------------------------
** Revision History:
**---------------------------
** [Laltu Banerjee]: Created
*************************************************************************************************************/
public with sharing class DOL_Dao {

    public Contact getContactDetailsForSessionTransfer(Id contactId){
        Contact outputContact = [ select lastName, firstName, mailingstreet, mailingcity, mailingstate, mailingcountry , email, MobilePhone, MailingPostalCode from contact where id =: contactId];
        return outputContact;
    }

    public MUSW__Receipt__c getReceiptForCartPage(String receiptId){
        MUSW__Receipt__c receipt = [select id,MUSW__Payment_Method__c,MUSW__Paid_By__c,MUSW__Receipt_Paid_by__c,BGBK__Cart__c,MUSW__Amount_Tendered__c from MUSW__Receipt__c where id =: receiptId];
        return receipt;
    }

    public MUSW__Receipt__c getReceiptByTransactionId(String paymentTransactionId){
        List<MUSW__Receipt__c> receipt = [select id from MUSW__Receipt__c where MUSW__Payment_Gateway_Transaction_Number__c =: paymentTransactionId ];
        if(receipt != null && receipt.size() > 0)
            return receipt.get(0);
        return null;
    }
    

    public List<MUSW__Fee__c> getFeeAndFeePayment(List<String> feeIds){
        List<MUSW__Fee__c> fees = [select id, ( select id from MUSW__Payments__r ) from MUSW__Fee__c where id in :feeIds];
        return fees;
    }

    public MUSW__License2__c getLicenseAndRenewalRecordByLicenseId(String licenseId){
        MUSW__License2__c license = [SELECT id, RecordType.Name, Is_Renewal_Eligible__c, MUSW__Applicant__c, Application_Type__c, Phone__c, Credential_Type__c, MUSW__Primary_Licensee__c, ( select id, Renewal_Reinstatement_Type__c, Renewal_Status__c from Renewal_Applications__r ) FROM MUSW__License2__c WHERE Id =: licenseId];
        return license;
    }

    public MUSW__License2__c getLicenseRecordById(String licenseId){
        MUSW__License2__c license = [ Select id, Is_Renewal_Eligible__c, MUSW__Applicant__c, Application_Type__c, Phone__c, Credential_Type__c, MUSW__Primary_Licensee__c From MUSW__License2__c where Id =: licenseId ];
        return license;
    }

    public Renewal_Application__c getRenewalApplicationAndFees(String renewalAppId){
        Renewal_Application__c renewalApp = [ Select Id,License__c,Applicant__c,Licensee__c, ( select Id, BGBK__Cart__c from Fees__r ) from Renewal_Application__c where id =: renewalAppId ];
        return renewalApp;
    }

    public List<License_Type__mdt> getLicenseTypeMetadataByApplicationType(String appType){
        List<License_Type__mdt> licenceTypeMetadata = [ Select Application_Type__c, IndividualBusinessType__c from License_Type__mdt where Application_Type__c =: appType ];
        return licenceTypeMetadata;
    }

    public static Id save(Sobject input){
        Database.UpsertResult result = Database.upsert(input,false);
        if(result.isSuccess()){
            return result.getId();
        }
        else{
            System.debug(result.getErrors());
            return null;
        }
    }


    public static List<Id> save(List<Sobject> inputList){
        HTTPRestResponse response = HTTPRestResponse.getInstance();
        List<Id> saveIds = new List<String>();
        Database.UpsertResult[] result = Database.upsert(inputList,false);
        for(Database.UpsertResult sr : result){
            if(sr.isSuccess()){
               saveIds.add(sr.getId());
            }
            else{
                System.debug(sr.getErrors());
                response.addLog(sr.getErrors());
            }
        }
        return saveIds;
    }

}