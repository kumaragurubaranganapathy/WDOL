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
    
    public void onAfterDelete() {}
    public void onAfterInsert() {
        if(!DOL_AppUtility.isFeeRunOnce){
            DOL_AppUtility.isFeeRunOnce = true;
            //Merging code from FeeUpdateCart Trigger **by Abhilasha**Start
            List<MUSW__Fee__c> fees = new List<MUSW__Fee__c>();
            for (SObject record : Trigger.new){
                MUSW__Fee__c f = (MUSW__Fee__c)record;
                if (!f.MUSW__Fee_Paid__c && f.MUSW__Outstanding_Fee__c > 0){
                    fees.add(f);
                }
            }
            if (fees.size() == 0){
                return;
            }else{
                afterExec(fees);
            }
            //Merging code from FeeUpdateCart Trigger **by Abhilasha**End
            //Merging code from DRE trigger
            BGCM.TriggerManager.execute('DRE2_MUSW_Fee_c', new DRETriggerHandler());
        }
    }
    public void onAfterUndelete() {}
    public void onAfterUpdate() {
        if(!DOL_AppUtility.isFeeRunOnce){
            DOL_AppUtility.isFeeRunOnce = true;
            //Merging code from FeeUpdateCart Trigger **by Abhilasha** Start
            List<MUSW__Fee__c> fees = new List<MUSW__Fee__c>();
            Map<Id,MUSW__Fee__c> oldMap = (Map<Id,MUSW__Fee__c>)trigger.oldMap;
            for (SObject record : Trigger.new){
                MUSW__Fee__c f = (MUSW__Fee__c)record;
                if (!f.MUSW__Fee_Paid__c && f.MUSW__Outstanding_Fee__c > 0 &&(f.MUSW__Outstanding_Fee__c != oldMap.get(f.Id).MUSW__Outstanding_Fee__c || f.MUSW__Amount_Waived__c != oldMap.get(f.Id).MUSW__Amount_Waived__c )){
                    fees.add(f);
                }
            }
            if (fees.size() == 0){
                return;
            }else{
                afterExec(fees);
            }
            //Merging code from FeeUpdateCart Trigger **by Abhilasha**End
        }
    }
    public void onBeforeDelete() {}
    public void onBeforeInsert() {
        
        //Merging code from FeeUpdateCart Trigger **by Abhilasha**Start
            List<MUSW__Fee__c> fees = new List<MUSW__Fee__c>();
            //end
            
            //Add for the US1812 on 7/11/2019 [Chiranth]
            for(SObject record: trigger.new) {
                MUSW__Fee__c fee = (MUSW__Fee__c)record;
                if(fee.MUSW__type__c == 'Trust Expense - Staff Hours'){
                    fee.MUSW__Amount__c = fee.Fee_amount_for_labor_charge__c;
                }else if(fee.MUSW__type__c == 'Trust Expense - Mileage'){
                    fee.MUSW__Amount__c = fee.Fee_amount_for_mileage__c; 
                }
                //Merging code from FeeUpdateCart Trigger **by Abhilasha**Start
                if (!fee.MUSW__Fee_Paid__c && fee.MUSW__Outstanding_Fee__c > 0){
                    fees.add(fee);
                }//end
                
            }
            // End of code US1812
            //Merging code from FeeUpdateCart Trigger **by Abhilasha**Start
            if(fees.size() >0){
                Boolean bulkDataload = fees.size() > 100;
                if (!bulkDataload){
                    BGBK.CartManager.addFeesToCart(fees);
                } 
            }
            //Merging code from FeeUpdateCart Trigger **by Abhilasha**End
        
    }
    public void onBeforeUndelete() {}
    public void onBeforeUpdate() {
         if(!DOL_AppUtility.isFeeRunOnce){
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
            //Merging code from DRE trigger
            BGCM.TriggerManager.execute('DRE2_MUSW_Fee_c', new DRETriggerHandler());
         }
    }
    
    //Merging code from FeeUpdateCart Trigger **by Abhilasha**Start
    public void afterExec(List<MUSW__Fee__c> feeList){
        Set<Id> cartIds = new Set<Id>();
        for (MUSW__Fee__c f : feeList){
            if (f.BGBK__Cart__c != null && !cartIds.contains(f.BGBK__Cart__c)){
                cartIds.add(f.BGBK__Cart__c);
            }
        }
        
        BGBK__Cart__c[] carts = [select BGBK__Total_Amount__c, (select MUSW__Outstanding_Fee__c from BGBK__Fees__r where MUSW__Outstanding_Fee__c > 0 and MUSW__Outstanding_Fee__c != null) from BGBK__Cart__c where Id in :cartIds and Id != null];
        
        if (carts.size() > 0){
            for (BGBK__Cart__c cart : carts){
                Decimal totalAmount = 0;
                for (MUSW__Fee__c f : cart.BGBK__Fees__r){
                    totalAmount += f.MUSW__Outstanding_Fee__c;
                }
                cart.BGBK__Total_Amount__c = totalAmount;
            }
            update carts;
        }
    }
    //Merging code from FeeUpdateCart Trigger **by Abhilasha** End
    
}