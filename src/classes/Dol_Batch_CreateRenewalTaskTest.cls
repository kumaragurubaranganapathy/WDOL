@isTest
public class Dol_Batch_CreateRenewalTaskTest{
    
   @isTest
   static void method1(){
         
        MUSW__License2__c lic = new MUSW__License2__c();
        lic.Application_Type__c = 'Timeshares';
        lic.Credential_Type__c =  'Timeshare Salesperson';
        lic.Application_Method__c = 'General Application';
        lic.MUSW__Expiration_Date__c = System.today() + 5;
        lic.Renewal_Eligible_Start_Date__c = System.today() - 5;
        lic.MUSW__Status__c = 'Active';
        lic.Name ='System Number';
        test.startTest();
        insert lic;
        
        Dol_Batch_CreateRenewalTask batch1 = new Dol_Batch_CreateRenewalTask();
        Database.executebatch(batch1);
        test.stopTest();
   }



}