/**
 * Name: TimeSlotsHelper
 * Description: This class is used to create "FREE" Time Slots for future scheduling
 * Date:        - Case#/Project:            - Developer/Company                               - Description
 * ------------------------------------------------------------------------------------------------------------------------- *

 */
public class TimeSlotsHelper {
    
  public static OrgSettings__c getFBSlotSettings(OrgSettings__c os){
        try{            
            os=OrgSettings__c.getValues('FBSlots');
            if(os==null){
                os =new OrgSettings__c(name='FBSlots',Time_Slot_Created__c=false,
                                               Minimum_Slot_duration__c=0.5,
                                               Year__c=System.today().year(),
                                              Date_Slot_Created_Till__c=System.today().addYears(-1));
                insert os;
            }
            return os;
        }catch(Exception e){            
            ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'No Custom Setting found!!'));
            return null;
        }
    }
    public static BusinessHours getBusinessHours(){
        return [Select  SundayStartTime, name,MondayStartTime, TuesdayStartTime,
                 WednesdayStartTime, ThursdayStartTime, FridayStartTime,
                 SaturdayStartTime, SundayEndTime, MondayEndTime,TuesdayEndTime,
                 WednesdayEndTime, ThursdayEndTime, FridayEndTime,SaturdayEndTime
                 From BusinessHours where name='Wisconsin Business Hours'];
    
    }
    //Get slot time in Minutes
    public static Integer getSlotInMinute(OrgSettings__c os){
        return (Integer)(os.Minimum_Slot_duration__c*60);         
    }
    
    //Return true if creates new slots
    public static boolean createFreeFBSlots(DateTime startTime, OrgSettings__c os, BusinessHours bh, Integer monthsToAdd){
        Date currentDate = Date.today();
        DateTime endTime = startTime.addMonths(monthsToAdd);
        boolean newlyCreatedRecord = false;
        
        List<Time_Slot__c> newSlots = CommonUtil.generateNewTimeSlots(startTime, endTime, os, bh);
    if (newSlots.size() > 0) {
      newlyCreatedRecord = true;
    }
    
        try{
          if (newSlots != null && newSlots.size() >0) {
              insert newSlots;
          }
            os.Time_Slot_Created__c = true;
            os.Year__c = endTime.year();
            os.Slot_Created_From__c = currentDate.addDays(-2);
            os.Date_Slot_Created_Till__c = endTime.date();
            
            if (os != null ) {
              update os;
            }
        } catch(Exception e) {
            Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,'ErrMessages for Creating FBSlots for current Year:'+e));
            return null;
        }
        
        return newlyCreatedRecord;
    }
    
    public static boolean DeleteFBSlots(Datetime startdate, Datetime endtime){        
        return true;
    }
  
    public static Time getHHMM(DateTime dtime){
        return Time.newInstance(dtime.hour(), dtime.minute(), 0,0);
    }
    
   /***************************************************************************************************
* @Description : Creates a resource location availability record or modifies one when a resource is 
created or modified.
* @Param       : NA
* @Return      : void
***************************************************************************************************/      
    public static void ConfigureResources(List<Resource__c> newResources) {
        Map<Id, Resource__c> location_resources = new Map<Id, Resource__c> ();
        for (Resource__c newres : newResources) {
                  location_resources.put(newRes.id, newres);
        }
        
        if (location_resources.size() > 0) {
            
            List<Resource_Week_Availability__c> location_availability = [ SELECT Id, Backend_User__c,Resource__c FROM Resource_Week_Availability__c
                WHERE Resource__c IN :location_resources.keySet()
            ]; // Check if Location availability is configured
            Map<Id, Id> resToAvailability = new Map<Id, Id> ();
            for (Resource_Week_Availability__c loca_avail : location_availability) {
                resToAvailability.put(loca_avail.Resource__c, loca_avail.id);
            }
            List<Resource_Week_Availability__c> new_location_availabilty = new List<Resource_Week_Availability__c> ();
            for (Resource__c loc_res : location_resources.values()) {
                if (!resToAvailability.containsKey(loc_res.id)) {
                    Resource_Week_Availability__c loc_avail = new Resource_Week_Availability__c();
                    loc_avail.Resource__c = loc_res.id;
                    loc_avail.Schedule_Valid_From__c = System.today();
                    loc_avail.Schedule_Valid_till__c = System.today() + 90; 
                    loc_avail.AutoRenewal__c = true;
                    loc_avail.backend_user__c=loc_res.User__c;
                    new_location_availabilty.add(loc_avail);
                }
            }
            try{
                if (new_location_availabilty.size() > 0) {
                    upsert new_location_availabilty;
                }
            }
            catch(Exception e){
                ErrorLogger.logGeneralException(e, UserInfo.getUserId(), 'TimeSlotsHelper', 'upsertrecords', 'ConfigureResources', 'SchedulerTriggerHelper', label.Str_Low);
            }
        }
    }
    
     public static void createAllDayMon_to_Fri(List<Resource_Week_Availability__c> rlaRecords){  
        List<Resource_Availability__c> RARecords=new List<Resource_Availability__c>();        
        List<String> days=new List<String>{Label.Str_Monday,Label.Str_Tuesday,Label.Str_Wednesday,Label.Str_Thursday,Label.Str_Friday};
            for(Resource_Week_Availability__c rla:rlaRecords){
                for(String day:days){
                    Resource_Availability__c RA=new Resource_Availability__c();                    
                    RA.AutoRenewal__c = true;
                    RA.Day__c=day;
                    RA.Backend_User__c=rla.Backend_User__c;
                    RA.Resource__c=rla.Resource__c;
                    RA.Resource_Week_Availability__c=rla.id;
                    RARecords.add(RA);
                }
            }
        if(RARecords.size()>0)
            insert RARecords;
    }
    
    
}