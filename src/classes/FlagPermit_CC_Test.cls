/*************************************************************************************************************
** User Story: 282 -- Adding Alerts to a Credential/Plan Review/PTO
**************************************************************************************************************
** Class Name    : FlagPermit_CC_Test
** Description   : Test class for Controller FlagPermit_CC
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
public class FlagPermit_CC_Test {
    public static Testmethod MUSW__Permit2__c createTestData(){
        List<Account> accList = new List<Account>();
        
        /** Account Creation **/ 
        Account a = CreateTestDataUtility.createAccount();
        accList.add(a);
        insert accList;
        
        /** Contact Creation **/
        Contact c = CreateTestDataUtility.createContact(a.Id);
        insert c;
        Id recordTypeId = Schema.SObjectType.MUSW__Permit2__c.getRecordTypeInfosByName().get('All').getRecordTypeId();
        MUSW__Permit2__c permit = new MUSW__Permit2__c(RecordTypeId = recordTypeId,
                                                          MUSW__Status__c='Pending',
                                                          App_Submitted_Date__c=System.today(),
                                                          Object_Type__c = 'Plan Review', 
                                                          Application_Type__c = 'Plan Review', 
                                                       	  Program_Area__c = 'POWTS', 
                                                       	  Permit_Type__c = 'POWTS Petition for Variance');
        permit.MUSW__Applicant__c =c.id;
        insert permit;
        Associate_Flag__c aFlag = new Associate_Flag__c(Effective_Date__c = system.today(),
                                                        Severity__c = 'Low',
                                                        Application_Type__c = 'Plan Review',
                                                        PTO_Plan_Review__c = permit.Id);
        Insert aFlag;
        return permit;
        
    }
    public static Testmethod void passTest(){
        MUSW__Permit2__c permit = createTestData();
        test.startTest();
        ApexPages.StandardController sc = new ApexPages.StandardController(permit);
        FlagPermit_CC flagPermit = new FlagPermit_CC(sc);
        flagPermit.customnew();
       // constructor();
        test.stopTest();
    }
}