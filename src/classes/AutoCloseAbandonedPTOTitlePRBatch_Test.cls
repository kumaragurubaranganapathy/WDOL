/**
* User Story:  285- Automatically abandoning applications
* Name: AutoCloseAbandonedPTOTitlePRBatch_Test
* Type: Test Class
* Description: Class to create Test Data and test the execution of AutoCloseAbandonedPTOTitlePRBatch
* Date:        Developer/Company                    Description
* ---------------------------------------------------------------------------------------------------------------------------------------- *
* 07/27/2018   Sharad Maheshwari/Deloitte           Initial Creation
**/
@isTest
public class AutoCloseAbandonedPTOTitlePRBatch_Test {            
    @isTest
    public static void AutoCloseAbandonedCredentialBatchTest1() {
        
        Name_Value_Pair__mdt days = [select Value__c from Name_Value_Pair__mdt where Label = :Label.Str_AutoClosePermitsIn_nDays];
        String autoClosePermitDays = days.Value__c;
        String staticResourceName = 'permitTestData';
    	List<sObject> permitList = Test.loadData(MUSW__Permit2__c.sObjectType, staticResourceName);
        Test.startTest();    
        String autoClosePermitQuery = 'SELECT Id, Name, Application_Type__c, Program_Area__c, Permit_Type__c, MUSW__Status__c '+
                ' FROM MUSW__Permit2__c'+
                ' WHERE MUSW__Status__c = \''+Label.ST_In_Review+'\''+
                ' AND Sub_Status__c = \''+ Label.ST_Additional_Information_Required +'\''+
        		' AND LastModifiedDate < LAST_N_DAYS:'+autoClosePermitDays+'' +
            	' AND Application_Type__c IN (\'' + Label.Str_Permit_to_Operate + '\',' + '\'' + Label.Str_Manufactured_Homes_Communities +'\')';          
        //System.debug('autoClosePermitQuery '+autoClosePermitQuery);
        AutoCloseAbandonedPTOTitlePRBatch batchToExecute = new AutoCloseAbandonedPTOTitlePRBatch(autoClosePermitQuery);
        /*Execute batch- AutoCloseAbandonedCredentialBatch to auto close abandoned applications*/
        Database.executeBatch(batchToExecute, 1);    
        Test.stopTest();
        
        List<MUSW__Permit2__c> autoClosedPermitsList = new List<MUSW__Permit2__c>();          
        /*Fetching the updated Id, Status and SubStatus for the above created Licenses*/    
        //System.debug('permitList >> '+permitList);
        autoClosedPermitsList = [SELECT Id, MUSW__Status__c
                            FROM MUSW__Permit2__c
                            WHERE ID IN :permitList];
    
        if(autoClosedPermitsList.size() > 0)    {               
                
        //Status should be changed to Withdrawn and Substatus to Inactive
        System.AssertEquals(Label.ST_Withdrawn,autoClosedPermitsList[0].MUSW__Status__c);               
        //System.AssertEquals('Inactive', autoClosedCredentialsList[0].Sub_Status__c);
            }    
    
        }
    
}