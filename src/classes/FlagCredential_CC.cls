/*************************************************************************************************************
** User Story: 282 -- Adding Alerts to a Credential/Plan Review/PTO
**************************************************************************************************************
** Class Name    : FlagCredential_CC
** Description   : Controller for Credential Related List (Associate Flag)
** Version       : 1.0
** Built By      : Srikanth Kottam
**------------------------------------------------------------------------------------------------------------
** Modification Log:
**------------------
** Developer                         Date                    Version                      Description
**------------------------------------------------------------------------------------------------------------
** Srikanth Kottam                07/07/2018                    1                          Created
** 
** Review Log:
**---------------
** Reviewer                  Date           Version               Description
**------------------------------------------------------------------------------------------------------------
**
**  **********************************************************************************/
public class FlagCredential_CC {
    ApexPages.StandardController controller;
    public MUSW__License2__C record {get; set;}
    public list<Associate_Flag__c> lstFlag {get; set;}
    public String flagObjectPrefix;
    public String licenseFieldId;
    public Boolean isContactOnHold {get; set;}
    
    public FlagCredential_CC(ApexPages.StandardController controller){
        this.controller = controller;
        this.record = (MUSW__License2__C)controller.getrecord();
        
        lstFlag = [SELECT Id, Name, Flag__c, Description__c, Severity__c, Effective_Date__c, End_Date__c FROM Associate_Flag__c  WHERE Credential__c =: record.id];  
   		flagObjectPrefix = Schema.getGlobalDescribe().get('Associate_Flag__c').getDescribe().getKeyPrefix();
        List<Name_Value_Pair__mdt> lstNVP = [Select Value__c from Name_Value_Pair__mdt where DeveloperName = 'FlagCredentialId'];
   		if(lstNVP.size() > 0){
   			licenseFieldId = lstNVP[0].Value__c;
   		}
        
        isContactOnHold = false;
        MUSW__License2__c lic = [Select Applicant_Status__c, MUSW__Primary_Licensee__r.Account_Status__c From MUSW__License2__c where Id = :record.Id];
        if(lic.Applicant_Status__c == 'On Hold' || lic.MUSW__Primary_Licensee__r.Account_Status__c == 'On Hold'){
            isContactOnHold = true;
        }
    }
    
    public pagereference customnew(){
        PageReference pageRef;
        
        MUSW__License2__c license = [select id, name from MUSW__License2__c where id =: Record.Id];
        String url = '/' + flagObjectPrefix + '/e?' + licenseFieldId + '=' + license.name + '&' + licenseFieldId + '_lkid=' + license.Id;
        
        pageRef = new PageReference(url);
        pageRef.setRedirect(true);
        return pageRef;
    }

}