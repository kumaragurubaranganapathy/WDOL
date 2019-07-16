/*************************************************************************************************************
** User Story: 283 -- Adding Alerts to a Contact
**************************************************************************************************************
** Class Name    : FlagCredential_CC_Test
** Description   : Test class for Controller FlagContact_CC
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
**************************************************************************************/
@isTest
public class FlagContact_CC_Test {
	public static Testmethod Contact createTestData(){
        List<Account> accList = new List<Account>();
        
        /** Account Creation **/ 
        Account a = CreateTestDataUtility.createAccount();
        accList.add(a);
        insert accList;
        
        /** Contact Creation **/
        Contact c = CreateTestDataUtility.createContact(a.Id);
        insert c;
        Associate_Flag__c aFlag = new Associate_Flag__c(Effective_Date__c = system.today(),
                                                        Severity__c = 'Low',
                                                        Application_Type__c = 'Trades Credential',
                                                        Contact__c = c.Id);
        Insert aFlag;
        return c;
        
    }
    public static Testmethod void passTest(){
        Contact c = createTestData();
        test.startTest();
        ApexPages.StandardController sc = new ApexPages.StandardController(c);
        FlagContact_CC flagContact = new FlagContact_CC(sc);
        flagContact.customnew();
        test.stopTest();
    }
}