/**
* Name: FeeTriggerHandler
* Type: Class
* Description: Trigger Handler for MUSW__Fee__c object being called from FeeTrigger
* Date:        Developer/Company                   Description
* ---------------------------------------------------------------------------------------------------------------------------------------- *
* 08/22/2018   Srikanth Kottam/Deloitte          Initial Creation
* 07/10/2019   Chiranth                          Added the code before Insert and before update method (US1818)
**/
public class FeeTriggerHandler implements BGCM.ITriggerHandler{
    public static boolean isTrue  = true;
    public void onAfterDelete() {}
    public void onAfterInsert() {
        afterMethod();
    }
    public void onAfterUndelete() {}
    public void onAfterUpdate() {
        afterMethod();
    }
    public void onBeforeDelete() {}
    public void onBeforeInsert() {
        //Add for the US1812 on 7/11/2019 [Chiranth]
        for(SObject record: trigger.new) {
           MUSW__Fee__c fee = (MUSW__Fee__c)record;
            if(fee.MUSW__type__c == 'Trust Expense - Staff Hours'){
                fee.MUSW__Amount__c = fee.Fee_amount_for_labor_charge__c;
            }else if(fee.MUSW__type__c == 'Trust Expense - Mileage'){
                fee.MUSW__Amount__c = fee.Fee_amount_for_mileage__c; 
            }   
            
         }
         // End of code US1812
    }
    public void onBeforeUndelete() {}
    public void onBeforeUpdate() {
    
        //Add for the US1812 on 7/11/2019 [Chiranth]
         for(SObject record: trigger.new) {
            MUSW__Fee__c fee = (MUSW__Fee__c)record;
            SObject oldrecord = Trigger.oldMap.get(record.Id);
            MUSW__Fee__c oldfee = (MUSW__Fee__c)oldrecord;
            if(fee.MUSW__type__c == 'Trust Expense - Staff Hours' && fee.MUSW__type__c != oldfee.MUSW__type__c){
                fee.MUSW__Amount__c = fee.Fee_amount_for_labor_charge__c;
            }else if(fee.MUSW__type__c == 'Trust Expense - Mileage' && fee.MUSW__type__c != oldfee.MUSW__type__c){
                fee.MUSW__Amount__c = fee.Fee_amount_for_mileage__c; 
            }   
            
         }
         // End of code US1812
    }
    
    public void afterMethod() {
        //This Method is called when already an AccountContact Record exists on an Account and Fee records get Created. This Record will be shared with the community Plus User
        if(userinfo.getName()!='System Integration' && isTrue){
        //FeeUsersharing controller = new FeeUsersharing();
        //controller.FeeSharing_RecordInsert(Trigger.New);
        //End of FeeUsersharing
        isTrue =false;
        //Share the Fee records when the Delegated Admin is the applicant
        //FeeCreatedByDelegate DelegateController = new FeeCreatedByDelegate();
        System.debug('Entered fee trigger');
      //  DelegateController.shareFeeRecords(Trigger.New);
        System.debug('Entered fee trigger again');
        }
    } 
}