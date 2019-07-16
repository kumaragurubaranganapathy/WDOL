global class DhpReminderEmailScheduler implements Schedulable {
    global void execute(SchedulableContext ctx) {
        Map<Id,List<Id>> licenseToAttachmentIdMap = new Map<Id,List<Id>>();
        List<MUSW__License2__c> licensesWithEmail = [Select id, Account_Email__c, Bad_Check__c,NoEmail__c from MUSW__License2__c where Bad_Check__c = true and NoEmail__c = false];
        system.debug('licensesWithEmail::'+licensesWithEmail);
        for(Attachment att : [Select id,ParentId from Attachment where ParentId in:licensesWithEmail]){
            if(licenseToAttachmentIdMap.containsKey(att.ParentId)){
                licenseToAttachmentIdMap.get(att.ParentId).add(att.Id);
            }else{
                licenseToAttachmentIdMap.put(att.ParentId, new List<Id>());
                licenseToAttachmentIdMap.get(att.ParentId).add(att.Id);
            }
        }        
        system.debug('licensesWithEmail::'+licensesWithEmail);
        // Send reminder emails
        List<Messaging.SingleEmailMessage> emailList = new list<Messaging.SingleEmailMessage>();
        for(MUSW__License2__c lic : licensesWithEmail){
            if(licenseToAttachmentIdMap.containsKey(lic.Id)){
                Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
                message.setToAddresses(new String[]{lic.Account_Email__c});
                message.setSubject('Reminder Letter for DHP');
                message.setEntityAttachments(licenseToAttachmentIdMap.get(lic.Id));
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