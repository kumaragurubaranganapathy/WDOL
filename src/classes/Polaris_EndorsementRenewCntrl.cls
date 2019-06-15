public class Polaris_EndorsementRenewCntrl {
    
    @AuraEnabled
    public static List<Endorsement__c> fetchEndorsement(String licId)
    {
        Id licenseId = [SELECT id,Application__c FROM MUSW__License2__c WHERE Application__c=: licId].Id;
        List<Endorsement__c> lstEndo = [SELECT id,Date_Requested_for_Adding_Endorsement__c,Endorsement_Type__c,License__c,Status__c FROM Endorsement__c where (Status__c='Active' OR Status__c='In-Review' OR Status__c='Pending Add'OR Status__c='Renew' OR Status__c='Remove') AND License__c =:licenseId ];
        for(Endorsement__c endo : lstEndo)
        {
            //endo.Status__c = 'Renew';
        }
       // update lstEndo;
        return lstEndo;
    }
    
    @AuraEnabled
    public static List<Endorsement__c> changeStatus(String endoId,String Status,String licId)
    {        
        Endorsement__c endo = [SELECT id,Date_Requested_for_Adding_Endorsement__c,Endorsement_Type__c,License__c,Status__c FROM Endorsement__c where  Id =:endoId ];
        endo.Status__c = Status;        
        update endo;
        return fetchEndorsement(licId);
    }
    
}