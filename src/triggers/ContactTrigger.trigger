trigger ContactTrigger on Contact (before insert, before update, before delete, after insert, after update, after delete, after undelete) { 
    Global_Settings__c gs = Global_Settings__c.getInstance(UserInfo.getUserId());
    if(gs.Disable_Triggers__c == true){
        // If the triggers have been disabled, then do not call the trigger handler
        return;
    }
    //calling the trigger handler
    TriggerDispatcher.Run(new ContactTriggerHandler()); 
    
    //IsContactRecordUpdatedFor ASC TRANSACTION
    if(trigger.isupdate && trigger.isbefore){
       List<Id> contactIds = new List<Id>();
        List<Contact> contactList = new List<Contact>();
         for(Contact con : trigger.new){
             if(con.IsContactRecordUpdatedForASC__c != true && (con.Social_Security_Number_Encrypted__c  != trigger.oldmap.get(con.id).Social_Security_Number_Encrypted__c  || con.LastName != trigger.oldmap.get(con.id).LastName
                 || con.FirstName != trigger.oldmap.get(con.id).FirstName|| con.MiddleName != trigger.oldmap.get(con.id).MiddleName
                 || con.Phone != trigger.oldmap.get(con.id).Phone || con.Company_Name__c != trigger.oldmap.get(con.id).Company_Name__c))
                 {
                     contactIds.add(con.id);
                 }
        }
        if (Dol_IntegrationUtil.isNotEmpty(contactIds)){
            contactList= [select id,IsContactRecordUpdatedForASC__c,(select id from MUSW__License2s__r where Credential_Type__c in ('Certified Residential Appraiser','Certified General Appraiser','State Licensed Appraiser')) from Contact where id =:contactIds];
            for(Contact con : contactList){
                if(Dol_IntegrationUtil.isNotEmpty(con.MUSW__License2s__r)){
                    for(Contact Cont : trigger.new){
                        Cont.IsContactRecordUpdatedForASC__c =true;
                    }
                } 
            }
        } 
    }
    
    /* [Nibedita Swain/ September 26, 2019] 
    Convert SSN to UBI – this is now out of Release 1 as it was dependent on API.
    Workaround – Send SSN instead of UBI (This is tested and verified with ASC)
    Changes – We have to revert the code/comment the trigger which was built for triggering this transaction from Salesforce
    
    if(trigger.isupdate && trigger.isafter){
            List<Id> contactWithNoSSN = new List<Id>();
            List<contact> contactWithNoSSNList = new List<contact>();
            List<contact> contactWithSSNList = new List<contact>();
            List<contact> updateConList = new List<contact>();
            Boolean isRecursive = false;
        for(contact con :trigger.new){
            if(Dol_IntegrationUtil.isBlank(con.Social_Security_Number_Encrypted__c) && Dol_IntegrationUtil.isNotBlank(con.UID__c)){
                System.debug('ssn deleted');
                contactWithNoSSN.add(con.id);
            }
            else if(Dol_IntegrationUtil.isNotBlank(con.Social_Security_Number_Encrypted__c) && trigger.oldMap.get(con.Id).Social_Security_Number_Encrypted__c != con.Social_Security_Number_Encrypted__c){
                 System.debug('ssn updates');
                contactWithSSNList.add(con);
            }
        }
         System.debug('contactWithSSNList**'+contactWithSSNList);
         System.debug('contactWithNoSSN**'+contactWithNoSSN);
        if(Dol_IntegrationUtil.isnotEmpty(contactWithNoSSN)){
            contactWithNoSSNList = [select id,UID__c from contact WHERE Id =: contactWithNoSSN];
            System.debug('contactWithNoSSNList**'+contactWithNoSSNList);
            for(contact con : contactWithNoSSNList){
                con.UID__c = null;
                updateConList.add(con);
                 System.debug('updateConList**'+updateConList);
            }
            if(Dol_IntegrationUtil.isnotEmpty(updateConList)){
                System.debug('updateConListbefore**'+updateConList);
                upsert updateConList;
                isRecursive = true;
            }
        }
        else if(Dol_IntegrationUtil.isnotEmpty(contactWithSSNList)){
            System.debug('contactWithSSNList'+contactWithSSNList);
            for(Contact con : contactWithSSNList){
                Dol_RestAPIservice.callASCservice(con.Social_Security_Number_Encrypted__c , con.id);
                isRecursive = true;
            }  
        }  
    }
    if(trigger.isinsert && trigger.isafter){
        List<contact> contactWithSSNList = new List<contact>();
        for(Contact con : trigger.new){
            if(con.Social_Security_Number_Encrypted__c != null){
                contactWithSSNList.add(con);
            }
        }
        if(Dol_IntegrationUtil.isnotEmpty(contactWithSSNList)){
            System.debug('contactWithSSNList'+contactWithSSNList);
            for(Contact con : contactWithSSNList){
                Dol_RestAPIservice.callASCservice(con.Social_Security_Number_Encrypted__c , con.id);
            }  
        }      
    } */  
}