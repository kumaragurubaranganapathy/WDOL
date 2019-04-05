/**
* Name: CreateUserTestDataUtility
* Type: Class
* Description: Class to create test user data
* Date:        Developer/Company                    Description
* ---------------------------------------------------------------------------------------------------------------------------------------- *
* 09/25/2018   Srikanth Kottam/Deloitte           Initial Creation
**/
@isTest
public class CreateUserTestDataUtility {
	public static final String COMMUNITY_PLUS_PROFILE_ID = [Select Id from Profile Where Name = : 'eSLA Customer Community Plus Login User' limit 1 ].Id ;
    public static final String COMMUNITY_PROFILE_ID = [Select Id from Profile Where Name = 'eSLA Customer Community Login User' limit 1 ].Id ;
   // public static final String COMMUNITY_GUEST_PROFILE_ID = [Select Id from Profile Where Name = 'elicense Profile' limit 1 ].Id ;
    public static Contact profileRecord ;
    public static Contact profileRecordSpcl ;
    public static Contact profileRecordSpcl2 ;
    
    static 
    {
        Account act = new Account(Name='Citizen') ;
        insert act ;
        
        List<Contact> cons = new List<Contact>() ;
        
        profileRecord = new Contact(FirstName ='Fname' , LastName ='lName' , email ='dummy@cooluser.com') ;
        cons.add(profileRecord) ;
        
        profileRecordspcl = new Contact(FirstName ='Special' , LastName ='Special' , email ='specialman@gmail.com' , Last_4_Digits_of_SSN__c ='9191' , Birthdate = Date.parse('10/31/1990')) ;
        cons.add(profileRecordspcl) ;
        
        profileRecordspcl2 = new Contact(FirstName ='Special2' , LastName ='Special2' , email ='specialman@gmail.com' , Last_4_Digits_of_SSN__c ='9000' , Birthdate = Date.parse('10/31/1990')) ;
        cons.add(profileRecordspcl2) ;
        
        
        
        INSERT cons ;
        
        profileRecord = cons[0] ;
        profileRecordspcl = cons[1] ;
        profileRecordspcl2 = cons[2] ;
    }
    
/*    public static user createGuestUserInstance()
    {
        // Now create new User Record 
          User usr = new User();
          usr.Username = 'test@randomusername.com.guest'; 
          usr.Email = 'test@randomusername.com.guest';
          usr.FirstName = 'DummGues';
          usr.LastName = 'uPromo.Gueame';
          usr.ProfileId = COMMUNITY_GUEST_PROFILE_ID; 
          transient string tempNickName = String.valueOf(Math.random()) + '-' + 'Dummy'  ;
        if(tempNickName.length() > 30 )
        {
            tempNickName = tempNickName.substring(2,30) ;
        }
          usr.CommunityNickname = tempNickName ; 

          
          usr.Alias = ('fdim' + 'dumgmy').substring(0,5);
          usr.languagelocalekey='en_US';
          usr.localesidkey='en_US';
          usr.timezonesidkey='America/Los_Angeles';
          usr.emailencodingkey='UTF-8';
          
          return usr ;
        
    }
 */   
    
    public static user createSpecialCommunityUser()
    {
        // Now create new User Record 
          User usr = new User();
          usr.Username = 'special@randomusername.com.guest'; 
          usr.Email = 'special@randomusername.com.guest';
          usr.FirstName = 'DummGues';
          usr.LastName = 'uPromo.Gueame';
          usr.ProfileId = COMMUNITY_PROFILE_ID; 
          usr.contactId = profileRecordspcl.Id ;
          transient string tempNickName = String.valueOf(Math.random()) + '-' + 'Dummy'  ;
        if(tempNickName.length() > 30 )
        {
            tempNickName = tempNickName.substring(2,30) ;
        }
          usr.CommunityNickname = tempNickName ; 

          
          usr.Alias = ('fdsim' + 'dumsgmy').substring(0,5);
          usr.languagelocalekey='en_US';
          usr.localesidkey='en_US';
          usr.timezonesidkey='America/Los_Angeles';
          usr.emailencodingkey='UTF-8';
          
          INSERT usr ;
          return usr ;
        
    }
    
    
    public static user createSpecialCommunityUser2()
    {
        // Now create new User Record 
          User usr = new User();
          usr.Username = 'special2@randomusername.com.guest'; 
          usr.Email = 'special2@randomusername.com.guest';
          usr.FirstName = 'DummGues';
          usr.LastName = 'uPromo.Gueame';
          usr.isActive= false ;
          usr.ProfileId = COMMUNITY_PROFILE_ID; 
          usr.contactId = profileRecordspcl2.Id ;
          transient string tempNickName = String.valueOf(Math.random()) + '-' + 'Dummy'  ;
        if(tempNickName.length() > 30 )
        {
            tempNickName = tempNickName.substring(2,30) ;
        }
          usr.CommunityNickname = tempNickName ; 

          
          usr.Alias = ('fdsim' + 'dumsgmy').substring(0,5);
          usr.languagelocalekey='en_US';
          usr.localesidkey='en_US';
          usr.timezonesidkey='America/Los_Angeles';
          usr.emailencodingkey='UTF-8';
          
          INSERT usr ;
          return usr ;
        
    }
    
    
    public static user createCommunityUserInstance()
    {
          // Now create new User Record 
          User usr = new User();
          usr.Username = 'test@randomusername.com'; 
          usr.Email = 'test@randomusername.com';
          usr.FirstName = 'Dumm';
          usr.LastName = 'uPromo.lastName';
          usr.ContactId = profileRecord.Id;
          usr.ProfileId = COMMUNITY_PROFILE_ID; 
          transient string tempNickName = String.valueOf(Math.random()) + '-' + 'Dummy'  ;
        if(tempNickName.length() > 30 )
        {
            tempNickName = tempNickName.substring(2,30) ;
        }
          usr.CommunityNickname = tempNickName ; 

          
          usr.Alias = ('fdim' + 'dummy').substring(0,5);
          usr.languagelocalekey='en_US';
          usr.localesidkey='en_US';
          usr.timezonesidkey='America/Los_Angeles';
          usr.emailencodingkey='UTF-8';
          
          return usr ;
          
    }
    

public static user createCommunityUser()
    {
          // Now create new User Record 
          User usr = new User();
          usr.Username = 'test@randomusername.com'; 
          usr.Email = 'test@randomusername.com';
          usr.FirstName = 'Dumm';
          usr.LastName = 'uPromo.lastName';
          usr.ContactId = profileRecord.Id;
          usr.ProfileId = COMMUNITY_PROFILE_ID; 
          transient string tempNickName = String.valueOf(Math.random()) + '-' + 'Dummy'  ;
        if(tempNickName.length() > 30 )
        {
            tempNickName = tempNickName.substring(2,30) ;
        }
          usr.CommunityNickname = tempNickName ; 

          
          usr.Alias = ('fdim' + 'dummy').substring(0,5);
          usr.languagelocalekey='en_US';
          usr.localesidkey='en_US';
          usr.timezonesidkey='America/Los_Angeles';
          usr.emailencodingkey='UTF-8';
          
          INSERT usr ;
          return usr ;
          
    }

    public static user createCommunityPlusUserInstance()
    {
        // Now create new User Record 
          User usr = new User();
          usr.Username = 'test@randomusername.com.cp'; 
          usr.Email = 'test@randomusername.com.cp';
          usr.FirstName = 'Dumm';
          usr.LastName = 'uPromo.lastName';
          usr.ContactId = profileRecord.Id;
          usr.ProfileId = COMMUNITY_PLUS_PROFILE_ID; 
          transient string tempNickName = String.valueOf(Math.random()) + '-' + 'Dummy'  ;
        if(tempNickName.length() > 30 )
        {
            tempNickName = tempNickName.substring(2,30) ;
        }
          usr.CommunityNickname = tempNickName ; 

          
          usr.Alias = ('fdim' + 'dummy').substring(0,5);
          usr.languagelocalekey='en_US';
          usr.localesidkey='en_US';
          usr.timezonesidkey='America/Los_Angeles';
          usr.emailencodingkey='UTF-8';
          
          return usr ;
    }
    
    
    
    public static user createCommunityPlusUser()
    {
        // Now create new User Record 
          User usr = new User();
          usr.Username = 'test@randomusername.com.cp'; 
          usr.Email = 'test@randomusername.com.cp';
          usr.FirstName = 'Dumm';
          usr.LastName = 'uPromo.lastName';
          usr.ContactId = profileRecord.Id;
          usr.ProfileId = COMMUNITY_PLUS_PROFILE_ID; 
          transient string tempNickName = String.valueOf(Math.random()) + '-' + 'Dummy'  ;
        if(tempNickName.length() > 30 )
        {
            tempNickName = tempNickName.substring(2,30) ;
        }
          usr.CommunityNickname = tempNickName ; 

          
          usr.Alias = ('fdim' + 'dummy').substring(0,5);
          usr.languagelocalekey='en_US';
          usr.localesidkey='en_US';
          usr.timezonesidkey='America/Los_Angeles';
          usr.emailencodingkey='UTF-8';
          
          INSERT usr ;
          return usr ;
    }
}