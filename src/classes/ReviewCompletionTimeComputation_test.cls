@isTest
public class ReviewCompletionTimeComputation_test {
    @isTest
    public static void testMethod1(){
        
        User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
        system.runAs(thisUser){
            Holiday h = new Holiday();
            h.ActivityDate = system.today()+1;
            h.name = 'test holiday';
            insert h;
        }
        
        Id reviewRT = Schema.SObjectType.MUSW__Review__c.getRecordTypeInfosByName().get('License Review').getRecordTypeId();
        MUSW__Review__c rev = new MUSW__Review__c();
        rev.RecordTypeId = reviewRT;
        rev.Start_Date__c = system.now();
        rev.MUSW__Completed_DateTime__c = system.now()+10;
        insert rev;
        ReviewCompletionTimeComputation rc = new ReviewCompletionTimeComputation();
        
        
        Decimal dec = rc.ReviewCompletionTimeComputation(rev);
        
    }
    
}