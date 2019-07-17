global class DhpReminderEmailScheduler implements Schedulable {
    global void execute(SchedulableContext ctx){
        Map<Id,Id> contentDocumentLinkToLicenseMap = new Map<Id,Id>();
        Map<Id,Id> licenseToContentVersionMap = new Map<Id,Id>();
        Set<Id> licenseIdSet = new Set<Id>();
        List<MUSW__Fee__c> DHPFeeList = [Select id,MUSW__License2__c,MUSW__Outstanding_Fee__c,Days_since_created__c from MUSW__Fee__c where MUSW__Type__c = 'DHP' and MUSW__Outstanding_Fee__c > 0 and (Days_since_created__c = 60)];
        for(MUSW__Fee__c fee: DHPFeeList){
            licenseIdSet.add(fee.MUSW__License2__c);
        }
        List<MUSW__License2__c> licenseWithDhp = [Select id, Account_Email__c,MUSW__Total_Balance__c,NoEmail__c from MUSW__License2__c where MUSW__Total_Balance__c >0 and NoEmail__c = false and Sub_Status__c = 'DHP' and Id In: licenseIdSet];
        List<ContentDocumentLink> cdLinkList = [SELECT ContentDocument.title,ContentDocumentId,LinkedEntityId FROM ContentDocumentLink WHERE LinkedEntityId In: licenseWithDhp and ContentDocument.title like 'DHP%' ];
        for(ContentDocumentLink clink: cdLinkList ){
            contentDocumentLinkToLicenseMap.put(clink.ContentDocumentId,clink.LinkedEntityId);
        }
        Set<Id> keySet = contentDocumentLinkToLicenseMap.keySet();
        List<ContentVersion> cvList = [Select Id,Title, ContentDocumentId from ContentVersion where ContentDocumentId In: keySet ];
        for(ContentVersion cv: cvList ){
            if(contentDocumentLinkToLicenseMap.containsKey(cv.ContentDocumentId)){
                licenseToContentVersionMap.put(contentDocumentLinkToLicenseMap.get(cv.ContentDocumentId),cv.Id);
            }
        }
        
        List<Messaging.SingleEmailMessage> emailList = new list<Messaging.SingleEmailMessage>();
        for(MUSW__License2__c lic: licenseWithDhp){
            if(licenseToContentVersionMap.containsKey(lic.Id)){
                Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
                message.setToAddresses(new String[]{lic.Account_Email__c});
                message.setSubject('Dept of Licensing – Dishonored Payment Reminder');
                message.setEntityAttachments(new List<Id>{licenseToContentVersionMap.get(lic.Id)});
                message.setPlainTextBody('Please find attached a copy of your DHP letter');
                emailList.add(message);
            }
        }
        
        system.debug('emailList::'+emailList);
        if(emailList.size() > 0){
            Messaging.SendEmailResult[] results = Messaging.sendEmail(emailList);
        }
    }
}