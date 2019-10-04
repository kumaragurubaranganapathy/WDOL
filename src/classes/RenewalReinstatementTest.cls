@isTest
public class RenewalReinstatementTest {
    public static testmethod void testautoRenewReinstatementMethod(){
        Id AccRecTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('User Account').getRecordTypeId();
        Id ConRecTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Contact').getRecordTypeId();
        Id LicRecTypeId = Schema.SObjectType.MUSW__License2__c.getRecordTypeInfosByName().get('Individual').getRecordTypeId();
        Id renewalRecordTypeId = Schema.SObjectType.Renewal_Application__c.getRecordTypeInfosByDeveloperName().get('Individual').getRecordTypeId();
        Id quesRecTypeId = Schema.SObjectType.Question__c.getRecordTypeInfosByName().get('License Information').getRecordTypeId();
        
        Test.startTest();
        //Insert Account
        Account acc = DOL_TestDataFactory.createAccount(AccRecTypeId); 
        
        //Insert Contact
        Contact con = DOL_TestDataFactory.createContact(ConRecTypeId,acc.id);
        
        //Insert License
        MUSW__License2__c license = DOL_TestDataFactory.createLicense(LicRecTypeId, acc.Id, 'Architects', 'Architect', 'General Application');
        license.MUSW__Applicant__c = con.Id;
        license.MUSW__Expiration_Date__c = System.today()+10;
        update license;
                
        //Insert Renewal Application
        Renewal_Application__c renew = DOL_TestDataFactory.createRenewalApplication(renewalRecordTypeId, license.Id, null);
        renew.Renewal_Status__c = 'Pending Payment';
        update renew;
        
        //Insert Question
        Question__c ques = new Question__c();
        ques.Question_Body__c = 'Total number of full months of experience in real estate appraising';
        ques.Data_Type__c = 'Yes_No';
        ques.Parent_Object_API_Name__c = 'Renewal_Application__c';
        ques.RecordTypeId = quesRecTypeId;
        ques.Application_Type__c = 'Notary Public';
        ques.External_Id__c = 'abc123';
        ques.QuestionFieldAPI__c = 'Name';
        ques.Section__c = 'Legal Background Questions';
        insert ques;
        
        //Insert Answer
        BGCK__Answer__c ans = new BGCK__Answer__c();
        ans.Answer_Text__c = 'No';
        ans.QuestionDOL__c = ques.Id;
        ans.Renewal_Reinstatement_Application__c = renew.id;
        insert ans;
        
        //Insert Answer
		BGCK__Answer__c ans1 = new BGCK__Answer__c();
        ans1.Answer_Text__c = 'No';
        ans1.QuestionDOL__c = ques.Id;
        ans1.Renewal_Reinstatement_Application__c = renew.id; 
        insert ans1;
        
        Test.stopTest();
    }
}