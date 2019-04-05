/*Name: FBSlotsCreateDelete
*Description: Utility class to manage create and delete of Free FBSlots
* Date:        - Case#/Project:            - Developer/Company                               - Description
* ------------------------------------------------------------------------------------------------------------------------- *
* 11/14/2017   -                      -Akosa Okwudiafor, Deloitte                  - Modified Labels and added comments.
*/
public class TimelotsCreateDelete {
    BusinessHours bh;
    public OrgSettings__c os;
    
    public void TimelotsCreateDelete(){
        
    }
    
    /***************************************************************************************************
* @Description : This function gets the business hours and the settings for the fbslots creation 
* @Param       : NA
* @Return      : void
***************************************************************************************************/
    public void getData(){
        os=TimeSlotsHelper.getFBSlotSettings(os);
        bh =TimeSlotsHelper.getBusinessHours();
    }
    
/***************************************************************************************************
* @Description : This function deletes the old slots.
* @Param       : NA
* @Return      : void
***************************************************************************************************/
    public void deleteOldSlots(Datetime startTime){
        List<Time_Slot__c> slotsInserted; 
        slotsInserted=[Select id from Time_Slot__c where Resource__c=null 
                       and status__c=:Label.St_Free
                       and Start_Time__c<:startTime limit 5000];        
        if(slotsInserted.size()>0){
            delete slotsInserted;
        }        
    }
    
/***************************************************************************************************
* @Description : Creating more slots for the year
* @Param       : NA
* @Return      : void
***************************************************************************************************/
    public void createNewYearSlotFromToday(Integer howManyFutureMonths){
        DateTime startDateTime=os.Date_Slot_Created_Till__c.addDays(-1);
        TimeSlotsHelper.createFreeFBSlots(startDateTime,os,bh,howManyFutureMonths);
    }
    
}