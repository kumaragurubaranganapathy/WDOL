/*************************************************************************************************************
** User Story: 282 -- Adding Alerts to a Credential/Plan Review/PTO
**************************************************************************************************************
** Class Name    : FlagPermit_CC
** Description   : Controller for Permit Related List (Associate Flag)
** Version       : 1.0
** Built By      : Srikanth Kottam
**------------------------------------------------------------------------------------------------------------
** Modification Log:
**------------------
** Developer                         Date                    Version                      Description
**------------------------------------------------------------------------------------------------------------
** Srikanth Kottam                07/20/2018                    1                          Created
** 
** Review Log:
**---------------
** Reviewer                  Date           Version               Description
**------------------------------------------------------------------------------------------------------------
**
**  **********************************************************************************/
public class FlagPermit_CC {
    ApexPages.StandardController controller;
    public MUSW__Permit2__c record {get; set;}
    public list<Associate_Flag__c> lstFlag {get; set;}
    public String flagObjectPrefix;
    public String permitFieldId;
    public Boolean isContactOnHold {get; set;}
    
    public FlagPermit_CC(ApexPages.StandardController controller){
        this.controller = controller;
        this.record = (MUSW__Permit2__c)controller.getrecord();
        
        lstFlag = [SELECT Id, Name, Flag__c, Description__c, Severity__c, Effective_Date__c, End_Date__c FROM Associate_Flag__c  WHERE PTO_Plan_Review__c =: record.id];  
        flagObjectPrefix = Schema.getGlobalDescribe().get('Associate_Flag__c').getDescribe().getKeyPrefix();
        List<Name_Value_Pair__mdt> lstNVP = [Select Value__c from Name_Value_Pair__mdt where DeveloperName = 'FlagPermitId'];
        if(lstNVP.size() > 0){
            permitFieldId = lstNVP[0].Value__c;
        }
        
        isContactOnHold = false;
        MUSW__Permit2__c per = [Select MUSW__Applicant__r.Contact_Status__c, MUSW__Account__r.Account_Status__c From MUSW__Permit2__c where Id = :record.Id];
        if(per.MUSW__Applicant__r.Contact_Status__c == 'On Hold' || per.MUSW__Account__r.Account_Status__c == 'On Hold'){
            isContactOnHold = true;
        }
    }
    
    public pagereference customnew(){
        PageReference pageRef;
        
        MUSW__Permit2__c permit = [select id, name from MUSW__Permit2__c where id =: Record.Id];
        String url = '/' + flagObjectPrefix + '/e?' + permitFieldId + '=' + permit.name + '&' + permitFieldId + '_lkid=' + permit.Id;
        
        pageRef = new PageReference(url);
        pageRef.setRedirect(true);
        return pageRef;
    }
    
}