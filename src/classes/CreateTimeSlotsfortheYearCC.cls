/*************************************************************************************************************
** User Story: 
**************************************************************************************************************
** Class Name       : CreateTimeSlotsfortheyearCC
** Description      :
** Version          : 1.0
** Built By         : 
**------------------------------------------------------------------------------------------------------------
** Modification Log:
**------------------
** Developer                               Date          Version               Description
**------------------------------------------------------------------------------------------------------------
** 
** Okwudiafor Akosa, Deloitte          
** Review Log:
**---------------
** Reviewer                   Date           Version                Description
**------------------------------------------------------------------------------------------------------------
**
*************************************************************************************************************/
public class CreateTimeSlotsfortheYearCC {
    private BusinessHours bh;
    private Integer slotDuration = 0;
    
    public Boolean newlyCreatedRecord { get; set; }
    public OrgSettings__c os{ get; set;}   
    public Integer slot_dur_in_minutes {
        get {
            if (os != null) {
                slotDuration = Integer.valueOf(os.Minimum_Slot_duration__c * 60);
            }
            
            return slotDuration;
        } set {
            slotDuration = slot_dur_in_minutes / 60;
            
            if (os != null) {
                os.Minimum_Slot_duration__c = slotDuration;
            }        
        }
    } 
    
    public CreateTimeSlotsfortheyearCC(){
        //Constructor
    }
   
    /***************************************************************************************************
* @Description : Get the business hours for the org.
* @Param       : NA
* @Return      : void
***************************************************************************************************/ 
    public void getFBSlotAndOrgBusinessHours(){
        try {            
            os = TimeSlotsHelper.getFBSlotSettings(os);            
            newlyCreatedRecord = false;
            bh = TimeSlotsHelper.getBusinessHours();
        } catch (Exception e) {            
            ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'No custom Setting found'));
        }
    }

/***************************************************************************************************
* @Description : Create the  fbslots for a year.
* @Param       : NA
* @Return      : PageReference
***************************************************************************************************/      
    public PageReference createSlotsForYear()
    {
        Date currentDate = Date.today();
        Integer currentYear = currentDate.year();
        Integer currentMonth = currentDate.Month();
        Integer currentDay = currentDate.Day();
        DateTime startTime=Datetime.newInstance(currentYear, currentMonth, currentDay);
        DateTime endTime=Datetime.newInstance(currentYear + 1, currentMonth, currentDay);
        
        List<Time_Slot__c> newSlots =CommonUtil.generateNewTimeSlots(startTime, endTime, os, bh);
        if (newSlots.size() > 0) {
            newlyCreatedRecord = true;
        }
        
        try{
            insert newSlots;
            os.Time_Slot_Created__c = true;
            os.Year__c = currentYear;
            os.Slot_Created_From__c = currentDate;
            os.Date_Slot_Created_Till__c = endTime.date();
            update os;
        } catch(Exception e) {
            Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,'Label.Err_Messages_for_Creating_FBSlots_for_current_Year'+e));
            return null;
        }
        
        if(newlyCreatedRecord) {
            ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.INFO, newSlots.size() +' created successfully'));
        } else {
            ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.WARNING,' no_new_FBSlots_Record_Created'));
        }
        
        return null;
    }
    
    public void SaveSetting(){
        update os;        
        os=OrgSettings__c.getValues('POWTS Slots');
    }
    
 /***************************************************************************************************
* @Description : Delete the all fbslots.
* @Param       : NA
* @Return      : void
***************************************************************************************************/  
    public void deleteAllSlot(){
        List<Time_Slot__c> slotsInserted;        
        slotsInserted = [SELECT Id 
                         FROM Time_Slot__c WHERE
                         Resource__c = null 
                         AND status__c ='Free'];
        
        try{            
            delete slotsInserted;
            newlyCreatedRecord = false;
            os.Time_Slot_Created__c = false;
            update os;
            ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.INFO,slotsInserted.size()+'Label.Str_Number_of_FBSlots_deleted_successfully'));
        }catch(Exception e){
            Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,'Label.Err_Messages_for_deleting_FBSlots_for_current_Year'+e));
        }
    }


/***************************************************************************************************
* @Description : Delete the old fbslots.
* @Param       : NA
* @Return      : void
***************************************************************************************************/    
    public void freeUpFbslotTable(){
        List<Time_Slot__c> oldSlots = [SELECT Id 
                                     FROM Time_Slot__c 
                                     WHERE Resource__c = NULL 
                                     AND Start_Time__c < :System.now() limit 10000];
        try {               
            delete oldSlots;
            newlyCreatedRecord = false;
            ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.INFO, oldSlots.size()+'Label.Str_old_time_slots_deleted_successfully'));
        } catch(Exception e) {
            Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,' Label.Err_Exception_while_deleting_old_time_slots' + e));
        }
    }

/***************************************************************************************************
* @Description : Get Business hours for display in VF page
* @Param       : NA
* @Return      : List<BusinessHoursRecord>
***************************************************************************************************/
    public List<BusinessHoursRecord> getWorkingHours(){
        List<Time> startHours = new Time [7];
        List<Time> endHours = new Time [7];
        
        startHours[0] = bh.SundayStartTime;
        startHours[1] = bh.MondayStartTime;
        startHours[2] = bh.TuesdayStartTime;
        startHours[3] = bh.WednesdayStartTime;
        startHours[4] = bh.ThursdayStartTime;
        startHours[5] = bh.FridayStartTime;
        startHours[6] = bh.SaturdayStartTime;
        
        endHours[0] = bh.SundayEndTime;
        endHours[1] = bh.MondayEndTime;
        endHours[2] = bh.TuesdayEndTime;
        endHours[3] = bh.WednesdayEndTime;
        endHours[4] = bh.ThursdayEndTime;
        endHours[5] = bh.FridayEndTime;
        endHours[6] = bh.SaturdayEndTime;
        
        List<String> days=new List<String>{Label.Str_Sunday,Label.Str_Monday,Label.Str_Tuesday,Label.Str_Wednesday,Label.Str_Thursday,Label.Str_Friday,Label.Str_Saturday};
        List<BusinessHoursRecord> businessDays = new List<BusinessHoursRecord>();
        
        for(integer i = 0; i < 7; i++){
            if(startHours[i] != null) {
                businessDays.add(new BusinessHoursRecord(days[i], startHours[i], endHours[i]));
            }
        }
        
        return businessDays;
    }

/***************************************************************************************************
* @Description : Get Holiday to display on VF page
* @Param       : NA
* @Return      : List<Holiday>
***************************************************************************************************/  
    public List<Holiday> getHolidayHours(){
        List<Holiday> holidays = [SELECT Id, Name, Description, ActivityDate 
                                  FROM Holiday 
                                  WHERE Id != NULL limit 300];
        
        return holidays;
    }
    //Business hour datastructure
    class businessHoursRecord {
        public String day {get; set;}
        public time st {get; set;}
        public time et {get; set;}
        
        public businessHoursRecord(String d,time s,time e){
            day=d;
            st=s;
            et=e;            
        }
    }
}