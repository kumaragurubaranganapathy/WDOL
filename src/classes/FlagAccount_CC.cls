/*************************************************************************************************************
** User Story: 284 -- Adding Alerts to an Account
**************************************************************************************************************
** Class Name    : FlagAccount_CC
** Description   : Controller for Account Related List (Associate Flag)
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
public class FlagAccount_CC {
      //Set up the standard controller connection and get current record 
    ApexPages.StandardController controller;
    public Account record {get; set;}
    public list<Associate_Flag__c> lstFlag {get; set;}
    public String flagObjectPrefix;
    public String accountFieldId;
    public Boolean isAccountOnHold {get; set;}
    
    public FlagAccount_CC(ApexPages.StandardController controller){
        this.controller = controller;
        this.record = (Account)controller.getrecord();
        
        lstFlag = [SELECT Id, Name, Flag__c, Description__c, Severity__c, Effective_Date__c, End_Date__c FROM Associate_Flag__c  WHERE Account__c =: record.id];  
   		
   		flagObjectPrefix = Schema.getGlobalDescribe().get('Associate_Flag__c').getDescribe().getKeyPrefix();
   		List<Name_Value_Pair__mdt> lstNVP = [Select Value__c from Name_Value_Pair__mdt where DeveloperName = 'FlagAccountId'];
   		if(lstNVP.size() > 0){
   			accountFieldId = lstNVP[0].Value__c;
   		}
        
        isAccountOnHold = false;
        Account acc = [Select Account_Status__c From Account where Id = :record.Id];
        if(acc.Account_Status__c == 'On Hold'){
            isAccountOnHold = true;
        }
    }  
    public pagereference customnew() {
        
        PageReference pageRef;
        
        Account acc = [select id, name from account where id =: Record.Id];
        String url = '/' + flagObjectPrefix + '/e?' + accountFieldId + '=' + acc.name + '&' + accountFieldId + '_lkid=' + acc.Id;
            
        pageRef =new PageReference(url);
        pageRef.setRedirect(true);
        
        return pageRef;
    }

}