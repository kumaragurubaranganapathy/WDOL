/* Author : Vinanthi
Date : 6/12/2019
*/
global class Lnp_Journal_Voucher_Generic implements Database.batchable<SObject>, Database.Stateful{
    
    map<String,String> mapJVNameID= new map<String,String>();
    map<String,String> mapJVFilterJVName= new map<String,String>();
    map<String,Boolean> mapJVFilterAddToPDF= new map<String,Boolean>();
    map<String,Boolean> mapJVFilterAddToInterface= new map<String,Boolean>();
    List<string> lstJVID = new List<string>();
    List<Journal_Voucher_meta__mdt> lstJVMeta = new List<Journal_Voucher_meta__mdt>();
    List<Journal_Voucher__c> lstJV= new List<Journal_Voucher__c>();
    JV_Sequence__c objJVseq = new JV_Sequence__c();
    decimal currentSeq=0 ;
    //BUG-7053 start
    Set<String> jvIdSet = new Set<String>();
    Set<String> itemSetKey =  new Set<String>();
            
    public Database.QueryLocator start(Database.BatchableContext objContext) {
        try{  
           // system.debug('$$start method');
        datetime currentTime= system.now();
        Decimal currentHour= currentTime.hourGmt();
        
        //Code to calculate Fiscal Year,Fiscal Month and Biennium Year start
        Date currentDate = system.today();
        integer currentYear =currentDate.year();
        integer currentMonth =currentDate.month();
        
        integer BienniumYear = 0;
        integer FiscalMonth  =0;
        integer FiscalYear = 0;
        
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
        
         objJVseq =[SELECT Current_sequence__c,id from JV_Sequence__c limit 1];
        if(objJVseq.id != null){
            currentSeq=objJVseq.Current_sequence__c;
        }
        //List<Journal_Voucher_meta__mdt> lstJVMeta = new List<Journal_Voucher_meta__mdt>();
      //  system.debug('Label.ConsiderBatchTime$$'+Label.ConsiderBatchTime);
        string considerBatchTime = Label.ConsiderBatchTime;
        if(Test.isRunningTest()){
            considerBatchTime ='No';
        }
        //Use below lines only for testing
        //considerBatchTime ='No';
        if(considerBatchTime == 'Yes'){
            lstJVMeta = [select id,MasterLabel,JV_Document_Title__c,Doc_Number_Prefix__c,JV_Explanation_of_Entry__c,(select id,Add_To_PDF__c,Add_To_Interface__c,JV_name__c,Item_FundAccSystem__c,Item_Fund_GL__c,Item_Intake_Method__c,Item_Payment_Method__c,Item_Transaction_Code__c,Journal_Voucher_mtd__c,Item_Transaction_Type__c from Journal_Voucher_Filters__r) from Journal_Voucher_meta__mdt WHERE Is_Active__c = true and Is_Active__c!= null AND Batch_Time__c =: currentHour and Batch_Time__c!=null];
        
        }
        else{
            lstJVMeta  = [select id,MasterLabel,JV_Document_Title__c,Doc_Number_Prefix__c,JV_Explanation_of_Entry__c,(select id,Add_To_PDF__c,Add_To_Interface__c,JV_name__c,Item_FundAccSystem__c,Item_Fund_GL__c,Item_Intake_Method__c,Item_Payment_Method__c,Item_Transaction_Code__c,Journal_Voucher_mtd__c,Item_Transaction_Type__c from Journal_Voucher_Filters__r) from Journal_Voucher_meta__mdt WHERE Is_Active__c = true and Is_Active__c!= null];
        }
        //system.debug('lstJVMetadata=='+lstJVMeta);
        for(Journal_Voucher_meta__mdt objJVMeta:lstJVMeta){
            Journal_Voucher__c objJV = new Journal_Voucher__c(); 
            for(Journal_Voucher_Filter__mdt objJVFilterMeta : objJVMeta.Journal_Voucher_Filters__r){
                string strFilterKey;
                 if(objJVFilterMeta.Item_Payment_Method__c == 'Any' ){
                    strFilterKey= objJVFilterMeta.Item_Intake_Method__c+objJVFilterMeta.Item_FundAccSystem__c+objJVFilterMeta.Item_Transaction_Code__c+objJVFilterMeta.Item_Fund_GL__c+objJVFilterMeta.Item_Transaction_Type__c; 
                 }else{
                    strFilterKey= objJVFilterMeta.Item_Intake_Method__c+objJVFilterMeta.Item_Payment_Method__c+objJVFilterMeta.Item_FundAccSystem__c+objJVFilterMeta.Item_Transaction_Code__c+objJVFilterMeta.Item_Fund_GL__c+objJVFilterMeta.Item_Transaction_Type__c;
                }
                mapJVFilterJVName.put(strFilterKey, objJVFilterMeta.JV_name__c);
                mapJVFilterAddToPDF.put(strFilterKey, objJVFilterMeta.Add_To_PDF__c);
                mapJVFilterAddToInterface.put(strFilterKey, objJVFilterMeta.Add_To_Interface__c);
            }
          //  system.debug('mapJVFilterAddToInterface$$'+mapJVFilterAddToInterface);
            objJV.Journal_Voucher_Type__c= objJVMeta.MasterLabel;
            objJV.Document_Type__c = objJVMeta.MasterLabel;
            objJV.Document_Title__c = objJVMeta.JV_Document_Title__c;
            objJV.Agency_Name__c= DOL_AppConstants.NULL_EMPTY_STRING + 'Department of Licensing';
            objJV.Agency_No__c= DOL_AppConstants.NULL_EMPTY_STRING + '2400';
            objJV.Document_Date__c=Date.today();
            objJV.Explanation_of_Entry__c = objJVMeta.JV_Explanation_of_Entry__c;
            objJV.Distribution__c = DOL_AppConstants.NULL_EMPTY_STRING + '';// Check with David
            objJV.Prepared_By__c= DOL_AppConstants.NULL_EMPTY_STRING + 'System Generated';
            objJV.Prepared_by_Date__c=date.today();
            objJV.Approved_By__c= DOL_AppConstants.NULL_EMPTY_STRING + 'BATCH';
            objJV.Approved__c=true;
            objJV.Approved_by_Date__c=date.today();
            objJV.Date_of_Deposit__c=date.today();
            string sTemp =String.Valueof(FiscalMonth);
             if(sTemp.length() == 1){
                 sTemp = DOL_AppConstants.NULL_EMPTY_STRING + '0'+ sTemp;
             }
             objJV.Fiscal_Month__c =sTemp;
             sTemp =String.Valueof(FiscalYear);
             if(sTemp.length() == 1){
                 sTemp = DOL_AppConstants.NULL_EMPTY_STRING + '0'+ sTemp;
             }
             objJV.Fiscal_Year__c =sTemp;
            //objJV.Fiscal_Month__c =FiscalMonth;
            //objJV.Fiscal_Year__c =FiscalYear;
            objJV.Biennium_Year__c= String.valueOf(BienniumYear); 
            objJV.RecordTypeId =Schema.SObjectType.Journal_Voucher__c.getRecordTypeInfosByName().get(DOL_AppConstants.sJVAutomated).getRecordTypeId();
            if(currentSeq > 9998){
                currentSeq =0;
            } else{
                currentSeq++;
            }
             sTemp =String.Valueof(currentSeq);
            if(sTemp.length() == 1){
                sTemp = DOL_AppConstants.NULL_EMPTY_STRING + '000'+ sTemp;
            }
            else if(sTemp.length() == 2){
                sTemp = DOL_AppConstants.NULL_EMPTY_STRING + '00'+ sTemp;
            }
            else if(sTemp.length() == 3){
                sTemp = DOL_AppConstants.NULL_EMPTY_STRING + '0'+ sTemp;
            }
            objJV.Current_Document_Number__c=objJVMeta.Doc_Number_Prefix__c+ sTemp;
            
            lstJV.add(objJV);
        }
        system.debug('lstJV$$'+lstJV);
        //system.debug('mapJVFilterJVName$$'+mapJVFilterJVName);
        if(lstJV.size()>0){
            Insert lstJV;
            for(Journal_Voucher__c objJV:lstJV){
                mapJVNameID.put(objJV.Journal_Voucher_Type__c, objJV.Id);
                //BUG-7053
                jvIdSet.add(objJV.Id);
            }
        }
        //system.debug('mapJVNameID$$'+mapJVNameID);
        if(objJVseq.id != null){
            objJVseq.Current_sequence__c=currentSeq;
            update objJVseq;
        }
        
        
        list<string> lstValueIntakeMethod=new list<String>{'Counter','Portal','Validation Room','N/A','NCR'};
        list<string> lstValuePaymentMethod=new list<String>{'Cash','Check','Money Order','Vital Check','ACH','Credit Card','Lockbox','NCR'};
        list<string> lstTargetAccountingSystem= new list<String>{'TMS','AFRS'};
        list<string> lstTraansactionCode= new list<String>{'770','001','780','012','062','298','965','006','781','008','966','068'};
        list<string> lstGL= new list<String>{'7110','3210','4310','1312','3205','5199','7140'};
        String strQuery = DOL_AppConstants.NULL_EMPTY_STRING + 'SELECT id, name,Transaction_Type__c,BGBK__Fund__r.GL__c,Agency__c,Transaction_Code_Type__c,Debit_Credit__c,Transaction_Code__c,Program_Index__c,BGBK__Amount__c,GL_To_AFRS__c,BGBK__Fund__r.Accounting_System__c,BGBK__Fee__r.Agency__c, ';
        strQuery+='BGBK__Fund__r.Fund__c,Intake_Method__c,Payment_Method__c,BGBK__Fund__r.Major_Group__c,BGBK__Fund__r.Major_Source__c,BGBK__Fund__r.Sub_Source__c ';
        strQuery+='FROM BGBK__Item__c WHERE Journal_Voucher_Detail__c = null AND BGBK__Fund__r.Accounting_System__c IN  (\'';
        strQuery += String.join(new List<string>(lstTargetAccountingSystem), '\',\'') + '\')';
       // strQuery+= 'AND Payment_Method__c IN (\'';
       // strQuery += String.join(new List<string>(lstValuePaymentMethod), '\',\'') + '\')';
        strQuery+= 'AND Transaction_Code__c IN (\'';
        strQuery += String.join(new List<string>(lstTraansactionCode), '\',\'') + '\')';
        strQuery+= 'AND BGBK__Fund__r.GL__c IN (\'';
        strQuery += String.join(new List<string>(lstGL), '\',\'') + '\')';
        strQuery+= 'AND Intake_Method__c IN (\'';
        strQuery += String.join(new List<string>(lstValueIntakeMethod), '\',\'') + '\')'; 
        //Use below lines only for testing
        //strQuery += ' AND CreatedDate >= 2019-10-19T02:52:00.000+0000 AND Intake_Method__c = \'Validation Room\'';
        strQuery += ' ORDER BY CreatedDate DESC';
        //system.debug('query$$'+strQuery);
        return Database.getQueryLocator(strQuery);
        }
        catch(Exception e){
            DOL_CreateErrorLog_Exception.logApplicationError(e);
            return null;
        }
        
    }
    public void execute(Database.BatchableContext objContext, List<BGBK__Item__c> lstItemRecords) {
        //system.debug('ListItem==='+lstItemRecords);
        //system.debug('mapJVNameID==='+mapJVNameID);
        List <Journal_Voucher_Detail__c> listJVDtoInsert = new List <Journal_Voucher_Detail__c>();
        List<DOL_AppUtility.JournalWrapper> lstJVDWrapperData = new List<DOL_AppUtility.JournalWrapper>();
        List<BGBK__Item__c> lstItemRecordsForJV = new List<BGBK__Item__c>();
        Map<String, List<BGBK__Item__c>> mapItemsData = new Map<String, List<BGBK__Item__c>>();
        Map<String, Decimal> mapTotalItemAmount = new Map<String, Decimal>();
        Map<String, String> mapTotalItemIds = new Map<String, String>();
        String sToBeGroupedFields= null;
        try{
            //BUG-7053 start
            //Find the existing Journal Voucher Details for same Journal Voucher
            Map<String,Journal_Voucher_Detail__c>  existingJVDMap = new Map<String,Journal_Voucher_Detail__c>();
            List<Journal_Voucher_Detail__c> jvdList = [select Id,Name,Journal_Voucher_Detail_Grouping__c,JVDGroupingKey__c,Amount__c,Item_record_IDs__c,JournalVoucher__c
                                                      from Journal_Voucher_Detail__c 
                                                      where JournalVoucher__c IN:jvIdSet];
            //System.debug('JVDList=='+jvdList);
            if(!jvdList.isEmpty()){
                for(Journal_Voucher_Detail__c jvdRec:jvdList){
                    if(existingJVDMap!= null && !existingJVDMap.containsKey(jvdRec.JVDGroupingKey__c)){
                        existingJVDMap.put(jvdRec.JVDGroupingKey__c,jvdRec);
                    }
                }
            }
            //System.debug('existingJVDMap=='+existingJVDMap);
            //BUG-7053 end
            List<BGBK__Item__c> unProcessItemList = new List<BGBK__Item__c>();
            for(BGBK__Item__c objItem : lstItemRecords){
                
                string strFilterKey = objItem.Intake_Method__c+objItem.Payment_Method__c+objItem.BGBK__Fund__r.Accounting_System__c+objItem.Transaction_Code__c+objItem.BGBK__Fund__r.GL__c+objItem.Transaction_Type__c;
                string strFilterKeyWithoutIM    = objItem.Intake_Method__c+objItem.BGBK__Fund__r.Accounting_System__c+objItem.Transaction_Code__c+objItem.BGBK__Fund__r.GL__c+objItem.Transaction_Type__c;
                //system.debug('mapJVFilterJVName==='+mapJVFilterJVName);
                itemSetKey.add(strFilterKey);
                system.debug('strFilterKey===='+strFilterKey);
                system.debug('WithougtKeyIM===='+strFilterKeyWithoutIM);
                if((mapJVFilterJVName.containsKey(strFilterKey) && mapJVNameID.containsKey(mapJVFilterJVName.get(strFilterKey))) 
                        ||(mapJVFilterJVName.containsKey(strFilterKeyWithoutIM) && mapJVNameID.containsKey(mapJVFilterJVName.get(strFilterKeyWithoutIM))) ){
                    System.debug('strFilterKey$$$'+strFilterKey);
                    if(mapJVNameID.containsKey(mapJVFilterJVName.get(strFilterKey))){
                        objItem.Journal_Voucher__c = mapJVNameID.get(mapJVFilterJVName.get(strFilterKey));
                    }else{
                        objItem.Journal_Voucher__c = mapJVNameID.get(mapJVFilterJVName.get(strFilterKeyWithoutIM));
                    }
                    lstItemRecordsForJV.add(objItem);
                    //Aggregate item records for TMS accounting system
                    if((objItem.BGBK__Fund__r.Accounting_System__c == DOL_AppConstants.sJVTMS)){
                        sToBeGroupedFields = objItem.Transaction_Code__c+objItem.Program_Index__c
                            +objItem.BGBK__Fund__r.Fund__c+objItem.GL_To_AFRS__c+objItem.Agency__c+objItem.Transaction_Code_Type__c+objItem.Debit_Credit__c+objItem.Journal_Voucher__c;
                    }
                    //Aggregate item records for AFRS accounting system
                    else if((objItem.BGBK__Fund__r.Accounting_System__c == DOL_AppConstants.sJVAFRES)){
                        
                        sToBeGroupedFields = objItem.Transaction_Code__c+objItem.Program_Index__c
                            +objItem.BGBK__Fund__r.Fund__c+objItem.GL_To_AFRS__c+objItem.Agency__c+
                            objItem.BGBK__Fund__r.Major_Group__c+objItem.BGBK__Fund__r.Major_Source__c+objItem.BGBK__Fund__r.Sub_Source__c+objItem.Transaction_Code_Type__c+objItem.Debit_Credit__c+objItem.Journal_Voucher__c;
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
                    String sTemp = DOL_AppConstants.NULL_EMPTY_STRING + '';
                    if(mapTotalItemIds <> null && mapTotalItemIds.containsKey(sToBeGroupedFields)){
                        sTemp = mapTotalItemIds.get(sToBeGroupedFields) +','+objItem.Id;
                    }
                    else{
                        sTemp= objItem.Id;
                    }
                    mapTotalItemIds.put(sToBeGroupedFields, sTemp);
                }else{//Below is testing purpose to identify the non matching value.
                    system.debug('===UnProcessItemRecord='+objItem);
                    unProcessItemList.add(objItem);
                }
            }
            /*system.debug('===UnProcessItem=='+unProcessItemList);
            system.debug('===mapItemsData=='+mapItemsData);
            system.debug('===mapTotalItemIds=='+mapItemsData);
            system.debug('===mapTotalItemAmount=='+mapTotalItemAmount);*/
            for(string str :mapItemsData.keyset()){
                DOL_AppUtility.JournalWrapper oData = new DOL_AppUtility.JournalWrapper(mapItemsData.get(str)[0], mapTotalItemAmount.get(str), mapTotalItemIDs.get(str));
                lstJVDWrapperData.add(oData);
            }
            //system.debug('==lstJVDWrapperData=='+lstJVDWrapperData);
            //Generate JVD record
            for(DOL_AppUtility.JournalWrapper objJournalWrapper:lstJVDWrapperData){
                //Get the Key value to check Existing JV Details
                String jvdGroupingValue = '';
                //BUG-7053 -start
                //Aggregate item records for TMS accounting system
                if((objJournalWrapper.objItemsData.BGBK__Fund__r.Accounting_System__c == DOL_AppConstants.sJVTMS)){
                    jvdGroupingValue = objJournalWrapper.objItemsData.Transaction_Code__c+objJournalWrapper.objItemsData.Program_Index__c
                                        +objJournalWrapper.objItemsData.BGBK__Fund__r.Fund__c+objJournalWrapper.objItemsData.GL_To_AFRS__c
                                        +objJournalWrapper.objItemsData.Agency__c+objJournalWrapper.objItemsData.Transaction_Code_Type__c
                                        +objJournalWrapper.objItemsData.Debit_Credit__c+objJournalWrapper.objItemsData.Journal_Voucher__c;
                }
                //Aggregate item records for AFRS accounting system
                else if((objJournalWrapper.objItemsData.BGBK__Fund__r.Accounting_System__c == DOL_AppConstants.sJVAFRES)){
                    
                    jvdGroupingValue = objJournalWrapper.objItemsData.Transaction_Code__c+objJournalWrapper.objItemsData.Program_Index__c
                                        +objJournalWrapper.objItemsData.BGBK__Fund__r.Fund__c+objJournalWrapper.objItemsData.GL_To_AFRS__c
                                        +objJournalWrapper.objItemsData.Agency__c+objJournalWrapper.objItemsData.BGBK__Fund__r.Major_Group__c
                                        +objJournalWrapper.objItemsData.BGBK__Fund__r.Major_Source__c
                                        +objJournalWrapper.objItemsData.BGBK__Fund__r.Sub_Source__c
                                        +objJournalWrapper.objItemsData.Transaction_Code_Type__c+objJournalWrapper.objItemsData.Debit_Credit__c
                                        +objJournalWrapper.objItemsData.Journal_Voucher__c;
                }
                //System.debug('jvdGroupingValue=='+jvdGroupingValue);
                Journal_Voucher_Detail__c objJVD = null;
                //if JVD record exist for the grouping code use the existing JVD otherwise create new JVD.
                if(existingJVDMap != null && existingJVDMap.size() >0 && existingJVDMap.containsKey(jvdGroupingValue)){
                    objJVD = existingJVDMap.get(jvdGroupingValue);
                    objJVD.Amount__c = objJVD.Amount__c+objJournalWrapper.iTotalAmount;
                    objJVD.Item_record_IDs__c = objJVD.Item_record_IDs__c+objJournalWrapper.sItemIDs;
                   // System.debug('if====='+objJVD);
                }else{
                    //BUG-7053 end
                    objJVD=new Journal_Voucher_Detail__c();
                    // objJVD.Target_Accounting_System__c =objJournalWrapper.objItemsData.BGBK__Fund__r.Accounting_System__c;
                    objJVD.Transaction_Code__c = objJournalWrapper.objItemsData.Transaction_Code__c;
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
                    objJVD.Subsidiary_Account_Debit__c = DOL_AppConstants.NULL_EMPTY_STRING + '';
                    objJVD.Subsidiary_Account_Credit__c = DOL_AppConstants.NULL_EMPTY_STRING + '';
                    objJVD.JournalVoucher__c = objJournalWrapper.objItemsData.Journal_Voucher__c;
                    objJVD.JVDGroupingKey__c = jvdGroupingValue;//BUG-7053
                    lstJVID.add(objJVD.JournalVoucher__c);
                    if(objJournalWrapper.objItemsData.BGBK__Fund__r.Accounting_System__c == DOL_AppConstants.sJVAFRES){
                        objJVD.AFRS_Transaction_Code__c=objJournalWrapper.objItemsData.Transaction_Code__c;  
                    }
                    if(objJournalWrapper.objItemsData.BGBK__Fund__r.Accounting_System__c == DOL_AppConstants.sJVTMS){
                        objJVD.TMS_Transaction_Code__c=objJournalWrapper.objItemsData.Transaction_Code__c;
                    }
                    
                    string  strFilterKey= objJournalWrapper.objItemsData.Intake_Method__c+objJournalWrapper.objItemsData.Payment_Method__c+objJournalWrapper.objItemsData.BGBK__Fund__r.Accounting_System__c+objJournalWrapper.objItemsData.Transaction_Code__c+objJournalWrapper.objItemsData.BGBK__Fund__r.GL__c+objJournalWrapper.objItemsData.Transaction_Type__c;
                    string  strFilterKeyWithoutPM= objJournalWrapper.objItemsData.Intake_Method__c+objJournalWrapper.objItemsData.BGBK__Fund__r.Accounting_System__c+objJournalWrapper.objItemsData.Transaction_Code__c+objJournalWrapper.objItemsData.BGBK__Fund__r.GL__c+objJournalWrapper.objItemsData.Transaction_Type__c;
                    //system.debug('strFilterKey$$'+strFilterKey);
                    //system.debug('strFilterKeyWithoutPM$$'+strFilterKeyWithoutPM);
                    if(mapJVFilterAddToInterface.containsKey(strFilterKey)){
                    //system.debug('1');
                        objJVD.Add_to_Interface__c=mapJVFilterAddToInterface.get(strFilterKey);
                    }
                    else if(mapJVFilterAddToInterface.containsKey(strFilterKeyWithoutPM)){
                    //system.debug('2');
                        objJVD.Add_to_Interface__c=mapJVFilterAddToInterface.get(strFilterKeyWithoutPM);
                    }
                    if(mapJVFilterAddToPDF.containsKey(strFilterKey)){
                        objJVD.Add_to_PDF__c=mapJVFilterAddToPDF.get(strFilterKey);
                    }
                    else if(mapJVFilterAddToPDF.containsKey(strFilterKeyWithoutPM)){
                        objJVD.Add_to_PDF__c=mapJVFilterAddToPDF.get(strFilterKeyWithoutPM);
                    }
                   
                }
                listJVDtoInsert.add(objJVD);
            }
            
            if(listJVDtoInsert.size()>0){
                //Insert listJVDtoInsert;
                upsert listJVDtoInsert;
            }
            //system.debug('listJVDtoInsert$$after=='+listJVDtoInsert);
            //stamp JVD id on Item record.
            List<BGBK__Item__c> lstItemToUpdate= new List<BGBK__Item__c>();
            //system.debug('listJVDtoInsert=='+listJVDtoInsert);
            for(Journal_Voucher_Detail__c objJVD:listJVDtoInsert){
                List<String> lstItemIds = objJVD.Item_record_IDs__c.split(',');
                //System.debug('==lstItemIds=='+lstItemIds);
                for(string sItemId:lstItemIds){
                    BGBK__Item__c objItem = new BGBK__Item__c();
                    objItem.Id =sItemId;
                    objItem.Journal_Voucher_Detail__c = objJVD.id;
                    lstItemToUpdate.add(objItem);
                }
            }
            //system.debug('==lstItemToUpdate=='+lstItemToUpdate);
            if(lstItemToUpdate.size()>0){
                update lstItemToUpdate;
            }
        }
        catch(Exception e){
            DOL_CreateErrorLog_Exception.logApplicationError(e);
            
        }
    }
    
    global void finish(Database.BatchableContext objBatchableContext) {
        //system.debug('lstJVID$$'+lstJVID);
        //system.debug('lstJV$$'+lstJV);
        system.debug('ItemKeySetValues=='+itemSetKey);
        decimal count = 0;
        List<Journal_Voucher__c> lstJVtoDelete= new List<Journal_Voucher__c>();
        try{
            for(journal_voucher__c objJV : lstJV){
                //system.debug('==objJV=='+objJV);
                if(!lstJVID.contains(objJV.id)){
                    count++;
                    lstJVtoDelete.add(objJV);
                }
            }
            //system.debug('==lstJVtoDelete=='+lstJVtoDelete);
            if(lstJVtoDelete.size()>0){
                delete lstJVtoDelete;
                objJVseq.Current_sequence__c = objJVseq.Current_sequence__c - count;
                update objJVseq;
            }
        }
        catch(Exception e){
            DOL_CreateErrorLog_Exception.logApplicationError(e);
            
        }
    }
    
}