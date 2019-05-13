public class Add_BusinessController {
	
    //get BusinessAccount RecordType Id 
    @AuraEnabled 
    public static id getRecordTypeIdAccount(){
       return Schema.SObjectType.Account.getRecordTypeInfosByName().get('Business Account').getRecordTypeId() ;
    }
    
     @AuraEnabled
    public static List<Account> getAllAccounts(){
        Set<Id> accntIdSet = new Set<Id>();
        User currentUser = [SELECT Id, Name,firstName ,lastName, ContactId , IsActive, IsPortalEnabled, MUSW__Successor__c, ProfileId , email from User Where ID = :UserInfo.getUserId() LIMIT 1];
        List<MUSW__Account_Contact__c> accntConList = [SELECT Id,MUSW__Contact__c,MUSW__Account__c,MUSW__Account__r.Name,MUSW__Account__r.Type_of_Ownership__c,MUSW__Account__r.Security_Code__c,MUSW__Account__r.First_Name_Primary_Contact__c,MUSW__Account__r.Last_Name_Primary_Contact__c,MUSW__Account__r.Business_Alias__c ,MUSW__Account__r.Doing_Business_As_1__c ,MUSW__Account__r.Website,MUSW__Account__r.Phone_Primary_Contact__c,MUSW__Account__r.Fax,MUSW__Account__r.Email__c,MUSW__Account__r.Email_Primary_Contact__c,MUSW__Account__r.FEIN_Number_Encrypted__c,MUSW__Account__r.Social_Security_Number_Encrypted__c,MUSW__Account__r.UBI_Number__c,MUSW__Account__r.Extension__c,MUSW__Account__r.Business_Phone__c,Name FROM MUSW__Account_Contact__c WHERE MUSW__Contact__c =: currentUser.ContactId  AND MUSW__Account__c != null and Associate_Status__c = 'Active'] ; 
        for(MUSW__Account_Contact__c accCon : accntConList ){
            accntIdSet.add(accCon.MUSW__Account__c);
        }
        return [select Id,Name,Type_of_Ownership__c,Doing_Business_As_1__c,First_Name_Primary_Contact__c,Last_Name_Primary_Contact__c,Phone_Primary_Contact__c,UBI_Number__c,Email__c,Business_Phone__c,Extension__c,Website from Account where id in:accntIdSet ];
    }
    
    @AuraEnabled
    public static void createAccountContactObject(String aId){
        System.debug('inside createAccount::');
        MUSW__Account_Contact__c retRes ;
         User currentUser = [SELECT Id,ContactId , email from User Where ID = :UserInfo.getUserId() LIMIT 1];
        list<MUSW__Account_Contact__c> businessList = new list<MUSW__Account_Contact__c>([SELECT Id, MUSW__Contact__c, MUSW__Account__r.Name, MUSW__Account__r.BillingStreet, MUSW__Account__r.BillingCity, MUSW__Account__r.BillingState, MUSW__Account__r.BillingPostalCode, MUSW__Account__r.BillingCountry FROM MUSW__Account_Contact__c WHERE MUSW__Contact__c =: currentUser.ContactId AND MUSW__Account__c =: aId ]);
        if(businessList.size()==0){
            MUSW__Account_Contact__c ac = new MUSW__Account_Contact__c();
            ac.MUSW__Account__c = aId;
            ac.MUSW__Contact__c = currentUser.ContactId;
            ac.Associate_Status__c = 'Active' ;
            insert ac;
        }
        
    }
    
    @AuraEnabled
    public static void updateAccount(List<Account> acc ){
        update acc;
    }
    
}