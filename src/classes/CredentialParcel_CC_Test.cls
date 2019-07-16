/**
* User Story: 78 - Associate addresses to a Credential Type
* Name: CredentialParcel_CC_Test
* Type: Test Class
* Description: Test Class for CredentialParcel_CC
* Date:        Developer/Company                    Description
* ---------------------------------------------------------------------------------------------------------------------------------------- *
* 07/18/2018   Srikanth Kottam/Deloitte           Initial Creation
**/
@isTest
public class CredentialParcel_CC_Test {
    public static testmethod void testIndividualLicense(){
        List<Account> accList = new List<Account>();
        
        /** Account Creation **/ 
        Account a = CreateTestDataUtility.createAccount();
        accList.add(a);
        insert accList;
        
        /** Contact Creation **/
        Contact c = CreateTestDataUtility.createContact(a.Id);
        insert c;
        Id recordTypeId = Schema.SObjectType.MUSW__License2__c.getRecordTypeInfosByName().get('Universal Default License Record Type').getRecordTypeId();
        MUSW__License2__c license = new MUSW__License2__c(RecordTypeId = recordTypeId,
                                                          MUSW__Status__c='Pending',
                                                          App_Submitted_Date__c=System.today(),
                                                          Application_Type__c = 'Trades Credential', 
                                                          Credential_Type__c = 'Dwelling Contractor', 
                                                          Credential__c = 'Dwelling Contractor', 
                                                          Application_Method__c = 'General Application');
        license.MUSW__Applicant__c =c.id;
        insert license;
        test.startTest();
        List<MUSW__Parcel__c> lstParcelAddresses = new List<MUSW__Parcel__c>();
        lstParcelAddresses.add(CreateTestDataUtility.createContactParcel(c.id,  '801 International Pkwy', 'Lake Mary','FL', '32746', 'United States'));
        lstParcelAddresses.add(CreateTestDataUtility.createContactParcel(c.id,  '901 International Pkwy', 'Lake Mary','FL', '32746', 'United States'));
        insert lstParcelAddresses;

        MUSW__License_Parcel__c licenseParcel = new MUSW__License_Parcel__c(MUSW__License2__c = license.Id, MUSW__Parcel__c = lstParcelAddresses[0].Id);
        insert licenseParcel;

        ApexPages.StandardController sc = new ApexPages.StandardController(licenseParcel);
        CredentialParcel_CC lp= new CredentialParcel_CC(sc);
        
        system.debug('mailingAddressId'+lp.mailingAddressId);
        system.debug('publicAddressId'+lp.publicAddressId);
        system.debug('physicalAddressId'+lp.physicalAddressId);
        // system.debug('licId'+lp.licId);
        // system.debug('licenseBoard'+lp.licenseBoard);
        //LicenseParcelControllerExt.ArchivP = licenseParcel;
        List<SelectOption> so = new List<SelectOption>();
        //LicenseParcelControllerExt.addressOptions = so;
            
        MUSW__Parcel_Contact2__c parcelContact = CreateTestDataUtility.createParcelContactJunction(lstParcelAddresses[0].id, c.id);
        insert parcelContact;
        parcelContact = CreateTestDataUtility.createParcelContactJunction(lstParcelAddresses[1].id, c.id);
        insert parcelContact;
            
        List<SelectOption> lstAddressOptions = lp.addressOptions;
        //system.assertEquals(lstParcelAddresses.size(), lstAddressOptions.size());
            
        lp.mailingAddressId = lstParcelAddresses[0].Id;
        lp.publicAddressId = lstParcelAddresses[0].Id;
            
        lp.saveCredentialAddress();

        List<MUSW__License_Parcel__c> lstParcelAddressesSaved = [SELECT MUSW__License2__c FROM MUSW__License_Parcel__c WHERE MUSW__Parcel__c=:lstParcelAddresses[0].Id];

        //System.assertEquals(lstParcelAddressesSaved.size(), 2);
            
        //Trying to force an exception
        lp.mailingAddressId = license.Id;
        lp.saveCredentialAddress();
        test.stopTest();  
        List<Apexpages.Message> msgs = ApexPages.getMessages();
            boolean b = false;
            for(Apexpages.Message msg:msgs){
                if (msg.getSeverity() == ApexPages.Severity.ERROR) b = true;
            }
            //System.assert(b);

    }
    
 /*   public static Testmethod void testBusinessLicense(){
        List<Account> accList = new List<Account>();
        
        // Account Creation  
        Account a = CreateTestDataUtility.createAccount();
        accList.add(a);
        insert accList;
        
        // Contact Creation 
        Contact c = CreateTestDataUtility.createContact(a.Id);
        insert c;
        
        Id recordTypeId = Schema.SObjectType.MUSW__License2__c.getRecordTypeInfosByName().get('Universal Default License Record Type').getRecordTypeId();
        MUSW__License2__c license = new MUSW__License2__c(RecordTypeId = recordTypeId,
                                                          MUSW__Status__c='Pending',
                                                          App_Submitted_Date__c=System.today(),
                                                          Application_Type__c = 'Trades Credential', 
                                                          Credential_Type__c = 'Dwelling Contractor', 
                                                          Credential__c = 'Dwelling Contractor', 
                                                          Application_Method__c = 'General Application',
                                                          MUSW__Primary_Licensee__c=a.id);
        license.MUSW__Applicant__c =c.id;
        insert license;
        test.startTest();
        List<MUSW__Parcel__c> lstParcelAddresses = new List<MUSW__Parcel__c>();
        lstParcelAddresses.add(CreateTestDataUtility.createContactParcel(c.id,  '801 International Pkwy', 'Lake Mary','FL', '32746', 'United States'));
        lstParcelAddresses.add(CreateTestDataUtility.createContactParcel(c.id,  '901 International Pkwy', 'Lake Mary','FL', '32746', 'United States'));
        insert lstParcelAddresses;

        //system.assertNotEquals(lstParcelAddresses[0].Id, null);

        MUSW__License_Parcel__c licenseParcel = new MUSW__License_Parcel__c(MUSW__License2__c = license.Id, MUSW__Parcel__c = lstParcelAddresses[0].Id);
        insert licenseParcel;

        ApexPages.StandardController sc = new ApexPages.StandardController(licenseParcel);
        CredentialParcel_CC lp= new CredentialParcel_CC(sc);
            
        Parcel_Account__c parcelAccount = CreateTestDataUtility.createParcelAccountJunction(lstParcelAddresses[0].id, a.id);
        insert parcelAccount;
        parcelAccount = CreateTestDataUtility.createParcelAccountJunction(lstParcelAddresses[1].id, a.id);
        insert parcelAccount;
        
        //system.assertEquals(lp.licenseBoard,Label.BRD_SAN );

        List<SelectOption> lstAddressOptions = lp.addressOptions;
        //system.assertEquals(lstParcelAddresses.size(), lstAddressOptions.size());

        //system.assertEquals(lp.licenseBoard,Label.BRD_SAN );
            
        lp.mailingAddressId = lstParcelAddresses[0].Id;
        lp.publicAddressId = lstParcelAddresses[0].Id;
        //lp.physicalAddressId = lstParcelAddresses[0].Id;
            
        lp.saveCredentialAddress();
        test.stopTest();
        List<MUSW__License_Parcel__c> lstParcelAddressesSaved = [SELECT MUSW__License2__c FROM MUSW__License_Parcel__c WHERE MUSW__Parcel__c=:lstParcelAddresses[0].Id];

        //System.assertEquals(lstParcelAddressesSaved.size(), 3);
    }  */
    @isTest 
    static void testConstructor(){
        CredentialParcel_CC controller = new CredentialParcel_CC();
    }   
}