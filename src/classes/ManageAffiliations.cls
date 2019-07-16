/*************************************************************************************************************
** Name             : ManageAffiliations
** Description       : This controller controls the ManageAffiliations page, it displays all the 
                      affiliations that are related to a particular credential. 
** Version             : 1.0
** Built By            : Akosa Okwudiafor.
** Reference          : ManageAffiliations.vfp
**------------------------------------------------------------------------------------------------------------
** Modification Log:
**------------------
** Developer                 Date              Version     Description
** Akosa Okwudiafor          8/21/2018         1.0         Initial Implementation
**------------------------------------------------------------------------------------------------------------
** Review Log:
**---------------
** Reviewer                  Date           Version               Description
**------------------------------------------------------------------------------------------------------------
***************************************************************************************************************/
public class ManageAffiliations {
   // Class Variables
    public Boolean isError{get;set;}
    public String errorMessage{get;set;}
    public String credentialNumber {get;set;}
    public String applicationtype {get;set;}
    public List<Affiliation__c> affiliations {get;set;}
    public Id credentialId {get;set;}
    private Id contactId;
    public String deactivateId {get; set;}
    public MUSW__Application2__c serviceRequest{get;set;}
    
    /***************************************************************************************************
     * @Description : Constructor
     * @Param       : NA
     * @Return      : NA
    ***************************************************************************************************/
    public ManageAffiliations(){
        isError = false;
        credentialId = ApexPages.currentPage().getParameters().get('credentialId');
        try{
            if(String.isNotBlank(credentialId)){
                List<MUSW__license2__c> license = [Select Id, Application_Type__c,Name from MUSW__license2__c where Id=:credentialId limit 1];
                User user = [SELECT Id, ContactId FROM User WHERE Id = :UserInfo.getUserId()];
                contactId = user.contactId;
                if(license.size()>0){
                    credentialNumber = license[0].Name;
                    applicationtype = license[0].Application_Type__c;
                    affiliations = [SELECT Service_Request__c, Credential_Name__c,Contact_s_Last_Name__c, Contact_s_Middle_Name__c, Application_Type__c, Contact_s_City__c, End_date__c, Start_Date__c, Type__c, Status__c, Contact_s_Zip_code__c, 
                                    Contact_s_state__c, Contact_s_Credential_Number__c, Contact_s_Street_Address__c, 
                                    Contact_s_Email__c, Credential__c, Contact_s_Name__c, Contact_s_Phone__c, Name, Id FROM Affiliation__c where Credential__c=: credentialId and  RecordType.Name=:Label.RT_Delegated_Agent_Affiliation];
                }
                else{
                    errorMessage = 'Unexpected error occurred ';
                    isError = true;
                }
            }else{
                isError = true;
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Unexpected error occurred while loading the application'));
                errorMessage = 'Unexpected error occurred while loading the application';
            } 
        }catch(Exception ex){
            isError = true;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Unexpected error occurred '+ '' +ex.getMessage()));
            errorMessage = 'Unexpected error occurred ' + '' +ex.getMessage();            
        }
    }
    
     /***************************************************************************************************
     * @Description : Add Business owner Affiliation
     * @Param       : NA
     * @Return      : PageReference
     ***************************************************************************************************/
    public PageReference addAffiliation(){
        return new PageReference('/AddAffiliation?credentialId='+credentialId);
    }
    
         /***************************************************************************************************
     * @Description : Method to deactivate Business owner Affiliations
     * @Param       : 
     * @Return      : PageReference
     ***************************************************************************************************/
    public PageReference deactivateAffiliation(){
        serviceRequest = new MUSW__Application2__c();
        serviceRequest.RecordTypeId= [Select Id from RecordType where DeveloperName =:'Manage_Affiliations' Limit 1][0].Id;
        serviceRequest.License__c = credentialId;
        serviceRequest.Application_type__c = applicationtype;
        serviceRequest.MUSW__Status__c = label.ST_Submitted;
        serviceRequest.MUSW__Applicant__c=contactId;
        serviceRequest.Submitted_Date__c = System.today();
        serviceRequest.Affiliation__c= deactivateId;
        serviceRequest.MUSW__Type__c = label.SR_Manage_Affiliations;
        serviceRequest.Purpose__c= label.Str_Deactivate;
        upsert serviceRequest;
        MUSW__Application2__c somesr= [SELECT Id, Application_type__c, Name FROM MUSW__Application2__c where Id=: serviceRequest.Id];    
        PageReference returnPage = new PageReference('/Dashboard');
        return returnPage ;
    }
     
    @RemoteAction
    public static List<Affiliation__c> findLicenses (String lic) {
        List<Affiliation__c> newaffiliations = [SELECT Service_Request__c,Contact_s_Last_Name__c, Contact_s_Middle_Name__c, Credential_Name__c, Application_Type__c, Contact_s_City__c, End_date__c, Start_Date__c, Type__c, Status__c, 
                                                Contact_s_Zip_code__c, Contact_s_state__c, Contact_s_Credential_Number__c, Contact_s_Street_Address__c, Contact_s_Email__c, 
                                                Credential__c, Contact_s_Name__c, Contact_s_Phone__c, Name, Id FROM Affiliation__c where Credential__c=: lic  and  RecordType.Name=:Label.RT_Delegated_Agent_Affiliation];
        return newaffiliations;
    }
}