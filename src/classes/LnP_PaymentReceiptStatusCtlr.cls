/**
 * Controller Class for LnP_PaymentReceiptStatus lightning component
 * 
 * @author      Kumaragurubaran Ganapathy
 * @version     1.0
 * @since       1.0
 */
public class LnP_PaymentReceiptStatusCtlr {
    //public static List<MUSW__Receipt__c> receiptList {get;set;}
    
    public LnP_PaymentReceiptStatusCtlr(){
        
    }

    @AuraEnabled
    public static Map<String,Double> getPmtInitialTotals(){
        Map<String,Double> totalAmount = new Map<String,Double>();
        Double amexAmount = 0.00;
        Double visaAmount = 0.00;
        Double masterAmount = 0.00;
        Double discoverAmount = 0.00;
        Double achAmount = 0.00;
        totalAmount.put('Amex',amexAmount);
        totalAmount.put('Visa',visaAmount);
        totalAmount.put('MasterCard',masterAmount);
        totalAmount.put('Discover',discoverAmount);
        totalAmount.put('ACH',achAmount);
        return totalAmount;
    }
    @auraEnabled 
    public static Map<String,String> getPaymentTotals(String paymentParameter,Date selectedDate){
     //   system.debug('PaymentParameter=='+paymentParameter);
       // system.debug('selectedDate=='+selectedDate);
        Map<String,String> totalAmount = new Map<String,String>();
        try{
            List<MUSW__Receipt__c> receiptList = getPaymentReceiptRecords(paymentParameter,selectedDate);
            Double amexAmount = 0.00;
            Double visaAmount = 0.00;
            Double masterAmount = 0.00;
            Double discoverAmount = 0.00;
            Double achAmount = 0.00;
            if(!receiptList.isEmpty()){
                for(MUSW__Receipt__c receipt:receiptList){
                    if(String.isNotBlank(receipt.MUSW__Card_Type__c)){
                        if(receipt.MUSW__Card_Type__c.equalsIgnoreCase('Amex')){
                                amexAmount = amexAmount+receipt.MUSW__Amount_Tendered__c;
                        }
                        else if(receipt.MUSW__Card_Type__c.equalsIgnoreCase('Visa')){
                                visaAmount = visaAmount+receipt.MUSW__Amount_Tendered__c;
                        }
                        else if(receipt.MUSW__Card_Type__c.equalsIgnoreCase('MasterCard')){
                                masterAmount = masterAmount+receipt.MUSW__Amount_Tendered__c;
                        }
                        else if(receipt.MUSW__Card_Type__c.equalsIgnoreCase('Discover')){
                                discoverAmount = discoverAmount+receipt.MUSW__Amount_Tendered__c;
                        }
                    }
                    if(String.isNotBlank(receipt.MUSW__Payment_Method__c)){
                        if(receipt.MUSW__Payment_Method__c.equalsIgnoreCase('ACH')){
                                achAmount = achAmount+receipt.MUSW__Amount_Tendered__c;
                        }
                    }
                }
            }
            totalAmount.put('Amex',formatCurrency(amexAmount));
            totalAmount.put('Visa',formatCurrency(visaAmount));
            totalAmount.put('MasterCard',formatCurrency(masterAmount));
            totalAmount.put('Discover',formatCurrency(discoverAmount));
            totalAmount.put('ACH',formatCurrency(achAmount));
        }catch(Exception ex){
            DOL_CreateErrorLog_Exception.logApplicationError(ex);
        }
     //   system.debug('total Amount==='+totalAmount);
        return totalAmount;
    }

    @AuraEnabled
    public static string paymentReceiptRecordsUpdate(String paymentParameter,Date selectedDate){
     //   system.debug('PaymentParameter=='+paymentParameter);
     //   system.debug('selectedDate=='+selectedDate);
        String status = '';
        try{
            List<MUSW__Receipt__c> receiptList =  getPaymentReceiptRecords(paymentParameter,selectedDate);
            List<MUSW__Receipt__c> updateReceiptList = new List<MUSW__Receipt__c>();
            if(!receiptList.isEmpty()){
                for(MUSW__Receipt__c receipt:receiptList){
                    MUSW__Receipt__c receiptRec = new MUSW__Receipt__c();
                    receiptRec.Id= receipt.Id;
                    receiptRec.Settlement_Date__c = DateTime.now();
                    receiptRec.US_Bank_Payment_Status__c = 'Settled';
                    updateReceiptList.add(receiptRec);
                }
            }
         //   system.debug('updateReceiptList==='+updateReceiptList);
            if(!updateReceiptList.isEmpty()){
                upsert updateReceiptList;
                status = 'success';
            }else{
                status = 'NoRecord';
            }
       }catch(Exception ex){
            DOL_CreateErrorLog_Exception.logApplicationError(ex);
            status = 'error';
        }
    //    system.debug('total Amount==='+status);
        return status;
    }
    public static List<MUSW__Receipt__c> getPaymentReceiptRecords(String paymentParameter,Date selectedDate){
    //    system.debug('PaymentParameter=='+paymentParameter);
        //system.debug('selectedDate=='+selectedDate);
        List<MUSW__Receipt__c> receiptList = new List<MUSW__Receipt__c>();
        try{
            String[] pmtTypeArray = null;
            Boolean isAmexChecked = false;
            Boolean isVisaChecked = false;
            Boolean isMasterChecked = false;
            Boolean isDiscoverChecked = false;
            Boolean isACHChecked = false;
            Date startDate = selectedDate;
            Date endDate = startDate.addDays(1);
            String status ='';
            DateTime startDateTime = DateTime.newInstance(startDate.year(),startDate.month(),startDate.day());
            DateTime endDateTime = DateTime.newInstance(startDate,Time.newInstance(23,59,59,999));
            if(String.isNotBlank(paymentParameter)){
                pmtTypeArray = paymentParameter.split('-');
                //system.debug('selectedDate=='+selectedDate);
                if(pmtTypeArray != null && pmtTypeArray.size() > 0){
                    if(String.isNotBlank(pmtTypeArray[0])){
                        isAmexChecked = Boolean.valueOf(pmtTypeArray[0]);
                    }
                    if(String.isNotBlank(pmtTypeArray[1])){
                        isVisaChecked = Boolean.valueOf(pmtTypeArray[1]);
                    }
                    if(String.isNotBlank(pmtTypeArray[2])){
                        isMasterChecked = Boolean.valueOf(pmtTypeArray[2]);
                    }
                    if(String.isNotBlank(pmtTypeArray[3])){
                        isDiscoverChecked = Boolean.valueOf(pmtTypeArray[3]);
                    }if(String.isNotBlank(pmtTypeArray[4])){
                        isACHChecked = Boolean.valueOf(pmtTypeArray[4]);
                    }
                    String selectQueryString = 'Select Id,Name,MUSW__Amount_Tendered__c,MUSW__Card_Type__c,Remittance_Process_Date_Time__c,MUSW__Payment_Method__c ';
                    selectQueryString += ' ,Settlement_Date__c,US_Bank_Payment_Status__c';
                    selectQueryString += ' from MUSW__Receipt__c where ';
                    selectQueryString += ' Remittance_Process_Date_Time__c >=: startDateTime and Remittance_Process_Date_Time__c <=:endDateTime';
                    selectQueryString += ' AND US_Bank_Payment_Status__c = \'Processed\'';
                    selectQueryString += ' AND (';
                    if(isAmexChecked) {
                        selectQueryString += ' MUSW__Card_Type__c=\'Amex\'';
                    }
                    
                    if(isAmexChecked && isVisaChecked) {
                        selectQueryString += ' OR MUSW__Card_Type__c=\'Visa\'';
                    }else if(isVisaChecked){
                        selectQueryString += ' MUSW__Card_Type__c=\'Visa\'';
                    } 
                    
                    if((isAmexChecked || isVisaChecked) && isMasterChecked) {
                        selectQueryString += ' OR MUSW__Card_Type__c=\'MasterCard\'';
                    }else if(isMasterChecked){
                        selectQueryString += ' MUSW__Card_Type__c=\'MasterCard\'';
                    }
                    if((isAmexChecked || isVisaChecked || isMasterChecked) && isDiscoverChecked) {
                        selectQueryString += ' OR MUSW__Card_Type__c=\'Discover\'';
                    } else if(isDiscoverChecked){
                        selectQueryString += ' MUSW__Card_Type__c=\'Discover\'';
                    }
                    if((isAmexChecked || isVisaChecked || isMasterChecked || isDiscoverChecked) && isACHChecked) {
                        selectQueryString += ' OR MUSW__Payment_Method__c=\'ACH\'';
                    }else if(isACHChecked){
                        selectQueryString += ' MUSW__Payment_Method__c=\'ACH\'';
                    }
                    selectQueryString += ' )'; 
                    //system.debug('QueryString=='+selectQueryString);  
                    receiptList =  Database.query(selectQueryString);
                    //system.debug('receiptList=='+receiptList);
                }
            }

        }catch(Exception ex){
            DOL_CreateErrorLog_Exception.logApplicationError(ex);
        }
        return receiptList;
    }
    public static String formatCurrency(Decimal i) {
        if(i==null) i=0;
        String s = ( i.setScale(2) + 0.001 ).format();
        return s.substring(0,s.length()-1);
    }
}