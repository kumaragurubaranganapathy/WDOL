/**
* Name: ServiceRequestUsersharing
* Type: Class
* Description: To handle sharing for Service Request records with the delegated admin on the account contact Record
* Date:        Developer/Company                 	Description
* ---------------------------------------------------------------------------------------------------------------------------------------- *
* 08/21/2018   Srikanth Kottam/Deloitte           Initial Creation
**/
public with sharing class ServiceRequestUsersharing {

/***************************************************************************************************
* @Method name   : ServiceRequest_RecordInsert
* @Description   : Prepare Necessary msp and list and pass them to the method that shares the records
* @Return Type   : None
* @Parameter     : Trigger.new
****************************************************************************************************/
    public void ServiceRequest_RecordInsert(List <MUSW__Application2__c> serviceReqShareList){
        
        SharingUtilityController controller = new SharingUtilityController();
        Set <Id> serviceReqIds = new Set <Id>();
        for (MUSW__Application2__c serviceReqRecord: serviceReqShareList){
            serviceReqIds.add(serviceReqRecord.Id);
        }
        controller.ShareRecordProcessingUtility(serviceReqIds,'MUSW__Application2__c','After Insert','ServiceRequestUsersharing',Schema.MUSW__Application2__share.RowCause.Insert_Service_Request_Share__c);
    }    
}