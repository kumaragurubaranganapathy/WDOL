public class Polaris_EndorsementRenewCntrl {
    
    @AuraEnabled
    public static List<Endorsement__c> fetchEndorsement(String licId)
    {
        try{
        Id licenseId = [SELECT id,Application__c FROM MUSW__License2__c WHERE Application__c=: licId].Id;
        List<Endorsement__c> lstEndo = [SELECT id,Date_Requested_for_Adding_Endorsement__c,License_Type__c,Endorsement_Type__c,License__c,Status__c FROM Endorsement__c where (Status__c='Active' OR Status__c='In-Review' OR Status__c='Pending Add'OR Status__c='Renew' OR Status__c='Remove') AND License__c =:licenseId ];
        for(Endorsement__c endo : [SELECT id,Date_Requested_for_Adding_Endorsement__c,License_Type__c,Endorsement_Type__c,License__c,Status__c FROM Endorsement__c where (Status__c='Active' OR Status__c='In-Review' OR Status__c='Pending Add'OR Status__c='Renew' OR Status__c='Remove') AND License__c =:licenseId ])
        {
            //endo.Status__c = 'Renew';
        }
       // update lstEndo;
        return lstEndo;
        }catch(Exception ex)
        {
            DOL_CreateErrorLog_Exception.logApplicationError(ex);
            throw new AuraHandledException('An error occurred: '+ex.getMessage());
        }
    }
    
    @AuraEnabled
    public static List<Electronic_Notary_Provider_Information__c> fetchProvider(String endoId)
    {
        try{
        return [SELECT id,Description__c,Effective_Date__c,Provider_Name__c FROM Electronic_Notary_Provider_Information__c where Endorsement__c =:endoId ];
        }catch(Exception ex)
        {
            DOL_CreateErrorLog_Exception.logApplicationError(ex);
            throw new AuraHandledException('An error occurred: '+ex.getMessage());
        }
            
    }
    
    @AuraEnabled
    public static Void removeProvider(String providerId)
    {
       try{
       Electronic_Notary_Provider_Information__c prov = [SELECT id,Description__c,Effective_Date__c,Provider_Name__c FROM Electronic_Notary_Provider_Information__c where Id =:providerId ];
    	delete prov;
       }catch(Exception ex)
        {
            DOL_CreateErrorLog_Exception.logApplicationError(ex);
            throw new AuraHandledException('An error occurred: '+ex.getMessage());
        }
    }
    
    @AuraEnabled
    public static List<Endorsement__c> changeStatus(String endoId,String Status,String licId)
    {        
        try{
        Endorsement__c endo = [SELECT id,Date_Requested_for_Adding_Endorsement__c,Endorsement_Type__c,License__c,Status__c FROM Endorsement__c where  Id =:endoId ];
        endo.Status__c = Status;        
        update endo;
        return fetchEndorsement(licId);
        }catch(Exception ex)
        {
            DOL_CreateErrorLog_Exception.logApplicationError(ex);
            throw new AuraHandledException('An error occurred: '+ex.getMessage());
        }
    }
    
}