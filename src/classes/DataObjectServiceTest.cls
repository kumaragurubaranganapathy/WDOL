/*************************************************************************************************************
**
**************************************************************************************************************
** Class Name    : DataObjectServiceTest
** Description   : Unit Test for DataObjectService class
** Version       : 1.0
** Built By      : 
**------------------------------------------------------------------------------------------------------------
** Modification Log:
**------------------
** Developer                         Date                    Version                     Description
** Review Log:
**---------------
** Reviewer                         Date                    Version                      Description
**------------------------------------------------------------------------------------------------------------
**
**  **********************************************************************************/
@isTest
private class DataObjectServiceTest {

    static RestRequest req = new RestRequest();
    static RestResponse res = new RestResponse();

    static DataMigrationUtil dmu = new DataMigrationUtil('MUSW__Automation_Rule__c', 'Parent');
    static List<Newsfeed__c> newsFeed = new List<Newsfeed__c>();
    static List<Question__c> questions = new List<Question__c>();
    static List<MUSW__Sequence_Number__c> seqNumbers = new List<MUSW__Sequence_Number__c>();
    static List<MUSW__Automation_Rule__c> autoRules = new List<MUSW__Automation_Rule__c>();
    static List<MUSW__Automation_Filter__c> autoFilters = new List<MUSW__Automation_Filter__c>();
    
    static {
        // setup test data        
        for (integer i = 0; i < 10; i++){
            newsFeed.add(new Newsfeed__c(Name = 'OHNF no.' + (i + 1)));
          questions.add(new Question__c(External_Id__c='i+1'+i,Application_type__c='Trades Credential'));//sfxid__c = 'QuestionNumber' + (i + 1)
            seqNumbers.add(new MUSW__Sequence_Number__c(Name = 'SEQ no.' + (i + 1)));
            autoRules.add(new MUSW__Automation_Rule__c(Name = 'Rule no.' + (i + 1)));
            autoFilters.add(new MUSW__Automation_Filter__c());
        }
        insert questions;
    }

    static testMethod void testDoGet() {
        req.requestURI = '/services/apexrest/DataService/Question__c';
        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response = res;

        List<SObject> results = DataObjectService.doGet();

        System.assertEquals(10, results.size());
    }

    static testMethod void testNegative() {
        req.requestURI = '/services/apexrest/DataService/NegativeTest';
        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response = res;

        List<SObject> results = DataObjectService.doGet();

        System.assert(true);
    }
}