global class batchSendLicenseCertification implements Database.Batchable<sObject> {
 global Database.QueryLocator start(Database.BatchableContext BC) {
        String query = DOL_AppConstants.NULL_EMPTY_STRING + 'Select id, MUSW__Applicant__r.Email,Print_License_Email__c,MUSW__Total_Balance__c from MUSW__License2__c where Print_License_Email__c=\'Yes\' AND MUSW__Status__c=\'Active\' AND MUSW__Applicant__r.Email!=\'\'';       
        system.debug('query :'+query );
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<MUSW__License2__c> scope) {
    system.debug('scope :'+scope);
        Map<Id,Id> contentDocumentLinkToLicenseMap = new Map<Id,Id>();
        Map<Id,Id> licenseToContentVersionMap = new Map<Id,Id>();
        Set<Id> licenseSet = new Set<Id>();
        for(MUSW__License2__c lic: scope){
            licenseSet.add(lic.Id);
        }

        List<ContentDocumentLink> cdLinkList = [SELECT ContentDocument.title,ContentDocumentId,LinkedEntityId FROM ContentDocumentLink WHERE LinkedEntityId In: licenseSet and ContentDocument.title like 'License%' ];
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
        for(MUSW__License2__c lic: scope){
            if(licenseToContentVersionMap.containsKey(lic.Id)){
                Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
                message.setToAddresses(new String[]{lic.MUSW__Applicant__r.Email});
                message.setSubject(DOL_AppConstants.sSubjectLine);
                message.setEntityAttachments(new List<Id>{licenseToContentVersionMap.get(lic.Id)});
                message.setPlainTextBody(DOL_AppConstants.sMailBody);
                emailList.add(message);                
            }
            lic.Print_License_Email__c= DOL_AppConstants.NULL_EMPTY_STRING + 'Completed';
        }
        if(!scope.isEmpty())
        {
            update scope;
        }
        system.debug('emailList::'+emailList);
        if(emailList.size() > 0){
            Messaging.SendEmailResult[] results = Messaging.sendEmail(emailList);
        }
    }
    
    global void finish(Database.BatchableContext BC) {
    }
}