@isTest
private class Email_Utility_Test {

    static testMethod void testMethod01() {
    	//Test by providing an email body
    	Account acc = CreateTestDataUtility.createAccount();
    	insert acc;
     	
     	Contact cont = CreateTestDataUtility.createContact(acc.Id);
     	insert cont;
    	
    	String body = '<div>Test HTML Content</div>';
    	String subject = 'Test Email';
    	
        Email_Utility email = new Email_Utility(cont.Id, subject, body);
        List<Email_Utility> lstNotifications = new List<Email_Utility>();
        lstNotifications.add(email);
        
        Email_Utility.sendEmailUsingBody(lstNotifications);
        
        List<Email_Notification__c> lstInsertedNotifications = [Select Id From Email_Notification__c limit 100];
        system.assertEquals(lstNotifications.size(), lstInsertedNotifications.size());
    }
    
    static testMethod void testMethod02() {
    	//Test by providing email parameters
    	Account acc = CreateTestDataUtility.createAccount();
    	insert acc;
     	
     	Contact cont = CreateTestDataUtility.createContact(acc.Id);
     	insert cont;
    	
    	String subject = 'Test Email';
    	Map<String, String> mapParamValues = new Map<String, String>();
    	mapParamValues.put('Param1','First Name');
    	mapParamValues.put('Param2','Last Name');
    	
        Email_Utility email = new Email_Utility(cont.Id, subject, mapParamValues);
        List<Email_Utility> lstNotifications = new List<Email_Utility>();
        lstNotifications.add(email);
        
        Email_Utility.sendEmailUsingParams(lstNotifications);
        
        List<Email_Notification__c> lstInsertedNotifications = [Select Id From Email_Notification__c limit 100];
        system.assertEquals(lstNotifications.size(), lstInsertedNotifications.size());
    }
    
    static testMethod void testMethod03() {
    	//Test by providing emailId instead of contact

		String emailId = 'test@testclass.com';    	
    	String subject = 'Test Email';
    	String body = '<div>Test HTML Content</div>';
    	
        Email_Utility email = new Email_Utility(emailId, subject, body);
        email.taskSubjectName = 'Renewal Reminder Sent';
        List<Email_Utility> lstNotifications = new List<Email_Utility>();
        lstNotifications.add(email);
        
        Email_Utility.sendEmailUsingParams(lstNotifications);
        
        List<Email_Notification__c> lstInsertedNotifications = [Select Id From Email_Notification__c limit 100];
        system.assertEquals(lstNotifications.size(), lstInsertedNotifications.size());
    }
    
    static testMethod void testMethod04() {             
        Account acc = new Account();
        acc = CreateTestDataUtility.createAccount();
        insert acc;
        
        Contact con = CreateTestDataUtility.createContact(acc.Id);
        insert con;   
        
        Musw__License2__c license1 = CreateTestDataUtility.createLicense(acc.Id, con.Id);
        insert license1;
        
        Attachment att = new Attachment(Name = 'testAttachment', parentId = license1.Id);
        att.Body = Blob.valueOf('Test Email Attachment');
        insert att;
        
		Integer batchSize = Email_Utility.getBatchSize();
        
        EmailTemplate template = [SELECT Name from EmailTemplate LIMIT 1];
        Email_Notification__c email = new Email_Notification__c();
        email.Email_Template_Name__c = template.Name;
        email.Credential__c = license1.Id;
        email.Attachment_Parent_Id__c = license1.Id;
        email.Recipient_Contact__c = con.Id;
        email.Attachment_Names__c = 'testAttachment';
        
        List<Email_Notification__c> emailList = new List<Email_Notification__c>();
        emailList.add(email);
        
        insert email;
        Email_Utility.sendApexEmails(emailList);
     }
    
    static testMethod void testMethod05() {
                
		Map<String, List<Email_Reminder_Setting__mdt>> criteriaMap = Email_Utility.getEmailCriteriaMap('Credential');
        
		EmailTemplate template = [SELECT Name from EmailTemplate LIMIT 1];
        Email_Notification__c email = new Email_Notification__c();
        email.Email_Template_Name__c = template.Name;
        email.Type__c = 'Raw HTML Body';
        
        insert email;
     }
}