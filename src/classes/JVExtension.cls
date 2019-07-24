public class JVExtension {
    
    public List<Journal_Voucher_Detail__c> jvd{get;set;} 
    
    public Journal_Voucher__c jv {get;set;} 
    public string documentDate {get;set;} 
    public string preparedByDate {get;set;} 
    public Decimal Amt {get;set;} 
    
    public JVExtension(ApexPages.StandardController controller) { 
        
            jv = (Journal_Voucher__c)controller.getRecord();  
            jv=[select Document_Date__c,createddate,Prepared_by_Date__c from Journal_Voucher__c where id =:jv.Id];
            if(jv.Document_Date__c != null){
            	documentDate = jv.Document_Date__c.format();
            }
            date createdDate = date.valueOf(jv.createddate);
            	preparedByDate =createdDate.format();
            
            jvd = [SELECT id,Add_to_Interface__c,Add_to_PDF__c, Agency__c, Amount__c,Debit_Credit__c,Fund__c,General_Ledger_Account__c,JournalVoucher__r.Amount__c,Major_Group__c,Major_Source__c,Program_Index__c,Reference_Document_Suffix__c,Reversal__c,Subsidiary_Account_Credit__c,Subsidiary_Account_Debit__c,Sub_Source__c,Target_Accounting_System__c,Transaction_Code__c FROM Journal_Voucher_Detail__c WHERE JournalVoucher__c = :jv.id and Add_to_PDF__c = true];     
             Amt=0;
            for(Journal_Voucher_Detail__c jvdrec:jvd){
                if(jvdrec.Amount__c != null)
              	Amt= Amt+jvdrec.Amount__c.abs();
            }
            
        
    }
}