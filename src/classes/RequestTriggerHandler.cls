/**
* Name: RequestTriggerHandler
* Type: Class
* Description: Trigger Handler for Renewal_Application__c object being called from RenewalApplicationTrigger
* Date:        Developer/Company                   Description
* ---------------------------------------------------------------------------------------------------------------------------------------- *
*													Initial Creation
* 08/22/2018   Srikanth Kottam/Deloitte          	Apex Sharing
**/
public class RequestTriggerHandler  implements BGCM.ITriggerHandler  {
    public static user u;
    public RequestTriggerHandler() {
        
        u = [Select Id, UserType, Is_Portal_User__c From User where Id = :UserInfo.getUserId()];
    }
    public void onAfterDelete() {}
    public void onAfterInsert() { 
        
    }
    public void onAfterUndelete() {}
    public void onAfterUpdate() {
        System.debug('CancelledSlotModifier');
         CancelledSlotModifier();
         System.debug('CancelledSlotModifier');
    }
    public void onBeforeDelete() {}
    public void onBeforeInsert() {
        
    }
    public void onBeforeUndelete() {}
    public void onBeforeUpdate() {
        System.debug('()()()before update');
        if (u.Is_Portal_User__c != true) {
            updateRequestOwner();
        }
    }
    
    public void updateRequestOwner(){
        List<Request__c> requests =(List<Request__c>)Trigger.new;
        Map<Id,List<Request__c>> rscRequest = new  Map<Id,List<Request__c>>();
        Map<Id,Resource__c> rscMap = new  Map<Id,Resource__c>();
        Map<Id,Resource__c> rswithRequests = new  Map<Id,Resource__c>();
        Map<Id,Request__c> triggerOldMap = (Map<Id,Request__c>)trigger.OldMap;
        List<Time_Slot__c> slotsforupdate= new List<Time_Slot__c> ();
        List<Request__c> Successfulrequestchange= new List<Request__c> ();
        List<MUSW__Review__c> updatereview= new List<MUSW__Review__c> ();
        
        Map<Id,Id> reviewOwnerchange= new  Map<Id,Id>();
        for(Request__c testing : requests){
            if(triggerOldMap.get(testing.id)!=null&&triggerOldMap.get(testing.id).OwnerId!=testing.ownerId&&triggerOldMap.get(testing.id).status__c!=Label.St_Eligible)
            {
                if(rscRequest.containsKey(testing.ownerId))
                {
                    rscRequest.get(testing.ownerId).add(testing);
                }
                else {
                    rscRequest.put(testing.ownerId,new List<Request__C>{testing});
                }
            }
        }
        
        List<Resource__c> resourcesfound= [SELECT  Plan_Review_Types__c, Application_Type__c, Active__c, User__c, Name, Id FROM Resource__c where Active__c=true and User__c=:rscRequest.keySet()]   ; 
        for(Resource__c rsc :resourcesfound)
        {
            rscMap.put(rsc.User__c,rsc);
        }
        
        for(Id req :rscRequest.keySet() )
        {
            List<Request__c> requests2 =rscRequest.get(req);
            
            if(rscRequest.containsKey(req)&&requests2!=null&&rscMap.containskey(req))
            {
                Resource__c rsc =rscMap.get(req);
                rswithRequests.put(req,rsc);               
            }
            else if(requests2!=null)
            {
                for(Request__c reqs: requests2)
                {
                    reqs.addError('The selected Owner is not a valid resource.');
                }
            }
        }
        
        for(Id identification:rswithRequests.keyset())
        {
            //Not bulkified
            Request__C selectedrequest= rscRequest.get(identification)[0];
            DateTime dT =selectedrequest.Start_Time__c ;
            Date myDate = date.newinstance(dT.year(), dT.month(), dT.day());
            Resource__c selectedResource=rswithRequests.get(identification);
            List<time_slot__c> futureFreeSlots =[select Start_Date__c,Start_Time__c,Backend_User__c,Resource__c  from time_slot__c where Resource__c=:selectedResource.id and Status__c=:Label.ST_Available and Start_Time__c >=Today and Start_Date__c =:myDate order by Start_Time__c asc Limit 16];
            Double duration =Double.valueOf(selectedrequest.Duration__c);
            Integer durationinnumber = Integer.valueOf(duration*2);
            if(futureFreeSlots!=null&&futureFreeSlots.size()>=durationinnumber)
            {
                for(Integer i=0;i<durationinnumber;i++)
                { 
                    Time_slot__c timeslot = futureFreeSlots[i];
                    if(i==0)
                    {
                        selectedrequest.Start_Time__c=timeslot.Start_Time__c;
                        selectedrequest.Assigned_Resource__c=timeslot.Resource__c;
                        selectedrequest.OwnerId=timeslot.Backend_User__c;
                        selectedrequest.End_Time__c= selectedrequest.Start_Time__c.addMinutes(Integer.valueOf(duration*60));
                        reviewOwnerchange.put(selectedrequest.Permit_Plan_Review__c,selectedrequest.OwnerId);
                    }
                    timeslot.Request__c=selectedrequest.Id;
                    timeslot.Status__c=Label.St_Busy;                
                    slotsforupdate.add(timeslot);
                    Successfulrequestchange.add(selectedrequest);
                }
            } 
            else{
                selectedrequest.addError('The selected Owner is not available at the day selected');
            }
            
        }
        
        for(Time_slot__c timeslot :[Select id,Status__c,request__c from time_slot__c where request__c=:Successfulrequestchange])
        {
            timeslot.Request__c=null;
            timeslot.Status__c=Label.St_Available;
            slotsforupdate.add(timeslot);
        }
        
        
        
        for(MUSW__Review__c rev : [select id,ownerId,MUSW__Permit2__c  from MUSW__Review__c where MUSW__Permit2__c =:reviewOwnerchange.keyset()])
        {
            rev.OwnerID=reviewOwnerchange.get(rev.MUSW__Permit2__c);
            updatereview.add(rev);
        }
        
        if(slotsforupdate.size()>0)
        {
            update slotsforupdate;
        }
        
        if(updatereview.size()>0)
        {
            update updatereview;
        }
    }
    
    /***************************************************************************************************
* @Description : Change the status of the exams when the request is changed to Cancelled.
* @Param       : NA
* @Return      : void
***************************************************************************************************/      
    public  void CancelledSlotModifier(){ 
        Map<Id,Request__c> newSObj= (Map<Id,Request__c>)Trigger.Newmap;
          Map<Id,Request__c> oldSObj= (Map<Id,Request__c>)Trigger.Oldmap;
        List<Id> cancelledrequests= new  List<Id>();
        System.debug('newSObj.values() '+newSObj.values() );
        for(Request__c request : [select id ,Start_Time__c from Request__c where id in: newSObj.values() and Status__c=:Label.Str_Canceled])
        {
            System.debug(oldSObj.get(request.id).Status__c==Label.St_Scheduled );
            system.debug(oldSObj.get(request.id).Status__c);
            if(oldSObj.get(request.id).Status__c==Label.St_Scheduled){
                cancelledrequests.add(request.id);
            }
        }
        
        SYSTEm.debug('cancelledrequests '+cancelledrequests);
        List<Time_Slot__c > timeSlots = [select id, Resource__c,Request__c, Status__c, Start_Time__c 
                                     from Time_Slot__c 
                                     where Request__c IN:cancelledrequests 
                                      and Status__c=:Label.St_Busy
                                     ORDER BY Start_Time__c];
        
        List<Time_Slot__c > TimeslotsToUpdate = new  List<Time_Slot__c >();
        for(Time_Slot__c timeslot: timeSlots){
                timeslot.Status__c =Label.St_Available; 
                timeslot.Request__c=null;
                TimeslotsToUpdate.add(timeslot);                
        }
        
        if(TimeslotsToUpdate.size()>0){
            List <Database.SaveResult > saveResults = new  List <Database.SaveResult >();
            saveResults=   database.update(TimeslotsToUpdate,false);
            ErrorLogger.logDMLDatabaseResultErrors(UserInfo.getUserId(), null, saveResults, null, 'Sobject','Update records', null,'RequestTriggerHandler',Label.Str_High,'RequestTriggerHandler');
        }
        
    }
}