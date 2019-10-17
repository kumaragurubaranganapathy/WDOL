@isTest
public class JVExtension_Test {
    @isTest static void test_method_one(){
        JV_Sequence__c objJVSeq = new JV_Sequence__c(Current_sequence__c =0.0);
        insert objJVSeq;
        
        Journal_Voucher__c objJV = new Journal_Voucher__c(Document_Type__c='ManualTransfer - User Created');
        objJV.Document_Date__c = system.today();
        objJV.RecordTypeID=Schema.SObjectType.Journal_Voucher__c.getRecordTypeInfosByName().get('Journal Voucher Manual').getRecordTypeId();
        insert objJV;
        
        
        
        Journal_Voucher_Detail__c objJVD = new Journal_Voucher_Detail__c(Amount__c = 100,Add_to_PDF__c = true);
        objJVD.JournalVoucher__c =objJV.id;
        insert objJVD;
        
        ApexPages.StandardController sc = new ApexPages.StandardController(objJV);
        JVExtension JVextn = new JVExtension(sc);
    }
    @isTest static void test_method_two(){
        JV_Sequence__c objJVSeq = new JV_Sequence__c(Current_sequence__c =9999.0);
        insert objJVSeq;
        
        Journal_Voucher__c objJV = new Journal_Voucher__c(Document_Type__c='Manual IAP -user created to ensure document # matches OFM/AFRS');
        objJV.Document_Date__c = system.today();
        objJV.Current_Document_Number__c='1233';
        objJV.RecordTypeID=Schema.SObjectType.Journal_Voucher__c.getRecordTypeInfosByName().get('Journal Voucher Manual').getRecordTypeId();
        insert objJV;
        
        
    }
    @isTest static void test_method_three(){
        JV_Sequence__c objJVSeq = new JV_Sequence__c(Current_sequence__c =95.0);
        insert objJVSeq;
        
        Journal_Voucher__c objJV = new Journal_Voucher__c(Document_Type__c='Manual IAP -user created to ensure document # matches OFM/AFRS');
        objJV.Document_Date__c = system.today();
        objJV.Current_Document_Number__c='1233';
        objJV.RecordTypeID=Schema.SObjectType.Journal_Voucher__c.getRecordTypeInfosByName().get('Journal Voucher Manual').getRecordTypeId();
        insert objJV;
        
        
    }
    @isTest static void test_method_four(){
        JV_Sequence__c objJVSeq = new JV_Sequence__c(Current_sequence__c =998.0);
        insert objJVSeq;
        
        Journal_Voucher__c objJV = new Journal_Voucher__c(Document_Type__c='Manual CRJSfor Daily -Lockbox  240Q');
        objJV.Document_Date__c = system.today();
        objJV.RecordTypeID=Schema.SObjectType.Journal_Voucher__c.getRecordTypeInfosByName().get('Journal Voucher Manual').getRecordTypeId();
        insert objJV;
        
        
    }
}