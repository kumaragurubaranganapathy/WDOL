global class Polaris_voucherAsPayment implements Database.batchable<SObject>, Database.Stateful {
    
    
    public Database.QueryLocator start(Database.BatchableContext objContext) {
        
        String query = DOL_AppConstants.NULL_EMPTY_STRING + 'SELECT Id, Name, MUSW__Amount_Tendered__c,MUSW__Paid_By__c,MUSW__Effective_Date__c, Validation_number__c FROM MUSW__Receipt__c where Validation_number__c !=null';
        return Database.getQueryLocator(query);
        
    }
    
    
    public void execute(Database.BatchableContext objContext, List<MUSW__Receipt__c> receipts) {
        
        
        // Map<List<MUSW__Receipt__c>, List<MUSW__Deposit__c>=new  Map<List<MUSW__Receipt__c>, List<MUSW__Deposit__c>(); 
     //   system.debug('hello');
     //   system.debug('the list of receipt records:' +receipts.size());
        List<MUSW__Deposit__c> dep=depositRecords();
      // system.debug('thre dep are' +dep.size());
        BGBK.Payable[] payables = new BGBK.Payable[]{};
            for (MUSW__Deposit__c deposit : dep){              
                payables.add(new BGBK.Payable(deposit, deposit.Amount__c));               
            }
        
        Map<MUSW__Receipt__c, Decimal> receiptMap = new Map<MUSW__Receipt__c, Decimal>();
        for(MUSW__Receipt__c rec : receipts){
            receiptMap.put(rec, rec.MUSW__Amount_Tendered__c);
        }
        
        DateTime myDateTime = DateTime.newInstance(2000, 7, 7, 7, 8, 12);
        BGBK.PaymentService paymentServiceObj = new BGBK.PaymentService();
        paymentServiceObj.processPayment(payables, receiptMap,null,myDateTime);
        
    }
    
    
    global void finish(Database.BatchableContext objBatchableContext) {
        
    }
    
    public static list<MUSW__Deposit__c> depositRecords(){
        List<MUSW__Deposit__c> deposits=[SELECT Id, Name, MUSW__Amount__c, Amount__c,Validation_number__c FROM MUSW__Deposit__c where Validation_number__c!=null];
        return deposits;
    }
    
}