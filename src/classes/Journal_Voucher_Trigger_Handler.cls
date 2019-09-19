public class Journal_Voucher_Trigger_Handler {
decimal currentSeq=0;
    
public void onInsert(List<Journal_Voucher__c> journalVoucherList)
{
    system.debug('the values are:' +journalVoucherList[0].Document_Type__c);
    JV_Sequence__c objJVseq =[SELECT Current_sequence__c,id from JV_Sequence__c limit 1];
        if(objJVseq.id != null){
            currentSeq=objJVseq.Current_sequence__c;
            system.debug('the current sequence number is' +currentSeq);
            
        }
    //Journal_Voucher__c jvRec=[Select id,Document_Type__c,Current_Document_Number__c from Journal_Voucher__c where id =: journalVoucherList[0].id]; 
    if( journalVoucherList !=null && journalVoucherList.size()>0) {
        for(Journal_Voucher__c journalVoucherRec:journalVoucherList ){
            if(journalVoucherRec.Current_Document_Number__c == null){
                if(currentSeq > 9998){
                currentSeq =0;
                } else{
                    currentSeq++;
                }
              
                
             objJVseq.Current_sequence__c=currentSeq++;
                system.debug('the increased currentSeq' +currentSeq);
            string sTemp =String.Valueof(currentSeq);
            if(sTemp.length() == 1){
                sTemp = '000'+ sTemp;
            }
            else if(sTemp.length() == 2){
                sTemp = '00'+ sTemp;
            }
            else if(sTemp.length() == 3){
                sTemp = '0'+ sTemp;
            }
                
      if(journalVoucherRec.Document_Type__c == 'Manual CreditJournal - User Created' || journalVoucherRec.Document_Type__c == 'Manual JV -User Created - Correction JV or one system to another JV' ||
         journalVoucherRec.Document_Type__c == 'Manual JV -Remittance JV from a validation number' || journalVoucherRec.Document_Type__c == 'RemittanceTransfer in POLARIS - User Created' ||
         journalVoucherRec.Document_Type__c == 'ManualTransfer - User Created' || journalVoucherRec.Document_Type__c == 'ManualTransfer - System Generated to other agencies'
          ){
              journalVoucherRec.Current_Document_Number__c='240V'+sTemp;
                }
                
                if(journalVoucherRec.Document_Type__c == 'Manual CRJSfor Daily -Lockbox  240Q'){
                     journalVoucherRec.Current_Document_Number__c='240Q'+sTemp;
                   }
                
                if(journalVoucherRec.Document_Type__c == 'Manual IAP -user created to ensure document # matches OFM/AFRS'){
                     journalVoucherRec.Current_Document_Number__c='';
                }
            }
        }
    }
 
update objJVseq;
    
    }
    
    
    public void onBeforeInsert(List<Journal_Voucher__c> journalVoucherList){
        system.debug('inside trigger');
        Id manualrecTypeId = Schema.SObjectType.Journal_Voucher__c.getRecordTypeInfosByName().get('Journal Voucher Manual').getRecordTypeId();
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

        for(Journal_Voucher__c voucher:journalVoucherList){
            if(voucher.RecordTypeID == manualrecTypeId){
                string sTemp =String.Valueof(FiscalMonth);
                if(sTemp.length() == 1){
                    sTemp = '0'+ sTemp;
                }
                voucher.Fiscal_Month__c =sTemp;
                sTemp =String.Valueof(FiscalYear);
                if(sTemp.length() == 1){
                    sTemp = '0'+ sTemp;
                }
                voucher.Fiscal_Year__c =sTemp;
                voucher.Biennium_Year__c= String.valueOf(BienniumYear);
            }
        }

    }


    
}