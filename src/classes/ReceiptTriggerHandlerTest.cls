@isTest
public class ReceiptTriggerHandlerTest {
     @testsetup
    static void setup(){
     BGBK__Payment_Batch__c objPaymentBatch = new BGBK__Payment_Batch__c();
        objPaymentBatch.Name ='test';
        insert objPaymentBatch;
        BGBK__Cart__c objCart= DOL_TestDataFactory.createCartRecord(objPaymentBatch.Id);
         MUSW__Receipt__c receiptRecord = new MUSW__Receipt__c(MUSW__Payment_Method__c = 'Credit Card'  ,MUSW__Amount_Tendered__c =1000.00,Intake_Method__c='counter');
       
            //DOL_TestDataFactory.createReceipt('Credit Card',1000,'Counter');
        receiptRecord.MUSW__Payment_Method__c = 'CC';
        receiptRecord.MUSW__Card_Type__c = 'MC';
        receiptRecord.BGBK__Cart__c =objCart.Id;
        insert receiptRecord;
        
         Id businessAccount = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Business Account').getRecordTypeId();
        Account acc= DOL_TestDataFactory.createAccount(businessAccount);
        acc.Email__c = 'test@mailinator.com';
        update acc;
        
        Id businessLicenseType = Schema.SObjectType.MUSW__License2__c.getRecordTypeInfosByName().get('Business').getRecordTypeId();
        MUSW__License2__c lic = DOL_TestDataFactory.createLicense(businessLicenseType, acc.Id, 'Architects', 'Architect', 'General Application');
        
        MUSW__Fee__c objFee = DOL_TestDataFactory.createFeeWithLicense('General',100.00,lic.id);
           
        
        MUSW__Fee_Payment__c objFeePayment = new MUSW__Fee_Payment__c(  MUSW__Payment_Amount__c =100.00);
        objFeePayment.MUSW__Receipt__c=receiptRecord.Id;    
        objFeePayment.MUSW__Fee__c=objFee.id;
        insert objFeePayment;
        

    }
    public static testmethod void testRecieptMethod(){
        Test.startTest();
         Id cashRegRecTypeId = Schema.SObjectType.Cash_Register__c.getRecordTypeInfosByName().get('Cash Register').getRecordTypeId();
        // Insert cashRegister
        Cash_Register__c cashRegisterRecord = DOL_TestDataFactory.createValidationRoomCashRegister(cashRegRecTypeId,100.0,200.0,300.0,400.0);
        
        BGBK__Payment_Batch__c pb = DOL_TestDataFactory.createPaymentBatch(cashRegisterRecord.Id);
        
        BGBK__Cart__c cartRecord = DOL_TestDataFactory.createCartRecord(pb.Id);
        
        MUSW__Receipt__c receiptRecord = DOL_TestDataFactory.createReceipt('Credit Card',1000,'Counter');
        receiptRecord.BGBK__Cart__c= cartRecord.id;
        update receiptRecord;
        System.assertEquals(receiptRecord.BGBK__Cart__c!=null, true);
        
        ReceiptTriggerHandler rec = new ReceiptTriggerHandler();
        rec.onBeforeDelete();
        rec.onBeforeUndelete();
        Test.stopTest();
        
    }
    
    public static testmethod void handleDeleteScenario(){
        Test.startTest();
        
        Id businessAccount = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Business Account').getRecordTypeId();
        Account acc= DOL_TestDataFactory.createAccount(businessAccount);
        acc.Email__c = 'test@mailinator.com';
        update acc;
        
        Id businessLicenseType = Schema.SObjectType.MUSW__License2__c.getRecordTypeInfosByName().get('Business').getRecordTypeId();
        //MUSW__License2__c lic = DOL_TestDataFactory.createLicense(businessLicenseType, acc.Id, 'Architects', 'Architect', 'General Application');
        
        BGBK__Payment_Batch__c objPaymentBatch = new BGBK__Payment_Batch__c();
        objPaymentBatch.Name ='test';
        insert objPaymentBatch;
        BGBK__Cart__c objCart= DOL_TestDataFactory.createCartRecord(objPaymentBatch.Id);
        
        
        MUSW__Receipt__c receiptRecord = new MUSW__Receipt__c(MUSW__Payment_Method__c = 'Credit Card'  ,MUSW__Amount_Tendered__c =1000.00,Intake_Method__c='counter');
       
            //DOL_TestDataFactory.createReceipt('Credit Card',1000,'Counter');
        receiptRecord.MUSW__Payment_Method__c = 'CC';
        receiptRecord.MUSW__Card_Type__c = 'MC';
        receiptRecord.BGBK__Cart__c =objCart.Id;
        //insert receiptRecord;
        MUSW__Receipt__c receiptRecordtoUpdate  =[select id,MUSW__Payment_Method__c,MUSW__Card_Type__c,BGBK__Cart__c,MUSW__Amount_Tendered__c,Intake_Method__c from MUSW__Receipt__c limit 1]; 
        receiptRecordtoUpdate.BGBK__Cart__c =objCart.Id;
        receiptRecordtoUpdate.DHP__c = true;
        receiptRecordtoUpdate.Agency_Code__c ='3000';
            update receiptRecordtoUpdate;
        //delete receiptRecord;
        
        
        MUSW__Receipt__c receiptRecord1 = DOL_TestDataFactory.createReceipt('Credit Card',1000,'Counter');
        receiptRecord1.MUSW__Payment_Method__c = 'CC';
        receiptRecord1.MUSW__Card_Type__c ='VISA';
        receiptRecord.BGBK__Cart__c =objCart.Id;
        receiptRecord1.DHP__c = true;
        insert receiptRecord;
        update receiptRecord1;
        delete receiptRecord;
        undelete receiptRecord;
        
        MUSW__Receipt__c receiptRecord2 = DOL_TestDataFactory.createReceipt('Credit Card',1000,'Counter');
        receiptRecord2.MUSW__Payment_Method__c = 'CC';
        receiptRecord2.MUSW__Card_Type__c ='AMEX';
        receiptRecord2.DHP__c = true;
        receiptRecord2.Agency_Code__c ='3000';
        update receiptRecord2;
        
       // MUSW__Fee__c objFee = DOL_TestDataFactory.createFeeWithLicense('General',100.00,lic.id);
        
       // MUSW__Fee_Payment__c feePayment = new MUSW__Fee_Payment__c(MUSW__Payment_Amount__c=100.0,DHP_Amount__c=100.0,MUSW__Receipt__c=receiptRecord2.id,MUSW__Fee__c=objFee.id);
        //insert  feePayment;  
        //ReceiptTriggerHandler rd = new ReceiptTriggerHandler();
        //RunTriggerDispatcher.Run(rd);
        Test.stopTest();
    }
    
    public static testmethod void insertCustomSetting(){
        Global_Settings__c setting = new Global_Settings__c(SetupOwnerId=UserInfo.getUserId(),Disable_Triggers__c=true);
        upsert setting;
        

    }
    public static testmethod  void testmethod3(){
        MUSW__Receipt__c receiptRecordtoUpdate  =[select id,MUSW__Payment_Method__c,MUSW__Card_Type__c,BGBK__Cart__c,MUSW__Amount_Tendered__c,Intake_Method__c from MUSW__Receipt__c limit 1]; 
        //receiptRecordtoUpdate.BGBK__Cart__c =objCart.Id;
        receiptRecordtoUpdate.DHP__c = true;
        receiptRecordtoUpdate.Agency_Code__c ='3000';
        receiptRecordtoUpdate.MUSW__Payment_Method__c ='Check/Cashier\'s Check';
            update receiptRecordtoUpdate;
    }
    public static testmethod  void testmethod4(){
        MUSW__Receipt__c receiptRecordtoUpdate  =[select id,MUSW__Payment_Method__c,MUSW__Card_Type__c,BGBK__Cart__c,MUSW__Amount_Tendered__c,Intake_Method__c from MUSW__Receipt__c limit 1]; 
        //receiptRecordtoUpdate.BGBK__Cart__c =objCart.Id;
        receiptRecordtoUpdate.DHP__c = true;
        receiptRecordtoUpdate.Agency_Code__c ='3000';
        receiptRecordtoUpdate.MUSW__Payment_Method__c ='Cash';
            update receiptRecordtoUpdate;
    }
     public static testmethod  void testmethod6(){
         MUSW__Receipt__c receiptRecord = new MUSW__Receipt__c(MUSW__Payment_Method__c = 'Credit Card'  ,MUSW__Amount_Tendered__c =1000.00,Intake_Method__c='counter');
       
            //DOL_TestDataFactory.createReceipt('Credit Card',1000,'Counter');
        receiptRecord.MUSW__Payment_Method__c = 'CC';
        receiptRecord.MUSW__Card_Type__c = 'AMEX';
        //receiptRecord.BGBK__Cart__c =objCart.Id;
        insert receiptRecord;
    }
    public static testmethod  void testmethod5(){
         MUSW__Receipt__c receiptRecord = new MUSW__Receipt__c(MUSW__Payment_Method__c = 'Credit Card'  ,MUSW__Amount_Tendered__c =1000.00,Intake_Method__c='counter');
       
            //DOL_TestDataFactory.createReceipt('Credit Card',1000,'Counter');
        receiptRecord.MUSW__Payment_Method__c = 'CC';
        receiptRecord.MUSW__Card_Type__c = 'VISA';
        //receiptRecord.BGBK__Cart__c =objCart.Id;
        insert receiptRecord;
    }
        
}