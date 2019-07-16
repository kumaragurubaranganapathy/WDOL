/**
* User Story: 212 - Deletion of Records
* Name: RecordDeletionScheduler_Test
* Type: Test Class
* Description: Test Class for RecordDeletionScheduler
* Date:        Developer/Company                    Description
* ---------------------------------------------------------------------------------------------------------------------------------------- *
* 07/30/2018   Srikanth Kottam/Deloitte           Initial Creation
**/
@isTest
public class RecordDeletionScheduler_Test {
    @isTest
    static void schedule(){
        Test.startTest();
        RecordDeletionScheduler rds = new RecordDeletionScheduler();
        string schedule = '0 0 23 * * ?';
        system.schedule('Test Record Deletion', schedule, rds);
        Test.stopTest();
    } 

}