@isTest
public class CartDepositsController_Test {
    
    @isTest
    public static void testController(){
        Test.startTest();
        List<MUSW__Deposit__c> depList = DOL_TestDataFactory.createDeposit('Architects');
        
        PageReference pageRef = Page.Cart;
		Test.setCurrentPage(pageRef);
        ApexPages.StandardSetController stdSetController = new ApexPages.StandardSetController(depList);
        stdSetController.setSelected(depList);
        CartDepositsController ext = new CartDepositsController(stdSetController);
        Test.stopTest();
    }
    
    @isTest
    public static void testInitOrder(){
        Test.startTest();
        List<MUSW__Deposit__c> depList = DOL_TestDataFactory.createDeposit('Architects');
        
        PageReference pageRef = Page.Cart;
		Test.setCurrentPage(pageRef);
        ApexPages.StandardSetController stdSetController = new ApexPages.StandardSetController(depList);
        stdSetController.setSelected(depList);
        CartDepositsController ext = new CartDepositsController(stdSetController);
        ext.initOrder();
        Test.stopTest();
    }
}