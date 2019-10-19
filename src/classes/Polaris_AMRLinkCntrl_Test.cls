/* 
*Class Name   : Polaris_AMRLinkCntrl_Test
* Description  : Testclass for Polaris_AMRLinkCntrl
* Created By   : Shreya Surabhi
* Created On   : 10/10/2019 
* Modification Log:  
*------------------------------------------------------------------------------------------------------------------------------------------------------------------------
* Developer                    Date                        Description
*------------------------------------------------------------------------------------------------------------------------------------------------------------------------
*
*/
@isTest
public class Polaris_AMRLinkCntrl_Test{
    static testMethod void testMethod1(){
        Id accRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Business Account').getRecordTypeId();
        Account accObj = DOL_TestDataFactory.createAccount(accRecordTypeId);
        //Create Contact
        Contact con = new Contact(LastName = DOL_AppConstants.NULL_EMPTY_STRING + 'firstConLastName', firstName = DOL_AppConstants.NULL_EMPTY_STRING + 'firstConFirstName', Email= DOL_AppConstants.NULL_EMPTY_STRING + 'firstcon@mailinator.com', 
                                  Birthdate = Date.newInstance(1947, 05, 01), AccountId = accObj.Id, Social_Security_Number_Encrypted__c = DOL_AppConstants.NULL_EMPTY_STRING + '111222333', 
                                  Duplicate_Override__c = true, Birth_Country__c = DOL_AppConstants.NULL_EMPTY_STRING + 'United States', Birth_State_Province__c= DOL_AppConstants.NULL_EMPTY_STRING + 'Illinois', Birth_City__c= DOL_AppConstants.NULL_EMPTY_STRING + 'Chicago', 
                                  Gender__c= DOL_AppConstants.NULL_EMPTY_STRING + 'Male', Contact_Status__c = 'Inactive', Ethnicity__c= DOL_AppConstants.NULL_EMPTY_STRING + 'Asian Indian', Unique_ID_To_Provide__c = 'SSN');
        insert con;
        Id licRecordTypeId = Schema.SObjectType.MUSW__License2__c.getRecordTypeInfosByName().get('Individual').getRecordTypeId();
        MUSW__License2__c licenseObj = DOL_TestDataFactory.createLicense(licRecordTypeId,accObj.Id,'Geologist','Geologist','General Application');
        
        try { licenseObj.Application__c = '';}
        catch(exception ex){}
        update licenseObj;
        Profile profile1 = [Select Id from Profile where name = 'eSLA Customer Community Plus Login User'];
        
        User user1 = DOL_TestDataFactory.createPortalUser('secondConLastName', 'ppuser', profile1.Id, 'portalplususerone@mailinator.com', con.Id);
        
        
        MUSW__License2__c upgradeLicense = DOL_TestDataFactory.createLicense(licRecordTypeId,accObj.Id,'Appraisers - Real Estate','State Licensed Appraiser','General Application');
        upgradeLicense.MUSW__Primary_Licensee__c = accObj.Id;
        update upgradeLicense;
        
        Request__c reqObj = DOL_TestDataFactory.createRequest(licenseObj.Id,'Geologist','Geologist');
        reqObj.Description__c = 'Request Description';
        update reqObj;
        System.runAs(user1){
        Test.startTest();
        
        try{
            Polaris_AMRLinkCntrl.fetchServiceLinksServer('Geologist','Geologist','General Application');
            Polaris_AMRLinkCntrl.fetchServiceLinksServer('Geologist','Geologist',null);
        }
        catch(Exception ex)
        {
            DOL_CreateErrorLog_Exception.logApplicationError(ex);
            }
        try{
            Polaris_AMRLinkCntrl.printUpdateLicense(licenseObj.Id,'download');
            Polaris_AMRLinkCntrl.printUpdateLicense(licenseObj.Id,null);
        }
        catch(Exception e){
                    DOL_CreateErrorLog_Exception.logApplicationError(e);
                    }
        try{
            Polaris_AMRLinkCntrl.fetchAppId(licenseObj.Id);
            Polaris_AMRLinkCntrl.fetchAppId(null);
        }
        catch(Exception ex)
        {
            DOL_CreateErrorLog_Exception.logApplicationError(ex);
            }
        try{
            Polaris_AMRLinkCntrl.getMetadata('Geologist','Legal Background Update','Geologist');
            Polaris_AMRLinkCntrl.getMetadata('Geologist','CE Audit','Geologist');
        }
        catch(Exception ex)
        {
            DOL_CreateErrorLog_Exception.logApplicationError(ex);
            }
        Polaris_AMRLinkCntrl.fetchBusinessInfo(accObj.Id);
        try{
            Polaris_AMRLinkCntrl.fetchContactInfo();
        }
        catch(Exception ex)
        {
            DOL_CreateErrorLog_Exception.logApplicationError(ex);
            }
        try{
            Polaris_AMRLinkCntrl.fetchAccountInfo(licenseObj.Id);
        }
        catch(Exception ex)
        {
            DOL_CreateErrorLog_Exception.logApplicationError(ex);
            }
        try{
            Polaris_AMRLinkCntrl.fetchWebsiteInfo(licenseObj.Id);
        }
        catch(Exception ex)
        {
            DOL_CreateErrorLog_Exception.logApplicationError(ex);
            }
        try{
            Polaris_AMRLinkCntrl.updateWebsiteInfo(licenseObj.Id,'websiteInfo');
            Polaris_AMRLinkCntrl.updateWebsiteInfo(licenseObj.Id,null);
        }
        catch(Exception ex)
        {
            DOL_CreateErrorLog_Exception.logApplicationError(ex);
            }
        try{
            Polaris_AMRLinkCntrl.createCodeValue('test');
            Polaris_AMRLinkCntrl.createCodeValue(null);
        }
        catch(Exception ex)
        {
            DOL_CreateErrorLog_Exception.logApplicationError(ex);
            }
        try{
            Polaris_AMRLinkCntrl.generateRandomString(5);
        }
        catch(Exception ex)
        {
            DOL_CreateErrorLog_Exception.logApplicationError(ex);
            }
        Polaris_AMRLinkCntrl.insertRequest(licenseObj.Id,'Geologist','Geologist','Legal Background Update',accObj.Id);
        List<Polaris_AMRLinkCntrl.selectListWrapper> returnPicklist = Polaris_AMRLinkCntrl.getPickListData('Funeral Establishment');
        try{
            Polaris_AMRLinkCntrl.createApplication('Geologist','Geologist','Upgrade',accObj.Id,upgradeLicense.Id);
            Polaris_AMRLinkCntrl.createApplication('Geologist','Geologist','Upgrade',accObj.Id,null);
        }
        catch(Exception ex)
        {
            DOL_CreateErrorLog_Exception.logApplicationError(ex);
            }
        
        Polaris_AMRLinkCntrl.updateWebsiteInfo(accObj.id,'createCode');
        Test.stopTest();
        }
        
            
    }
    
    static testMethod void testMethod2(){
        Id accRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Business Account').getRecordTypeId();
        Account accObj = DOL_TestDataFactory.createAccount(accRecordTypeId);
        //Create Contact
        Contact con = new Contact(LastName = DOL_AppConstants.NULL_EMPTY_STRING + 'firstConLastName', firstName = DOL_AppConstants.NULL_EMPTY_STRING + 'firstConFirstName', Email= DOL_AppConstants.NULL_EMPTY_STRING + 'firstcon@mailinator.com', 
                                  Birthdate = Date.newInstance(1947, 05, 01), AccountId = accObj.Id, Social_Security_Number_Encrypted__c = DOL_AppConstants.NULL_EMPTY_STRING + '111222333', 
                                  Duplicate_Override__c = true, Birth_Country__c = DOL_AppConstants.NULL_EMPTY_STRING + 'United States', Birth_State_Province__c= DOL_AppConstants.NULL_EMPTY_STRING + 'Illinois', Birth_City__c= DOL_AppConstants.NULL_EMPTY_STRING + 'Chicago', 
                                  Gender__c= DOL_AppConstants.NULL_EMPTY_STRING + 'Male', Contact_Status__c = 'Inactive', Ethnicity__c= DOL_AppConstants.NULL_EMPTY_STRING + 'Asian Indian', Unique_ID_To_Provide__c = 'SSN');
        insert con;
        Id licRecordTypeId = Schema.SObjectType.MUSW__License2__c.getRecordTypeInfosByName().get('Individual').getRecordTypeId();
        MUSW__License2__c licenseObj = DOL_TestDataFactory.createLicense(licRecordTypeId,accObj.Id,'Geologist','Geologist','General Application');
        
        try { licenseObj.Application__c = '';}
        catch(exception ex){}
        update licenseObj;
        Profile profile1 = [Select Id from Profile where name = 'eSLA Customer Community Plus Login User'];
        
        User user1 = DOL_TestDataFactory.createPortalUser('secondConLastName', 'ppuser', profile1.Id, 'portalplususerone@mailinator.com', con.Id);
        //System.runAs(user1){
        
        MUSW__License2__c upgradeLicense = DOL_TestDataFactory.createLicense(licRecordTypeId,accObj.Id,'Appraisers - Real Estate','State Licensed Appraiser','General Application');
        upgradeLicense.MUSW__Primary_Licensee__c = accObj.Id;
        update upgradeLicense;
        
        Request__c reqObj = DOL_TestDataFactory.createRequest(licenseObj.Id,'Geologist','Geologist');
        reqObj.Description__c = 'Request Description';
        update reqObj;
        
        
        String before = 'Testing base 64 encode';
        Blob beforeblob = Blob.valueOf(before);
        String base64Data = EncodingUtil.base64Encode(beforeblob);
        
        ContentVersion cv = new ContentVersion();
        cv.ContentLocation = 'S';
        cv.VersionData = EncodingUtil.base64Decode(base64Data);
        cv.Title = 'License cversion';
        cv.PathOnClient = 'cversion';
        insert cv;
        
        ContentDocumentLink cdl = new ContentDocumentLink();
        cdl.ContentDocumentId = [SELECT Id, ContentDocumentId FROM ContentVersion WHERE Id =: cv.Id].ContentDocumentId;        
        cdl.LinkedEntityId = licenseObj.Id;
        cdl.ShareType = 'V';
        insert cdl;
        
        
        Test.startTest();
        
       
        try{
            Polaris_AMRLinkCntrl.printUpdateLicense(licenseObj.Id,'download');
            //Polaris_AMRLinkCntrl.printUpdateLicense(licenseObj.Id,null);
        }
        catch(Exception e){
                    DOL_CreateErrorLog_Exception.logApplicationError(e);
                    }
       
       
       
        Test.stopTest();
        //}
        
            
    }
    
}