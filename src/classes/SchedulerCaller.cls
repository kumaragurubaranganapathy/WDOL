/*Name: SchedulerCaller
*Description: Abstraction Design pattern implemented to let change already scheduled class


* Date:        - Case#/Project:            - Developer/Company                               - Description
* ------------------------------------------------------------------------------------------------------------------------- *
*
*/
//

global class SchedulerCaller implements  Schedulable 
{
    //Execute auto location renewals
    global void execute(SchedulableContext ctx){    
        TimelotsCreateDelete createDeleteJob=new TimelotsCreateDelete();
        createDeleteJob.getData();
        if(createDeleteJob.os.Date_Slot_Created_Till__c.addMonths(-6)==System.today()){
            createDeleteJob.deleteOldSlots(System.Now().addDays(-2));
            createDeleteJob.createNewYearSlotFromToday(6);
        }
        BatchRecalculateSchedule batchExecution=new BatchRecalculateSchedule();
        ID batchprocessid = Database.executeBatch(batchExecution);
        ModifyTimeResources batchExecution2=new ModifyTimeResources();
        ID batchprocessid2 = Database.executeBatch(batchExecution2);
        
        
    }
    
    
    
}