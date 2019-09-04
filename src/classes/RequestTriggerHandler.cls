/**
* Name: RequestTriggerHandler
* Type: Class
* Description: Trigger Handler for Renewal_Application__c object being called from RenewalApplicationTrigger
* Date:        Developer/Company                   Description
* ---------------------------------------------------------------------------------------------------------------------------------------- *
*                                                   Initial Creation
* 08/22/2018   Srikanth Kottam/Deloitte             Apex Sharing
* 09/04/2019   Sukrut Nagarkar/Deloitte				automationAMR
**/
public class RequestTriggerHandler  implements BGCM.ITriggerHandler  {
    public static user u;
    public RequestTriggerHandler() {
        
        u = [Select Id, UserType, Is_Portal_User__c From User where Id = :UserInfo.getUserId()];
    }
    public void onAfterDelete() {}
    public void onAfterInsert() { 
        
    }
    public void onAfterUndelete() {}
    public void onAfterUpdate() {
        
        List<Request__c> lstRequests =(List<Request__c>)Trigger.new;
        Set<Id> setRequestId = new Set<Id>();
        for(Request__c req : lstRequests )
        {
            if(req.Status__c == 'Approved')
            {
                setRequestId.add(req.Id);
            }
        }
        if(!setRequestId.isEmpty())
        {
            automationAMR(setRequestId);
        }
    }
    public void onBeforeDelete() {}
    public void onBeforeInsert() {
        
    }
    public void onBeforeUndelete() {}
    public void onBeforeUpdate() {
        
    }
    
    public void automationAMR(Set<Id> setRequestId ){
        List<Request__c> lstrequest = [SELECT id,Contact__c,Account__c,License__c,Form_JSON__c,Profession__c,Service_Request_Type__c,License_Type__c,Status__c FROM Request__c WHERE Id=: setRequestId ];
        
            List<BGCK__Answer__c> lstAnswers = [SELECT Id,Answer_Text__c,License__c,Create_Endorsement_Record__c,Endorsement_Type__c,QuestionDOL__r.Question_Body__c,QuestionDOL__r.Data_Type__c,QuestionDOL__r.Endorsement_Type__c,Question_Section__c,Request__c,QuestionDOL__r.QuestionFieldAPI__c,QuestionDOL__r.Parent_Object_API_Name__c,QuestionDOL__r.QuestionObjectName__c,QuestionDOL__r.RecordType.DeveloperName FROM BGCK__Answer__c where Request__c=:lstrequest[0].Id];
            
            Service_Request_Automation__mdt sra = [SELECT id,Object_Name__c,Service_Request_Type__c FROM Service_Request_Automation__mdt where Service_Request_Type__c =:lstrequest[0].Service_Request_Type__c];
            List<String> fieldNames = new List<String>();
            String objectName = sra.Object_Name__c;     
            
            
            for(BGCK__Answer__c ans : lstAnswers)
            {
                fieldNames.add(ans.QuestionDOL__r.QuestionFieldAPI__c);
            }
            String condition;
            if(objectName == 'Contact')
            {
                condition = ' Id=\''+lstrequest[0].Contact__c+'\'';
            }
            else if(objectName == 'Account')
            {
                condition = ' Id=\''+lstrequest[0].Account__c+'\'';
            }
            else if(objectName == 'MUSW__License2__c')
            {
                condition = ' Id=\''+lstrequest[0].License__c+'\'';
            }
            
            string query = ' SELECT ' +       String.join( fieldNames, ', ' ) +   ' FROM ' +ObjectName +' where '+condition;
            system.debug('query'+query);
            SObject detail = Database.query(query);
            for(BGCK__Answer__c ans : lstAnswers)
            {
                detail.put(ans.QuestionDOL__r.QuestionFieldAPI__c,ans.Answer_Text__c);
            }
            system.debug('detail--'+detail);
        update detail;
    }
    
    
}