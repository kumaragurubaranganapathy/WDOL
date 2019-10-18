/* 
*Class Name   : LnP_ReceiptDHPPopupModalCtrl_Test
* Description  : Testclass for LnP_ReceiptDHPPopupModalCtrl
* Created By   : Shreya Surabhi
* Created On   : 19/09/2019 
* Modification Log:  
*------------------------------------------------------------------------------------------------------------------------------------------------------------------------
* Developer                    Date                        Description
Nidhi Inani					 10/18/2019					   Testclass for LnP_ReceiptDHPPopupModalCtrl
*------------------------------------------------------------------------------------------------------------------------------------------------------------------------
*
*/
@isTest
public class LnP_ReceiptDHPPopupModalCtrl_Test{
    public static testMethod void testMethod1(){
        LnP_ReceiptDHPPopupModalCtrl receiptDHPObj = new LnP_ReceiptDHPPopupModalCtrl();
        MUSW__Receipt__c rec1 = DOL_TestDataFactory.createReceipt('NCR - cash',10,'Validation Room');
        rec1.DHP__c=true;
        rec1.Inactivate_License_Date__c=System.today();
        update rec1;
        
        Id businessAccount = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Business Account').getRecordTypeId();
        Account acc= DOL_TestDataFactory.createAccount(businessAccount);
        acc.Email__c = 'test@mailinator.com';
        update acc;
        
        Id businessLicenseType = Schema.SObjectType.MUSW__License2__c.getRecordTypeInfosByName().get('Business').getRecordTypeId();
        MUSW__License2__c lic = DOL_TestDataFactory.createLicense(businessLicenseType, acc.Id, 'Architects', 'Architect', 'General Application');
        
        MUSW__Fee__c objFee = DOL_TestDataFactory.createFeeWithLicense('General',100.00,lic.id);
        
        MUSW__Fee_Payment__c objFeePayment = new MUSW__Fee_Payment__c(  MUSW__Payment_Amount__c =100.00);
        objFeePayment.MUSW__Receipt__c=rec1.Id;    
        objFeePayment.MUSW__Fee__c=objFee.id;
       // objFeePayment.Related_To_License__c=lic.id;
        insert objFeePayment;
        
        Master_ConfigData_Listing__c  mastConfig = new Master_ConfigData_Listing__c();
        mastConfig.License_Type__c='Architect';
        mastConfig.Program_Type__c='Architects';
        mastConfig.Profession_Code__c='123';
        mastConfig.Revenue_Account_Code__c='567';
        mastConfig.Listing_Type__c='Product Revenue Code';
        insert mastConfig; 
        try{
            LnP_ReceiptDHPPopupModalCtrl.saveLicenseandReceipt(rec1.Id);
        }
        catch(Exception e){
            DOL_CreateErrorLog_Exception.logApplicationError(e);
       //     System.debug('Error');
        }
    }
}