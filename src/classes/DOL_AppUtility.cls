public class DOL_AppUtility {

    public static Boolean bIsFeeTriggerFired = false;
    public static Boolean bIsFeePaymentTriggerFired = false;
    
    
    //public static List<String> lstErrorLogIds = new List<String>();
    
    @AuraEnabled
    public static String fetchErrorLogs()
    {
        //if(!DOL_AppUtility.lstErrorLogIds.isEmpty())
        //return DOL_AppUtility.lstErrorLogIds;
        //else
        //return null;
        String sId = UserInfo.getUserId();
        if(sId <> null)
        {
        List<Polaris_Custom_Exception__c> oD = [select Name from Polaris_Custom_Exception__c 
        where CreatedById = :sId order by createddate desc LIMIT 10];
        System.debug(sId+' Sumeet '+oD);
        if(oD <> null && !oD.isEmpty())
        {
            System.debug(' Sumeet '+oD[0].Name);
            return oD[0].Name;
        }
        }
        return null;
        
    }
    
    /**
    * @author: Mangesh Madhukar, A
    * @method: isAuthenticatedUser
    * @desc Checks if the user is authentiacted to access the system
    * @param no params
    * @return throws exception for non authenticated users.
    * */
    public static void isAuthenticatedUser() {
        if (UserInfo.getUserType() == 'Guest') {
            throw new AuthenticationException('*** You are not authenticated to access the system ***');
        }        
    }

    /**
    * @author: Mangesh Madhukar, A
    * @method: isAllowedToAccess
    * @desc Checks if the user is authorized to access sobject
    * @param objType -- SObjectType 
    * @return Boolean - true if allowed to access else false
    * */
    public static Boolean isAllowedToAccess(Schema.SObjectType objType) {     
        return objType.getDescribe().isAccessible();
    }

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
            String Y= DOL_AppConstants.NULL_EMPTY_STRING + '',M= DOL_AppConstants.NULL_EMPTY_STRING + '',D= DOL_AppConstants.NULL_EMPTY_STRING + '';
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
            String Y= DOL_AppConstants.NULL_EMPTY_STRING + '',M= DOL_AppConstants.NULL_EMPTY_STRING + '',D= DOL_AppConstants.NULL_EMPTY_STRING + '';
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
            String Y= DOL_AppConstants.NULL_EMPTY_STRING + '',M= DOL_AppConstants.NULL_EMPTY_STRING + '',D= DOL_AppConstants.NULL_EMPTY_STRING + '',h= DOL_AppConstants.NULL_EMPTY_STRING + '',mi= DOL_AppConstants.NULL_EMPTY_STRING + '',s= DOL_AppConstants.NULL_EMPTY_STRING + '';
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
            String Y= DOL_AppConstants.NULL_EMPTY_STRING + '',M= DOL_AppConstants.NULL_EMPTY_STRING + '',D= DOL_AppConstants.NULL_EMPTY_STRING + '',h= DOL_AppConstants.NULL_EMPTY_STRING + '',mi= DOL_AppConstants.NULL_EMPTY_STRING + '',s= DOL_AppConstants.NULL_EMPTY_STRING + '';
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

    // Get Field API_NAME for given sObject
    // @author Laltu Banerjee
    public static Set<String> getSobjectFields(String sObjectApiName){
        SObjectType sObjType = Schema.getGlobalDescribe().get(sObjectApiName);
        Set<String> fieldApiNameSet = sObjType.getDescribe().fields.getMap().keySet();
        return fieldApiNameSet;
    }

    // Get Generic Query String
    // Will return a select query with all fields
    // The return string qualified for query
    // User need to add where condition into return query string
    //@author Laltu Banerjee
    public static String getQueryString(String sObjectApiName){
        Set<String> fieldApiNameSet = getSobjectFields(sObjectApiName);
        String queryString = DOL_AppConstants.NULL_EMPTY_STRING + 'Select ';
        queryString += String.join(new List<String>(fieldApiNameSet),' ,');
        queryString += ' from '+sObjectApiName+' ';
        return queryString;
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

    public Class AuthenticationException extends Exception{}
    
}
