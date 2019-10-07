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
            User thisUser = [ select Id from User where Id = :UserInfo.getUserId() ];
        System.runAs ( thisUser ) {
            
            /*Profile p = [select Id,name from Profile where name ='eSLA Customer Community Plus Login User'  limit 1];
            System.debug('***profile***'+p);
            newUser = DOL_TestDataFactory.createPortalUser('lastName', 'nuser',p.id,'pb@ff.com',con.id );
            insert newUser;
            */
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
        }
        
        }catch(Exception e){
            DOL_CreateErrorLog_Exception.logApplicationError(e);
            system.debug('Exception e '+ e);
        }
        
       
    }
        
        
    }