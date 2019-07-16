@isTest
public class InboundEmailProcessorTest {
	public static Account businessAccount ;
	public static Contact profileRecord ;
    static
    {
        Global_Settings__c gs= new Global_Settings__c(SetupOwnerId=UserInfo.getUserId(), Disable_Triggers__c=true);
         insert gs;

    	List<Account> acts = new List<Account>();
    	
        Account acct = new Account(Name = 'Citizen') ;
        acts.add(acct) ;
        
        businessAccount = new Account(Name='My Business Act ') ;
        
        acts.add(businessAccount) ;
        
        INSERT acts ;
        profileRecord = new Contact(FirstName='Mr Profile ' , LastName = 'demo LastName' , AccountId = acts[0].Id ) ;
        INSERT profileRecord ;
        Delete gs;
    }
    
    
    public static testMethod void unitTestForInboundEmailProcessor()
    {
    	Test.startTest();
    	InboundEmailProcessor proc = new InboundEmailProcessor();
    	Messaging.InboundEmail dumm = new Messaging.InboundEmail() ;
    	Messaging.InboundEmailResult result = proc.handleInboundEmail(null,null ) ;	
    	Test.stopTest();
    }
    
    public static testMethod void unitTestForInboundEmailProcessor2()
    {
    	Test.startTest();
    	InboundEmailProcessor proc = new InboundEmailProcessor();
    	Messaging.InboundEmail dumm = new Messaging.InboundEmail() ;
    	Messaging.InboundEmailResult result = proc.handleInboundEmail(dumm,null ) ;	
    	Test.stopTest();
    }
    
    public static testMethod void unitTestForInboundEmailProcessor3()
    {
    	Test.startTest();
    	InboundEmailProcessor proc = new InboundEmailProcessor();
    	Messaging.InboundEmail dumm = new Messaging.InboundEmail() ;
    	dumm.subject = 'COMMUNITY_PLUS_USER_CREATION' ; 
    	dumm.plainTextBody = JSON.serialize(new BusinessUtility.NewBusinessUserPromoCombo(null,null,null)) ;
    	Messaging.InboundEmailResult result = proc.handleInboundEmail(dumm,null ) ;	
    	Test.stopTest();
    }
    
    public static testMethod void unitTestForInboundEmailProcessor4()
    {
    	Test.startTest();
    	InboundEmailProcessor proc = new InboundEmailProcessor();
    	Messaging.InboundEmail dumm = new Messaging.InboundEmail() ;
    	dumm.subject = 'COMMUNITY_USER_DEMOTION' ; 
    	dumm.plainTextBody = JSON.serialize(new BusinessUtility.NewBusinessUserPromoCombo(null,null,null)) ;
    	Messaging.InboundEmailResult result = proc.handleInboundEmail(dumm,null ) ;	
    	Test.stopTest();
    }
    
    public static testMethod void unitTestForInboundEmailProcessor5()
    {
    	Test.startTest();
    	InboundEmailProcessor proc = new InboundEmailProcessor();
    	Messaging.InboundEmail dumm = new Messaging.InboundEmail() ;
    	dumm.subject = 'COMMUNITY_PLUS_BUSINESS_CREATION' ; 
    	dumm.plainTextBody = JSON.serialize(new BusinessUtility.NewBusinessUserPromoCombo(null,null,null)) ;
    	Messaging.InboundEmailResult result = proc.handleInboundEmail(dumm,null ) ;	
    	Test.stopTest();
    }
    
    
    public static testMethod void unitTestForInboundEmailProcessor6()
    {
    	Test.startTest();
    	InboundEmailProcessor proc = new InboundEmailProcessor();
    	Messaging.InboundEmail dumm = new Messaging.InboundEmail() ;
    	dumm.subject = 'COMMUNITY_USER_DEMOTION' ; 
    	
    	BusinessUtility.UserPromotion uP = new BusinessUtility.UserPromotion();
    	up.contactId = null ;
    	uP.currentUserId  = UserInfo.getUserId() ;
		up.firstName = 'Test';
		uP.lastName = 'Last' ;
		uP.email = 'test@gmail.com.7ui';
    	
    	dumm.plainTextBody = JSON.serialize(new BusinessUtility.NewBusinessUserPromoCombo(null,uP,null)) ;
    	Messaging.InboundEmailResult result = proc.handleInboundEmail(dumm,null ) ;	
    	Test.stopTest();
    }
    
    public static testMethod void unitTestForInboundEmailProcessor7()
    {
    	Test.startTest();
    	InboundEmailProcessor proc = new InboundEmailProcessor();
    	Messaging.InboundEmail dumm = new Messaging.InboundEmail() ;
    	dumm.subject = 'COMMUNXXXXITY_USER_DEMOTION_CVVCVC' ; 
    	
    	BusinessUtility.UserPromotion uP = new BusinessUtility.UserPromotion();
    	up.contactId = null ;
    	uP.currentUserId  = UserInfo.getUserId() ;
		up.firstName = 'Test';
		uP.lastName = 'Last' ;
		uP.email = 'test@gmail.com.7ui';
    	
    	dumm.plainTextBody = JSON.serialize(new BusinessUtility.NewBusinessUserPromoCombo(null,uP,null)) ;
    	Messaging.InboundEmailResult result = proc.handleInboundEmail(dumm,null ) ;	
    	Test.stopTest();
    }
    
    public static testMethod void unitTestForInboundEmailProcessor9()
    {
        //Test.startTest();
    	//Create Account 
    	User cUser = CreateUserTestDataUtility.createCommunityUser();
    	
    	Test.startTest();
    	InboundEmailProcessor proc = new InboundEmailProcessor();
    	Messaging.InboundEmail dumm = new Messaging.InboundEmail() ;
    	dumm.subject = 'COMMUNITY_USER_DEMOTION' ; 
    	
    	BusinessUtility.UserPromotion uP = new BusinessUtility.UserPromotion();
    	up.contactId = null ;
    	uP.currentUserId  = cUser.Id ;
    	uP.currentUserProfileId = cUser.ProfileId ;
		up.firstName = 'Test';
		uP.lastName = 'Last' ;
		uP.email = 'test@gmail.com.7ui';
    	
    	dumm.plainTextBody = JSON.serialize(new BusinessUtility.NewBusinessUserPromoCombo(null,uP,null)) ;
    	Messaging.InboundEmailResult result = proc.handleInboundEmail(dumm,null ) ;	
    	Test.stopTest();
    }
    
    public static testMethod void unitTestForInboundEmailProcessor10()
    {
    	//Create Account 
        Test.startTest();
        String COMMUNITY_PROFILE_ID = [Select Id from Profile Where Name = 'eSLA Customer Community Login User' limit 1 ].Id ;
        User cUser = new User();
        cUser.Username = 'test@randomusername.com'; 
          cUser.Email = 'test@randomusername.com';
          cUser.FirstName = 'Dumm';
          cUser.LastName = 'uPromo.lastName';
          cUser.ContactId = profileRecord.Id;
          cUser.ProfileId = COMMUNITY_PROFILE_ID; 
          transient string tempNickName = String.valueOf(Math.random()) + '-' + 'Dummy'  ;
        if(tempNickName.length() > 30 )
        {
            tempNickName = tempNickName.substring(2,30) ;
        }
          cUser.CommunityNickname = tempNickName ; 
          cUser.Alias = ('fdim' + 'dummy').substring(0,5);
          cUser.languagelocalekey='en_US';
          cUser.localesidkey='en_US';
          cUser.timezonesidkey='America/Los_Angeles';
          cUser.emailencodingkey='UTF-8';
        insert cUser;
    	
    	//Test.startTest();
    	InboundEmailProcessor proc = new InboundEmailProcessor();
    	Messaging.InboundEmail dumm = new Messaging.InboundEmail() ;
    	dumm.subject = 'COMMUNITY_PLUS_USER_CREATION' ; 
    	
    	BusinessUtility.UserPromotion uP = new BusinessUtility.UserPromotion();
    	up.contactId = null ;
    	uP.currentUserId  = cUser.Id ;
    	uP.currentUserProfileId = cUser.ProfileId ;
		up.firstName = 'Test';
		uP.lastName = 'Last' ;
		uP.email = 'test@gmail.com.7ui';
    	
    	
    	BusinessUtility.NewBusiness bs = new BusinessUtility.NewBusiness() ; 
    	bs.registeredAs ='Partenership' ;
		bs.accountName ='TEst ';
		bs.contactId = profileRecord.Id ;
        bs.firmCertificate = 'assasas' ;
        bs.contactPerson = 'ojn' ;
        bs.contactPersonFirstName = 'jjs' ;
        bs.contactPersonLastName ='asas' ;
        bs.website ='asasa.com' ;
        bs.phoneNumber='1234567899';
        bs.email = 'eassae@gmail.com' ;
        
        
        MUSW__Parcel__c  parcel = new MUSW__Parcel__c ();
        parcel.Comments__c = 'My Addres  ' ;
        parcel.Country__c = 'India';
        Insert parcel ;
       
        bs.primaryParcelId = parcel.Id ;
        bs.mailingParcelId = parcel.Id ;
    	
    	
    	dumm.plainTextBody = JSON.serialize(new BusinessUtility.NewBusinessUserPromoCombo(bs,uP,'BrandNewBusiness')) ;
    	Messaging.InboundEmailResult result = proc.handleInboundEmail(dumm,null ) ;	
    	Test.stopTest();
    }
    
   
    public static testMethod void unitTestForInboundEmailProcessor11()
    {
    	//Create Account 
    	User cUser = CreateUserTestDataUtility.createCommunityUser();
    	
    	Test.startTest();
    	InboundEmailProcessor proc = new InboundEmailProcessor();
    	Messaging.InboundEmail dumm = new Messaging.InboundEmail() ;
    	dumm.subject = 'COMMUNITY_PLUS_BUSINESS_CREATION' ; 
    	
    	BusinessUtility.UserPromotion uP = new BusinessUtility.UserPromotion();
    	up.contactId = null ;
    	uP.currentUserId  = cUser.Id ;
    	uP.currentUserProfileId = cUser.ProfileId ;
		up.firstName = 'Test';
		uP.lastName = 'Last' ;
		uP.email = 'test@gmail.com.7ui';
    	
    	
    	BusinessUtility.NewBusiness bs = new BusinessUtility.NewBusiness() ; 
    	bs.registeredAs ='Partenership' ;
		bs.accountName ='TEst ';
		bs.contactId = profileRecord.Id ;
        bs.firmCertificate = 'assasas' ;
        bs.contactPerson = 'ojn' ;
        bs.contactPersonFirstName = 'jjs' ;
        bs.contactPersonLastName ='asas' ;
        bs.website ='asasa.com' ;
        bs.phoneNumber='1234567899';
        bs.email = 'eassae@gmail.com' ;
        
        
        List<MUSW__Parcel__c> parcels = new List<MUSW__Parcel__c>();
        
        MUSW__Parcel__c  parcel = new MUSW__Parcel__c ();
        parcel.Comments__c = 'My Addres  ' ;
        parcel.Country__c = 'India';
        parcels.add( parcel );
       
       MUSW__Parcel__c  parcel2 = new MUSW__Parcel__c ();
        parcel2.Comments__c = 'My Addres  ' ;
        parcel2.Country__c = 'India';
        parcels.add( parcel2 );
        
        INSERT parcels ;
        bs.primaryParcelId = parcels[0].Id ;
        bs.mailingParcelId =  parcels[1].Id ;
    	
    	
    	dumm.plainTextBody = JSON.serialize(new BusinessUtility.NewBusinessUserPromoCombo(bs,uP,'BrandNewBusiness')) ;
    	Messaging.InboundEmailResult result = proc.handleInboundEmail(dumm,null ) ;	
    	Test.stopTest();
    }
    
    public static testMethod void unitTestForInboundEmailProcessor12()
    {
    	//Create Account 
    	User cUser = CreateUserTestDataUtility.createCommunityUser();
    	try
    	{
    	cUser.lastName = 'updated ' ;
    	
    	Database.SaveResult re = Database.update(cUser , false ) ;
    	
    	InboundEmailProcessor.processUserOperationResult(re,null,'Test','Test');
    	}catch(exception e)
    	{
    	
    	}
    }
    
    public static testMethod void unitTestForInboundEmailProcessor13()
    {
    	//Create Account 
    	User cUser = new User(Id= UserInfo.getUserId(), LastName = 'Demo' );
    	Database.SaveResult re = Database.update(cUser , false ) ;
    	
    	InboundEmailProcessor.processDBResult(re);
    	
    }
    
    
    public static testMethod void unitTestForInboundEmailProcess()
    {
    	try{
    	//Create Account 
    	User cUser = new User(LastName = 'Demo' );
    	Database.SaveResult re = Database.update(cUser , false ) ;
    	
    	InboundEmailProcessor.processDBResult(re);
    	}catch(exception ex)
    	{
    		
    	}
    }
}