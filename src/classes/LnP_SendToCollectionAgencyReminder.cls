global class LnP_SendToCollectionAgencyReminder implements Schedulable {
    global String [] email = new String[] {'nazbegum@deloitte.com'};
    global void execute(SchedulableContext ctx) {
       // Map<Id,Id> licenseToAttachmentIdMap = new Map<Id,Id>();
        List<MUSW__Fee__c> feeList = [SELECT Id,Name,Related_To_Name__c,MUSW__Outstanding_Fee__c,MUSW__Type__c FROM MUSW__Fee__c WHERE MUSW__Type__c =:'Fine' AND MUSW__Outstanding_Fee__c>0  AND CreatedDate < last_n_days:10];
        system.debug('feeList::'+feeList);
      
        // Send reminder emails
        List<Messaging.SingleEmailMessage> emailList = new list<Messaging.SingleEmailMessage>();
        for(MUSW__Fee__c fee : feeList){
            system.debug('teh fee is' +fee);
                Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
                message.setToAddresses(email);
                message.setSubject('Reminder Notification to Collection Agency For the fees');
                String messageBody = '<html><body>Hello,</body></html>';
                String messageBody1 = '<html><body>The fine is pending for the License:</body></html>'+fee.Related_To_Name__c;
                String messageBody2 = '<html><body>The Outstanidng amount for the fee is:</body></html>'+fee.MUSW__Outstanding_Fee__c;
                message.setHtmlBody(messageBody+''+messageBody1+''+messageBody2);
                //message.setPlainTextBody('The fine is pending for the fee:' +fee.Name);
                //message.setPlainTextBody('The Outstanidng amount for the fee is:' +fee.MUSW__Outstanding_Fee__c);
                emailList.add(message);
            
        }
        system.debug('emailList::'+emailList);
        if(emailList.size() > 0){
            Messaging.SendEmailResult[] results = Messaging.sendEmail(emailList);
        }
    }
}