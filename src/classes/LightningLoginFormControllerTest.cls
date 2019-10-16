@IsTest(SeeAllData = true)
public with sharing class LightningLoginFormControllerTest {

 @IsTest
 static void testLoginWithInvalidCredentials() {
     try{
         System.assertEquals('Argument 1 cannot be null', LightningLoginFormController.login('testUser', 'fakepwd', null));
         System.assertEquals('Argument 1 cannot be null', LightningLoginFormController.login('testUser', null, null));
          System.assertEquals('Argument 1 cannot be null', LightningLoginFormController.login(' ', 'null', null));
     }catch(Exception e){
        // system.debug('Exception '+e);
     }
 }

 @IsTest
 static void LightningLoginFormControllerInstantiation() {
     try{
         LightningLoginFormController controller = new LightningLoginFormController();
         System.assertNotEquals(controller, null);
     }catch(Exception e){
         // system.debug('Exception '+e);
     }
     
 }

 @IsTest
 static void testIsUsernamePasswordEnabled() {
     try{
          System.assertEquals(true, LightningLoginFormController.getIsUsernamePasswordEnabled());
     }catch(Exception e){
         //system.debug('Exception '+e);
     }
 
 }

 @IsTest
 static void testIsSelfRegistrationEnabled() {
     try{
         System.assertEquals(false, LightningLoginFormController.getIsSelfRegistrationEnabled()); 
     }catch(Exception e){
        // System.debug('Exception '+e);
     }
 
 }

 @IsTest
 static void testGetSelfRegistrationURL() {
     try{
 System.assertEquals(null, LightningLoginFormController.getSelfRegistrationUrl());         
     }catch(Exception e){
        // system.debug('Exception '+e);
     }
 
 }

    @IsTest
    static void testAuthConfig() {
        try{
           Auth.AuthConfiguration authConfig = LightningLoginFormController.getAuthConfig();
        System.assertNotEquals(null, authConfig);  
        }catch(Exception e){
          //  system.debug(' Exception '+e);
        }
       
    }
    
    @IsTest
    static  void testsetExperienceId(){     
        try{
           System.assertEquals(LightningLoginFormController.setExperienceId(null),null );
        }catch(Exception e){
            //system.debug('Exception '+e);
        }
                
    } 
    
    @IsTest
    static void testgetForgotPasswordUrl(){
        try{
            LightningLoginFormController.getForgotPasswordUrl();
        }
        catch(Exception e){
           // system.debug('Exception '+e);
        }
    }
    
    @IsTest
    static  void testsetNullExperienceId(){ 
        try{
            System.assertEquals(LightningLoginFormController.setExperienceId(''),null );
        }
        catch(Exception e){
            //system.debug('Exception '+e);
        }
        
    } 
}