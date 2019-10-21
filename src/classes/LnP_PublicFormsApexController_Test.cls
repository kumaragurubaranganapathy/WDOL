/* 
*Class Name   : LnP_PublicFormsApexController_Test
* Description  : Testclass for LnP_PublicFormsApexController
* Created By   : Shreya Surabhi
* Created On   : 19/09/2019 
* Modification Log:  
*------------------------------------------------------------------------------------------------------------------------------------------------------------------------
* Developer                    Date                        Description
*------------------------------------------------------------------------------------------------------------------------------------------------------------------------
*
*/
@isTest
public class LnP_PublicFormsApexController_Test{
    static testMethod void testMethod1(){
        LnP_PublicFormsApexController userDetails = new LnP_PublicFormsApexController();
        String strPrefix = 'google';
        String usrnm = 'abachchan';
        String pwd = 'bachchan@123';
        //insert userDetails;
        
        try{
            LnP_PublicFormsApexController.userlogin('abachchan','bachchan@123');
        }
        catch(Exception ex){
            DOL_CreateErrorLog_Exception.logApplicationError(ex);
            //System.debug('Error');
        }
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"example":"test"}');
        res.setStatusCode(200);

        
        Test.startTest();
           Map<String,String> formJSONVal = LnP_PublicFormsApexController.getFormsJSON();
        try { LnP_PublicFormsApexController.getAutoComplete('google');}
        catch(exception ex){}
        
        LnP_PublicFormsApexController.makeAPICall('www.google.com');
        
          
        Test.stopTest();
    }
}