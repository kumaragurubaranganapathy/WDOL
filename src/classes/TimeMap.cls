/*************************************************************************************************************
** User Story: 
**************************************************************************************************************
** Class Name       : TimeMap
** Description      : This class is data structure created to make filter time faster .
** Version          : 1.0
** Built By         : 
**------------------------------------------------------------------------------------------------------------
** Modification Log:
**------------------
** Developer                               Date          Version               Description
**------------------------------------------------------------------------------------------------------------
** Okwudiafor Akosa, Deloitte            11/14/2017          2.1              Improved the code,added comments.
** Review Log:
**---------------
** Reviewer                   Date           Version                Description
**------------------------------------------------------------------------------------------------------------
**
*************************************************************************************************************/
public class TimeMap {
    public List<Resource_Availability__c> availbility;
    public OrgSettings__c os;
    DateTime StartDateSunday=Datetime.newInstance(2016, 10, 9);//Set it to any sunday date ..dont change [MEC]    
    public Map<String,Set<Time>> DayTimeMap=new Map<String,Set<Time>>();
    static BusinessHours bh =TimeSlotsHelper.getBusinessHours();
    Integer slot;
    
    
    /***************************************************************************************************
* @Description : This is the constructor for the timemap class.
on the license.
* @Param       : List<Resource_Availability__c>
* @Return      : void
***************************************************************************************************/    
    public TimeMap(ID ResourceID){
        availbility=[select Day__c, Day_Number__c,Time_Availability__c,New_Time_Availability__c,Resource__c from Resource_Availability__c where Resource__c =: ResourceID limit 1000];
        os=TimeSlotsHelper.getFBSlotSettings(os);
        slot=TimeSlotsHelper.getSlotInMinute(os);     //in minutes
    }

    /***************************************************************************************************
* @Description : This is the constructor for the timemap class.
on the license.
* @Param       : List<Resource_Availability__c>
* @Return      : void
***************************************************************************************************/    
    public TimeMap(List<Resource_Availability__c> availability){
        
        this.availbility=availability;
        os=TimeSlotsHelper.getFBSlotSettings(os);
        slot=TimeSlotsHelper.getSlotInMinute(os);     //in minutes
    }
    
    /***************************************************************************************************
* @Description : This functions creates a map of times for a particular resource.
on the license.
* @Param       : NA
* @Return      : void
***************************************************************************************************/      
    public void constructDayTimeMap(){
        for(Resource_Availability__c res_avl:availbility){
                Set<Time> times=new Set<Time>();
               
                if((String.isEmpty(res_avl.Time_Availability__c)&&String.isEmpty(res_avl.New_Time_Availability__c))||res_avl.New_Time_Availability__c==Label.St_Unavailable||res_avl.Time_Availability__c==Label.St_Unavailable){
                    DayTimeMap.put(res_avl.Day__c, times);
                    continue;
                }
                
                if(res_avl.New_Time_Availability__c!=null||res_avl.New_Time_Availability__c==Label.St_Unavailable){
                    for(String aTime:res_avl.New_Time_Availability__c.split(';')){                    
                        String[] splitTimeRange=aTime.split('to');                   
                        DateTime considerDate= StartDateSunday.addDays((Integer)res_avl.Day_Number__c);   
                        Time StartTime=getTimeByString(splitTimeRange[0].split('\\.')[0],splitTimeRange[0].split('\\.')[1]);
                        Time EndTime=getTimeByString(splitTimeRange[1].split('\\.')[0],splitTimeRange[1].split('\\.')[1]);                    
                        times.addAll(getTimeBetweenStartAndEndTime(DateTime.newInstance(considerDate.date(),EndTime)
                                                                   ,DateTime.newInstance(considerDate.date(),StartTime)));                    
                    }
                }
                else{
                    for(String aTime:res_avl.Time_Availability__c.split(';')){                    
                        String[] splitTimeRange=aTime.split('to');                   
                        DateTime considerDate= StartDateSunday.addDays((Integer)res_avl.Day_Number__c);   
                        Time StartTime=getTimeByString(splitTimeRange[0].split('\\.')[0],splitTimeRange[0].split('\\.')[1]);
                        Time EndTime=getTimeByString(splitTimeRange[1].split('\\.')[0],splitTimeRange[1].split('\\.')[1]);                    
                        times.addAll(getTimeBetweenStartAndEndTime(DateTime.newInstance(considerDate.date(),EndTime)
                                                                   ,DateTime.newInstance(considerDate.date(),StartTime)));                    
                    }
                }
                DayTimeMap.put(res_avl.Day__c, times);
        }
    }
    
    /***************************************************************************************************
* @Description : This functions creates a time based on the strings passed.
on the license.
* @Param       : String,String
* @Return      : Time
***************************************************************************************************/      
    @TestVisible Time getTimeByString(String hh,String mm){
        return Time.newInstance(Integer.valueOf(hh.trim()), Integer.valueOf(mm.trim()), 0, 0);
    }
    
    /***************************************************************************************************
* @Description : This functions creates a set of time based on the day
on the license.
* @Param       : Integer
* @Return      : Set<time> Time
***************************************************************************************************/      
    @TestVisible Set<Time> getAllTime(Integer DayNumber){
        DateTime endTime=StartDateSunday.addDays(DayNumber+1);
        DateTime targetTime=StartDateSunday.addDays(DayNumber);
        Set<Time> times=new Set<time>();
        while(True){
            if(targetTime>endTime){
                break;
            }
            if(BusinessHours.isWithin(bh.id, targetTime)){
                Time temp=Time.newInstance(targetTime.hour(), targetTime.minute(),0,0);
                times.add(temp);                 
            }
            targetTime=targetTime.addMinutes(slot);
        }
        return times;
    }
    
    /***************************************************************************************************
* @Description : This functions creates a set of time based on the dates given
on the license.
* @Param       : Date,Date
* @Return      : Set<time> Time
***************************************************************************************************/      
    @TestVisible Set<Time> getTimeBetweenStartAndEndTime( DateTime EndDateTime,DateTime StartDateTime){
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
    
    
    
    
}