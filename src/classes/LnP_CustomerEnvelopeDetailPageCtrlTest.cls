@isTest
public class LnP_CustomerEnvelopeDetailPageCtrlTest {

    public static testMethod void ceDetailsPageMethod(){
        Customer_Envelope__c ce = new Customer_Envelope__c();
        insert ce;
        
        Id AccRecTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('User Account').getRecordTypeId();
        Id ConRecTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Contact').getRecordTypeId();
        Id LicRecTypeId = Schema.SObjectType.MUSW__License2__c.getRecordTypeInfosByName().get('Individual').getRecordTypeId();
        
        Account acc = DOL_TestDataFactory.createAccount(AccRecTypeId);         
        Contact con = DOL_TestDataFactory.createContact(ConRecTypeId,acc.id);        
        
        MUSW__Deposit__c depRec = new MUSW__Deposit__c();       
        depRec.Amount__c = 100;
        depRec.MUSW__Transfered_In_Amount__c = 100;
        depRec.Validation_number__c = ce.Id;
        depRec.wadol_Program_Type__c = 'Architects';
        depRec.Contact__c = con.Id;
        depRec.MUSW__Account__c = acc.Id;
        insert depRec;   
        
             
        test.startTest();
        LnP_CustomerEnvelopeDetailPageCtrl.fetchDeposits(ce.Id);
        LnP_CustomerEnvelopeDetailPageCtrl.getObjViews();
        LnP_CustomerEnvelopeDetailPageCtrl.submitDeposits(ce.Id);
        test.stopTest();

        
    }
        
}