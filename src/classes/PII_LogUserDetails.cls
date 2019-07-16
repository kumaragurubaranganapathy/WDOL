/*************************************************************************************************************
** User Story: 
**************************************************************************************************************
** Class Name       : PII_LogUserDetails
** Description      : 
** Version          : 1.0
** Built By         : Aishwaria Rangineni
**------------------------------------------------------------------------------------------------------------
** Modification Log:
**------------------
** Developer                  Date          Version               Description
**------------------------------------------------------------------------------------------------------------
**
** Review Log:
**---------------
** Reviewer                   Date           Version                Description
**------------------------------------------------------------------------------------------------------------
**
*************************************************************************************************************/
public with sharing class PII_LogUserDetails {
    //Declare three global variables to control render and reRender of the page
    public Boolean infoPrint {get;set;} 
    public Boolean infoEdit {get;set;}
    public Boolean showRelatedLists {get; set;}
    
    //Set up the standard controller connection and get current record 
    ApexPages.StandardController controller;
    public Contact record {get; set;}
    public List<ContactHistory> lstHistory {get; set;}
    /***************************************************************************************************
* @Description : Create a method to query ContactHistory.
* @Param       : NA
* @Return      : None
***************************************************************************************************/
    
    public void historyQuery (){
        
        list<String> lstFieldNames = new List<String>{'Ethnicity__c'};
        if (Schema.sObjectType.Contact.fields.Birthdate.isAccessible()) {
            lstFieldNames.add('Birthdate');
        }
        if (Schema.sObjectType.Contact.fields.Social_Security_Number_Encrypted__c.isAccessible()) {
            lstFieldNames.add('Social_Security_Number_Encrypted__c');
        }
        if (Schema.sObjectType.Contact.fields.Comments__c.isAccessible()) {
        lstFieldNames.add('Comments__c');
        }
        
        lstHistory = [Select Id, Field, ContactId, NewValue, OldValue, CreatedById, CreatedBy.Name, CreatedDate From ContactHistory where ContactId = :record.Id and Field IN :lstFieldNames ORDER BY CreatedDate DESC NULLS LAST ];

        System.debug('lstHistory  ' +lstHistory);
    }
    
    /***************************************************************************************************
* @Description : Constructor
* @Param       : NA
* @Return      : NA
***************************************************************************************************/
    
    public PII_LogUserDetails (ApexPages.StandardController controller){
        
        this.controller = controller;
        this.record = (Contact)controller.getrecord();
        
        infoPrint = true;
        infoEdit = false;
        historyQuery ();
        
        //Put this in the constructor to allow only certain profiles to see
        //showRelatedLists = false;
        User currentUser = [Select Profile.Name from User where Id = :UserInfo.getUserId()];
        //if(currentUser.Profile.Name == label.Str_System_Administrator){
            showRelatedLists = true;
        //}
    }    
    
    /***************************************************************************************************
* @Description : Create a method to change the two Boolean values when the "Edit" button is pressed.
* @Param       : NA
* @Return      : PageReference
***************************************************************************************************/
    
    public PageReference EditContact (){
        infoPrint = false;
        infoEdit = true;
        return null;    
    }
    
    /***************************************************************************************************
* @Description : Create a method to save the page.
* @Param       : NA
* @Return      : PageReference
***************************************************************************************************/
    public PageReference savePage(){
        infoPrint = true;
        infoEdit = false;
        controller.save();
        return null;
    }
    
    /***************************************************************************************************
* @Description : Now insert a new log entry when the page opens.
* @Param       : NA
* @Return      : PageReference
***************************************************************************************************/
    public PageReference createNewLog() {
        
        //Get page definition
        PageReference pdfPage = Page.Contact_PII_Information;
        pdfPage.getparameters().put('id', record.id);
        
        //Get the current user id
        Id userId = UserInfo.getUserId ();
        if (userId !=null && record.id !=null){
            PII_Info_Log__c entry = new PII_Info_Log__c(Contact__c = record.id, Date_Time__c = System.now(), User__c = userId);
            insert entry;
        }
        //Continue loading the page after the entry has been made
        return null;
    }
    
}