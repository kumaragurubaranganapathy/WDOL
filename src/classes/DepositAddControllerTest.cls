@isTest
public class DepositAddControllerTest {
    @isTest
    static void orderTest(){
        
        Test.startTest();
        List<MUSW__Deposit__c> depList = DOL_TestDataFactory.createDeposit('Architects');
        List<MUSW__Deposit__c> depList2 = DOL_TestDataFactory.createDeposit('Geologist');
        depList.add(depList2[0]);
        
        ApexPages.StandardSetController ssc = new ApexPages.StandardSetController(depList);
        ssc.setSelected(depList);
        
        DepositAddController dac = new DepositAddController(ssc);
        PageReference pageRef = dac.initOrder();
        
        Test.stopTest();
    }
}