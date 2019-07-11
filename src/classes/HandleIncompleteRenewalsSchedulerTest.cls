@istest
public class HandleIncompleteRenewalsSchedulerTest {
    
	 public static testmethod void  testschedule() {
        Test.StartTest();
        List<sObject> ls = Test.loadData(MUSW__License2__c.sObjectType,'credentialsWithExpirationDate'); 
         System.assert(ls.size() == 4);
         musw__license2__c license2 = (musw__license2__c)ls[1];
         license2.MUSW__Status__c = 'Active';
         license2.musw__expiration_date__c = date.parse('11/28/2018');
         license2.CE_Hours__c = 5;         
		update license2;         
         System.debug('license2.Is_Late_Renewal_Eligible__c ' + license2.Is_Late_Renewal_Eligible__c);
         System.debug('license2.CE_Hours_per_Cycle__c ' + license2.CE_Hours_per_Cycle__c);
         System.debug('license2.MUSW__Expiration_Date__c ' + license2.MUSW__Expiration_Date__c);
         System.debug('license2.Renewal_Cycle_End_Date__c ' + license2.Renewal_Cycle_End_Date__c);
        HandleIncompleteRenewalsScheduler sh1 = new HandleIncompleteRenewalsScheduler();      
        String sch = '0 0 23 * * ?';
        system.schedule('Test check', sch, sh1);
        Test.stopTest();
    }
    
    public static testmethod void  testschedule2() {
        Test.StartTest();
        List<sObject> ls = Test.loadData(MUSW__License2__c.sObjectType,'credentialsWithExpirationDate'); 
         System.assert(ls.size() == 4);
         musw__license2__c license1 = (musw__license2__c)ls[2];
		 license1.musw__status__c = 'Expired';
         license1.musw__expiration_date__c = date.parse('11/25/2018');
         license1.Late_Renewal_Eligible_End_Date__c = date.parse('12/25/2018');
         license1.CE_Hours__c = 5;
        	
		update license1;   
        
        System.debug('license1.Is_Late_Renewal_Eligible__c ' + license1.Is_Late_Renewal_Eligible__c);
         System.debug('license1.CE_Hours_per_Cycle__c ' + license1.CE_Hours_per_Cycle__c);
         System.debug('license1.MUSW__Expiration_Date__c ' + license1.MUSW__Expiration_Date__c);
         System.debug('license1.Late_Renewal_Eligible_End_Date__c ' + license1.Late_Renewal_Eligible_End_Date__c);
         System.debug('license1.Renewal_Cycle_End_Date__c ' + license1.Renewal_Cycle_End_Date__c);
        
        HandleIncompleteRenewalsScheduler sh1 = new HandleIncompleteRenewalsScheduler();      
        String sch = '0 0 23 * * ?';
        system.schedule('Test check', sch, sh1);
        Test.stopTest();
    }
}