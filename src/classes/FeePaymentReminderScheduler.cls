global class FeePaymentReminderScheduler implements Schedulable {
    global void execute(SchedulableContext ctx) {
        List<MUSW__Fee__c> fineCollectionNoticeList = new List<MUSW__Fee__c>();
        List<MUSW__Fee__c> finePaymentNoticeList = new List<MUSW__Fee__c>();
        List<MUSW__Fee__c> fineList = [Select id,MUSW__License2__r.name,MUSW__Amount__c,MUSW__Outstanding_Fee__c,Days_since_created__c,Licensee_Email__c from MUSW__Fee__c where MUSW__Type__c = 'Fine' and MUSW__Outstanding_Fee__c > 0 and (Days_since_created__c = 44 OR Days_since_created__c = 61)];
        Set<ID> finePaymentIdSet = new Set<Id>();
        Set<ID> fineCollectionIdSet = new Set<Id>();
        if(fineList.size()>0){
            for(MUSW__Fee__c fee: fineList){
                if(fee.Days_since_created__c == 44){
                    finePaymentNoticeList.add(fee);
                    finePaymentIdSet.add(fee.id);
                }else if(fee.Days_since_created__c == 61){
                    fineCollectionNoticeList.add(fee);
                    fineCollectionIdSet.add(fee.Id);
                }
            }
        }
        if(finePaymentNoticeList.size()>0){
            List<ContentDocumentLink> clinkListForPaymentReminder = [SELECT ContentDocument.title,ContentDocumentId,LinkedEntityId FROM ContentDocumentLink WHERE LinkedEntityId In: finePaymentIdSet and ContentDocument.title like '%Fine_Payment_Reminder%' ];
            String sub= 'Fine Payment Past Due';
            sendPaymentReminder(finePaymentNoticeList,clinkListForPaymentReminder,sub);
        }
        if(fineCollectionNoticeList.size()>0){
            List<ContentDocumentLink> clinkListForCollectionReminder = [SELECT ContentDocument.title,ContentDocumentId,LinkedEntityId FROM ContentDocumentLink WHERE LinkedEntityId In: fineCollectionIdSet and ContentDocument.title like '%Fine_Collection_Reminder%' ];
            String sub= 'Notice of Collections';
            sendPaymentReminder(fineCollectionNoticeList,clinkListForCollectionReminder,sub);
        }
    }
    private void sendPaymentReminder(List<MUSW__Fee__c> finePaymentNoticeList,List<ContentDocumentLink> clinkList,String subLine){
        Map<Id,Id> contentDocumentLinkToFeeMap = new Map<Id,Id>();
        Map<Id,Id> feeToContentVersionMap = new Map<Id,Id>();
        if(clinkList.size()>0){
            for(ContentDocumentLink clink: clinkList ){
                contentDocumentLinkToFeeMap.put(clink.ContentDocumentId,clink.LinkedEntityId);
            }
            Set<Id> keySet = contentDocumentLinkToFeeMap.keySet();
            List<ContentVersion> cvList = [Select Id,Title, ContentDocumentId from ContentVersion where ContentDocumentId In: keySet];
            for(ContentVersion cv: cvList ){
                if(contentDocumentLinkToFeeMap.containsKey(cv.ContentDocumentId)){
                    feeToContentVersionMap.put(contentDocumentLinkToFeeMap.get(cv.ContentDocumentId),cv.Id);
                }
            }
            
            List<Messaging.SingleEmailMessage> emailList = new list<Messaging.SingleEmailMessage>();
            for(MUSW__Fee__c fine: finePaymentNoticeList){
                if(fine.Licensee_Email__c != null && feeToContentVersionMap.containsKey(fine.Id)){
                    Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
                    message.setToAddresses(new String[]{fine.Licensee_Email__c});
                    String sub = 'Final Order for Case # ['+fine.MUSW__License2__r.name+'] – '+ subLine;
                    message.setSubject(sub);
                    message.setEntityAttachments(new List<Id>{feeToContentVersionMap.get(fine.Id)});
                    String bdy = 'Please find attached a copy of '+subLine+' letter';
                    message.setPlainTextBody(bdy);
                    emailList.add(message);
                }
            }
            
            system.debug('emailList::'+emailList);
            if(emailList.size() > 0){
                Messaging.SendEmailResult[] results = Messaging.sendEmail(emailList);
            }
        }
        
    }
}