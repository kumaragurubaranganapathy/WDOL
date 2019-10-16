/**
* Name: RequestTriggerHandler
* Type: Class
* Description: Trigger Handler for Renewal_Application__c object being called from RenewalApplicationTrigger
* Date:        Developer/Company                   Description
* ---------------------------------------------------------------------------------------------------------------------------------------- *
*                                                   Initial Creation
* 08/22/2018   Srikanth Kottam/Deloitte             Apex Sharing
* 09/04/2019   Sukrut Nagarkar/Deloitte        automationAMR
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
        Set<Id> setExamRequestTaskId = new Set<Id>();
        Set<Id> setCERequestTaskId = new Set<Id>();
        for(Request__c req : lstRequests )
        {
            if(req.Status__c == 'Under Review' && (req.Service_Request_Type__c == 'Reschedule Exam' || req.Service_Request_Type__c == 'Submit Exam Results') )
            {
                setExamRequestTaskId.add(req.Exam__c);
            }
            if(req.Status__c == 'Under Review' && req.Service_Request_Type__c == 'CE Audit'  )
            {
                setCERequestTaskId.add(req.Id);
            }
            if(req.Status__c == 'Approved')
            {
                setRequestId.add(req.Id);
            }
        }
        if(!setExamRequestTaskId.isEmpty())
        {
            updateTaskToClose(setExamRequestTaskId);
        }
        if(!setCERequestTaskId.isEmpty())
        {
            updateTaskToClose(setCERequestTaskId);
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
    public void onBeforeUpdate() {}
    
    public void updateTaskToClose(Set<Id> setRequestTaskId){
        List<Task> lstTask = [SELECT id,Status,Whatid FROM Task WHERE Whatid IN:setRequestTaskId AND Status='Pending'];
        
        if(!lstTask.isEmpty())
        {
            for(Task ta : lstTask)
            {
                ta.Status = 'Completed';
            }
            try{
            update lstTask;
        }catch(Exception ex)
        {
            DOL_CreateErrorLog_Exception.logApplicationError(ex);
            throw new AuraHandledException('An error occurred: '+ex.getMessage());
        }
        }
        
    }
    public void automationAMR(Set<Id> setRequestId ){
        List<Request__c> lstrequest = [SELECT id,Contact__c,Account__c,License__c,Form_JSON__c,Profession__c,Service_Request_Type__c,License_Type__c,Status__c FROM Request__c WHERE Id=: setRequestId ];
        
        if(lstrequest[0].Service_Request_Type__c == 'Update Physical Address')
        {
            updateRequestMailing(lstrequest[0]);
        }
        else
        {
            List<BGCK__Answer__c> lstAnswers = [SELECT Id,Answer_Text__c,License__c,Create_Endorsement_Record__c,Endorsement_Type__c,QuestionDOL__r.Question_Body__c,QuestionDOL__r.Data_Type__c,QuestionDOL__r.Endorsement_Type__c,Question_Section__c,Request__c,QuestionDOL__r.QuestionFieldAPI__c,QuestionDOL__r.Parent_Object_API_Name__c,QuestionDOL__r.QuestionObjectName__c,QuestionDOL__r.RecordType.DeveloperName FROM BGCK__Answer__c where Request__c=:lstrequest[0].Id];
            String objectName;
            List<String> fieldNames = new List<String>();
            for(Service_Request_Automation__mdt sra : [SELECT id,Object_Name__c,Service_Request_Type__c FROM Service_Request_Automation__mdt where Service_Request_Type__c =:lstrequest[0].Service_Request_Type__c]){
                if(sra.Service_Request_Type__c == lstrequest[0].Service_Request_Type__c)
                {
                    objectName = sra.Object_Name__c;   
                }  
            }
            
            for(BGCK__Answer__c ans : [SELECT Id,Answer_Text__c,License__c,Create_Endorsement_Record__c,Endorsement_Type__c,QuestionDOL__r.Question_Body__c,QuestionDOL__r.Data_Type__c,QuestionDOL__r.Endorsement_Type__c,Question_Section__c,Request__c,QuestionDOL__r.QuestionFieldAPI__c,QuestionDOL__r.Parent_Object_API_Name__c,QuestionDOL__r.QuestionObjectName__c,QuestionDOL__r.RecordType.DeveloperName FROM BGCK__Answer__c where Request__c=:lstrequest[0].Id])
            {
                fieldNames.add(ans.QuestionDOL__r.QuestionFieldAPI__c);
            }
            if(!fieldNames.isEmpty() && objectName!=null ){
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
           //     system.debug('query'+query);
                SObject detail = Database.query(query);
                for(BGCK__Answer__c ans : [SELECT Id,Answer_Text__c,License__c,Create_Endorsement_Record__c,Endorsement_Type__c,QuestionDOL__r.Question_Body__c,QuestionDOL__r.Data_Type__c,QuestionDOL__r.Endorsement_Type__c,Question_Section__c,Request__c,QuestionDOL__r.QuestionFieldAPI__c,QuestionDOL__r.Parent_Object_API_Name__c,QuestionDOL__r.QuestionObjectName__c,QuestionDOL__r.RecordType.DeveloperName FROM BGCK__Answer__c where Request__c=:lstrequest[0].Id])
                {
                    detail.put(ans.QuestionDOL__r.QuestionFieldAPI__c,ans.Answer_Text__c);
                }
             //   system.debug('detail--'+detail);
                
                update detail;
        
        if(lstrequest[0].Service_Request_Type__c == 'Update Legal Name' || lstrequest[0].Service_Request_Type__c == 'Update Print Name')
        {
          updateLicensePrintName(lstrequest[0]);
        }                
            }
        }
    }
  
  public void updateLicensePrintName(Request__c request)
  {
    if(request.Service_Request_Type__c == 'Update Legal Name')
    {
    List<MUSW__License2__c> lstLicence = [SELECT id,MUSW__Applicant__c,Print_First_Name__c,Print_Middle_Name__c,Print_Last_Name__c,License_Printable_Name__c,Using_my_legal_name_as_print_name__c FROM MUSW__License2__c WHERE Using_my_legal_name_as_print_name__c=true AND MUSW__Applicant__c =: request.Contact__c];
    Contact con = [SELECT id,FirstName,MiddleName,LastName FROM Contact WHERE id =: request.Contact__c];
    for(MUSW__License2__c lic : lstLicence)
    {      
      lic.License_Printable_Name__c = (con.MiddleName == null)?(con.FirstName+' '+ con.LastName):(con.FirstName+' '+ con.MiddleName+' '+ con.LastName);
            lic.Print_First_Name__c = con.FirstName !=null ? con.FirstName : '';
            lic.Print_Middle_Name__c = con.MiddleName !=null ? con.MiddleName : ' ';
            lic.Print_Last_Name__c = con.LastName !=null ? con.LastName : '';      
    }
    if(!lstLicence.isEmpty())
    {
      update lstLicence;
    }
    }
    else if(request.Service_Request_Type__c == 'Update Print Name')
    {
        List<MUSW__License2__c> lstLicence = [SELECT id,MUSW__Applicant__c,Print_First_Name__c,Print_Middle_Name__c,Print_Last_Name__c,License_Printable_Name__c FROM MUSW__License2__c WHERE id =: request.License__c];
        for(MUSW__License2__c lic : lstLicence)
        {      
            lic.License_Printable_Name__c = (lic.Print_Middle_Name__c == null)?(lic.Print_First_Name__c+' '+ lic.Print_Last_Name__c):(lic.Print_First_Name__c+' '+ lic.Print_Middle_Name__c+' '+ lic.Print_Last_Name__c);                  
        }
        if(!lstLicence.isEmpty())
        {
            update lstLicence;
        }
    }
  }
  
    public void updateRequestMailing(Request__c request)
    {
        MUSW__Parcel__c parcel = [SELECT id FROM MUSW__Parcel__c WHERE Request_Parcel__c=:request.Id];
        List<MUSW__License_Parcel__c> lstLicenseParcel = [SELECT id,MUSW__License2__c,MUSW__Parcel__c,Physical__c,Mailing__c,Status__c FROM MUSW__License_Parcel__c WHERE Status__c='Active' AND Physical__c=true AND MUSW__License2__c=:request.License__c];
        List<MUSW__License_Parcel__c> updatelstLicenseParcel = new List<MUSW__License_Parcel__c>();
        List<MUSW__Parcel__c> updatelstParcel = new List<MUSW__Parcel__c>();
        Set<Id> parcelIds = new Set<Id>();
        for(MUSW__License_Parcel__c licParcel : lstLicenseParcel)
        {
            if(licParcel.Mailing__c)
            {
                licParcel.Physical__c = false;
                parcelIds.add(licParcel.MUSW__Parcel__c);
            }
            else
            {
                licParcel.Status__c = 'Inactive';
            }
            updatelstLicenseParcel.add(licParcel);
            MUSW__License_Parcel__c licenseParcelRecord = new MUSW__License_Parcel__c();
            licenseParcelRecord.MUSW__Parcel__c = parcel.Id;
            licenseParcelRecord.MUSW__License2__c  = request.License__c;
            licenseParcelRecord.Status__c ='Active';
            licenseParcelRecord.Physical__c = true;
            updatelstLicenseParcel.add(licenseParcelRecord);
        }
        if(!parcelIds.isEmpty())
        {
            updatelstParcel = [SELECT id,is_Physical_and_Mailing_Address_Same__c FROM MUSW__Parcel__c WHERE id=:parcelIds];
            for(MUSW__Parcel__c parcelupdate : updatelstParcel )
            {
                parcelupdate.is_Physical_and_Mailing_Address_Same__c = false;
            }
        }
        try{
            if(!updatelstParcel.isEmpty())
            {
                update updatelstParcel;
            }            
            upsert updatelstLicenseParcel; 
        }
        catch(DmlException e){
           // System.debug('Error while inserting new Parcel---' + e.getMessage());
        }
    }
}