trigger StoreDebugErrorLogs on Debug_Error_Loggger__e (after insert) {

        //Global_Settings__c settings = Global_Settings__c.getInstance(UserInfo.getUserId()); if(settings!= null) { if(settings.Bypass_Validation_Workflow_Rules__c){ return;}}
    
        List<Error_Logs__c> objLogMessages = new List<Error_Logs__c>();

        // Iterate through each notification.
        for (Debug_Error_Loggger__e event : Trigger.New) {
           if (event.Message__c!=null){
               Error_Logs__c objMessage= (Error_Logs__c)JSON.deserialize(event.Message__c, Error_Logs__c.class);
               objLogMessages.add(objMessage);
           }//end-if
        } //end for
        
       if (objLogMessages.size() >0){Database.insert(objLogMessages,false);}
} //end trigger