public class Polaris_RelationshipsUtilty {
     
    @AuraEnabled 
    public static Polaris_RelationshipsUtilty.resultWrapper removeAssociationRecord(String associationId)
    {
        Polaris_RelationshipsUtilty.resultWrapper result;
        
        Database.SaveResult sr;
        
        Associations__c association = [SELECT id, Status__c,End_Date__c,Child_License__r.MUSW__Applicant__c FROM Associations__c where id=:associationId ];
        
         
        
        if(association != null ){
            
            association.Status__c = DOL_AppConstants.NULL_EMPTY_STRING + 'Canceled';
            
            association.End_Date__c = system.today();
            
            sr = Database.update(association,false);
             
            if(sr.isSuccess()){
                
              result =  new Polaris_RelationshipsUtilty.resultWrapper(True,'The association has been successfully removed');
              
                List<task> task = [select id,Whatid,Status from task where Whatid=:association.Id limit 1];
                
                if(!task.isEmpty()){
                    
                  task[0].Status = DOL_AppConstants.NULL_EMPTY_STRING + 'Completed';
              }
              
              update task;
                
            }else{
            
             String Errormessage = DOL_AppConstants.NULL_EMPTY_STRING + 'Please contact system administrator\n';
             
             for(Database.Error err: sr.getErrors()){
                 
                 Errormessage = Errormessage+err.getFields()+' '+err.getMessage()+' '+err.getStatusCode()+'\n';
                 break;
             }
                
              result =  new Polaris_RelationshipsUtilty.resultWrapper(False,Errormessage);
            }
        }else{
            
           result  = new Polaris_RelationshipsUtilty.resultWrapper(false,'Please contact system administrator');
        }
        return result; 
    }
    
    @AuraEnabled 
    public static Polaris_RelationshipsUtilty.resultWrapper updateAssociationRecord(String associationId,String statusOfAssociation)
    {
        Polaris_RelationshipsUtilty.resultWrapper result;
        
        Database.SaveResult sr;
        
        Associations__c association = [SELECT id, Status__c,End_Date__c,Child_License__r.MUSW__Applicant__c FROM Associations__c where id=:associationId ];
        
         
        
        if(association != null && statusOfAssociation == 'Cancel' && statusOfAssociation == 'resend' && statusOfAssociation == 'remove'){
            
            if(statusOfAssociation == 'Cancel'){
                
                association.Status__c = DOL_AppConstants.NULL_EMPTY_STRING + 'Declined';
            }
            if(statusOfAssociation == 'resend'){
                
                association.Status__c = DOL_AppConstants.NULL_EMPTY_STRING + 'Invited';
            }
            if(statusOfAssociation == 'remove'){
                
                association.Status__c = DOL_AppConstants.NULL_EMPTY_STRING + 'Deleted';
            }
            
            sr = Database.update(association,false);
             
            if(sr.isSuccess()){
                
              result =  new Polaris_RelationshipsUtilty.resultWrapper(True,'The Operation has been successfull');
              
                List<task> task = [select id,Whatid,Status from task where Whatid=:association.Id limit 1];
                
                if(!task.isEmpty() && statusOfAssociation != 'resend'){
                    
                  task[0].Status = DOL_AppConstants.NULL_EMPTY_STRING + 'Completed';
                  
                  
              }
              if(!task.isEmpty() && statusOfAssociation == 'resend'){
                    
                  task[0].Status = DOL_AppConstants.NULL_EMPTY_STRING + 'Pending';
                  
                  
              }
              
              update task;
                
            }else{
            
             String Errormessage = DOL_AppConstants.NULL_EMPTY_STRING + 'Please contact system administrator\n';
             
             for(Database.Error err: sr.getErrors()){
                 
                 Errormessage = Errormessage+err.getFields()+' '+err.getMessage()+' '+err.getStatusCode()+'\n';
                 break;
             }
                
              result =  new Polaris_RelationshipsUtilty.resultWrapper(False,Errormessage);
            }
        }else{
            
           result  = new Polaris_RelationshipsUtilty.resultWrapper(false,'Please contact system administrator');
        }
        return result; 
    }
    
    @AuraEnabled 
    public static Polaris_RelationshipsUtilty.resultWrapper removeAffliationRecord(String affliationId)
    {
        Polaris_RelationshipsUtilty.resultWrapper result;
        
        Database.SaveResult sr;
        
        MUSW__Account_Contact__c accountContact = [SELECT id, Status__c FROM MUSW__Account_Contact__c where id=:affliationId LIMIT 1];
        
        if(accountContact != null ){
            
           accountContact.Status__c = DOL_AppConstants.NULL_EMPTY_STRING + 'Deleted';
           
           sr = Database.update(accountContact,false);
           
            if(sr.isSuccess()){
                
              result =  new Polaris_RelationshipsUtilty.resultWrapper(True,'The association has been successfully removed');
              
                 List<task> task = [select id,Whatid,Status from task where Whatid=:accountContact.Id limit 1];
                
                    if(!task.isEmpty()){
                        
                      task[0].Status = DOL_AppConstants.NULL_EMPTY_STRING + 'Completed';
                  }
              
                  update task;
                
            }else{
            
             String Errormessage = DOL_AppConstants.NULL_EMPTY_STRING + 'Please contact system administrator'+'\n';
             
             for(Database.Error err: sr.getErrors()){
                 
                 Errormessage = Errormessage+err.getFields()+' '+err.getMessage()+' '+err.getStatusCode()+'\n';
                 break;
             }
                
              result =  new Polaris_RelationshipsUtilty.resultWrapper(False,Errormessage);
            }
        }else{
            
           result  = new Polaris_RelationshipsUtilty.resultWrapper(false,'Please contact system administrator');
        }
        return result;  
    }
    
    public class resultWrapper{
        
        public boolean isSuccess;
        
        public String message;
        
        resultWrapper(boolean isSuccess, String Message){
            
            this.isSuccess = isSuccess;
            
            this.message = Message;
        }
    }
}