@isTest
public class LnP_comHeaderPublicFormsApexCtrlTest {
    @isTest
    public static void testMethod1(){
     Id AccRecTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Business Account').getRecordTypeId();
        Account a = DOL_TestDataFactory.createAccount(AccRecTypeId);
        Id conRecTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Contact').getRecordTypeId();
        Contact con = DOL_TestDataFactory.createContact(conRecTypeId,a.Id);
        LnP_comHeaderPublicFormsApexController.getCommonHeaderCustomLabels();
        try{
            LnP_comHeaderPublicFormsApexController.getCurrentUserInfo();
        }catch(Exception ex){}
        LnP_comHeaderPublicFormsApexController.getContactUserInfo(con.Id);
        
        
    }

}