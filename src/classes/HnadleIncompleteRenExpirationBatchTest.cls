@istest
public class HnadleIncompleteRenExpirationBatchTest {
    public static testMethod void testschedule1()
    {
        List<MUSW__License2__c> renapp= new List<MUSW__License2__c>();
               // for(Integer i=0 ;i<200;i++)
                {
             MUSW__License2__c a = new MUSW__License2__c();
                 a.Credential_Type__c='Soil Professions';
                 a.Application_Type__c = 'Trades Credential';
                 a.Credential__c='Soil Tester';
                 a.CE_Hours__c =3;
                 a.MUSW__Expiration_Date__c= Date.newInstance(2018, 10, 10);
                 a.Late_Renewal_Eligible_End_Date__c = Date.newInstance(2019,09, 17);
                 renapp.add(a);
                }
        insert renapp;
       // MUSW__Fee__c f = new MUSW__Fee__c();
        //Renewal_application__c r = new Renewal_application__c();
        //renapp.add(r);
     //   MUSW__License2__c lic = [select Id,CE_Hours_per_Cycle__c from MUSW__License2__c where id=: a.Id];
        //system.debug('error message' +lic.CE_Hours_per_Cycle__c);
        Test.startTest();

            String q = 'select id, CE_Hours__c, Credential__c, CE_Hours_per_Cycle__c, Is_Late_Renewal_Eligible__c, MUSW__Expiration_Date__c, Credential_Type__c, Application_Type__c, Renewal_Cycle_End_Date__c, Renewal_Window__c,MUSW__Status__c  from MUSW__License2__c';
            HandleIncompleteRenewalsExpirationBatch obj = new HandleIncompleteRenewalsExpirationBatch(q);
        System.debug('obj' +obj);
            DataBase.executeBatch(obj); 
            
        Test.stopTest();
    }
   
}