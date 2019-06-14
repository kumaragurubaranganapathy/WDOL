public class VerifyLicenseDetailCtlr {
    
    public boolean isGuestUserLoggedIn {get;set;}
    public VerifyLicenseCtlr.SearchResult searchResult {get;set;}
    public VerifyLicenseCtlr.SearchFields SearchFields {get;set;}
    public String currentSystemDateTime{get;set;}
    public String SystemNow{get;set;}
    public Boolean isPageValid {get;set;}
    public String recordDetailId {get;set;}
    public String source {get;set;}    
    public String searchType {get;set;}    
    
    /**
* Constructor
* */    
    public VerifyLicenseDetailCtlr(){
        isGuestUserLoggedIn = Utilities.isGuestUserLoggedIn();
        Datetime dateGMT=System.now();
        Datetime d1 = Datetime.valueOf(dateGMT);
        currentSystemDateTime = d1.format('MM/dd/yyyy hh:mm a', 'CST');
        String searchObject = ApexPages.currentPage().getParameters().get('source');
        String recordId = ApexPages.currentPage().getParameters().get('recordId');
        Map<ID, String> answerMap = new Map<ID, String>();
        if(String.isNotBlank(searchObject) && String.isNotBlank(recordId)){
            recordDetailId = recordId;
            source = searchObject;
            String query = getSearchQuery(searchObject, recordId);  
            List<SObject> sobjects = Database.query(query);
            // 
            ID titleID;
            ID ceEligibleLicenseID;
            List<Renewal_Application__c> ceEligibleRenewalList = new List<Renewal_Application__c>();
            for (SObject obj : sobjects) {
                Boolean isCEEligible;
                if(searchObject == label.API_License2){
                    isCEEligible = Boolean.valueOf(obj.get('CE_Eligible__c'));
                    if(isCEEligible){
                        ceEligibleLicenseID = String.valueOf(obj.get('Id'));
                    }
                    if(String.valueOf(obj.get('Credential_Type__c')) == 'Manufactured Homes Titling'){
                        titleID = String.valueOf(obj.get('Id'));
                    }                
                }            
            }
            if(String.isNotBlank(titleID)){
                List<Answer__c> answerList = [Select id, name, License__c, Answer_Text__c from Answer__c 
                                              where License__r.id = :titleID and (External_id_of_Question__c = 'Ex-QUE-MHCOT-5' 
                                                                                  OR External_id_of_Question__c = 'Ex-QUE-MHCOT-SP-2')];
                for(Answer__c answer: answerList){
                    if(answerMap.containsKey(answer.License__c)){
                        String concatenatedAnswer = answerMap.get(answer.License__c) + ', ' +answer.Answer_Text__c;
                        answerMap.put(answer.License__c, concatenatedAnswer);
                    }else{
                        answerMap.put(answer.License__c, answer.Answer_Text__c);
                    }
                }
                //System.debug(answerMap); 
            }           
            
            if(String.isNotBlank(ceEligibleLicenseID)){
                ceEligibleRenewalList = [SELECT license__r.Id, Id, CE_Hours__c
                                         FROM Renewal_Application__c
                                         WHERE license__r.id = :ceEligibleLicenseID
                                         AND Renewal_Status__c = :Label.ST_Submitted];
                
            }
            
            if(sobjects.size() > 0){
                Decimal ceHours = -99996645.23;
                if(ceEligibleRenewalList.size() > 0){
                    for(Renewal_Application__c renewalRecord: ceEligibleRenewalList){
                        System.debug('in for loop for renewalRecord- CE');
                        ceHours = renewalRecord.CE_Hours__c;
                        System.debug('renewal CE Hours '+ ceHours);                        
                    }
                }
                
                searchResult = new VerifyLicenseCtlr.SearchResult(sobjects[0], searchObject, answerMap, ceHours);
            }
        }
        searchType = ApexPages.currentPage().getParameters().get('searchType');
        //Timezone code 
        SystemNow=d1.format('MM/dd/yyyy hh:mm a', 'CST');
    }
    
    /**
* Method to get Search query based on Object API and record Id
* */
    private String getSearchQuery(String searchObject, String recordId){
        String query = VerifyLicenseCtlr.getDefaultSearchFields(searchObject,'Public_Lookup_Fields');
        query += VerifyLicenseCtlr.queryReleationColumns();
        query += 'Id FROM ' +searchObject + ' WHERE Id = \''+recordId+'\''; 
        return query;
    }
}