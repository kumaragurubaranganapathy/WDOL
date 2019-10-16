@isTest
public class LnP_SaveBackgroundDetails_Test {
    
    public static testmethod void LnP_SaveBackgroundDetailsConstructor(){
        List<SObject> Iid = new List<SObject>();
        List<SObject> Iid1 = new List<SObject>();
        MUSW__Application2__c testApp=TestUtility.getApp();
        insert testApp;
        LnP_BackgroundSection__c testdel = new LnP_BackgroundSection__c();
        //testdel.RecordTypeId= DOL_AppConstants.NULL_EMPTY_STRING + '012r00000007LasAAE';
        testdel.RecordTypeId = Schema.SObjectType.LnP_BackgroundSection__c.getRecordTypeInfosByName().get('Qualifying Education').getRecordTypeId(); 
        testdel.Name= DOL_AppConstants.NULL_EMPTY_STRING + 'testName';
      //  testdel.Start_Date__c=System.today();
        insert testdel;
        String  ObjectName= DOL_AppConstants.NULL_EMPTY_STRING + 'LnP_BackgroundSection__c';
        String applicationId=testApp.Id;
        String recordTypeID= DOL_AppConstants.NULL_EMPTY_STRING + '012r00000007LasAAE';
        String flowType = 'CE Audit';
        String flowType1 = 'General Application';
        Request__c reqObj = new Request__c();
        reqObj.Service_Request_Type__c = 'Reschedule Exam';
        reqObj.Status__c = 'Approved';
        insert reqObj;
        Education_History__c eduHObj = new Education_History__c();
        eduHObj.State__c = 'California';
        eduHObj.Request__c = reqObj.Id;
        insert eduHObj;
        Test.startTest();
        try{
        Iid= LnP_SaveBackgroundDetails.returnIds(ObjectName,applicationId,recordTypeID,flowType);
        Iid= LnP_SaveBackgroundDetails.returnIds(ObjectName,applicationId,recordTypeID,flowType1);
        }
        catch(Exception e){
            DOL_CreateErrorLog_Exception.logApplicationError(e);
          //  System.debug('Error Occured');
        }
        try{
        String response = LnP_SaveBackgroundDetails.updateEducationHistoryRecord(eduHObj.Id,reqObj.Id);}
        catch(Exception e){
            DOL_CreateErrorLog_Exception.logApplicationError(e);
            //System.debug('Error Occured');
        }
        try{LnP_SaveBackgroundDetails.deleteTableRecord(testdel.Id);}
         catch(Exception e){
            DOL_CreateErrorLog_Exception.logApplicationError(e);
            //System.debug('Error Occured');
        }
      //  system.assert(Iid.size() > 0 );
        Test.stopTest();
    }
}