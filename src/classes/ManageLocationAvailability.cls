/*************************************************************************************************************
** User Story: 
**************************************************************************************************************
** Name                : ManageLocationAvailability 
** Description         : Future class to manage avalibility of resources
** Version             : 1.0
** Built By            : Okwudiafor Akosa
**------------------------------------------------------------------------------------------------------------
** Modification Log:
**------------------
** Developer                         Date                    Version                      Description
**------------------------------------------------------------------------------------------------------------
** Okwudiafor Akosa                11/28/17                                
** Review Log:
**---------------
** Reviewer                  Date           Version               Description
**------------------------------------------------------------------------------------------------------------
**
************************************************************************************/ 

public class ManageLocationAvailability{
    
    
    /***************************************************************************************************
* @Description : The function clears all the fb slots currently on the resource.
on the license.
* @Param       : Set<ID>
* @Return      : void
***************************************************************************************************/
    public static void freeblockedAvaliblityOfLocation(Set<ID> LocationIDs){
        Datetime startDateTime=System.today().addDays(-1);
        Datetime endDateTime=System.now().addDays(124);
        List<Time_Slot__c> freeSlots=[Select id
                                      from Time_Slot__c 
                                      where (status__c=:Label.ST_Available) and 
                                      Resource__c in :locationIDs and
                                      Start_Time__c>:startDateTime and End_Time__c<=:endDateTime];  
        delete freeSlots;
    }
    
    /***************************************************************************************************
* @Description : Creates fbslots for the resource based on the configurations made.
on the license.
* @Param       : MAP<ID,List<Resource_Availabilty__c>>
Resource_Availability__c
* @Return      : void
***************************************************************************************************/
    public static void blockAvaliblityOfResources(MAP<ID,List<Resource_Availability__c>> LocationIDlocAvailMap){
        DateTime todayDateTime = system.today();
        Datetime startDateTime=todayDateTime;
        Datetime endDateTime=todayDateTime.addDays(91);
        MAP<ID,TimeMap> selectedResourceTimeGraph=getLocationTimeGraph(LocationIDlocAvailMap);
        List<Time_Slot__c> freeSlots=[Select id,status__c,Resource__c,Start_Time__c,End_Time__c 
                                      from Time_Slot__c 
                                      where status__c=:Label.ST_Free and
                                      Start_Time__c>:startDateTime and Start_Time__c<=:endDateTime];
        List<Time_Slot__c> busySlots=new List<Time_Slot__c>();
        for(ID location:LocationIDlocAvailMap.keySet()){
            if(LocationIDlocAvailMap.get(location).size()>0){
                resource__c selectedresource =[select id,user__c,user__r.id,Application_type__c from resource__c where id=:location];
                System.debug(' LocationIDlocAvailMap.get(location).get(0). '+ LocationIDlocAvailMap.get(location).get(0));
                busySlots.addAll(applyAllocationToLocation(selectedresource,freeSlots,location,
                                                           LocationIDlocAvailMap.get(location).get(0).Valid_From_Date__c,          
                                                           LocationIDlocAvailMap.get(location).get(0).Valid_till_Date__c.addDays(1),
                                                           selectedResourceTimeGraph.get(location).DayTimeMap));
            }
        }
        if(busySlots.size()>0){
            database.insert(busySlots, false);
        }
    }
    
    /***************************************************************************************************
* @Description : Creates fbslots for the resource based on the configurations made through a batch
process for an extra day everyday
on the license.
* @Param       : MAP<ID,List<Resource_Availabilty__c>>
* @Return      : void
***************************************************************************************************/
    public static void blockAvaliblityOfResourcesdailybatch(MAP<ID,List<Resource_Availability__c>> LocationIDlocAvailMap){
        Datetime startDateTime=System.now().addDays(120);
        Datetime endDateTime=System.now().addDays(121);
        MAP<ID,TimeMap> selectedResourceTimeGraph=getLocationTimeGraph(LocationIDlocAvailMap);
        List<Time_Slot__c> freeSlots=[Select id,status__c,Resource__c,Start_Time__c,End_Time__c 
                                      from Time_Slot__c 
                                      where status__c=:Label.ST_Free and
                                      Start_Time__c>:startDateTime and Start_Time__c<=:endDateTime];
        List<Time_Slot__c> busySlots=new List<Time_Slot__c>();
        for(ID location:LocationIDlocAvailMap.keySet()){
            if(LocationIDlocAvailMap.get(location).size()>0){
                resource__c selectedresource =[select id,user__c,user__r.id,Application_type__c from resource__c where id=:location];
                busySlots.addAll(applyAllocationToLocationdailybatch(selectedresource,freeSlots,location,       
                                                                     LocationIDlocAvailMap.get(location).get(0).Valid_till_Date__c.addDays(1),
                                                                     selectedResourceTimeGraph.get(location).DayTimeMap));
            }
        }
        if(busySlots.size()>0){
            database.insert(busySlots, false);
        }
    }
    
    /***************************************************************************************************
* @Description : Creates a map of times for  a given particualar resoruce
on the license.
* @Param       : MAP<ID,List<Resource_Availabilty__c>>
* @Return      : void
***************************************************************************************************/
    public static MAP<ID,TimeMap> getLocationTimeGraph(MAP<ID,List<Resource_Availability__c>> LocationIDlocAvailMap){
        MAP<ID,TimeMap> selectedResourceTimeGraph=new MAP<ID,TimeMap>();
        for(ID location:LocationIDlocAvailMap.keySet()){
            TimeMap tMap=new TimeMap(LocationIDlocAvailMap.get(location));  
            tMap.constructDayTimeMap();
            selectedResourceTimeGraph.put(location,tMap);
        }
        return selectedResourceTimeGraph;
    }   
    
    /***************************************************************************************************
* @Description : Determining which fbslots should be created for the given configuration, either available
or slots are created for the next 90 days.
on the license.
* @Param       : List<Time_Slot__c>, ID ,Decimal, Boolean ,Date ,Date ,Map<String,Set<Time>> 
* @Return      : void
***************************************************************************************************/    
    public static List<Time_Slot__c> applyAllocationToLocation(resource__c selectedresource,List<Time_Slot__c> availableSlots,ID resourceID,Date startTime,Date EndTime, Map<String,Set<Time>> DayTimeMap){
        List<Time_Slot__c> availableSlottemplate=availableSlots; 
        DateTime todayDateTime = system.today();
        Datetime startDateTime=todayDateTime;
        Datetime endDateTime=todayDateTime.addDays(120);
        Set<Datetime> slots = new Set<Datetime>();
        
        for(Time_Slot__c slot: [Select id,Start_Time__c from Time_Slot__c where Resource__c =:resourceID and
                                Start_Time__c>:startDateTime and Start_Time__c<=:endDateTime])
        {
            slots.add(slot.Start_Time__c);
        }
        
        List<Time_Slot__c> locationBusy_final=new List<Time_Slot__c>(); 
        Set<Datetime> newitems = new Set<Datetime> ();
        for(Integer i=0;i<availableSlottemplate.size();i++){            
            Time_Slot__c temp=availableSlottemplate.get(i);
            if(startTime<=temp.Start_Time__c&&endTime>=temp.Start_Time__c){
                String day=temp.Start_Time__c.format('EEEE');
                if(DayTimeMap.isEmpty())
                    continue;
                else if(!DayTimeMap.containsKey(day)){
                    continue;
                }else{
                    if(!newitems.contains(temp.Start_Time__c)&&!slots.contains(temp.Start_Time__c)&&DayTimeMap.containsKey(day)&&DayTimeMap.get(day).contains(TimeSlotsHelper.getHHMM(temp.Start_Time__c))){
                        locationBusy_final.add(createNewAvailableSlot(selectedresource.Application_Type__c,temp,resourceID,selectedresource.User__r.Id));
                        newitems.add(temp.Start_Time__c);
                    } 
                }
            }
            
        }
        return locationBusy_final;
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
        
        for(Time_Slot__c slot: [Select id,Start_Time__c from Time_Slot__c where status__c=:Label.ST_Busy and Resource__c =:resourceID and
                                Start_Time__c>=:dates])
        {
            slots.add(slot.Start_Time__c);
        }
        
        for(Integer i=0;i<availableSlottemplate.size();i++){            
            Time_Slot__c temp=availableSlottemplate.get(i);
            String day=endDateTime.format('EEEE');    
            if(DayTimeMap.containsKey(day)&&DayTimeMap.get(day).contains(TimeSlotsHelper.getHHMM(temp.Start_Time__c))&&!slots.contains(temp.Start_Time__c)){
                locationBusy_final.add(createNewAvailableSlot(selectedresource.Application_Type__c,temp,resourceID,selectedresource.User__r.Id));
                newitems.add(temp.Start_Time__c);
            }                                                                                   
        }
        return locationBusy_final;
    }
        
    
    /***************************************************************************************************
* @Description : This is  where the available fbslot for the resource is made.
* @Param       : Time_Slot__c, Integer , Id
* @Return      : void
***************************************************************************************************/
    public static Time_Slot__c createNewAvailableSlot(String applicationtype,Time_Slot__c slot,ID resourceID,ID userid){
        Time_Slot__c temp=new Time_Slot__c();
        temp.resource__c=resourceID;
        temp.Backend_User__c=userid;
        temp.Status__c=Label.St_Available;
        temp.Application_Type__c=applicationtype;
        temp.Start_Time__c=slot.Start_Time__c;
        temp.End_Time__c=slot.End_Time__c;
        return temp;
    }
    
    /***************************************************************************************************
* @Description : This is  where the batch is initiated through.
* @Param       : List<Resource_Availability__c>
* @Return      : void
***************************************************************************************************/
    public static void blockAvaliblityOfResourcesBatch(List<Resource_Week_Availability__c> res){
        String Query='Select '+CommonUtil.getFields('Resource_Availability__c')+ 
            ' from Resource_Availability__c where Resource_Week_Availability__c in :res';
        MAP<ID,List<Resource_Availability__c>> LocationIDlocAvailMap=new MAP<ID,List<Resource_Availability__c>>();
        for(Resource_Availability__c loc: Database.query(query)){
            List<Resource_Availability__c> locAvailList=new List<Resource_Availability__c>();
            if(LocationIDlocAvailMap.containsKey(loc.Resource__c))
                locAvailList=LocationIDlocAvailMap.get(loc.Resource__c);
            locAvailList.add(loc);
            LocationIDlocAvailMap.put(loc.Resource__c, locAvailList);
        }
        if(LocationIDlocAvailMap.size()>0)
            ManageLocationAvailability.blockAvaliblityOfResourcesdailybatch(LocationIDlocAvailMap);
    }
    
    /***************************************************************************************************
* @Description : This is  where the update  is initiated through.
* @Param       : List<Resource_Location_Avalability__c>
* @Return      : void
***************************************************************************************************/
    public static void blockAvaliblityOfResourcesUpdate(Set<Id> res){
        String Query='Select '+CommonUtil.getFields('Resource_Availability__c')+ 
            ' from Resource_Availability__c where  Resource_Week_Availability__c in :res';
        MAP<ID,List<Resource_Availability__c>> LocationIDlocAvailMap=new MAP<ID,List<Resource_Availability__c>>();
        for(Resource_Availability__c loc: Database.query(query)){
            List<Resource_Availability__c> locAvailList=new List<Resource_Availability__c>();
            if(LocationIDlocAvailMap.containsKey(loc.Resource__c))
                locAvailList=LocationIDlocAvailMap.get(loc.Resource__c);
            locAvailList.add(loc);
            LocationIDlocAvailMap.put(loc.Resource__c, locAvailList);
        }
        if(LocationIDlocAvailMap.size()>0)
            ManageLocationAvailability.blockAvaliblityOfResources(LocationIDlocAvailMap);
    }
    
    /***************************************************************************************************
* @Description : The function clears all the past fb slots currently on the resource.
on the license.
* @Param       : Set<ID>
* @Return      : void
***************************************************************************************************/    
    public static void removeAvaliblityOfResourcesBatch(set<ID> LocationIds){
        List<Time_Slot__c> freeSlots=[Select id
                                      from Time_Slot__c 
                                      where (status__c=:Label.ST_Busy or status__c=:Label.ST_Available) and 
                                      Resource__c in :locationIDs and Start_Date__c<today];  
        if(freeslots.size()>0)
            delete freeSlots;
    }
}