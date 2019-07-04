public without sharing class DeleteAbandonedApplications
{
    @InvocableMethod
    public static void ApplicationDelete(List<Id> ApplicationIds)
    {
        List<MUSW__Application2__c> Applications =[select id from MUSW__Application2__c
                          where (id in :ApplicationIds
                       AND LastModifiedDate >= LAST_N_DAYS:120) AND MUSW__Status__c = 'Abandoned'];
        delete Applications;
   }
}