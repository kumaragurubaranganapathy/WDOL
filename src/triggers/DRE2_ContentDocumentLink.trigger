trigger DRE2_ContentDocumentLink on ContentDocumentLink (after insert, before update, before delete, after undelete) {
    
    public static boolean runonce = false;
    if(Trigger.isAfter &&Trigger.isInsert && runonce == false) {
         system.debug('inside test');
         runonce= true;
        List<MUSW__Submission__c> lstnewAttachment = new List<MUSW__Submission__c>();
        Set<ID> lstdocs = new Set<ID> ();
        for(ContentDocumentLink cd : Trigger.new){
            lstdocs.add(cd.LinkedEntityId);
        }
        if(!lstdocs.isEmpty()) {
            for(MUSW__Submission__c sub : [select id,Public_Disciplinary_Action__c from MUSW__Submission__c where id =:lstdocs and Public_Disciplinary_Action__c = true]) {
                sub.Has_Public_Distribution__c = true;  
                lstnewAttachment.add(sub);
            }    
        }

        if(!lstnewAttachment.isEmpty()){
           update lstnewAttachment;
        }
    }    
    BGCM.TriggerManager.execute('DRE2_ContentDocumentLink', new DRETriggerHandler()); 

}