public without sharing class DeleteAbandonedApplications
{
    @InvocableMethod
    public static void ApplicationDelete(List<Id> ApplicationIds)
    {
        Date deletedRecordLastModified = Date.today().addDays(-120);
        Datetime deletedRecordLastModifiedDateTime = datetime.newInstance(deletedRecordLastModified.year(), deletedRecordLastModified.month(),deletedRecordLastModified.day());
        List<MUSW__Application2__c> Applications =[select id,LastModifiedDate  from MUSW__Application2__c
                          where (id in :ApplicationIds
                       AND LastModifiedDate <= :deletedRecordLastModifiedDateTime) AND MUSW__Status__c = 'Abandoned'];
        delete Applications;
   }
}