/*************************************************************************************************************
** User Story: Test Class
**************************************************************************************************************
** Class Name       : ApplicationHistoryTest
** Description      : @ Test class that creates a couple of records; 
**                      instantiates the controller, and then asserts the sizes of the lists.  
**                      @see also: ApplicationHistory.cls and ApplicationHistory pahe 
**------------------------------------------------------------------------------------------------------------
** Modification Log:
**------------------
** Developer                  Date          Version               Description
**------------------------------------------------------------------------------------------------------------
**  
**
** Review Log:
**---------------
** Reviewer                   Date           Version                Description
**------------------------------------------------------------------------------------------------------------
**
*************************************************************************************************************/

@isTest
private class ApplicationHistoryTest {
    //Create some class variables that you will need
    
    static id contactid;
    static id userid;
    static id accountid;
    
    
    //Create the "Setup" method to create a couple of records which will populate the lists.  
    @testsetup static void createTestData () {
        //Disable the triggers for the current user
        
        Global_Settings__c g = new Global_Settings__c();
        g.Disable_Triggers__c = true;
        insert g;
        
        BGBK__CartSettings__c cartSettings = new BGBK__CartSettings__c(Name = 'Default', BGBK__Payable_Parents__c = 'MUSW__License2__c, MUSW__Application2__c, License_Renewal__c', BGBK__Payment_Gateway_Data_Encryption_Key__c = 'BasicGovPayments');
        insert cartSettings;
        
        //In order not to hit the SOQL Limit, create lists to insert data of the same type all at once. 
        list<Account> acctsToInsert = new list<Account> ();
        list<MUSW__License2__c> licToInsert = new list<MUSW__License2__c> ();
        
        //Set up and insert the Accounts
        Account acc =  CreateTestDataUtility.createAccount();
        acctsToInsert.add(acc);
        
        Account acc1 = CreateTestDataUtility.createCitizenAccount();       
        acctsToInsert.add(acc1);
        
        Database.insert(acctsToInsert);
        accountid=acc.id;
        //Set up and insert the contact after you create the accounts
        Contact c = CreateTestDataUtility.createContact(acc.Id);
        Database.insert(c);
        contactid = c.id;
        
        
        MUSW__Account_Contact__c MAC=CreateTestDataUtility.createAccountContact(acc.id,c.Id);
        insert MAC;
        
        
    }
    
    @isTest
    public static void testApplicationHistoryTestCtlr() {
        // createTestData ();
        Test.startTest();
        
        //Query for the variables you need that were created in the setup
        Contact c = [SELECT Id,User__c FROM Contact limit 1];
        User u = CreateTestDataUtility.createCommunityUser(c.id);            
        Database.insert(u); 
        
        
        System.debug('contactid '+ c);
       // list<MUSW__Fee_Payment__c> lst1 = [select id,Name,Application_Type__c,Fee_Type__c,MUSW__Fee_Amount__c,MUSW__Payment_Amount__c,MUSW__Paid_Date__c,Paid_By__c,MUSW__Receipt__c,BGBK__License2__c from MUSW__Fee_Payment__c];
      //  system.debug('list:'+lst1);     
        //Run as the User you set up.
        System.runAs(u){
            Fine__c testfines = new Fine__c();
            testfines.Contact_Related_to_the_Fine__c = c.id;
            testfines.Account__c   = accountid ;
            testfines.Status__c=Label.St_Pending;
            testfines.Fine_Amount__c=33;
            insert testfines;
            testfines.Status__c='Applied';
            update testfines;
            MUSW__Receipt__c receipt = new MUSW__Receipt__c();
            receipt.MUSW__Amount_Tendered__c  = 50;
            receipt.MUSW__Payment_Method__c = 'Check';
            receipt.MUSW__Effective_Date__c = System.today();
            receipt.MUSW__Payment_Method__c = 'Credit Card';
            Insert receipt;
            
            
            MUSW__License2__c license = CreateTestDataUtility.createLicense(accountid,C.ID); 
            insert license;
            MUSW__GlobalSettings__c globalSettings = new MUSW__GlobalSettings__c(Name = 'Default', MUSW__Disable_Triggers__c  = true);
            if(globalSettings != null) insert globalSettings;
            
            MUSW__Fee__c fee = new MUSW__Fee__c(MUSW__Type__c = 'Test Fee', MUSW__License2__c = license.Id, MUSW__Amount__c = 5.0, Application_type__c = license.Application_Type__c);
            insert fee;
            
            MUSW__License2__c license1 = CreateTestDataUtility.createLicense( accountid,c.Id);      
            Database.insert (license1);  
            
            BGBK__Payment__c testPayment = new BGBK__Payment__c(fine__c = testfines.Id,BGBK__Receipt__c = receipt.Id,BGBK__Amount__c=50,BGBK__License2__c  = license1.Id);
            Insert testPayment;
            MUSW__Permit2__c permit2 = CreateTestDataUtility.createPermit( accountId,c.Id);     
            insert permit2;
            
            
            MUSW__Fee_Payment__c feePaymentTest = new MUSW__Fee_Payment__c(BGBK__Payment__c = testPayment.Id,
                                                                           MUSW__Fee__c=fee.Id,MUSW__Fee_Amount__c=50,
                                                                           MUSW__Payment_Amount__c=5,
                                                                           MUSW__Receipt__c=receipt.Id);
            insert feePaymentTest;
            
            PageReference pref = Page.ApplicationHistory; 
            Test.setCurrentPage(pref);
            ApplicationHistory rhc = new ApplicationHistory (); 
            list<string> str1 = new list <String> ();
            rhc.tableHeaderList = str1;
            list<BGBK__Payment__c> paylist = new list<BGBK__Payment__c>();
            rhc.paymentHistoryList=paylist;
            rhc.paymentHistoryRenewalList=paylist;
            rhc.serviceHistoryRenewalList=paylist;
            //rhc.feePayment=lst1;
            string str123='shravan';
            list<ApplicationHistory.PaymentRecord> nprlist = new list<ApplicationHistory.PaymentRecord>();
            ApplicationHistory.PaymentRecord npr = new ApplicationHistory.PaymentRecord();
            npr.PaymentNumber =str123;
            npr.Applicationtype =str123;
            npr.LicenseNumber =str123;
            npr.Applicant =str123;
            npr.FeeType =str123;
            npr.FeeAmount =str123;
            npr.PaymentAmount =str123;
            npr.PaidDate =str123;
            npr.PaidBy =str123;
            npr.ReceiptNumber =str123;
            npr.ReceiptId =str123;
            npr.CartId =str123; 
            nprlist.add(npr);
            System.assertEquals(1, rhc.feepayment.size());
        }
        
        Test.stopTest();
    }   
}