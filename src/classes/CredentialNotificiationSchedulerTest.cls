@isTest
private class CredentialNotificiationSchedulerTest {

    @testSetup 
    static void setUpTestData(){
        
        Global_Settings__c globalSettings = new Global_Settings__c(Name = Userinfo.getUserName(), Disable_Triggers__c = true);
		insert globalSettings; 
        
        Account acc1 = CreateTestDataUtility.createCitizenAccount();
        Database.insert(acc1);
        Account acc = CreateTestDataUtility.createAccount();
        Database.insert(acc);

        Contact c = CreateTestDataUtility.createContact(acc.Id);
        Database.insert(c);
        
        List<MUSW__License2__c> lstLicenses = new List<MUSW__License2__c>();
         List<MUSW__Permit2__c> lstpermits = new List<MUSW__Permit2__c>();
        List<MUSW__License2__c> lstLicensesToUpdate = new List<MUSW__License2__c>();
        
        /***** Insert License #1 *****/
        MUSW__License2__c license1 = CreateTestDataUtility.createLicense(acc.id, c.id);
        license1.MUSW__Expiration_Date__c = Date.today();
           license1.Next_Notification_Attempt__c=1;
        license1.MUSW__Status__c='Active';
        lstLicenses.add(license1);
       
        
  /***** Insert  Permit #1 *****/        
          MUSW__Permit2__c permit = CreateTestDataUtility.createPermit(acc.id, c.id);
        permit.MUSW__Expiration_Date__c = Date.today();
        permit.Next_Notification_Attempt__c=1;
                permit.MUSW__Status__c='Active';
        lstpermits.add(permit);
       
        
        /***** Insert all Licenses *****/
        insert lstLicenses;
        insert lstpermits;
		delete(globalSettings); 
    }

    static testMethod void testSchedulableClass() {
        
        Global_Settings__c globalSettings = new Global_Settings__c(Name = Userinfo.getUserName(), Disable_Triggers__c = true);
		insert globalSettings; 
        //Check if Next Notification Date and Attempt were set
        List<MUSW__License2__c> lstLicenses = [Select Id, Next_Notification_Date__c, Next_Notification_Attempt__c From MUSW__License2__c Limit 100];
        Integer numOfLicenses = lstLicenses.size();
        for(MUSW__License2__c licenseCheck : lstLicenses){
            system.assertNotEquals(licenseCheck.Next_Notification_Attempt__c, null);
        }
        
        Test.startTest();
        
        String CRON_EXP = '0 0 0 15 3 ? 2022';
        String jobId = System.schedule('CredentialNotificationScheduler'+Date.today(), CRON_EXP, new CredentialNotificationScheduler());
        
        //Get the information from the CronTrigger API object
        CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE id = :jobId];
        
        //Verify the job has not run
        System.assertEquals(0, ct.TimesTriggered);
        
        Test.stopTest();
        delete(globalSettings); 
    }
    
    //This method will send the initial renewal email 
    static testMethod void testBatch01() {
        //Check if Next Notification Date and Attempt were set
        List<MUSW__License2__c> lstLicenses = [Select Id, Next_Notification_Date__c, Next_Notification_Attempt__c From MUSW__License2__c limit 100];
        Integer numOfLicenses = lstLicenses.size();
        for(MUSW__License2__c licenseCheck : lstLicenses){
            system.assertNotEquals(licenseCheck.Next_Notification_Attempt__c, null);
        }
        
        Test.startTest();
        
        
		Global_Settings__c globalSettings = new Global_Settings__c(Name = Userinfo.getUserName(), Disable_Triggers__c = true);
		insert globalSettings; 
        
        List<Email_Notification__c> lstNotifications = [Select Id From Email_Notification__c];
        //Verify no email notification is sent as of now
        System.assertEquals(0, lstNotifications.size());
        
        //Invoke Batch Class
        String query = 'Select Id, Name, MUSW__Applicant__r.FirstName, MUSW__Applicant__r.LastName, MUSW__Applicant__r.Name, MUSW__Primary_Licensee__r.Email_Primary_Contact__c, MUSW__Status__c, ' + 
            'MUSW__Expiration_Date__c, Next_Notification_Date__c, Next_Notification_Attempt__c, Business_License__c, OwnerId,Credential__c, ' + 
            'Is_Renewal_Eligible__c, Account_Email__c,Sub_Status__c ' + 
            ' From MUSW__License2__c where Next_Notification_Date__c = TODAY '+
            ' or MUSW__Status__c = \'Active\'' +
            ' or (MUSW__Status__c = \'Inactive\' AND Sub_Status__c = \'Expired\') LIMIT 200' ;
        
        CredentialNotificationBatch batch = new CredentialNotificationBatch(query);
        Integer BatchSize = Email_Utility.getBatchSize();
        Database.executeBatch(batch, 200);
        
        delete(globalSettings); 
        
        Test.stopTest();
        
        //Once the batch has run, verify if the notification record was created
        lstNotifications = [Select Id From Email_Notification__c];
        //Verify that 1 email notification was sent
        //System.assertEquals(numOfLicenses, lstNotifications.size());
    }
    
     static testMethod void testSchedulableClass2() {
        
        Global_Settings__c globalSettings = new Global_Settings__c(Name = Userinfo.getUserName(), Disable_Triggers__c = true);
		insert globalSettings; 
        //Check if Next Notification Date and Attempt were set
        List<MUSW__Permit2__c> lstpermits = [Select Id, Next_Notification_Date__c, Next_Notification_Attempt__c From MUSW__Permit2__c Limit 100];
        Integer numOfLicenses = lstpermits.size();
        for(MUSW__Permit2__c licenseCheck : lstpermits){
            system.assertNotEquals(licenseCheck.Next_Notification_Attempt__c, null);
        }
        
        Test.startTest();
        
        String CRON_EXP = '0 0 0 15 3 ? 2022';
        String jobId = System.schedule('PermitNotificationScheduler'+Date.today(), CRON_EXP, new PermitNotificationScheduler());
        
        //Get the information from the CronTrigger API object
        CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE id = :jobId];
        
        //Verify the job has not run
        System.assertEquals(0, ct.TimesTriggered);
        
        Test.stopTest();
        delete(globalSettings); 
    }
    
        static testMethod void testBatch02() {
        //Check if Next Notification Date and Attempt were set
        List<MUSW__Permit2__c> lstLicenses = [Select Id, Next_Notification_Date__c, Next_Notification_Attempt__c From MUSW__Permit2__c limit 100];
        Integer numOfLicenses = lstLicenses.size();
        for(MUSW__Permit2__c licenseCheck : lstLicenses){
            system.assertNotEquals(licenseCheck.Next_Notification_Attempt__c, null);
        }
        
        Test.startTest();
        
        
		Global_Settings__c globalSettings = new Global_Settings__c(Name = Userinfo.getUserName(), Disable_Triggers__c = true);
		insert globalSettings; 
        
        List<Email_Notification__c> lstNotifications = [Select Id From Email_Notification__c];
        //Verify no email notification is sent as of now
        System.assertEquals(0, lstNotifications.size());
        
        //Invoke Batch Class
        String query = 'Select Id, Name, MUSW__Applicant__r.FirstName, MUSW__Applicant__r.LastName, MUSW__Applicant__r.Name, MUSW__Account__r.Email_Primary_Contact__c, MUSW__Status__c, ' + 
            'MUSW__Expiration_Date__c, Next_Notification_Date__c, Next_Notification_Attempt__c, Business_License__c, OwnerId,permit_type__c, ' + 
            'Is_Renewal_Eligible__c, Account_Email__c,Sub_Status__c ' + 
            ' From MUSW__Permit2__c where Next_Notification_Date__c = TODAY '+
            ' or MUSW__Status__c = \'Active\'' +
            ' or MUSW__Status__c = \'Conditional Approved\'' +
            ' or (MUSW__Status__c = \'Inactive\' AND Sub_Status__c = \'Expired\') Limit 200' ;
        
        PermitNotificationBatch batch = new PermitNotificationBatch(query);
        Integer BatchSize = Email_Utility.getBatchSize();
        Database.executeBatch(batch, 200);
        
        delete(globalSettings); 
        
        Test.stopTest();
        lstNotifications = [Select Id From Email_Notification__c];
    }
    
}