/*************************************************************************************************************
** User Story: 
**************************************************************************************************************
** Name                : 
** Description         : Controller class for ApplicationHistory page 
** Version             : 1.0
** Built By            : 
**------------------------------------------------------------------------------------------------------------
** Modification Log:
**------------------
** Developer                         Date                    Version                      Description
**------------------------------------------------------------------------------------------------------------
**                                 1.0                       Controller class for ApplicationHistory page
** Review Log:
**---------------
** Reviewer                  Date           Version               Description
**------------------------------------------------------------------------------------------------------------
**
************************************************************************************/
public with sharing class ApplicationHistory {  
    // Global variables
    public List<MUSW__License2__c> licenseList{get; set;}
    public List<MUSW__Permit2__c> permitList{get; set;}
    public List<Renewal_Application__c> renewalList;
    public List<MUSW__Application2__c> serviceList;
    public List<Renewal_Application__c> reinstatementList;
    public List<MUSW__Application2__c> serviceRequests {get; set;}
    public List<BGBK__Payment__c> paymentHistoryList {get; set;}
    public List<BGBK__Payment__c> paymentHistoryRenewalList {get; set;}
    public List<BGBK__Payment__c> serviceHistoryRenewalList {get; set;}
    public List<MUSW__Fee_Payment__c> feePayment {get; set;}
    public List<PaymentRecord> PaymentRecords {get;set;}
    public List<String> tableHeaderList {get; set;}
    
    /**
* Constructor
*/
    
    /***************************************************************************************************
* @Description : This is the constructor for the ApplicationHistory
* @Param       : null
* @Return      : 
****************************************************************************************************/ 
    public ApplicationHistory() {
        // List of all contacts
        Set<Id> contactIds = getContactIds();
        // Get list of licenses
        Set<Id> accountIds = getAccountIds();
        getPaymentDetails(contactIds,accountIds);
        // Get list of service requests
        getServiceRequests(contactIds);     
    }
    
    
    /***************************************************************************************************
* @Description :  Gets all contact Ids associated with current user
* @Param       : null
* @Return      : Set<Id> 
****************************************************************************************************/
    public Set<Id> getContactIds() {
        
        // Create set of Ids
        Set<Id> contactIds = new Set<Id>();
        Set<Id> accountIds = new Set<Id>();
        Id contactId = [Select contactId from user where id =: UserInfo.getUserId()].contactId;
        contactIds.add(contactId);
        // Get accounts
        try {
            List<MUSW__Account_Contact__c> accountList = [SELECT Id, MUSW__Account__c, MUSW__Account__r.Name FROM MUSW__Account_Contact__c WHERE MUSW__Contact__c = :contactId];
            system.debug('accountList:'+accountList);
            for(MUSW__Account_Contact__c ac : accountList) {
                accountIds.add(ac.MUSW__Account__c);
            }
            accountList = [SELECT MUSW__Contact__c FROM MUSW__Account_Contact__c WHERE MUSW__Account__c IN :accountIds];
            for(MUSW__Account_Contact__c ac : accountList) {
                contactIds.add(ac.MUSW__Contact__c);
            }
        }
        catch(Exception e) {
            System.debug(e);
             ErrorLogger.logGeneralException(e, UserInfo.getUserId(), 'ApplicationHistory', 'Retrieve Records', 'customSave', 'ApplicationHistory', label.Str_Low);
        }
        return contactIds;
    }
    
    public Set<Id> getAccountIds(){
         Set<Id> accountIds = new Set<Id>();
         Id contactId = [Select contactId from user where id =: UserInfo.getUserId()].contactId;
           List<MUSW__Account_Contact__c> accountList = [SELECT Id, MUSW__Account__c, MUSW__Account__r.Name FROM MUSW__Account_Contact__c WHERE MUSW__Contact__c = :contactId];
            for(MUSW__Account_Contact__c ac : accountList) {
                accountIds.add(ac.MUSW__Account__c);
            }
          return accountIds;
    }    
    
    /***************************************************************************************************
* @Description : Gets payment details
* @Param       : Set<Id>
* @Return      : void 
****************************************************************************************************/
    public void getPaymentDetails(Set<Id> contactIds,Set<Id> accountList) {        
        try{
            Map<Id, MUSW__License2__c> licenses = new Map<Id, MUSW__License2__c>([SELECT Id, Name, MUSW__Status__c, MUSW__Issue_Date__c, Credential_Type__c, Credential__c, Sub_Status__c,MUSW__Expiration_Date__c FROM MUSW__License2__c WHERE MUSW__Applicant__c IN :contactIds LIMIT 1000]);
            Map<Id, MUSW__Permit2__c> permits=new Map<Id, MUSW__Permit2__c>([SELECT Id,MUSW__Status__c, Sub_Status__c, Permit_Type__c, Program_Area__c, App_Submitted_Date__c,MUSW__Issue_Date__c,MUSW__Expiration_Date__c, Name FROM MUSW__Permit2__c WHERE  MUSW__Applicant__c IN :contactIds or MUSW__Account__c IN : accountList LIMIT 1000]);
            Map<Id, Renewal_Application__c> Renewals = new Map<Id,Renewal_Application__c>([Select Id from Renewal_Application__c where License__c IN: licenses.keySet() OR permit__c IN: permits.keySet()]);
            Map<Id, MUSW__Application2__c> ServiceRequests = new Map<Id, MUSW__Application2__c>([Select Id from MUSW__Application2__c where License__c IN: licenses.keySet() OR permit__c IN: permits.keySet()]);
            User currentUser = [Select Id, ContactId from User where ID =: Userinfo.getUserId()];
            Map<Id, BGBK__Payment__c> paymentList = new Map<Id, BGBK__Payment__c>([Select Id from BGBK__Payment__c Where
                                                                                   BGBK__License2__c IN:  licenses.keySet() OR 
                                                                                   BGBK__Permit2__c IN:  permits.keySet() OR 
                                                                                   Renewal_Application__c IN: Renewals.keySet() OR 
                                                                                   BGBK__Application2__c IN: ServiceRequests.keySet() 
                                                                                  ]);
            
            // Get fee payment junction records list
            feePayment = [SELECT Id, Name, BGBK__Payment__c, MUSW__Payment_Amount__c, MUSW__Paid_Date__c, 
                          Fee_Type__c, MUSW__Fee_Amount__c, MUSW__Receipt__c, MUSW__Receipt__r.Name, BGBK__Payment__r.Name,
                          Application_Type__c, Paid_By__c, MUSW__Fee__r.MUSW__License2__c,MUSW__Fee__r.MUSW__License2__r.Name,MUSW__Fee__r.MUSW__License2__r.Licensee_Name__c,
                          MUSW__Fee__r.Renewal_Application__c ,MUSW__Fee__r.Renewal_Application__r.Permit__c,
                          MUSW__Fee__r.Renewal_Application__r.License__r.Name,MUSW__Fee__r.Renewal_Application__r.License__r.Licensee_Name__c,
                          MUSW__Fee__r.Renewal_Application__r.license__c ,MUSW__Fee__r.Renewal_Application__r.Permit__r.Name,
                          MUSW__Fee__r.Renewal_Application__r.Permit__r.Licensee_Name__c,
                          MUSW__Fee__r.MUSW__Permit2__c ,MUSW__Fee__r.MUSW__Permit2__r.Name,MUSW__Fee__r.MUSW__Permit2__r.Licensee_Name__c,
                          MUSW__Fee__r.MUSW__Application2__r.license__c,MUSW__Fee__r.MUSW__Application2__r.license__r.Name,
                          MUSW__Fee__r.MUSW__Application2__r.license__r.Licensee_Name__c,
                          MUSW__Fee__r.MUSW__Application2__c ,MUSW__Fee__r.MUSW__Application2__r.Permit__c,
                          MUSW__Fee__r.MUSW__Application2__r.Permit__r.Name,MUSW__Fee__r.MUSW__Application2__r.Permit__r.Licensee_Name__c,
                          MUSW__Fee__r.Name, MUSW__Fee__r.BGBK__Cart__c
                          FROM MUSW__Fee_Payment__c
                          WHERE BGBK__Payment__c IN :paymentList.keySet()];
            
            createPaymentRecords();
            
            licenseList= licenses.values();
            permitList=permits.values();
        }
        catch(Exception ex){
                         ErrorLogger.logGeneralException(ex, UserInfo.getUserId(), 'ApplicationHistory', 'Retrieve Records', 'customSave', 'ApplicationHistory', label.Str_Low);
            feePayment = new List<MUSW__Fee_Payment__c>();
        }
    }
    
    
    
    /***************************************************************************************************
* @Description : Gets service request records
* @Param       : Set<Id>
* @Return      : void 
****************************************************************************************************/
    public void getServiceRequests(Set<Id> contactIds) {
        
        serviceRequests = [SELECT Id, Name, MUSW__Applicant__c, Application_Type__c, MUSW__Status__c, Submitted_Date__c, license__c,
                           MUSW__Type__c, license__r.Name, license__r.Licensee_Name__c,Permit__C,Permit__r.Name,Permit__r.Licensee_Name__c
                           FROM MUSW__Application2__c
                           WHERE MUSW__Applicant__c IN :contactIds]; 
    }
    
    public Class PaymentRecord {
        public String PaymentNumber {get;set;}
        public String Applicationtype {get;set;}
        public String LicenseNumber {get;set;}
        public String Applicant {get;set;}
        public String FeeType {get;set;}
        public String FeeAmount {get;set;}
        public String PaymentAmount {get;set;}
        public String PaidDate {get;set;}
        public String PaidBy {get;set;}
        public String ReceiptNumber {get;set;}
        public String ReceiptId {get;set;}
        public String CartId {get;set;}
    }
    
    /***************************************************************************************************
* @Description : Create Payment Records.
* @Param       : void
* @Return      : void 
****************************************************************************************************/
    public void createPaymentRecords(){
        PaymentRecords = new List<PaymentRecord>();
        PaymentRecord payment = new PaymentRecord();
        for(MUSW__Fee_Payment__c fp: feePayment){
            payment = new PaymentRecord();
            payment.PaymentNumber = fp.Name;
            payment.applicationtype = fp.Application_Type__c ;
            payment.FeeType  = fp.Fee_Type__c;
            payment.FeeAmount = fp.MUSW__Fee_Amount__c+'';
            payment.PaymentAmount = fp.MUSW__Payment_Amount__c+'';
            payment.PaidDate = fp.MUSW__Paid_Date__c.format();
            payment.PaidBy = fp.Paid_By__c;
            payment.ReceiptNumber = fp.MUSW__Receipt__r.Name;
            payment.ReceiptId = fp.MUSW__Receipt__c;
            payment.CartId = fp.MUSW__Fee__r.BGBK__Cart__c;
            
            //License Application Payment
            if(fp.MUSW__Fee__r.MUSW__License2__c != null){
                payment.LicenseNumber = fp.MUSW__Fee__r.MUSW__License2__r.Name;
                payment.Applicant = fp.MUSW__Fee__r.MUSW__License2__r.Licensee_Name__c;
            }
            //License Renewal/Reinstatement Payment
            else if(fp.MUSW__Fee__r.Renewal_Application__c != null && fp.MUSW__Fee__r.Renewal_Application__r.Permit__c  == null){
                payment.LicenseNumber = fp.MUSW__Fee__r.Renewal_Application__r.License__r.Name;
                payment.Applicant = fp.MUSW__Fee__r.Renewal_Application__r.License__r.Licensee_Name__c;
            }            
            //Permit Application payment
            else if(fp.MUSW__Fee__r.MUSW__Permit2__c != null){
                payment.LicenseNumber = fp.MUSW__Fee__r.MUSW__Permit2__r.Name;
                payment.Applicant = fp.MUSW__Fee__r.MUSW__Permit2__r.Licensee_Name__c;
            }            
            //Permit Renewal/Reinstatement Payment
            else if(fp.MUSW__Fee__r.Renewal_Application__c != null && fp.MUSW__Fee__r.Renewal_Application__r.Permit__c  != null){
                payment.LicenseNumber = fp.MUSW__Fee__r.Renewal_Application__r.Permit__r.Name;
                payment.Applicant = fp.MUSW__Fee__r.Renewal_Application__r.Permit__r.Licensee_Name__c;
            }             
            //Service Request Payment
            else if(fp.MUSW__Fee__r.MUSW__Application2__c != null&&fp.MUSW__Fee__r.MUSW__Application2__r.license__c!=null){
                payment.LicenseNumber = fp.MUSW__Fee__r.MUSW__Application2__r.license__r.Name;
                payment.Applicant = fp.MUSW__Fee__r.MUSW__Application2__r.license__r.Licensee_Name__c;
            } 
            else if(fp.MUSW__Fee__r.MUSW__Application2__c != null&&fp.MUSW__Fee__r.MUSW__Application2__r.Permit__c!=null){
                payment.LicenseNumber = fp.MUSW__Fee__r.MUSW__Application2__r.Permit__r.Name;
                payment.Applicant = fp.MUSW__Fee__r.MUSW__Application2__r.Permit__r.Licensee_Name__c;
            } 
            PaymentRecords.add(payment);            
        }
    }
}