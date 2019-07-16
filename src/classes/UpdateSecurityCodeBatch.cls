global with sharing class UpdateSecurityCodeBatch implements Database.Batchable<sObject>, Database.Stateful{
    global final String query;  
    global integer totalCount;  
    
    global UpdateSecurityCodeBatch(String q){        
        query=q;        
        totalCount = 0;
    }
    global Database.QueryLocator start(Database.BatchableContext BC){        
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<Contact> scope){
        System.debug('in scope');
        List<Contact> contacts = new List<Contact>();
        Integer len = 5;
        for(Contact cont : scope){
            totalCount = totalCount + 1;
            
            Blob blobKey = crypto.generateAesKey(128);
            String key = EncodingUtil.convertToHex(blobKey);
            //System.debug('contact id::'+cont.Id);   
            String pwd = key.substring(0,len);
            //system.debug('security code::' + String.valueOf(cont.Id).substring(10,15)+ pwd);
            cont.Security_Code__c = String.valueOf(cont.Id).substring(10,15)+pwd;
            contacts.add(cont);
        }
        update contacts;   
        
    }
    
    global void finish(Database.BatchableContext BC){
        System.debug('totalCount '+totalCount);
        AsyncApexJob a = [Select Id, Status,ExtendedStatus,NumberOfErrors, JobItemsProcessed,TotalJobItems, CreatedBy.Email    
                          from AsyncApexJob 
                          where Id =:BC.getJobId()];
      
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        List<String> toAddresses = new List<String>();
        if(Label.Str_Support_Team_Emails != null){
            String[] temp = Label.Str_Support_Team_Emails.split(',');
            for(String address : temp){
                address = address.trim();
                toAddresses.add(address);
            }
        }
        
        if(toAddresses.size() > 0){
            mail.setToAddresses(toAddresses);
            mail.setSubject('Match Merge Batch ' + a.Status);
            mail.setPlainTextBody('records processed ' + a.TotalJobItems +   'with '+ a.NumberOfErrors + ' failures. Items processed: '+a.JobItemsProcessed+ ' total count '+totalCount);
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        }
    }
    
}