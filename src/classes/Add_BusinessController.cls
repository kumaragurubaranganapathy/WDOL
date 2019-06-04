public class Add_BusinessController {
    
    //get BusinessAccount RecordType Id 
    @AuraEnabled 
    public static id getRecordTypeIdAccount(){
       return Schema.SObjectType.Account.getRecordTypeInfosByName().get('Business Account').getRecordTypeId() ;
    }
    
     @AuraEnabled
    public static List<Account> getAllAccounts(){
        Set<Id> accntIdSet = new Set<Id>();
        List<Account> accList = new List<Account>();
        User currentUser = [SELECT Id, Name,firstName ,lastName, ContactId , IsActive, IsPortalEnabled, MUSW__Successor__c, ProfileId , email from User Where ID = :UserInfo.getUserId() LIMIT 1];
        List<MUSW__Account_Contact__c> accntConList = [SELECT Id,MUSW__Contact__c,MUSW__Account__c,MUSW__Account__r.Name,MUSW__Account__r.Type_of_Ownership__c,
                                                       MUSW__Account__r.Security_Code__c,MUSW__Account__r.First_Name_Primary_Contact__c,MUSW__Account__r.Last_Name_Primary_Contact__c,MUSW__Account__r.Business_Alias__c ,MUSW__Account__r.Doing_Business_As_1__c ,MUSW__Account__r.Website,MUSW__Account__r.Phone_Primary_Contact__c,MUSW__Account__r.Fax,MUSW__Account__r.Email__c,
                                                       MUSW__Account__r.Email_Primary_Contact__c,MUSW__Account__r.FEIN_Number_Encrypted__c,MUSW__Account__r.Social_Security_Number_Encrypted__c,
                                                       MUSW__Account__r.UBI_Number__c,MUSW__Account__r.Extension__c,MUSW__Account__r.Business_Phone__c,Name 
                                                       FROM MUSW__Account_Contact__c WHERE MUSW__Contact__c =: currentUser.ContactId  AND MUSW__Account__c != null and Associate_Status__c = 'Active'] ; 
        for(MUSW__Account_Contact__c accCon : accntConList ){
            accntIdSet.add(accCon.MUSW__Account__c);
        }
        if(accntIdSet!=null && !accntIdSet.isEmpty()){
        accList= [select Id,(select id,isAdminContact__c from MUSW__Account_Contacts__r where MUSW__Contact__c = :currentUser.ContactId and isAdminContact__c =true),
                Name,Type_of_Ownership__c,Doing_Business_As_1__c,First_Name_Primary_Contact__c,Last_Name_Primary_Contact__c,Phone_Primary_Contact__c,
                UBI_Number__c,Email__c,Business_Phone__c,Extension__c,Website 
                from Account where id in:accntIdSet ];
        }
        else{
                        
            
        }
          return accList;
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
            ac.isAdminContact__c = True;
            ac.Role__c = 'Administrator';
            ac.Account_Admin__c = true;
            insert ac;
        }
        
    }
    
    @AuraEnabled
    public static void updateAccount(List<Account> acc ){
        update acc;
    }
    
    @AuraEnabled
    public static List<MUSW__Account_Contact__c> getAllContacts(String accountId){
        List<MUSW__Account_Contact__c> lstContact = new List<MUSW__Account_Contact__c>();
        for(MUSW__Account_Contact__c ac :[SELECT Id,MUSW__Account__r.Name,resend_Invitation__c,isAdminContact__c,First_Name__c,Last_Name__c,Title__c,Role__c,Ownership_Percentage__c,Associate_Status__c FROM MUSW__Account_Contact__c WHERE MUSW__Account__c =: accountId]){
            lstContact.add(ac);
        }
        return lstContact;
    }
    @AuraEnabled
    public static List<MUSW__Account_Contact__c> updateContactAccountStatus(String Id, String status, String accountId) {
       List<MUSW__Account_Contact__c> lstContact = new List<MUSW__Account_Contact__c>();
       for(MUSW__Account_Contact__c ac :[SELECT Id,Associate_Status__c 
                                         FROM MUSW__Account_Contact__c WHERE Id =: Id]){
            ac.Associate_Status__c = status;
            lstContact.add(ac);                                 
        }
        system.debug('updatedList'+lstContact);
        if(!lstContact.isEmpty ()){
            update lstContact;
        }
        lstContact = new List<MUSW__Account_Contact__c>();
         for(MUSW__Account_Contact__c ac :[SELECT MUSW__Account__r.Name,isAdminContact__c,First_Name__c,Last_Name__c,Title__c,Role__c,Ownership_Percentage__c,Associate_Status__c FROM MUSW__Account_Contact__c WHERE MUSW__Account__c =: accountId]){
            lstContact.add(ac);
        }
        return lstContact;
    }
    @AuraEnabled
    public static List<MUSW__Account_Contact__c> resendEmailInvitation (String Id, String accountId) {
        Polaris_UtilityClass appUtility = new  Polaris_UtilityClass();
        List<Messaging.SingleEmailMessage> resendEmailList = new List<Messaging.SingleEmailMessage>();        
        List<MUSW__Account_Contact__c> lstContact = [SELECT Id,Associate_Status__c,Email__c
                                                     FROM MUSW__Account_Contact__c WHERE Id =: Id limit 1];
        Set<String> setEmail = new Set<String>();
        if(!lstContact.isEmpty() && lstContact[0].Email__c != null) {
            lstContact[0].Resend_Invitation_Date__c = system.today();
            Id orgWideEmailAddressId = appUtility.getOrgWideEmailAddressId(System.label.Organization_Wide_EmailAddress);
            EmailTemplate emailTemplate = appUtility.getEmailTemplate('Department of Licensing - Pending request to join a firm');
            String htmlBody = emailTemplate.HtmlValue;
            String htmlSubject = emailTemplate.Subject;
            setEmail.add(lstContact[0].Email__c);
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.templateid=emailTemplate.Id;
            mail.setToAddresses(new List<String>(setEmail));
            mail.setSubject(htmlSubject);
            mail.setHtmlBody(htmlBody);
            mail.setOrgWideEmailAddressId(orgWideEmailAddressId);
            resendEmailList.add(mail);
            update lstContact;
        }
        if(!resendEmailList.isEmpty()){
            Messaging.sendEmail(resendEmailList);
        }
        
        lstContact = new List<MUSW__Account_Contact__c>();
        for(MUSW__Account_Contact__c ac :[SELECT MUSW__Account__r.Name,isAdminContact__c,First_Name__c,Last_Name__c,Title__c,Role__c,Ownership_Percentage__c,Associate_Status__c                                           FROM MUSW__Account_Contact__c WHERE MUSW__Account__c =: accountId]){
            lstContact.add(ac);
        }
        return lstContact; 
        
    }

    
}