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
    Journal_Voucher__c jvRec=[Select id,Document_Type__c,Current_Document_Number__c from Journal_Voucher__c where id =: journalVoucherList[0].id]; 
    if( journalVoucherList !=null && journalVoucherList.size()>0) {
        for(Journal_Voucher__c journalVoucherRec:journalVoucherList ){
            if(journalVoucherRec.Current_Document_Number__c == null){
              currentSeq++;
                
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
                
      if(jvRec.Document_Type__c == 'Manual CreditJournal - User Created' || jvRec.Document_Type__c == 'Manual JV -User Created - Correction JV or one system to another JV' ||
         jvRec.Document_Type__c == 'Manual JV -Remittance JV from a validation number' || jvRec.Document_Type__c == 'RemittanceTransfer in POLARIS - User Created' ||
         jvRec.Document_Type__c == 'ManualTransfer - User Created' || jvRec.Document_Type__c == 'ManualTransfer - System Generated to other agencies'
          ){
              jvRec.Current_Document_Number__c='240V'+sTemp;
                }
                
                if(jvRec.Document_Type__c == 'Manual CRJSfor Daily -Lockbox  240Q'){
                     jvRec.Current_Document_Number__c='240Q'+sTemp;
                   }
                
                if(jvRec.Document_Type__c == 'Manual IAP -user created to ensure document # matches OFM/AFRS'){
                     jvRec.Current_Document_Number__c='';
                }
            }
        }
    }
 
update objJVseq;
update jvRec;      
    }
}