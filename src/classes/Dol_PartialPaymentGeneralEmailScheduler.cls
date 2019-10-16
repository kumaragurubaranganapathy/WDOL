global class Dol_PartialPaymentGeneralEmailScheduler implements Schedulable {
    global void execute(SchedulableContext ctx){
        Map<Id,Id> contentDocumentLinkToInvoiceMap = new Map<Id,Id>();
        Map<Id,Id> invoiceToContentVersionMap = new Map<Id,Id>();
        Map<Id,Id> invoiceToAttachmentMap = new Map<Id,Id>();
        Set<Id> invIdSet = new Set<Id>();
        List<BGBK__Bill__c> invoiceList = [Select id,BGBK__Recipient2__c,BGBK__Recipient2__r.Email__c from BGBK__Bill__c where CreatedDate = Yesterday and BGBK__Recipient2__r.Email__c != null];
        //System.debug('invoiceList::'+invoiceList);
        for(BGBK__Bill__c inv : invoiceList){
            invIdSet.add(inv.Id);
        }
        //System.debug('invIdSet::'+invIdSet);
        for(ContentDocumentLink clink: [SELECT ContentDocument.title,ContentDocumentId,LinkedEntityId FROM ContentDocumentLink WHERE LinkedEntityId In: invIdSet and ContentDocument.title like 'Partial_Payment%' ] ){
            contentDocumentLinkToInvoiceMap.put(clink.ContentDocumentId,clink.LinkedEntityId);
        }
        Set<Id> keySet = contentDocumentLinkToInvoiceMap.keySet();
        for(ContentVersion cv: [Select Id,Title, ContentDocumentId from ContentVersion where ContentDocumentId In: keySet ] ){
            if(contentDocumentLinkToInvoiceMap.containsKey(cv.ContentDocumentId)){
                invoiceToContentVersionMap.put(contentDocumentLinkToInvoiceMap.get(cv.ContentDocumentId),cv.Id);
            }
        }
        
        List<Messaging.SingleEmailMessage> emailList = new list<Messaging.SingleEmailMessage>();
        for(BGBK__Bill__c inv: invoiceList){
            if(invoiceToContentVersionMap.containsKey(inv.Id)){
                Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
                message.setToAddresses(new String[]{inv.BGBK__Recipient2__r.Email__c});
                message.setSubject('Dept of Licensing – Partial Payment Reminder');
                message.setEntityAttachments(new List<Id>{invoiceToContentVersionMap.get(inv.Id)});
                message.setPlainTextBody('Please find attached a copy of your partial payment letter');
                emailList.add(message);
            }
        }
        
        
        //System.debug('emailList::'+emailList);
        if(emailList.size() > 0){
            Messaging.SendEmailResult[] results = Messaging.sendEmail(emailList);
        }
    }
}