@isTest
public class Dol_UBISearchTransform_test{
    @isTest
    public static void transformAndSave_Test(){
         Account acc = new Account(name = DOL_AppConstants.NULL_EMPTY_STRING + 'testaccount');
         insert acc;
         contact con = new contact(LastName = DOL_AppConstants.NULL_EMPTY_STRING + 'test Last' , Accountid = acc.id, UBI_Number__c = DOL_AppConstants.NULL_EMPTY_STRING + 'ubi');
         insert con;
         test.startTest();
         	Dol_UBISearchTransform.transformAndSave (con.id, con.UBI_Number__c);
         test.stopTest();
    }
}