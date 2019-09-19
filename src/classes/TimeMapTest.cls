@isTest
public class TimeMapTest {
    
    public user usered;
    @testSetup static void setup(){
        Account testAccount = CreateTestDataUtility.createAccount();       
        insert testAccount;
        Contact testContact = CreateTestDataUtility.createContact(testAccount.id);  
        insert testContact;
        MUSW__License2__c testLicense = CreateTestDataUtility.createLicense(testAccount.id,testContact.id );
        insert testLicense;         
        User u = CreateTestDataUtility.createCommunityTestUser(testContact.id);    
        u.ContactId =    testContact.Id;   
        Database.insert(u); 
        Date currentDate = Date.today();
        Integer currentYear = currentDate.year();
        Integer currentMonth = currentDate.Month();
        Integer currentDay = currentDate.Day();
        DateTime startTime=Datetime.newInstance(currentYear, currentMonth, currentDay);
        DateTime endTime=Datetime.newInstance(currentYear, currentMonth+1, currentDay);
        OrgSettings__c os  = new OrgSettings__c();
        os.Minimum_Slot_duration__c=1.0;
        os.Name= DOL_AppConstants.NULL_EMPTY_STRING + 'Fbslots';
        insert os;
        BusinessHours bh=[select id from BusinessHours where IsDefault=true limit 1];
        List<Time_Slot__c> newSlots = CommonUtil.generateNewTimeSlots(startTime, endTime, os, bh);
        insert newslots;
    }
    
    public testmethod static void TimeMap_Test2() {
        test.startTest();
                User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
        System.runAs (thisUser) {
             User testuser=CreateTestDataUtility.createBackendUser();
            insert testuser;
          Resource__c rsc = new Resource__c();
            rsc.Application_Type__c=label.Str_Plan_Review;
            rsc.Active__c=true;
            rsc.User__c=testuser.id;
            rsc.Plan_Review_Types__c= DOL_AppConstants.NULL_EMPTY_STRING + 'POWTS Petition for Variance';
            insert rsc;
            Group__c grp = new Group__c();
            grp.Name	= DOL_AppConstants.NULL_EMPTY_STRING + 'POWTS';
            grp.Application_Type__c= label.Str_Plan_Review;
            grp.type__C= DOL_AppConstants.NULL_EMPTY_STRING + 'Location';
            insert grp;           
     Group_Resource__c seven = new Group_Resource__c();
            seven.Resource__c= rsc.id;
            seven.Group__c=grp.Id;
            seven.Application_Type__c=label.Str_Plan_Review;
            insert seven;
               Resource_Week_Availability__c nwResLocAvai = new Resource_Week_Availability__c();
        nwResLocAvai.Schedule_Valid_till__c = Date.Today();        
        nwResLocAvai.Resource__c = rsc.ID;
        nwResLocAvai.Backend_User__c=testuser.id;
        nwResLocAvai.Autorenewal__c=true;
        insert nwResLocAvai;
        Resource_Availability__c a =[SELECT Backend_User__c, Valid_till_Date__c, Resource_Week_Availability__c, Day_Number__c, New_Time_Availability__c, Time_Availability__c, Day__c, Autorenewal__c, Resource__c, New_Availability_Start_Date__c, Valid_From_Date__c, Id FROM Resource_Availability__c limit 1];
        a.Time_Availability__c= DOL_AppConstants.NULL_EMPTY_STRING + '8.00 to 8.30';
        List<Resource_Availability__c> rscavails = new  List<Resource_Availability__c>();
        rscavails.add(a);
        update a;
        
        TimeMap t = new TimeMap(rscavails);
        
        t.availbility.add(new Resource_Availability__c());
        t.constructDayTimeMap();
        
        
        t.getTimeByString('666', '777');
        t.getAllTime(21);
        t.getTimeBetweenStartAndEndTime(datetime.now(), datetime.now() + 1);
        
        a.New_Time_Availability__c= DOL_AppConstants.NULL_EMPTY_STRING + '8.00 to 8.30; 8.30 to 9.00';
        List<Resource_Availability__c> rscavails2 = new  List<Resource_Availability__c>();
        rscavails.add(a);
        TimeMap t2 = new TimeMap(rscavails2);        
        t2.availbility.add(a);
        t2.constructDayTimeMap();       
        t2.getTimeByString('666', '777');
        t2.getAllTime(21);
        t2.getTimeBetweenStartAndEndTime(datetime.now(), datetime.now() + 1);
        
        TimeMap mp1 = new TimeMap(rsc.Id);
        mp1.availbility.add(new Resource_Availability__c());
        mp1.constructDayTimeMap();
        mp1.getTimeByString('666', '777');
        mp1.getAllTime(21);
        mp1.getTimeBetweenStartAndEndTime(datetime.now(), datetime.now() + 1);
        System.assert(mp1!=null);
        test.stopTest();
        }
    }
    
}