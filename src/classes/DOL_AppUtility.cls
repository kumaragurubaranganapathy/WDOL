public class DOL_AppUtility {

    public static String getDate(String inputformat){
        Datetime dt = Datetime.now();
        return dt.format(inputformat);
    }
    
    public static String getString(List<String> strList){
       	String outputString;
        if(strList != null && strList.size() > 0){
            //strList.remove(null);
            outputString = String.join(strList,',');
        }
        return outputString;
    }

    /**
    This method will work on standard Inputs.
    M Stands for Month
    m stands for minutes
     */
    public static Date getDate(String inputStrDate, String inputDateFormat){
        try{
            String[] inputStrDateArr = inputStrDate.split('');
            String[] inputDateFormatArr = inputDateFormat.split('');
            String Y='',M='',D='';
            Integer i;
            for(i=0;i<inputDateFormatArr.size();i++){
                if(inputDateFormatArr[i] == 'Y'){
                    Y += inputStrDateArr[i];
                }
                else if(inputDateFormatArr[i] == 'M'){
                    M += inputStrDateArr[i];
                }
                else if(inputDateFormatArr[i] == 'D'){
                    D += inputStrDateArr[i];
                }
            }
            System.debug('date'+Y+'-'+M+'-'+D);
            return Date.valueOf(Y+'-'+M+'-'+D);
        }catch(Exception error){
            System.debug(' message :- '+error.getMessage()+' StackTrace :- '+error.getStackTraceString());
        }
        return null;
    }

    public static String getDateString(String inputStrDate, String inputDateFormat){
        try{
            String[] inputStrDateArr = inputStrDate.split('');
            String[] inputDateFormatArr = inputDateFormat.split('');
            String Y='',M='',D='';
            Integer i;
            for(i=0;i<inputDateFormatArr.size();i++){
                if(inputDateFormatArr[i] == 'Y' ){
                    Y += inputStrDateArr[i];
                }
                else if( inputDateFormatArr[i] == 'M'){
                    M += inputStrDateArr[i];
                }
                else if(inputDateFormatArr[i] == 'D' ){
                    D += inputStrDateArr[i];
                }
            }
            return Y+'-'+M+'-'+D;
        }catch(Exception error){
            System.debug(' message :- '+error.getMessage()+' StackTrace :- '+error.getStackTraceString());
        }
        return null;
    }

    public static DateTime getDateTime(String inputStrDateTime, String inputDateTimeFormat){
        try{
            String[] inputStrDateTimeArr = inputStrDateTime.split('');
            String[] inputDateTimeFormatArr = inputDateTimeFormat.split('');
            String Y='',M='',D='',h='',mi='',s='';
            Integer i;
            for(i=0;i<inputDateTimeFormatArr.size();i++){
                if(inputDateTimeFormatArr[i] == 'Y' ){
                    Y += inputStrDateTimeArr[i];
                }
                else if(inputDateTimeFormatArr[i].equals('M') ){
                    M += inputStrDateTimeArr[i];
                }
                else if(inputDateTimeFormatArr[i] == 'D' ){
                    D += inputStrDateTimeArr[i];
                }
                else if(inputDateTimeFormatArr[i] == 'H' ){
                    h += inputStrDateTimeArr[i];
                }
                else if(inputDateTimeFormatArr[i].equals('m')) {
                    mi += inputStrDateTimeArr[i];
                }
                else if(inputDateTimeFormatArr[i] == 'S' ){
                    s += inputStrDateTimeArr[i];
                }
            }
            System.debug('Date time '+Y+'-'+M+'-'+D+' '+h+':'+mi+':'+s);
            return DateTime.valueOf(Y+'-'+M+'-'+D+' '+h+':'+mi+':'+s);
        }catch(Exception error){
            System.debug(' message :- '+error.getMessage()+' StackTrace :- '+error.getStackTraceString());
        }
        return null;
    }

    public static String getDateTimeString(String inputStrDateTime, String inputDateTimeFormat){
        try{
            String[] inputStrDateTimeArr = inputStrDateTime.split('');
            String[] inputDateTimeFormatArr = inputDateTimeFormat.split('');
            String Y='',M='',D='',h='',mi='',s='';
            Integer i;
            for(i=0;i<inputDateTimeFormatArr.size();i++){
                if(inputDateTimeFormatArr[i] == 'Y' ){
                    Y += inputStrDateTimeArr[i];
                }
                else if(inputDateTimeFormatArr[i].equals('M') ){
                    M += inputStrDateTimeArr[i];
                }
                else if(inputDateTimeFormatArr[i] == 'D' ){
                    D += inputStrDateTimeArr[i];
                }
                else if(inputDateTimeFormatArr[i] == 'H' ){
                    h += inputStrDateTimeArr[i];
                }
                else if(inputDateTimeFormatArr[i].equals('m')) {
                    mi += inputStrDateTimeArr[i];
                }
                else if(inputDateTimeFormatArr[i] == 'S' ){
                    s += inputStrDateTimeArr[i];
                }
            }
            return Y+'-'+M+'-'+D+' '+h+':'+mi+':'+s;
        }catch(Exception error){
            System.debug(' message :- '+error.getMessage()+' StackTrace :- '+error.getStackTraceString());
        }
        return null;
    }

    public static Boolean isValidDecimalValue(String input){
        boolean isValidInput = false;
        try{
            Decimal.valueOf(input);
            isValidInput = true;
        }catch(Exception e){
            isValidInput = false;
        }
        return isValidInput;
    }

    public static Id getRenewalAppRecordTypeId(String name){
        return Schema.SObjectType.Renewal_Application__c.getRecordTypeInfosByName().get(name).getRecordTypeId();
    }

    //Do not delete this wrapper 
    //Added by Sumeet Kanjilal for processing flow of Journal 
    //Wrapper scenario in Finance Application related US- 
    public class JournalWrapper
    {
        public BGBK__Item__c objItemsData {get;set;}
        public Decimal iTotalAmount {get;set;}
        public String sItemIDs {get;set;} //Added by Vinanthi to hold item record IDs
        
        public JournalWrapper(BGBK__Item__c objItemsData, Decimal iTotalAmount,String sItemIDs)
        {
            this.objItemsData = objItemsData;
            this.iTotalAmount = iTotalAmount;
            this.sItemIDs =sItemIDs;
        }
    }
    
}