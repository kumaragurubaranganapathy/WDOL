trigger Dol_UpdateUIDonSSNUpdate on Contact (after update, after insert) {
    List<Id> contactWithNoSSN = new List<Id>();
    List<contact> contactWithNoSSNList = new List<contact>();
    List<contact> contactWithSSNList = new List<contact>();
    List<contact> updateConList = new List<contact>();
    Boolean isRecursive = false; 
    
    
    if(trigger.isupdate && trigger.isafter && isRecursive == false){
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
    }    
}