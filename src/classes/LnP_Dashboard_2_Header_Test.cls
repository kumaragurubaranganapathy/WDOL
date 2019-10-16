/*
 *@authur 
 */ 
@isTest
public class LnP_Dashboard_2_Header_Test {
    public static testmethod void LnP_Dashboard_2_HeaderConstructor(){
        Id RecordTypeIdContact = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Contact').getRecordTypeId();
        ID RecordTypeIdAccount = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Business Account').getRecordTypeId();
        Contact conObj= DOL_TestDataFactory.createContact(RecordTypeIdContact,DOL_TestDataFactory.createAccount(RecordTypeIdAccount).Id) ;
        Test.startTest();
        conObj=LnP_Dashboard_2_Header_ApexController.getContact();
        LnP_Dashboard_2_Header_ApexController.getAddressDetails();
        LnP_Dashboard_2_Header_ApexController.checkActiveCart();
        LnP_Dashboard_2_Header_ApexController.insertRequest('test');       
        Test.stopTest();
        //system.debug('conObj : '+conObj);
        //system.assert(conObj != null );
        
        
    }
    
}