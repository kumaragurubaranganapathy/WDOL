@isTest
private class DataMigrationUtilTest {

    static DataMigrationUtil dmu = new DataMigrationUtil('MUSW__Automation_Rule__c', 'Parent');
    static List<Newsfeed__c> newsFeed = new List<Newsfeed__c>();
    static List<Question__c> questions = new List<Question__c>();
    static List<MUSW__Sequence_Number__c> seqNumbers = new List<MUSW__Sequence_Number__c>();
    static List<Application_Page__c> pagesed = new List<Application_Page__c>();
    static List<Application_Section__c> sectionsed = new List<Application_Section__c>();
      static List<MUSW__Master_Submission_List__c> sublist = new List<MUSW__Master_Submission_List__c>();
    
    static {
        // setup test data        
        for (integer i = 0; i < 10; i++){
            newsFeed.add(new Newsfeed__c(Name = 'OHNF no.' + (i + 1),External_Id__c='i+1'+i,Application_type__c='Trades Credential'));
             sublist.add(new MUSW__Master_Submission_List__c(Name = 'OHNF no.' + (i + 1),External_Id__c='i+1'+i,Application_type__c='Trades Credential'));
            questions.add(new Question__c(External_Id__c='i+1'+i,Application_type__c='Trades Credential'));//sfxid__c = 'QuestionNumber' + (i + 1)
            seqNumbers.add(new MUSW__Sequence_Number__c(Name = 'SEQ no.' + (i + 1)));
            pagesed.add(new Application_Page__c(External_Id__c='i+1'+i,Application_type__c='Trades Credential'));
            sectionsed.add(new Application_Section__c(External_Id__c='i+1'));
        }
        insert questions;
    }
    
    @isTest static void testInsertRecords() {
        Test.startTest();
        List<Application_Section__c> sections = new  List<Application_Section__c>(); 
        Application_Page__c p = new Application_Page__c();
        p.Name = 'pageName';
        p.License__c = true;
        p.Permit__c = true;
        p.License_Renewal__c = true;
        p.License_Reinstatement__c = true;
        insert p;
    
        Application_Section__c s = new Application_Section__c();
        s.Name = 'Personal Information Test';
        s.Parent__c = p.Id;
        s.Order_Number__c = 1;
        s.License__c = true;
        s.Permit__c = true;
        s.License_Renewal__c = true;
        s.License_Reinstatement__c = true;
        insert s;
        
        s.External_Id__c=s.Id;
        update s;
        sections.add(s);

        dmu = new DataMigrationUtil('Application_Section__c', 'Application_Page__c');
        Boolean result = dmu.insertRecords(sections, 50000);
        System.assertEquals(result, true);
        Test.stopTest();
    }
    
    @isTest static void testInsertNewsRecords2() {
        Test.startTest();
        Database.insert(newsFeed, false);
        dmu = new DataMigrationUtil('Newsfeed__c', '');
        Boolean result = dmu.insertRecords(newsFeed, 50001);
        System.assertEquals(result, true);
        Test.stopTest();
    }
    
      @isTest static void testInsertSublist() {
        Test.startTest();
        Database.insert(sublist, false);
        dmu = new DataMigrationUtil('MUSW__Master_Submission_List__c', '');
        Boolean result = dmu.insertRecords(sublist, 50);
        System.assertEquals(result, true);
        Test.stopTest();
    }
    
    @isTest static void testInsertRecordsTestlimit() {
        Test.startTest();
        Database.insert(pagesed, false);
        Database.insert(sectionsed, false);
        dmu = new DataMigrationUtil('Application_Section__c', 'Application_Page__c');
        try{
             dmu.insertRecords(sectionsed, 5);
        }
        catch(Exception e){
            
        }
        Test.stopTest();
    }
    
    @isTest static void testInsertNewsRecords() {
        Test.startTest();
        Database.insert(newsFeed, false);
        dmu = new DataMigrationUtil('Newsfeed__c', '');
        Boolean result = dmu.insertNewsRecords(newsFeed);
        System.assertEquals(result, true);
        Test.stopTest();
    }

    @isTest static void testInsertQuestionRecords() {
        Test.startTest();
        Database.insert(questions, false);
        dmu = new DataMigrationUtil('Question__c', '');
        Boolean result = dmu.insertQuestionRecords(questions);
        System.assertEquals(result, true);
        Test.stopTest();
    }
    
    @isTest static void testInsertSequenceNumbers() {
        Test.startTest();
        seqNumbers.add(new MUSW__Sequence_Number__c(name='DEFAULT'));
        Database.insert(seqNumbers, false);
        dmu = new DataMigrationUtil('MUSW__Sequence_Number__c', '');
        Boolean result = dmu.insertSequenceNumbers(seqNumbers);
        System.assertEquals(result, true);
        Test.stopTest();
    }

    @isTest static void testPurgeRecords() {
        Test.startTest();
        dmu = new DataMigrationUtil('Application_Page__c', 'Parent');
        Boolean result = dmu.purgeRecords();
        System.assertEquals(result, true);
        Test.stopTest();
    }
}