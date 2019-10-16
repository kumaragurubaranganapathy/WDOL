global class DhpReminderEmailScheduler implements Schedulable {
    global void execute(SchedulableContext ctx){
        Map<Id,Id> contentDocumentLinkToLicenseMap = new Map<Id,Id>();
        Map<Id,Id> licenseToContentVersionMap = new Map<Id,Id>();
        Set<Id> licenseIdSet = new Set<Id>();
        //List<MUSW__Fee__c> DHPFeeList = [Select id,MUSW__License2__c,MUSW__Outstanding_Fee__c,Days_since_created__c from MUSW__Fee__c where MUSW__Type__c = 'DHP' and MUSW__Outstanding_Fee__c > 0 and (Days_since_created__c = 60)];
        for(MUSW__Fee__c fee: [Select id,MUSW__License2__c,MUSW__Outstanding_Fee__c,Days_since_created__c from MUSW__Fee__c where MUSW__Type__c = 'DHP' and MUSW__Outstanding_Fee__c > 0 and (Days_since_created__c = 60)]){
            licenseIdSet.add(fee.MUSW__License2__c);
        }
        List<MUSW__License2__c> licenseWithDhp = [Select id, Account_Email__c,MUSW__Total_Balance__c,NoEmail__c from MUSW__License2__c where MUSW__Total_Balance__c >0 and NoEmail__c = false and Polaris_DHP__c = true and Id In: licenseIdSet];
        Set<Id> licenseWithDhpSet = new Set<Id>();
        for(MUSW__License2__c lic: [Select id, Account_Email__c,MUSW__Total_Balance__c,NoEmail__c from MUSW__License2__c where MUSW__Total_Balance__c >0 and NoEmail__c = false and Polaris_DHP__c = true and Id In: licenseIdSet]){
            licenseWithDhpSet.add(lic.Id);
        }

        //List<ContentDocumentLink> cdLinkList = [SELECT ContentDocument.title,ContentDocumentId,LinkedEntityId FROM ContentDocumentLink WHERE LinkedEntityId In: licenseWithDhpSet and ContentDocument.title like 'DHP%' ];
        for(ContentDocumentLink clink: [SELECT ContentDocument.title,ContentDocumentId,LinkedEntityId FROM ContentDocumentLink WHERE LinkedEntityId In: licenseWithDhpSet and ContentDocument.title like 'Dishonored%' ] ){
            contentDocumentLinkToLicenseMap.put(clink.ContentDocumentId,clink.LinkedEntityId);
        }
        Set<Id> keySet = contentDocumentLinkToLicenseMap.keySet();
        //List<ContentVersion> cvList = [Select Id,Title, ContentDocumentId from ContentVersion where ContentDocumentId In: keySet ];
        for(ContentVersion cv: [Select Id,Title, ContentDocumentId from ContentVersion where ContentDocumentId In: keySet ] ){
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
        
        //System.debug('emailList::'+emailList);
        if(emailList.size() > 0){
            Messaging.SendEmailResult[] results = Messaging.sendEmail(emailList);
        }
    }
}