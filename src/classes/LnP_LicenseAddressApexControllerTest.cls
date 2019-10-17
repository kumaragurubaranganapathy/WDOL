@isTest
public class LnP_LicenseAddressApexControllerTest {
    
    @testSetup static void setup() {
        // Create common test accounts
        
        Id accRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('User_Account').getRecordTypeId();
        Account acc = DOL_TestDataFactory.createAccount(accRecordTypeId);
        Id conRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('Contact').getRecordTypeId();
        Contact con = DOL_TestDataFactory.createContact(conRecordTypeId,acc.Id);
        Id parcelRecordTypeId = Schema.SObjectType.MUSW__Parcel__c.getRecordTypeInfosByDeveloperName().get('Address').getRecordTypeId();
        MUSW__Parcel__c testparcel1 = DOL_TestDataFactory.createParcel(parcelRecordTypeId);
        testparcel1.MUSW__Primary_Contact__c = con.Id;
        testparcel1.Address_Type__c = 'MAILING ADDRESS';
        testparcel1.is_Physical_and_Mailing_Address_Same__c = true;
        update testparcel1;
        Id LocationRT = Schema.SObjectType.MUSW__Parcel__c.getRecordTypeInfosByName().get('Affiliated Location').getRecordTypeId(); 
        Id licRecordTypeId = Schema.SObjectType.MUSW__License2__c.getRecordTypeInfosByDeveloperName().get('Business').getRecordTypeId();
        Id licRecordTypeIdIndivi = Schema.SObjectType.MUSW__License2__c.getRecordTypeInfosByDeveloperName().get('Universal_Default_License_Record_Type').getRecordTypeId();        
        MUSW__License2__c lic1 = DOL_TestDataFactory.createLicenseIndividual(licRecordTypeIdIndivi, con.Id, 'Notary Public', 'Notary Public', 'General Application');
        MUSW__License2__c lic2 = DOL_TestDataFactory.createLicense(licRecordTypeId, acc.Id, 'Cemeteries', 'Cemetery', 'General Application');
        MUSW__License_Parcel__c testLicenseParcel = DOL_TestDataFactory.createLicenseParcel(lic1.id,testparcel1.id);
        Request__c testRequest1 = DOL_TestDataFactory.createRequest(lic1.Id,'Cemeteries', 'Cemetery');
        MUSW__Parcel__c testparcel2 = DOL_TestDataFactory.createParcel(parcelRecordTypeId);
        testparcel2.MUSW__Primary_Contact__c = con.Id;
        testparcel2.Primary_Account__c = acc.Id;
        testparcel2.Request_Parcel__c = testRequest1.Id;
        testparcel2.Request__c = testRequest1.Id;
        testparcel2.recordtypeid = LocationRT;
        testparcel2.Address_Type__c = 'PHYSICAL ADDRESS';
        testparcel2.is_Physical_and_Mailing_Address_Same__c = false;
        update testparcel2;
        
    }
    
    
    public static testMethod void LnP_LicenseAddressApexControllerMethod1(){
        Contact con = [Select Id from contact where LastName= 'Test Contact' ];        
        Account acc = [Select Id from Account where Name= 'Test Account' ];        
        Id applicationRecordTypeId = Schema.SObjectType.MUSW__Application2__c.getRecordTypeInfosByDeveloperName().get('General_Service_Request').getRecordTypeId();
        MUSW__Application2__c testApp = DOL_TestDataFactory.createApplication(applicationRecordTypeId);
        MUSW__Parcel__c parcel = [Select Id,Application_BG__c from MUSW__Parcel__c where MUSW__Primary_Contact__c=: con.Id limit 1];
        MUSW__Parcel__c parcelPhysical = [Select Id,Application_BG__c from MUSW__Parcel__c where Primary_Account__c=: acc.Id limit 1];
        parcel.Application_BG__c = testApp.Id;
        update parcel;
        MUSW__License2__c lic1 = [Select id from MUSW__License2__c where Credential_Type__c='Notary Public' limit 1];
        MUSW__License2__c lic2 = [Select id from MUSW__License2__c where Credential_Type__c='Cemetery' limit 1];
        Request__c testRequest1 = [Select id From Request__c where License_Type__c='Cemetery' limit 1];
        
        String addressStringone = 'Businessfirst, Olympia, WA, 9887, United States';
        String addressStringtwo = 'Businessfirst,Businesstwo, Olympia, WA, 9887, United States';
        test.startTest();
        LnP_LicenseAddressApexController.getAllAddress(con.Id,testApp.Id);
        LnP_LicenseAddressApexController.getPhysicalAddress(lic1.Id);
        LnP_LicenseAddressApexController.getAddressDetailsType();
        LnP_LicenseAddressApexController.getPhysicalAddressForRequest(testRequest1.Id);
        LnP_LicenseAddressApexController.getCountyValue('WA','Olympia');
        LnP_LicenseAddressApexController.getCountyValue('AL','Test');
        LnP_LicenseAddressApexController.sameAddUpdate(parcel.Id,'MUSW__Parcel__c',con.Id,true,testApp.Id);
        LnP_LicenseAddressApexController.sameAddUpdate(parcelPhysical.Id,'MUSW__Parcel__c',con.Id,true,testApp.Id);
        LnP_LicenseAddressApexController.deleteTableRecord(parcel.Id,'MAILING ADDRESS','MUSW__Parcel__c',testApp.Id);
        LnP_LicenseAddressApexController.getStates(parcel,'County__c');
        LnP_LicenseAddressApexController.validateAddress('add1','add2','city','state','1222');        
        
        test.stopTest();
    }
    public static testMethod void LnP_LicenseAddressApexControllerMethod2(){
        Contact con = [Select Id from contact where LastName= 'Test Contact' ];        
        Account acc = [Select Id from Account where Name= 'Test Account' ];        
        Id applicationRecordTypeId = Schema.SObjectType.MUSW__Application2__c.getRecordTypeInfosByDeveloperName().get('General_Service_Request').getRecordTypeId();
        MUSW__Application2__c testApp = DOL_TestDataFactory.createApplication(applicationRecordTypeId);
        MUSW__Application2__c testApp2 = DOL_TestDataFactory.createApplication(applicationRecordTypeId);
        MUSW__Parcel__c parcel = [Select Id,Application_BG__c from MUSW__Parcel__c where MUSW__Primary_Contact__c=: con.Id limit 1];
        MUSW__Parcel__c parcelPhysical = [Select Id,Application_BG__c from MUSW__Parcel__c where Primary_Account__c=: acc.Id limit 1];
        parcel.Application_BG__c = testApp.Id;        
        update parcel;
        
        List<Id> lstparelId = new List<Id>();
        lstparelId.add(parcel.Id);
        MUSW__License2__c lic1 = [Select id from MUSW__License2__c where Credential_Type__c='Notary Public' limit 1];
        MUSW__License2__c lic2 = [Select id from MUSW__License2__c where Credential_Type__c='Cemetery' limit 1];
        Request__c testRequest1 = [Select id From Request__c where License_Type__c='Cemetery' limit 1];
        String addressStringone = 'Businessfirst, Olympia, WA, 9887, United States';
        String addressStringtwo = 'Businessfirst,Businesstwo, Olympia, WA, 9887, United States';
        test.startTest();
        LnP_LicenseAddressApexController.integrationsaveAddress(addressStringone,false,testApp.Id,false,'MAILING ADDRESS','Adams',con.Id,'Contact',false,false);
        LnP_LicenseAddressApexController.integrationsaveAddress(addressStringone,true,testApp2.Id,true,'PHYSICAL ADDRESS','Adams',acc.Id,'Account',true,true);
        LnP_LicenseAddressApexController.AffiliatedLocation(JSON.serialize(parcel),true,true);
        LnP_LicenseAddressApexController.AffiliatedLocation(JSON.serialize(parcel),true,false);
        LnP_LicenseAddressApexController.AffiliatedLocation(JSON.serialize(parcel),false,true);
        LnP_LicenseAddressApexController.AffiliatedLocation(JSON.serialize(parcel),false,false);
        LnP_LicenseAddressApexController.removeLocation(parcel.Id,true);
        LnP_LicenseAddressApexController.removeLocation(parcel.Id,false);
        LnP_LicenseAddressApexController.setRequestLocationTable(testRequest1.Id);
        //LnP_LicenseAddressApexController.removeAffiliationRequest(lstparelId,testRequest1.Id);
        LnP_LicenseAddressApexController.undoAffiliateRequest(parcel.Id,'Pending Add','test');
        LnP_LicenseAddressApexController.undoAffiliateRequest(parcel.Id,'Pending Remove','test');
        LnP_LicenseAddressApexController.undoAffiliateRequest(parcel.Id,'Pending Remove',null);
        LnP_LicenseAddressApexController.setLocationTable(testApp.Id, testRequest1.Id, true,true);
        LnP_LicenseAddressApexController.setLocationTable(testApp.Id, testRequest1.Id, false,true);
        LnP_LicenseAddressApexController.setLocationTable(testApp.Id, testRequest1.Id, false,false);
        test.stopTest();
    }
     public static testMethod void LnP_LicenseAddressApexControllerMethod3(){
         Contact con = [Select Id from contact where LastName= 'Test Contact' ]; 
         Account acc = [Select Id from Account where Name= 'Test Account' ]; 
         Id applicationRecordTypeId = Schema.SObjectType.MUSW__Application2__c.getRecordTypeInfosByDeveloperName().get('General_Service_Request').getRecordTypeId();
         MUSW__Application2__c testApp = DOL_TestDataFactory.createApplication(applicationRecordTypeId);
         MUSW__Parcel__c parcel = [Select Id,Application_BG__c from MUSW__Parcel__c where MUSW__Primary_Contact__c=: con.Id limit 1];
        MUSW__Parcel__c parcelPhysical = [Select Id,Application_BG__c from MUSW__Parcel__c where Primary_Account__c=: acc.Id limit 1];
        parcel.Application_BG__c = testApp.Id;
        parcelPhysical.Application_BG__c = testApp.Id;
        update parcel;
        update parcelPhysical;
        SOD_Address_Auth__c objCS = new SOD_Address_Auth__c(Name = 'Auto_Complete_Address');
         objCS.url__c ='https://us-autocomplete.api.smartystreets.com/suggest?';
             objCS.AuthID__c = '414e1969-26ef-f656-68bc-668f24ce0b8d';
             objCS.AuthToken__c = 'VgUZjHEiR0cQd7LrsfEq';
         objCS.Key__c = '33656206653415784';
         insert objCS;
         test.startTest();
         LnP_LicenseAddressApexController.AddrWrapper wrapper = new LnP_LicenseAddressApexController.AddrWrapper();
         wrapper.country = 'country';
         wrapper.street ='Street';
         wrapper.street2 ='street2';
         wrapper.city ='city';
         wrapper.state ='state';
         wrapper.zip ='zip';
         
         LnP_LicenseAddressApexController.addContactparcel(con.Id,parcel.Id);
         LnP_LicenseAddressApexController.getloggedInContactData();
         LnP_LicenseAddressApexController.getAutoComplete('test');
         StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
         test.stopTest();
         
     }
}