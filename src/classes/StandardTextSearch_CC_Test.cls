/**
* User Story: 242 - Use standard paragraphs in generated documents
* Class Name: StandardTextSearch_CC_Test
* Description: This is test class for StandardTextSearch_CC
* Date:            Developer/Company                    Description
* ---------------------------------------------------------------------------------------------------------------------------------------- *
* 10/05/2018    Srikanth Kottam/Deloitte           	  Initial Creation
**/
@isTest
public class StandardTextSearch_CC_Test {
	@testSetup
    public static void testSetup(){
        Id recordtypeId = Schema.SObjectType.MUSW__Violation_Type__c.getRecordTypeInfosByName().get('Paragraph').getRecordTypeId(); 
        MUSW__Violation_Type__c paragraph = new MUSW__Violation_Type__c();
        paragraph.RecordTypeId = recordtypeId;
        paragraph.Name = 'Testclass paragraph';
        paragraph.MUSW__Code_Number__c	= 'T1.11.1';
        paragraph.MUSW__Description__c = 'Paragraph for the test class';
        paragraph.MUSW__Short_Description__c = 'Paragraph for the test class';
        List<MUSW__Violation_Type__c> paraList = new List<MUSW__Violation_Type__c>();
        paraList.add(paragraph);
        insert paraList;
    }
    @isTest static void testsearchStandardText() {
        List<MUSW__Violation_Type__c> paraListResult = [Select Id, name, MUSW__Code_Number__c, MUSW__Short_Description__c from MUSW__Violation_Type__c
                                                       where name = 'Testclass paragraph'];
        Test.startTest();
        //Pass method
        StandardTextSearch_CC sts = new StandardTextSearch_CC();
        sts.shortDescription = 'Paragraph for the test class';
        sts.searchStandardText();
        system.debug('standardText size pass>>>'+ sts.standardText.size());
        system.assertEquals(sts.standardText.size(), 1);
        //Fail method-1
        sts.name = 'Standardtextsearch'; 
        sts.searchStandardText();
        system.assertEquals(sts.standardText.size(), 0);
        Test.stopTest();
    }
}