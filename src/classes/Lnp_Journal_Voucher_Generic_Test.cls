@isTest
public class Lnp_Journal_Voucher_Generic_Test {
    @isTest static void test_method_one(){
        BGBK__Fund2__c objFund = new BGBK__Fund2__c(Name='01P-xx-xx-xxxxxx-5199-A');
        insert objFund;
        
        MUSW__Receipt__c objReceipt = new MUSW__Receipt__c(MUSW__Payment_Method__c ='Lockbox',Intake_Method__c='Validation Room');
        insert objReceipt;
        
        Id businessAccount = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Business Account').getRecordTypeId();
        Account acc= DOL_TestDataFactory.createAccount(businessAccount);
        acc.Email__c = 'test@mailinator.com';
        update acc;
        
        Id businessLicenseType = Schema.SObjectType.MUSW__License2__c.getRecordTypeInfosByName().get('Business').getRecordTypeId();
        MUSW__License2__c lic = DOL_TestDataFactory.createLicense(businessLicenseType, acc.Id, 'Architects', 'Architect', 'General Application');
        
        MUSW__Fee__c objFee = DOL_TestDataFactory.createFeeWithLicense('General',100.00,lic.id);
           
        
        MUSW__Fee_Payment__c objFeePayment = new MUSW__Fee_Payment__c(  MUSW__Payment_Amount__c =100.00);
        objFeePayment.MUSW__Receipt__c=objReceipt.Id;    
        objFeePayment.MUSW__Fee__c=objFee.id;
		insert objFeePayment;
        
        JV_Sequence__c objJVSeq = new JV_Sequence__c(Current_sequence__c =0.0);
        insert objJVSeq;
        
        BGBK__Transaction__c objTransaction = new BGBK__Transaction__c(BGBK__Type__c='Fee');
        insert objTransaction;
        
        BGBK__Item__c objItem = new BGBK__Item__c(BGBK__Type__c='965X',BGBK__Price_Per_Unit__c=10.00,BGBK__Quantity__c=1);
        objItem.Fee_Payment__c =objFeePayment.id;
        objItem.BGBK__Transaction__c=objTransaction.id;
        objItem.BGBK__Fund__c=objFund.id;
		insert objItem;  
        objItem=[select Payment_Method__c,Debit_Credit__c,Intake_Method__c,BGBK__Fund__r.GL__c,Transaction_Code__c,BGBK__Fund__r.Accounting_System__c from BGBK__Item__c where id=:objItem.Id];
        system.debug('item$$'+objItem.Debit_Credit__c+objItem.Payment_Method__c +objItem.Intake_Method__c+objItem.BGBK__Fund__r.GL__c+ objItem.Transaction_Code__c+objItem.BGBK__Fund__r.Accounting_System__c);
        test.startTest();
        //Lnp_Journal_Voucher_Generic objJV = new Lnp_Journal_Voucher_Generic();
	    //DataBase.executeBatch(objJV);
		Lnp_Journal_Voucher_Generic_SCHED sh1 = new Lnp_Journal_Voucher_Generic_SCHED();

		String sch = '0 0 23 * * ?'; 
        system.schedule('Test Territory Check', sch, sh1); 
        test.stopTest();
    }
}