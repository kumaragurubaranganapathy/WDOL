/* 
*Class Name   : DOL_CreateErrorLog_Exception_Test
* Description  : Testclass for DOL_CreateErrorLog_Exception
* Created By   : Sandeep Mahankali
* Created On   : 10/18/2019 
* Modification Log:  
*------------------------------------------------------------------------------------------------------------------------------------------------------------------------
* Developer                    Date                        Description
*------------------------------------------------------------------------------------------------------------------------------------------------------------------------
*Sandeep                        10/21/2019    
*/


@IsTest
public class DOL_CreateErrorLog_Exception_Test {
    static testMethod void testCreateErrorLogException(){
        try{
            Integer I = 10/0;
        }catch(Exception e){
            DOL_CreateErrorLog_Exception.addError(e,'DOL_CreateErrorLog_Exception_Test','testCreateErrorLogException');
        }
    }
    
    static testMethod void logApplicationError(){
        try{
            Integer I = 10/0;
        }catch(Exception e){
            DOL_CreateErrorLog_Exception.createErrorLogs(e,'DOL_CreateErrorLog_Exception_Test','testCreateErrorLogException');
            DOL_CreateErrorLog_Exception.logApplicationError(e);
        }
    }
     static testMethod void logApplicationError2(){
        try{
            Integer I = 10/0;
        }catch(Exception e){
            DOL_CreateErrorLog_Exception.logApplicationError(e,'DOL_CreateErrorLog_Exception_Test','testCreateErrorLogException');
            DOL_CreateErrorLog_Exception.logApplicationError(e);
        }
    }
    
    static testMethod void logDeleteDetails(){
        DOL_CreateErrorLog_Exception.logDeleteDetails('','','');
        Account acc = new Account(name='testtesttesttesttesttesttesttesttesttesttesttest');
        Database.SaveResult[] srList;
        try{
            Id LicRecTypeId = Schema.SObjectType.MUSW__License2__c.getRecordTypeInfosByName().get('Individual').getRecordTypeId();
            List<MUSW__License2__c> listLicense = new List<MUSW__License2__c>();
            for(Integer i = 0; i<10; i++)
            {
                 MUSW__License2__c licenseObj = new MUSW__License2__c(Name='System Number', RecordTypeId = LicRecTypeId, MUSW__Primary_Licensee__c = acc.Id, Application_Type__c = 'Geologist', Credential_Type__c = 'Geologist', Application_Method__c = 'General Application', Manual_Fee_Generation__c = true);
                 listLicense.add(licenseObj);
            }
            //srList= Database.insert(new List<Account>{acc},false);
            Test.startTest(); 
            //List<Database.SaveResult> res = Database.insert(listLicense);
            //DOL_CreateErrorLog_Exception.logDataBaseSaveDetails(srList,'','');
        }catch(exception  e){
            //DOL_CreateErrorLog_Exception.logDataBaseSaveDetails(res,'DOL_CreateErrorLog_Exception_Test','logDeleteDetails');
        }
        
        
    }
    
    static testMethod void testM2(){
        
        try{
            Id AccRecTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('User Account').getRecordTypeId();
            Account acc = DOL_TestDataFactory.createAccount(AccRecTypeId);
            Id licRecordTypeId = Schema.SObjectType.MUSW__License2__c.getRecordTypeInfosByName().get('Individual').getRecordTypeId();
            MUSW__License2__c lic = DOL_TestDataFactory.createLicense(licRecordTypeId,acc.Id,'Funerals','Embalmer Intern','General Application');
            lic.Application_Method__c = 'Comit';
            update lic;
            
        }catch(exception  e){
             //DOL_CreateErrorLog_Exception.logDatabaseError(e,'DOL_CreateErrorLog_Exception_Test','testM2');
             DOL_CreateErrorLog_Exception.logDatabaseError(null,'','');
        }
        
        
    }
}