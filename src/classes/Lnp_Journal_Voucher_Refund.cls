/* Author : Vinanthi
   Date : 6/27/2019
*/
global class Lnp_Journal_Voucher_Refund implements Database.batchable<SObject>, Database.Stateful{
    	integer BienniumYear = 0;
        integer FiscalMonth  =0;
        integer FiscalYear = 0;
    map<String,List<BGBK__Item__c>> mapRefundIDItem= new map<String,List<BGBK__Item__c>>();
    public Database.QueryLocator start(Database.BatchableContext objContext) {
        //Code to calculate Fiscal Year,Fiscal Month and Biennium Year start
        Date currentDate = system.today();
        integer currentYear =currentDate.year();
        integer currentMonth =currentDate.month();
        
        
        
        if(math.mod(currentYear,2)==1){
            if(currentMonth > 6){
                 BienniumYear =   currentYear+2;
                FiscalMonth = currentMonth-6;
                FiscalYear = 01;
            }
            else {
                 BienniumYear = currentYear;
                FiscalYear = 02;
                FiscalMonth = currentMonth + 18;
            }
            
        }
        else{
            BienniumYear =   currentYear+1;
             FiscalMonth = currentMonth + 6;
            if(currentMonth > 6){
                 
               
                FiscalYear = 02;
            }
            else {
                 
                FiscalYear = 01;
                
            }
        }

        //Code to calculate Fiscal Year,Fiscal Month and Biennium Year end
   // List<Journal_Voucher_meta__mdt> lstJVMeta = [select id,MasterLabel,JV_Document_Title__c,JV_Explanation_of_Entry__c from Journal_Voucher_meta__mdt WHERE Is_Active__c = true ];
    String strQuery = 'SELECT id,Receipt_Refund__c,Receipt_Refund__r.BGBK__Refund2__c,BGBK__Refund2__c, name,BGBK__Fund__r.GL__c,Agency__c,Transaction_Code_Type__c,Debit_Credit__c,Transaction_Code__c,Program_Index__c,BGBK__Amount__c,GL_To_AFRS__c,BGBK__Fund__r.Accounting_System__c,BGBK__Fee__r.Agency__c, ';
            strQuery+='BGBK__Fund__r.Fund__c,Intake_Method__c,Payment_Method__c,BGBK__Fund__r.Major_Group__c,BGBK__Fund__r.Major_Source__c,BGBK__Fund__r.Sub_Source__c ';
            strQuery+='FROM BGBK__Item__c WHERE Journal_Voucher_Detail__c = null AND (BGBK__Refund2__c != null OR Receipt_Refund__c != null )';
            
        return Database.getQueryLocator(strQuery);
    }
 public void execute(Database.BatchableContext objContext, List<BGBK__Item__c> lstItemRecords) {
        List<Journal_Voucher__c> lstJV= new List<Journal_Voucher__c>();
        List <Journal_Voucher_Detail__c> listJVDtoInsert = new List <Journal_Voucher_Detail__c>();
        List<DOL_AppUtility.JournalWrapper> lstJVDWrapperData = new List<DOL_AppUtility.JournalWrapper>();
        List<BGBK__Item__c> lstItemRecordsForJV = new List<BGBK__Item__c>();
        Map<String, List<BGBK__Item__c>> mapItemsData = new Map<String, List<BGBK__Item__c>>();
        Map<String, Decimal> mapTotalItemAmount = new Map<String, Decimal>();
     	Map<String, String> mapTotalItemIds = new Map<String, String>();
        Map<String, String> mapRefundIDItemID = new Map<String, String>();
     	Map<String, String> mapItemIDRefundID = new Map<String, String>();
     	Map<String, String> mapRefundIDjvID = new Map<String, String>();
     	decimal currentSeq=0 ;
     
        String sToBeGroupedFields= null;
     for(BGBK__Item__c objItem : lstItemRecords){
         if(objItem.BGBK__Refund2__c != null){
             mapRefundIDItemID.put(objItem.BGBK__Refund2__c, objItem.Id);
             mapItemIDRefundID.put(objItem.Id, objItem.BGBK__Refund2__c);
         }
         else{
             mapRefundIDItemID.put(objItem.Receipt_Refund__r.BGBK__Refund2__c,objItem.Id);
             mapItemIDRefundID.put(objItem.Id, objItem.Receipt_Refund__r.BGBK__Refund2__c);
         }
         
         
         if(mapRefundIDItem.containsKey(mapItemIDRefundID.get(objItem.Id))){
             //mapRefundIDItem.get(mapRefundIDItemID.get(objItem.Id)).add(objItem);
         }
         else{
             List<BGBK__Item__c> lstItem = new List <BGBK__Item__c>();
             lstItem.add(objItem);
             mapRefundIDItem.put(mapItemIDRefundID.get(objItem.Id), lstItem);
         }
        
         
     }  
     system.debug('mapRefundIDItemID'+mapRefundIDItemID);
     system.debug('mapRefundIDItem$$'+mapRefundIDItem);
     system.debug('mapItemIDRefundID'+mapItemIDRefundID);
     JV_Sequence__c objJVseq =[SELECT Current_sequence__c,id from JV_Sequence__c limit 1];
        if(objJVseq.id != null){
            currentSeq=objJVseq.Current_sequence__c;
        }
     //Insert JV
     for(String refundID:mapRefundIDItem.keySet()){
         system.debug('refundID$$'+refundID);
        Journal_Voucher__c objJV = new  Journal_Voucher__c();
         objJV.Journal_Voucher_Type__c= 'Refund JV';
            objJV.Document_Title__c = 'Refund JV';
            objJV.Agency_Name__c='Department of Licensing';
            objJV.Agency_No__c='2400';
            objJV.Document_Date__c=Date.today();
            objJV.Explanation_of_Entry__c = 'Refund';
            objJV.Distribution__c ='';// Check with David
            objJV.Prepared_By__c='System Generated';
            objJV.Refund1__c=refundID;
            objJV.Approved_By__c='BATCH';
            objJV.Approved__c=true;
            objJV.Approved_by_Date__c=date.today();
            objJV.Date_of_Deposit__c=date.today();
         	string sTemp =String.Valueof(FiscalMonth);
             if(sTemp.length() == 1){
                 sTemp = '0'+ sTemp;
             }
             objJV.Fiscal_Month__c =sTemp;
             sTemp =String.Valueof(FiscalYear);
             if(sTemp.length() == 1){
                 sTemp = '0'+ sTemp;
             }
             objJV.Fiscal_Year__c =sTemp;
            //objJV.Fiscal_Month__c =FiscalMonth;
            //objJV.Fiscal_Year__c =FiscalYear;
            objJV.Biennium_Year__c= String.valueOf(BienniumYear); 
            objJV.RecordTypeId =Schema.SObjectType.Journal_Voucher__c.getRecordTypeInfosByName().get('Journal Voucher Automated').getRecordTypeId();
         	if(currentSeq > 9998){
                currentSeq =0;
            } else{
            	currentSeq++;
            }
             sTemp =String.Valueof(currentSeq);
            if(sTemp.length() == 1){
                sTemp = '000'+ sTemp;
            }
            else if(sTemp.length() == 2){
                sTemp = '00'+ sTemp;
            }
            else if(sTemp.length() == 3){
                sTemp = '0'+ sTemp;
            }
            objJV.Current_Document_Number__c='240V'+ sTemp;
         
         	lstJV.add(objJV);
     	}
     	if(lstJV.size()>0){
            Insert lstJV;
            for(Journal_Voucher__c objJV:lstJV){
                mapRefundIDjvID.put(objJV.Refund1__c, objJV.Id);
            }
        }
     if(objJVseq.id != null){
            objJVseq.Current_sequence__c=currentSeq;
            update objJVseq;
        }
     system.debug('mapRefundIDjvID$$'+mapRefundIDjvID);
        for(BGBK__Item__c objItem : lstItemRecords){
            system.debug('lstItemRecords$$'+lstItemRecords);
            system.debug('mapRefundIDjvID.get(mapItemIDRefundID.get(objItem.Id));$$'+mapRefundIDjvID.get(mapItemIDRefundID.get(objItem.Id)));
            objItem.Journal_Voucher__c = mapRefundIDjvID.get(mapItemIDRefundID.get(objItem.Id));
                
                lstItemRecordsForJV.add(objItem);
                //Aggregate item records for TMS accounting system
               if((objItem.BGBK__Fund__r.Accounting_System__c == 'TMS')){
                   sToBeGroupedFields = objItem.Transaction_Code__c+objItem.Program_Index__c
                    +objItem.BGBK__Fund__r.Fund__c+objItem.GL_To_AFRS__c+objItem.Agency__c+objItem.Transaction_Code_Type__c+objItem.Debit_Credit__c+mapItemIDRefundID.get(objItem.Id);
               }
                	//Aggregate item records for AFRS accounting system
                   else if((objItem.BGBK__Fund__r.Accounting_System__c == 'AFRS')){
                        
                        sToBeGroupedFields = objItem.Transaction_Code__c+objItem.Program_Index__c
                        +objItem.BGBK__Fund__r.Fund__c+objItem.GL_To_AFRS__c+objItem.Agency__c+
                       objItem.BGBK__Fund__r.Major_Group__c+objItem.BGBK__Fund__r.Major_Source__c+objItem.BGBK__Fund__r.Sub_Source__c+objItem.Transaction_Code_Type__c+objItem.Debit_Credit__c+mapItemIDRefundID.get(objItem.Id);
                    } 
                
               // Group item records in  mapItemsData based on agregation
               if(mapItemsData <> null && mapItemsData.containsKey(sToBeGroupedFields)){
          			mapItemsData.get(sToBeGroupedFields).add(objItem);
                }
                else{
                       mapItemsData.put(sToBeGroupedFields, new List<BGBK__Item__c>{objItem});
                    }
                
                //Calculate total amount of grouped item records
                Decimal dTemp = 0.0;
                if(mapTotalItemAmount <> null && mapTotalItemAmount.containsKey(sToBeGroupedFields)){
                	dTemp = mapTotalItemAmount.get(sToBeGroupedFields) + objItem.BGBK__Amount__c.abs();
                }
                else{
                    dTemp = objItem.BGBK__Amount__c.abs();
                }
                mapTotalItemAmount.put(sToBeGroupedFields, dTemp);
                
                //Stamp Item id on JVD record
                String sTemp = '';
                if(mapTotalItemIds <> null && mapTotalItemIds.containsKey(sToBeGroupedFields)){
                    sTemp = mapTotalItemIds.get(sToBeGroupedFields) +','+objItem.Id;
                }
                else{
                    sTemp= objItem.Id;
                }
                mapTotalItemIds.put(sToBeGroupedFields, sTemp);
            
        }
        
        for(string str :mapItemsData.keyset()){
            DOL_AppUtility.JournalWrapper oData = new DOL_AppUtility.JournalWrapper(mapItemsData.get(str)[0], mapTotalItemAmount.get(str), mapTotalItemIDs.get(str));
            lstJVDWrapperData.add(oData);
        }
        
        //Generate JVD record
        for(DOL_AppUtility.JournalWrapper objJournalWrapper:lstJVDWrapperData){
            Journal_Voucher_Detail__c objJVD=new Journal_Voucher_Detail__c();
            
            objJVD.Target_Accounting_System__c =objJournalWrapper.objItemsData.BGBK__Fund__r.Accounting_System__c;
            //objJVD.Transaction_Code__c = objJournalWrapper.objItemsData.Transaction_Code__c;
            if(objJournalWrapper.objItemsData.BGBK__Fund__r.Accounting_System__c == 'AFRS'){
                objJVD.AFRS_Transaction_Code__c=objJournalWrapper.objItemsData.Transaction_Code__c;  
            }
            if(objJournalWrapper.objItemsData.BGBK__Fund__r.Accounting_System__c == 'TMS'){
                objJVD.TMS_Transaction_Code__c=objJournalWrapper.objItemsData.Transaction_Code__c;
            }
            objJVD.Reversal__c = objJournalWrapper.objItemsData.Transaction_Code_Type__c;     
            objJVD.Agency__c =  objJournalWrapper.objItemsData.Agency__c;
            objJVD.Fund__c =  objJournalWrapper.objItemsData.BGBK__Fund__r.Fund__c;
            objJVD.Major_Group__c = objJournalWrapper.objItemsData.BGBK__Fund__r.Major_Group__c;
            objJVD.Major_Source__c =  objJournalWrapper.objItemsData.BGBK__Fund__r.Major_Source__c;
            objJVD.Sub_Source__c =  objJournalWrapper.objItemsData.BGBK__Fund__r.Sub_Source__c;
            objJVD.Debit_Credit__c=objJournalWrapper.objItemsData.Debit_Credit__c;  
            objJVD.Item_record_IDs__c =   objJournalWrapper.sItemIDs;   
            objJVD.Amount__c= objJournalWrapper.iTotalAmount;
            objJVD.General_Ledger_Account__c= objJournalWrapper.objItemsData.GL_To_AFRS__c;
            objJVD.Subsidiary_Account_Debit__c = '';
            objJVD.Subsidiary_Account_Credit__c ='';
            objJVD.JournalVoucher__c = objJournalWrapper.objItemsData.Journal_Voucher__c; 
            objJVD.Add_to_Interface__c=true;
            objJVD.Add_to_PDF__c=true;
            
            
            listJVDtoInsert.add(objJVD);
        }
        if(listJVDtoInsert.size()>0){
        	 Insert listJVDtoInsert;
        }
        //stamp JVD id on Item record.
         List<BGBK__Item__c> lstItemToUpdate= new List<BGBK__Item__c>();
           for(Journal_Voucher_Detail__c objJVD:listJVDtoInsert){
                    
               List<String> lstItemIds = objJVD.Item_record_IDs__c.split(',');
               for(string sItemId:lstItemIds){
                        BGBK__Item__c objItem = new BGBK__Item__c();
                        objItem.Id =sItemId;
                        objItem.Journal_Voucher_Detail__c = objJVD.id;
                        lstItemToUpdate.add(objItem);
                  }
                    
              }
        if(lstItemToUpdate.size()>0){
        	 update lstItemToUpdate;
        }
    }
    
    global void finish(Database.BatchableContext objBatchableContext) {}

}