/*Name: Event_LocationAvalDateChange
*Description: This trigger handles location availablity if Date change on Location Availability 
* Date:        - Case#/Project:            - Developer/Company                               - Description
* ------------------------------------------------------------------------------------------------------------------------- *
* 11/7/2017   -                      - Okwudiafor Akosa, Deloitte                  - Initial Implementation.
*/

/***************************************************************************************************
* @Description : For an update of the Resource_Location_Avalability__c record clear the old fbslots.
* @Param       : Set<ID>
* @Return      : void
***************************************************************************************************/
trigger manageResourceWeekAvailability on Resource_Week_Availability__c ( after update,after insert){
    Boolean isTriggerDisabled = false;
    Global_Settings__c settings = Global_Settings__c.getInstance(UserInfo.getUserId());
    if (settings != null) {
        isTriggerDisabled = settings.Disable_Triggers__c;
    }
    
    if (!isTriggerDisabled) {
        if(Trigger.isInsert&&trigger.isafter)
        {
            List<Resource_Week_Availability__c> rlaRecords=new List<Resource_Week_Availability__c>();    
            for(Resource_Week_Availability__c rla:Trigger.new){
                rlaRecords.add(rla);
            }
            TimeSlotsHelper.createAllDayMon_to_Fri(rlaRecords);
        }
        if(Trigger.isUpdate&&trigger.isafter){
            List<Resource_Week_Availability__c> rlaRecords=new List<Resource_Week_Availability__c>();
            Set<ID> deleteLocationBusy=new Set<ID>();
            for(Resource_Week_Availability__c rla:Trigger.new){
                    if(rla.Schedule_Valid_till__c!=Trigger.oldMap.get(rla.id).Schedule_Valid_till__c
                       ||rla.Schedule_Valid_From__c!=Trigger.oldMap.get(rla.id).Schedule_Valid_From__c){
                           rlaRecords.add(rla);
                           deleteLocationBusy.add(rla.resource__c);
                       }
            }
            if(rlaRecords.size()>0){
                ManageLocationAvailability.removeAvaliblityOfResourcesBatch(deleteLocationBusy);
                ManageLocationAvailability.blockAvaliblityOfResourcesBatch(rlaRecords);
            }
        }
        
    }
}