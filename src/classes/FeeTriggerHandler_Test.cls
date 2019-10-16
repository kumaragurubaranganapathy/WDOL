@isTest
public class FeeTriggerHandler_Test {

    @isTest
    public static void test_method_one(){
       
        test.startTest();
        Id accRecId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('User Account').getRecordTypeId();
        Account acc = DOL_TestDataFactory.createAccount(accRecId);
        
        Id conRecId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Contact').getRecordTypeId();
        Contact c = DOL_TestDataFactory.createContact(conRecId, acc.Id);
        
        Contact cq = [select AccountId from Contact where Id=:c.Id];

        MUSW__Account_Contact__c accCon = new MUSW__Account_Contact__c(MUSW__Account__c=acc.Id,	
                                                                       MUSW__Contact__c=c.Id);
        insert accCon;
                
        BGBK__Cart__c testCart = new BGBK__Cart__c(BGBK__Account__c= cq.AccountId, 
                                                   BGBK__Contact__c= cq.Id, 
                                                   BGBK__Expiration_DateTime__c=system.now().addDays(1));
        insert testCart;
        
        Id LicenseRecType = Schema.SObjectType.MUSW__License2__c.getRecordTypeInfosByName().get('Individual').getRecordTypeId();
        MUSW__License2__c lic = DOL_TestDataFactory.createLicense(LicenseRecType, acc.Id, 'Architects', 'Architect', 'General Application');
        
        MUSW__Fee__c objFee = DOL_TestDataFactory.createFeeWithLicense('General',100.00,lic.id);
        objFee.BGBK__Cart__c = testCart.Id;
        update objFee;
        
        MUSW__Fee__c objFee2 = DOL_TestDataFactory.createFeeWithLicense('Trust Expense - Staff Hours',100.00,lic.id);
        objFee2.BGBK__Cart__c = testCart.Id;
        update objFee2; 
        
        objFee.MUSW__Type__c = 'Trust Expense - Mileage';
        //System.debug('objFee---'+objFee);
        update objFee;
        
        Double totalDue = 0;
        
        List<String> feeIds = new List<String>();
        feeIds.add(objFee.Id);
        totalDue = objFee.MUSW__Amount__c;
        
                
        // create Receipt
        MUSW__Receipt__c receipt = new MUSW__Receipt__c();
        receipt.BGBK__Cart__c = testCart.Id;
        receipt.Status__c = 'Draft';
        receipt.Selected_Fees__c = String.join(feeIds,',');
        insert receipt;
        
        test.stopTest();
    }
      @isTest
    public static void test_method_two(){
       
        test.startTest();
        Global_Settings__c gs = new Global_Settings__c(Name = 'Gs', Disable_Triggers__c = true);
        insert gs;
        
        Id accRecId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('User Account').getRecordTypeId();
        Account acc = DOL_TestDataFactory.createAccount(accRecId);
        
        Id conRecId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Contact').getRecordTypeId();
        Contact c = DOL_TestDataFactory.createContact(conRecId, acc.Id);
        
        Contact cq = [select AccountId from Contact where Id=:c.Id];

        MUSW__Account_Contact__c accCon = new MUSW__Account_Contact__c(MUSW__Account__c=acc.Id,	
                                                                       MUSW__Contact__c=c.Id);
        insert accCon;
                
        BGBK__Cart__c testCart = new BGBK__Cart__c(BGBK__Account__c= cq.AccountId, 
                                                   BGBK__Contact__c= cq.Id, 
                                                   BGBK__Expiration_DateTime__c=system.now().addDays(1));
        insert testCart;
        
        Id LicenseRecType = Schema.SObjectType.MUSW__License2__c.getRecordTypeInfosByName().get('Individual').getRecordTypeId();
        MUSW__License2__c lic = DOL_TestDataFactory.createLicense(LicenseRecType, acc.Id, 'Architects', 'Architect', 'General Application');
        
        MUSW__Fee__c objFee = DOL_TestDataFactory.createFeeWithLicense('General',100.00,lic.id);
        objFee.BGBK__Cart__c = testCart.Id;
        update objFee;
        
        MUSW__Fee__c objFee2 = DOL_TestDataFactory.createFeeWithLicense('Trust Expense - Staff Hours',100.00,lic.id);
        objFee2.BGBK__Cart__c = testCart.Id;
        update objFee2; 
        
        objFee.MUSW__Type__c = 'Trust Expense - Mileage';
        //System.debug('objFee---'+objFee);
        update objFee;
        
        Double totalDue = 0;
        
        delete objFee;
        
        undelete objFee;
       
        List<String> feeIds = new List<String>();
        feeIds.add(objFee.Id);
        totalDue = objFee.MUSW__Amount__c;
        
                
        // create Receipt
        MUSW__Receipt__c receipt = new MUSW__Receipt__c();
        receipt.BGBK__Cart__c = testCart.Id;
        receipt.Status__c = 'Draft';
        receipt.Selected_Fees__c = String.join(feeIds,',');
        insert receipt;
        
       
        test.stopTest();
    }
}