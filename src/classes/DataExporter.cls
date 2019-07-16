/*************************************************************************************************************
**
User Story :TECH:  Create a page that helps a user load particular information from another Sandbox
**************************************************************************************************************
** Class Name    : DataExporter_Constructor
** Description   :  As a system admin user, I want to be able to be able to load data from one  particular sandbox 
**                  to another sandbox.
** Version       : 1.0
** Built By      : Akosa Okwudiafor
**------------------------------------------------------------------------------------------------------------
** Modification Log:
**------------------
** Developer                         Date                    Version                     Description
**------------------------------------------------------------------------------------------------------------
** Akosa Okwudiafor                   09/22/2016                  1                        Created
** Review Log:
**---------------
** Reviewer                         Date                    Version                      Description
**------------------------------------------------------------------------------------------------------------
**
**  **********************************************************************************/

//taExporter_Constructor
public with sharing class DataExporter {
    
    //Declaring the standard and custom object options for the system Admin to select. 
    List<Data_Object__mdt> objectstobeloaded = new List<Data_Object__mdt>();
    List<Data_Object__mdt> objectswithparents = new List<Data_Object__mdt>();
    //These are the items selected by the user in the fields section.
    Public List < string > selectedItems { get; set; }
    Public List < string > deselectedItems { get; set; }
    public Integer recordSizeLimit = 50000;
    //Message displayed after operation runs  successfully    
    Public String successMessage = '';
    Public String failedMessage = '';
    
    //Information for the user to log in to the source Org.
    Public String password = '';
    Public String Email = '';
    Public String sourceOrg = '';
    
    // Error message when the log in fails.
    Public String failedLogin = '';
    
    //Stores  the value of the user being logged in .
    Public Boolean userloggedin;
    
    //Gets the information from the connection made to the source Org
    Private String SERVER_URL;
    Private String SESSION_ID ;
    
    //When only one object is selected to be imported
    private string solitaryObject;
    
    //Boolean to check if all the selected objects haver 
    Public Boolean Objectslistempty;
    
    //These are the current set of values in the fields section.
    Set <string> leftValues = new Set < string > ();
    Set <string> rightValues = new Set < string > ();
    List <string> selectedObjects = new List < string > ();
    
    //Starting Values for the Object field on load.
    public String selectedObject = '';
    
    //Checking if the page is operating in a sandbox
    Public Boolean inSandbox;
    
    //Getters and setters method for the above objects
    Public void setInSandbox(Boolean bool) {
        insandbox = bool;
    }
    Public Boolean getInSandbox() {
        return insandbox;
    }
    
    Public void setObjectslistempty(Boolean bool) {
        Objectslistempty = bool;
    }
    Public Boolean getObjectslistempty() {
        return Objectslistempty;
    }
    
    Public void setuserloggedin(Boolean bool) {
        userloggedin = bool;
    }
    Public Boolean getuserloggedin() {
        return userloggedin;
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
    
    public void setFailedMessage(String failure) {
        failedmessage = failure;
    }
    public String getpassword() {
        return password;
    }
    
    public void setpassword(String success) {
        password = success;
    }
    
    public String getEmail() {
        return Email;
    }
    
    public void setEmail(String success) {
        Email = success;
    }
    
    public String getsourceOrg() {
        return sourceOrg;
    }
    
    public void setsourceOrg(String success) {
        sourceOrg = success;
    }
    
    public String getfailedLogin() {
        return failedLogin;
    }
    
    public void setfailedLogin(String fail) {
        failedLogin = fail;
    }
    
    /**
* Method name  : DataExporter_Constructor
* Description  : Constructor for the DataExporter. Gets objects from the custom metadata and checking environment for sandbox,Initializes the login boolean to false
* Return Type  :
* Parameter    :
**/
    public DataExporter() {
        objectstobeloaded = [ Select Label ,Order__c from Data_Object__mdt order by Order__c limit 100];
        objectswithparents =[SELECT Id, Parent_API_Name__c, Label, Order__c FROM Data_Object__mdt  where Parent_API_Name__c!='' order by Order__c];
        inSandbox = [select id,IsSandbox  from organization].IsSandbox; 
        userloggedin = false;
    }
    
    
    /**
* Method name  : returnAllObjects
* Description  : Initial loading of the Objects into the select boxes
* Return Type  : void
* Parameter    :
**/
    public void returnAllObjects() {
        System.debug('i was called');
        successMessage = '';
        failedmessage='';
        rightValues.clear();
        getSelectedValues();
        getObjectsList();
    }
    
    /**
* Method name  : getObjectsList
* Description  : Filling the Objects list with appropriate data from the objects selected
* Return Type  : Set < String >
* Parameter    :
**/
    public Set < String > getObjectsList() {
        Set < String > options = new Set < String > ();
        for (Data_Object__mdt objectSel : objectstobeloaded ) {
            String obj = objectSel.Label;
            options.add(obj);
        }
        selecteditems = new List < String > ();
        deSelectedItems = new List < String > ();
        leftValues.clear();
        leftValues.addAll(options);
        return options;
    }
    
    /**
* Method name  : selectClick
* Description  : This fires when the user clicks on the select  button and the items highlighted on the unselected select options box  moves to the selected section
* Return Type  : PageReference
* Parameter    :
**/
    public PageReference selectClick() {
        successMessage = '';
        failedMessage='';
        deSelectedItems.clear();
        for (String itemSelected : selectedItems) {
            rightValues.add(itemSelected);
            leftValues.remove(itemSelected);
            parentDepedent(itemSelected);
            childDependentSelecting(itemSelected);
        }
        return null;
    }
    
    /**
* Method name  : parentDepedent
* Description  : Selecting the parents of children
* Return Type  : 
* Parameter    : String itemselected
**/
    
    public void parentDepedent(String itemselected) {
        for (Data_Object__mdt objectSel : objectswithparents ) {
            String obj = objectSel.Label;
            if(obj==itemselected){
                rightValues.add(objectSel.Parent_API_Name__c);
                leftValues.remove(objectSel.Parent_API_Name__c);
                childDependentSelecting(objectSel.Parent_API_Name__c);
                parentDepedent(objectSel.Parent_API_Name__c);
            }
        }
    }
    
    /**
* Method name  : childDependentSelecting
* Description  : Selecting children of the parents in the right select boxes
* Return Type  : 
* Parameter    : String itemselected
**/   
    
    public void childDependentSelecting(String itemselected) {
        for (Data_Object__mdt objectSel : objectswithparents ) {
            String obj = objectSel.Label;
            if(objectSel.Parent_API_Name__c==itemselected){
                System.debug(obj + ' 243');
                leftValues.remove(obj);
                rightvalues.add(obj);
                childDependentSelecting(obj);
            }
        }
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
        for (String itemselected : deSelectedItems) {    
            rightValues.remove(itemselected);
            leftValues.add(itemselected);
            childDependent(itemselected);
            parentDepedentUnselecting(itemselected);
        }
        return null;
    }
    
    /**
* Method name  : parentDepedentUnselecting
* Description  : Unselecting the parents of children
* Return Type  : 
* Parameter    : String itemselected
**/
    
    public void parentDepedentUnselecting(String itemselected) {
        for (Data_Object__mdt objectSel : objectswithparents ) {
            String obj = objectSel.Label;
            if(obj==itemselected){
                leftValues.add(objectSel.Parent_API_Name__c);
                rightValues.remove(objectSel.Parent_API_Name__c);
                parentDepedentUnselecting(objectSel.Parent_API_Name__c);
                childDependent(objectSel.Parent_API_Name__c);
            }
        }
    }
    /**
* Method name  : parentDepedent
* Description  : Selecting the children of  parents
* Return Type  : 
* Parameter    : String itemselected
**/
    public void childDependent(String itemselected) {
        for (Data_Object__mdt objectSel : objectswithparents ) {
            String obj = objectSel.Label;
            if(objectSel.Parent_API_Name__c==itemselected){
                rightValues.remove(obj);
                leftValues.add(obj);
                childDependent(obj);
            }
        }
    }
    
    /**
* Method name  : selectAllClick
* Description  : This fires when the user clicks on the select all button and all items on the unselected select options box  moves to the selected section
* Return Type  : PageReference
* Parameter    :
**/    
    public PageReference selectAllClick() {
        successmessage = '';
        failedMessage='';
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
* Method name  : getSelectedValues
* Description  : Binds the set of 'right values' set  to the right select option box .
* Return Type  : List < SelectOption >
* Parameter    :
**/
    public List < SelectOption > getSelectedValues() {
        List < SelectOption > options = new List < SelectOption > ();
        List < string > tempList = new List < String > ();
        tempList.addAll(rightValues);
        tempList.sort();
        for (String s : tempList)
            options.add(new SelectOption(s, s));
        return options;
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
        for (string s : tempList) {
            options.add(new SelectOption(s, s));
        }
        return options;
    }
    
    /**
* Method name  : objectsToBeImported
* Description  : This is where the actually masking of the field takes place and a success or failed message is shown.It passes the information to the masking utility class.
* Return Type  : List<AsyncApexJob>
* Parameter    :
**/
    
    public void objectsToBeImported() {
        successmessage='';
        failedMessage='';
        if(!rightvalues.isEmpty()){
            for(Integer i =0 ; i< objectstobeloaded.size();i++){
                String obj = objectstobeloaded[i].Label;
                for(String oneobject : rightvalues){
                    if(oneobject==obj){
                        selectedObjects.add(obj);
                    }
                }
            }
            Objectslistempty=false;
            System.debug('Objectslistempty '+' I am here');
            returnAllObjects(); 
            dataloading();
            
        }
        else{
            failedMessage='No Object was selected.';
        }
        
    }
    
    /**
* Method name  : dataloading
* Description  : This is where the actually  importation of the data takes place.
* Return Type  : List<AsyncApexJob>
* Parameter    :
**/
    
    public void dataloading() {
System.debug('i am here');        
        Objectslistempty=selectedObjects.isEmpty(); 
        successmessage=solitaryObject;
        System.debug(selectedObjects);
        if (!selectedObjects.isEmpty()) {
            HttpRequest req = new HttpRequest();
            req.setMethod('GET');
            req.setHeader('Authorization', 'Bearer '+ SESSION_ID);
            string BaseURL = ApexPages.currentPage().getHeaders().get('Host');
            for(integer i=0; i<1;i++){
                System.debug('counter '+i);
                String parentname='';
                String objname =selectedObjects[i];
                for (Data_Object__mdt objectSel : objectswithparents ) {
                    String obj = objectSel.Label;
                    if(obj==objname){
                        parentname=objectSel.Parent_API_Name__c;
                    }
                }                               
                req.setEndpoint('https://'+sourceOrg+'/services/apexrest/DataService/'+objname);
                Http http = new Http();
                try{
                    DataMigrationUtil datainstance = new DataMigrationUtil(objname,parentname);
                    datainstance.purgeRecords();
                    if(objname.contains('Question')||objname.contains('Field'))
                    {
                        selectedObjects.remove(i); 
                        successmessage=objname +' has been sucessfully imported.';
                        solitaryObject=successmessage;
                        testing123(Session_id,objname,parentname,sourceOrg ); 
                    }
                    /*else if(objname.contains('MUSW__Master_Submission_List__c'))                    {    
                        selectedObjects.remove(i); 
                        break;
                    }*/
                    else{
                        System.debug(objname);
                        String body = (new Http()).send(req).getBody();
                        selectedObjects.remove(i); 
                        List<Sobject> objectsDeserialized = (List<Sobject>) JSON.deserialize(body, List<Sobject>.class);
                        System.debug('objectsDeserialized  '+objectsDeserialized);
                        if(objectsDeserialized.size()!=0 ){
                            datainstance.insertRecords(objectsDeserialized, recordSizeLimit);  
                            successmessage=objname +' has been sucessfully imported.';
                            solitaryObject=successmessage;
                        }
                        else{
                            break;
                        }                     
                    }
                }
                catch(System.CalloutException e) {
                    System.debug(e);
                }
                catch(System.JSONException e){
                    System.debug(e);
                    failedMessage= 'Please ensure the metadata between source and target for  '+objname +' is the same. The Object was not Imported.';
                }
            }
        }
    }
    
    @future(callout=true)
    public static void Testing123(String session_id,string objname, string parentname,string sourceorg)
    {              
        HttpRequest req = new HttpRequest();
        req.setMethod('GET');
        req.setHeader('Authorization', 'Bearer '+ SESSION_ID);
        req.setEndpoint('https://'+sourceOrg+'/services/apexrest/DataService/'+objname);    
        System.debug('line 428 ' +limits.getHeapSize());
        req.setTimeout(120000);
        String body = (new Http()).send(req).getBody();
        
        System.debug('line 430 ' +limits.getHeapSize());
        DataMigrationUtil datainstance = new DataMigrationUtil(objname,parentname);
        List<Sobject> objectsDeserialized = (List<Sobject>) JSON.deserialize(body, List<Sobject>.class);
        System.debug('objectsDeserialized  '+objectsDeserialized);
       System.debug(objectsDeserialized.size());
        System.debug(System.Limits.getHeapSize());
        System.debug(System.Limits.getLimitHeapSize());
        String body2 ='';
       /* if(objname.contains('Question')){
            req.setEndpoint('https://'+sourceOrg+'/services/apexrest/DataService/'+'MUSW__Master_Submission_List__c');    
            body2 = (new Http()).send(req).getBody();
        }*/
        if(objectsDeserialized.size()!=0&&objname.contains('Question')){
           datainstance.insertRecords(objectsDeserialized, 50000);  
       }
        /*if(objname.contains('Question')){
            System.enqueueJob(new dataimportqueueable('MUSW__Master_Submission_List__c','Question__c',body2));
        }*/
         if(objname.contains('Application_Field__c')){
            System.enqueueJob(new dataimportqueueable(objname,'Application_SubSection__c',body));
        }
    }
    
    
    /**
* Method name  : logIntoSourceOrg
* Description  : This is where the logging into the other org takes place.
* Return Type  : void
* Parameter    :
**/
    public void logIntoSourceOrg() {
        HttpRequest request = new HttpRequest();
        Email =Email.trim();
        if(sourceOrg.contains('https')){
            sourceOrg=sourceOrg.replace('https', '');
            sourceOrg=sourceOrg.substring(3);
        }
        sourceorg =sourceorg.trim();
        request.setEndpoint('https://' + sourceOrg + '/services/Soap/u/37.0');
        request.setMethod('POST');
        request.setHeader('Content-Type', 'text/xml;charset=UTF-8');
        request.setHeader('SOAPAction', '""');       
        request.setBody('<Envelope xmlns="http://schemas.xmlsoap.org/soap/envelope/"><Header/><Body><login xmlns="urn:partner.soap.sforce.com"><username>' + Email + '</username><password>' + password + '</password></login></Body></Envelope>');
        Http http = new Http();
        try {
            Dom.XmlNode resultElmt = (http).send(request).getBodyDocument().getRootElement()
                .getChildElement('Body', 'http://schemas.xmlsoap.org/soap/envelope/')
                .getChildElement('loginResponse', 'urn:partner.soap.sforce.com')
                .getChildElement('result', 'urn:partner.soap.sforce.com');
            System.debug((http).send(request).getBodyDocument().getRootElement()
                         .getChildElement('Body', 'http://schemas.xmlsoap.org/soap/envelope/')
                         .getChildElement('loginResponse', 'urn:partner.soap.sforce.com')
                         .getChildElement('result', 'urn:partner.soap.sforce.com'));
            SERVER_URL = resultElmt.getChildElement('serverUrl', 'urn:partner.soap.sforce.com').getText().split('/services')[0];
            SESSION_ID = resultElmt.getChildElement('sessionId', 'urn:partner.soap.sforce.com').getText();
            userloggedin = true;
        } catch (Exception e){
             System.debug('Here ==>'+ e);
        }
        if ( userloggedin != true) {
            failedLogin = 'Login failed.';
        }
        
    }
}