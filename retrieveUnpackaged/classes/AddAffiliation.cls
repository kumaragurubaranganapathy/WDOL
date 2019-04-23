/** Controller for component - AddAffiliation page
* 
* @author      - Akosa Okwudiafor helps the user add or edit affilations to aparticular license.
* @Reference   - AddAffiliation.vfp
**------------------------------------------------------------------------------------------------------------
** Modification Log:
**------------------
** Developer                 Date              Version     Description
** Akosa Okwudiafor         8/21/2018           1.0         Initial Implementation
**------------------------------------------------------------------------------------------------------------
** Review Log:
**---------------
** Reviewer                  Date           Version               Description
**------------------------------------------------------------------------------------------------------------
***************************************************************************************************************/

public class AddAffiliation {
    // class variables 
    public Boolean isError{get;set;}
    public String errorMessage{get;set;}    
    public Affiliation__c affiliation {get;set;}
    public Affiliation__c newAffiliation {get;set;}
    public MUSW__License2__c credential {get;set;}
    public String credentialId {get;set;}
    public boolean NewAgreement {get;set;}
    public String serviceRequestId {get;set;}
    public String message {get;set;}
    public Id contactId;
    public MUSW__Application2__c serviceRequest{get;set;}
    public String affiliationid {get;set;}
    
    
    /***************************************************************************************************
* @Description : method for adding the new affiliation
* @Param       : NA
* @Return      : void
****************************************************************************************************/
    public AddAffiliation(){       
        try{
            contactId= null;
            affiliationid = ApexPages.currentPage().getParameters().get('affiliationid'); 
            credentialId = ApexPages.currentPage().getParameters().get('credentialId');
            serviceRequestId = ApexPages.currentPage().getParameters().get('servReqId');
            if(affiliationid!=null){
                NewAgreement=false;
            }
            else{
                NewAgreement=true;
            }
            affiliation = new Affiliation__c();
            affiliation.RecordTypeId=Utilities.getRecordTypeForName(Label.API_Affiliation,Label.RT_Delegated_Agent_Affiliation); 
            affiliation.Type__c='Primary Enforcement Contact'; 
            if(String.isNotBlank(credentialId)){
                List<MUSW__license2__c> credentials = [SELECT Id,Credential__c,Name,Application_Type__c,MUSW__Type__c,MUSW__Primary_Licensee__c,MUSW__Applicant__c FROM MUSW__License2__c WHERE Id=:credentialId limit 1];
                if(credentials.size()>0){
                    User user = [SELECT Id, ContactId FROM User WHERE Id = :UserInfo.getUserId()];
                    contactId =  user.ContactId;     
                    credential= credentials[0];
                    if(affiliationid != NULL){
                        affiliation = [SELECT Contact_s_City__c, End_date__c,Contact_s_Last_Name__c, Contact_s_Middle_Name__c,Start_Date__c, Type__c, Status__c, Contact_s_Zip_code__c, Contact_s_state__c, Contact_s_Street_Address__c, Contact_s_Credential_Number__c, 
                                       Contact_s_Email__c, Contact_s_Phone__c, Contact_s_Name__c, Credential__c, Id FROM Affiliation__c
                                       WHERE Id=: affiliationid];
                        newAffiliation= affiliation.clone(false, true, false,false);                                
                    } 
                }
                else{  
                    isError = true;
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Unexpected error occurred while loading the application'));
                    errorMessage = 'Unexpected error occurred while loading the application';
                }
            }            
        }catch(Exception ex){
            isError = true;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Unexpected error occurred '+ex.getMessage()));
            errorMessage = 'Unexpected error occurred '+ex.getMessage();
        }        
    }
    
    /***************************************************************************************************
* @Description : Method to save the affiliation
* @Param       : PageReference
* @Return      : NA
****************************************************************************************************/
    public PageReference SaveAffiliation(){
        PageReference returnPage = null;
        try{ 
            affiliationid = ApexPages.currentPage().getParameters().get('affiliationid');            
            serviceRequest = new MUSW__Application2__c();
            affiliation.application_type__c = credential.application_type__c;
            //serviceRequest.RecordTypeId= Schema.SObjectType.MUSW__Application2__c.getRecordTypeInfosByName().get('Manage Affiliations Service Request').getRecordTypeId();
            if(affiliationid== null||affiliationid== '')
            {               
                affiliation.Status__c=Label.St_Pending;
                affiliation.Credential__c=credential.Id;
                upsert affiliation;
                affiliationid = affiliation.id;
                servicerequest.Credential__c=credential.Credential__c;
                serviceRequest.License__c = credential.Id;
                serviceRequest.application_type__c = credential.application_type__c;
                serviceRequest.MUSW__Applicant__c=contactId;
                serviceRequest.MUSW__Status__c = label.ST_Submitted;
                serviceRequest.Submitted_Date__c = System.today();
                serviceRequest.Affiliation__c= affiliation.id;
                serviceRequest.RecordTypeId=Utilities.getRecordTypeForName(Label.API_Service_Request,'Manage Affiliations'); 
                serviceRequest.Purpose__c='Add';
                serviceRequest.MUSW__Type__c = 'Manage Affiliations';
                upsert serviceRequest;        
            }
            else{         
                serviceRequest.License__c = credential.Id;
                serviceRequest.MUSW__Type__c = 'Manage Affiliations';
                serviceRequest.application_type__c = credential.application_type__c;
                serviceRequest.MUSW__Applicant__c=contactId;
                serviceRequest.MUSW__Status__c = label.ST_Submitted;
                serviceRequest.RecordTypeId= Utilities.getRecordTypeForName(Label.API_Service_Request,'Manage Affiliations'); 
                serviceRequest.Submitted_Date__c = System.today();
                serviceRequest.Affiliation__c= affiliation.id;
                serviceRequest.Purpose__c='Edit';
                upsert serviceRequest;
                newAffiliation.application_type__c = credential.application_type__c;
                newAffiliation.Status__c= label.ST_Pending;        
                newAffiliation.Credential__c=null;
                if(newAffiliation.End_Date__c==affiliation.End_Date__c)
                {
                    newAffiliation.End_Date__c=null;
                }
                else{
                    newAffiliation.End_Date__c=affiliation.End_Date__c;
                }
                if(newAffiliation.Start_Date__c==affiliation.Start_Date__c)
                {
                    newAffiliation.Start_Date__c=null;
                }
                else{
                    newAffiliation.Start_Date__c=affiliation.Start_Date__c;
                }
                if(newAffiliation.Contact_s_Street_Address__c==affiliation.Contact_s_Street_Address__c)
                {
                    newAffiliation.Contact_s_Street_Address__c='';
                }
                else{
                    newAffiliation.Contact_s_Street_Address__c=affiliation.Contact_s_Street_Address__c;
                }
                if(newAffiliation.Contact_s_state__c==affiliation.Contact_s_state__c)
                {
                    newAffiliation.Contact_s_state__c='';
                }
                else{
                    newAffiliation.Contact_s_state__c=affiliation.Contact_s_state__c;
                }
                if(newAffiliation.Contact_s_City__c==affiliation.Contact_s_City__c)
                {
                    newAffiliation.Contact_s_City__c='';
                }
                else{
                    newAffiliation.Contact_s_City__c=affiliation.Contact_s_City__c;
                }
                if(newAffiliation.Contact_s_Zip_code__c==affiliation.Contact_s_Zip_code__c)
                {
                    newAffiliation.Contact_s_Zip_code__c='';
                }
                else{
                    newAffiliation.Contact_s_Zip_code__c=affiliation.Contact_s_Zip_code__c;
                }
                if(newAffiliation.Contact_s_Phone__c==affiliation.Contact_s_Phone__c)
                {
                    newAffiliation.Contact_s_Phone__c=null;
                }
                else{
                    newAffiliation.Contact_s_Phone__c=affiliation.Contact_s_Phone__c;
                }
                if(newAffiliation.Type__c==affiliation.Type__c)
                {
                    newAffiliation.Type__c='';
                }
                else{
                    newAffiliation.Type__c=affiliation.Type__c;
                }
                
                newAffiliation.Service_Request__c=serviceRequest.Id;
                upsert newAffiliation;
            }
            MUSW__Application2__c somesr= [SELECT Id, Application_type__c, Name FROM MUSW__Application2__c where Id=: serviceRequest.Id];    
            returnPage = new PageReference(label.PR_ServiceRequestConfirmation);
            returnPage.getParameters().put('Id',somesr.Name);
            return returnPage ;
        }
        catch(Exception queryEx){
            isError = true;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Unexpected error occurred '+queryEx.getMessage()));
            errorMessage = 'Error in upserting affiliation ==> '+queryEx.getMessage();         
        }
        return returnPage;
    }
    
    
    
}