/*************************************************************************************************************
**
User Story 31138:TECH: Visualize the PII Masking Jobs on a Visualforce Page
**************************************************************************************************************
** Class Name    : PIIMasking_MainInterface_Cons_Tetsing
** Description   : This is a test class for the PIIMasking_MainInterface_Constructor class
** Version       : 1.0
** Built By      : Akosa Okwudiafor
**------------------------------------------------------------------------------------------------------------
** Modification Log:
**------------------
** Developer                         Date                    Version                     Description
**------------------------------------------------------------------------------------------------------------
** Akosa Okwudiafor                   08/26/2016                  1                        Created
** Review Log:
**---------------
** Reviewer                         Date                    Version                      Description
** Kaistha, Aayush                  09/15/2016                   1                        Reviewed
**------------------------------------------------------------------------------------------------------------
** For Testing : There must be records in 'Sandbox_Refresh_PII_Masking__mdt' with options 1 through 5 
** in order to run and pass the tests. OTHERWISE THE TEST WILL FAIL.The methods needed are appendBefore, appendEnd , appendBoth 
** , replacedomain,replaceDomainNullEmail and SettoNull
** **********************************************************************************/

@isTest
private class PIIMasking_MainInterface_Cons_Testing {

    /**
    * Test Method name  : unselectingall
    * Description  : This test method works on selecting  and unselecting all fields.
    * Return Type  : void
    * Parameter    :
    **/    
    public static testMethod void unSelectingAll() {

        PIIMasking_MainInterface_Constructor controller = new PIIMasking_MainInterface_Constructor();
        controller.insandbox = PIIMasking_Utility.issandbox;
        // Instantiate a new controller with all parameters in the page
        controller.setselectedObject('Account');
        controller.setinsandbox(PIIMasking_Utility.issandbox);
        controller.getinsandbox();
        controller.returnAllfields();
        controller.getObjectlist();
        controller.getfieldsList();
        controller.getjobs();
        controller.getselectedObject();
        controller.getSelectedValues();
        controller.getunSelectedValues();
        List <String> one = new List<String> {'Email__c'};
        controller.deselecteditems = one ;
        controller.selectallclick();
        controller.deselecteditems = one ;
        controller.unselectallclick();

    }

        /**
    * Test Method name  : replaceDomainNullEmail
    * Description  : This test method works on the selected email field to replace domain while the email is null
    * Return Type  : void
    * Parameter    :
    **/
    public static testMethod void replaceDomainNullEmail() {
        PIIMasking_MainInterface_Constructor controller = new PIIMasking_MainInterface_Constructor();
        // Instantiate a new controller with all parameters in the page
        controller.setselectedObject('Account');
        controller.getinsandbox();
        controller.getObjectlist();
        controller.getfieldsList();
        controller.returnAllfields();
        controller.getjobs();
        controller.getselectedObject();
        List <String> one = new List<String> {'Email__c'};
        controller.selecteditems = one ;
        controller.getunSelectedValues();
        controller.selectallclick();
        controller.getSelectedValues();
        controller.objectsandfieldstobemasked();
        List <Account> accns = new List<Account>();
        for (integer i = 0; i < 100; i++) {
            Account a = new Account(Name = 'testAccount' + i, Phone = '1234567891');
            accns.add(a);
        }
        insert accns;
        Test.startTest();
        controller.objectsandfieldstobemasked();
        Test.StopTest();
    }

    /**
    * Test Method name  : replacedomain
    * Description  : This test method works on selected email field to replace domain while the email is not null  
    * Return Type  : void
    * Parameter    :
    **/
    
    public static testMethod void replacedomain() {
        PIIMasking_MainInterface_Constructor controller = new PIIMasking_MainInterface_Constructor();
        // Instantiate a new controller with all parameters in the page
        controller.setselectedObject('Account');
        controller.getinsandbox();
        controller.getObjectlist();
        controller.getfieldsList();
        controller.returnAllfields();
        controller.getjobs();
        controller.getselectedObject();
        List <String> one = new List<String> {'Email__c'};
        controller.selecteditems = one ;
        controller.getunSelectedValues();
        controller.selectallclick();
        controller.getSelectedValues();
        controller.objectsandfieldstobemasked();
        List <Account> accns = new List<Account>();
        for (integer i = 0; i < 100; i++) {
            Account a = new Account(Name = 'testAccount' + i, Email__c = 'test@test.com', Phone = '1234567891');
            accns.add(a);
        }
        
        insert accns;
        
        Test.startTest();
        controller.objectsandfieldstobemasked();
        Test.StopTest();
    }

    /**
    * Test Method name  : appendBefore
    * Description  :  This test method works on adding the masking string to the selected field
    * Return Type  : void
    * Parameter    :
    **/
    public static testMethod void appendBefore() {
        Global_Settings__c gs= new Global_Settings__c(SetupOwnerId=UserInfo.getUserId(), Disable_Triggers__c=true);
         insert gs; 
        PIIMasking_MainInterface_Constructor controller = new PIIMasking_MainInterface_Constructor();
        // Instantiate a new controller with all parameters in the page
        controller.setselectedObject('MUSW__License2__c');
        controller.getinsandbox();
        controller.getObjectlist();
        controller.getfieldsList();
        controller.returnAllfields();
        controller.getjobs();
        controller.getselectedObject();
        List <String> one = new List<String> {'Rp_Email__c'};
        controller.selecteditems = one ;
        controller.getunSelectedValues();
        controller.selectallclick();
        controller.getSelectedValues();
        controller.objectsandfieldstobemasked();
        List <MUSW__License2__c> accns = new List<MUSW__License2__c>();
        for (integer i = 0; i < 1; i++) {
            //MUSW__License2__c a = new MUSW__License2__c( Rp_Email__c = 'test@test.com');
           // accns.add(a);
        }
        
        insert accns;
        delete gs;
        Test.startTest();
        controller.objectsandfieldstobemasked();
        Test.StopTest();
    }

        /**
    * Test Method name  : setToNull
    * Description  : This test method works on changing  the selected field to null
    * Return Type  : void
    * Parameter    :
    **/
    public static testMethod void setToNull() {
        PIIMasking_MainInterface_Constructor controller = new PIIMasking_MainInterface_Constructor();
     controller.setselectedObject('MUSW__Complaint2__c');
        controller.getinsandbox();
        controller.getObjectlist();
        controller.getfieldsList();
        controller.returnAllfields();
        controller.getjobs();
        controller.getselectedObject();
        List <String> one = new List<String> {'Respondent_Email__c'};
        controller.selecteditems = one ;
        controller.getunSelectedValues();
        controller.selectallclick();
        controller.getSelectedValues();
        controller.objectsandfieldstobemasked();
        List <MUSW__Complaint2__c> accns = new List<MUSW__Complaint2__c>();
        for (integer i = 0; i < 100; i++) {
            MUSW__Complaint2__c a = new MUSW__Complaint2__c();
            accns.add(a);
        }
        insert accns;
        Test.startTest();
        controller.objectsandfieldstobemasked();
        Test.StopTest();
    }
    
        /**
    * Test Method name  : appendBoth
    * Description  :  This test method works on adding the masking string to and before the selected field
    * Return Type  : void
    * Parameter    :
    **/
    public static testMethod void appendBoth() {
        PIIMasking_MainInterface_Constructor controller = new PIIMasking_MainInterface_Constructor();
     controller.setselectedObject('Courses__c');
        controller.getinsandbox();
        controller.getObjectlist();
        controller.getfieldsList();
        controller.returnAllfields();
        controller.getjobs();
        controller.getselectedObject();
        List <String> one = new List<String> {'Licensee_Email__c'};
        controller.selecteditems = one ;
        controller.getunSelectedValues();
        controller.selectallclick();
        controller.getSelectedValues();
        controller.objectsandfieldstobemasked();
        List <Course__c > accns = new List<Course__c >();
        for (integer i = 0; i < 100; i++) {
          //  Course__c a = new Course__c(Licensee_Email__c = 'test@test.com');
            //accns.add(a);
        }
        insert accns;
        Test.startTest();
        controller.objectsandfieldstobemasked();
        Test.StopTest();
    }

    
      /**
    * Test Method name  : appendEnd
    * Description  :  This test method works on adding the masking string to the end of  the selected field
    * Return Type  : void
    * Parameter    :
    **/
    public static testMethod void appendEnd() {
        PIIMasking_MainInterface_Constructor controller = new PIIMasking_MainInterface_Constructor();
     controller.setselectedObject('Exam_Information__c');
        controller.getinsandbox();
        controller.getObjectlist();
        controller.getfieldsList();
        controller.returnAllfields();
        controller.getjobs();
        controller.getselectedObject();
        List <String> one = new List<String> {'Email__c'};
        controller.selecteditems = one ;
        controller.getunSelectedValues();
        controller.selectallclick();
        controller.getSelectedValues();
        controller.objectsandfieldstobemasked();
       /* List <Exam_Information__c  > accns = new List<Exam_Information__c  >();
        for (integer i = 0; i < 100; i++) {
            Exam_Information__c  a = new Exam_Information__c (Email__c = 'test@test.com');
            accns.add(a);
        }
        insert accns;*/
        Test.startTest();
        controller.objectsandfieldstobemasked();
        Test.StopTest();
    }
    
    /**
    * Test Method name  : selectUnselectingFields
    * Description  : This test method works on selecting and unselecting a field in the select box .
    * Return Type  : void
    * Parameter    :
    **/
    public static testMethod void selectUnselectingFields() {
        PIIMasking_MainInterface_Constructor controller = new PIIMasking_MainInterface_Constructor();
        // Instantiate a new controller with all parameters in the page
        controller.setselectedObject('Account');
        controller.setinsandbox(PIIMasking_Utility.issandbox);
        controller.setsuccessmessage('success');
        controller.getsuccessmessage();
        controller.setfailedmessage('failed');
        controller.getfailedmessage();
        controller.getinsandbox();
        controller.returnAllfields();
        controller.getObjectlist();
        controller.getfieldsList();
        controller.getjobs();
        controller.getselectedObject();
        List <String> one = new List<String> {'Email__c'};
        controller.selecteditems = one ;
        controller.getSelectedValues();
        controller.getunSelectedValues();
        controller.selectclick();
        controller.getwaytomaskwhatfield();
        List <String> two = new List<String> {'Email__c'};
        controller.deselecteditems = two ;
        controller.unselectclick();
        controller.updatejobs();
    }
}