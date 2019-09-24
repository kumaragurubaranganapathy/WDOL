/**
* Name: AccountTriggerHandler
* Type: Handler Class
* Description: Trigger Handler for Account object being called from AccountTrigger 
* Date:        Developer/Company                 	Description
* ---------------------------------------------------------------------------------------------------------------------------------------- *
* 08/06/2018   Srikanth Kottam/Deloitte           Initial Creation
**/
public class AccountTriggerHandler implements BGCM.ITriggerHandler{
	public void onAfterDelete() {}
    public void onAfterInsert() {
         afterMethod();
    }
    public void onAfterUndelete() {}
    public void onAfterUpdate() {}
    public void onBeforeDelete() {}
    public void onBeforeInsert() {
        // Calling beforeInsertMethod to perform actions before insert 
        beforeInsertMethod();
    }
    public void onBeforeUndelete() {}
    public void onBeforeUpdate() {
        // Calling beforeUpdateMethod to perform actions before insert 
        beforeUpdateMethod();        
    }
    
    Public void beforeInsertMethod(){
        // Get Record type Id to validate Business Accounts
        Id recordtypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Business Account').getRecordTypeId();
        
        // Insert basicgov Unique Sequence numbers
        MUSW.SequenceNumber.updateNumbers(Trigger.new, Trigger.old);
        
        // Insert Last4FEIN if it is Business Account
        for(Account a: (list<Account>)Trigger.New){
            if(a.FEIN_Number_Encrypted__c != null && a.recordtypeId == recordtypeId){
                a.Last_4_Digits_of_FEIN__c = a.FEIN_Number_Encrypted__c.right(4);
            }
            if(a.recordtypeId == recordtypeId ){
                a.Account_Status__c = (a.UBI_Status__c != null && a.UBI_Status__c != 'NA')? a.UBI_Status__c : 'Active';
            }
        }
    }
    
    Public void beforeUpdateMethod(){
        // Get Record type Id to validate Business Accounts
        Id recordtypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Business Account').getRecordTypeId();
        
        // Insert Last4FEIN if it is Business Account
        for(Account a: (list<Account>)Trigger.New){
            Account oldAcc = (Account)Trigger.oldMap.get(a.ID);
            if(a.FEIN_Number_Encrypted__c != null && a.recordtypeId == recordtypeId && oldAcc.FEIN_Number_Encrypted__c != a.FEIN_Number_Encrypted__c){
                a.Last_4_Digits_of_FEIN__c = a.FEIN_Number_Encrypted__c.right(4);
            }
            
            //Update Contact Status if DOR Response Code was received
            if(a.Account_Status__c == 'On Hold'){
                if(a.Dor_Response__c == 'CL' || a.Dor_Response__c == 'IC' || a.Dor_Response__c == 'HO' || a.Dor_Response__c == 'OK'){
                    a.Account_Status__c = 'Active';
                    a.DOR_Response_Date__c = null;
                }
            }else{
                if(a.Dor_Response__c == 'CD' || a.Dor_Response__c == 'HD' || a.Dor_Response__c == 'AA'){
                    a.Account_Status__c = 'On Hold';
                }
            }
        }
    }
    
    public void afterMethod(){
        /*if(Trigger.isInsert){
            if(!SecurityCodeHelper.isAccountSecurityCodeSet){
                SecurityCodeHelper.setAccountSecurityCode();
            }
            
        }*/
    }
}