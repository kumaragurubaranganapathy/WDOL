/*************************************************************************************************************
** User Story: 
**************************************************************************************************************
** Name             : CommonUtil
** Description       : The CommonUtil class contains the Common Utility methods.** Version             : 1.0
** Built By            : 
**------------------------------------------------------------------------------------------------------------
** Modification Log:
**------------------
** Developer                         Date                    Version                      Description
**------------------------------------------------------------------------------------------------------------
** Nitant Kakar             09/02/2017                1.0                          Created
** Aishwaria Rangineni        02/10/2018          2.0               Added error logging functionality
** Review Log:
**---------------
** Reviewer                  Date           Version               Description
**------------------------------------------------------------------------------------------------------------
**
************************************************************************************/ 



/**
* The CommonUtil class contains the Common Utility methods. 
* MEC: Modified generateNewTimeSlots , holiday logic was incorrect ..  no slot should be created for holiday
*
*/
public with sharing class CommonUtil {
    
    public static String getPageParam(String paramName){
        if(null != ApexPages.currentPage()){  
            return ApexPages.currentPage().getParameters().get(paramName);  
        } 
        return null;
    }  
    
    public static boolean isBlank(String str) {
        return String.isBlank(str) || str.equalsIgnoreCase('null') || str.trim().equalsIgnoreCase('null');
    }
    
    public static boolean isNull(Decimal dec) {
        return (dec == null);
    }
    
    public static Boolean isNotBlank(String str) {
        return (!isBlank(str));
    }
    
    public static Boolean isDateBlank(Date dateValue) {
        return dateValue == null || dateValue.format().trim() == null || dateValue.format().trim().length() == 0;
    }
    
    public static boolean isEmpty(List<Object> values) {
        return (values == null || values.size() < 1) ? true : false;
    }
    
    public static boolean isNotEmpty(List<Object> values) {
        return !isEmpty(values);
    }
    
    public static Integer toInteger(String str){
        Integer intgr = null;
        if(!isBlank(str)){
            intgr = Integer.valueOf(str);
        }
        return intgr;
    }
    
    
    
    public static Decimal toDecimal(String str){
        Decimal decml = null;
        if(!isBlank(str)){
            decml = Decimal.valueOf(str);
        }
        return decml;
    }
    
    
    // Use this function when your date string conforms to the "yyyy-MM-dd HH:mm:ss" format.
    public static Date getDateValue(String dateStr) {
        Date dt = null;
        if(!isBlank(dateStr)) {
            try {
                dt = Date.valueof(dateStr);
                if(null!=dt && dt.year()<1700) {
                    return null;
                }
            } catch(Exception e) {
                ErrorLogger.logGeneralException(e, UserInfo.getUserId(), 'CommonUtil', 'get date value', 'getDateValue', 'CommonUtil', 'HIGH');
                return null;
            }
        }
        return dt;
    }
    
    // Use this function when your date string conforms to the "MM/dd/yyyy" format.
    public static Date getDateValueWithDateParse(String dateStr) {
        Date dt = null;
        if(!isBlank(dateStr)) {
            try {
                dt = Date.parse(dateStr);
                if(null!=dt && dt.year()<1700) {
                    return null;
                }
            } catch(Exception e) {
                ErrorLogger.logGeneralException(e, UserInfo.getUserId(), 'CommonUtil', 'get date parsed', 'getDateValueWithDateParse', 'CommonUtil','HIGH');
                return null;
            }
        }
        return dt;
    }
    
    public static DateTime getTruncatedDateTime(Date dateVal) {
        DateTime dt = null;
        if(!isDateBlank(dateVal)) {
            dt = DateTime.newInstance(dateVal.year(),dateVal.month(),dateVal.day(),0,0,0);
        }
        return dt;
    }
    
    public static Boolean isValidInputData (String dataRulePattern, String fieldValue){
        Boolean res = true;
        Pattern myPattern = Pattern.compile(dataRulePattern);
        Matcher myMatcher = myPattern.matcher(fieldValue);
        if (!myMatcher.matches()) 
            res = false;
        return res; 
    } 
    
    public static String getDateYYYYMMDD(Date dateVal) {
        String fmtDate = null;
        DateTime dt = null;
        if(!isDateBlank(dateVal)) {
            dt = DateTime.newInstance(dateVal.year(),dateVal.month(),dateVal.day(),0,0,0);
            fmtDate = dt.format('yyyy-MM-dd');
        }
        return fmtDate;
    }
    
    public static Boolean isHoliday(Date dTargetDate){
        Boolean bIsHoliday = false;
        List<Holiday> holidays = [SELECT ActivityDate FROM Holiday];
        For(Holiday h : holidays)
        {
            if( dTargetDate == h.ActivityDate){
                bIsHoliday = true;
                break;
            }
        }
        return bIsHoliday;
    } 
    
    public static Integer getDaysElapsed(Date startDate, Date endDate) {
        Integer daysElapsed = 0;
        
        // Neither date should be null, and the end date should be greater
        // than the start date, or we might as well just return zero.
        if (startDate != null && endDate != null && endDate > startDate) {
            daysElapsed = startDate.daysBetween(endDate);
        }
        
        return daysElapsed;
    }
    
    /***************************************************************************************************
* @Description : Method to generate new timeslots
* @Param       : DateTime, DateTime, OrganizationSetting__c, BusinessHours
* @Return      : List<Time_Slot__c>
***************************************************************************************************/
    public static List<Time_Slot__c> generateNewTimeSlots(DateTime startTime, DateTime endTime, OrgSettings__c os, BusinessHours bh) {
        Integer slot =TimeSlotsHelper.getSlotInMinute(os);
        DateTime targetTime = startTime;
        
        List<Time_Slot__c> newSlots = new List<Time_Slot__c>();
        Set<DateTime> existingTimes = new Set<DateTime>();
        
        for(Time_Slot__c existingSlot : [SELECT Start_Time__c 
                                         FROM Time_Slot__c
                                         WHERE Status__c =:Label.St_Free  
                                         ORDER BY Start_Time__c]) {
                                             existingTimes.add(existingSlot.Start_Time__c);
                                         } 
        
        Set<Date> holidays = new Set<Date>();        
        for(Holiday hol: [SELECT ActivityDate FROM Holiday]){
            holidays.add(hol.ActivityDate);
        }
        
        do {
            if(BusinessHours.isWithin(bh.id, targetTime) && !existingTimes.contains(targetTime)&&!holidays.contains(targetTime.date())){
                Time_Slot__c newSlot = new Time_Slot__c();
                newSlot.Start_Time__c = targetTime;
                newSlot.End_Time__c = targetTime.addMinutes(slot);
                newSlot.Status__c = Label.St_Free;                
                newSlots.add(newSlot);
            }
            
            targetTime = targetTime.addMinutes(slot);            
        } while(targetTime <= endTime);
        
        return newSlots;
    }
    
    /***************************************************************************************************
* @Description : Method to generate Record Type maps containing type names and IDs
* @Param       : String
* @Return      : Map<String, Id>
***************************************************************************************************/
    public static Map<String, Id> getRecordTypes(string objectName) {
        Map<String, Id> types = New Map<String, Id>();
        
        for(RecordType rt: [SELECT DeveloperName, Id FROM RecordType WHERE sObjectType = :objectName]) {
            types.put(rt.DeveloperName, rt.Id);
        }
        
        return types;
    }
    public static string getFields(String sObjectName){      
        return String.join(new List<String>((((Schema.getGlobalDescribe()).get(sObjectName).getDescribe()).fields.getMap()).keyset()), ',');        
    }
}