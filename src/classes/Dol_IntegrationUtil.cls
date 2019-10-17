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