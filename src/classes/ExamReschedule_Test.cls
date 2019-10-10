@isTest
public class ExamReschedule_Test {
    
    @isTest
    public static void getEducationHistoryDataTest(){
        Id AccRecTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('User Account').getRecordTypeId();
        Id ConRecTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Contact').getRecordTypeId();
        Id LicRecTypeId = Schema.SObjectType.MUSW__License2__c.getRecordTypeInfosByName().get('Individual').getRecordTypeId();
        Id ReviewRecTypeId = Schema.SObjectType.MUSW__Review__c.getRecordTypeInfosByName().get('License Review').getRecordTypeId();
        Id ExamRecTypeId = Schema.SObjectType.Education_History__c.getRecordTypeInfosByName().get('Exam').getRecordTypeId();
        User newUser;
        
        Account acc = DOL_TestDataFactory.createAccount(AccRecTypeId);  
        //insert acc;
        Contact con = DOL_TestDataFactory.createContact(ConRecTypeId,acc.id);
        //insert con;
        try{
            
            //Insert for License
            MUSW__License2__c licObj = new MUSW__License2__c(
                Name='System Number', 
                RecordTypeId = LicRecTypeId,
                MUSW__Primary_Licensee__c = acc.id, 
                Application_Type__c = 'Geologist',
                Credential_Type__c = 'Geologist',
                Application_Method__c = 'General Application',
                MUSW__Applicant__c =  con.Id);
            insert licObj;
            System.debug('***licObj***'+licObj);
            
            MUSW__Review__c testReview = new MUSW__Review__c();
            testReview.Name = 'General Application Review';
            testReview.License__c = licObj.Id;
            testReview.Application_Type__c = licObj.Application_Type__c;
            testReview.License_Type__c = licObj.Credential_Type__c;
            testReview.Review_Type__c = 'General Application';
            testReview.RecordTypeId = ReviewRecTypeId;
            testReview.MUSW__Status__c = 'Pending';
            insert testReview;
            
            testReview.MUSW__Status__c = 'Exam Approved';
            testReview.Review_SubStatus__c = 'PE Approved';
            update testReview;
            
            Education_History__c testExamRecord = new Education_History__c();
            testExamRecord.Exam_Type__c = 'Washington State Hydrogeology Exam (PE)';
            testExamRecord.License_Type__c = 'Geologist';
            testExamRecord.Program_Type__c = 'Geologist';
            testExamRecord.Status__c = 'Pending';
            testExamRecord.License__c = licObj.Id;
            insert testExamRecord;
            
            licObj.MUSW__Status__c = 'In-Review';
            update licObj;
            String licenseId = licObj.Id;
            String examRecID = testExamRecord.Id;
            
            List<Education_History__c> examRecs = ExamReschedule.getEducationHistoryData(licenseId);
            
            ExamReschedule.insertRequestExam(licenseId,'Geologist' ,'Geologist', 'Exam Reschedule',examRecID );
            
            Global_Settings__c gloSett = new Global_Settings__c(Name='cs');
            insert gloSett;
            gloSett.Disable_Triggers__c = true;
            update gloSett;
            
            Database.delete(testExamRecord);
            
            Database.undelete(testExamRecord);
            testExamRecord.Status__c = 'Pass';
            update testExamRecord;
            
            
            
            
        }catch(Exception e){
            DOL_CreateErrorLog_Exception.logApplicationError(e);
            system.debug('Exception e '+ e);
        }
        
        
    }
    
    @isTest
    public static void unitTest2(){
        Id ReviewRecTypeId = Schema.SObjectType.MUSW__Review__c.getRecordTypeInfosByName().get('License Review').getRecordTypeId();
        Id ExamRecTypeId = Schema.SObjectType.Education_History__c.getRecordTypeInfosByName().get('Exam').getRecordTypeId();
       
        Id appRecId = Schema.SObjectType.MUSW__Application2__c.getRecordTypeInfosByName().get('Registration').getRecordTypeId();
        MUSW__Application2__c app = DOL_TestDataFactory.createApplication(appRecId);
        Id AccRecTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('User Account').getRecordTypeId();
        Account a = DOL_TestDataFactory.createAccount(AccRecTypeId);
        Id LicRecTypeId1 = Schema.SObjectType.MUSW__License2__c.getRecordTypeInfosByName().get('Individual').getRecordTypeId();
        MUSW__License2__c lic1 = DOL_TestDataFactory.createLicense(LicRecTypeId1, a.Id, 'Geologist', 'Geologist', 'General Application');
        lic1.Application__c = app.id;
        lic1.MUSW__Status__c = 'In-Review';
        update lic1;
        
        MUSW__Review__c testReview = new MUSW__Review__c();
        testReview.Name = 'General Application Review';
        testReview.License__c = lic1.Id;
        testReview.Application_Type__c = lic1.Application_Type__c;
        testReview.License_Type__c = lic1.Credential_Type__c;
        testReview.Review_Type__c = 'General Application';
        testReview.RecordTypeId = ReviewRecTypeId;
        testReview.MUSW__Status__c = 'Pending';
        insert testReview;
        
        testReview.MUSW__Status__c = 'Exam Approved';
        testReview.Review_SubStatus__c = 'PE Approved';
        update testReview;
        
       
        test.startTest();
        
        Global_Settings__c globalSettings = new Global_Settings__c(Name = Userinfo.getUserName(), Disable_Triggers__c = false);
        insert globalSettings; 
        globalSettings.Disable_Triggers__c = true;
        update globalSettings;
        
        Education_History__c testExamRecord = new Education_History__c();
        testExamRecord.Exam_Type__c = 'Washington State Hydrogeology Exam (PE)';
        testExamRecord.License_Type__c = 'Geologist';
        testExamRecord.Program_Type__c = 'Geologist';
        testExamRecord.Status__c = 'Pending';
        testExamRecord.License__c = lic1.Id;
        insert testExamRecord;
       
        testExamRecord.Status__c = 'Pass';
        update testExamRecord;
        
        delete testExamRecord;
        test.stopTest();
        
    }
    
    
}