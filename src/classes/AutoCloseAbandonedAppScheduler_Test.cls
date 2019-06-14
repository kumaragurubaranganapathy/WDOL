/**
* User Story:  285- Automatically abandoning applications
* Name: AutoCloseAbandonedAppScheduler_Test
* Type: Test Class
* Description: Test class for corresponding Scheduler class - AutoCloseAbandonedAppScheduler
* Date:        Developer/Company                    Description
* ---------------------------------------------------------------------------------------------------------------------------------------- *
* 08/03/2018   Sharad Maheshwari/Deloitte           Initial Creation
**/

@isTest
public class AutoCloseAbandonedAppScheduler_Test {

    public static testMethod void testscheduler()     {
        Test.startTest();
        List<sObject> ls = Test.loadData(MUSW__License2__c.sObjectType,'credentialTestData'); 
        List<sObject> ls1 = Test.loadData(MUSW__Permit2__c.sObjectType,'permitTestData'); 
        AutoCloseAbandonedAppScheduler ACAAS = new AutoCloseAbandonedAppScheduler ();
        String schedule = '0 0 23 * * ?';
        System.Schedule('To Test AutoCloseAbandonedAppScheduler', schedule, ACAAS);
        AutoCloseAbandonedPermitScheduler ACAPS = new AutoCloseAbandonedPermitScheduler ();
        String schedulePermitBatch = '0 0 23 * * ?';
        System.Schedule('To Test AutoCloseAbandonedPermitScheduler', schedulePermitBatch, ACAPS);
        Test.stopTest();
    }
}