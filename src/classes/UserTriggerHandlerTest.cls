@isTest
public class UserTriggerHandlerTest {
    public static testmethod void checkUserDetails(){
        Id AccRecTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('User Account').getRecordTypeId();
        Id ConRecTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Contact').getRecordTypeId();
        Id LicRecTypeId = Schema.SObjectType.MUSW__License2__c.getRecordTypeInfosByName().get('Individual').getRecordTypeId();
        User newUser;
        
        Account acc = DOL_TestDataFactory.createAccount(AccRecTypeId);  
        //insert acc;
        Contact con = DOL_TestDataFactory.createContact(ConRecTypeId,acc.id);
        //insert con;
        
        User thisUser = [ select Id from User where Id = :UserInfo.getUserId() ];
        System.runAs ( thisUser ) {
            List<User> newUserList = new List<User>();
            List<User> oldUserList = new List<User>();
            Map<Id, User> newItems = new Map<Id, User>();
            Map<Id, User> oldItems = new Map<Id, User>();
            UserRole ur = [Select PortalType, PortalAccountId From UserRole where PortalType ='CustomerPortal' and PortalAccountId!=null AND PortalType!=null limit 1];
     //       System.debug('***ur***'+ur);
            Profile p = [select Id,name from Profile where name ='eSLA Customer Community Plus Login User'  limit 1];
          //  System.debug('***profile***'+p);
            
            newUser = DOL_TestDataFactory.createPortalUser('lastName', 'nuser',p.id,'pb@ff.com',con.id );
            newUserList.add(newUser);  
            insert newUserList;
            UserTriggerHandler ut = new UserTriggerHandler();
            ut.AfterInsert(newUserList);
            ut.BeforeInsert(newUserList);
            ut.BeforeUpdate(newItems,oldItems);
            ut.BeforeDelete(oldItems);
            ut.AfterInsert(newItems);
            ut.AfterUpdate(newItems,oldItems);
            ut.AfterDelete(oldItems);
            ut.AfterUndelete(oldItems);
        }
    }
}