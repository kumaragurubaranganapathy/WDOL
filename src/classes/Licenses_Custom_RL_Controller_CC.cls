/*************************************************************************************************************
**************************************************************************************************************
** Name                	: Licenses_Custom_RL_Controller_CC
** Description     		: Controller class for Licenses_Custom_Related_List_On_Contact
** Version            	: 1.0
** Built By             : Aishwaria Rangineni
**-----------------------------------------------------------------------------------------------------------------
** Modification Log:
**--------------------------
** Developer                         Date                    Version                      Description
**----------------------------------------------------------------------------------------------------------------
** 
**
** Review Log:
**---------------
** Reviewer                  Date           Version               Description
**---------------------------------------------------------------------------------------------------------------
**
*************************************************************************************************************/
public without sharing class Licenses_Custom_RL_Controller_CC{
    
    //Set up the standard controller connection and get current record 
    ApexPages.StandardController controller;
    public Contact record {get; set;}
    public list<MUSW__License2__c> lstLicense {get; set;}
    public list<MUSW__Permit2__c> lstPlanReviews {get; set;}
    public list<MUSW__Permit2__c> lstPermits {get; set;}
    
    public Licenses_Custom_RL_Controller_CC(ApexPages.StandardController controller){
        this.controller = controller;
        this.record = (Contact)controller.getrecord();
        lstPlanReviews = new  list<MUSW__Permit2__c>();
        lstPermits = new list<MUSW__Permit2__c>();
        
        lstLicense = [Select Id, MUSW__Applicant__c, Name, MUSW__Expiration_Date__c, Credential__c, 
                      MUSW__Status__c, MUSW__Issue_Date__c  
                      From MUSW__License2__c 
                      Where MUSW__Applicant__c =: record.Id 
                      ORDER BY Credential_Type__c DESC NULLS LAST, MUSW__Status__c ASC];  
        
        for(MUSW__Permit2__c permit : [Select Id, MUSW__Applicant__c, Name, Application_Type__c, 
                                       MUSW__Expiration_Date__c, Permit_Type__c, MUSW__Status__c, MUSW__Issue_Date__c 
                                       From MUSW__Permit2__c 
                                       where MUSW__Applicant__c =: record.Id 
                                       ORDER BY MUSW__Expiration_Date__c DESC NULLS FIRST, Permit_Type__c DESC NULLS LAST, MUSW__Status__c ASC
                      				   LIMIT 100]){
            if(permit.Application_Type__c == Label.Str_Permit_to_Operate || permit.Application_Type__c == 'Manufactured Homes Communities'){
                lstPermits.add(permit);
            }else if(permit.Application_Type__c == Label.Str_Plan_Review){
                lstPlanReviews.add(permit);
            }
        } 
    }       
}