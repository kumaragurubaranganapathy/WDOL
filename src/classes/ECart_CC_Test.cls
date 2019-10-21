@isTest
public class ECart_CC_Test {
    
    @testSetup
    public static void setupTestData(){
        BGBK__CartSettings__c cartSettings = new BGBK__CartSettings__c(Name = DOL_AppConstants.NULL_EMPTY_STRING + 'Default', BGBK__Payable_Parents__c = DOL_AppConstants.NULL_EMPTY_STRING + 'MUSW__License2__c, MUSW__Application2__c, License_Renewal__c', BGBK__Payment_Gateway_Data_Encryption_Key__c = DOL_AppConstants.NULL_EMPTY_STRING + 'BasicGovPayments');
        insert cartSettings;
        
        
        String accountRecType = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Business Account').getRecordTypeId();
        Account acc = DOL_TestDataFactory.createAccount(accountRecType);
        
        String contactRecType = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Contact').getRecordTypeId();
        Contact con = DOL_TestDataFactory.createContact(contactRecType,acc.Id);
        
    }
    
    @isTest
    public static void test01(){
        Account acc = [Select Id From Account limit 1];
        Contact con = [Select Id From Contact limit 1];
        
        
        User newUser = DOL_TestDataFactory.createPortalAccountUser();
      
        
        Test.startTest();
        
        System.runAs(newUser){
            
            ID RecordTypeIdAccount = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Business Account').getRecordTypeId();        
            ID RecordTypeIdLicense = Schema.SObjectType.MUSW__License2__c.getRecordTypeInfosByName().get('Business').getRecordTypeId();
            
            MUSW__License2__c liceId = DOL_TestDataFactory.createLicense(RecordTypeIdLicense, 
                                                                         DOL_TestDataFactory.createAccount(RecordTypeIdAccount).Id, 
                                                                         'Appraisal Management Companies', 
                                                                         'Appraisal Management Company', 
                                                                         'General Application');
            liceId.MUSW__Status__c = 'Generate Fee';
            update liceId;
            
            MUSW__Fee__c fee = new MUSW__Fee__c();
            fee.MUSW__Amount__c = 188;
            fee.Contact__c = con.Id;
            fee.MUSW__License2__c = liceId.Id;
            insert fee;
            
            ECart_CC controller = new ECart_CC();
            controller.onPageLoad();
            controller.continueToCheckout();
            controller.backToItems();
            
            for(ECart_CC.FeeWrapper feeW : controller.fees){
                feeW.checked = true;
            }
            
            controller.redirectToPaymentGateway();
            Decimal totalAmount = controller.totalAmount;
            controller.resetFeeList();
        }
        
        Test.stopTest();
    }
}