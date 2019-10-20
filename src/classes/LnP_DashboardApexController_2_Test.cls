@IsTest
public class LnP_DashboardApexController_2_Test {
    @IsTest 
    public static void test_method_one(){
        
        Id businessAccount = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Business Account').getRecordTypeId();
        Account acc= DOL_TestDataFactory.createAccount(businessAccount);
        acc.Email__c = 'test@mailinator.com';
        update acc;
        Id conRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Contact').getRecordTypeId();
        Contact con = DOL_TestDataFactory.createContact(conRecordTypeId, acc.Id);
        
        String businessLicenseType = LnP_DashboardApexController_2.getRecordTypeId('MUSW__License2__c','Business');
        MUSW__License2__c lic = DOL_TestDataFactory.createLicense(businessLicenseType, 
                                                                  acc.Id, 'Architects', 
                                                                  'Architect', 
                                                                  'General Application');
        lic.MUSW__Status__c='In Review';
        lic.MUSW__Applicant__c = con.id;
        update lic;
        
        Associations__c association = DOL_TestDataFactory.createAssociation(lic.Id);
        
        
        Profile profile1 = [Select Id from Profile where name = 'System Administrator'];
        Id conRecTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Contact').getRecordTypeId();
        
        User u1 = DOL_TestDataFactory.createPortalUser('Portal Lname', 'pLnamePortal', profile1.Id, 'test785@mailinator.com', con.Id);
        
        
        MUSW__Account_Contact__c accCon = DOL_TestDataFactory.createAccountContact(con.Id, acc.Id);
        
        // create Employment History
        Id employmentHistoryRecId = LnP_DashboardApexController_2.getRecordTypeId('Employment_History__c','Default_Employment_History');
    	DOL_TestDataFactory.getEmploymentHistory(employmentHistoryRecId, lic.id);
        
        try{
            Test.startTest();
            Id Renewal_ApplicationRecId = Schema.SObjectType.Renewal_Application__c.getRecordTypeInfosByName().get('Business').getRecordTypeId();
            Schema.SObjectType sObjType = Renewal_ApplicationRecId.getSobjectType();
            String sobjName =  sObjType.getDescribe().getName();
            system.debug('sobjName'+sobjName);
            LnP_DashboardApexController_2.setAbandonStatus(Renewal_ApplicationRecId);
            LnP_DashboardApexController_2.uploadAdditionalDocuments(lic.Id);
            LnP_DashboardApexController_2.createAssociationTask(association.Id);
            LnP_DashboardApexController_2.getEducationalHistory(lic.Id);
            LnP_DashboardApexController_2.setLicenseToInreview(lic.Id);
            LnP_DashboardApexController_2.setCurrentLicenseTable();
            LnP_DashboardApexController_2.ProfessionalRelationshipTable();
            LnP_DashboardApexController_2.DraftNewLicenseApplicationsTable();
            LnP_DashboardApexController_2.setDraftRenewApplicationsTable();
            LnP_DashboardApexController_2.setDraftMaintananceRequestApplicationsData();
            LnP_DashboardApexController_2.setDraftAMRAppLicenseData(lic.Id);
            LnP_DashboardApexController_2.PendingNewLicenseApplicationsTable();
            LnP_DashboardApexController_2.showExamsTabOnDashboard(lic.Id);
            LnP_DashboardApexController_2.PendingRenewApplicationsTable();
            LnP_DashboardApexController_2.PendingMaintananceRequestApplicationsTable();
            LnP_DashboardApexController_2.CompletedMaintananceRequestApplicationsTable();
            LnP_DashboardApexController_2.fetchLicenseDetailsTable(lic.Id);
            LnP_DashboardApexController_2.fetchEndorsementDetails(lic.Id);
            LnP_DashboardApexController_2.getBusinessRelationShipData(lic.Id);
            LnP_DashboardApexController_2.setPeerRelationShipTable('Architect', lic.Id);
            LnP_DashboardApexController_2.getContact();
            LnP_DashboardApexController_2.isValidCommunityUser();
            LnP_DashboardApexController_2.helptextFetch();
            LnP_DashboardApexController_2.checkActiveCart();
            LnP_DashboardApexController_2.fetchLicenseDetails(lic.Id);
            LnP_DashboardApexController_2.getEducationalHistory(lic.Id);
            LnP_DashboardApexController_2.uploadAdditionalDocuments(lic.Id);
            LnP_DashboardApexController_2.setLicenseToInreview(lic.Id);
            LnP_DashboardApexController_2.fetchLicenseDetailsTable(lic.Id);
            LnP_DashboardApexController_2.fetchEndorsementDetails(lic.Id);
            LnP_DashboardApexController_2.seperateAccountContactRelationship(accCon.Id);
            LnP_DashboardApexController_2.seperateAssociateRelationship(association.Id);
            LnP_DashboardApexController_2.getBusinessRelationShipData(lic.Id);
            LnP_DashboardApexController_2.setPeerRelationShipTable('Architect', lic.Id);
            LnP_DashboardApexController_2.setPeerRelationShipTable('Architect Firm', lic.Id);
            LnP_DashboardApexController_2.setDraftAMRAppLicenseData(lic.Id);
            LnP_DashboardApexController_2.showExamsTabOnDashboard(lic.Id);
            LnP_DashboardApexController_2.updateAssociateRelationship(association.Id,'FAKE');
            Test.stopTest();
        }
        catch(Exception ex){
           DOL_CreateErrorLog_Exception.logApplicationError(ex);
           System.debug('Error Occured :- '+ex.getMessage()+' stack Trace :- '+ex.getStackTraceString() );
        }
    }
   
    @IsTest 
   	public static void test_method_two(){
        Test.startTest();
        User portaluser = DOL_TestDataFactory.createPortalAccountUser();
        System.runAs ( portaluser ) {
        	LnP_DashboardApexController_2.getDBJSON();
        } 
        Test.stopTest();
    }
    
    @IsTest
    public static void test_method_three(){
        try{
            Id businessAccount = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Business Account').getRecordTypeId();
        	Account acc= DOL_TestDataFactory.createAccount(businessAccount);
            Test.startTest();
            LnP_DashboardApexController_2.setAbandonStatus(acc.Id);
            LnP_DashboardApexController_2.uploadAdditionalDocuments(acc.Id);
            LnP_DashboardApexController_2.createAssociationTask(acc.Id);
            LnP_DashboardApexController_2.getEducationalHistory(acc.Id);
            LnP_DashboardApexController_2.setLicenseToInreview(acc.Id);
            LnP_DashboardApexController_2.setCurrentLicenseTable();
            LnP_DashboardApexController_2.ProfessionalRelationshipTable();
            LnP_DashboardApexController_2.DraftNewLicenseApplicationsTable();
            LnP_DashboardApexController_2.setDraftRenewApplicationsTable();
            LnP_DashboardApexController_2.setDraftMaintananceRequestApplicationsData();
            LnP_DashboardApexController_2.setDraftAMRAppLicenseData(acc.Id);
            LnP_DashboardApexController_2.PendingNewLicenseApplicationsTable();
            LnP_DashboardApexController_2.showExamsTabOnDashboard(acc.Id);
            LnP_DashboardApexController_2.PendingRenewApplicationsTable();
            LnP_DashboardApexController_2.PendingMaintananceRequestApplicationsTable();
            LnP_DashboardApexController_2.CompletedMaintananceRequestApplicationsTable();
            LnP_DashboardApexController_2.fetchLicenseDetailsTable(acc.Id);
            LnP_DashboardApexController_2.fetchEndorsementDetails(acc.Id);
            LnP_DashboardApexController_2.getBusinessRelationShipData(acc.Id);
            LnP_DashboardApexController_2.setPeerRelationShipTable('Architect', acc.Id);
            LnP_DashboardApexController_2.getContact();
            LnP_DashboardApexController_2.isValidCommunityUser();
            LnP_DashboardApexController_2.helptextFetch();
            LnP_DashboardApexController_2.checkActiveCart();
            LnP_DashboardApexController_2.fetchLicenseDetails(acc.Id);
            LnP_DashboardApexController_2.getEducationalHistory(acc.Id);
            LnP_DashboardApexController_2.uploadAdditionalDocuments(acc.Id);
            LnP_DashboardApexController_2.setLicenseToInreview(acc.Id);
            LnP_DashboardApexController_2.fetchLicenseDetailsTable(acc.Id);
            LnP_DashboardApexController_2.fetchEndorsementDetails(acc.Id);
            LnP_DashboardApexController_2.seperateAccountContactRelationship(acc.Id);
            LnP_DashboardApexController_2.seperateAssociateRelationship(acc.Id);
            LnP_DashboardApexController_2.getBusinessRelationShipData(acc.Id);
            LnP_DashboardApexController_2.setPeerRelationShipTable('Architect', acc.Id);
            LnP_DashboardApexController_2.setPeerRelationShipTable('Architect Firm', acc.Id);
            LnP_DashboardApexController_2.setDraftAMRAppLicenseData(acc.Id);
            LnP_DashboardApexController_2.showExamsTabOnDashboard(acc.Id);
            LnP_DashboardApexController_2.updateAssociateRelationship(acc.Id,'FAKE');
            Test.stopTest();
        }
        catch(Exception ex){
           DOL_CreateErrorLog_Exception.logApplicationError(ex);
           System.debug('Error Occured :- '+ex.getMessage()+' stack Trace :- '+ex.getStackTraceString() );
        }
    }
    
    
    
}