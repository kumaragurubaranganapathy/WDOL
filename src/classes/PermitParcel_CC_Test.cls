/**
* User Story: 78 - Associate addresses to a Plan Review/PTO Type
* Name: PermitParcel_CC_Test
* Type: Test Class
* Description: Test Class for PermitParcel_CC
* Date:        Developer/Company                    Description
* ---------------------------------------------------------------------------------------------------------------------------------------- *
* 07/19/2018   Srikanth Kottam/Deloitte           Initial Creation
**/
@isTest
public class PermitParcel_CC_Test {
    public static testmethod void testIndividualLicense(){
        List<Account> accList = new List<Account>();
        
        /** Account Creation **/ 
        Account a = CreateTestDataUtility.createAccount();
        accList.add(a);
        insert accList;
        
        /** Contact Creation **/
        Contact c = CreateTestDataUtility.createContact(a.Id);
        insert c;
        Id recordTypeId = Schema.SObjectType.MUSW__Permit2__c.getRecordTypeInfosByName().get('All').getRecordTypeId();
        MUSW__Permit2__c permit = new MUSW__Permit2__c(RecordTypeId = recordTypeId,
                                                          MUSW__Status__c='Pending',
                                                          App_Submitted_Date__c=System.today(),
                                                          Object_Type__c = 'Plan Review', 
                                                          Application_Type__c = 'Plan Review', 
                                                       	  Program_Area__c = 'POWTS', 
                                                       	  Permit_Type__c = 'POWTS Petition for Variance');
        permit.MUSW__Applicant__c =c.id;
        insert permit;
        test.startTest();
        List<MUSW__Parcel__c> lstParcelAddresses = new List<MUSW__Parcel__c>();
        lstParcelAddresses.add(CreateTestDataUtility.createContactParcel(c.id,  '801 International Pkwy', 'Lake Mary','FL', '32746', 'United States'));
        lstParcelAddresses.add(CreateTestDataUtility.createContactParcel(c.id,  '901 International Pkwy', 'Lake Mary','FL', '32746', 'United States'));
        insert lstParcelAddresses;

        MUSW__Permit_Parcel__c permitParcel = new MUSW__Permit_Parcel__c(MUSW__Permit2__c = permit.Id, MUSW__Parcel__c = lstParcelAddresses[0].Id);
        insert permitParcel;

        ApexPages.StandardController sc = new ApexPages.StandardController(permitParcel);
        PermitParcel_CC lp= new PermitParcel_CC(sc);
        
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
            
        lp.savePermitAddress();

        List<MUSW__License_Parcel__c> lstParcelAddressesSaved = [SELECT MUSW__License2__c FROM MUSW__License_Parcel__c WHERE MUSW__Parcel__c=:lstParcelAddresses[0].Id];

        //System.assertEquals(lstParcelAddressesSaved.size(), 2);
            
        //Trying to force an exception
        lp.mailingAddressId = permit.Id;
        lp.savePermitAddress();
        test.stopTest();  
        List<Apexpages.Message> msgs = ApexPages.getMessages();
            boolean b = false;
            for(Apexpages.Message msg:msgs){
                if (msg.getSeverity() == ApexPages.Severity.ERROR) b = true;
            }
            //System.assert(b);
    }
    
    @isTest 
    static void testConstructor(){
        PermitParcel_CC controller = new PermitParcel_CC();
    }   
}