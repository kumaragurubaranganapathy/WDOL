trigger Dol_IsContactRecordUpdatedForASC on Contact (before update) {
  /*Checking whether triggers have been disabled for the user or not*/
    Global_Settings__c gs = Global_Settings__c.getInstance(UserInfo.getUserId());
    if(gs.Disable_Triggers__c == true){
        // If the triggers have been disabled, then do not call the trigger handler
        return;
    }
     for(Contact con : trigger.new){
         System.debug('con.UID__c=='+con.UID__c +'--trigger.oldmap.get(con.id).UID__c=='+trigger.oldmap.get(con.id).UID__c);
         if(con.IsContactRecordUpdatedForASC__c != true && (con.Social_Security_Number_Encrypted__c  != trigger.oldmap.get(con.id).Social_Security_Number_Encrypted__c  || con.LastName != trigger.oldmap.get(con.id).LastName
             || con.FirstName != trigger.oldmap.get(con.id).FirstName|| con.MiddleName != trigger.oldmap.get(con.id).MiddleName
             || con.Phone != trigger.oldmap.get(con.id).Phone || con.Company_Name__c != trigger.oldmap.get(con.id).Company_Name__c))
             {
                 con.IsContactRecordUpdatedForASC__c = true;
             }
    }
}