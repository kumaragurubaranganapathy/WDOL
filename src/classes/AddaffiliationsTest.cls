@isTest
public class AddaffiliationsTest {
    
    @testSetup static void setup(){
        Account testAccount = CreateTestDataUtility.createCitizenAccount();       
        insert testAccount;
        Contact testContact = CreateTestDataUtility.createContact(testAccount.id);  
        insert testContact;
        MUSW__License2__c testLicense = CreateTestDataUtility.createLicense(testAccount.id,testContact.id); //License
        testlicense.Application_Type__c='Delegated Municipality';
        testlicense.Credential_Type__c ='Delegated Municipality Agent';
        testlicense.Credential__c='Delegated Agent - Elevator';
        testlicense.Application_Method__c='General Application';
        insert testLicense; 
        MUSW__Application2__c serviceRequest = new MUSW__Application2__c();
        serviceRequest.License__c = testLicense.Id;
        insert serviceRequest;
 
        Affiliation__c la = new Affiliation__c();
        la.Credential__c = testLicense.id;
        la.Status__c = Label.ST_Inactive;
        insert la;
    }  

    public static testMethod void testMyController() {
        MUSW__License2__c license = [Select Id from MUSW__License2__c limit 1];
        MUSW__Application2__c serviceRequest = [Select Id from MUSW__Application2__c limit 1];
        Affiliation__c la = [Select Id from Affiliation__c limit 1];
        PageReference pageRef = Page.AddAffiliation;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('credentialId', license.id);
        ApexPages.currentPage().getParameters().put('affiliationid', la.id);
        ApexPages.currentPage().getParameters().put('servReqId', serviceRequest.Id);
        AddAffiliation controller = new AddAffiliation();            // New Agreement
        controller.affiliation = la;
        controller.newaffiliation = la;
        controller.serviceRequest=serviceRequest;
         test.startTest();
        controller.SaveAffiliation();
        controller.serviceRequestId = serviceRequest.Id;   
     test.stopTest();
    }
    
    public static testMethod void testMyController5() {
        MUSW__License2__c license = [Select Id from MUSW__License2__c limit 1];
        MUSW__Application2__c serviceRequest = [Select Id from MUSW__Application2__c limit 1];
        PageReference pageRef = Page.AddAffiliation;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('credentialId', license.id);
        ApexPages.currentPage().getParameters().put('servReqId', serviceRequest.Id);
        AddAffiliation controller = new AddAffiliation();            // New Agreement
         test.startTest();
        controller.SaveAffiliation();
        controller.serviceRequestId = serviceRequest.Id;   
     test.stopTest();
    }
    
     public static testMethod void testMyController2() {
         test.startTest();
        MUSW__License2__c license = [Select Id from MUSW__License2__c limit 1];
        MUSW__Application2__c serviceRequest = [Select Id from MUSW__Application2__c limit 1];
        PageReference pageRef = Page.AddAffiliation;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('credentialId', license.id);
        ApexPages.currentPage().getParameters().put('servReqId', serviceRequest.Id);
        AddAffiliation controller = new AddAffiliation();            // New Agreement
        controller.serviceRequest=serviceRequest;
         
        controller.SaveAffiliation();
        controller.serviceRequestId = serviceRequest.Id;
     test.stopTest();
    }
    
     public static testMethod void testMyController3() {
        MUSW__License2__c license = [Select Id from MUSW__License2__c limit 1];
        MUSW__Application2__c serviceRequest = [Select Id from MUSW__Application2__c limit 1];
        PageReference pageRef = Page.AddAffiliation;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('credentialId', license.id+'test');
        ApexPages.currentPage().getParameters().put('servReqId', serviceRequest.Id);
        AddAffiliation controller = new AddAffiliation();            // New Agreement
        controller.serviceRequest=serviceRequest;
         test.startTest();
        controller.SaveAffiliation();
        controller.serviceRequestId = serviceRequest.Id;
     test.stopTest();
    }
    
        public static testMethod void testMyController4() {
            test.startTest();
        MUSW__License2__c license = [Select Id from MUSW__License2__c limit 1];
        MUSW__Application2__c serviceRequest = [Select Id from MUSW__Application2__c limit 1];
        Affiliation__c la = [Select Id from Affiliation__c limit 1];
        PageReference pageRef = Page.AddAffiliation;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('credentialId', license.id);
        ApexPages.currentPage().getParameters().put('affiliationid', la.id);
        ApexPages.currentPage().getParameters().put('servReqId', serviceRequest.Id);
        AddAffiliation controller = new AddAffiliation();            // New Agreement

        Affiliation__c la2 = new Affiliation__c();
        la2.Status__c = Label.ST_Active;
        date startdate = date.today();
        la2.Start_Date__c=startdate;
         date enddate = date.today();
        la2.End_Date__c=enddate;
            la2.Contact_s_Street_Address__c='sdsd';
            la2.Contact_s_state__c='Florida';
            La2.Contact_s_Zip_code__c='23232';
            la2.Type__c='Primary Enforcement Contact';
            la2.Contact_s_City__c='testing';
            la2.RecordTypeId=Utilities.getRecordTypeForName(Label.API_Affiliation,'Delegated Agent Affiliation'); 
        insert la2;
        controller.affiliation = la;
        controller.newaffiliation = la2;
        controller.serviceRequest=serviceRequest;
        controller.SaveAffiliation();
        controller.serviceRequestId = serviceRequest.Id;
     test.stopTest();
    }
 }