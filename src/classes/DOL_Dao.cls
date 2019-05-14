public class DOL_Dao {

    public Contact getContactDetailsForSessionTransfer(Id contactId){
        Contact outputContact = [ select lastName, firstName, mailingstreet, mailingcity, mailingstate, mailingcountry , email, MobilePhone, MailingPostalCode from contact where id =: contactId];
        return outputContact;
    }

    public MUSW__Receipt__c getReceiptForCartPage(String receiptId){
        MUSW__Receipt__c receipt = [select id,MUSW__Payment_Method__c,MUSW__Paid_By__c,MUSW__Receipt_Paid_by__c,BGBK__Cart__c,MUSW__Amount_Tendered__c from MUSW__Receipt__c where id =: receiptId];
        return receipt;
    }

    public static Id save(Sobject input){
        Database.SaveResult result = Database.insert(input,false);
        if(result.isSuccess()){
            return result.getId();
        }
        else{
            return null;
        }
    }

    public static List<Id> save(List<Sobject> inputList){
        List<Id> saveIds = new List<String>();
        Database.SaveResult[] result = Database.insert(inputList,false);
        for(Database.SaveResult sr : result){
            if(sr.isSuccess()){
               saveIds.add(sr.getId());
            }
            else{
                
            }
        }
        return saveIds;
    }

}