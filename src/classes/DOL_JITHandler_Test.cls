@isTest
public class DOL_JITHandler_Test {
    
    // Contact and associated User exists
    // Contact and associated User exists
    @isTest static void testUserExists(){
        Id acctRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('User Account').getRecordTypeId();
        Id contRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Contact').getRecordTypeId();
        Account Acc = new Account();
        acc.name= DOL_AppConstants.NULL_EMPTY_STRING + 'testAccount';
        acc.RecordTypeId = acctRecordTypeId;
        acc.Account_Status__c  = DOL_AppConstants.NULL_EMPTY_STRING + 'Active';
        insert acc;
        
        Contact con1 = new Contact();
        con1.firstName = DOL_AppConstants.NULL_EMPTY_STRING + 'SSOfirstName';
        con1.lastName = DOL_AppConstants.NULL_EMPTY_STRING + 'SSOLastName';
        con1.Email = DOL_AppConstants.NULL_EMPTY_STRING + 'test@gmail.com';
        con1.Recordtypeid = contRecordTypeId;
        con1.Unique_ID_To_Provide__c  = 'SSN';
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
            String fedId = DOL_AppConstants.NULL_EMPTY_STRING + 'aaaJMvPrGO1b';
            String username = DOL_AppConstants.NULL_EMPTY_STRING + 'testUser';
            User us = handObj.createUser(con1, fedId, username);
            us.FederationIdentifier = DOL_AppConstants.NULL_EMPTY_STRING + 'aaaJMvPrGO1b';
            //us.Alias = DOL_AppConstants.NULL_EMPTY_STRING + 'fname';
            update us;
            System.assertEquals('test@gmail.com', us.Email);
            
            Test.startTest();
                handObj.updateUser(us.id, null, null, null,fedId, attributes, null);
            Test.stopTest();
        }
    }
    @isTest static void testUserDoesnotExist(){
        final Map<String, String> attributes = new Map<String, String> {
            'email' => 'NSWAIN@DELOITTE.COM',
            'groups' => 'f3_users',
            'name' => 'NIBEDITA SWAIN',
            'user' => 'NSWAIN'
        };
            final Map<String, String> attributes2 = new Map<String, String> {
            'email' => 'NibiN@DELOITTE.COM',
            'groups' => 'f3_users',
            'name' => 'NIBEDITA SWAIN',
            'user' => 'NSWAIN'
        };
            
            //{email=NSWAIN@DELOITTE.COM, groups=f3_users, guid=DP6WZ9ZL1PW5W-1TF2PF4MP2-D1LW4VZ0FD-PV6LT5VD4, level=2, name=NIBEDITA SWAIN, user=NSWAIN}
              
        User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
        System.runAs (thisUser) {
            DOL_JITHandler handObj = new DOL_JITHandler();
            String fedId = DOL_AppConstants.NULL_EMPTY_STRING + 'aaaJMvPrGO1b';
            //String username = DOL_AppConstants.NULL_EMPTY_STRING + 'testUser';
            //us.Alias = DOL_AppConstants.NULL_EMPTY_STRING + 'fname';
            //update us;
           // System.assertEquals('test@gmail.com', us.Email);
            
            Test.startTest();
                handObj.createUser(null, null, null,fedId, attributes, null);
            handObj.createUser(null, null, null,fedId, attributes2, null);
            DOL_JITHandler.encrypt('errorMessage');
            //global User createUser(Id samlSsoProviderId, Id communityId, Id portalId, String federationIdentifier, Map<String, String> attributes, String assertion)
            Test.stopTest();
        }
    }
}