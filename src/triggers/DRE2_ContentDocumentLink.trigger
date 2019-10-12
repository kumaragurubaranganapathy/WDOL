trigger DRE2_ContentDocumentLink on ContentDocumentLink (before insert,after insert, before update, before delete, after undelete) {
    
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
        List<ContentDocumentLink> lstContentDocLink = Trigger.new;
        List<ContentDocumentLink> lstNewContentDocLink =  new List<ContentDocumentLink>();
         List<ContentDocumentLink> lstdeleteContDocLink  = [SELECT ContentDocumentId,ContentDocument.Title,Id,IsDeleted,LinkedEntityId,ShareType,SystemModstamp,Visibility FROM ContentDocumentLink WHERE LinkedEntityId IN:lstdocs and LinkedEntityId != null AND ShareType =: DOL_AppConstants.NULL_EMPTY_STRING + 'V' and ShareType != null AND (ContentDocument.Title Like '%License_Certificate%' OR ContentDocument.Title Like '%Self-print_Certificate%' OR ContentDocument.Title LIKE '%Appraiser_Course_Certificate%') and ContentDocument.Title != null];
        for(ContentDocumentLink cd : lstdeleteContDocLink )
        {
            ContentDocumentLink cd1 = new ContentDocumentLink();
            cd1.ContentDocumentId = cd.ContentDocumentId;
            cd1.LinkedEntityId = cd.LinkedEntityId;
            cd1.ShareType = DOL_AppConstants.NULL_EMPTY_STRING + 'I';
            cd1.Visibility = DOL_AppConstants.NULL_EMPTY_STRING + 'AllUsers';
            lstNewContentDocLink.add(cd1);
        }
        if(!lstNewContentDocLink.isEmpty()){
        try{
            delete lstdeleteContDocLink;
           insert lstNewContentDocLink;
           }catch(Exception ex)
        {
            DOL_CreateErrorLog_Exception.logApplicationError(ex);            
        }    
           
        }
    }
    
}