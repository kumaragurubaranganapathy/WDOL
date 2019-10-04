@isTest
public class Dol_UBISearchTransform_test{
    @isTest
    public static void transformAndSave_Test(){
         Account acc = new Account(name = 'testaccount',UBI_Number__c = '123456789');
         insert acc;
         Account acc2 = new Account(name = 'SEATTLE SOUNDERS, LLC',UBI_Number__c = '123456789');
         insert acc2;
         contact con = new contact(LastName = 'test Last' , Accountid = acc.id, Unique_ID_To_Provide__c = 'SSN');
         insert con;
         MUSW__Account_Contact__c  acctCon = new MUSW__Account_Contact__c();
             acctCon.First_Name__c = 'amin';
             acctCon.Last_Name__c = 'peter';
             acctCon.MUSW__Account__c = acc2.id;
        insert acctCon;
        //Select id,Title__c,Last_Name__c,Middle_Name__c,First_Name__c from MUSW__Account_Contact__c where MUSW__Account__c =:accountId AND MUSW__Account__c != null];
         test.startTest();
         	Dol_UBISearchTransform.getAccountUBI(acc.id);
         	Dol_UBISearchTransform.transformAndSave (acc.id, '123-345-5678');
        	Dol_UBISearchTransform.transformAndSave (acc2.id, '123-345-5678');
         test.stopTest();
    }
    @isTest
    public static void transformAndSave_Test2(){
         Account acc = new Account(name = 'testaccount',UBI_Number__c = '123456789');
         insert acc;
         Account acc2 = new Account(name = 'SEATTLE SOUNDERS, LLC',UBI_Number__c = '123456789');
         insert acc2;
         contact con = new contact(LastName = 'test Last' , Accountid = acc.id, Unique_ID_To_Provide__c = 'SSN');
         insert con;
         /*MUSW__Account_Contact__c  acctCon = new MUSW__Account_Contact__c();
             acctCon.First_Name__c = 'amin';
             acctCon.Last_Name__c = 'peter';
             acctCon.MUSW__Account__c = acc2.id;
        insert acctCon;*/
        //Select id,Title__c,Last_Name__c,Middle_Name__c,First_Name__c from MUSW__Account_Contact__c where MUSW__Account__c =:accountId AND MUSW__Account__c != null];
         test.startTest();
         	Dol_UBISearchTransform.getAccountUBI(acc.id);
         	Dol_UBISearchTransform.transformAndSave (acc.id, '123-345-5678');
        	Dol_UBISearchTransform.transformAndSave (acc2.id, '123-345-5678');
         test.stopTest();
    }
}