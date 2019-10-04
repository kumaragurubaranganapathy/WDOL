@isTest
public class LnP_CalculateSystemGeneratedAmount_Test {
    @isTest
    public static void CalculateSystemGeneratedAmountTest(){
        Id cashRegRecTypeId = Schema.SObjectType.Cash_Register__c.getRecordTypeInfosByName().get('Cash Register').getRecordTypeId();
        Cash_Register__c cr = DOL_TestDataFactory.createCashRegister(cashRegRecTypeId);                                             
        MUSW__Receipt__c receipt = DOL_TestDataFactory.createReceipt('cash',100,'Counter');
        LnP_CalculateSystemGeneratedAmountClass.CalculateSystemGeneratedAmount(cr.Id);
        try{
            LnP_CalculateSystemGeneratedAmountClass.CalculateSystemGeneratedAmount(null);
        }catch(Exception e){}
        
        //SELECT Id,MUSW__Amount_Tendered__c, BGBK__Cart__r.BGBK__BG_Payment_Batch__r.Cash_Register__c FROM MUSW__Receipt__c where BGBK__Cart__r.BGBK__BG_Payment_Batch__r.Cash_Register__c =:RecordId and MUSW__Payment_Method__c ='cash']){
            
    }
        

}