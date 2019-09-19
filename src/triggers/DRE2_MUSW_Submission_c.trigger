trigger DRE2_MUSW_Submission_c on MUSW__Submission__c (after insert, before update, before delete, after undelete, after update) { 
    
    Global_Settings__c gs = Global_Settings__c.getInstance(UserInfo.getUserId());
    if(gs.Disable_Triggers__c == true){
        return;
    }
    public static boolean runonce = false;
    if(Trigger.isbefore &&Trigger.isUpdate && runonce == false){
        runonce= true;
        List<MUSW__Submission__c> lstnewAttachment = new List<MUSW__Submission__c>() ;
        Set<Id> setDoc = new Set<ID>();
        for(MUSW__Submission__c newSub :Trigger.new) {
            if(newSub.Public_Disciplinary_Action__c  == true) {
                setDoc.add(newSub.Id);
                lstnewAttachment.add(newSub);
            }
        }
        Set<ID> lstdoc= new Set<ID>();
        Map<String,String> mapDoc = new Map<String,String>();
        if(!lstnewAttachment.isEmpty()) {
            for(ContentDocumentLink ctlink: [select LinkedEntityId,contentDocumentID from ContentDocumentLink where LinkedEntityId =:setDoc]) {
                lstdoc.add(ctlink.contentDocumentID);
                mapDoc.put(ctlink.contentDocumentID,ctlink.LinkedEntityId);
            }
        }
        List<contentversion> contd = new List<contentversion>();
        if(!lstdoc.isEmpty()) {
             contd= [select id from contentversion where  contentDocumentID =:lstdoc ];
        }
        List<ContentDistribution> lstContentDistribution = new List<ContentDistribution>();
        if(!contd.isEmpty()){
            for(contentversion abc : contd) {
                ContentDistribution cdl = new ContentDistribution();
                cdl.ContentVersionId = abc.Id;
                cdl.Name = DOL_AppConstants.NULL_EMPTY_STRING + 'PublicShare';
                lstContentDistribution.add(cdl);
            }
        }
        if(!lstContentDistribution.isEmpty()) {
            insert lstContentDistribution;
            system.debug('lstContentDistribution'+lstContentDistribution[0].iD);
            lstContentDistribution =  [ SELECT ContentDocumentId, DistributionPublicUrl, Id FROM ContentDistribution where ContentDocumentId =: lstdoc];
        }
        for(String abc : mapDoc.keySet()) {
            for(ContentDistribution cd : lstContentDistribution) {
                if(abc == cd.ContentDocumentId ) {
                    for(MUSW__Submission__c sub : lstnewAttachment){
                        if(sub.id == mapDoc.get(abc)) {
                           sub.Public_Distribution_URL__c = cd.DistributionPublicUrl; 
                        }
                    }
                }
            }
        }       
    }
    
    BGCM.TriggerManager.execute('DRE2_MUSW_Submission_c', new DRETriggerHandler()); 

}
