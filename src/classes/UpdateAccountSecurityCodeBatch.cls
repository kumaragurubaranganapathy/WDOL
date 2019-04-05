global with sharing class UpdateAccountSecurityCodeBatch implements Database.Batchable<sObject>, Database.Stateful{
    global final String query;  
    global integer totalAccountCount;  
    
    global UpdateAccountSecurityCodeBatch(String q){        
        query=q;        
        totalAccountCount = 0;
    }
    global Database.QueryLocator start(Database.BatchableContext BC){        
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<Account> scope){
        System.debug('in account scope');
        List<Account> accounts = new List<Account>();
        Integer len = 5;
        for(Account acct : scope){
            totalAccountCount = totalAccountCount + 1;
            
            Blob blobKey = crypto.generateAesKey(128);
            String key = EncodingUtil.convertToHex(blobKey);
            String pwd = key.substring(0,len);
            acct.Security_Code__c = String.valueOf(acct.Id).substring(10,15)+pwd;
            accounts.add(acct);
        }
        update accounts;   
        
    }
    
    global void finish(Database.BatchableContext BC){
        System.debug('totalAccountCount '+totalAccountCount);
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
            mail.setPlainTextBody('records processed ' + a.TotalJobItems +   'with '+ a.NumberOfErrors + ' failures. Items processed: '+a.JobItemsProcessed+ ' total account count '+totalAccountCount);
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        }
    }
    
}