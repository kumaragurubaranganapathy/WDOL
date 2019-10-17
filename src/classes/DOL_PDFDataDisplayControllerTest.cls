@isTest
public class DOL_PDFDataDisplayControllerTest{
    @isTest
    public static void setUpData(){
        //account record data
        Id AccRecTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Business Account').getRecordTypeId();
        Account accountRecord = DOL_TestDataFactory.createAccount(AccRecTypeId);
        
        //license record data
        Id LicRecTypeId1 = Schema.SObjectType.MUSW__License2__c.getRecordTypeInfosByName().get('Business').getRecordTypeId();
        MUSW__License2__c licenseRecord = DOL_TestDataFactory.createLicense(LicRecTypeId1, accountRecord.Id, 'Architects', 'Architect', 'General Application');
        
        //parcel record data
        Id parcelRecodTypeId = Schema.SObjectType.MUSW__Parcel__c.getRecordTypeInfosByDeveloperName().get('Address').getRecordTypeId() ;
        MUSW__Parcel__c parcelRecord = DOL_TestDataFactory.createParcel(parcelRecodTypeId);
        
        //license parcel record data
        MUSW__License_Parcel__c licenseParcelRecord = DOL_TestDataFactory.createLicenseParcel(licenseRecord.Id, parcelRecord.Id);
        
        //question record data
        Id questionRecordTypeId = Schema.SObjectType.Question__c.getRecordTypeInfosByDeveloperName().get('Review_and_Submit').getRecordTypeId() ;
        Question__c questionRecord = DOL_TestDataFactory.createQuestion(questionRecordTypeId);
        
        //qualifying education record
        Id qualifyingEducationRecordTypeId = Schema.SObjectType.LnP_BackgroundSection__c.getRecordTypeInfosByDeveloperName().get('Qualifying_Education').getRecordTypeId();
        LnP_BackgroundSection__c qualifyingEducationRecord = DOL_TestDataFactory.createBackgroundSection();
        qualifyingEducationRecord.RecordTypeId = qualifyingEducationRecordTypeId;
        update qualifyingEducationRecord;
        
        Test.StartTest(); 
        DOL_PDFDataDisplayController pdfControllerobj = new DOL_PDFDataDisplayController(new ApexPages.StandardController(licenseRecord));  
        Test.StopTest();
    }
}