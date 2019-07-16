/*************************************************************************************************************
** 
User Story 31138:TECH: Visualize the PII Masking Jobs on a Visualforce Page
**************************************************************************************************************
** Class Name    : PIIMasking_MainInterface_Constructor
** Description   :  As a system admin user, I want to be able to see the past jobs run to mask the PII data on certain objects 
and have the ability to schedule the Apex Job for masking the PII in the sandbox at any given time. 
**                 TODO: Integrate with the metadata type.
** Version       : 1.0
** Built By      : Akosa Okwudiafor
**------------------------------------------------------------------------------------------------------------
** Modification Log:
**------------------
** Developer                         Date                    Version                     Description
**------------------------------------------------------------------------------------------------------------
** Akosa Okwudiafor                   08/23/2016                  1                        Created
** Rohit Gowrishetty				  10/26/2017                  1                        Edited for Custom Labels
** Review Log:
**---------------
** Reviewer                         Date                    Version                      Description
** Kaistha, Aayush                  09/15/2016                   1                        Reviewed
**------------------------------------------------------------------------------------------------------------
**
**  **********************************************************************************/


public with sharing class PIIMasking_MainInterface_Constructor {
    
    //Declaring the standard and custom object options for the system Admin to select.
    List<Sandbox_Refresh_PII_Masking__mdt> objectstObemasked=new List<Sandbox_Refresh_PII_Masking__mdt>();
    
    //These are the items selected by the user in the fields section.
    Public List < string > selectedItems {
        get;
        set;
    }
    Public List < string > deselectedItems {
        get;
        set;
    }
    
    //Message displayed after operation runs
    Public String successMessage='';
    Public String failedMessage='';
    
    //These are the current set of values in the fields section.
    Set <string> leftValues = new Set < string > ();
    Set <string> rightValues = new Set < string > ();
    
    
    //Starting Values for the Object field on load.
    public String selectedObject='';
    
    //Checking if the page is operating in a sandbox
    Public Boolean inSandbox;
    
    //Getters and setters method for the above objects
    Public void setInSandbox(Boolean bool)
    {
        insandbox=bool;
    }
    Public Boolean getInSandbox()
    {
        return insandbox;
    }
    
    //This is the getter and setter methods for selected objects
    public String getSelectedObject() {
        return selectedObject;
    }
    
    public void setSelectedObject(String obj) {
        selectedObject = obj;
    }
    
    //This is the getter and setter methods for sucess and failed message
    public String getSuccessMessage() {
        return successMessage;
    }
    
    public void setSuccessMessage(String success) {
        successmessage = success;
    }
    
    public String getFailedMessage() {
        return failedmessage;
    }
    
    public void setFailedMessage(String fail) {
        failedmessage = fail;
    }
    
           /**
* Method name  : PIIMasking_MainInterface_Constructor
* Description  : Constructor for the PIIMasking_MainInterface. Gets objects from the custom metadata and checking environment for sandbox
* Return Type  : 
* Parameter    : 
**/
    public PIIMasking_MainInterface_Constructor() { 
        getJobs();
        objectsToBeMasked= [ Select FieldName__c, MaskingString__c, Masking__c, ObjectName__c from Sandbox_Refresh_PII_Masking__mdt order by ObjectName__c ,FieldName__c Limit 50];
        inSandbox = PIIMasking_Utility.isSandbox;        
    }
    
       /**
* Method name  : getObjectList
* Description  : Sorting the object list before returning the value to the dropdown menu  
* Return Type  : List < SelectOption >
* Parameter    : 
**/
    public List < SelectOption > getObjectList() {
        List < SelectOption > objectList = new List < SelectOption >();
        Set < SelectOption > uniqueList = new Set < SelectOption >();
        for(Sandbox_Refresh_PII_Masking__mdt objectSel :objectsToBeMasked )
        {
            String obj =objectsel.ObjectName__c;
            uniquelist.add( new SelectOption(obj, obj ));
        }
        objectlist.addAll(uniquelist);
        return objectlist;
    }
 
       /**
* Method name  : returnAllFields
* Description  : Initial loading of the Fields into the select list by changing of object selected or page landing. It works with the getfieldslist  
* Return Type  : void
* Parameter    : 
**/
    public void returnAllFields() {
        successMessage='';
        failedMessage='';
        rightValues.clear();
        getSelectedValues();
        getFieldsList();
    }
    
   /**
* Method name  : getFieldsList
* Description  : Filling the field list with appropriate data from the objects selected . Only Texts, date and datetimes are maskable
* Return Type  : Set < String >
* Parameter    : 
**/
    public Set < String > getFieldsList() {
        Set < String > options = new Set < String > ();
        for(Sandbox_Refresh_PII_Masking__mdt objectSel :objectsToBeMasked )
        {
            if(objectSel.ObjectName__c.equals(selectedObject))
            {
                String obj =objectSel.FieldName__c;
                options.add(obj);
            }
        }
        selecteditems = new List < String > ();
        deSelectedItems = new List < String > ();
        leftValues.clear();
        leftValues.addAll(options);
        return options;
    }
    
    
 //Removing the fields to be masked.
   /**
* Method name  : selectClick
* Description  : This fires when the user clicks on the select  button and the items highlighted on the unselected select options box  moves to the selected section
* Return Type  : PageReference
* Parameter    : 
**/
    public PageReference selectClick() {
        successMessage='';
        failedMessage='';
        deSelectedItems.clear();
        for (String itemSelected: selectedItems) {
            rightValues.add(itemSelected);
            leftValues.remove(itemSelected);   
        }
        return null;
    }
    
    //Removing the fields to be masked.
   /**
* Method name  : unSelectClick
* Description  : This fires when the user clicks on the unselect  button and the items highlighted on the selected select options box  moves to the unselected section
* Return Type  : PageReference
* Parameter    : 
**/
    public PageReference unSelectClick() {
        selectedItems.clear();
        for (String itemselected: deSelectedItems) {
            
            rightValues.remove(itemselected);
            leftValues.add(itemselected);
        }
        return null;
    }
    
   /**
* Method name  : selectAllClick
* Description  : This fires when the user clicks on the select all button and all items on the unselected select options box  moves to the selected section
* Return Type  : PageReference
* Parameter    : 
**/
    public PageReference selectAllClick() {
        successmessage='';
        deselecteditems.clear();
        selecteditems.clear();
        rightvalues.addAll(leftvalues);
        leftvalues.clear();
        return null;
    }
    
           /**
* Method name  : unSelectallClick
* Description  : This fires when the user clicks on the unselect all button and all items on the selected select options moves to the unselected section
* Return Type  : PageReference
* Parameter    : 
**/
    public PageReference unSelectallClick() {
        deSelectedItems.clear();
        selectedItems.clear();
        leftValues.addAll(rightValues);
        rightValues.clear();
        return null;
    }
    
        /**
* Method name  : getUnSelectedValues
* Description  : Binds the set of 'left values' set to the left select option box .
* Return Type  : List < SelectOption >
* Parameter    : 
**/
    public List < SelectOption > getUnSelectedValues() {
        List < SelectOption > options = new List < SelectOption > ();
        List < string > tempList = new List < String > ();
        tempList.addAll(leftvalues);
        tempList.sort();
        for (string s: tempList) {
            options.add(new SelectOption(s, s));
        }
        return options;
    }
    
 /**
* Method name  : getUnSelectedValues
* Description  : Binds the set of 'right values' set  to the right select option box .
* Return Type  : List < SelectOption >
* Parameter    : 
**/
    public List < SelectOption > getSelectedValues() {
        List < SelectOption > options = new List < SelectOption > ();
        List < string > tempList = new List < String > ();
        tempList.addAll(rightValues);
        tempList.sort();
        for (String s: tempList)
            options.add(new SelectOption(s, s));
        return options;
    }
    
    
    /**
* Method name  : objectsAndFieldsToBeMasked
* Description  : This is where the actually masking of the field takes place and a success or failed message is shown.It passes the information to the masking utility class.
* Return Type  : List<AsyncApexJob>
* Parameter    : 
**/
    public void objectsAndFieldsToBeMasked() {
        if(!rightvalues.isEmpty())
        {
            successMessage=label.Str_The_batch_is_scheduled_for_execution;
            PIIMasking_Utility newBatch = new PIIMasking_Utility(selectedObject,rightvalues);
            newBatch.maskFields();  
        }
        else{
            failedMessage=label.Str_No_field_was_selected;
            
        }
        rightValues.clear();
        getSelectedValues();
        getfieldsList();
        getJobs();
    }
    
    /**
* Method name  : getJobs
* Description  : This is made for the constructor , it helps populate the async apex table
* Return Type  : List<AsyncApexJob>
* Parameter    : 
**/   
    public  List<AsyncApexJob> getJobs(){
        return [SELECT   JobType, ApexClass.name, ApexClassId, Status, JobItemsProcessed, TotalJobItems, CompletedDate, ExtendedStatus, NumberOfErrors,CreatedBy.Name
                FROM AsyncApexJob
                where ApexClass.name='PIIMasking_Batch_MainInterface' and JobType='BatchApex'
                order by CompletedDate Desc Limit 5];
        
    }

    /**
* Method name  : getWayToMaskWhatField
* Description  : Gets the information for masking a certain  field --> The masked string and the way of masking the selected fields.
* Return Type  : Map<String,String>
* Parameter    : 
**/
    public Map<String,String> getWayToMaskWhatField() {
        Map<String,String> fieldsAndWay= new Map<String,String>();
        for(Sandbox_Refresh_PII_Masking__mdt oneItem :objectsToBeMasked)
        {
            if( selectedObject.equals(oneItem.ObjectName__c)){
                for(String one:rightValues){
                    if(one.equals(oneItem.FieldName__c )){                       
                        fieldsandway.put(one, '  To be Masked by '+oneItem.Masking__c +  '.  The masking string is '+ oneItem.MaskingString__c+  ' .');
                    }
                }
            }
        }
        
        return fieldsAndWay;
    }
          public PageReference updateJobs(){
          getJobs();
        return null;
    }
}