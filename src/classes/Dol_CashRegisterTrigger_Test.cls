@isTest
public class Dol_CashRegisterTrigger_Test {
    @isTest
    public static void validateHandleBeforeInsert() {
        Id validationRoomRecTypeId = Schema.SObjectType.Cash_Register__c.getRecordTypeInfosByName().get('Validation Room').getRecordTypeId();
        Test.startTest();
        try{
            MUSW__Receipt__c rec1 = DOL_TestDataFactory.createReceipt('NCR - cash',10,'Validation Room');
            MUSW__Receipt__c rec2 = DOL_TestDataFactory.createReceipt('NCR - check',10,'Validation Room');
            MUSW__Receipt__c rec3 = DOL_TestDataFactory.createReceipt('Cash',10,'Validation Room');
            MUSW__Receipt__c rec4 = DOL_TestDataFactory.createReceipt('Check/Cashier\'s Check',10,'Validation Room');
            MUSW__Receipt__c rec5 = DOL_TestDataFactory.createReceipt('Vitalcheck',10,'Validation Room');
            
            Cash_Register__c cashRegister = DOL_TestDataFactory.createValidationRoomCashRegister(validationRoomRecTypeId, 100, 100, 100, 100);
        }catch(Exception ex){
            //System.debug('ex:'+ex.getMessage());
            system.assert(ex.getMessage().contains('is not matching'));
        }
        test.stopTest();
    }
}