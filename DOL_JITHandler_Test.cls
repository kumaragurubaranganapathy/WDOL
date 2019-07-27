@isTest
public class DOL_JITHandler_Test {
    
    // Contact and associated User exists
    // Contact and associated User exists
    @isTest static void testUserExists(){
        Id acctRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('User Account').getRecordTypeId();
        Id contRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Contact').getRecordTypeId();
        Account Acc = new Account();
        acc.name= 'testAccount';
        acc.RecordTypeId = acctRecordTypeId;
        acc.Account_Status__c  = 'Active';
        insert acc;
        
        Contact con1 = new Contact();
        con1.firstName = 'SSOfirstName';
        con1.lastName = 'SSOLastName';
        con1.Email = 'test@gmail.com';
        con1.Recordtypeid = contRecordTypeId;
        con1.AccountId = acc.id;
        insert con1;
        
        final Map<String, String> attributes = new Map<String, String> {
            'urn:oid:2.5.4.42' => 'con1.FirstName',
			'urn:oid:2.5.4.4' => 'con1.LastName',
			'urn:oid:0.9.2342.19200300.100.1.3' => 'contactUser@email.ca',
			'urn:mace:dir:attribute-def:ubcEduCwlPuid' => 'aaaJMvPrGO1b',
			'User.IsActive' => '1',
			'urn:oid:0.9.2342.19200300.100.1.1' => 'aaakzeS7' //SAML Attribute CWL
        };
              
        User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
        System.runAs (thisUser) {
            DOL_JITHandler handObj = new DOL_JITHandler();
            String fedId = 'aaaJMvPrGO1b';
            String username = 'testUser';
            User us = handObj.createUser(con1, fedId, username);
            us.FederationIdentifier = 'aaaJMvPrGO1b';
            //us.Alias = 'fname';
            update us;
            System.assertEquals('test@gmail.com', us.Email);
            
            Test.startTest();
				handObj.updateUser(us.id, null, null, null,fedId, attributes, null);
            Test.stopTest();
        }
    }
    @isTest static void testUserDoesnotExist(){
        Id acctRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('User Account').getRecordTypeId();
        Id contRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Contact').getRecordTypeId();
        Account Acc = new Account();
        acc.name= 'testAccount';
        acc.RecordTypeId = acctRecordTypeId;
        acc.Account_Status__c  = 'Active';
        insert acc;
        
        Contact con1 = new Contact();
        con1.firstName = 'SSOfirstName';
        con1.lastName = 'SSOLastName';
        con1.Email = 'test@gmail.com';
        con1.Recordtypeid = contRecordTypeId;
        con1.AccountId = acc.id;
        insert con1;
        
        final Map<String, String> attributes = new Map<String, String> {
            'urn:oid:2.5.4.42' => 'con1.FirstName',
			'urn:oid:2.5.4.4' => 'con1.LastName',
			'urn:oid:0.9.2342.19200300.100.1.3' => 'contactUser@email.ca',
			'urn:mace:dir:attribute-def:ubcEduCwlPuid' => 'aaaJMvPrGO1b',
			'User.IsActive' => '1',
			'urn:oid:0.9.2342.19200300.100.1.1' => 'aaakzeS7' //SAML Attribute CWL
        };
              
        User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
        System.runAs (thisUser) {
            DOL_JITHandler handObj = new DOL_JITHandler();
            String fedId = 'aaaJMvPrGO1b';
            String username = 'testUser';
            User us = handObj.createUser(con1, fedId, username);
            us.FederationIdentifier = 'aaaJMvPrGO1b';
            //us.Alias = 'fname';
            update us;
            System.assertEquals('test@gmail.com', us.Email);
            
            Test.startTest();
				handObj.updateUser(us.id, null, null, null,fedId, attributes, null);
            Test.stopTest();
        }
    }
}