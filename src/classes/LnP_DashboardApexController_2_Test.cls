@isTest
public class LnP_DashboardApexController_2_Test {
    @isTest static void test_method_one(){
        string businessLicenseType = LnP_DashboardApexController_2.getRecordTypeId('MUSW__License2__c','Business');
        Id businessAccount = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Business Account').getRecordTypeId();
        Account acc= DOL_TestDataFactory.createAccount(businessAccount);
        acc.Email__c = 'test@mailinator.com';
        update acc;
        MUSW__License2__c lic = DOL_TestDataFactory.createLicense(businessLicenseType, acc.Id, 'Architects', 'Architect', 'General Application');
        lic.MUSW__Status__c='In Review';
        update lic;
        
        Associations__c association = DOL_TestDataFactory.createAssociation(lic.Id);
        
        Id conRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Contact').getRecordTypeId();
        Contact con = DOL_TestDataFactory.createContact(conRecordTypeId, acc.Id);
        
        MUSW__Account_Contact__c accCon = DOL_TestDataFactory.createAccountContact(con.Id, acc.Id);
        
        try{
            LnP_DashboardApexController_2.getEducationalHistory(lic.Id);
        }
        catch(Exception ex){
            DOL_CreateErrorLog_Exception.logApplicationError(ex);
       //     System.debug('Error');
        }
        
        try{
            LnP_DashboardApexController_2.setLicenseToInreview(lic.Id);
        }
        catch(Exception ex){
            DOL_CreateErrorLog_Exception.logApplicationError(ex);
         //   System.debug('Error');
        }
        
        try{
            LnP_DashboardApexController_2.setCurrentLicenseTable();
        }
        catch(Exception ex){
            DOL_CreateErrorLog_Exception.logApplicationError(ex);
           // System.debug('Error');
        }
        
        try{
            LnP_DashboardApexController_2.ProfessionalRelationshipTable();
        }
        catch(Exception ex){
            DOL_CreateErrorLog_Exception.logApplicationError(ex);
            //System.debug('Error');
        }
        
        try{
            LnP_DashboardApexController_2.DraftNewLicenseApplicationsTable();
        }
        catch(Exception ex){
            DOL_CreateErrorLog_Exception.logApplicationError(ex);
            //System.debug('Error');
        }
        
        try{
            LnP_DashboardApexController_2.setDraftRenewApplicationsTable();
        }
        catch(Exception ex){
            DOL_CreateErrorLog_Exception.logApplicationError(ex);
            //System.debug('Error');
        }
        
        try{
            LnP_DashboardApexController_2.setDraftMaintananceRequestApplicationsData();
        }
        catch(Exception ex){
            DOL_CreateErrorLog_Exception.logApplicationError(ex);
            //System.debug('Error');
        }
        
        try{
            LnP_DashboardApexController_2.setDraftAMRAppLicenseData(lic.Id);
        }
        catch(Exception ex){
            DOL_CreateErrorLog_Exception.logApplicationError(ex);
            //System.debug('Error');
        }
        
        try{
            LnP_DashboardApexController_2.PendingNewLicenseApplicationsTable();
        }
        catch(Exception ex){
            DOL_CreateErrorLog_Exception.logApplicationError(ex);
            //System.debug('Error');
        }
        
        try{
            LnP_DashboardApexController_2.showExamsTabOnDashboard(lic.Id);
        }
        catch(Exception ex){
            DOL_CreateErrorLog_Exception.logApplicationError(ex);
            //System.debug('Error');
        }
        
        try{
            LnP_DashboardApexController_2.PendingRenewApplicationsTable();
        }
        catch(Exception ex){
            DOL_CreateErrorLog_Exception.logApplicationError(ex);
            //System.debug('Error');
        }
        
        try{
            LnP_DashboardApexController_2.PendingMaintananceRequestApplicationsTable();
        }
        catch(Exception ex){
            DOL_CreateErrorLog_Exception.logApplicationError(ex);
            //System.debug('Error');
        }
        
        try{
            LnP_DashboardApexController_2.CompletedMaintananceRequestApplicationsTable();
        }
        catch(Exception ex){
            DOL_CreateErrorLog_Exception.logApplicationError(ex);
            //System.debug('Error');
        }
        
        try{
            LnP_DashboardApexController_2.fetchLicenseDetailsTable(lic.Id);
        }
        catch(Exception ex){
            DOL_CreateErrorLog_Exception.logApplicationError(ex);
            //System.debug('Error');
        }
        
        try{
            LnP_DashboardApexController_2.fetchEndorsementDetails(lic.Id);
        }
        catch(Exception ex){
            DOL_CreateErrorLog_Exception.logApplicationError(ex);
            //System.debug('Error');
        }
        
        try{
            LnP_DashboardApexController_2.getBusinessRelationShipData(lic.Id);
        }
        catch(Exception ex){
            DOL_CreateErrorLog_Exception.logApplicationError(ex);
            //System.debug('Error');
        }
        
        try{
            LnP_DashboardApexController_2.setPeerRelationShipTable('Architect', lic.Id);
        }
        catch(Exception ex){
            DOL_CreateErrorLog_Exception.logApplicationError(ex);
            //System.debug('Error');
        }
        
        try{
            LnP_DashboardApexController_2.getContact();
        }
        catch(Exception ex){
            DOL_CreateErrorLog_Exception.logApplicationError(ex);
        //    System.debug('Error');
        }
        
        try{
            LnP_DashboardApexController_2.isValidCommunityUser();
        }
        catch(Exception ex){
            DOL_CreateErrorLog_Exception.logApplicationError(ex);
          //  System.debug('Error');
        }
        
        try{
            LnP_DashboardApexController_2.helptextFetch();
        }
        catch(Exception ex){
            DOL_CreateErrorLog_Exception.logApplicationError(ex);
            //System.debug('Error');
        }
        
        try{
            LnP_DashboardApexController_2.checkActiveCart();
        }
        catch(Exception ex){
            DOL_CreateErrorLog_Exception.logApplicationError(ex);
            //System.debug('Error');
        }
        
        Test.startTest();
        LnP_DashboardApexController_2.fetchLicenseDetails(lic.Id);
        LnP_DashboardApexController_2.createAssociationTask(association.Id);
        //LnP_DashboardApexController_2.getEducationalHistory(lic.Id);
        LnP_DashboardApexController_2.uploadAdditionalDocuments(lic.Id);
        //LnP_DashboardApexController_2.setLicenseToInreview(lic.Id);
        //LnP_DashboardApexController_2.fetchLicenseDetailsTable(lic.Id);
        //LnP_DashboardApexController_2.fetchEndorsementDetails(lic.Id);
        LnP_DashboardApexController_2.seperateAccountContactRelationship(accCon.Id);
        //LnP_DashboardApexController_2.getBusinessRelationShipData(lic.Id);
        LnP_DashboardApexController_2.setPeerRelationShipTable('Architect', lic.Id);
        //LnP_DashboardApexController_2.setDraftAMRAppLicenseData(lic.Id);
        //LnP_DashboardApexController_2.showExamsTabOnDashboard(lic.Id);
        //fetchLicenseRelatedEmploymentNEducationalHistoryRecords(String relatedRecordId);
        //fetchRenewalRelatedEmploymentNEducationalHistoryRecords(String relatedRecordId);
              LnP_DashboardApexController.getDBJSON();  
        Test.stopTest();
    }
}