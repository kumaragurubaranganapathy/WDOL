@isTest
public class Dol_UBISearchTransform_test{
    @isTest
    public static void transformAndSave_Test(){
         Account acc = new Account(name = 'testaccount');
         insert acc;
         contact con = new contact(LastName = 'test Last' , Accountid = acc.id, UBI_Number__c = 'ubi');
         insert con;
         test.startTest();
         	Dol_UBISearchTransform.transformAndSave (con.id, con.UBI_Number__c);
         test.stopTest();
    }
}