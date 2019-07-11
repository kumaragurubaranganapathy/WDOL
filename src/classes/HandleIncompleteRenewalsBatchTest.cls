@istest
public class HandleIncompleteRenewalsBatchTest {
    public static testMethod void testschedule()
    {
        List<Renewal_application__c> renapp= new List<Renewal_application__c>();
        
         MUSW__License2__c r= new MUSW__License2__c(Credential_Type__c='Dwelling Contractor',
                                                    Application_Type__c = 'Trades Credential',
                                                    Credential__c='Dwelling Contractor'
                                                   );
        Insert r;
        //for(Integer i=0 ;i <200;i++)
         //    {
             Renewal_application__c a = new Renewal_application__c();
                 a.CE_Hours__c = 	3+0;
                 a.License__c =r.ID;
            renapp.add(a);
          //   }
        
        insert renapp;
        MUSW__Review__c review = new MUSW__Review__c(MUSW__Status__c = Label.ST_Pending,
                                                    Renewal_Application__c = renapp[0].ID);
        insert review;
        Test.startTest();

            String q = 'select id, CE_Hours__c, License__r.CE_Hours_Per_Cycle__c, License__r.MUSW__Total_Balance__c  from Renewal_application__c';
            HandleIncompleteRenewalsBatch obj = new HandleIncompleteRenewalsBatch(q);
            DataBase.executeBatch(obj); 
            
        Test.stopTest();
    }
}