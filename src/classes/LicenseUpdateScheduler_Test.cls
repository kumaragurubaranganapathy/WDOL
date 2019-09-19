/**
* Name: LicenseUpdateScheduler_Test
* Type: Test Class
* Description: Inactivating License Records on nightly basis 
* Date:        Developer/Company                    Description
* ---------------------------------------------------------------------------------------------------------------------------------------- *
* 5-13-2019   Padmavathi D/Deloitte           Initial Creation
**/
@isTest
public class LicenseUpdateScheduler_Test {
    @isTest
    static void schedule(){
        Test.startTest();
        LicenseUpdateScheduler rds = new LicenseUpdateScheduler();
        string schedule = DOL_AppConstants.NULL_EMPTY_STRING + '0 0 23 * * ?';
        system.schedule('Test License Record Deactivation', schedule, rds);
        Test.stopTest();
    } 
 }