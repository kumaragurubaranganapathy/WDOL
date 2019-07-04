/**
    * Batch class which Creates JV and JVD records
    * <p /><p />
    * @author Nazneen Begum
    */
    global class LnP_Journal_Voucher implements Database.batchable<SObject>, Database.Stateful {
        
        private static List<DOL_AppUtility.JournalWrapper> lstData = new List<DOL_AppUtility.JournalWrapper>();
        
        /**
         * Starts the execution of the scheduled process.
         *
         * @param objSchedulableContext Schedulable context.
         */
        public Database.QueryLocator start(Database.BatchableContext objContext) {
             system.debug('the queried item records');
            string strValueIntakeMethod='Counter';
            string strValuePaymentMethodCash='Cash';
            string strValuePaymentMethodCheck='Check';
            string strValuePaymentMethodMoneyOrder='Money Order';
            string strValuePaymentMethodVitalCheck='Vital Check';
            string strTargetAccountingSystemTMS='TMS';
            string strTargetAccountingSystemAFRS='AFRS';
            string strTraansactionCode='770';
            string strGL='7110';  
            
           String strQuery = 'SELECT id, name,BGBK__Fund__r.GL__c,Transaction_Code__c,Program_Index__c,BGBK__Amount__c,GL_To_AFRS__c,BGBK__Fund__r.Accounting_System__c,BGBK__Fee__r.Agency__c, ';
            strQuery+='BGBK__Fund__r.Fund__c,Intake_Method__c,Payment_Method__c,BGBK__Fund__r.Major_Group__c,BGBK__Fund__r.Major_Source__c,BGBK__Fund__r.Sub_Source__c ';
            strQuery+='FROM BGBK__Item__c WHERE BGBK__Fund__r.Accounting_System__c IN '+'('+'\''+String.escapeSingleQuotes(strTargetAccountingSystemAFRS)+'\'';
			strQuery+=','+'\''+String.escapeSingleQuotes(strTargetAccountingSystemTMS)+'\''+') AND Payment_Method__c IN ('+'\''+String.escapeSingleQuotes(strValuePaymentMethodCash)+'\'';
            strQuery+=','+'\''+String.escapeSingleQuotes(strValuePaymentMethodCheck)+'\''+','+'\''+String.escapeSingleQuotes(strValuePaymentMethodMoneyOrder)+'\'';
            strQuery+=','+'\''+String.escapeSingleQuotes(strValuePaymentMethodVitalCheck)+'\''+')';
            strQuery+=' AND Intake_Method__c=\''+String.escapeSingleQuotes(strValueIntakeMethod)+ '\'';
            //strQuery+=','+'\''+String.escapeSingleQuotes(BGBK__Transaction__r.BGBK__Effective_Date__c)+'\''+')';
            //strQuery+=' AND Intake_Method__c=\''+String.escapeSingleQuotes(strValueIntakeMethod)+ '\'';
            //CreatedDate = YESTERDAY
            
            return Database.getQueryLocator(strQuery);
            
        }
        
        /**
         * Executes the required operations over the found records.
         *
         * @param objBatchableContext Batchable context.
         * @param lstJVRecordsToInsert List of records of the current batch.
         */
        public void execute(Database.BatchableContext objContext, List<BGBK__Item__c> lstRecords) {
            system.debug('inside execute method');
           system.debug('the queried item records' +lstRecords.size());
          
            List<BGBK__Item__c> lstAFRS = new List<BGBK__Item__c>();
            List<BGBK__Item__c> lstTMS = new List<BGBK__Item__c>();
            
            Map<String, List<BGBK__Item__c>> mapItemsData = new Map<String, List<BGBK__Item__c>>();
            Map<String, Decimal> mapTotalItemAmount = new Map<String, Decimal>();
            String sToBeSortedFields= null;
                
            for(BGBK__Item__c items:lstRecords){
                system.debug('inside for loop' +items);
                if((items.BGBK__Fund__r.Accounting_System__c == 'TMS')) 
               {
                   sToBeSortedFields = items.Transaction_Code__c+''+items.Program_Index__c+''
                    +items.BGBK__Fund__r.Fund__c+''+items.GL_To_AFRS__c+items.BGBK__Fund__r.GL__c+'';
               }
                    //lstAFRS.add(items);//10 records
                     //String sToBeSortedFields=null;
                   //if(){if TMS
                   //sToBeSortedFields=;
                   //}
                  /*  String sToBeSortedFields = items.Transaction_Code__c+''+items.Program_Index__c+''
                    +items.BGBK__Fund__r.Fund__c+''+items.GL_To_AFRS__c+items.BGBK__Fund__r.GL__c+'';*/
                if((items.BGBK__Fund__r.Accounting_System__c == 'AFRS')){
                    
                    sToBeSortedFields = items.Transaction_Code__c+''+items.Program_Index__c+''
                    +items.BGBK__Fund__r.Fund__c+''+items.GL_To_AFRS__c+items.BGBK__Fund__r.GL__c+'';

                }
                
                    if(mapItemsData <> null && mapItemsData.get(sToBeSortedFields) <> null)
                    {
                        mapItemsData.get(sToBeSortedFields).add(items);
                    }
                    else
                    {
                        mapItemsData.put(sToBeSortedFields, new List<BGBK__Item__c>{items});
                    }
                    Decimal dTemp = 0.0;
                    if(mapTotalItemAmount <> null && mapTotalItemAmount.get(sToBeSortedFields) <> null)
                    {
                        dTemp+= mapTotalItemAmount.get(sToBeSortedFields) + items.BGBK__Amount__c.abs();
                        mapTotalItemAmount.remove(sToBeSortedFields);
                        
                    }
                    else
                    {
                        dTemp+= items.BGBK__Amount__c.abs();
                    }
                    
                    System.debug('What is the Amount Coming in For Nazneen to Check '+dTemp);
                    mapTotalItemAmount.put(sToBeSortedFields, dTemp);
                    
                
                             
            }
           
            List<String> lstNewSort = new List<String>();
            lstNewSort.addAll(mapTotalItemAmount.keyset());
            
            lstNewSort.sort();
            
            if(mapTotalItemAmount <> null)
            {
                for(String s :lstNewSort)
                {
                    if(mapItemsData <> null && mapItemsData.get(s) <> null)
                    {
                        DOL_AppUtility.JournalWrapper oData = new DOL_AppUtility.JournalWrapper(mapItemsData.get(s)[0], mapTotalItemAmount.get(s));
                        lstData.add(oData);
                    }
                }
            }
            
            
            System.debug(' Nazneen To Get Sorted Date '+ lstData);
            
            //Logic to insert JV records   
        Journal_Voucher__c journalVoucher = new Journal_Voucher__c();
        journalVoucher.Journal_Voucher_Type__c='Counter Funds Received';
        journalVoucher.Document_Title__c = 'CRJS';
        journalVoucher.Agency_Name__c='Department of Licensing';
        journalVoucher.Agency_No__c='2400';
        journalVoucher.Document_Date__c=Date.today();
        journalVoucher.Current_Document_Number__c = '240EXXXX';
        journalVoucher.Ref_Document_Number__c='';
        journalVoucher.Explanation_of_Entry__c = 'CRJS to record daily receipts from counter.';
            for(BGBK__Item__c items:lstRecords){
        journalVoucher.Distribution__c = items.BGBK__Fund__r.Accounting_System__c;
            }
        journalVoucher.Prepared_By__c='System Generated';
        journalVoucher.Telephone_Number__c='';
        journalVoucher.Prepared_by_Date__c=date.today();
        journalVoucher.Approved_By__c='BATCH';
        journalVoucher.Approved_by_Date__c=date.today();
        journalVoucher.Date_of_Deposit__c=date.today();
        system.debug('the journalVoucher records are:' +journalVoucher);
        insert journalVoucher;
        
        //Logic to insert child record
      List <Journal_Voucher_Detail__c> listJVD = new List <Journal_Voucher_Detail__c>();
            //chcek lst is not eqaul to empty, and is empty should be false
            if(!lstData.isEmpty() && lstData <> null){
            for(DOL_AppUtility.JournalWrapper lst:lstData){
              Journal_Voucher_Detail__c JVD=new Journal_Voucher_Detail__c();
         JVD.Target_Accounting_System__c =lst.objItemsData.BGBK__Fund__r.Accounting_System__c;
         //JVD.Add_to_PDF__c=lst.objItemsData.
         //JVD.Add_to_Interface__c=
         JVD.Reference_Document_Suffix__c= '';
         JVD.Transaction_Code__c = lst.objItemsData.Transaction_Code__c;
         if( lst.objItemsData.Transaction_Code__c !=null &&  lst.objItemsData.Transaction_Code__c == 'R'){       
         JVD.Reversal__c='R';
          }else{
                JVD.Reversal__c ='';
                 }
         //JVD.Agency__c =  lst.objItemsData.BGBK__Fee__r.Agency__c;
         JVD.Fund__c =  lst.objItemsData.BGBK__Fund__r.Fund__c;
        // JVD.Program_Index__c= lst.objItemsData.Program_Index__c;
        JVD.Program_Index__c= '';
         JVD.Major_Group__c = lst.objItemsData.BGBK__Fund__r.Major_Group__c;
         JVD.Major_Source__c =  lst.objItemsData.BGBK__Fund__r.Major_Source__c;
         JVD.Sub_Source__c =  lst.objItemsData.BGBK__Fund__r.Sub_Source__c;
                 if( lst.objItemsData.BGBK__Amount__c != null &  lst.objItemsData.BGBK__Amount__c<0){
         JVD.Debit_Credit__c='CR';
             }else{
                JVD.Debit_Credit__c='DR'; 
             }
                 
         JVD.Amount__c= lst.iTotalAmount;
        // JVD.General_Ledger_Account__c= lst.objItemsData.GL_To_AFRS__c;
         //JVD.Subsidiary_Account_Debit__c = '';
         //JVD.Subsidiary_Account_Credit__c ='';
         JVD.JournalVoucher__c = journalVoucher.Id; 
                
                listJVD.add(JVD);
            }     
            
          system.debug('before insert' +listJVD);  
         insert listJVD;
        }
            
        }
        
        /**
         * Implemented method on finish.
         *
         * @param objBatchableContext Batchable context.
         */
        global void finish(Database.BatchableContext objBatchableContext) {}
    }