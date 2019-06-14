/*************************************************************************************************************
**
User Story :TECH:  Create a page that helps a user load particular information from another Sandbox
**************************************************************************************************************
** Class Name    : DataExporterTest
** Description   :  /*************************************************************************************************************
**
User Story :TECH:  Create a page that helps a user load particular information from another Sandbox
**************************************************************************************************************
** Class Name    : DataExporter_Constructor
** Description   : This is a test class for the DataExporter_Constructor class
** Version       : 1.0
** Built By      : Akosa Okwudiafor
**------------------------------------------------------------------------------------------------------------
** Modification Log:
**------------------
**------------------------------------------------------------------------------------------------------------
** Akosa Okwudiafor                   09/22/2016                  1                        Created
** Review Log:
**---------------
** Reviewer                         Date                    Version                      Description
**------------------------------------------------------------------------------------------------------------
**
**  **********************************************************************************/

@isTest
private class DataExporterTest {
      
     /**
    * Test Method name  : selectingOnefield
    * Description  : This test method works on selecting one object.
    * Return Type  : void
    * Parameter    :
    **/  
    @isTest static void selectingOnefield() {
        DataExporter controller = new DataExporter();
        controller.setinsandbox([select id,IsSandbox from organization].IsSandbox); 
        controller.setuserloggedin(true); 
        controller.getuserloggedin();
        controller.setObjectslistempty(false);
        controller.getObjectslistempty();
        controller.getinsandbox();
        controller.returnAllObjects();
        controller.getObjectsList();
        controller.getselectedObject();
        controller.getSelectedValues();
        controller.getunSelectedValues();
        List <String> one = new List<String> {'Application_Field__c'};
        controller.selecteditems = one ;
        controller.selectclick();
        Test.setMock(HttpCalloutMock.class, new Mockgetobjectsresponse());
         controller.objectsToBeImported();
    }
    
         /**
    * Test Method name  : loggingtoorg
    * Description  : This test method works on logging into the org
    * Return Type  : void
    * Parameter    :
    **/  
     public static testMethod void loggingtoorg() {
        DataExporter controller = new DataExporter();
        controller.setinsandbox([select id,IsSandbox  from organization].IsSandbox);
        controller.setuserloggedin(true);
        controller.getuserloggedin();
        controller.setObjectslistempty(false);
        controller.setEmail('Akosa@akosa.com');
        controller.getEmail();
        controller.setPassword('TheAteam');
        controller.getPassword();
        controller.setsourceorg('google.com');
        controller.getsourceorg();
        controller.getObjectslistempty();
        controller.getinsandbox();
        controller.returnAllObjects();
        controller.getObjectsList();
         controller.setsuccessmessage('Succeed');
         controller.getsuccessmessage();
         controller.setfailedmessage('failed');
             controller.getfailedmessage();
        controller.getselectedObject();
        controller.getSelectedValues();
        controller.getunSelectedValues();
         controller.objectsToBeImported();
         controller.logintosourceorg();
    }
    
       /**
    * Test Method name  : importdata
    * Description  : This test method works on importing data into the org
    * Return Type  : void
    * Parameter    :
    **/  
    public static testMethod void importdata() {

        DataExporter controller = new DataExporter();
        controller.setinsandbox([select id,IsSandbox  from organization].IsSandbox);
        controller.setuserloggedin(true);
        controller.getuserloggedin();
        controller.setObjectslistempty(false);
        controller.getObjectslistempty();
           controller.setEmail('Akosa@akosa.com');
        controller.getEmail();
        controller.setPassword('TheAteam');
        controller.getPassword();
        controller.setsourceorg('google.com');
        controller.getsourceorg();
        controller.getinsandbox();
        controller.returnAllObjects();
        controller.getObjectsList();
        controller.getselectedObject();
        controller.getSelectedValues();
        controller.getunSelectedValues();
        List <String> one = new List<String> {'Application_Section__c'};
        controller.selecteditems = one ;
        controller.selectClick();
          Test.setMock(HttpCalloutMock.class, new Mockgetobjectsresponse());
        Test.startTest();
        controller.objectsToBeImported();
        
        Test.stopTest();
        controller.returnAllObjects();
    }
    
        /**
    * Test Method name  : importdata
    * Description  : This test method works on importing question into the org
    * Return Type  : void
    * Parameter    :
    **/  
    public static testMethod void importdata2() {

        DataExporter controller = new DataExporter();
        controller.setinsandbox([select id,IsSandbox  from organization].IsSandbox);
        controller.setuserloggedin(true);
        controller.getuserloggedin();
        controller.setObjectslistempty(false);
        controller.getObjectslistempty();
           controller.setEmail('Akosa@akosa.com');
        controller.getEmail();
        controller.setPassword('TheAteam');
        controller.getPassword();
        controller.setsourceorg('google.com');
        controller.getsourceorg();
        controller.getinsandbox();
        controller.returnAllObjects();
        controller.getObjectsList();
        controller.getselectedObject();
        controller.getSelectedValues();
        controller.getunSelectedValues();
        List <String> one = new List<String> {'Question__c'};
        controller.selecteditems = one ;
         controller.selectClick();
       Test.setMock(HttpCalloutMock.class, new Mockgetobjectsresponse());
        Test.startTest();
        controller.objectsToBeImported();
        
        Test.stopTest();
        controller.returnAllObjects();
    }
    
           /**
    * Test Method name  : unSelectingOne
    * Description  : This test method works on selection and unselecting one object 
    * Return Type  : void
    * Parameter    :
    **/  
    public static testMethod void unSelectingOne() {
     DataExporter controller = new DataExporter();
        controller.setinsandbox([select id,IsSandbox  from organization].IsSandbox);
        controller.setuserloggedin(true);
        controller.getuserloggedin();
        controller.setObjectslistempty(false);
        controller.getObjectslistempty();
        controller.getinsandbox();
        controller.returnAllObjects();
        controller.getObjectsList();
        controller.setselectedObject('Application_Field__c');        
                List <String> two = new List<String> {'Application_subsection__c'};
        controller.getselectedObject();
        controller.getSelectedValues();
        controller.getunSelectedValues();
        controller.setfailedLogin('failed login');
        controller.getfailedLogin();
        List <String> one = new List<String> {'Submission_List__c'};
        controller.selecteditems = one ;
        controller.selectclick();
         controller.deselecteditems = two ;
        controller.unSelectclick();
         
    }
    
    /**
    * Test Method name  : unselectingAll
    * Description  : This test method works on selection and unselecting all objects 
    * Return Type  : void
    * Parameter    :
    **/  
    public static testMethod void unselectingAll() {
        DataExporter controller = new DataExporter();
        controller.setinsandbox([select id,IsSandbox  from organization].IsSandbox);
        controller.setuserloggedin(true);
        controller.getuserloggedin();
        controller.setObjectslistempty(false);
        controller.getObjectslistempty();
        controller.setEmail('Akosa@akosa.com');
        controller.getEmail();
        controller.setPassword('TheAteam');
        controller.getPassword();
        controller.setsourceorg('google.com');
        controller.getsourceorg();
        controller.getinsandbox();
        controller.returnAllObjects();
        controller.getObjectsList();
        controller.getselectedObject();
        controller.getSelectedValues();
        controller.getunSelectedValues();
        List <String> one = new List<String> {'Application__Field__c'};
        controller.deselecteditems = one ;
        controller.selectallclick();
        controller.deselecteditems = one ;
        controller.unselectallclick();
    }
    
}