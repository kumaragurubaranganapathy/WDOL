trigger DRE2_Associations_c on Associations__c (after insert, before update, before delete, after undelete) 
  { 
   /*Checking whehter triggers have been disabled for the user or not*/
    Global_Settings__c globalSetting = Global_Settings__c.getInstance(UserInfo.getUserId());
    if(globalSetting.Disable_Triggers__c == true) {
        /*If the triggers have been disabled, then do not call the trigger handler*/
        return;
    }
    public static boolean runAgain = false;
    BGCM.TriggerManager.execute('DRE2_Associations_c', new DRETriggerHandler()); 
    Map<Id,Integer> mapIdCount = new Map<Id,Integer>();
    List<MUSW__License2__c> lictoUpdate = new List<MUSW__License2__c>();
    if(Trigger.isAfter && Trigger.isInsert){
        for(Associations__c assoc : Trigger.new){
             mapIdCount.put(assoc.Child_License__c,1);
        }
    }
    if(Trigger.isBefore && Trigger.isUpdate && runAgain == false){
    runAgain= true;
    for(Associations__c assoc : Trigger.new){
        Integer Number_Count = 0;
        if(assoc.Status__c != trigger.oldMap.get(assoc.id).Status__c && trigger.oldMap.get(assoc.id).Status__c != 'Active' && assoc.Status__c == 'Active'){
            Number_Count ++;
        }else if(assoc.Status__c != trigger.oldMap.get(assoc.id).Status__c && trigger.oldMap.get(assoc.id).Status__c == 'Active' && assoc.Status__c != 'Active'){
            Number_Count  --;
        }
        mapIdCount.put(assoc.Child_License__c,Number_Count);
    }
    }
    if(!mapIdCount.isEmpty()){
         List<MUSW__License2__c> licenseList = [Select id,No_of_Active_Relationship__c from MUSW__License2__c where Id IN:mapIdCount.keyset()  and Id != null];
             for(MUSW__License2__c lic : licenseList){
                 Integer ActiveRelationship =  Integer.valueOf((lic.No_of_Active_Relationship__c != null) ? lic.No_of_Active_Relationship__c + mapIdCount.get(lic.id) : mapIdCount.get(lic.id));
                 lic.No_of_Active_Relationship__c = (ActiveRelationship >= 0) ? ActiveRelationship : 0 ;
                 lictoUpdate.add(lic);
            }
        }
        
        if(!lictoUpdate.isEmpty()){
            update lictoUpdate;
        }
   

}