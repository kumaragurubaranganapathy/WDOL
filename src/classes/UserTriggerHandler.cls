public class UserTriggerHandler implements ITriggerHandler {
    public static Boolean TriggerDisabled = false;

    /*
        Checks to see if the trigger has been disabled. For example, you could check a custom setting here.
        In this example, a static property is used to disable the trigger.
        In a unit test, you could use AccountTriggerHandler.TriggerDisabled = true to completely disable the trigger.
    */
    public Boolean IsDisabled()
    {
        return TriggerDisabled;
    }

    public void BeforeInsert(List<SObject> lstItems) 
    {
        //newItems[0].Name = DOL_AppConstants.NULL_EMPTY_STRING + 'Test Trigger';
    }

    public void BeforeUpdate(Map<Id, SObject> newItems, Map<Id, SObject> oldItems) 
    {

    }

    public void BeforeDelete(Map<Id, SObject> oldItems) {}

    public void AfterInsert(List<User> newItems) {
        
     //   system.debug('inside trigger user'+newItems);
        //Add user details
        List<User> lstuserId = new List<User>();
        Map<String,User> mapUser  = new Map<String,User>();
        for(User usr : newItems) {
            if(usr.ContactId != null) {
                User user  = new User ();
                user.Id = usr.Id;
                user.Email =  usr.Email;
                user.Username = usr.Username;
                user.ContactId = usr.ContactId; 
                mapUser.put(user.Email, user); 
            }
        }
        
        //Get account contact basis emailID of reigstered user
        List<MUSW__Account_Contact__c> lstAccountContact  = new List<MUSW__Account_Contact__c>();
        for(MUSW__Account_Contact__c accountContact : [select id,Email__c,MUSW__Contact__c,Associate_Status__c 
                                                       from MUSW__Account_Contact__c where Email__c in :mapUser.keySet()]) {
                                                           lstAccountContact.add(accountContact);
                                                       }
        for(MUSW__Account_Contact__c accountContact :lstAccountContact ) {
            if(mapUser.containsKey(accountContact.Email__c)){
                accountContact.MUSW__Contact__c = mapUser.get(accountContact.Email__c).ContactId;
                accountContact.Associate_Status__c = DOL_AppConstants.NULL_EMPTY_STRING + 'Active';
            }
        }
        //Update account contact
        if(!lstAccountContact.isEmpty()) {
            update lstAccountContact;
        }
        
       
    }
    public void AfterInsert(Map<Id, SObject> newItems) { 
    
    }
    
    public void AfterUpdate(Map<Id, SObject> newItems, Map<Id, SObject> oldItems) {}

    public void AfterDelete(Map<Id, SObject> oldItems) {}

    public void AfterUndelete(Map<Id, SObject> oldItems) {}

}