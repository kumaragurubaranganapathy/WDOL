/**
* User Story: 108 - Promote user, to a business user, by creating an account on the portal
* Class Name: BusinessUtility
* Test Class Name: BusinessUtility_Test
* Description: This class serves as Utility class for AddBusiness_CC
* Date:            Developer/Company                    Description
* ---------------------------------------------------------------------------------------------------------------------------------------- *
* 08/01/2018    Srikanth Kottam/Deloitte           	  Initial Creation
**/
public with sharing class BusinessUtility {
	
    public static String EMAIL_SERVICE_ADDRESS;
    public static final String COMMUNITY_PLUS_PROFILE = 'eSLA Customer Community Plus Login User' ;
   // public static final String COMMUNITY_PLUS_PROFILE = 'eSLA Customer Community Login User' ;
    public static final String OWD_EMAIL_ADDRESS = System.Label.Str_OWD_Email;
    public static final String COMMUNITY_SUCCESSOR_USER = System.Label.Str_SuccessorForDeactivatedUser ;
     
     public class AccountJunctionResult 
     {
        public Account businessAccount {get;set;}
        public MUSW__Account_Contact__c acJunction {get;set;}
        public List<Parcel_Account__c> paJunctions {get;set;}
        public Boolean isSuccess {get;set;}
        
        public AccountJunctionResult(Account newAcc ,List<Parcel_Account__c>  paJunctions ,  MUSW__Account_Contact__c  junction ) 
        {
            businessAccount = newAcc ;
            acJunction = junction ;
            paJunctions = new List<Parcel_Account__c>() ;
            paJunctions.addAll(paJunctions);
            isSuccess = true ;
        }
     }
    public class NewBusiness
    {
        public String registeredAs {get;set;}
        public String accountName {get;set;}
        public String contactId {get;set;}
        public String firmCertificate{get;set;}
        public String contactPerson {get;set;}
        
        public String contactPersonFirstName {get;set;}
        public String contactPersonLastName {get;set;}
        
        public String FEINNumbersole {get;set;}
        public String SSNNumber {get;set;}
        public String website {get;set;}
        public String phoneNumber{get;set;}
        public String fax{get;set;}
        public String UBINumber{get;set;}			//Dharan Shah -- adding UBI number for Business Account -- 03/26
        public String extension {get;set;}		//Dharan Shah -- adding Extension for Business Account -- 03/27
        public String businessPhone {get;set;}	//Dharan Shah -- adding Business Phone for Business Account -- 03/27
        public String email{get;set;}
        public String primaryContactEmail{get;set;}
        public String businessAlias{get;set;}
        public String DoingbusinessAs{get;set;}
        public String primaryParcelId {get;set;}
        public String mailingParcelId {get;set;}
    } 
    
    public class UserPromotion
    {
        public String contactId {get;set;}
        public String currentUserId {get;set;}
        public String currentUserProfileId {get;set;}
        public String firstName {get;set;}
        public String lastName {get;set;}
        public String email {get;set;}
        public String newAccountId {get;set;}
        public Boolean isSharingRequired {get;set;}
    }
    
    public class NewBusinessUserPromoCombo
    {
        public NewBusiness newBus {get;set;}
        public UserPromotion uPromo {get;set;}
        public String executionScenario {get;set;}
        
        public NewBusinessUserPromoCombo(NewBusiness nBusIn , UserPromotion uPromoIn , String exScenario  )
        { 
            
            newBus = nBusIn ;
            system.debug('newbus@75'+newBus);
            uPromo = uPromoIn ;
            executionScenario = exScenario ;
        }
    }
    
    public static User getUserDetails(String userId , String profileId )
    {
        User retRec = null ;
        List<User> users = [Select Id, 
                                Name, 
                                Email, 
                                FirstName, 
                                LastName, 
                                UserName, 
                                ContactId, 
                                Contact.AccountId ,
                                Alias,
                                CommunityNickname ,
                                MUSW__Successor__c
                                From User where  ID = : userId AND ProfileId =: profileId AND isActive = true  ] ;
       if(users != null && users.isEmpty() == false )
       {
            retRec = users[0];
       }         
       
       return retRec ;
     }
     public static Database.SaveResult upgradeCommunityUser(User uRec, BusinessUtility.UserPromotion uPromo , BusinessUtility.NewBusiness nBusiness , String exScenario)
     {
         Database.SaveResult retRes = null ;
         string commPlusProfileId = [Select Id, Name From Profile Where Name = :COMMUNITY_PLUS_PROFILE LIMIT 1][0].Id;
         uRec.ProfileId = commPlusProfileId;
         system.debug('ProfileId>>>>>>>>>>'+commPlusProfileId);
         retRes = Database.update(uRec) ;
         system.debug('Update User comments>>>>>>>>>'+retRes);
         return retRes;
     }
    
     public static Database.SaveResult deactivateCommunityUser(User uRec)
     {
        uRec.FirstName = 'Old-' + uRec.FirstName ;
        uRec.UserName = Math.random() + '-' + uRec.UserName  ; 
        uRec.MUSW__Successor__c = COMMUNITY_SUCCESSOR_USER;
        uRec.isActive = false ;
        transient string tempNickName = String.valueOf(Math.random()) + '-' + uRec.CommunityNickname  ;
        if(tempNickName.length() > 30 )
        {
            tempNickName = tempNickName.substring(2,30) ;
        }
        
        uRec.CommunityNickname = tempNickName ;
         
        uRec.IsPortalEnabled = false ;

        return Database.update(uRec) ;
     }
     
     public static Database.SaveResult createCommunityPlusUser(BusinessUtility.UserPromotion uPromo , BusinessUtility.NewBusiness nBusiness , String exScenario)
     {
          system.debug('Processing started ------------' + exScenario ) ;
          system.debug(' ------------' + uPromo ) ;
          system.debug(' ------------' + nBusiness ) ;
          
          Database.SaveResult retRes = null ;
          string commPlusProfileId = [Select Id, Name From Profile Where Name = :COMMUNITY_PLUS_PROFILE LIMIT 1][0].Id;
          // Now create new User Record 
          User usr = new User();
          usr.Username = uPromo.email; 
          usr.Email = uPromo.email;
          usr.FirstName = uPromo.firstName;
          usr.LastName = uPromo.lastName;
          usr.ContactId = uPromo.ContactId;
          usr.ProfileId = commPlusProfileId; 
          transient string tempNickName = String.valueOf(Math.random()) + '-' + uPromo.lastName  ;
            if(tempNickName.length() > 30 )
            {
                tempNickName = tempNickName.substring(2,30) ;
            }
          usr.CommunityNickname = tempNickName ; 

          usr.Alias = uPromo.firstName + uPromo.lastName;
          if(usr.Alias.length() > 5){
            usr.Alias = usr.Alias.substring(0,5);
          }
          
          usr.languagelocalekey='en_US';
          usr.localesidkey='en_US';
          usr.timezonesidkey='America/New_York';
          usr.emailencodingkey='UTF-8';
          retRes =  Database.INSERT(usr ) ;
          
          if(retRes.isSuccess())
          {
            //create account contact parcel object here 
            if(exScenario == 'SecurityCode')
            { 
                MUSW__Account_Contact__c ac = new MUSW__Account_Contact__c();
                ac.MUSW__Account__c = uPromo.newAccountId;
                ac.MUSW__Contact__c = uPromo.contactId ;
                ac.Associate_Status__c = label.ST_Active ;
                insert ac;
            }else if(exScenario == 'BrandNewBusiness')
            {
                handleAccountContactJunctionOperation(nBusiness) ;
            }
          } 
          
          return retRes  ;
     }
     
     public static Messaging.SendEmailResult sendMessageForEmailService(String event , NewBusinessUserPromoCombo comboIn )
     {
        Messaging.SendEmailResult retRes = null ;
        List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();
         SYSTEM.DEBUG('OWD_EMAIL_ADDRESS'+OWD_EMAIL_ADDRESS);
        String owdEmail = [Select Id from OrgWideEmailAddress Where Address = : OWD_EMAIL_ADDRESS limit 1 ].Id ;
        
        String messageSubject = event ;
        String messageBody = JSON.serialize(comboIn) ; 
        
        // Get Email service address
        List<EmailServicesAddress> delicateAdminaddress = [Select EmailDomainName from EmailServicesAddress where LocalPart = 'deligateemailservice']; 
         if(delicateAdminaddress.size() > 0){
             EMAIL_SERVICE_ADDRESS = 'delegateadminemailservice@' + delicateAdminaddress[0].EmailDomainName;
         }else if(Test.isRunningTest()){
            EMAIL_SERVICE_ADDRESS = 'test@salesforce.com';
         }
        system.debug('EMAIL_SERVICE_ADDRESS>>>>>'+EMAIL_SERVICE_ADDRESS);
        if(messageBody != null && messageSubject != null )
        {
            Messaging.reserveMassEmailCapacity(1);
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setOrgWideEmailAddressId(owdEmail) ;
            mail.Setsubject(messageSubject) ;
            mail.SetplainTextBody( messageBody) ;
           // mail.setCCAddresses(new String[]{'skottam@deloitte.com'});
            mail.setToAddresses(new string[]{EMAIL_SERVICE_ADDRESS}) ;
            emails.add(mail);
            system.debug('Emails in Normal Method>>>>'+emails);
        }
        
        if(emails != null && emails.isEmpty() == false )
        {
            List<Messaging.SendEmailResult> result = Messaging.sendEmail(emails);
            retRes = result[0] ;
            system.debug('Email error>>>'+retRes);
        }
        
        system.debug('Subject line ------' + messageSubject ) ;
        system.debug('Mail body -----' + messageBody ) ;
        system.debug('Email =====' + emails ) ;
        
        return retRes ;
     }
     
     @Future
     public static void sendMessageForEmailService(String event , String comboIn )
     {
        Messaging.SendEmailResult retRes = null ;
        List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();
        String owdEmail = [Select Id from OrgWideEmailAddress Where Address = : OWD_EMAIL_ADDRESS limit 1 ].Id ;
        
        String messageSubject = event ;
        String messageBody = comboIn; 
         
        // Get Email service address
        List<EmailServicesAddress> delicateAdminaddress = [Select EmailDomainName from EmailServicesAddress where LocalPart = 'delegateadminemailservice']; 
         if(delicateAdminaddress.size() > 0){
             EMAIL_SERVICE_ADDRESS = 'delegateadminemailservice@' + delicateAdminaddress[0].EmailDomainName;
         }else if(Test.isRunningTest()){
            EMAIL_SERVICE_ADDRESS = 'test@salesforce.com';
         }
         system.debug('EMAIL_SERVICE_ADDRESS>>>>>'+EMAIL_SERVICE_ADDRESS);
        if(messageBody != null && messageSubject != null )
        {
            Messaging.reserveMassEmailCapacity(1);
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setOrgWideEmailAddressId(owdEmail) ;
            mail.Setsubject(messageSubject) ;
            mail.SetplainTextBody( messageBody) ;
            mail.setToAddresses(new string[]{EMAIL_SERVICE_ADDRESS}) ;
            emails.add(mail);
            system.debug('Emails in Future Method>>>>'+emails);
        }
        
        if(emails != null && emails.isEmpty() == false )
        {
            List<Messaging.SendEmailResult> result = Messaging.sendEmail(emails);
            retRes = result[0] ;
            system.debug('Email error>>>'+retRes);
        }
        
        system.debug('Subject line @Future ------' + messageSubject ) ;
        system.debug('Mail body @Future-----' + messageBody ) ;
        system.debug('Email @Future=====' + emails ) ;
        
     } 
    public static Boolean createAccountContactJunction(BusinessUtility.UserPromotion uPromo){
        Boolean result = false;
        
        try{
            MUSW__Account_Contact__c ac = new MUSW__Account_Contact__c();
            ac.MUSW__Account__c = uPromo.newAccountId;
            ac.MUSW__Contact__c = uPromo.contactId ;
            ac.Associate_Status__c = 'Active' ;
            insert ac;
            
            result = true;
        }catch(Exception e){
            result = false;
        }
        
        return result;
    }
    
     public static AccountJunctionResult handleAccountContactJunctionOperation(BusinessUtility.NewBusiness newBusiness)
     {
        system.debug('------' + newBusiness );
        AccountJunctionResult retRes ;
        Account newAcc = new Account();
        newAcc.Name = newBusiness.accountName;
        newAcc.Type_of_Ownership__c = newBusiness.registeredAs;
        newAcc.Business_Alias__c = newBusiness.businessAlias ;
        newAcc.First_Name_Primary_Contact__c = newBusiness.contactPersonFirstName;
        newAcc.Last_Name_Primary_Contact__c = newBusiness.contactPersonLastName;
        newAcc.Doing_Business_As_1__c = newBusiness.DoingbusinessAs;
        newAcc.Website = newBusiness.website;
        newAcc.Phone_Primary_Contact__c = newBusiness.phoneNumber;
        newAcc.Fax = newBusiness.fax;
        newAcc.UBI_Number__c = newBusiness.UBINumber;		//Dharan Shah -- adding UBI Number for Business Account -- 03/26
        newAcc.Extension__c = newBusiness.extension;		//Dharan Shah -- adding Extension for Business Account -- 03/27
        newAcc.Business_Phone__c = newBusiness.businessPhone;		//Dharan Shah -- adding Business Phone for Business Account -- 03/27
        newAcc.Email__c = newBusiness.email;
        newAcc.Email_Primary_Contact__c = newBusiness.primaryContactEmail;
       // newAcc.Created_By_Contact__c = newBusiness.contactId;
       newAcc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Business Account').getRecordTypeId() ;
        newAcc.FEIN_Number_Encrypted__c = newBusiness.FEINNumbersole; 
      //  newAcc.Social_Security_Number__c = newBusiness.SSNNumber;
        newAcc.Social_Security_Number_Encrypted__c =  newBusiness.SSNNumber;
        Contact c = null;
      /*  if(newBusiness.contactId != null){
            c = [Select id, RecordTypeId from Contact where id=:newBusiness.contactId];
            if(c.RecordTypeId == Schema.SObjectType.Contact.getRecordTypeInfosByName().get(label.RT_Casino_Contact).getRecordTypeId()){
                newAcc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get(label.RT_Casino_Business_Account).getRecordTypeId() ;
            }
        } */
         system.debug('utility @ 313'+newAcc);
        insert newAcc; 
        system.debug('Insert New Account>>>>>>>'+newAcc);
        // Also Update both Parcel records with Primary Account
        Set<MUSW__Parcel__c> parcels = new Set<MUSW__Parcel__c>();
        
        // Create Address junctions 
         List<Parcel_Account__c> paJunctions = new List<Parcel_Account__c>() ;
         if(newBusiness.primaryParcelId != null && newBusiness.primaryParcelId instanceof ID)
         {
             Parcel_Account__c pa = new Parcel_Account__c();
             pa.Account__c = newAcc.Id;
             pa.Parcel__c =newBusiness.primaryParcelId;
             pa.Primary__c = true ;
             paJunctions.add(pa) ;
             
             parcels.add(new MUSW__Parcel__c(Id= newBusiness.primaryParcelId , Primary_Account__c = newAcc.Id , MUSW__Primary_Contact__c = newBusiness.contactId )) ;
         }
         
         if(newBusiness.mailingParcelId != null  && newBusiness.mailingParcelId instanceof ID )
         {
             Parcel_Account__c pam = new Parcel_Account__c();
             pam.Account__c = newAcc.Id;
             pam.Parcel__c =newBusiness.mailingParcelId;
             pam.Mailing__c = true ;
             paJunctions.add(pam) ;
             
             parcels.add(new MUSW__Parcel__c(Id= newBusiness.mailingParcelId , Primary_Account__c = newAcc.Id , MUSW__Primary_Contact__c = newBusiness.contactId )) ;
         }
         
         if(paJunctions.isEmpty() == false )
         {
            INSERT paJunctions ;
             system.debug('Parcel_Account__c Insert>>>>>>>>'+paJunctions);
         }
         
         if(parcels.isEmpty() == false )
         {
            List<MUSW__Parcel__c> lstParcels = new List<MUSW__Parcel__c>(parcels);
            UPDATE lstParcels; 
             system.debug('Update Parcel>>>>'+lstParcels);
         }        
         
        // Create Account Contact Junctions 
        MUSW__Account_Contact__c junction = new MUSW__Account_Contact__c() ;
        junction.MUSW__Contact__c = newBusiness.contactId ;
        junction.MUSW__Account__c = newAcc.Id ;
        junction.Associate_Status__c = label.ST_Active ;
        
        INSERT junction ;
        system.debug('Account Contact>>>>>'+junction);
        
        retRes = new AccountJunctionResult(newAcc , paJunctions , junction ) ;
                
        return retRes ;
     }
}