@isTest
public class RulesEngineFeeHandlerTest {
    public static testmethod void testcheckTransactionFeeMethod(){
		Test.startTest();        
            FeeTable__c feeTable = new FeeTable__c();
            feeTable.Name = 'testFee';
            feeTable.Account_Code__c = '13568';
            feeTable.Account_Number__c ='87644';
            feeTable.Add_Additional_Fee__c = 'FEE-OIT-TRANS';
            feeTable.Amount__c = 1000.0;
            feeTable.Board__c = 'Medical Board';
            feeTable.Fee_type__c = 'FeeType';
            feeTable.Rule_Name__c = 'TestRule';
            feeTable.Expiry_Date__c = System.today()+5;
            feeTable.Parent_Status_Field_API_Name__c= 'test';
            feeTable.Status_value_Before_Fee_Generation__c = 'test';
            insert feeTable;
            RulesEngineFeeHandler.getAll(); 
        Test.stopTest();
        
    }
}