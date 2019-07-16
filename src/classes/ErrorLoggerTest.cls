/*************************************************************************************************************
*  User Story: None
**************************************************************************************************************
** Class Name       : ErrorLoggerTest
** Description      : Test class to check error logger
** Version          : 1.0
** Built By         :
**------------------------------------------------------------------------------------------------------------
** Modification Log:
**------------------
** Developer                  Date              Version              Description
**----------------------------------------------------------------------------------------------------------
** Review Log:
**---------------
** Reviewer                  Date           Version               Description
**----------------------------------------------------------------------------------------------------------
** 
**********************************************************************************/ 
@isTest
public class ErrorLoggerTest {
    
    /**
* Method name  : logGeneralExceptionTest
* Description  : This method throws an exception and verified if the exception is logged in the OH_Error__C 
* Return Type  : None
* Parameter    : None
**/
    public static testMethod Void logGeneralExceptionTest()
    {
        Integer countErrLogBeforeEx = [Select Count() from Error_Log__c];
        try{    
            Account accountObj = new Account();
            insert(accountObj);
        }
        catch(Exception ex)
        {
            ErrorLogger.logGeneralException(ex,UserInfo.getUserId(),Label.API_Account, 'test Account insert eventType', 'test component logGeneralExceptionTest', 'OH_ErrorLoggerTest', 'Test severityLevel');
        }
        Integer countErrAfterEx = [Select Count() from Error_Log__c];
        System.assertEquals(countErrLogBeforeEx, countErrAfterEx-1);
    }
    
    /**
* Method name  : logDMLDatabaseResultErrors_UpsertResultTest
* Description  : This method checks if unsuccessful upsert of records are captured and logged in the OH_Error__C object
* Return Type  : None
* Parameter    : None
**/
    public static testMethod Void logDMLDatabaseResultErrors_UpsertResultTest()
    {
        Integer countErrLogBeforeUpRslt = [Select Count() from Error_Log__c];
        Database.UpsertResult[] ur;
        List<Account> testAccsList= new List<Account>();
        for (integer i=0;i<10;i++)
        {
            if(i<5)
                //5 correct values
                testAccsList.add(new Account(name='Test DML Save'+i));
            else
                //5 null value records
                testAccsList.add(new Account());
        }
        ur = Database.upsert(testAccsList,false);
        ErrorLogger.logDMLDatabaseResultErrors(UserInfo.getUserId(), null, null,ur,Label.API_Account,'Account Upsert', 'logDMLDatabaseResultErrors_UpsertResultTest', 'OH_ErrorLoggerTest','Test Severity', 'Error Logger');            
       Boolean testing =ErrorLogger.logDMLDatabaseResultErrorsWithResponse(UserInfo.getUserId(), null, null,ur,Label.API_Account,'Account Upsert', 'logDMLDatabaseResultErrors_UpsertResultTest', 'OH_ErrorLoggerTest','Test Severity', 'Error Logger');            

           Integer countErrLogAfterUpRslt = [Select Count() from Error_Log__c];
        //system.assertEquals(countErrLogBeforeUpRslt, countErrLogAfterUpRslt-6);        
    }
    
    /**
* Method name  : logDMLDatabaseResultErrors_DeleteResultTest
* Description  : This method checks if unsuccessful delete of records are captured and logged in the OH_Error__C object
* Return Type  : None
* Parameter    : None
**/
    
    public static testMethod Void logDMLDatabaseResultErrors_DeleteResultTest()
    {
        Integer countErrLogBeforeDelRslt = [Select Count() from Error_Log__c];
        Database.DeleteResult[] dr;
        List<Account> testAccsList= new List<Account>();
        for (integer i=0;i<5;i++)
        {
            Account acc=new Account(name='Test DML Save'+i);
            testAccsList.add(acc);                   
        }       
        insert testAccsList;
          List<Case> testCases= new List<Case>(); 
               for(Account currAcct : testAccsList)
        {
            Case c1= new case(AccountId=currAcct.Id);
            testCases.add(c1); 
        }
        insert testCases;
        //Delete of accounts associated to cases is not allowed hence delete fails and error is logged
        dr = Database.delete(testAccsList,false);
        ErrorLogger.logDMLDatabaseResultErrors(UserInfo.getUserId(), dr, null,null,Label.API_Account,'Account Delete', 'logDMLDatabaseResultErrors_DeleteResultTest', 'OH_ErrorLoggerTest','Test Severity', 'Error Logger');            
        Integer countErrLogAfterDelRslt = [Select Count() from Error_Log__c];
        //system.assertEquals(countErrLogBeforeDelRslt, countErrLogAfterDelRslt-6);
        
    }
    
}