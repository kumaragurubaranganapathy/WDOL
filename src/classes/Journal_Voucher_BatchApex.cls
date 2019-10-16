global class Journal_Voucher_BatchApex implements Schedulable{

    global void execute(SchedulableContext SC){
        
        //Querying Items records so that they can be used to map the JV ans JVD fields
        BGBK__Item__c itemRecords=[select
                                   id, name,Transaction_Code__c,Program_Index__c,BGBK__Amount__c,GL_To_AFRS__c,BGBK__Fund__r.Accounting_System__c,
                                   BGBK__Fund__r.Fund__c,BGBK__Fund__r.Major_Group__c,BGBK__Fund__r.Major_Source__c,BGBK__Fund__r.Sub_Source__c
                                   FROM BGBK__Item__c WHERE GL_To_AFRS__c =: '3205' AND Payment_Method__c =: 'Cash'];
          //System.debug('the queried item records are:' +itemRecords);
        
     //Logic to insert JV records   
    Journal_Voucher__c journalVoucher = new Journal_Voucher__c();
    //journalVoucher.Document_Title__c = 'Journal Voucher';
    journalVoucher.Agency_Name__c='test';
    journalVoucher.Agency_No__c='2400';
    //journalVoucher.Document_Date__c=Date.today();
    journalVoucher.Current_Document_Number__c = '240VXXXX';
    journalVoucher.Ref_Document_Number__c='';
    journalVoucher.Explanation_of_Entry__c = 'Journal Voucher to record Portal credit card pending transactions.';
    journalVoucher.Distribution__c = '';
    journalVoucher.Prepared_By__c='';
    journalVoucher.Telephone_Number__c='';
    journalVoucher.Prepared_by_Date__c=date.today();
    journalVoucher.Approved_By__c='BATCH';
    journalVoucher.Approved_by_Date__c=date.today();
    //System.debug('the journalVoucher records are:' +journalVoucher);
    insert journalVoucher;
    
    //Logic to insert child record
    
    /* Journal_Voucher_Detail__c JVD = new Journal_Voucher_Detail__c();
     JVD.Reference_Document_Suffix__c= '';
     JVD.Transaction_Code__c = itemRecords.Transaction_Code__c;
     JVD.Agency__c = '';
     JVD.Fund__c = itemRecords.BGBK__Fund__c;
     JVD.Program_Index__c=itemRecords.Program_Index__c;
     JVD.Major_Group__c = '';
     JVD.Major_Source__c ='';
     JVD.Sub_Source__c = '';
     JVD.Amount__c=itemRecords.BGBK__Amount__c;
     JVD.General_Ledger_Account__c=itemRecords.GL_To_AFRS__c;
     JVD.Subsidiary_Account_Debit__c = '';
     JVD.Subsidiary_Account_Credit__c ='';
     JVD.JournalVoucher__c = journalVoucher.Id; 
     insert JVD;*/
    }
}