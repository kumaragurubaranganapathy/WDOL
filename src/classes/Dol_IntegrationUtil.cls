public without sharing class Dol_IntegrationUtil{

 public static Boolean isBatchRunning(String zBatchName) {
          Boolean yesRunning = false;
          List<AsyncApexJob> asyncJobList = [SELECT ApexClass.Name,JobType,Status,CreatedById from AsyncApexJob where ApexClassId IN (SELECT Id FROM ApexClass WHERE Name =:zBatchName) and Status= 'Processing'];
          System.debug('***********isBatchRunning:asyncJobList***********:'+asyncJobList);
          if(asyncJobList != null && asyncJobList.size() > 1){
          	yesRunning = true;
          }
          return yesRunning;
	}
	
	// Check for the batch status 'Holding', 'Queued', 'Preparing', 'Processing'
	public static Boolean isBatchInQueue(String zBatchName){
          Boolean isBtchInQueue = false;
          List<AsyncApexJob> asyncJobList = [SELECT ApexClass.Name,JobType,Status,CreatedById from AsyncApexJob where ApexClassId IN (SELECT Id FROM ApexClass WHERE Name =:zBatchName) and Status IN ('Holding', 'Queued', 'Preparing', 'Processing')];
          System.debug('***********isBatchInQueue:asyncJobList***********:'+asyncJobList);
          if(asyncJobList != null && asyncJobList.size() >= 1){
          	isBtchInQueue = true;
          }
          return isBtchInQueue;
	}

    /** 
	 * Method name  : isNotBlank
     * Description  : This method checks if the given string is white space, empty (''), or null; otherwise, returns false.
     * Return Type  : Boolean
     * Parameter    : String
     */
	public static boolean isBlank(String str) {
    	return String.isBlank(str) || str.equalsIgnoreCase('null') || str.trim().equalsIgnoreCase('null');
    }

    /** 
     * Method name  : isNotBlank
     * Description  : This method checks if the field is not blank
     * Return Type  : Boolean
     * Parameter    : String
     */
     public static Boolean isNotBlank(String str) {
        return (!isBlank(str));
     }
     
    /**
     * Method name  : isDateBlank
     * Description  : This method checks if the date field is blank
     * Return Type  : Boolean
     * Parameter    : Date
     */
     public static Boolean isDateBlank(Date dateValue) {
        return dateValue == null || dateValue.format().trim() == null || dateValue.format().trim().length() == 0;
     }

    /**
     * Returns true if the list is null or empty. Else, returns false.
     * @param values List of objects to test.
     *
     * @return Boolean 
     */
    public static boolean isEmpty(List<Object> values) {
        return (values == null || values.size() < 1) ? true : false;
    }

    /**
     * Returns true if the list has at least one element. Else, returns false.
     * @param values List of objects to test.
     *
     * @return Boolean 
     */
    public static boolean isNotEmpty(List<Object> values) {
        return !isEmpty(values);
    }
}