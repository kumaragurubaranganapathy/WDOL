/**
* User Story:  
* Name: ChangeAddress_CCTest
* Type: Test Class
* Description: Class to create Test Data and test the execution of ChangeAddress_CC
* Date:        Developer/Company                    Description
* ---------------------------------------------------------------------------------------------------------------------------------------- *
* 10/10/2018   Sharad Maheshwari/Deloitte           Initial Creation
**/
@isTest
public class ChangeAddress_CCTest {
    
    @isTest static void testChangeAddressForIndividualLicense() {
    	//Creating test Account
        Account acc = new Account();
        acc = CreateTestDataUtility.createAccount();
        //Inserting test Account
        insert acc;
        
        //Creating test Contact
        Contact con = CreateTestDataUtility.createContact(acc.Id);
        //Inserting test Contact
        insert con;   
        
        //Creating test License
        Musw__License2__c license1 = CreateTestDataUtility.createLicense(acc.Id, con.Id);
        license1.Application_Type__c = 'Manufactured Homes'; 
        license1.Credential_type__c = 'Manufactured Homes Credential';
        license1.Credential__c = 'Manufactured Homes Installer';
        license1.Application_Method__c = 'Course Completion';
        insert license1;
        
         //Creating test  Parcel
        MUSW__Parcel__c parcel = CreateTestDataUtility.createAccountParcel(acc.Id, 
                                                                                  con.id, 
                                                                                  '901 International Pkwy', 
                                                                                  'Lake Mary', 
                                                                                  'FL', 
                                                                                  '32746', 
                                                                                  'United States');
    	insert parcel;
        
        //Creating test Contact Parcel Junction
        MUSW__Parcel_Contact2__c contactParcel = CreateTestDataUtility.createParcelContactJunction(parcel.Id, 
                                                                                  con.id);
    	insert contactParcel;
        
        //MUSW__Parcel_Contact2__c createParcelContactJunction(Id pid, Id cid)
         //Creating test License Parcel
        MUSW__License_Parcel__c licenseParcel = CreateTestDataUtility.createLicenseParcel(acc.Id, 
                                                                                          license1.Id, 
                                                                                          parcel.Id, 
                                                                                          true, 
                                                                                          true);
    	insert licenseParcel;
    Test.startTest();
        Test.setCurrentPageReference(new PageReference('Page.myPage'));
        System.currentPageReference().getParameters().put('licenseOrPermitId', license1.Id);
		System.currentPageReference().getParameters().put('licenseOrPermit', 'Credential');
        System.currentPageReference().getParameters().put('accountId', acc.Id);
		System.currentPageReference().getParameters().put('contactId', con.id);
        System.currentPageReference().getParameters().put('parcelId', parcel.Id);
		changeAddress_CC chngAdd = new changeAddress_CC();  
        chngAdd.customSave();
        chngAdd.createParcelContact();
    Test.stopTest();
}
    
    @isTest static void testChangeAddressForBusinessLicense() {
    	//Creating test Account
        Account acc2 = new Account();
        acc2 = CreateTestDataUtility.createAccount();
        //Inserting test Account
        insert acc2;
        
        //Creating test Contact
        Contact con2 = CreateTestDataUtility.createContact(acc2.Id);
        //Inserting test Contact
        insert con2;   
        
        //Creating test License
        Musw__License2__c license2 = CreateTestDataUtility.createLicense(acc2.Id, con2.Id);
        license2.Application_Type__c = 'Manufactured Homes'; 
        license2.Credential_type__c = 'Manufactured Homes Credential';
        license2.Credential__c = 'Manufactured Homes Manufacturer';
        license2.Application_Method__c = 'General Application';
        insert license2;
        
         //Creating test  Parcel
        MUSW__Parcel__c parcel2 = CreateTestDataUtility.createAccountParcel(acc2.Id, 
                                                                                  con2.id, 
                                                                                  '901 International Pkwy', 
                                                                                  'Lake Mary', 
                                                                                  'FL', 
                                                                                  '32746', 
                                                                                  'United States');
    	insert parcel2;
        
        //Creating test Contact Parcel Junction
        MUSW__Parcel_Contact2__c contactParcel2 = CreateTestDataUtility.createParcelContactJunction(parcel2.Id, 
                                                                                  con2.id);
    	insert contactParcel2;
        
         //Creating test License Parcel
        MUSW__License_Parcel__c licenseParcel2 = CreateTestDataUtility.createLicenseParcel(acc2.Id, 
                                                                                          license2.Id, 
                                                                                          parcel2.Id, 
                                                                                          true, 
                                                                                          true);
    	insert licenseParcel2;
    Test.startTest();
        Test.setCurrentPageReference(new PageReference('Page.myPage'));
        System.currentPageReference().getParameters().put('licenseOrPermitId', license2.Id);
		System.currentPageReference().getParameters().put('licenseOrPermit', 'Credential');
        System.currentPageReference().getParameters().put('accountId', acc2.Id);
		System.currentPageReference().getParameters().put('contactId', con2.id);
        System.currentPageReference().getParameters().put('parcelId', parcel2.Id);
		changeAddress_CC chngAdd2 = new changeAddress_CC();  
        chngAdd2.customSave();
        chngAdd2.createParcelContact();
    Test.stopTest();
}
    @isTest static void testChangeAddressForPermit() {
    	//Creating test Account
        Account acc1 = new Account();
        acc1 = CreateTestDataUtility.createAccount();
        //Inserting test Account
        insert acc1;
        
        //Creating test Contact
        Contact con1 = CreateTestDataUtility.createContact(acc1.Id);
        //Inserting test Contact
        insert con1;   
        
        //Creating test License
        Musw__Permit2__c permit1 = CreateTestDataUtility.createPermit(acc1.Id, con1.Id);
        permit1.Application_Type__c = 'Manufactured Homes Communities'; 
        permit1.Program_Area__c = 'Manufactured Homes Communities';
        permit1.Permit_Type__c = 'Manufactured Homes Community Permit';
        //permit1.Application_Method__c = 'Course Completion';
        insert permit1;
        
        //Creating test  Parcel
        MUSW__Parcel__c parcel1 = CreateTestDataUtility.createAccountParcel(acc1.Id, 
                                                                                  con1.id, 
                                                                                  '901 International Pkwy', 
                                                                                  'Lake Mary', 
                                                                                  'FL', 
                                                                                  '32746', 
                                                                                  'United States');
    	insert parcel1;
        
        //Creating test Contact Parcel Junction
        MUSW__Parcel_Contact2__c contactParcel1 = CreateTestDataUtility.createParcelContactJunction(parcel1.Id, 
                                                                                  con1.id);
    	insert contactParcel1;
        
         //Creating test License Parcel
        MUSW__Permit_Parcel__c permitParcel1 = CreateTestDataUtility.createPermitParcel(acc1.Id, 
                                                                                          permit1.Id, 
                                                                                          parcel1.Id, 
                                                                                          true, 
                                                                                          true);
    	insert permitParcel1;
        
    Test.startTest();
        Test.setCurrentPageReference(new PageReference('Page.myPage'));
        System.currentPageReference().getParameters().put('licenseOrPermitId', permit1.Id);
		System.currentPageReference().getParameters().put('licenseOrPermit', 'Permit');
        changeAddress_CC chngAdd1 = new changeAddress_CC();  
        chngAdd1.customSave();
        
    Test.stopTest();
}
    
     @isTest static void testChangeAddressForPermitError() {
    	//Creating test Account
        Account acc4 = new Account();
        acc4 = CreateTestDataUtility.createAccount();
        //Inserting test Account
        insert acc4;
        
        //Creating test Contact
        Contact con4 = CreateTestDataUtility.createContact(acc4.Id);
        //Inserting test Contact
        insert con4;   
        
        //Creating test License
        Musw__Permit2__c permit4 = CreateTestDataUtility.createPermit(acc4.Id, con4.Id);
        permit4.Application_Type__c = 'Plan Review'; 
        permit4.Program_Area__c = 'POWTS';
        permit4.Permit_Type__c = 'POWTS Component Manual Design';
        insert permit4;        
        
    Test.startTest();
        Test.setCurrentPageReference(new PageReference('Page.myPage'));
        System.currentPageReference().getParameters().put('licenseOrPermitId', permit4.Id);
		System.currentPageReference().getParameters().put('licenseOrPermit', 'Permit');
        changeAddress_CC chngAdd4 = new changeAddress_CC();  
        chngAdd4.customSave();
        
    Test.stopTest();
}
    
    @isTest static void testChangeAddressForOthers() {
        
    Test.startTest();    	
        Test.setCurrentPageReference(new PageReference('Page.myPage'));
        System.currentPageReference().getParameters().put('licenseOrPermit', 'None');
        changeAddress_CC chngAdd1 = new changeAddress_CC();  
        
    Test.stopTest();
}
}