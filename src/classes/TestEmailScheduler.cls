public class TestEmailScheduler {
    
    public static String emailId  = DOL_AppConstants.NULL_EMPTY_STRING + 'abhilassharma@deloitte.com';
    public static Id fineId = DOL_AppConstants.NULL_EMPTY_STRING + 'a0Rr0000002mRjbEAE';
    public static Id conId = DOL_AppConstants.NULL_EMPTY_STRING + '003r000000FD2HKAA1';
    
    public static void sendEmail(){
        Map<Id,Id> contentDocumentLinkToLicenseMap = new Map<Id,Id>();
        Map<Id,Id> licenseToContentVersionMap = new Map<Id,Id>();
        Map<Id,MUSW__License2__c> licenseWithDhp = new Map<Id,MUSW__License2__c>([Select id, Account_Email__c,MUSW__Total_Balance__c,NoEmail__c from MUSW__License2__c where MUSW__Total_Balance__c >0 and NoEmail__c = false and Sub_Status__c =: DOL_AppConstants.NULL_EMPTY_STRING + 'DHP']);
        Set<Id> licenseKeySet = licenseWithDhp.keySet();
        //List<ContentDocumentLink> cdLinkList = [SELECT ContentDocument.title,ContentDocumentId,LinkedEntityId FROM ContentDocumentLink WHERE LinkedEntityId In: licenseKeySet and ContentDocument.title like 'DHP%' ];
        for(ContentDocumentLink clink: [SELECT ContentDocument.title,ContentDocumentId,LinkedEntityId FROM ContentDocumentLink WHERE LinkedEntityId In: licenseKeySet and ContentDocument.title like 'DHP%' ] ){
            contentDocumentLinkToLicenseMap.put(clink.ContentDocumentId,clink.LinkedEntityId);
        }
        Set<Id> keySet = contentDocumentLinkToLicenseMap.keySet();
        //List<ContentVersion> cvList = [Select Id,Title, ContentDocumentId from ContentVersion where ContentDocumentId In:keySet ];
        for(ContentVersion cv: [Select Id,Title, ContentDocumentId from ContentVersion where ContentDocumentId In:keySet ] ){
            if(contentDocumentLinkToLicenseMap.containsKey(cv.ContentDocumentId)){
                licenseToContentVersionMap.put(contentDocumentLinkToLicenseMap.get(cv.ContentDocumentId),cv.Id);
            }
        }
        
        List<Messaging.SingleEmailMessage> emailList = new list<Messaging.SingleEmailMessage>();
        for(MUSW__License2__c lic: licenseWithDhp.values()){
            if(licenseToContentVersionMap.containsKey(lic.Id)){
                Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
                message.setToAddresses(new String[]{lic.Account_Email__c});
                message.setSubject('DHP Reminder');
                message.setEntityAttachments(new List<Id>{licenseToContentVersionMap.get(lic.Id)});
                message.setPlainTextBody('Please find attached a copy of your DHP letter');
                emailList.add(message);
            }
        }
        
    //    system.debug('emailList::'+emailList);
        if(emailList.size() > 0){
            Messaging.SendEmailResult[] results = Messaging.sendEmail(emailList);
        }
    }
    
    
}