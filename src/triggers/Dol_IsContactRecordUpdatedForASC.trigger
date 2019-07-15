trigger Dol_IsContactRecordUpdatedForASC on Contact (before update) {
     List<Id> contactIds  = new List<Id>();
     List<Contact> ContactList = new List<Contact>();
   
     for(Contact con : trigger.new){
         System.debug('con.UID__c=='+con.UID__c +'--trigger.oldmap.get(con.id).UID__c=='+trigger.oldmap.get(con.id).UID__c);
         if((con.UID__c != trigger.oldmap.get(con.id).UID__c || con.LastName != trigger.oldmap.get(con.id).LastName
             || con.FirstName != trigger.oldmap.get(con.id).FirstName|| con.MiddleName != trigger.oldmap.get(con.id).MiddleName
             || con.Phone != trigger.oldmap.get(con.id).Phone || con.Company_Name__c != trigger.oldmap.get(con.id).Company_Name__c))
         {
             contactIds.add(con.id);
         }
    }
    System.debug('contactIds'+contactIds);
    if(Dol_IntegrationUtil.isNotEmpty(contactIds)){
        ContactList = [select id, IsContactRecordUpdatedForASC__c from Contact  where id =:contactIds];
    }
    for(contact contact : ContactList){
        for(Contact con : trigger.new){
            con.IsContactRecordUpdatedForASC__c =true;
        }
    }
}