/*************************************************************************************************************
** User Story: 282 -- Adding Alerts to a Credential/Plan Review/PTO
**************************************************************************************************************
** Class Name    : FlagCredential_CC_Test
** Description   : Test class for Controller FlagCredential_CC
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
public class FlagCredential_CC_Test {
    public static Testmethod MUSW__License2__c createTestData(){
        List<Account> accList = new List<Account>();
        
        /** Account Creation **/ 
        Account a = CreateTestDataUtility.createAccount();
        accList.add(a);
        insert accList;
        
        /** Contact Creation **/
        Contact c = CreateTestDataUtility.createContact(a.Id);
        insert c;
        Id recordTypeId = Schema.SObjectType.MUSW__License2__c.getRecordTypeInfosByName().get('Universal Default License Record Type').getRecordTypeId();
        MUSW__License2__c license = new MUSW__License2__c(RecordTypeId = recordTypeId,
                                                          MUSW__Status__c='Pending',
                                                          App_Submitted_Date__c=System.today(),
                                                          Application_Type__c = 'Trades Credential', 
                                                          Credential_Type__c = 'Dwelling Contractor', 
                                                          Credential__c = 'Dwelling Contractor', 
                                                          Application_Method__c = 'General Application');
        license.MUSW__Applicant__c =c.id;
        insert license;
        Associate_Flag__c aFlag = new Associate_Flag__c(Effective_Date__c = system.today(),
                                                        Severity__c = 'Low',
                                                        Application_Type__c = 'Trades Credential',
                                                        Credential__c = license.Id);
        Insert aFlag;
        return license;
        
    }
    public static Testmethod void passTest(){
        MUSW__License2__c license = createTestData();
        test.startTest();
        ApexPages.StandardController sc = new ApexPages.StandardController(license);
        FlagCredential_CC flagPermit = new FlagCredential_CC(sc);
        flagPermit.customnew();
        test.stopTest();
    }
}