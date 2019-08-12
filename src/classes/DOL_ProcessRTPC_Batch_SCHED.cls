/**
* User Story: 5228
* Class Name: DOL_ProcessRTPC_Batch
* Test Class Name: ****
* Description: RTPC Batch scheduler 
* Date:        Developer/Company                    Description
* ------------------------------------------------------------------------------------------------*
* 08/2/2019   Laltu Banerjee/Deloitte           Initial Creation
**/
public with sharing class DOL_ProcessRTPC_Batch_SCHED {
    public DOL_ProcessRTPC_Batch_SCHED() {
        if(! Dol_IntegrationUtil.isBatchRunning('DOL_ProcessRTPC_Batch')){
            DOL_ProcessRTPC_Batch batch = new DOL_ProcessRTPC_Batch();
            Database.executeBatch(batch,1);
        }
    }
}