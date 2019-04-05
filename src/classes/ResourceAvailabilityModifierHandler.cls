/*************************************************************************************************************
** User Story: 
**************************************************************************************************************
** Name                : ResourceAvailabilityModifierHandler
** Description         :  
** Version             : 1.0
** Built By            : 
**------------------------------------------------------------------------------------------------------------
** Modification Log:
**------------------
** Developer                         Date                    Version                      Description
**------------------------------------------------------------------------------------------------------------
**
**
**
** Review Log:
**---------------
** Reviewer                  Date           Version               Description
**------------------------------------------------------------------------------------------------------------
**
************************************************************************************/
public class ResourceAvailabilityModifierHandler {
    
    public static  void ResourceAvailabilityModifierHandlerManager(List<Resource_Availability_Modifier__c> newSObj){
        ResourceAvailabilityModifierHandler.unavailableresource(newSobj);
        ResourceAvailabilityModifierHandler.availableresource(newSobj);
    }
    public static void unavailableresource(List<Resource_Availability_Modifier__c> newSObj){
        Boolean fbslotcomplete=false;
        List<Resource_Availability_Modifier__c> Sorteditems = new   List<Resource_Availability_Modifier__c>();
        Map<Id,Id> resMd = new  Map<Id,Id> ();
        for(Resource_Availability_Modifier__c resmod: newSObj){            
            if(resmod.Status__c==Label.ST_Eligible&&resmod.Date__c!=null&&resmod.Activity__c==Label.Str_Make_Unavailable){
                sorteditems.add(resmod);
                resMd.put(resmod.Id,resmod.resource__c);
            }
        }
        Map<String,List<Time_slot__c>> usertimeslots = new  Map<String,List<time_slot__c>>();
        for( time_slot__c timeslot :   [Select id,Resource__c,Start_Date__c from time_slot__c where Resource__c=:resmd.values() and Backend_User__c!='' and status__c=:Label.ST_Available])
        {
            if(usertimeslots.containsKey(timeslot.Resource__c+String.valueof(timeslot.Start_Date__c)))
            {
                usertimeslots.get(timeslot.Resource__c+String.valueof(timeslot.Start_Date__c)).add(timeslot);
            }
            else if(!usertimeslots.containsKey(timeslot.Resource__c+String.valueof(timeslot.Start_Date__c))) {
                usertimeslots.put(timeslot.Resource__c+String.valueof(timeslot.Start_Date__c),new List<time_slot__c> { timeslot} );
            }
        }
        
        List<Time_slot__c> fbslotsforupdate = new List<Time_slot__c>(); 
        for(Resource_Availability_Modifier__c resmod : sorteditems)
        {
            if(usertimeslots.containskey(resmod.Resource__c+String.valueof(resmod.Date__c)))
            {
                fbslotsforupdate.addall(usertimeslots.get(resmod.Resource__c+String.valueof(resmod.Date__c)));
                resmod.Status__c=Label.Str_success;
                resmod.More_Information__c='The time modification succeeded to make the day busy ';
            }
            else {
                resmod.Status__c=Label.St_Failed;
                resmod.More_Information__c='The resource is currently busy or there is no availability on the chosen date.';
            }
        }
        if(fbslotsforupdate.size()>0)
        {
            for(Time_slot__c timeslot:fbslotsforupdate )
            {
                timeslot.Status__c=Label.St_Busy;
            }
        }
        if(fbslotsforupdate.size()>0){
            List <Database.SaveResult > saveResults = Database.update(fbslotsforupdate, true);  
            fbslotcomplete =ErrorLogger.logDMLDatabaseResultErrorsWithResponse(UserInfo.getUserId(), null, saveResults, null, 'sObject',' Update records', null, 'ResourceAvailabilityModifierHandler', label.str_HIGH, 'ResourceAvailabilityModifierHandler');
        }
        
        if(!fbslotcomplete)
        {
            for(Resource_Availability_Modifier__c resmod : sorteditems)
            {
                resmod.Status__c=Label.St_Failed;
                resmod.More_Information__c='There was an unexpected error,please try again.';
            }
            
        }
    }
    
    public static void availableresource(List<Resource_Availability_Modifier__c> newSObj){
        Boolean fbslotcomplete=false;
        List<Resource_Availability_Modifier__c> Sorteditems = new   List<Resource_Availability_Modifier__c>();
        Map<Id,Id> resMd = new  Map<Id,Id> ();
        for(Resource_Availability_Modifier__c resmod: newSObj){            
            if(resmod.Status__c==Label.ST_Eligible&&resmod.Date__c!=null&&resmod.Activity__c==Label.Str_Make_Available){
                sorteditems.add(resmod);
                resMd.put(resmod.Id,resmod.resource__c);
            }
        }
        Map<Id,Resource__c> resmap =new Map<Id,Resource__c> ([Select id, User__r.Id,Application_Type__c from Resource__c where id=:resmd.values()]);
        Map<String,List<Time_slot__c>> usertimeslots = new  Map<String,List<time_slot__c>>();
        for( time_slot__c timeslot :   [Select id,Status__c,Request__c,Resource__c,Start_Date__c from time_slot__c where Resource__c=:resmd.values() and Backend_User__c!='' ])
        {
            if(usertimeslots.containsKey(timeslot.Resource__c+String.valueof(timeslot.Start_Date__c)))
            {
                usertimeslots.get(timeslot.Resource__c+String.valueof(timeslot.Start_Date__c)).add(timeslot);
            }
            else if(!usertimeslots.containsKey(timeslot.Resource__c+String.valueof(timeslot.Start_Date__c))) {
                usertimeslots.put(timeslot.Resource__c+String.valueof(timeslot.Start_Date__c),new List<time_slot__c> { timeslot} );
            }
        }
        
        List<Time_slot__c> fbslotsforupdate = new List<Time_slot__c>(); 
        List<Time_slot__c> fbslotsforudelete = new List<Time_slot__c>(); 
        for(Resource_Availability_Modifier__c resmod : sorteditems)
        {
            if(usertimeslots.containskey(resmod.Resource__c+String.valueof(resmod.Date__c)))
            {
                List<Time_slot__c> testing = new List<Time_slot__c>();
                boolean status=true;
                for(Time_Slot__c timeslots : usertimeslots.get(resmod.Resource__c+String.valueof(resmod.Date__c))){
                    if(timeslots.status__c==Label.St_Available||(timeslots.Request__c==null&&timeslots.status__c==Label.St_Busy)){
                        resmod.Status__c=Label.Str_success;
                        resmod.More_Information__c='The time modification succeeded to make the time Available';
                    }
                    else{
                        resmod.Status__c=Label.St_Failed;
                        status=false; 
                        resmod.More_Information__c='The time modification failed as the resource is already booked on this day.';
                    }
                    
                }
                if(status)
                { 
                    boolean deleteall = deleteslots(usertimeslots.get(resmod.Resource__c+String.valueof(resmod.Date__c)));
                    if(deleteall)
                    {
                        List<Time_Slot__C> newslots=  createnewslots( resmod, resmap);
                        if(newslots!=null&&newslots.size()>0)
                        {
                            fbslotsforupdate.addall(newslots);
                        }
                        
                    }
                    else{
                        resmod.Status__c=Label.St_Failed;
                        resmod.More_Information__c='The time modification failed.';
                    }
                }
            }
            else {
                
                List<Time_Slot__C> newslots=  createnewslots( resmod, resmap);
                if(newslots!=null&&newslots.size()>0)
                {
                    fbslotsforupdate.addall(newslots);
                }
            }
        }

        if(fbslotsforupdate.size()>0){
            List <Database.SaveResult > saveResults = Database.insert(fbslotsforupdate, true);  
            fbslotcomplete =ErrorLogger.logDMLDatabaseResultErrorsWithResponse(UserInfo.getUserId(), null, saveResults, null, 'sObject',' Update records', null, 'ResourceAvailabilityModifierHandler', label.str_HIGH, 'ResourceAvailabilityModifierHandler');
        }
        
        if(!fbslotcomplete)
        {
            for(Resource_Availability_Modifier__c resmod : sorteditems)
            {
                resmod.Status__c=Label.St_Failed;
                resmod.More_Information__c='There was an unexpected error,please try again.';
            }
            
        }
    }
    
    /***************************************************************************************************
* @Description : Determining which fbslots should be created for the given configuration, either available
or slots are created for the next  day for the batch on the license.
* @Param       : List<Time_Slot__c>, ID ,Decimal, Boolean ,Date ,Date ,Map<String,Set<Time>> 
* @Return      : void
***************************************************************************************************/ 
    public static List<Time_Slot__c> applyAllocationToLocationdailybatch(resource__c selectedresource,List<Time_Slot__c> availableSlots,ID resourceID,Date EndTime,Map<String,Set<Time>> DayTimeMap){
        List<Time_Slot__c> availableSlottemplate=availableSlots;              
        Datetime endDateTime=EndTime;
        List<Time_Slot__c> locationBusy_final=new List<Time_Slot__c>(); 
        Set<Datetime> newitems = new Set<Datetime> ();
        Datetime dates=System.now().addDays(120);
        Set<Datetime> slots = new Set<Datetime>();
        
        for(Time_Slot__c slot: [Select id,Start_Time__c from Time_Slot__c where status__c=:Label.ST_Available and Resource__c =:resourceID and
                                Start_Time__c>=:dates])
        { 
            slots.add(slot.Start_Time__c);
        }
        for(Integer i=0;i<availableSlottemplate.size();i++){            
            Time_Slot__c temp=availableSlottemplate.get(i);
                locationBusy_final.add(ManageLocationAvailability.createNewAvailableSlot(selectedresource.Application_Type__c,temp,resourceID,selectedresource.User__r.Id));
                newitems.add(temp.Start_Time__c);                                                                               
        }
        return locationBusy_final;
    }
    
    static Time getTimeByString(String hh,String mm){
        return Time.newInstance(Integer.valueOf(hh.trim()), Integer.valueOf(mm.trim()), 0, 0);
    }
    
    /***************************************************************************************************
* @Description : This functions creates a set of time based on the dates given
on the license.
* @Param       : Date,Date
* @Return      : Set<time> Time
***************************************************************************************************/      
    static Set<Time> getTimeBetweenStartAndEndTime( DateTime EndDateTime,DateTime StartDateTime){
        BusinessHours bh =TimeSlotsHelper.getBusinessHours();
        Integer  slot=30;
        Set<Time> times=new Set<time>();
        while(true){
            if(StartDateTime>=EndDateTime)
                break;
            if(BusinessHours.isWithin(bh.id, StartDateTime)){
                Time temp=Time.newInstance(StartDateTime.hour(), StartDateTime.minute(),0,0);
                times.add(temp);               
            }            
            StartDateTime=StartDateTime.addMinutes(slot); 
        }
        return times;
    }
    
    static List<Time_Slot__c> createnewslots(Resource_Availability_Modifier__c resmod,  Map<Id,Resource__c> resmap){
        Datetime startDateTime=resmod.Date__c;
        Datetime endDateTime=resmod.Date__c.addDays(1);
        List<Time_Slot__c> freeSlots=[Select id,status__c,Resource__c,Start_Time__c,End_Time__c 
                                      from Time_Slot__c 
                                      where status__c=:Label.ST_Free and
                                      Start_Time__c>:startDateTime and Start_Time__c<=:endDateTime];
        if(resmod.Time_Availability_per_Day__c!=''&&!resmod.Time_Availability_per_Day__c.contains(Label.ST_Unavailable)){
            Resource__c res = new Resource__c();
            Set<Time> times=new Set<Time>();
            Map<String,Set<Time>> DayTimeMap=new Map<String,Set<Time>>();
            DayTimeMap.put(endDateTime.format('EEEE'), times);
            res=  resmap.get(resmod.Resource__c);
            for(String aTime:resmod.Time_Availability_per_Day__c.split(';')){                    
                String[] splitTimeRange=aTime.split('to');                   
                Time StartTime=getTimeByString(splitTimeRange[0].split('\\.')[0],splitTimeRange[0].split('\\.')[1]);
                Time EndTime=getTimeByString(splitTimeRange[1].split('\\.')[0],splitTimeRange[1].split('\\.')[1]);                    
                times.addAll(getTimeBetweenStartAndEndTime(DateTime.newInstance(resmod.Date__c,EndTime)
                                                           ,DateTime.newInstance(resmod.Date__c,StartTime))); 
            }
            return  applyAllocationToLocationdailybatch(res,freeSlots,res.Id,resmod.Date__c.adddays(1),DayTimeMap);
        }
        return null;
    }
    
    static Boolean deleteslots(List<Time_slot__c> fbslotsfordelete){
        boolean fbslotcomplete=false;
        if(fbslotsfordelete.size()>0)
        {
            List <Database.deleteresult > saveResults = Database.delete(fbslotsfordelete, true);  
            fbslotcomplete =ErrorLogger.logDMLDatabaseResultErrorsWithResponse(UserInfo.getUserId(), saveResults,null, null, 'sObject',' Update records', null, 'ResourceAvailabilityModifierHandler', label.str_HIGH, 'ResourceAvailabilityModifierHandler');        
        }
        return  fbslotcomplete;
    }
}