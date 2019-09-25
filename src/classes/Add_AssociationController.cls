public with sharing class Add_AssociationController {
    @AuraEnabled
    public static List<MUSW__License2__c> searchForIds(String searchLicense , Id parentLicense) {
        try{
        
        
        //Adding AS PER CRUD SECURITY STANDARDS REPORT;
        List<MUSW__License2__c> results;    
        if (Schema.sObjectType.MUSW__License2__c.isAccessible()){   
        results = [SELECT Id,Name,MUSW__Applicant__c FROM MUSW__License2__c WHERE Name =: searchLicense limit 1];
        }
        
        if(!results.isEmpty()){
            Associations__c assc = new Associations__c();
            /*assc.Name__c = 'Assoc- '+ results[0].Name ;*/         /*cOMMENTED AS PART OF CODE QUALITY FIX*/
            if (Schema.sObjectType.Associations__c.isAccessible() && Schema.sObjectType.Associations__c.fields.Name__c.isCreateable()
            && Schema.sObjectType.Associations__c.fields.Child_Contact__c.isCreateable()
            && Schema.sObjectType.Associations__c.fields.Child_License__c.isCreateable()
            && Schema.sObjectType.Associations__c.fields.Parent_License__c.isCreateable()
            && Schema.sObjectType.Associations__c.fields.Source_Id__c.isCreateable()
            && Schema.sObjectType.Associations__c.fields.Submitted_Date__c.isCreateable())
            {
            assc.Name__c = DOL_AppConstants.PREPEND_ASSOC_NAME+ results[0].Name ;
            assc.Child_Contact__c = results[0].MUSW__Applicant__c;
            assc.Child_License__c = results[0].Id;
            assc.Parent_License__c = parentLicense;
            /*assc.Source_Id__c = 'Assoc- '+ results[0].Name ;*/    /*cOMMENTED AS PART OF CODE QUALITY FIX*/
            assc.Source_Id__c = DOL_AppConstants.PREPEND_ASSOC_NAME+ results[0].Name ;
            assc.Submitted_Date__c = System.today();
            }
            try{
                insert assc ;   
                System.debug('assc::'+assc);
            }catch(Exception e){
                System.debug('exception::'+e);
                DOL_CreateErrorLog_Exception.logApplicationError(e);
                
                throw new AuraHandledException('An error occurred: '+e.getMessage());
            }
        }
        return results;
        }
          catch(Exception ex)
        {
            DOL_CreateErrorLog_Exception.logApplicationError(ex);
            throw new AuraHandledException('An error occurred: '+ex.getMessage());
            
        }
    }
    
    //Method to get All associations realted to license
    @AuraEnabled
     public static List<Associations__c> getAssociations(Id parentId) {
         try{
         List<Associations__c> listAssoc = [select id,Name__c,Child_Contact_Name__c,Child_License_Name__c,Parent_License_Name__c,Submitted_Date__c from Associations__c where Parent_License__c =:parentId];
         System.debug('listAssoc::'+listAssoc);
         return listAssoc;
         }
           catch(Exception ex)
        {
            DOL_CreateErrorLog_Exception.logApplicationError(ex);
            throw new AuraHandledException('An error occurred: '+ex.getMessage());
            //return null;
        }
     }
    
    @AuraEnabled
    public static Boolean deleteAssociations(List<Associations__c> listAssoc){
        try{
        Boolean issuccess = false;
        if(!listAssoc.isEmpty() && Schema.sObjectType.Associations__c.isDeletable()){
            delete listAssoc;
            issuccess = true;
        }
        return issuccess;
        }
          catch(Exception ex)
        {
            DOL_CreateErrorLog_Exception.logApplicationError(ex);
            throw new AuraHandledException('An error occurred: '+ex.getMessage());
            //return null;
        }
    }
    
    
}