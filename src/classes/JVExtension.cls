public class JVExtension {
    
    public List<Journal_Voucher_Detail__c> jvd{get;set;} 
    
    public Journal_Voucher__c jv {get;set;} 
    
    public JVExtension(ApexPages.StandardController controller) { 
        
        jv = (Journal_Voucher__c)controller.getRecord();      
        
        jvd = [SELECT id,Add_to_Interface__c,Add_to_PDF__c, Agency__c, Amount__c,Debit_Credit__c,Fund__c,General_Ledger_Account__c,JournalVoucher__r.Amount__c,Major_Group__c,Major_Source__c,Program_Index__c,Reference_Document_Suffix__c,Reversal__c,Subsidiary_Account_Credit__c,Subsidiary_Account_Debit__c,Sub_Source__c,Target_Accounting_System__c,Transaction_Code__c FROM Journal_Voucher_Detail__c WHERE JournalVoucher__c = :jv.id];     
        
    }
}