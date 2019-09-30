public class DOL_AppUtility {

    public static Boolean bIsFeeTriggerFired = false;
    public static Boolean bIsFeePaymentTriggerFired = false;
    public static Boolean isReceiptRunOnce = false;
	public static Boolean isFeeRunOnce = false;
    public static Boolean runfromDolBatchUpdateLicenseStatus = false; 
    
    
    //public static List<String> lstErrorLogIds = new List<String>();
    
    @AuraEnabled
    public static String fetchErrorLogs()
    {
        //if(!DOL_AppUtility.lstErrorLogIds.isEmpty())
        //return DOL_AppUtility.lstErrorLogIds;
        //else
        //return null;
        try{
            String sId = UserInfo.getUserId();
            if(sId <> null)
            {
                List<Polaris_Custom_Exception__c> oD = [select Name from Polaris_Custom_Exception__c 
                where CreatedById = :sId and CreatedById!=null order by createddate desc LIMIT 10];
                
                if(oD <> null && !oD.isEmpty())
                {
                    return oD[0].Name;
                }
            }
            return null;
        }catch(Exception ex)
        {
            throw new AuraHandledException('An error occurred: '+ex.getMessage());
        }
        
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
    /*public static Boolean isAllowedToDelete(String objType) {     
        return objType.getDescribe().isDeleteable();
    }*/
    public static Boolean isAllowedToCreate(Schema.SObjectType objType) {     
        return objType.getDescribe().IsCreateable();
    }
    public static Boolean isAllowedToUpdate(Schema.SObjectType objType) {     
        return objType.getDescribe().IsUpdateable();
    }

    /**
    ** Name 			: getDate
    ** Input			: String, dateFormat 
    ** Functionality	: return date in required format
    ** Return			: String, Date in required format
    ** Author			: Laltu Banerjee
    ** Note             : 
    ** Date (MM/DD/YYYY): 06/23/2019
    */
    public static String getDate(String inputformat){
        Datetime dt = Datetime.now();
        return dt.format(inputformat);
    }
    
    /**
    ** Name 			: getString
    ** Input			: List of String 
    ** Functionality	: Merge the whole list into single string
    ** Return			: String
    ** Author			: Laltu Banerjee
    ** Date (MM/DD/YYYY): 06/23/2019
    */

    public static String getString(List<String> strList){
        String outputString;
        if(strList != null && strList.size() > 0){
            outputString = String.join(strList,',');
        }
        return outputString;
    }

    /**
    ** Name 			: getDate
    ** Input			: input Date String and input date format
    ** Functionality	: convert the string into date
    ** Return			: Date
    ** Author			: Laltu Banerjee
    ** Note             : Here we are using standard input
                        : Y = Year, M = Month, D = Date
    ** Date (MM/DD/YYYY): 06/23/2019
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
            return Date.valueOf(Y+'-'+M+'-'+D);
        }catch(Exception error){
            DOL_CreateErrorLog_Exception.logApplicationError(error);
        }
        return null;
    }

    /**
    ** Name 			: getDateString
    ** Input			: input Date String and input date format
    ** Functionality	: get the date String into format Y-M-D
    ** Return			: String 
    ** Author			: Laltu Banerjee
    ** Note             : Here we are using standard input
                        : Y = Year, M = Month, D = Date
    ** Date (MM/DD/YYYY): 06/23/2019
    */
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
            DOL_CreateErrorLog_Exception.logApplicationError(error);
        }
        return null;
    }

    /**
    ** Name 			: getDateTime
    ** Input			: input DateTime String and input dateTime format
    ** Functionality	: get the dateTime  String into DateTime
    ** Return			: DateTime 
    ** Author			: Laltu Banerjee
    ** Note             : Here we are using standard input
                        : Y = Year, M = Month, D = Date, H= hour, m = minute, S = second
    ** Date (MM/DD/YYYY): 06/23/2019
    */
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
            DOL_CreateErrorLog_Exception.logApplicationError(error);
        }
        return null;
    }

    /**
    ** Name 			: getDateTime
    ** Input			: input DateTime String and input dateTime format
    ** Functionality	: get the DateTime String
    ** Return			: String 
    ** Author			: Laltu Banerjee
    ** Note             : Here we are using standard input
                        : Y = Year, M = Month, D = Date, H= hour, m = minute, S = second
    ** Date (MM/DD/YYYY): 06/23/2019
    */
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
            DOL_CreateErrorLog_Exception.logApplicationError(error);
        }
        return null;
    }

    /**
    ** Name 			: isValidDecimalValue
    ** Input			: string input
    ** Functionality	: checks if input is decimal or not
    ** Return			: Boolean 
    ** Author			: Laltu Banerjee
    ** Date (MM/DD/YYYY): 06/23/2019
    */
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
    public static List<String> getSobjectFields(String sObjectApiName){
        SObjectType sObjType = Schema.getGlobalDescribe().get(sObjectApiName);
        Set<String> fieldApiNameSet = sObjType.getDescribe().fields.getMap().keySet();
        List<String> fieldApiNameLst = new List<String>();
        List<String> notRequiredField = new List<String>();
        notRequiredField.add('lastvieweddate');
        notRequiredField.add('lastreferenceddate');
        for(String apiName : fieldApiNameSet){
            if(! notRequiredField.contains(apiName.toLowerCase()) )
                fieldApiNameLst.add(apiName);
        } 
        return fieldApiNameLst;
    }

    // Get Generic Query String
    // Will return a select query with all fields
    // The return string qualified for query
    // User need to add where condition into return query string
    //@author Laltu Banerjee
    public static String getQueryString(String sObjectApiName){
        List<String> fieldApiNameSet = getSobjectFields(sObjectApiName);
        String queryString = 'Select ';
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