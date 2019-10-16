/**
 * User Story: 1315
 * Name: DOL_Batch_ApplictionsStatusUpdateScheduler
 * Type: Class
 * Description: Scheduler class to run the batch class to convert draft applications to abandoned applications and delete old abandoned applications.
 * Date:        - Case#/Project:            - Developer/Company                         - Description
 * ------------------------------------------------------------------------------------------------------------------------- *
 * 07/16/2019   Swapna Satapathy/Deloitte           Initial Creation 
 */
 
 global class DOL_Batch_ApplictionsStatusScheduler implements Schedulable {
  
  global void execute (SchedulableContext sc){
   DOL_Batch_ApplictionsStatusUpdate autoCloseApplicationBatch = new DOL_Batch_ApplictionsStatusUpdate();
   
   try{
     database.executebatch(autoCloseApplicationBatch);
   }
   catch (Exception e){
     //System.debug('Scheduler Exception');
     DOL_CreateErrorLog_Exception.logApplicationError(e);
   }
  }
  
 }