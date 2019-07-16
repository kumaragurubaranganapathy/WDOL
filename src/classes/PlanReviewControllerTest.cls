@isTest
public class PlanReviewControllerTest {
    public user usered;
    @testSetup static void setup(){
        List<Account> lstAccounts = new List<Account>();
        Account acc = CreateTestDataUtility.createAccount();
        insert acc;
        Account acc1 = CreateTestDataUtility.createCitizenAccount();   
        lstAccounts.add(acc1);
        insert acc1;
        Contact testContact = CreateTestDataUtility.createContact(acc.id);  
        insert testContact;
        MUSW__Permit2__c testpermit = CreateTestDataUtility.createPermit(acc.id,testContact.id );
        insert testpermit;         
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
        os.Minimum_Slot_duration__c=0.5;
        os.Name='Fbslots';
        insert os;
        BusinessHours bh=[select id from BusinessHours where IsDefault=true limit 1];
        List<Time_Slot__c> newSlots = CommonUtil.generateNewTimeSlots(startTime, endTime, os, bh);
        insert newslots;
    }  
    
    @isTest
    public static  void testMyController() {
        MUSW__Permit2__c permit = [Select Id,musw__applicant__c ,MUSW__Applicant__r.iD from MUSW__Permit2__c limit 1];
        PageReference pageRef = Page.PlanReviewScheduler;
        User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
        Time_Slot__c timeslottest = new Time_Slot__c();
        // Insert account as current user
        User user = [SELECT Id, ContactId FROM User WHERE ContactId = :permit.musw__applicant__r.Id  limit 1];
        System.runAs (thisUser) {
            
            User a=CreateTestDataUtility.createBackendUser();
            insert a;
            Resource__c rsc = new Resource__c();
            rsc.Application_Type__c=label.Str_Plan_Review;
            rsc.Active__c=true;
            rsc.User__c=a.id;
            rsc.Plan_Review_Types__c='POWTS Petition for Variance';
            insert rsc;
            Group__c grp = new Group__c();
            grp.Name	='POWTS';
            grp.Application_Type__c= label.Str_Plan_Review;
            grp.type__C='Location';
            insert grp;
            Group_Resource__c seven = new Group_Resource__c();
            seven.Resource__c= rsc.id;
            seven.Group__c=grp.Id;
            seven.Application_Type__c=label.Str_Plan_Review;
            insert seven;
            
            
            timeslottest.Application_Type__c=label.Str_Plan_Review;
            timeslottest.Resource__c=rsc.id;
            timeslottest.Status__c='Available';
            timeslottest.Start_Time__c=System.now().adddays(1);
            timeslottest.End_Time__c=timeslottest.Start_Time__c.addhours(2);
            insert timeslottest;
            
            Time_slot__c oneslot = new time_slot__C();
            oneslot.Application_Type__c=label.Str_Plan_Review;
            oneslot.Resource__c=rsc.id;
            oneslot.Status__c='Available';
            oneslot.Start_Time__c=System.now().adddays(1);
            oneslot.End_Time__c=timeslottest.Start_Time__c.addhours(3);
            insert oneslot;
            
        }
        System.runAs(user){
            Test.setCurrentPage(pageRef);
            ApexPages.currentPage().getParameters().put('permitId', permit.id);
            test.startTest();
            
            
            
            PlanReviewSchedulerCC controller = new PlanReviewSchedulerCC();  
            controller.schedulereview(); 
            Test.setCurrentPage(pageRef);
            controller.getCounties();
            controller.getItems();
            //List<Resource__c> rsc =controller.getResource('Testibg','Plan Review');
            ApexPages.currentPage().getParameters().put('timeslot', timeslottest.id);
            controller.setThisTimeSlotAsFinal();
            Pagereference pgref= controller.confirm(); 
            test.stopTest();
        }
    }
    
     @isTest
    public static  void testMyController6() {
        MUSW__Permit2__c permit = [Select Id,musw__applicant__c ,MUSW__Applicant__r.iD from MUSW__Permit2__c limit 1];
        permit.Review_Hours_Based_on_Answers__c=9.0;
        update permit;
        PageReference pageRef = Page.PlanReviewScheduler;
        User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
        Time_Slot__c timeslottest = new Time_Slot__c();
        // Insert account as current user
        User user = [SELECT Id, ContactId FROM User WHERE ContactId = :permit.musw__applicant__r.Id  limit 1];
        System.runAs (thisUser) {
            
            User a=CreateTestDataUtility.createBackendUser();
            insert a;
            Resource__c rsc = new Resource__c();
            rsc.Application_Type__c=label.Str_Plan_Review;
            rsc.Active__c=true;
            rsc.User__c=a.id;
            rsc.Plan_Review_Types__c='POWTS Petition for Variance';
            insert rsc;
            Group__c grp = new Group__c();
            grp.Name	='POWTS';
            grp.Application_Type__c= label.Str_Plan_Review;
            grp.type__C='Location';
            insert grp;
            Group_Resource__c seven = new Group_Resource__c();
            seven.Resource__c= rsc.id;
            seven.Group__c=grp.Id;
            seven.Application_Type__c=label.Str_Plan_Review;
            insert seven;
            
            
            timeslottest.Application_Type__c=label.Str_Plan_Review;
            timeslottest.Resource__c=rsc.id;
            timeslottest.Status__c='Available';
            timeslottest.Start_Time__c=System.now().adddays(1);
            timeslottest.End_Time__c=timeslottest.Start_Time__c.addhours(2);
            insert timeslottest;
            
            Time_slot__c oneslot = new time_slot__C();
            oneslot.Application_Type__c=label.Str_Plan_Review;
            oneslot.Resource__c=rsc.id;
            oneslot.Status__c='Available';
            oneslot.Start_Time__c=System.now().adddays(1);
            oneslot.End_Time__c=timeslottest.Start_Time__c.addhours(3);
            insert oneslot;
            
        }
        System.runAs(user){
            Test.setCurrentPage(pageRef);
            ApexPages.currentPage().getParameters().put('permitId', permit.id);
            test.startTest();
            
            
            
            PlanReviewSchedulerCC controller = new PlanReviewSchedulerCC();  
            controller.schedulereview(); 
            Test.setCurrentPage(pageRef);
            controller.getCounties();
            controller.getItems();
            //List<Resource__c> rsc =controller.getResource('Testibg','Plan Review');
            ApexPages.currentPage().getParameters().put('timeslot', timeslottest.id);
            controller.setThisTimeSlotAsFinal();
            Pagereference pgref= controller.confirm(); 
            test.stopTest();
        }
    }
    
    @isTest
    public static  void testMyController2() {
        MUSW__Permit2__c permit = [Select Id,musw__applicant__c ,MUSW__Applicant__r.iD from MUSW__Permit2__c limit 1];
        PageReference pageRef = Page.PlanReviewScheduler;
        User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
        Time_Slot__c timeslottest = new Time_Slot__c();
        // Insert account as current user
        User user = [SELECT Id, ContactId FROM User WHERE ContactId = :permit.musw__applicant__r.Id  limit 1];
        User a= new user();
        System.runAs (thisUser) {
            
            a=CreateTestDataUtility.createBackendUser();
            insert a;
            Resource__c rsc = new Resource__c();
            rsc.Application_Type__c=label.Str_Plan_Review;
            rsc.Active__c=true;
            rsc.User__c=a.id;
            rsc.Plan_Review_Types__c='POWTS Petition for Variance';
            insert rsc;
             Resource__c rsc2 = new Resource__c();
               User b=CreateTestDataUtility.createBackendUser2();
            insert b;
            rsc2.Application_Type__c=label.Str_Plan_Review;
            rsc2.Active__c=true;
            rsc2.User__c=b.id;
            rsc2.Plan_Review_Types__c='POWTS Petition for Variance';
            insert rsc2;
            Group__c grp = new Group__c();
            grp.Name	='POWTS';
            grp.Application_Type__c= label.Str_Plan_Review;
            grp.type__C='Location';
            insert grp;
            Group_Resource__c seven = new Group_Resource__c();
            seven.Resource__c= rsc.id;
            seven.Group__c=grp.Id;
            seven.Application_Type__c=label.Str_Plan_Review;
            insert seven;
            Group_Resource__c sev = new Group_Resource__c();
            sev.Resource__c= rsc2.id;
            sev.Group__c=grp.Id;
            sev.Application_Type__c=label.Str_Plan_Review;
            insert sev;
            
            
            timeslottest.Application_Type__c=label.Str_Plan_Review;
            timeslottest.Resource__c=rsc.id;
            timeslottest.Status__c='Available';
            timeslottest.Start_Time__c=System.now().adddays(1);
            timeslottest.End_Time__c=timeslottest.Start_Time__c.addhours(2);
            insert timeslottest;
            
            Time_slot__c oneslot = new time_slot__C();
            oneslot.Application_Type__c=label.Str_Plan_Review;
            oneslot.Resource__c=rsc.id;
            oneslot.Status__c='Available';
            oneslot.Start_Time__c=System.now().adddays(1);
            oneslot.End_Time__c=oneslot.Start_Time__c.addhours(3);
            insert oneslot;
            
            Time_slot__c onesl = new time_slot__C();
            onesl.Application_Type__c=label.Str_Plan_Review;
            onesl.Resource__c=rsc2.id;
            onesl.Status__c='Available';
            onesl.Start_Time__c=System.now().adddays(1);
            onesl.End_Time__c=onesl.Start_Time__c.addhours(2);
            insert onesl;
            
            Time_slot__c oneslt = new time_slot__C();
            oneslt.Application_Type__c=label.Str_Plan_Review;
            oneslt.Resource__c=rsc2.id;
            oneslt.Status__c='Available';
            oneslt.Start_Time__c=System.now().adddays(1);
            oneslt.End_Time__c=oneslt.Start_Time__c.addhours(3);
            insert oneslt;
            
        }
        System.runAs(user){
                        Request__C REQ= NEW Request__C();
            req.Contact__c=permit.MUSW__Applicant__c;
            req.Permit_Plan_Review__c=permit.Id;
            req.Start_Time__c=System.now().adddays(1);
            req.End_Time__c=req.Start_Time__c.addhours(1);
            req.Status__c=Label.ST_Scheduled ;
            insert req;
            Test.setCurrentPage(pageRef);

            ApexPages.currentPage().getParameters().put('permitId', permit.id);
            test.startTest();
            PlanReviewSchedulerCC controller = new PlanReviewSchedulerCC();  
            controller.searchtype=Label.Str_Search_for_reviewer;
            ApexPages.currentPage().getParameters().put('myParam',a.id);
            controller.schedulereview(); 
            Test.setCurrentPage(pageRef);
            controller.getCounties();
            PlanReviewSchedulerCC.getResource('test','test');
            ApexPages.currentPage().getParameters().put('timeslot', timeslottest.id);
            controller.setThisTimeSlotAsFinal();
            test.stopTest();
        }
    }
    
    public static testMethod void testMyController3() {
        PageReference pageRef = Page.PlanReviewScheduler;
         MUSW__Permit2__c permit = [Select Id,musw__applicant__c ,MUSW__Applicant__r.iD from MUSW__Permit2__c limit 1];
                User user = [SELECT Id, ContactId FROM User WHERE ContactId = :permit.musw__applicant__r.Id  limit 1];
        System.runAs(user){
            test.startTest();
            Test.setCurrentPage(pageRef);
            PlanReviewSchedulerCC controller = new PlanReviewSchedulerCC();            // New Agreement
            test.stopTest();
        }
    }
    
    public static testMethod void testMyController4() {
        PageReference pageRef = Page.PlanReviewScheduler;
         MUSW__Permit2__c permit = [Select Id,musw__applicant__c ,MUSW__Applicant__r.iD from MUSW__Permit2__c limit 1];
                User user = [SELECT Id, ContactId FROM User WHERE ContactId = :permit.musw__applicant__r.Id  limit 1];
        System.runAs(user){
            test.startTest();
            Test.setCurrentPage(pageRef);
             ApexPages.currentPage().getParameters().put('permitId', permit.id+'23232');
            PlanReviewSchedulerCC controller = new PlanReviewSchedulerCC();            // New Agreement
            test.stopTest();
        }
    }
    
       @isTest
    public static  void testMyController7() {
        MUSW__Permit2__c permit = [Select Id,musw__applicant__c ,MUSW__Applicant__r.iD from MUSW__Permit2__c limit 1];
        PageReference pageRef = Page.PlanReviewScheduler;
        User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
        Time_Slot__c timeslottest = new Time_Slot__c();
        // Insert account as current user
        System.runAs (thisUser) {
            
            User a=CreateTestDataUtility.createBackendUser();
            insert a;
            Resource__c rsc = new Resource__c();
            rsc.Application_Type__c=label.Str_Plan_Review;
            rsc.Active__c=true;
            rsc.User__c=a.id;
            rsc.Plan_Review_Types__c='POWTS Petition for Variance';
            insert rsc;
            Group__c grp = new Group__c();
            grp.Name	='POWTS';
            grp.Application_Type__c= label.Str_Plan_Review;
            grp.type__C='Location';
            insert grp;
            Group_Resource__c seven = new Group_Resource__c();
            seven.Resource__c= rsc.id;
            seven.Group__c=grp.Id;
            seven.Application_Type__c=label.Str_Plan_Review;
            insert seven;
            
            
            timeslottest.Application_Type__c=label.Str_Plan_Review;
            timeslottest.Resource__c=rsc.id;
            timeslottest.Status__c=Label.ST_Available;
            timeslottest.Backend_User__c=a.id;
            timeslottest.Start_Time__c=System.now().adddays(1);
            timeslottest.End_Time__c=timeslottest.Start_Time__c.addhours(2);
            insert timeslottest;
            
            Time_slot__c oneslot = new time_slot__C();
            oneslot.Application_Type__c=label.Str_Plan_Review;
            oneslot.Resource__c=rsc.id;
            oneslot.Backend_User__c=a.id;
            oneslot.Status__c=Label.ST_Available;
            oneslot.Start_Time__c=System.now().adddays(1);
            oneslot.End_Time__c=timeslottest.Start_Time__c.addhours(3);
            insert oneslot;
            
             oneslot = new time_slot__C();
            oneslot.Application_Type__c=label.Str_Plan_Review;
            oneslot.Resource__c=rsc.id;
            oneslot.Backend_User__c=a.id;
            oneslot.Status__c=Label.ST_Available;
            oneslot.Start_Time__c=System.now().adddays(3);
            oneslot.End_Time__c=timeslottest.Start_Time__c.addhours(3);
            insert oneslot;
            
             oneslot = new time_slot__C();
            oneslot.Application_Type__c=label.Str_Plan_Review;
            oneslot.Resource__c=rsc.id;
            oneslot.Backend_User__c=a.id;
            oneslot.Status__c=Label.ST_Available;
            oneslot.Start_Time__c=System.now().adddays(4);
            oneslot.End_Time__c=timeslottest.Start_Time__c.addhours(3);
            insert oneslot;
            
             SYstem.debug('Label.ST_UnAvailable  '+[Select id,Resource__c,Start_Date__c from time_slot__c where Resource__c=:rsc.id and Backend_User__c!='' and status__c=:Label.ST_Available]);
            Resource_Availability_Modifier__c ram = new Resource_Availability_Modifier__c();
            ram.Activity__c=Label.ST_Unavailable;
            ram.Resource__c=rsc.id;
            ram.Date__c=System.today().adddays(1);
            ram.Activity__c=Label.Str_Make_UnAvailable;
            insert ram;
            
            
            Resource_Availability_Modifier__c ram2 = new Resource_Availability_Modifier__c();
            ram2.Activity__c=Label.Str_Make_Available;
            ram2.Resource__c=rsc.id;
            ram2.Date__c=System.today().adddays(3);
            ram2.Time_Availability_per_Day__c='8.00 to 8.30';
            insert ram2;
            
            ram2 = new Resource_Availability_Modifier__c();
            ram2.Activity__c=Label.Str_Make_Available;
            ram2.Resource__c=rsc.id;
            ram2.Date__c=System.today().adddays(3);
            ram2.Time_Availability_per_Day__c=Label.ST_Unavailable;
            insert ram2;
            SYstem.debug('Label.ST_Available  '+[Select id from time_slot__C]);
            
        }
    }
    
   public static testMethod void testMyController8() {
        OrgSettings__c os=TimeSlotsHelper.getFBSlotSettings(null);
        BusinessHours bh=TimeSlotsHelper.getBusinessHours();
       TimeSlotsHelper.createFreeFBSlots(System.now(),  os,  bh, 2);
    }
    
       public static testMethod void testMyController9() {
       MUSW__Permit2__c permit = [Select Id,musw__applicant__c ,MUSW__Applicant__r.iD from MUSW__Permit2__c limit 1];
        permit.State_Owned_Facility__c=true;
           update permit;
        MUSW__Review__c review = new MUSW__Review__c ();
           review.MUSW__Status__c=Label.ST_Pending;
           review.MUSW__Permit2__c=permit.id;
           insert review;
           review.MUSW__Status__c='Approved';
           review.Start_Date__c=System.today();
           review.MUSW__Completed_DateTime__c=System.today().adddays(1);
           update review;
    }

    
    
    
}