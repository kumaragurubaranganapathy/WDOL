/**
* User Story:  
* Name: DRE2_Exam_Custom_Test
* Type: Test Class
* Description: Class to create Test Data and test the execution of AutoCloseAbandonedPTOTitlePRBatch
* Date:        Developer/Company                    Description
* ---------------------------------------------------------------------------------------------------------------------------------------- *
* 10/22/2018   Sharad Maheshwari/Deloitte           Initial Creation
**/
@isTest
public class DRE2_Exam_Custom_Test {
    
    @isTest
    public static void AutoCloseAbandonedCredentialBatchTest1() {
       Exam_Schedule__c examScheduleRecord = new Exam_Schedule__c(Name = 'Test Schedule',
                                        Exam_Date__c=System.today(),
                                        Time_of_Exam__c = Time.newInstance(0, 2, 2, 0),
                                        Exam_Location__c = 'Anywhere',
                                        Maximum_Capacity__c = 10);
        insert examScheduleRecord;
        
        
        Exam__c examRecord = new Exam__c(Exam_Type__c = 'Soil Tester Exam',
                                        Status__c='New',
                                        Exam_Schedule__c = examScheduleRecord.Id);
        insert examRecord;
    }

}