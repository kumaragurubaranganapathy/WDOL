/************************************************************************
* Name   : RulesEngineFeeHandler                                        *
* Author : Sujila Nair                                                  *
* Desc   : Rules Engine Framework to read fee confi from Fee Table      *
* ----------------------------------------------------------------------*
* Developer     |  Date        |  Description                           *
* ----------------------------------------------------------------------*
* Sujila Nair   | 09/19/2017   |  Inital Implementation                 *
* Sujila Nair   | 02/10/2018   |  Updated Query                         *
*************************************************************************/
public without sharing class RulesEngineFeeHandler {
    public static Map<String, FeeTable__c> FeeTable = new Map<String, FeeTable__c>();
    
    public static Map<String, FeeTable__c> getAll(){
        for(FeeTable__c fee: [Select Id, Name, Account_Code__c, Account_Number__c, Add_Additional_Fee__c, Amount__c, Board__c, Fee_type__c, Rule_Name__c, Expiry_Date__c, Parent_Status_Field_API_Name__c, Status_value_Before_Fee_Generation__c From FeeTable__c limit 2000]){
            FeeTable.put(fee.Name, fee);
        }
        return FeeTable;
    }
    
    public static List<MUSW__Fee__c> checkTransactionFee(Map<String, MUSW__Fee__c> feetableToFee){
        List<MUSW__Fee__c> TransactionFees = new List<MUSW__Fee__c>();
        for(string feeName: feetableToFee.keySet()){           
            if(FeeTable!= null && FeeTable.size()>0 && FeeTable.containsKey(feeName)){
                FeeTable__c setting = FeeTable.get(feeName);   
                if(setting.Add_Additional_Fee__c != null && FeeTable.containsKey(setting.Add_Additional_Fee__c)){   
                    FeeTable__c newSetting = FeeTable.get(setting.Add_Additional_Fee__c);
                    MUSW__Fee__c newFee = feetableToFee.get(feeName).clone(false, false, false, false);   // Clone the parent fee
                    newFee.Account_Number__c = newSetting.Account_Number__c;
                    newFee.MUSW__Type__c = newSetting.Fee_type__c;
                    newFee.MUSW__Amount__c = newSetting.Amount__c;
                    newFee.MUSW__Amount_Paid__c = 0;
                    newFee.MUSW__Amount_Waived__c = 0;
                    newFee.Upsert_ID__c = feetableToFee.get(feeName).Upsert_ID__c +'_'+setting.Add_Additional_Fee__c;  // Upsert ID => Parent fee upsert id + transaction revs name
                    TransactionFees.add(newFee);
                }
            }
        }
        return TransactionFees;
    }    

}