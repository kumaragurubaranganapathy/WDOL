@isTest
public class Address_CC_Test {
    public static TestMethod MUSW__Parcel__c createTestData(){
        list <Account> acctsToInsert = new list <Account> ();
        Account account = CreateTestDataUtility.createAccount(); 
        Database.insert(account);
        
        Contact contact = CreateTestDataUtility.createContact(account.Id);
        Database.insert(contact);
        
        MUSW__Parcel__c objParcel = new MUSW__Parcel__c(MUSW__Primary_Contact__c= contact.Id, Primary_Account__c = account.Id);
        objParcel.MUSW__Street2__c = '500 Main St';
        objParcel.MUSW__City__c = 'Melbourne';
        objParcel.Country__c = 'Australia';
        Database.insert(objParcel);
        return objParcel;
    }
    
    public static TestMethod void testLocalAddress(){
        MUSW__Parcel__c objParcel = createTestData();
        Test.startTest();
        
        Test.setMock(HttpCalloutMock.class, new CleanAddress_MockService());
        
        PageReference pageRef = Page.Address;
        Test.setCurrentPage(pageRef);
        ApexPages.StandardController con = new ApexPages.StandardController(objParcel);  
        system.debug('objParcel>>>'+objParcel);
        Address_CC controller = new Address_CC(con);
        system.debug('controller>>>'+controller);
         //Test variable initialization
        System.assertEquals(controller.newAddress, false);
        
        List<selectOption> countryOptions = controller.getInternationalCountries();
        System.assertNotEquals(countryOptions.size(),0);
        system.debug('countryOptions>>>'+countryOptions);
        //Test SelectCountry 
        controller.selectCountry();
        System.assert(controller.isInternational);
        
        Test.stopTest();
    }
    
    public static TestMethod void testLocalAddress2(){
        MUSW__Parcel__c objParcel = createTestData();
        objParcel.Country__c = 'United States';
        objParcel.MUSW__Street2__c = '500 Main St';
        objParcel.MUSW__City__c = 'Atlanta';
        objParcel.MUSW__State__c = 'GA';
        update objParcel;
        
        Test.startTest();
        
        Test.setMock(HttpCalloutMock.class, new CleanAddress_MockService());
        
        PageReference pageRef = Page.Address;
        Test.setCurrentPage(pageRef);
        ApexPages.StandardController con = new ApexPages.StandardController(objParcel);  
        system.debug('objParcel>>>'+objParcel);
        Address_CC controller = new Address_CC(con);
        
      	controller.findAddresses();
        controller.saveLocalAddress();
        Test.stopTest();
    }
    
    public static TestMethod void testInternationalAddress(){
        MUSW__Parcel__c objParcel = createTestData();
        Test.startTest();
        
        PageReference pageRef = Page.Address;
        Test.setCurrentPage(pageRef);
        ApexPages.StandardController con = new ApexPages.StandardController(objParcel);        
        Address_CC controller = new Address_CC(con);
        
         //Test variable initialization
        System.assertEquals(controller.newAddress, false);
        
        List<selectOption> countryOptions = controller.getInternationalCountries();
        System.assertNotEquals(countryOptions.size(),0);
        
        //Test SelectCountry 
        controller.selectCountry();
      //  System.assert(controller.isInternational);
        
        //Set country
        MUSW__Parcel__c record = ((MUSW__Parcel__c)con.getRecord());
        record.Country__c = 'Canada';
        
      //  con.addFields(List<String> fieldNames);
        con.save();
        controller.selectCountry();
        controller.selectedInternationalCountry = 'Canada';
    //    System.assert(!controller.isInternational);
        // controller.findAddresses();
        controller.saveInternationalAddress();
        Test.stopTest();
    }
    
    public static TestMethod void test2(){
        
        Test.startTest ();
        
        list <Account> acctsToInsert = new list <Account> ();
        Account account = CreateTestDataUtility.createAccount(); 
        Database.insert(account);
        
        Contact contact = CreateTestDataUtility.createContact(account.Id);
        Database.insert(contact);
        
        MUSW__Parcel__c objParcel = new MUSW__Parcel__c(MUSW__Primary_Contact__c= contact.Id);
        objParcel.Country__c = 'Australia';
        Database.insert(objParcel);
        
        ApexPages.StandardController con = new ApexPages.StandardController(objParcel);        
        Address_CC controller = new Address_CC(con);
        controller.selectedInternationalCountry = 'Canada';
        
        Test.stopTest ();
    }
    
    @testSetup 
    static void setUpServiceData(){
        Boolean isSandbox = [Select Id, isSandbox From Organization limit 1][0].isSandbox;
     /*   GeocodeWebserviceSettings__c geoSetting = new GeocodeWebserviceSettings__c(Name='Canada',Username__c = 'test username', Password__c = 'test password', Endpoint_URL__c = 'http://www.exampleURL.com');
        geoSetting.name = isSandbox ?   label.Str_sandbox : label.Str_production;
        if(geoSetting != null) insert geoSetting;
      */  
        list <Account> acctsToInsert = new list <Account> ();
        Account account = CreateTestDataUtility.createAccount(); 
        Database.insert(account);
        
        Contact c = CreateTestDataUtility.createContact(account.Id);
        Database.insert(c);
        
        User u = CreateTestDataUtility.createCommunityUser(c.Id);
        Database.insert(u);
        
        list <MUSW__Parcel__c> parsToInsert= new list <MUSW__Parcel__c> ();
        MUSW__Parcel__c par = CreateTestDataUtility.createContactParcel(c.id,  'test',  'Test City', 'test', 'test', 'United States');
        parsToInsert.add(par);
        MUSW__Parcel__c par2 = CreateTestDataUtility.createContactParcel(c.id, '1150 University Ave', 'Madison', 'Wisconsin', '53706', 'United States');
        parsToInsert.add(par2);
        Database.insert(parsToInsert);
        
    }
    
       
}