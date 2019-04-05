/**
* User Story: 88 - Allow applicant to submit another initial application for the same application type
* Class Name: AllowToCreateAnotherApplication
* Test Class Name: AllowToCreateAnotherApplication_Test
* Description: Class to check if an existing credential application exists, then prevent the user from creating a new one
* Date:        Developer/Company                    Description
* ---------------------------------------------------------------------------------------------------------------------------------------- *
* 07/27/2018   Sharad Maheshwari/Deloitte           Initial Creation
**/
public class AllowToCreateAnotherApplication {
    
    boolean allowToCreateAnotherApplication = true;
    
    public boolean AllowToCreateAnotherApplication(String applicant, 
                                                   String applicationType, 
                                                   String credentialTypeOrProgramArea, 
                                                   String credentialOrPermitType, 
                                                   String applicationMethod,
                                                   String primaryLicensee){
        System.debug('applicant '+applicant);
        System.debug('primaryLicensee '+primaryLicensee);
                                                       
                                                       
		String query = 'SELECT Id, Name, Application_Type__c, Credential_Type__c, Credential__c, Application_Method__c, MUSW__Status__c, MUSW__Expiration_Date__c '+
                       'FROM MUSW__License2__c '+
                       'WHERE Application_Type__c = '+ '\'' +applicationType + '\'' +
                       ' AND Credential_Type__c = '+ '\'' +credentialTypeOrProgramArea + '\'' +
                       ' AND Credential__c = '+ '\'' +credentialOrPermitType + '\'' +
                       ' AND (MUSW__Applicant__c = '+ '\'' +applicant + '\'';
                                                       if(primaryLicensee != null){
                                                           query = query + ' OR MUSW__Primary_Licensee__c =:primaryLicensee)'; 
                                                       }else{
                                                           query = query + ')'; 
                                                       }
		System.debug('QUERY is '+query);                                                                             
        if(applicationType == 'Trades Credential'){
            System.debug('in trades credential');
        	
            List<MUSW__License2__c> existingCredentialsList = new List<MUSW__License2__c>();
            
            existingCredentialsList = Database.query(query);
                /*[SELECT Id, Name, Application_Type__c, Credential_Type__c, Credential__c, Application_Method__c, MUSW__Status__c, MUSW__Expiration_Date__c
                                      FROM MUSW__License2__c
                                      WHERE Application_Type__c = :applicationType
                                      AND Credential_Type__c = :credentialTypeOrProgramArea
                                      AND Credential__c = :credentialOrPermitType
                                      AND (MUSW__Applicant__c =:applicant
                                      OR MUSW__Primary_Licensee__c =:primaryLicensee)
                                      ];*/
            
            System.debug('existingCredentialsList '+existingCredentialsList);
            for (MUSW__License2__c credentialList: existingCredentialsList){
                
                if(credentialList.MUSW__Status__c == Label.ST_Pending || 
                   credentialList.MUSW__Status__c == Label.ST_Submitted || 
                   credentialList.MUSW__Status__c == Label.ST_Active || 
                   credentialList.MUSW__Status__c == Label.ST_Expired || 
                   credentialList.MUSW__Status__c == Label.ST_Generate_Fee){
                       System.debug('credentialList '+credentialList);
                       System.debug('credentialList.MUSW__Status__c '+credentialList.MUSW__Status__c);
                    allowToCreateAnotherApplication = false;
            }
            }            
            return allowToCreateAnotherApplication;
        } else if((applicationType == 'Manufactured Homes' && credentialTypeOrProgramArea == 'Manufactured Homes Credential')){
            System.debug('MH Credential');
        	
            List<MUSW__License2__c> existingCredentialsList = new List<MUSW__License2__c>();
            existingCredentialsList = Database.query(query);
            /*existingCredentialsList = [SELECT Id, Name, Application_Type__c, Credential_Type__c, Credential__c, Application_Method__c, MUSW__Status__c, MUSW__Expiration_Date__c
                                      FROM MUSW__License2__c
                                      WHERE Application_Type__c = :applicationType
                                      AND Credential_Type__c = :credentialTypeOrProgramArea
                                      AND Credential__c = :credentialOrPermitType
                                      AND (MUSW__Applicant__c =:applicant
                                      OR MUSW__Primary_Licensee__c =:primaryLicensee)
                                      ];*/
            System.debug('existingCredentialsList '+existingCredentialsList);
            for (MUSW__License2__c credentialList: existingCredentialsList){
                
                if(credentialList.MUSW__Status__c == Label.ST_Pending || 
                   credentialList.MUSW__Status__c == Label.ST_Submitted || 
                   credentialList.MUSW__Status__c == Label.ST_Active || 
                   credentialList.MUSW__Status__c == Label.ST_Generate_Fee){
                       System.debug('credentialList '+credentialList);
                       System.debug('credentialList.MUSW__Status__c '+credentialList.MUSW__Status__c);
                    allowToCreateAnotherApplication = false;
            }
            }            
            return allowToCreateAnotherApplication;
        }
        else if(applicationType == 'Delegated Municipality'){
            System.debug('Delegated Municipality');
        	
            List<MUSW__License2__c> existingCredentialsList = new List<MUSW__License2__c>();
            
            existingCredentialsList = Database.query(query);
            /*existingCredentialsList = [SELECT Id, Name, Application_Type__c, Credential_Type__c, Credential__c, Application_Method__c, MUSW__Status__c, MUSW__Expiration_Date__c
                                      FROM MUSW__License2__c
                                      WHERE Application_Type__c = :applicationType
                                      AND Credential_Type__c = :credentialTypeOrProgramArea
                                      AND Credential__c = :credentialOrPermitType
                                      AND (MUSW__Applicant__c =:applicant
                                      OR MUSW__Primary_Licensee__c =:primaryLicensee)
                                      ];
            */
            System.debug('existingCredentialsList '+existingCredentialsList);
            for (MUSW__License2__c credentialList: existingCredentialsList){
                
                if(credentialList.MUSW__Status__c == Label.ST_Pending || 
                   credentialList.MUSW__Status__c == Label.ST_Submitted || 
                   credentialList.MUSW__Status__c == Label.ST_Active){
                       System.debug('credentialList '+credentialList);
                       System.debug('credentialList.MUSW__Status__c '+credentialList.MUSW__Status__c);
                    allowToCreateAnotherApplication = false;
            }
            }            
            return allowToCreateAnotherApplication;
        }
        else if(applicationType == 'Manufactured Homes' && credentialTypeOrProgramArea == 'Manufactured Homes Titling'){
            System.debug('MH titling');
            return allowToCreateAnotherApplication;
        }else if(applicationType == 'Plan Review'){
            System.debug('Plan Review');
            return allowToCreateAnotherApplication;
        }
        else if(applicationType == 'Permit to Operate'){
            System.debug('Permit to Operate');
            return allowToCreateAnotherApplication;
        }
        
        return allowToCreateAnotherApplication;
        
        
        
        
    }
    
    /*
            List<Allow_to_create_another_application__mdt> conditionsList = new List<Allow_to_create_another_application__mdt>();
            
            conditionsList = [SELECT Application_Type__c, Credential_Type__c, Credential__c, Application_Method__c, Status__c
                               FROM Allow_to_create_another_application__mdt
                               WHERE Application_Type__c = :applicationType
                               AND Credential_Type__c = :credentialTypeOrProgramArea
                               AND Credential__c = :credentialOrPermitType
                               //AND Application_Method__c = :applicationMethod 
                               ];
            integer incrementCounter = 0;
            integer decrementCounter = 0;
            integer conditionSatisfied = 0;
            integer conditionNotSatisfied = 0;
            integer licenseCountSatisfyingConditions = 0;
            integer licenseCountNotSatisfyingConditions = 0;
            if(!existingCredentialsList.isEmpty() && !conditionsList.isEmpty()){
                
            
            for (MUSW__License2__c credentialList: existingCredentialsList){
                
                if(licenseCountNotSatisfyingConditions > 0){
                    break;                        
                    }
                
                for(Allow_to_create_another_application__mdt cList: conditionsList){
                    
                    if(cList.Status__c != null && cList.Status__c == credentialList.MUSW__Status__c){
                        //System.debug('in first if status matches');
                        incrementCounter++;
                    }else if (cList.Status__c != null && cList.Status__c != credentialList.MUSW__Status__c){
                        //System.debug('in else if status does not matches');
                        decrementCounter++;
                    }
                    
                    //if(cList.MUSW__Expiration_Date__c != null && cList.MUSW__Expiration_Date__c == credentialList.MUSW__Expiration_Date__c){
                     //   allowToCreateAnotherApplication = true;
                    //}  
                    
                    if(decrementCounter == 0 && incrementCounter > 0){
                        //System.debug('in decrementCounter == 0 && incrementCounter > 0');
                        conditionSatisfied++;
                        
                    }else if(decrementCounter > 0){
                        conditionNotSatisfied++;
                    }
                    
                    incrementCounter = 0;
            		decrementCounter = 0;
                    
                }
                
                if(conditionNotSatisfied > 0){                    
                    licenseCountNotSatisfyingConditions++;
                    break;
                    //do not allow creation of another application
                    
                }else if(conditionSatisfied > 0){
                    licenseCountSatisfyingConditions++;
                    conditionSatisfied = 0;
                    conditionNotSatisfied = 0;    
                    //move on to check the next license
                   	
                }
                
            }
        }
            if(licenseCountNotSatisfyingConditions > 0){
                    //System.debug('in conditionSatisfied > 0 - first');
                        allowToCreateAnotherApplication = false;
                    }
            */
            //System.debug('before return '+ allowToCreateAnotherApplication);

}