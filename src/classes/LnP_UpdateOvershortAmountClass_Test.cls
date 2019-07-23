/* 
*Class Name   : LnP_UpdateOvershortAmountClass_Test
* Description  : Testclass for LnP_UpdateOvershortAmountClass
* Created By   : Chiranth Aradhya
* Created On   : 07/03/2019 
* Modification Log:  
*------------------------------------------------------------------------------------------------------------------------------------------------------------------------
* Developer                    Date                        Description
*------------------------------------------------------------------------------------------------------------------------------------------------------------------------
*
*/
@isTest
public class LnP_UpdateOvershortAmountClass_Test {
    
    
    static testMethod void testMethod1(){
        
        Account testAccount = CreateTestDataUtility.createAccount();       
        insert testAccount;
        
        System.assertNotEquals(testAccount.Id, null);
        
        Contact testContact = CreateTestDataUtility.createContact(testAccount.id);  
        insert testContact;
        
        /*
        MUSW__License2__c testLicense = CreateTestDataUtility.createLicense(testAccount.id, testContact.id); //License
        testLicense.MUSW__Status__c = 'Active';
        insert testLicense; 
        */
        
        
        BGBK__Cart__c testCart = new BGBK__Cart__c(BGBK__Account__c= testContact.AccountId, BGBK__Contact__c= testContact.Id, BGBK__Expiration_DateTime__c=system.now().addDays(1));
        insert testCart;
        
       
        
        MUSW__Fee__c f1 = new MUSW__Fee__c(MUSW__Amount__c=0.1, BGBK__Cart__c = testCart.Id);
        MUSW__Fee__c f2 = new MUSW__Fee__c(MUSW__Amount__c=0.2,  BGBK__Cart__c = testCart.Id);
        MUSW__Fee__c[] fees = new MUSW__Fee__c[]{f1,f2};
        insert fees;
        
        Double totalDue = 0;
        List<String> feeIds = new List<String>();
        for(MUSW__Fee__c fee : fees){
            feeIds.add(fee.id);
            totalDue += fee.MUSW__Amount__c;
        }
        
        // create Receipt
        MUSW__Receipt__c receipt = new MUSW__Receipt__c();
        receipt.BGBK__Cart__c = testCart.Id;
        receipt.Status__c = 'Draft';
        receipt.MUSW__Amount_Available__c = 10;
        receipt.Selected_Fees__c = String.join(feeIds,',');
        insert receipt;
        
        MUSW__Deposit__c dep = new MUSW__Deposit__c();
        dep.wadol_Program_Type__c='Geologist';
        dep.MUSW__Transfered_In_Amount__c = 10;
        insert dep;
        
        
        LnP_UpdateOvershortAmountClass.updateovershortdepositMethod(dep.Id);
        LnP_UpdateOvershortAmountClass.updateovershortreceiptMethod(receipt.Id);
        //LnP_UpdateOvershortAmountClass.payFromOverShort(fees[0].Id);
        
        
    }

}