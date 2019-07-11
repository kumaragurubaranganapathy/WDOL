/*
**------------------------------------------------------------------------------------------------------------
** Modification Log:
** reference Schedulereview
**------------------
** Developer                 Date              Version     Description
** Akosa Okwudiafor           
**------------------------------------------------------------------------------------------------------------
** Review Log:
**---------------
** Reviewer                  Date           Version               Description
**------------------------------------------------------------------------------------------------------------
***************************************************************************************************************/
public without sharing class PlanReviewSchedulerCC {
    public MUSW__Permit2__c Permit {get;set;}
    public Boolean isError{get;set;}
    public string county{get;set;}
    public Time_Slot__C beginnningtimeslot;
    public Time_Slot__C endtimeslot;
    public Boolean showscheduler{get;set;}
    public Id selectresourceId{get;set;}
    public Id resourceuserId{get;set;}
    public Boolean newRequest{get;set;}
    public Request__c request{get;set;}
    public Boolean previousScheduledreview{get;set;}
    public String rscid {get;set;}
    public String searchtype{get;set;}
    public Map<Date,List<time_slot__c>> slotgroupping {get;set;}
    public Map<String,List<time_slot__c>> resourcedategroup{get;set;}
    public String PermitId {get;set;}
    public time_slot__c slotSelected {get;set;}
    public List<time_slot__c> futureFreeSlots  {get;set;}
    public time_slot__c selectedslot {get;set;}
    List<Group_Resource__c> resourcegroup;
    Set<String> mhcoffices;
    Set<String> powtsoffices;
    public request__c exisitingrequest;
    public Id contactId;
    Public Set<Id> previousResource;
    public String reviewDesignation;
    public List<time_slot__c> AvailableSlotsWithResCombination{get;set;} 
    public transient List<time_slot__c> AvailableSlotsWithResCombination2;    
    public List<time_slot__c> getAvailableSlotsWithResCombination2()
    {
        AvailableSlotsWithResCombination2= new List<time_slot__c>();
        AvailableSlotsWithResCombination2=AvailableSlotsWithResCombination;
        return AvailableSlotsWithResCombination2;
    }
    
    /***************************************************************************************************
* @Description : The constructor here suggests the reviews that have to be taken together based on the the review grouping field on the user's profile and
on the Permit.
* @Param       : NA
* @Return      : 
***************************************************************************************************/    
    public PlanReviewSchedulerCC(){
        searchtype='';
        county='';
        selectresourceId=null;
        resourceuserId=null;
        mhcoffices= new Set<String> ();
        powtsoffices= new Set<String> ();
        resourcegroup = new List <Group_Resource__c> ();
        previousResource = new Set<Id>();
        beginnningtimeslot = new Time_slot__C();
        endtimeslot = new time_slot__c();
        AvailableSlotsWithResCombination = new List<time_slot__c>();
        slotgroupping= new Map<Date,List<time_slot__c>> ();
        resourcedategroup=new  Map<String,List<time_slot__c>>();
        Permit = new MUSW__Permit2__c();    
        slotSelected = new time_slot__c();
        request = new Request__c();
        iserror = false;
        showscheduler= false;
        previousScheduledreview=false;
        newRequest=true;
        try{
            contactId= null;
            PermitId = ApexPages.currentPage().getParameters().get('permitid');
            if(String.isNotBlank(PermitId)){
                List<MUSW__Permit2__c> Permits =new List<Musw__Permit2__c> ();
                User users = [SELECT Id,Is_Portal_User__c, ContactId FROM User WHERE Id = :UserInfo.getUserId()  limit 1];
                if (users.Is_Portal_User__c == true) {
                    permits =[SELECT Id,Name,program_area__c,Permit2__c,MUSW__Type__c,Permit_Type__c,Application_Type__c,MUSW__Status__c,Review_Hours_Based_on_Answers__c,MUSW__Applicant__c,Generate_Invoice__c,(Select id,status__c from Requests__r where status__c=:Label.St_Eligible) FROM MUSW__Permit2__c WHERE Id=:PermitId and 
                              Type_of_Plan_Review__c ='' limit 1];
                }
                else {
                    permits =[SELECT Id,Name,program_area__c,Permit2__c,MUSW__Type__c,Permit_Type__c,Application_Type__c,MUSW__Status__c,Review_Hours_Based_on_Answers__c,MUSW__Applicant__c,Generate_Invoice__c,(Select id,status__c from Requests__r where status__c=:Label.St_Eligible) FROM MUSW__Permit2__c WHERE Id=:PermitId 
                               limit 1];
                }
                
                if(Permits.size()>0){
                    
                    User user = [SELECT Id,Is_Portal_User__c, ContactId FROM User WHERE Id = :UserInfo.getUserId()  limit 1];
                    if (user.Is_Portal_User__c == true) {
                        contactId =  user.ContactId;
                    }
                    else {
                        contactId=permits[0].MUSW__Applicant__c;
                    }
                    List<request__c> prevrequests= [select id ,Contact__c,Assigned_Resource__c from request__c where Contact__c=:contactId and Status__c=:Label.ST_Scheduled and Permit_Plan_Review__c=:permits[0].Permit2__c ];
                    List<request__c> alreadyScheduledrequests= [select id ,Contact__c from request__c where  Contact__c=:contactId and Status__c=:Label.ST_Scheduled and Permit_Plan_Review__c=:PermitId];
                    Permit= Permits[0];    
                    if(alreadyScheduledrequests.size()==0)
                    {
                        if(permits[0]!=null)
                        {
                            if(Permits[0].requests__r!=null&&Permits[0].requests__r.size()>0){
                                exisitingrequest=  Permits[0].requests__r;
                                newRequest=false;
                            }
                        }
                        
                        //If the users has had a previous plan review done, check if the resource is still available
                        if(prevrequests.size()>0)
                        {
                            request__c prev = prevrequests[0];
                            /*  List<Time_Slot__c> prevtimeslots= [Select id,Resource__c,Backend_User__c,Status__c from time_Slot__c where Request__c=:prevrequests ];
for(time_Slot__c timeslot :prevtimeslots )
{*/
                            previousScheduledreview=true;
                            previousResource.add(prev.Assigned_Resource__c);
                            //}
                            if(previousScheduledreview&&Permit.Review_Hours_Based_on_Answers__c!=null)
                            {
                                resourcegroup = [Select id,Group__c,Resource__c,Group__r.Name from Group_Resource__c where Group__r.Name =:permit.program_area__c and Resource__c=:previousResource and Application_Type__c=:permit.Application_Type__c and Resource__r.Active__c=true and Resource__r.Plan_Review_Types__c includes (: permit.Permit_Type__c )];
                            }
                        }
                        if(resourcegroup.size()==0)
                        {
                            previousScheduledreview=false;
                        }
                        if(Permit.Review_Hours_Based_on_Answers__c!=null&&!previousScheduledreview){
                            resourcegroup = [Select id,Group__c,Resource__c,Group__r.Name from Group_Resource__c where Group__r.Name =:permit.program_area__c and Application_Type__c=:permit.Application_Type__c and Resource__r.Active__c=true and Resource__r.Plan_Review_Types__c includes (: permit.Permit_Type__c )];
                        }
                    } else{                       
                        isError = true;
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'  A request has already been scheduled.'));
                    }
                }
                else{
                    isError = true;
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,' Error occurred here. This review was selected as priority or public health.'));
                }
            }
            else{
                isError = true;
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,' Unexpected error occurred '));
            }
            
        }catch(Exception ex){
            isError = true;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,' Unexpected  error occurred' +ex.getMessage()));
        }
        
    }
    
    
    public List<SelectOption> getItems() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption(Label.Str_None,Label.Str_None));
        options.add(new SelectOption(Label.Str_All_Available_Times,Label.Str_All_Available_Times));
        options.add(new SelectOption(Label.Str_Times_by_Office,Label.Str_Times_by_Office));
        options.add(new SelectOption(Label.Str_Search_for_reviewer,Label.Str_Search_for_reviewer));
        return options;
    }
    
    
    public List<SelectOption> getCounties() {
        mhcoffices=Utilities.getallMHCOffices();
        powtsoffices=Utilities.getallPOWTSOffices();
        Set<String> offices= new   Set<String>();    
        if(Permit.Application_Type__c==Label.Str_Plan_Review)
        {
            offices=powtsoffices;
        }
        else 
        {
            offices=mhcoffices;
        }
        Schema.DescribeFieldResult fieldResult =Resource__c.County__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        List<SelectOption> options = new List<SelectOption>();
        for( Schema.PicklistEntry f : ple)
        {
            if(offices.contains(f.getLabel())){
                options.add(new SelectOption(f.getLabel(), f.getValue()));
            }
        }       
        return options;
    }
    
    /***************************************************************************************************
* @Description : This function attaches the review to an review request if an review request exists or creates an review request for the review for
the reviews without review requests. This also generates the time slots for the user to select the appropriate results.
* @Param       : NA
* @Return      : PageReference
***************************************************************************************************/
    public PageReference schedulereview(){
        try{
            if(newRequest){
                request.application_type__c=Permit.application_type__c;
                request.Permit_Plan_Review__c= Permit.id;
                request.Contact__c= contactId;
                request.Status__c =Label.ST_Eligible;
                request.Duration__c=String.valueOf(permit.Review_Hours_Based_on_Answers__c);
                List<Request__c> requests = new List<Request__c> ();
                requests.add(request);
                insert requests; 
                exisitingrequest=requests[0];
                request=exisitingrequest;
            }
            else{
                request=exisitingrequest;
            }
            System.debug( 'request  '+request);
            showscheduler =true; 
            newRequest=false;
            Set<Time_Slot__c> availabletimes = new Set<Time_Slot__c>();
            if(searchtype==Label.Str_Search_for_reviewer)
            {
                rscid = Apexpages.currentPage().getParameters().get('myParam');
                List<Resource__c> rsc =[SELECT County__c, External_Id__c, Application_Type__c, User__c,user__r.Name,Plan_Review_Types__c, Active__c, Name, Id FROM Resource__c where user__c=:rscId and Plan_Review_Types__c includes (: permit.Permit_Type__c )
                                        Order by Name ASC];
                resourcegroup= new List<Group_Resource__c>();
                if(rsc.size()>0)
                    resourcegroup= [Select id,Group__c,Resource__c,Group__r.Name from Group_Resource__c where Group__r.Name =:permit.program_area__c and Application_Type__c=:permit.Application_Type__c and Resource__c=: rsc[0].Id];
            }
            else if(searchtype==Label.Str_Times_by_Office)
            {
                String rsccounty = Apexpages.currentPage().getParameters().get('myParam1');
                List<Resource__c> rsc =[SELECT County__c, External_Id__c, Application_Type__c, User__c,user__r.Name,Plan_Review_Types__c, Active__c, Name, Id FROM Resource__c where County__c=:rsccounty and Active__c=true and  Plan_Review_Types__c includes (: permit.Permit_Type__c ) Order by Name ASC];
                resourcegroup= new List<Group_Resource__c>();
                if(rsc.size()>0)
                    resourcegroup= [Select id,Group__c,Resource__c,Group__r.Name from Group_Resource__c where Group__r.Name =:permit.program_area__c and Application_Type__c=:permit.Application_Type__c and Resource__c=: rsc];
            }
            else {
                resourcegroup = [Select id,Group__c,Resource__c,Group__r.Name from Group_Resource__c where Group__r.Name =:permit.program_area__c and Application_Type__c=:permit.Application_Type__c and Resource__r.Active__c=true and Resource__r.Plan_Review_Types__c includes (: permit.Permit_Type__c )];
            }
            
            slotgroupping= new Map<Date,List<time_slot__c>> ();
            resourcedategroup=new  Map<String,List<time_slot__c>>();
            for(Group_Resource__c grprsc :resourcegroup)
            {
                availabletimes.addAll(findSlotsforreview(grprsc.Resource__c));
                
            }
            List<time_slot__c> combinationslots =new List<time_slot__c> ();
            Set<Date> availdates= new Set<Date>();
            for(Time_Slot__c a :availabletimes)
            {
                if(!availdates.contains(a.start_date__c)){
                    availdates.add(a.start_date__c);
                    combinationslots.add(a);
                }
            }
            AvailableSlotsWithResCombination.clear();
            AvailableSlotsWithResCombination.addAll(combinationslots);
            return null;
        }
        catch(Exception Ex){
            ErrorLogger.logGeneralException(Ex,UserInfo.getUserId(),'review_Information__c', 'Create review Request', 'schedulereview', 'reviewSchedulerController', 'High');
            PageReference returnPage = new PageReference('/PlanReviewNotConfirmed');
            return returnPage;
        }
    }
    
    /***************************************************************************************************
* @Description : This functionality finds all the available slots available for the selected reviews.
* @Param       : NA
* @Return      : List<time_slot__c>
***************************************************************************************************/
    public List<time_slot__c> findSlotsforreview(Id res){
        boolean showFuturedates= false;
        Set<Datetime> dates =new set<Datetime> ();
        Set<Datetime> userdates =new set<Datetime> ();
        List<time_slot__c> slots = new List<time_slot__c> ();
        List<time_slot__c> freeSlots = new List<time_slot__c> ();        
        futureFreeSlots =[select Start_Date__c,end_time__c,Start_Time__c,Backend_User__c,Resource__c from time_slot__c where Resource__c=:res and Status__c=:Label.ST_Available and Start_Time__c >=Today order by Start_Time__c asc Limit 1200];
        date newDate = System.today();
        boolean firsttime=true;
        Integer counter=0;      
        if(permit.Review_Hours_Based_on_Answers__c<=8){
            for(Time_slot__c currentslot:futureFreeSlotS)
            {           
                if(resourcedategroup.containsKey(currentslot.Resource__c+String.valueof(currentslot.Start_Date__c))&&resourcedategroup.get(currentslot.Resource__c+String.valueof(currentslot.Start_Date__c)).size()<(2*permit.Review_Hours_Based_on_Answers__c))
                {
                    slotgroupping.get(currentslot.Start_Date__c).add(currentslot);
                    resourcedategroup.get(currentslot.Resource__c+String.valueof(currentslot.Start_Date__c)).add(currentslot);
                    counter++;
                }
                else if(!resourcedategroup.containsKey(currentslot.Resource__c+String.valueof(currentslot.Start_Date__c))) {
                    slotgroupping.put(currentslot.Start_Date__c, new List<time_slot__c> { currentslot});
                    counter++;
                    resourcedategroup.put(currentslot.Resource__c+String.valueof(currentslot.Start_Date__c),new List<time_slot__c> { currentslot} );
                    slots.add(currentslot);
                }
            }
        }
        else{
            Integer counters=0;
            Time_Slot__C ONEW= new time_Slot__c();
            for(Time_slot__c currentslot:futureFreeSlotS)
            {
                
                // System.debug('Math.mod(counters,Integer.valueof(permit.Review_Hours_Based_on_Answers__c*2) '+Math.mod(slotgroupping.get(currentslot.Start_Date__c).size(),Integer.valueof(permit.Review_Hours_Based_on_Answers__c*2) ));
                if(counters==0||ONEW!=null&&Math.mod(slotgroupping.get(ONEW.Start_Date__c).size(),Integer.valueof(permit.Review_Hours_Based_on_Answers__c*2) )==0)
                {
                    counters++;
                    ONEW=currentslot;
                    slotgroupping.put(currentslot.Start_Date__c, new List<time_slot__c> { currentslot});
                    resourcedategroup.put(ONEW.Resource__c+String.valueof(ONEW.Start_Date__c)+String.valueOf(counters),new List<time_slot__c> { currentslot} );
                    slots.add(currentslot);
                }
                else{
                    resourcedategroup.get(ONEW.Resource__c+String.valueof(ONEW.Start_Date__c)+String.valueOf(counters)).add(currentslot);
                    slotgroupping.get(ONEW.Start_Date__c).add(currentslot);
                }
                
            }
        }
        
        System.debug('welcome to ');
        List<Date> incompletedates = new List<Date>();
        //Remove incomplete items from list
        for(String key:resourcedategroup.keySet())
        {
            if(resourcedategroup.get(key).size()<(2*permit.Review_Hours_Based_on_Answers__c))
            {
                resourcedategroup.remove(key);
                
                if(2*permit.Review_Hours_Based_on_Answers__c<=8){
                    incompletedates.add(Date.valueOf(key.substring(18, key.length())));
                    slotgroupping.remove(Date.valueOf(key.substring(18, key.length())));
                }
                
            }
        }
        
        List<Integer> counters2= new List<Integer>();
        if(incompletedates!=null&&incompletedates.size()>0){
            for(integer i=0; i<slots.size(); i++){
                time_slot__c freeslot= slots[i];
                if(incompletedates.contains(freeslot.Start_Date__c))
                {
                    counters2.add(i);
                }
            }
        }
        
        for(Integer i = counters2.size() - 1; i >= 0; i--){
            System.debug(counters2[i]);
            System.debug('slots '+slots.get(counters2[i]));
            slots.remove(counters2[i]);
        }
        
        Map<Datetime,Datetime> datesbooked = new Map<Datetime,Datetime>();
        
        //Get all the future times that have been booked by the user
        for(Request__c request : [Select id,End_Time__c,Start_Time__c from Request__c where Status__c=:Label.ST_Scheduled and Start_Time__c >=Today and  Contact__c=:contactId]){
            if(request.Start_Time__c>System.now()){
                datesbooked.put(request.Start_Time__c, request.End_Time__c);
            }
        }
        
        //Making a map for all dates and the datetimes that are free
        Map<Date,List<Datetime>> datesnotbooked = new Map<Date,List<Datetime>>();
        for(time_slot__c freeslot: slots ){
            if(datesnotbooked.containsKey(freeslot.Start_Date__c)){
                datesnotbooked.get(freeslot.Start_Date__c).add(freeslot.Start_Time__c);
            }
            else{
                datesnotbooked.put(freeslot.Start_Date__c, new List<Datetime>{freeslot.Start_Time__c});
            }
        }
        
        //Intersecting the busy days and the free days from the fbslots to show the user available time slots.
        for(Datetime busydates : datesbooked.keySet())
        { 
            Date myDate = date.newinstance(busydates.year(), busydates.month(), busydates.day());
            if(datesnotbooked.containsKey(myDate))
            {
                List<Datetime> nonbusyDatetimes =datesnotbooked.get(myDate);
                for(Datetime freedatetimes : nonbusyDatetimes)
                {
                    boolean overlap = busydates < (freedatetimes + (Integer)(Double.valueof(permit.Review_Hours_Based_on_Answers__c))) ;
                    boolean overlap2= freedatetimes <  datesbooked.get(busydates);
                    if(overlap&&overlap2){
                        userdates.add(freedatetimes);
                    }
                }
            }
            
        }
        List<Integer> counters= new List<Integer>();
        //This functionality finds out the dates that are overlapping with the users schedule.
        if(userdates!=null&&userdates.size()>0){
            for(integer i=0; i<slots.size(); i++){
                time_slot__c freeslot= slots[i];
                if(userdates.contains(freeslot.Start_Time__c))
                {
                    counters.add(i);
                }
            }
        }
        
        for(Integer i = counters.size() - 1; i >= 0; i--){
            slots.remove(counters[i]);
        }
        List<time_slot__c> fbslotlist = new  List<time_slot__c> ();
        Set<Date> daytobeshown = new Set<Date>();
        
        for(integer i=0; i<slots.size();i++)
        {
            time_slot__c oneslot = slots[i];
            if(daytobeshown.size()!=60||daytobeshown.contains(oneslot.Start_Date__c)){                  
                if(oneslot.Start_Time__c> System.now())
                {
                    fbslotlist.add(oneslot);
                    daytobeshown.add(oneslot.Start_Date__c);
                }
                else {
                    
                }
            }
            else{
                break;
            }
        }
        System.debug('fbslotlist  '+fbslotlist.size());
        return fbslotlist;        
    }
    
    
    /***************************************************************************************************
* @Description : The functionality helps confirm the time slot the user has chosen and reroutes the page if it is successful or tells the user to 
refresh the page to get the latest time slots.
* @Param       : NA
* @Return      : PageReference
***************************************************************************************************/
    public PageReference confirm(){        
        Savepoint sp = Database.setSavepoint();
        boolean confirmed = confirmbooking();
        PageReference returnPage = null;
        User user = [SELECT Id,Is_Portal_User__c, ContactId FROM User WHERE Id = :UserInfo.getUserId()  limit 1];
        try{
            if(confirmed){
                request.Start_Time__c=beginnningtimeslot.Start_Time__c;
                request.Assigned_Resource__c=selectresourceId;
                request.OwnerId=resourceuserId;
                Double valueinminutes=double.valueof(permit.Review_Hours_Based_on_Answers__c)*60;
                // request.Start_Time__c.addMinutes(Integer.valueOf(valueinminutes))
                System.debug('endtimeslot '+endtimeslot);
                request.End_Time__c= endtimeslot.End_Time__c;
                request.Status__c=Label.ST_Scheduled;
                List<Request__c> requests = new List<Request__c> ();
                requests.add(request);
                update  requests;
                
                if (user.Is_Portal_User__c == true) {
                    returnPage = new PageReference('/PlanReviewScheduled');
                    returnPage = (Permit.Generate_Invoice__c) ? new PageReference('/dashboard') : returnPage;
                }
                else {
                    returnPage = new PageReference('/apex/PlanReviewScheduled');
                }
                
                if(permit.musw__status__c==Label.ST_Submitted)
                {
                    List<Musw__review__c> reviews = [Select id ,ownerid from Musw__review__c where MUSW__Permit2__c=:permit.Id LIMIT 1];
                    if(reviews.size()==1){
                        reviews[0].ownerid=request.OwnerId;
                        update reviews;
                    }
                }
                return returnPage;
            }
            else{
                Database.rollback( sp );
                if (user.Is_Portal_User__c == true) {
                    returnPage = new PageReference('/PlanReviewNotConfirmed');
                }
                else {
                    returnPage = new PageReference('/apex/PlanReviewNotConfirmed');
                    
                }
                return returnPage;
            }
        } 
        Catch(Exception Ex){
            ErrorLogger.logGeneralException(Ex,UserInfo.getUserId(),'review_Information__c', 'Create review Request', 'schedulereview', 'reviewSchedulerController', 'Medium');
            Database.rollback( sp );
            if (user.Is_Portal_User__c == true) {
                returnPage = new PageReference('/PlanReviewNotConfirmed');
            }
            else {
                returnPage = new PageReference('/apex/PlanReviewNotConfirmed');
            }
            return returnPage;
        }
    }
    
    /***************************************************************************************************
* @Description : This functions selects the time the user chose from the portal and updates the tempate with the information 
* @Param       : NA
* @Return      : PageReference
***************************************************************************************************/
    public PageReference setThisTimeSlotAsFinal(){
        Map<Id,Time_slot__C> Mappingslots = new Map<Id,Time_slot__C>();
        for(Time_slot__C one : AvailableSlotsWithResCombination){           
            Mappingslots.put(one.id, one);
        }
        Id listIndex=  Id.valueof(apexpages.currentpage().getparameters().get('timeslot'));
        if( Mappingslots.get(listIndex)!=null){
            selectedslot = Mappingslots.get(listIndex);
            slotselected= selectedslot;                    
        }
        return null;
    }
    
    
    
    /***************************************************************************************************
* @Description : This functions selects the time the user chose from the portal and updates the tempate with the information 
* @Param       : NA
* @Return      : PageReference
***************************************************************************************************/
    public List<Time_slot__C> randomizer(Date selectedDate){
        List<String> resourcedts= new List<String>();
        String onlyres='';
        System.debug('resourcedategroup '+resourcedategroup);
        for(String rscdt : resourcedategroup.keySet())
        {
            System.debug('here');
            if(rscdt.substring(18, rscdt.length())==String.valueof(selectedDate))
            {
                resourcedts.add(rscdt);
            }
            else if(permit.Review_Hours_Based_on_Answers__c>8){
                if(rscdt.substring(18, 28)==String.valueof(selectedDate)){
                    resourcedts.add(rscdt);
                }
            }
        }
        if (resourcedts.size()== 1)
        {
            onlyres =resourcedts[0];
            return resourcedategroup.get(onlyres);           
        }
        else if(resourcedts.size()> 1){
            List<String> actuals = new List<String>();
            List<String> clones = resourcedts.clone();
            onlyres=resourcedts[Math.mod(Math.abs(Crypto.getRandomLong().intValue()),resourcedts.size())];
            return  resourcedategroup.get(onlyres);
        }
        
        return null;
    }
    
    /***************************************************************************************************
* @Description : This functions checks to see if the fbslot is still available before confirming the slot the user requested.
* @Param       : NA
* @Return      : Boolean
***************************************************************************************************/
    public boolean confirmbooking(){
        //todo
        List<time_slot__c> randomrscslection = randomizer(selectedslot.Start_Date__c);
        List <Database.SaveResult > saveResults = new  List <Database.SaveResult >();
        List<time_slot__c> listforupdate = new List<time_slot__c>();
        boolean checkSlotAvailability = true;
        try{
            if(randomrscslection!=null){
                for(Time_slot__c slot :[Select id,end_time__c,Backend_User__c,Resource__c , Status__c,Start_Time__c from time_slot__c where id =:randomrscslection  FOR UPDATE ]){
                    if(slot.Status__c!=Label.ST_Available)                      
                    {
                        checkSlotAvailability=false;
                    }
                    if(slot.Start_Time__c< System.now())
                    {
                        checkSlotAvailability=false;
                    }
                    listforupdate.add(slot);
                }
                if(checkSlotAvailability&&randomrscslection.size()>0){
                    beginnningtimeslot=selectedslot;
                    for(time_slot__c slot : listforupdate){
                        if(slot.Start_Time__c<beginnningtimeslot.Start_Time__c)
                        {
                            beginnningtimeslot=slot;
                        }
                        if(endtimeslot.End_Time__c==null)
                        {
                            endtimeslot=slot;
                        }
                        else if(slot.End_Time__c>endtimeslot.End_Time__c)
                        {                          
                            endtimeslot=slot;
                        }
                        slot.Request__c=request.id;
                        slot.status__c=Label.st_busy;
                        if(selectresourceId==null)
                        {
                            selectresourceId=slot.Resource__c;
                            resourceuserId=slot.Backend_User__c;
                        }
                        
                    }
                    if(listforupdate.size()>0){
                        saveResults = Database.update(listforupdate, true);  
                        if(saveresults!=null){
                            Boolean success=ErrorLogger.logDMLDatabaseResultErrorsWithResponse(UserInfo.getUserId(), null, saveResults, null, 'sObject','Update_records', null, 'SchedulerController',Label.Str_High, 'SchedulerController');
                            return success;
                        }
                        else{
                            return false;
                        }
                    }
                    else{
                        return false;
                    }
                }
                else{
                    return false;
                }
            }
            else{
                return false;
            }
        }
        catch(QueryException queryEx){
            ErrorLogger.logGeneralException(queryEx, UserInfo.getUserId(), 'sObject', 'Update records','SchedulerController', 'SchedulerController', Label.Str_High) ;
            return false;
        }catch(Exception ex){
            ErrorLogger.logGeneralException(ex, UserInfo.getUserId(), 'sObject', 'Update records','SchedulerController', 'SchedulerController', Label.Str_High) ;
            return false;
        }
    }
    
    @RemoteAction
    public static List<Resource__c> getResource(String searchstr,String apptype){
        List<Resource__c> lstrsc = [SELECT County__c, External_Id__c, Application_Type__c, User__c,user__r.Name, Active__c, Name, Id FROM Resource__c where Active__c=true and user__r.Name LIKE : searchstr and Application_Type__c=:apptype Order by Name ASC];
        return lstrsc;
    }
}