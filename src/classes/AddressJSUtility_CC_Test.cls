/**
* User Story: 135 - Mailing Address on Portal
* Name: AddressJSUtility_CC_Test
* Type: Class
* Description: Test class for AddressJSUtility_CC
* Date:        Developer/Company                    Description
* ---------------------------------------------------------------------------------------------------------------------------------------- *
* 06/19/2018   Sharad Maheshwari/Deloitte           Initial Creation
**/
@isTest
public class AddressJSUtility_CC_Test 
{
	public static Account businessAccount ;
	public static Contact profileRecord ;
    static
    {
    	List<Account> acccountList = new List<Account>();
    	
        Account account1 = CreateTestDataUtility.createAccount() ;
        acccountList.add(account1) ;
        
        businessAccount = CreateTestDataUtility.createAccount() ;
        acccountList.add(businessAccount) ;
        
        INSERT acccountList;
        
        profileRecord = CreateTestDataUtility.createContact(account1.Id);
        INSERT profileRecord ;
        //Todo
        //createGeoConfigs();
    }
    
    public static testMethod void unitTestForBusinessAddress()
     {
     	
         Test.setMock(HttpCalloutMock.class, new CleanAddress_MockService());
         
     	// Saving primary Address on account  
        AddressJSUtility_CC.RawAddress rAddr = new AddressJSUtility_CC.RawAddress() ; 

        rAddr.addressName = 'MIL Address Name ' ;
        rAddr.addressLine1 = 'Line one ' ;
        rAddr.intAddress ='One' ;
        rAddr.addressCountry = 'India' ;
        rAddr.addressType ='International Address' ;
        rAddr.BusinessAccountId = businessAccount.Id ;
        rAddr.EnableAutoLinkingWithAccount = true ;
        rAddr.businessAddressType = 'Primary' ;
        
       AddressJSUtility_CC.RMBusinessAddressResult  result = AddressJSUtility_CC.saveBusinessAddress(rAddr) ;
       system.debug(' ======== > ' +  result.isSuccess);
       system.debug(result.message);
       //it should successfully insert record , and show result as success 
        system.assert(result.isSuccess) ;  
     }
    
     public static testMethod void unitTestForBusinessAddress1(){    
        
         Test.setMock(HttpCalloutMock.class, new CleanAddress_MockService());
         
         // Mailing address
        AddressJSUtility_CC.RawAddress rAddrm = new AddressJSUtility_CC.RawAddress() ; 

        rAddrm.addressName = 'MIL Address Name ' ;
        rAddrm.addressLine1 = 'Line one ' ;
        rAddrm.intAddress ='One' ;
        rAddrm.addressCountry = 'India' ;
        rAddrm.addressType ='International Address' ;
        rAddrm.BusinessAccountId = businessAccount.Id ;
        rAddrm.EnableAutoLinkingWithAccount = true ;
        rAddrm.businessAddressType = 'Mailing' ;
        
       AddressJSUtility_CC.RMBusinessAddressResult  resultm = AddressJSUtility_CC.saveBusinessAddress(rAddrm) ;
       system.debug(resultm.message);
       //it should successfully insert record , and show result as success 
        system.assert(resultm.isSuccess) ;
     }
     
    public static testMethod void unitTestForBusinessAddress2(){    
        
        Test.setMock(HttpCalloutMock.class, new CleanAddress_MockService());
         // Public address
        AddressJSUtility_CC.RawAddress rAddrp = new AddressJSUtility_CC.RawAddress() ; 

        rAddrp.addressName = 'MIL Address Name ' ;
        rAddrp.addressLine1 = 'Line one ' ;
        rAddrp.intAddress ='One' ;
        rAddrp.addressCountry = 'India' ;
        rAddrp.addressType ='International Address' ;
        rAddrp.BusinessAccountId = businessAccount.Id ;
        rAddrp.EnableAutoLinkingWithAccount = true ;
        rAddrp.businessAddressType = 'Public' ;
        
       AddressJSUtility_CC.RMBusinessAddressResult  resultp = AddressJSUtility_CC.saveBusinessAddress(rAddrp) ;
       system.debug(' ======== > ' +  resultp.isSuccess);
       system.debug(resultp.message);
       //it should successfully insert record , and show result as success 
        system.assert(resultp.isSuccess) ;
    }
    
    public static testMethod void unitTestForBusinessAddress3(){
        
        Test.setMock(HttpCalloutMock.class, new CleanAddress_MockService());
        
        // Physical address
        AddressJSUtility_CC.RawAddress rAdd = new AddressJSUtility_CC.RawAddress() ; 

        rAdd.addressName = 'MIL Address Name ' ;
        rAdd.addressLine1 = 'Line one ' ;
        rAdd.intAddress ='One' ;
        rAdd.addressCountry = 'India' ;
        rAdd.addressType ='International Address' ;
        rAdd.BusinessAccountId = businessAccount.Id ;
        rAdd.EnableAutoLinkingWithAccount = true ;
        rAdd.businessAddressType = 'Physical' ;
        
       AddressJSUtility_CC.RMBusinessAddressResult  resultmm = AddressJSUtility_CC.saveBusinessAddress(rAdd) ;
       system.debug(' ======== > ' +  resultmm.isSuccess);
       system.debug(resultmm.message);
       //it should successfully insert record , and show result as success 
        system.assert(resultmm.isSuccess) ;
        
    }
        
   public static testMethod void unitTestForBusinessAddress4(){
       
       Test.setMock(HttpCalloutMock.class, new CleanAddress_MockService());
       
        AddressJSUtility_CC.RawAddress rAddc = new AddressJSUtility_CC.RawAddress() ; 

        rAddc.addressName = 'MIL Address Name ' ;
        rAddc.addressLine1 = 'Line one ' ;
        rAddc.intAddress ='One' ;
        rAddc.addressCountry = 'United States' ;
        rAddc.addressType ='International Address' ;
        rAddc.BusinessContactId = profileRecord.Id ;
        rAddc.EnableAutoLinkingWithContact = true ;
        rAddc.businessAddressType = 'Primary' ;
        rAddc.saveAsaAddressOnEntityFlag = true ;
        
       AddressJSUtility_CC.RMBusinessAddressResult  re = AddressJSUtility_CC.saveBusinessAddress(rAddc) ;
       system.debug(' ======== > ' +  re.isSuccess);
       system.debug(re.message);
       //it should successfully insert record , and show result as success 
       //system.assert(re.isSuccess) ;
        
     }
         
    public static testMethod void unitTestForBusinessAddress5(){
        
        Test.setMock(HttpCalloutMock.class, new CleanAddress_MockService());
        
       AddressJSUtility_CC.RawAddress rAddc1 = new AddressJSUtility_CC.RawAddress() ; 

        rAddc1.addressName = 'MIL Address Name ' ;
        rAddc1.addressLine1 = 'Line one ' ;
        rAddc1.intAddress ='One' ;
        rAddc1.addressCountry = 'India' ;
        rAddc1.addressType ='International Address' ;
        rAddc1.BusinessContactId = profileRecord.Id ;
        rAddc1.EnableAutoLinkingWithContact = true ;
        rAddc1.businessAddressType = 'Mailing' ;
        rAddc1.saveAsaAddressOnEntityFlag = true ;
        
       AddressJSUtility_CC.RMBusinessAddressResult  re1 = AddressJSUtility_CC.saveBusinessAddress(rAddc1) ;
       system.debug(' ======== > ' +  re1.isSuccess);
       system.debug(re1.message);
       //it should successfully insert record , and show result as success 
       system.assert(re1.isSuccess) ;
       
     }
         
      public static testMethod void unitTestForBusinessAddress7(){
          
          Test.setMock(HttpCalloutMock.class, new CleanAddress_MockService());
              
       AddressJSUtility_CC.RawAddress rAddc2 = new AddressJSUtility_CC.RawAddress() ; 

        rAddc2.addressName = 'MIL Address Name ' ;
        rAddc2.addressLine1 = 'Line one ' ;
        rAddc2.intAddress ='One' ;
        rAddc2.addressCountry = 'India' ;
        rAddc2.addressType ='International Address' ;
        rAddc2.BusinessContactId = profileRecord.Id ;
        rAddc2.EnableAutoLinkingWithContact = true ;
        rAddc2.businessAddressType = 'Public' ;
        rAddc2.saveAsaAddressOnEntityFlag = true ;
        
        
       AddressJSUtility_CC.RMBusinessAddressResult  re2 = AddressJSUtility_CC.saveBusinessAddress(rAddc2) ;
       system.debug(' ======== > ' +  re2.isSuccess);
       system.debug(re2.message);
       //it should successfully insert record , and show result as success 
       system.assert(re2.isSuccess) ;
       
              AddressJSUtility_CC.RawAddress rAddc3 = new AddressJSUtility_CC.RawAddress() ; 

        rAddc3.addressName = 'MIL Address Name ' ;
        rAddc3.addressLine1 = 'Line one ' ;
        rAddc3.intAddress ='One' ;
        rAddc3.addressCountry = 'India' ;
        rAddc3.addressType ='International Address' ;
        rAddc3.BusinessContactId = profileRecord.Id ;
        rAddc3.EnableAutoLinkingWithContact = true ;
        rAddc3.businessAddressType = 'Physical' ;
        rAddc3.saveAsaAddressOnEntityFlag = true ;
        
       AddressJSUtility_CC.RMBusinessAddressResult  re3 = AddressJSUtility_CC.saveBusinessAddress(rAddc3) ;
       system.debug(' ======== > ' +  re3.isSuccess);
       system.debug(re3.message);
       //it should successfully insert record , and show result as success 
       system.assert(re3.isSuccess) ;
       
      }
      
      public static testMethod void unitTestForBusinessAddress6(){
          
          Test.setMock(HttpCalloutMock.class, new CleanAddress_MockService());
          
        AddressJSUtility_CC.RawAddress rAddc4 = new AddressJSUtility_CC.RawAddress() ; 

        rAddc4.addressName = 'MIL Address Name ' ;
        rAddc4.addressLine1 = 'Line one ' ;
        rAddc4.intAddress ='One' ;
        rAddc4.addressCountry = 'India' ;
        rAddc4.addressType ='International Address' ;
        rAddc4.BusinessContactId = profileRecord.Id ;
        rAddc4.EnableAutoLinkingWithContact = true ;
        rAddc4.businessAddressType = 'Primary' ;
        rAddc4.saveAsaAddressOnEntityFlag = true ;
        
       AddressJSUtility_CC.RMBusinessAddressResult  re4 = AddressJSUtility_CC.saveBusinessAddress(rAddc4) ;
       system.debug(' ======== > ' +  re4.isSuccess);
       system.debug(re4.message);
       //it should successfully insert record , and show result as success 
       system.assert(re4.isSuccess) ;
       
       Global_Settings__c gs= new Global_Settings__c(SetupOwnerId=UserInfo.getUserId(), Disable_Triggers__c=true);
         insert gs;  
       //Create one lic record 
        
          MUSW__License2__c lic = CreateTestDataUtility.createLicense(businessAccount.Id, profileRecord.Id);//(MUSW__Primary_Licensee__c= , MUSW__Applicant__c = ,App_Submitted_Date__c=System.today(),MUSW__Type__c='Restaurant');
       insert lic ;
          delete gs;
       
       AddressJSUtility_CC.EditRMInput rmIn = new AddressJSUtility_CC.EditRMInput() ;
       rmIn.accountId = businessAccount.Id ;
       rmIn.contactId = profileRecord.Id ;
       rmIn.isLPJobRemaining = true ;
       rmIn.contextParcelId = re4.addressRecord.Id ;
       rmIn.licenseId = lic.Id ;
       rmIn.primaryEntityType = 'Contact' ;
       rmIn.contextAddressType = 'Public' ;
       
       AddressJSUtility_CC.BusinessAddressResult bRes = AddressJSUtility_CC.saveAsAddressOnEntity(rmIn) ;
       
       system.assert(bRes.isSuccess ) ;
     }
    
    public static testMethod void unitTest1ForSavingNonGeoAddress(){
        
        Test.setMock(HttpCalloutMock.class, new CleanAddress_MockService());
        
        // Saving military address 
        AddressJSUtility_CC.RawAddress rAddr = new AddressJSUtility_CC.RawAddress() ; 

        rAddr.addressName = 'MIL Address Name ' ;
        rAddr.addressLine1 = 'Line one ' ;
        rAddr.addressLine2 = 'Line 2 ' ;
        rAddr.city ='APO' ;
        rAddr.state = 'AE' ;
        rAddr.addressCountry = 'United States' ;
        rAddr.zipCode = '78240' ;
        
        AddressJSUtility_CC.RMBusinessAddressResult  result = AddressJSUtility_CC.saveBusinessAddress(rAddr) ;
        system.assert(result.isSuccess) ;
     }
     
     
     public static testMethod void unitTest2ForSavingNonGeoAddress(){
         
         Test.setMock(HttpCalloutMock.class, new CleanAddress_MockService());
         
        // Saving military address 
        AddressJSUtility_CC.RawAddress rAddr = new AddressJSUtility_CC.RawAddress() ; 

        rAddr.addressName = 'MIL Address Name ' ;
        rAddr.addressLine1 = 'Line one ' ;
        rAddr.addressLine2 = 'Line 2 ' ;
        rAddr.city ='APO' ;
        rAddr.state = 'AE' ;
        rAddr.addressCountry = 'United States' ;
        rAddr.zipCode = 'abcde' ;
        rAddr.addressType ='Military Address' ;
        rAddr.militaryFlag = true ;
        
       AddressJSUtility_CC.RMBusinessAddressResult  result = AddressJSUtility_CC.saveBusinessAddress(rAddr) ;
       //it should successfully insert record , and show result as success 
        //system.assert(result.isSuccess) ;
     }
    
     public static testMethod void unitTest3ForSavingNonGeoAddress(){
         
         Test.setMock(HttpCalloutMock.class, new CleanAddress_MockService());
         
        // Saving military address 
        AddressJSUtility_CC.RawAddress rAddr = new AddressJSUtility_CC.RawAddress() ; 

        rAddr.addressName = 'MIL Address Name ' ;
        rAddr.addressLine1 = 'Line one ' ;
        rAddr.addressLine2 = 'Line 2 ' ;
        rAddr.city ='APO' ;
        rAddr.state = 'DD' ;
        rAddr.addressCountry = 'United States' ;
        rAddr.zipCode = 'abcde' ;
        rAddr.addressType ='Military Address' ;
        rAddr.militaryFlag = true ;
        
       AddressJSUtility_CC.RMBusinessAddressResult  result = AddressJSUtility_CC.saveBusinessAddress(rAddr) ;
       system.debug(' ======== > ' +  result.isSuccess);
       system.debug(result.message);
       //it should successfully insert record , and show result as success 
        //system.assert(result.isSuccess) ;
     }
     
     public static testMethod void unitTestForWebserviceCallout(){
         
         Test.setMock(HttpCalloutMock.class, new CleanAddress_MockService());
         
            // Saving US address 
        	//Try to call webservice directly , It should throw exception 
        	//Webservice callout is not allowed this time 
        	//As Webservice Mock is not Set
        	AddressJSUtility_CC.RawAddress rAddr = new AddressJSUtility_CC.RawAddress();
            rAddr.addressName = 'My US Address' ;
            rAddr.addressLine1 = 'Line one ' ;
            rAddr.addressLine2 = 'Line 2 ' ;
            rAddr.city ='Denver' ;
            rAddr.state = 'CO' ;
            rAddr.addressCountry = 'United States' ;
        	rAddr.addressCounty = 'XX' ;
        	rAddr.addressName = 'Test' ;
            rAddr.zipCode = '78240' ;
            rAddr.addressType = 'US Address' ;
        	Test.startTest() ;
        	AddressJSUtility_CC.RMBusinessAddressResult resultError = AddressJSUtility_CC.saveBusinessAddress(rAddr) ;
        	//system.assert(!resultError.isSuccess) ;
        	system.assert(resultError.message != null ) ;
        	Test.stopTest() ;
       }
       
       
    //With Mock class
    //Without exact match
    public static testMethod void unitTest2ForWebserviceCallout(){
        Test.setMock(HttpCalloutMock.class, new CleanAddress_MockService());
        
            // Saving US address 
        	AddressJSUtility_CC.RawAddress rAddr = new AddressJSUtility_CC.RawAddress();
            rAddr.addressName = 'My US Address' ;
            rAddr.addressLine1 = 'Line one ' ;
            rAddr.addressLine2 = 'Line 2 ' ;
            rAddr.city ='Denver' ;
            rAddr.state = 'CO' ;
            rAddr.addressCountry = 'United States' ;
            rAddr.zipCode = '78240' ;
            rAddr.addressType ='US Address' ;
        	Test.startTest() ;
        	//Todo
        	//Test.setMock(WebServiceMock.class , new AddressMockWebService('Street 1' , 'Street2 ' ,'test city ' , 'test state' ,'test zip')) ;
        	AddressJSUtility_CC.RMBusinessAddressResult result = AddressJSUtility_CC.saveBusinessAddress(rAddr) ;
            system.debug('**********'+ result) ;
            system.assert(result.isSuccess) ;
            //This should success message 
            //It should show multiple address here
            //Todo
            //system.assert(result.geoAddresses.size() == 2 ) ; 
            // It should return two rows of GeoResults , one is returned by webservice
        	// Other is supplied to geo service
            Test.stopTest();
      }
      
      //With Mock class
    //Without exact match
    public static testMethod void unitTest3ForWebserviceCallout(){
        
        Test.setMock(HttpCalloutMock.class, new CleanAddress_MockService());
        
            // Saving US address 
        	AddressJSUtility_CC.RawAddress rAddr = new AddressJSUtility_CC.RawAddress();
            rAddr.addressName = 'My US Address' ;
            rAddr.addressLine1 = 'Line one ' ;
            rAddr.city ='Denver' ;
            rAddr.state = 'CO' ;
            rAddr.addressCountry = 'United States' ;
            rAddr.zipCode = '78240' ;
            rAddr.addressType ='US Address' ;
        	Test.startTest() ;
        	//Todo
        	//Test.setMock(WebServiceMock.class , new AddressMockWebService('Street 1' , '' ,'test city ' , 'test state' ,'test zip')) ;
        	AddressJSUtility_CC.RMBusinessAddressResult result = AddressJSUtility_CC.saveBusinessAddress(rAddr) ;
            system.debug('**********'+ result) ;
            system.assert(result.isSuccess) ;
            //This should success message 
            //It should show multiple address here
            //Todo
            //system.assert(result.geoAddresses.size() == 2 ) ; 
            // It should return two rows of GeoResults , one is returned by webservice
        	// Other is supplied to geo service
            Test.stopTest();
       }
     
    public static testMethod void unitTest4ForWebserviceCallout(){
        
        Test.setMock(HttpCalloutMock.class, new CleanAddress_MockService());
        
            AddressJSUtility_CC.RawAddress rAddr1 = new AddressJSUtility_CC.RawAddress();
            rAddr1.addressName = 'My US Address' ;
            rAddr1.addressType = 'US Address' ;
            rAddr1.addressLine1 = 'Line 11' ;
            rAddr1.addressLine2 = 'Line 2' ;
            rAddr1.city ='Denver' ;
            rAddr1.state = 'CO' ;
            rAddr1.addressCountry = 'United States' ;
            rAddr1.zipCode = '78240' ;
            rAddr1.EnableAutoLinkingWithContact = true ;
            rAddr1.businessContactId = profileRecord.Id ;
        
        	//Todo
        	//Test.setMock(WebServiceMock.class , new AddressMockWebService('Line 11' , 'Line 2' ,'Denver' , 'CO' ,'78240')) ;
        	AddressJSUtility_CC.RMBusinessAddressResult result1 = AddressJSUtility_CC.saveBusinessAddress(rAddr1) ;
        
            
            // Saving US address 
        	
        	AddressJSUtility_CC.RawAddress rAddr = new AddressJSUtility_CC.RawAddress();
            rAddr.addressName = 'My US Address' ;
            rAddr.addressType = 'US Address' ;
            rAddr.addressLine1 = 'Line 1' ;
            rAddr.addressLine2 = 'Line 2' ;
            rAddr.city ='Denver' ;
            rAddr.state = 'CO' ;
            rAddr.addressCountry = 'United States' ;
            rAddr.zipCode = '78240' ;
        
        	Test.startTest() ;
        	//Todo
        	//Test.setMock(WebServiceMock.class , new AddressMockWebService('Line 1' , 'Line 2' ,'Denver' , 'CO' ,'78240')) ;
        	AddressJSUtility_CC.RMBusinessAddressResult result = AddressJSUtility_CC.saveBusinessAddress(rAddr) ;
            //This should success message 
            //It should show that exact match has been found 
            system.assert(result.isSuccess );
            
            //Todo
            //system.assert(result.geoAddresses.size() == 1) ;
            
            //system.assert(result.addressRecord != null ) ;
            
            
            // Try to delete same address now 
            AddressJSUtility_CC.BusinessAddressRMIn rmIn = new AddressJSUtility_CC.BusinessAddressRMIn();
            //rmIn.parcelId = result.addressRecord.Id ;
            rmIn.contactId = profileRecord.Id ; 
            rmIn.PrimaryEntityType = 'Contact' ;
            
            AddressJSUtility_CC.BusinessAddressDBOpResult delRes = AddressJSUtility_CC.deleteBusinessAddress(rmIn ) ;
            
            system.assert(delRes.isSuccess) ;
    
            
            Test.stopTest();
       } 
    
    public static testMethod void unitTest5ForWebserviceCallout(){
        
            Test.startTest();
        
        Test.setMock(HttpCalloutMock.class, new CleanAddress_MockService());
        
            AddressJSUtility_CC.RawAddress rAddr1 = new AddressJSUtility_CC.RawAddress();
            rAddr1.addressName = 'My US Address' ;
            rAddr1.addressType = 'US Address' ;
            rAddr1.addressLine1 = 'Line 11' ;
            rAddr1.addressLine2 = 'Line 2' ;
            rAddr1.city ='Denver' ;
            rAddr1.state = 'CO' ;
            rAddr1.addressCountry = 'United States' ;
            rAddr1.zipCode = '78240' ;
            rAddr1.EnableAutoLinkingWithContact = true ;
            rAddr1.businessContactId = profileRecord.Id ;
            rAddr1.businessAddressType = 'Mailing' ;
            rAddr1.saveAsaAddressOnEntityFlag = true ;
        
        	//Todo
        	//Test.setMock(WebServiceMock.class , new AddressMockWebService('Line 11' , 'Line 2' ,'Denver' , 'CO' ,'78240')) ;
        	AddressJSUtility_CC.RMBusinessAddressResult result1 = AddressJSUtility_CC.saveBusinessAddress(rAddr1) ;
        	
        	system.assert(result1.isSuccess) ;
        	
        	AddressJSUtility_CC.RawAddress rAddr = new AddressJSUtility_CC.RawAddress();
            rAddr.addressName = 'My US Address' ;
            rAddr.addressType = 'US Address' ;
            rAddr.addressLine1 = 'Line 1' ;
            rAddr.addressLine2 = 'Line 2' ;
            rAddr.city ='Denver' ;
            rAddr.state = 'CO' ;
            rAddr.addressCountry = 'United States' ;
            rAddr.zipCode = '78240' ;
            rAddr.saveAsaAddressOnEntityFlag = true ;
            //rAddr.parcelId = result1.addressRecord.Id ;
            rAddr.EnableAutoLinkingWithContact = true ;
            rAddr.businessContactId = profileRecord.Id ;
            rAddr.businessAddressType = 'Mailing' ;
        
        	
        	//Todo
        	//Test.setMock(WebServiceMock.class , new AddressMockWebService('Line 1' , 'Line 2' ,'Denver' , 'CO' ,'78240')) ;
        	AddressJSUtility_CC.RMBusinessAddressResult result = AddressJSUtility_CC.saveBusinessAddress(rAddr) ;
        	
        	system.debug(result.isSuccess) ;
            
        	Test.stopTest();
    } 
    
    public static testMethod void unitTest6ForWebserviceCallout()
    {
            Test.startTest();
        
        Test.setMock(HttpCalloutMock.class, new CleanAddress_MockService());
        
            AddressJSUtility_CC.RawAddress rAddr1 = new AddressJSUtility_CC.RawAddress();
            rAddr1.addressName = 'My US Address' ;
            rAddr1.addressType = 'US Address' ;
            rAddr1.addressLine1 = 'Line 11' ;
            rAddr1.addressLine2 = 'Line 2' ;
            rAddr1.city ='Denver' ;
            rAddr1.state = 'CO' ;
            rAddr1.addressCountry = 'United States' ;
            rAddr1.zipCode = '78240' ;
            rAddr1.EnableAutoLinkingWithContact = true ;
            rAddr1.businessContactId = profileRecord.Id ;
            rAddr1.businessAddressType = 'Public' ;
            rAddr1.saveAsaAddressOnEntityFlag = true ;
        
        	//Todo
        	//Test.setMock(WebServiceMock.class , new AddressMockWebService('Line 11' , 'Line 2' ,'Denver' , 'CO' ,'78240')) ;
        	AddressJSUtility_CC.RMBusinessAddressResult result1 = AddressJSUtility_CC.saveBusinessAddress(rAddr1) ;
        	
        	system.assert(result1.isSuccess) ;
        	
        	AddressJSUtility_CC.RawAddress rAddr = new AddressJSUtility_CC.RawAddress();
            rAddr.addressName = 'My US Address' ;
            rAddr.addressType = 'US Address' ;
            rAddr.addressLine1 = 'Line 1' ;
            rAddr.addressLine2 = 'Line 2' ;
            rAddr.city ='Denver' ;
            rAddr.state = 'CO' ;
            rAddr.addressCountry = 'United States' ;
            rAddr.zipCode = '78240' ;
            //rAddr.parcelId = result1.addressRecord.Id ;
            rAddr.EnableAutoLinkingWithContact = true ;
            rAddr.businessContactId = profileRecord.Id ;
            rAddr.businessAddressType = 'Public' ;
            rAddr.saveAsaAddressOnEntityFlag = true ;
        
        	
        	//Todo
        	//Test.setMock(WebServiceMock.class , new AddressMockWebService('Line 1' , 'Line 2' ,'Denver' , 'CO' ,'78240')) ;
        	AddressJSUtility_CC.RMBusinessAddressResult result = AddressJSUtility_CC.saveBusinessAddress(rAddr) ;
        	
        	system.debug(result.isSuccess) ;
            
        	Test.stopTest();
    } 
    
    public static testMethod void unitTest8ForWebserviceCallout()
    {
            Test.startTest();
        
        Test.setMock(HttpCalloutMock.class, new CleanAddress_MockService());
        
            AddressJSUtility_CC.RawAddress rAddr1 = new AddressJSUtility_CC.RawAddress();
            rAddr1.addressName = 'My US Address' ;
            rAddr1.addressType = 'US Address' ;
            rAddr1.addressLine1 = 'Line 11' ;
            rAddr1.addressLine2 = 'Line 2' ;
            rAddr1.city ='Denver' ;
            rAddr1.state = 'CO' ;
            rAddr1.addressCountry = 'United States' ;
            rAddr1.zipCode = '78240' ;
            rAddr1.EnableAutoLinkingWithContact = true ;
            rAddr1.businessContactId = profileRecord.Id ;
            rAddr1.businessAddressType = 'Physical' ;
            rAddr1.saveAsaAddressOnEntityFlag = true ;
        
        	//Todo
        	//Test.setMock(WebServiceMock.class , new AddressMockWebService('Line 11' , 'Line 2' ,'Denver' , 'CO' ,'78240')) ;
        	AddressJSUtility_CC.RMBusinessAddressResult result1 = AddressJSUtility_CC.saveBusinessAddress(rAddr1) ;
        	
        	system.assert(result1.isSuccess) ;
        	
        	AddressJSUtility_CC.RawAddress rAddr = new AddressJSUtility_CC.RawAddress();
            rAddr.addressName = 'My US Address' ;
            rAddr.addressType = 'US Address' ;
            rAddr.addressLine1 = 'Line 1' ;
            rAddr.addressLine2 = 'Line 2' ;
            rAddr.city ='Denver' ;
            rAddr.state = 'CO' ;
            rAddr.addressCountry = 'United States' ;
            rAddr.zipCode = '78240' ;
            //rAddr.parcelId = result1.addressRecord.Id ;
            rAddr.EnableAutoLinkingWithContact = true ;
            rAddr.businessContactId = profileRecord.Id ;
            rAddr.businessAddressType = 'Physical' ;
            rAddr.saveAsaAddressOnEntityFlag = true ;
        
        	
        	//Todo
        	//Test.setMock(WebServiceMock.class , new AddressMockWebService('Line 1' , 'Line 2' ,'Denver' , 'CO' ,'78240')) ;
        	AddressJSUtility_CC.RMBusinessAddressResult result = AddressJSUtility_CC.saveBusinessAddress(rAddr) ;
        	
        	system.debug(result.isSuccess) ;
            
        	Test.stopTest();
    } 
    public static testMethod void unitTest7ForWebserviceCallout()
    {
            Test.startTest();
        
        Test.setMock(HttpCalloutMock.class, new CleanAddress_MockService());
        
            AddressJSUtility_CC.RawAddress rAddr1 = new AddressJSUtility_CC.RawAddress();
            rAddr1.addressName = 'My US Address' ;
            rAddr1.addressType = 'US Address' ;
            rAddr1.addressLine1 = 'Line 11' ;
            rAddr1.addressLine2 = 'Line 2' ;
            rAddr1.city ='Denver' ;
            rAddr1.state = 'CO' ;
            rAddr1.addressCountry = 'United States' ;
            rAddr1.zipCode = '78240' ;
            rAddr1.EnableAutoLinkingWithContact = true ;
            rAddr1.businessContactId = profileRecord.Id ;
            rAddr1.businessAddressType = 'Primary' ;
            rAddr1.saveAsaAddressOnEntityFlag = true ;
        
        	//Todo
        	//Test.setMock(WebServiceMock.class , new AddressMockWebService('Line 11' , 'Line 2' ,'Denver' , 'CO' ,'78240')) ;
        	AddressJSUtility_CC.RMBusinessAddressResult result1 = AddressJSUtility_CC.saveBusinessAddress(rAddr1) ;
        	
        	system.assert(result1.isSuccess) ;
        	
        	AddressJSUtility_CC.RawAddress rAddr = new AddressJSUtility_CC.RawAddress();
            rAddr.addressName = 'My US Address' ;
            rAddr.addressType = 'US Address' ;
            rAddr.addressLine1 = 'Line 1' ;
            rAddr.addressLine2 = 'Line 2' ;
            rAddr.city ='Denver' ;
            rAddr.state = 'CO' ;
            rAddr.addressCountry = 'United States' ;
            rAddr.zipCode = '78240' ;
            //rAddr.parcelId = result1.addressRecord.Id ;
            rAddr.EnableAutoLinkingWithContact = true ;
            rAddr.businessContactId = profileRecord.Id ;
            rAddr.businessAddressType = 'Primary' ;
            rAddr.saveAsaAddressOnEntityFlag = true ;
        
        	
        	//Todo
        	//Test.setMock(WebServiceMock.class , new AddressMockWebService('Line 1' , 'Line 2' ,'Denver' , 'CO' ,'78240')) ;
        	AddressJSUtility_CC.RMBusinessAddressResult result = AddressJSUtility_CC.saveBusinessAddress(rAddr) ;
        	
        	system.debug(result.isSuccess) ;
            
        	Test.stopTest();
    }
    
    
    public static testMethod void unitTest6ActForWebserviceCallout()
    {
            Test.startTest();
        
        Test.setMock(HttpCalloutMock.class, new CleanAddress_MockService());
        
            AddressJSUtility_CC.RawAddress rAddr1 = new AddressJSUtility_CC.RawAddress();
            rAddr1.addressName = 'My US Address' ;
            rAddr1.addressType = 'US Address' ;
            rAddr1.addressLine1 = 'Line 11' ;
            rAddr1.addressLine2 = 'Line 2' ;
            rAddr1.city ='Denver' ;
            rAddr1.state = 'CO' ;
            rAddr1.addressCountry = 'United States' ;
            rAddr1.zipCode = '78240' ;
            rAddr1.EnableAutoLinkingWithAccount = true ;
            rAddr1.businessAccountId = businessAccount.Id ;
            rAddr1.businessAddressType = 'Public' ;
            rAddr1.saveAsaAddressOnEntityFlag = true ;
        
        	//Todo
        	//Test.setMock(WebServiceMock.class , new AddressMockWebService('Line 11' , 'Line 2' ,'Denver' , 'CO' ,'78240')) ;
        	AddressJSUtility_CC.RMBusinessAddressResult result1 = AddressJSUtility_CC.saveBusinessAddress(rAddr1) ;
        	
        	system.assert(result1.isSuccess) ;
        	
        	AddressJSUtility_CC.RawAddress rAddr = new AddressJSUtility_CC.RawAddress();
            rAddr.addressName = 'My US Address' ;
            rAddr.addressType = 'US Address' ;
            rAddr.addressLine1 = 'Line 1' ;
            rAddr.addressLine2 = 'Line 2' ;
            rAddr.city ='Denver' ;
            rAddr.state = 'CO' ;
            rAddr.addressCountry = 'United States' ;
            rAddr.zipCode = '78240' ;
            //rAddr.parcelId = result1.addressRecord.Id ;
            rAddr.EnableAutoLinkingWithAccount = true ;
            rAddr.businessAccountId = businessAccount.Id ;
            rAddr.businessAddressType = 'Public' ;
            rAddr.saveAsaAddressOnEntityFlag = true ;
        
        	
        	//todo
        	//Test.setMock(WebServiceMock.class , new AddressMockWebService('Line 1' , 'Line 2' ,'Denver' , 'CO' ,'78240')) ;
        	AddressJSUtility_CC.RMBusinessAddressResult result = AddressJSUtility_CC.saveBusinessAddress(rAddr) ;
        	
        	system.debug(result.isSuccess) ;
            
        	Test.stopTest();
    } 
    
    
     public static testMethod void unitTest5AForWebserviceCallout()
    {
            Test.startTest();
        
        Test.setMock(HttpCalloutMock.class, new CleanAddress_MockService());
        
            AddressJSUtility_CC.RawAddress rAddr1 = new AddressJSUtility_CC.RawAddress();
            rAddr1.addressName = 'My US Address' ;
            rAddr1.addressType = 'US Address' ;
            rAddr1.addressLine1 = '901 International Pkwy' ;
            rAddr1.addressLine2 = '' ;
            rAddr1.city ='Lake Mary' ;
            rAddr1.state = 'FL' ;
            rAddr1.addressCountry = 'United States' ;
            rAddr1.zipCode = '32746' ;
            rAddr1.EnableAutoLinkingWithAccount = true ;
            rAddr1.businessAccountId = businessAccount.Id ;
            rAddr1.businessAddressType = 'Mailing' ;
        
        	//todo
        	//Test.setMock(WebServiceMock.class , new AddressMockWebService('901 International Pkwy' , '' ,'Lake Mary' , 'FL' ,'32746')) ;
        	AddressJSUtility_CC.RMBusinessAddressResult result1 = AddressJSUtility_CC.saveBusinessAddress(rAddr1) ;
        	System.debug('result1 line#737 '+result1);
        	system.assert(result1.isSuccess) ;
        	
        	AddressJSUtility_CC.RawAddress rAddr = new AddressJSUtility_CC.RawAddress();
            rAddr1.addressName = 'My US Address' ;
            rAddr1.addressType = 'US Address' ;
            rAddr1.addressLine1 = '901 International Pkwy' ;
            rAddr1.addressLine2 = '' ;
            rAddr1.city ='Lake Mary' ;
            rAddr1.state = 'FL' ;
            rAddr1.addressCountry = 'United States' ;
            rAddr1.zipCode = '32746' ;
            rAddr.saveAsaAddressOnEntityFlag = true ;
            //rAddr.parcelId = result1.addressRecord.Id ;
            rAddr.EnableAutoLinkingWithAccount = true ;
            rAddr.businessAccountId = businessAccount.Id ;
            rAddr.businessAddressType = 'Mailing' ;
        
        	
        	//Todo
        	//Test.setMock(WebServiceMock.class , new AddressMockWebService('Line 1' , 'Line 2' ,'Denver' , 'CO' ,'78240')) ;
        	AddressJSUtility_CC.RMBusinessAddressResult result = AddressJSUtility_CC.saveBusinessAddress(rAddr) ;
        	
        	system.debug(result.isSuccess) ;
            
        	Test.stopTest();
    }
    
    
    public static testMethod void unitTest5ActForWebserviceCallout()
    {
            Test.startTest();
        
        Test.setMock(HttpCalloutMock.class, new CleanAddress_MockService());
        
            AddressJSUtility_CC.RawAddress rAddr1 = new AddressJSUtility_CC.RawAddress();
            rAddr1.addressName = 'My US Address' ;
            rAddr1.addressType = 'US Address' ;
            rAddr1.addressLine1 = 'Line 11' ;
            rAddr1.addressLine2 = 'Line 2' ;
            rAddr1.city ='Denver' ;
            rAddr1.state = 'CO' ;
            rAddr1.addressCountry = 'United States' ;
            rAddr1.zipCode = '78240' ;
            rAddr1.EnableAutoLinkingWithAccount = true ;
            rAddr1.businessAccountId = businessAccount.Id ;
            rAddr1.businessAddressType = 'Public' ;
        
        	//Todo
        	//Test.setMock(WebServiceMock.class , new AddressMockWebService('Line 11' , 'Line 2' ,'Denver' , 'CO' ,'78240')) ;
        	AddressJSUtility_CC.RMBusinessAddressResult result1 = AddressJSUtility_CC.saveBusinessAddress(rAddr1) ;
        	
        	system.assert(result1.isSuccess) ;
        	
        	AddressJSUtility_CC.RawAddress rAddr = new AddressJSUtility_CC.RawAddress();
            rAddr.addressName = 'My US Address' ;
            rAddr.addressType = 'US Address' ;
            rAddr.addressLine1 = 'Line 1' ;
            rAddr.addressLine2 = 'Line 2' ;
            rAddr.city ='Denver' ;
            rAddr.state = 'CO' ;
            rAddr.addressCountry = 'United States' ;
            rAddr.zipCode = '78240' ;
            rAddr.saveAsaAddressOnEntityFlag = true ;
            //rAddr.parcelId = result1.addressRecord.Id ;
            rAddr.EnableAutoLinkingWithAccount = true ;
            rAddr.businessAccountId = businessAccount.Id ;
            rAddr.businessAddressType = 'Public' ;
        
        	
        	//Todo
        	//Test.setMock(WebServiceMock.class , new AddressMockWebService('Line 1' , 'Line 2' ,'Denver' , 'CO' ,'78240')) ;
        	AddressJSUtility_CC.RMBusinessAddressResult result = AddressJSUtility_CC.saveBusinessAddress(rAddr) ;
        	
        	system.debug(result.isSuccess) ;
            
        	Test.stopTest();
    }
    
    
    
    public static testMethod void unitTestPhysical5ActForWebserviceCallout()
    {
            Test.startTest();
        
        Test.setMock(HttpCalloutMock.class, new CleanAddress_MockService());
        
            AddressJSUtility_CC.RawAddress rAddr1 = new AddressJSUtility_CC.RawAddress();
            rAddr1.addressName = 'My US Address' ;
            rAddr1.addressType = 'US Address' ;
            rAddr1.addressLine1 = 'Line 11' ;
            rAddr1.addressLine2 = 'Line 2' ;
            rAddr1.city ='Denver' ;
            rAddr1.state = 'CO' ;
            rAddr1.addressCountry = 'United States' ;
            rAddr1.zipCode = '78240' ;
            rAddr1.EnableAutoLinkingWithAccount = true ;
            rAddr1.businessAccountId = businessAccount.Id ;
            rAddr1.businessAddressType = 'Physical' ;
        
        	//Todo
        	//Test.setMock(WebServiceMock.class , new AddressMockWebService('Line 11' , 'Line 2' ,'Denver' , 'CO' ,'78240')) ;
        	AddressJSUtility_CC.RMBusinessAddressResult result1 = AddressJSUtility_CC.saveBusinessAddress(rAddr1) ;
        	
        	system.assert(result1.isSuccess) ;
        	
        	AddressJSUtility_CC.RawAddress rAddr = new AddressJSUtility_CC.RawAddress();
            rAddr.addressName = 'My US Address' ;
            rAddr.addressType = 'US Address' ;
            rAddr.addressLine1 = 'Line 1' ;
            rAddr.addressLine2 = 'Line 2' ;
            rAddr.city ='Denver' ;
            rAddr.state = 'CO' ;
            rAddr.addressCountry = 'United States' ;
            rAddr.zipCode = '78240' ;
            rAddr.saveAsaAddressOnEntityFlag = true ;
            //rAddr.parcelId = result1.addressRecord.Id ;
            rAddr.EnableAutoLinkingWithAccount = true ;
            rAddr.businessAccountId = businessAccount.Id ;
            rAddr.businessAddressType = 'Physical' ;
        
        	
        	//Todo
        	//Test.setMock(WebServiceMock.class , new AddressMockWebService('Line 1' , 'Line 2' ,'Denver' , 'CO' ,'78240')) ;
        	AddressJSUtility_CC.RMBusinessAddressResult result = AddressJSUtility_CC.saveBusinessAddress(rAddr) ;
        	
        	system.debug(result.isSuccess) ;
            
        	Test.stopTest();
    } 
    
    
    public static testMethod void unitTestAct8ForWebserviceCallout()
    {
            Test.startTest();
        
        Test.setMock(HttpCalloutMock.class, new CleanAddress_MockService());
        
            AddressJSUtility_CC.RawAddress rAddr1 = new AddressJSUtility_CC.RawAddress();
            rAddr1.addressName = 'My US Address' ;
            rAddr1.addressType = 'US Address' ;
            rAddr1.addressLine1 = 'Line 11' ;
            rAddr1.addressLine2 = 'Line 2' ;
            rAddr1.city ='Denver' ;
            rAddr1.state = 'CO' ;
            rAddr1.addressCountry = 'United States' ;
            rAddr1.zipCode = '78240' ;
            rAddr1.EnableAutoLinkingWithAccount = true ;
            rAddr1.businessAccountId = businessAccount.Id ;
            rAddr1.businessAddressType = 'Physical' ;
            rAddr1.saveAsaAddressOnEntityFlag = true ;
        
        	//Todo
        	//Test.setMock(WebServiceMock.class , new AddressMockWebService('Line 11' , 'Line 2' ,'Denver' , 'CO' ,'78240')) ;
        	AddressJSUtility_CC.RMBusinessAddressResult result1 = AddressJSUtility_CC.saveBusinessAddress(rAddr1) ;
        	
        	system.assert(result1.isSuccess) ;
        	
        	AddressJSUtility_CC.RawAddress rAddr = new AddressJSUtility_CC.RawAddress();
            rAddr.addressName = 'My US Address' ;
            rAddr.addressType = 'US Address' ;
            rAddr.addressLine1 = 'Line 1' ;
            rAddr.addressLine2 = 'Line 2' ;
            rAddr.city ='Denver' ;
            rAddr.state = 'CO' ;
            rAddr.addressCountry = 'United States' ;
            rAddr.zipCode = '78240' ;
            //rAddr.parcelId = result1.addressRecord.Id ;
            rAddr.EnableAutoLinkingWithAccount = true ;
            rAddr.businessAccountId = businessAccount.Id ;
            rAddr.businessAddressType = 'Physical' ;
            rAddr.saveAsaAddressOnEntityFlag = true ;
        
        	
        	//Todo
        	//Test.setMock(WebServiceMock.class , new AddressMockWebService('Line 1' , 'Line 2' ,'Denver' , 'CO' ,'78240')) ;
        	AddressJSUtility_CC.RMBusinessAddressResult result = AddressJSUtility_CC.saveBusinessAddress(rAddr) ;
        	
        	system.debug(result.isSuccess) ;
            
        	Test.stopTest();
    }
    
    
    
    public static testMethod void unitTest7ActForWebserviceCallout()
    {
            Test.startTest();
        
        Test.setMock(HttpCalloutMock.class, new CleanAddress_MockService());
        
            AddressJSUtility_CC.RawAddress rAddr1 = new AddressJSUtility_CC.RawAddress();
            rAddr1.addressName = 'My US Address' ;
            rAddr1.addressType = 'US Address' ;
            rAddr1.addressLine1 = 'Line 11' ;
            rAddr1.addressLine2 = 'Line 2' ;
            rAddr1.city ='Denver' ;
            rAddr1.state = 'CO' ;
            rAddr1.addressCountry = 'United States' ;
            rAddr1.zipCode = '78240' ;
            rAddr1.EnableAutoLinkingWithAccount = true ;
            rAddr1.businessAccountId = businessAccount.Id ;
            rAddr1.businessAddressType = 'Primary' ;
            rAddr1.saveAsaAddressOnEntityFlag = true ;
        
        	//Todo
        	//Test.setMock(WebServiceMock.class , new AddressMockWebService('Line 11' , 'Line 2' ,'Denver' , 'CO' ,'78240')) ;
        	AddressJSUtility_CC.RMBusinessAddressResult result1 = AddressJSUtility_CC.saveBusinessAddress(rAddr1) ;
        	
        	system.assert(result1.isSuccess) ;
        	
        	AddressJSUtility_CC.RawAddress rAddr = new AddressJSUtility_CC.RawAddress();
            rAddr.addressName = 'My US Address' ;
            rAddr.addressType = 'US Address' ;
            rAddr.addressLine1 = 'Line 1' ;
            rAddr.addressLine2 = 'Line 2' ;
            rAddr.city ='Denver' ;
            rAddr.state = 'CO' ;
            rAddr.addressCountry = 'United States' ;
            rAddr.zipCode = '78240' ;
            //rAddr.parcelId = result1.addressRecord.Id ;
            rAddr.EnableAutoLinkingWithAccount = true ;
            rAddr.businessAccountId = businessAccount.Id ;
            rAddr.businessAddressType = 'Primary' ;
            rAddr.saveAsaAddressOnEntityFlag = true ;
        
        	
        	//Todo
        	//Test.setMock(WebServiceMock.class , new AddressMockWebService('Line 1' , 'Line 2' ,'Denver' , 'CO' ,'78240')) ;
        	AddressJSUtility_CC.RMBusinessAddressResult result = AddressJSUtility_CC.saveBusinessAddress(rAddr) ;
        	
        	system.debug(result.isSuccess) ;
            
        	Test.stopTest();
    }
    
    
    
    public static testmethod void unitTestForSaveSelectedGC()
    {
    	    Test.startTest();
        
        Test.setMock(HttpCalloutMock.class, new CleanAddress_MockService());
        
            AddressJSUtility_CC.GeoResult rAddr1 = new AddressJSUtility_CC.GeoResult();
            rAddr1.addressName = 'My US Address' ;
            rAddr1.addressLine1 = 'Line 11' ;
            rAddr1.addressLine2 = 'Line 2' ;
            rAddr1.city ='Denver' ;
            rAddr1.state = 'CO' ;
            rAddr1.addressCountry = 'United States' ;
            rAddr1.zipCode = '78240' ;
            rAddr1.EnableAutoLinkingWithAccount = true ;
            rAddr1.businessAccountId = businessAccount.Id ;
            rAddr1.businessAddressType = 'Primary' ;
            rAddr1.validated = true ;
            rAddr1.saveAsaAddressOnEntityFlag = true ;
        
        	AddressJSUtility_CC.RMBusinessAddressResult result1 = AddressJSUtility_CC.saveSelectedGeoCodedAddress(rAddr1) ;
        	
        	
        	
        	AddressJSUtility_CC.GeoResult rAddr = new AddressJSUtility_CC.GeoResult();
            rAddr.addressName = 'My US Address' ;
            rAddr.addressLine1 = 'Line 11' ;
            rAddr.addressLine2 = 'Line 2' ;
            rAddr.city ='Denver' ;
            rAddr.state = 'CO' ;
            rAddr.addressCountry = 'United States' ;
            rAddr.zipCode = '78240' ;
            rAddr.EnableAutoLinkingWithContact = true ;
            rAddr.businessAccountId = profileRecord.Id ;
            rAddr.businessAddressType = 'Primary' ;
            rAddr.validated = true ;
            rAddr.saveAsaAddressOnEntityFlag = true ;
        
        	AddressJSUtility_CC.RMBusinessAddressResult result2 = AddressJSUtility_CC.saveSelectedGeoCodedAddress(rAddr) ;
    
    
    
        	
        	system.assert(result2.isSuccess) ;
    
        	AddressJSUtility_CC.GeoResult rAdd = new AddressJSUtility_CC.GeoResult();
            rAdd.addressName = 'My US Address' ;
            rAdd.addressLine1 = 'Line 11' ;
            rAdd.addressLine2 = 'Line 2' ;
            rAdd.city ='Denver' ;
            rAdd.state = 'CO' ;
            rAdd.addressCountry = 'United States' ;
            rAdd.zipCode = '78240' ;
            rAdd.EnableAutoLinkingWithContact = true ;
            rAdd.businessAccountId = profileRecord.Id ;
            rAdd.businessAddressType = 'Primary' ;
            rAdd.validated = true ;
            rAdd.saveAsaAddressOnEntityFlag = true ;
            rAdd.sfdcID = result2.addressRecord.Id ;
        
        	AddressJSUtility_CC.RMBusinessAddressResult result3 = AddressJSUtility_CC.saveSelectedGeoCodedAddress(rAdd) ;
        	
        	system.assert(result3.isSuccess) ;
        	
        	
        	sObject s = result3.addressRecord ;
        	delete s ;
        	
        	
        	    	AddressJSUtility_CC.GeoResult rAd= new AddressJSUtility_CC.GeoResult();
            rAd.addressName = 'My US Address' ;
            rAd.addressLine1 = 'Line 11' ;
            rAd.addressLine2 = 'Line 2' ;
            rAd.city ='Denver' ;
            rAd.state = 'CO' ;
            rAd.addressCountry = 'United States' ;
            rAd.zipCode = '78240' ;
            rAd.EnableAutoLinkingWithContact = true ;
            rAd.businessAccountId = profileRecord.Id ;
            rAd.businessAddressType = 'Primary' ;
            rAd.validated = true ;
            rAd.saveAsaAddressOnEntityFlag = true ;
            rAd.sfdcID = result2.addressRecord.Id ;
        
        	AddressJSUtility_CC.RMBusinessAddressResult result4 = AddressJSUtility_CC.saveSelectedGeoCodedAddress(rAd) ;
        	
        	system.assert(!result4.isSuccess) ;
    
    }
    
    public static testmethod void genericALl()
    {
    	Test.startTest();
        
        Test.setMock(HttpCalloutMock.class, new CleanAddress_MockService());
        
    	AddressJSUtility_CC.GlobalAddressConfig res = AddressJSUtility_CC.getPartialConfigurationsOnLoad() ;
    	
    	system.assert(res != null ) ;
    
    	Test.stopTest();
    }
    
    
    public static testMethod void unitTestForLPOperations()
    {
        Test.setMock(HttpCalloutMock.class, new CleanAddress_MockService());
        
    	//Create one ParcelRecord and try to edit via service 
        MUSW__Parcel__c  parcel = new MUSW__Parcel__c ();
        parcel.Comments__c = 'My Addres  ' ;
        parcel.Country__c = 'India';
        Insert parcel ;
        
        MUSW__License2__c lic = CreateTestDataUtility.createLicense(businessAccount.Id, profileRecord.Id);
        //MUSW__License2__c  lic = new MUSW__License2__c(MUSW__Primary_Licensee__c= businessAccount.Id, MUSW__Applicant__c = profileRecord.Id,App_Submitted_Date__c=System.today(),MUSW__Type__c='Restaurant');
        lic.App_Submitted_Date__c=System.today();
        INSERT lic ;
        
        Test.startTest();
        
        string res = AddressJSUtility_CC.handleLicenseParcelOperations(lic.Id , parcel.Id , 'Mailing');
        string res2 = AddressJSUtility_CC.handleLicenseParcelOperations(lic.Id , parcel.Id , 'Public');
        string res3= AddressJSUtility_CC.handleLicenseParcelOperations(lic.Id , parcel.Id , 'Primary');
        string res4 = AddressJSUtility_CC.handleLicenseParcelOperations(lic.Id , parcel.Id , 'Physical');
        
        
        AddressJSUtility_CC.EditRMInput rm = new AddressJSUtility_CC.EditRMInput();
        rm.accountId = businessAccount.Id ;
        rm.contactId = profileRecord.Id ;
        rm.licenseId = lic.Id;
        rm.contextParcelId = parcel.Id;
        rm.primaryEntityType = 'Contact' ;
        rm.isLPJobRemaining = true;
        rm.contextAddressType = label.Str_Primary;
        
        AddressJSUtility_CC.LicenseBusinessAddressResult result = AddressJSUtility_CC.getLicenseBusinessAddressDetails(rm) ;
        system.assert(result != null ) ;
        
        
        List<Id> actIds = new List<Id>();
        actIds.add(businessAccount.Id) ;
        
        List<Id> contIds = new List<Id>() ;
        contIds.add(profileRecord.Id ) ;
        
        AddressJSUtility_CC.BusinessAddressResult res7 = AddressJSUtility_CC.getBusinessAddressListOnLoad(actIds , contIds ,'Contact' ) ;
       	system.assert(res7 != null ) ;
         
        AddressJSUtility_CC.BusinessAddressResult res8 = AddressJSUtility_CC.getBusinessAddressListOnLoad(actIds , contIds ,'Account' ) ;
       	system.assert(res8 != null ) ;
        
        
        Test.stopTest();
    }
    
    public static testMethod void unitTestForLPOperationsForPermit()
    {
        Test.setMock(HttpCalloutMock.class, new CleanAddress_MockService());
        
    	//Create one ParcelRecord and try to edit via service 
        MUSW__Parcel__c  parcel = new MUSW__Parcel__c ();
        parcel.Comments__c = 'My Addres  ' ;
        parcel.Country__c = 'India';
        Insert parcel ;
        
        MUSW__Permit2__c per = CreateTestDataUtility.createPermit(businessAccount.Id, profileRecord.Id);
        INSERT per ;
        
        Test.startTest();
        
        string res = AddressJSUtility_CC.handlePermitParcelOperations(per.Id , parcel.Id , 'Mailing');
        string res2 = AddressJSUtility_CC.handlePermitParcelOperations(per.Id , parcel.Id , 'Public');
        string res3= AddressJSUtility_CC.handlePermitParcelOperations(per.Id , parcel.Id , 'Primary');
        string res4 = AddressJSUtility_CC.handlePermitParcelOperations(per.Id , parcel.Id , 'Physical');
        
        AddressJSUtility_CC.EditRMInput rm = new AddressJSUtility_CC.EditRMInput();
        rm.accountId = businessAccount.Id ;
        rm.contactId = profileRecord.Id ;
        rm.permitId = per.Id;
        rm.contextParcelId = parcel.Id;
        rm.primaryEntityType = 'Contact' ;
        rm.isPPJobRemaining = true;
        rm.contextAddressType = label.Str_Primary;
        
        AddressJSUtility_CC.PermitBusinessAddressResult result = AddressJSUtility_CC.getPermitBusinessAddressDetails(rm) ;
        system.assert(result != null ) ;
        
        Test.stopTest();
    }
}