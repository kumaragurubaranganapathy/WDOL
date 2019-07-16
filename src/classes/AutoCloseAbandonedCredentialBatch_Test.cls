/**
* User Story:  285- Automatically abandoning applications
* Name: AutoCloseAbandonedCredentialBatch_Test
* Type: Test Class
* Description: Class to create Test Data and test the execution of AutoCloseAbandonedCredentialBatch
* Date:        Developer/Company                    Description
* ---------------------------------------------------------------------------------------------------------------------------------------- *
* 07/27/2018   Sharad Maheshwari/Deloitte           Initial Creation
**/
@isTest
public class AutoCloseAbandonedCredentialBatch_Test {            
    @isTest
    public static void AutoCloseAbandonedCredentialBatchTest1() {
        
        Name_Value_Pair__mdt days = [select Value__c from Name_Value_Pair__mdt where Label = :Label.Str_AutoCloseCredentialsIn_nDays];
        String autoCloseCredentialDays = days.Value__c;
        String staticResourceName = 'credentialTestData';
    	List<sObject> credentialList = Test.loadData(MUSW__License2__c.sObjectType, staticResourceName);
        Test.startTest();    
        String query = 'SELECT Id, Name, Application_Type__c, Credential_Type__c, Credential__c, MUSW__Status__c '+
                ' FROM MUSW__License2__c'+
                ' WHERE MUSW__Status__c = \''+Label.ST_Pending+'\''+
                ' AND LastModifiedDate < LAST_N_DAYS:'+autoCloseCredentialDays+'';
           
        AutoCloseAbandonedCredentialBatch batchToExecute = new AutoCloseAbandonedCredentialBatch(query);
        /*Execute batch- AutoCloseAbandonedCredentialBatch to auto close abandoned applications*/
        Database.executeBatch(batchToExecute, 1);    
        Test.stopTest();
        
        List<MUSW__License2__c> autoClosedCredentialsList = new List<MUSW__License2__c>();          
        /*Fetching the updated Id, Status and SubStatus for the above created Licenses*/    
        
        autoClosedCredentialsList = [SELECT Id, MUSW__Status__c, Sub_Status__c
                            FROM MUSW__License2__c
                            WHERE ID IN :credentialList];
    
        if(autoClosedCredentialsList.size() > 0)    {               
                
        //Status should be changed to Withdrawn and Substatus to Inactive
        System.AssertEquals('Withdrawn',autoClosedCredentialsList[0].MUSW__Status__c);               
        //System.AssertEquals('Inactive', autoClosedCredentialsList[0].Sub_Status__c);
            }    
    
        }
    
}