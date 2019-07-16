/*************************************************************************************************************
** User Story: 283 -- Adding Alerts to a Contact
**************************************************************************************************************
** Class Name    : FlagContact_CC
** Description   : Controller for Contact Related List (Associate Flag)
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
**************************************************************************************/
public class FlagContact_CC {
    //Set up the standard controller connection and get current record 
    ApexPages.StandardController controller;
    public contact record {get; set;}
    public list<Associate_Flag__c> lstFlag {get; set;}
    public String flagObjectPrefix;
    public String contactFieldId;
    public Boolean isContactOnHold {get; set;}
    
    public FlagContact_CC(ApexPages.StandardController controller){
        this.controller = controller;
        this.record = (contact)controller.getrecord();
        
        lstFlag = [SELECT Id, Name, Flag__c, Description__c, Severity__c, Effective_Date__c, End_Date__c FROM Associate_Flag__c  WHERE Contact__c =: record.id];  
   		
   		flagObjectPrefix = Schema.getGlobalDescribe().get('Associate_Flag__c').getDescribe().getKeyPrefix();
   		List<Name_Value_Pair__mdt> lstNVP = [Select Value__c from Name_Value_Pair__mdt where DeveloperName = 'FlagContactId'];
   		if(lstNVP.size() > 0){
   			contactFieldId = lstNVP[0].Value__c;
   		}
        
        isContactOnHold = false;
        Contact con = [Select Contact_Status__c From Contact where Id = :record.Id];
        if(con.Contact_Status__c == 'On Hold'){
            isContactOnHold = true;
        }
    } 
    public pagereference customnew() {
        
        PageReference pageRef;   
            
        contact con = [select id, name from contact where id =: Record.Id];
        String url = '/' + flagObjectPrefix + '/e?' + contactFieldId + '=' + con.name + '&' + contactFieldId + '_lkid=' + con.Id;
        
        pageRef =new PageReference(url);
        pageRef.setRedirect(true);
        
        return pageRef;
    }
}