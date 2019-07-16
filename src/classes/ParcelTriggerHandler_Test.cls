/**
* Name: ParcelTriggerHandler_Test
* Type: Class
* Description: Test class for ParcelTriggerHandler
* Date:        Developer/Company                    Description
* ---------------------------------------------------------------------------------------------------------------------------------------- *
* 07/12/2018   Srikanth Kottam/Deloitte           Initial Creation
**/
@isTest
public class ParcelTriggerHandler_Test {
	public static TestMethod MUSW__Parcel__c createTestData(){
        Global_Settings__c globalSetting = new Global_Settings__c(Name = UserInfo.getUsername(), Disable_Triggers__c = true);
    	insert globalSetting;       
        
        Test.startTest();
        
        /*Creating test Account*/
        Account acc = new Account();
        acc = CreateTestDataUtility.createAccount();
        /*Inserting test Account*/
        insert acc;
        
        /*Creating test Contact*/
        Contact con = CreateTestDataUtility.createContact(acc.Id);
        /*Inserting test Contact*/
        insert con;   
        
        /*Creating test Parcel*/
        MUSW__Parcel__c par = new MUSW__Parcel__c(International_Address__c = '345 Street', Country__c = 'Canada');
        insert par;
        
		Test.stopTest();
        return par;
    }
    
    public static TestMethod void triggerTest(){
        MUSW__Parcel__c par = createTestData();
       // Test.startTest();
        par.International_Address__c = '456 Street';
        update par;
        ParcelTriggerHandler parcelTH = new ParcelTriggerHandler();
		parcelTH.onBeforeDelete();
        parcelTH.onBeforeUndelete();
        parcelTH.onAfterDelete();
        parcelTH.onAfterUndelete();
        //parcelTH.onAfterInsert();
        //parcelTH.onAfterUpdate();
      //  Test.stopTest(); 
    }
}