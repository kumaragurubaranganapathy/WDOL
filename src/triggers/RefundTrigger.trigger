trigger RefundTrigger on BGBK__Refund2__c (before update) {
    Map<Id, BGBK__Refund2__c> rejectedStatements 
        = new Map<Id, BGBK__Refund2__c>{};
            
            for(BGBK__Refund2__c ref: trigger.new)
        {
            /* 
Get the old object record, and check if the approval status 
field has been updated to rejected. If so, put it in a map 
so we only have to use 1 SOQL query to do all checks.
*/
            if (Trigger.oldMap.get(ref.Id).Approval_Status__c != 'Rejected' 
                && ref.Approval_Status__c == 'Rejected' )
            { 
                rejectedStatements.put(ref.Id, ref);  
            }
        }
    
    if (!rejectedStatements.isEmpty())  
    {
        system.debug('rejectedStatements::');
        system.debug(rejectedStatements);
        // UPDATE 2/1/2014: Get the most recent approval process instance for the object.
        // If there are some approvals to be reviewed for approval, then
        // get the most recent process instance for each object.
        List<Id> processInstanceIds = new List<Id>{};
            
            for (BGBK__Refund2__c refs : [SELECT (SELECT ID
                                                      FROM ProcessInstances
                                                      ORDER BY CreatedDate DESC
                                                      LIMIT 1)
                                              FROM BGBK__Refund2__c
                                              WHERE ID IN :rejectedStatements.keySet()])
        {
            processInstanceIds.add(refs.ProcessInstances[0].Id);
        }
        
        system.debug('processInstanceIds::');
        system.debug(processInstanceIds);
        // Now that we have the most recent process instances, we can check
        // the most recent process steps for comments.  
         List<ProcessInstance> piList = [SELECT TargetObjectId,
                                   (SELECT Id, StepStatus, Comments 
                                    FROM Steps
                                    ORDER BY CreatedDate DESC
                                    LIMIT 1 )
                                   FROM ProcessInstance
                                   WHERE Id IN :processInstanceIds
                                   ORDER BY CreatedDate DESC];
        system.debug('piList::');
        system.debug(piList);
        system.debug(piList[0].Steps[0].Comments);
        
        for (ProcessInstance pi : [SELECT TargetObjectId,
                                   (SELECT Id, StepStatus, Comments 
                                    FROM Steps
                                    ORDER BY CreatedDate DESC
                                    LIMIT 1 )
                                   FROM ProcessInstance
                                   WHERE Id IN :processInstanceIds
                                   ORDER BY CreatedDate DESC] )   
        {                   
            if ((pi.Steps[0].Comments == null || 
                 pi.Steps[0].Comments.trim().length() == 0))
            {
                system.debug('pi::');
                system.debug(pi.Steps);
                rejectedStatements.get(pi.TargetObjectId).addError(
                    'Operation Cancelled: Please provide a rejection reason!');
            }
        }  
    }
}