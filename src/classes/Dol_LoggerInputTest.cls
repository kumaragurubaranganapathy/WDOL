@isTest
public class Dol_LoggerInputTest {

    public static testMethod void Dol_LoggerInputMethod(){
        test.startTest();
        Dol_LoggerInput.getDolLoggerForInfo('test','test','test');
        Dol_LoggerInput.getDolLoggerForError('test','test','test');
        Dol_LoggerInput logObj = new Dol_LoggerInput();
        logObj.e = new DMLException('My DML EXCEPTION'); 
        logObj.SourcePackage = '';
            logObj.sObjectId = '';
        logObj.sObjectName = '';
        logObj.additionalDetails2 = '';
        test.stopTest();
        
       
    }
}