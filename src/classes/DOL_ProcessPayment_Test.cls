@IsTest
public class DOL_ProcessPayment_Test {
    
    @IsTest
    public static void testNCRPayment(){
        Id accRecId = SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Business_Account').getRecordTypeId();
        Account acc = DOL_TestDataFactory.createAccount(accRecId);
        
        Id conRecId = SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('Contact').getRecordTypeId();
        Contact c = DOL_TestDataFactory.createContact(conRecId, acc.Id);
		        
        Contact cq = [select AccountId from Contact where Id=:c.Id];

        MUSW__Account_Contact__c accCon = new MUSW__Account_Contact__c(MUSW__Account__c=acc.Id,	
                                                                       MUSW__Contact__c=c.Id);
        insert accCon;
                
        BGBK__Cart__c testCart = new BGBK__Cart__c(BGBK__Account__c= cq.AccountId, 
                                                   BGBK__Contact__c= cq.Id, 
                                                   BGBK__Expiration_DateTime__c=system.now().addDays(1));
        insert testCart;
        
        Id businessLicenseType = Schema.SObjectType.MUSW__License2__c.getRecordTypeInfosByName().get('Business').getRecordTypeId();
        MUSW__License2__c lic = DOL_TestDataFactory.createLicense(businessLicenseType, 
                                                                  acc.Id, 
                                                                  'Architects', 
                                                                  'Architect', 
                                                                  'General Application');
        
        MUSW__Fee__c objFee = DOL_TestDataFactory.createFeeWithLicense('General',100.00,lic.id);
        objFee.BGBK__Cart__c = testCart.Id;
        update objFee;
        
        List<String> feeIds = new List<String>();
        feeIds.add(objFee.Id);
        
        MUSW__Receipt__c receipt = new MUSW__Receipt__c();
        receipt.Status__c = 'Draft';
        receipt.Selected_Fees__c = String.join(feeIds,',');
        receipt.MUSW__Payment_Method__c = 'Credit Card';
        insert receipt;
        
        DOL_ProcessPayment processPayment = new DOL_ProcessPayment(c.Id,testCart.Id,feeIds,receipt,100.00);
        try{
            processPayment.doPaymentForNCR();
        }
        catch(Exception e){
            System.debug('error :: '+e.getMessage()+' stackTrace :: '+e.getStackTraceString());
        }
    }

}