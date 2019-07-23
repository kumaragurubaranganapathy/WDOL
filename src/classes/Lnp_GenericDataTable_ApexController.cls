public without sharing class Lnp_GenericDataTable_ApexController {         
    @AuraEnabled
    public static List<Sobject> getSobjectData(List<String> soqlFields,String sObjectName,String BusinessFunction,String queryId){
        List<sObject> sObjList;
       if(BusinessFunction == 'Draft Maintance Request'){
         sObjList   = [Select  id,License_Type__c, Service_Request_Type__c
                                     from Request__c
                                     where Status__c = 'Under Review' AND Contact__c in(Select ContactId From User Where Id =: UserInfo.getUserId())];
            
         }else if(BusinessFunction == 'Account Contact'){
           
          sObjList =[select id,Name,Role__c,Full_Name__c,Email__c,isAdminContact__c,Status__c,resend_Invitation__c from MUSW__Account_Contact__c where MUSW__Account__c =: queryId and Status__c != 'Deleted']; 
        }else if(BusinessFunction == 'ProfessionalRelationshipData'){
           
          sObjList =[select id,Name,Title__c,Role__c,Full_Name__c,Email__c,isAdminContact__c,Status__c,resend_Invitation__c from MUSW__Account_Contact__c where MUSW__Contact__c =: queryId and Status__c != 'Deleted']; 
        }else if(BusinessFunction == 'License Relationship'){
            sObjList =[select id,Name,Parent_License__c,Child_Licensee_Name__c,Association_Type__c,Child_Contact_Name__c,Child_Contact__c,Child_License__c,Child_License_Type__c,Child_License_Name__c,Status__c,resend_Invitation__c from Associations__c where Parent_License__c =: queryId and Status__c != 'Deleted']; 
        }else if(BusinessFunction == 'Business-License'){
             Id businessRT = SObjectType.MUSW__License2__c.getRecordTypeInfosByDeveloperName().get('Business').getRecordTypeId();
            sObjList =[select id,Name,Application_Type__c,Credential_Type__c,MUSW__Expiration_Date__c,MUSW__Status__c,Sub_Status__c from MUSW__License2__c where Ultimate_Parent_Account__c =:queryId and recordTypeId=:businessRT];
        }
         if(sObjList!= null && !sObjList.isEmpty()){
             return sObjList;
         }else{
             return null;
         }
         

    }
    
    public class DataTableColumnWrapper{
        String label;
        String fieldName;
        String type;
        typeAttributeWrapper typeAttributes;
        
        public DataTableColumnWrapper(String label,String fieldName, String type,typeAttributeWrapper typeAttributes){
            this.label =label;
            this.fieldName = fieldName;
            this.type = type;
            this.typeAttributes = typeAttributes;
        }
        
    }
    
    public class typeAttributeWrapper{
        public List<actionListWrapper> rowActions;
        
        typeAttributeWrapper(){
            rowActions = new List<actionListWrapper>();
        }
        
        public void addAction(actionListWrapper action){
            this.rowActions.add(action);
        } 
    }
    
    public class actionListWrapper{
        String label;
        String name;
        actionListWrapper(String label,String name){
            this.label = label;
            this.name = name;
        }
    }
    
    @AuraEnabled 
    public static Boolean removeRecord(MUSW__Account_Contact__c accConId,string action){
      try{
      List<task> tsk = [select id,Whatid,Status from task where Whatid=:accConId.id limit 1];
      
      System.debug('accConId::'+accConId);
         if(action == 'Remove'){
              accConId.Status__c = 'Deleted';
              if(!tsk.isEmpty()){
                  tsk[0].Status = 'Completed';
              }
              
          }else if(action == 'Resend'){
              accConId.Status__c ='Invited';
              accConId.invitation_send_date__c = system.today();
              if(!tsk.isEmpty()){
              tsk[0].Status = 'Pending';
              }
          }
          update accConId;
          if(!tsk.isEmpty()){
            update tsk;
          }
          return true;
      }catch(Exception e){
          system.debug('exception::'+e.getmessage());
          return false;
      } 
       
    }    
    @AuraEnabled 
    public static MUSW__License2__c fetchLicenseDetails(String licenseID)
    {
        return [SELECT id,Credential_Type__c,No_of_Associations__c FROM MUSW__License2__c WHERE id=:licenseID];
    }
    
    @AuraEnabled 
    public static Boolean removeAssociationRecord(Associations__c accConId,string action){
      try{
      List<task> tsk = [select id,Whatid,Status from task where Whatid=:accConId.id limit 1];
      
      System.debug('accConId::'+accConId);
         if(action == 'Remove'){
              accConId.Status__c = 'Canceled';
              if(!tsk.isEmpty()){
                  tsk[0].Status = 'Completed';
              }
              
          }else if(action == 'Resend'){
              accConId.Status__c ='Invited';
              accConId.invitation_send_date__c = system.today();
              if(!tsk.isEmpty()){
              tsk[0].Status = 'Pending';
              }
          }
          update accConId;
          if(!tsk.isEmpty()){
            update tsk;
          }
          return true;
      }catch(Exception e){
          system.debug('exception::'+e.getmessage());
          return false;
      } 
       
    }
    @AuraEnabled
    public static Boolean createTask(Id accountContact,String Email){
        MUSW__Account_Contact__c accList = [select id,Name,MUSW__Account__r.Name,Email__c  from MUSW__Account_Contact__c where id =:accountContact];
        try{
        task t = new task();
        t.Whatid = accountContact;
        t.Status = 'Pending';
        t.Email__c = Email;
        t.Subject = 'Invitation to be a Business Admin';
        t.Type = 'Contact Relationship';
           t.Business_Name__c = accList.MUSW__Account__r.Name;
        insert t;
        return true;
      }catch(Exception e){
          System.debug(e.getMessage());
          return false;
      }
    }
     @AuraEnabled
    public static Boolean createAssociationTask(Id associationID){
        Associations__c association = [SELECT id, Association_Type__c,Parent_License__r.MUSW__Applicant__c,Parent_License__r.Application_Type__c,Parent_License__r.Credential_Type__c,Parent_License__r.Name,Child_License__r.Application_Type__c,Child_License__r.Credential_Type__c,Child_License__r.Name,Child_License__r.MUSW__Applicant__c FROM Associations__c where id=:associationID ];
        Contact childcon = [Select id,Email,Full_Name__c FROM Contact where id=:association.Child_License__r.MUSW__Applicant__c];
        Contact parentcon = [Select id,Email,Full_Name__c FROM Contact where id=:association.Parent_License__r.MUSW__Applicant__c];
        try{
        task t = new task();
        t.Whatid = associationID;
        t.Status = 'Pending';
        t.Email__c = childcon.Email;
        t.Subject = 'Invitation to get asociated to a Business License';
        t.Type = 'License Relationship';
          t.Designation__c =  association.Association_Type__c;
            t.Child_Licensee_Name__c =  childcon.Full_Name__c;
            t.Child_License_Name__c =  association.Child_License__r.Name;
            t.Child_License_Type__c =  association.Child_License__r.Credential_Type__c;
            t.Child_Profession__c =  association.Child_License__r.Application_Type__c;
            t.Parent_Licensee_Name__c =  parentcon.Full_Name__c;
            t.Parent_License_Name__c =  association.Parent_License__r.Name;
            t.Parent_License_Type__c =  association.Parent_License__r.Credential_Type__c;
            t.Parent_Profession__c =  association.Parent_License__r.Application_Type__c;
           	t.Child_License_Id__c = association.Child_License__c;
        insert t;
        return true;
      }catch(Exception e){
          System.debug(e.getMessage());
          return false;
      }
    }

}