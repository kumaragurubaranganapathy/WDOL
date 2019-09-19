global class batchRenewalCouponUpdate implements Database.Batchable<sObject> {
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
        String query = 'SELECT id,Print_Renewal_Coupon__c FROM MUSW__License2__c where (Print_Renewal_Coupon__c!=\'Completed\' OR Print_Renewal_Coupon__c!=\'Yes\') AND (Is_Late_Renewal_Eligible__c= true OR Is_Renewal_Eligible__c=true) AND MUSW__Applicant__r.Email=\'\'';       
        system.debug('query :'+query );
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<MUSW__License2__c> scope) {
    system.debug('scope :'+scope);
        for(MUSW__License2__c lic : scope) {
            lic.Print_Renewal_Coupon__c = 'Yes';
        }
        update scope;
    }
    
    global void finish(Database.BatchableContext BC) {
    }
}