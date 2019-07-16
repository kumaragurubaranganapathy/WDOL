/*Name: manageResourceAvailability
*Description: This trigger handles location availablity if Date change on Location Availability 
* Date:        - Case#/Project:            - Developer/Company                               - Description
* ------------------------------------------------------------------------------------------------------------------------- *
* 11/7/2017   -                      - Okwudiafor Akosa, Deloitte                  - Initial Implementation.
*/

/***************************************************************************************************
* @Description : For an update of the Resource_Group_Avalability__c record clear the old fbslots.
* @Param       : Set<ID>
* @Return      : void
***************************************************************************************************/
trigger manageResourceAvailability on Resource_Availability__c (after insert,after update,before update,before delete){
    MAP<ID,List<Resource_Availability__c>> LocationIDlocAvailMap=new MAP<ID,List<Resource_Availability__c>>();
    Set<ID> deleteLocationBusy=new Set<ID>();
    Set<ID> RlaID=new Set<ID>();
    if(Trigger.isInsert){
        for(Resource_Availability__c loc:Trigger.new){            
            List<Resource_Availability__c> locAvailList=new List<Resource_Availability__c>();
            if(LocationIDlocAvailMap.containsKey(loc.Resource__c))
                locAvailList=LocationIDlocAvailMap.get(loc.Resource__c);
            locAvailList.add(loc);
            LocationIDlocAvailMap.put(loc.Resource__c, locAvailList);
        }
    }else if(Trigger.isUpdate){
        for(Resource_Availability__c loc:Trigger.new){
            if(loc.New_Time_Availability__c==Trigger.oldMap.get(loc.id).New_Time_Availability__c&&loc.New_Availability_Start_Date__c==Trigger.oldMap.get(loc.id).New_Availability_Start_Date__c){
                deletelocationBusy.add(loc.Resource__c);
                if(loc.Time_Availability__c!=Trigger.oldMap.get(loc.id).Time_Availability__c ){                    
                    RlaID.add(loc.Resource_Week_Availability__c);
                }
                
            }
            
        }
        if(trigger.isbefore){
            for(Resource_Availability__c loc:Trigger.new){
                if(loc.New_Time_Availability__c!=Trigger.oldMap.get(loc.id).New_Time_Availability__c&&loc.New_Time_Availability__c!=null)
                {
                    loc.New_Availability_Start_Date__c=System.today().addDays(121);
                }
            }
        }
    }
    if(deletelocationBusy.size()>0)//for update
    {
        ManageLocationAvailability.freeblockedAvaliblityOfLocation(deletelocationBusy);
    }
    if(LocationIDlocAvailMap.size()>0)//for insert
    {
        System.debug('LocationIDlocAvailMap'+ LocationIDlocAvailMap);
        ManageLocationAvailability.blockAvaliblityOfResources(LocationIDlocAvailMap);
    }
    if(RlaID.size()>0)//for update 
    {
        ManageLocationAvailability.blockAvaliblityOfResourcesUpdate(RlaID);
    }
}