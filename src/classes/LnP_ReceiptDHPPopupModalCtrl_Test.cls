/* 
*Class Name   : LnP_ReceiptDHPPopupModalCtrl_Test
* Description  : Testclass for LnP_ReceiptDHPPopupModalCtrl
* Created By   : Shreya Surabhi
* Created On   : 19/09/2019 
* Modification Log:  
*------------------------------------------------------------------------------------------------------------------------------------------------------------------------
* Developer                    Date                        Description
*------------------------------------------------------------------------------------------------------------------------------------------------------------------------
*
*/
@isTest
public class LnP_ReceiptDHPPopupModalCtrl_Test{
    public static testMethod void testMethod1(){
        LnP_ReceiptDHPPopupModalCtrl receiptDHPObj = new LnP_ReceiptDHPPopupModalCtrl();
        MUSW__Receipt__c receiptObj = DOL_TestDataFactory.createReceipt('Credit Card',200.0,'Portal');
        receiptObj.Override_25_Handling_Fee__c = False;
        receiptObj.DHP__c = True;
        receiptObj.Inactivate_License_Date__c = System.today();
        update receiptObj;
        try{
            LnP_ReceiptDHPPopupModalCtrl.saveLicenseandReceipt(receiptObj.Id);
        }
        catch(Exception e){
            DOL_CreateErrorLog_Exception.logApplicationError(e);
       //     System.debug('Error');
        }
    }
}