/*************************************************************************************************************
** User Story: 284 -- Adding Alerts to an Account
**************************************************************************************************************
** Class Name    : FlagAccount_CC
** Description   : Controller for Account Related List (Associate Flag)
** Version       : 1.0
** Built By      : Srikanth Kottam
**------------------------------------------------------------------------------------------------------------
** Modification Log:
**------------------
** Developer                         Date                    Version                      Description
**------------------------------------------------------------------------------------------------------------
** Srikanth Kottam                07/20/2018                    1                          Created
** 
** Review Log:
**---------------
** Reviewer                  Date           Version               Description
**------------------------------------------------------------------------------------------------------------
**
**  **********************************************************************************/
@isTest
public class FlagAccount_CC_Test {
	public static Testmethod Account createTestData(){
        /** Account Creation **/ 
        Account acc = CreateTestDataUtility.createAccount();
        insert acc;
        
        Associate_Flag__c aFlag = new Associate_Flag__c(Effective_Date__c = system.today(),
                                                        Severity__c = 'Low',
                                                        Application_Type__c = 'Trades Credential',
                                                        Account__c = acc.Id);
        Insert aFlag;
        return acc;
        
    }
    public static Testmethod void passTest(){
        Account acc = createTestData();
        test.startTest();
        ApexPages.StandardController sc = new ApexPages.StandardController(acc);
        FlagAccount_CC flagContact = new FlagAccount_CC(sc);
        flagContact.customnew();
        test.stopTest();
    }
}