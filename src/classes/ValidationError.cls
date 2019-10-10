/*************************************************************************************************************
** User Story: 
**************************************************************************************************************
** Class Name    : ValidationError
** Description   : This class is used as a DTO object (data transfer object)
we want to keep track of the errors that happend during validation but we want to keep this
as a lightweight class.  An instance of this class will be used to communicate database errors
to the front end.
** Version       : 1.0
** Built By      : 
**------------------------------------------------------------------------------------------------------------
** Modification Log:
**------------------
** Developer                              Date                    Version                      Description
** 
** Okwudiafor Akosa, Deloitte            11/27/2017                  2.0             Added  logs to the class.
**------------------------------------------------------------------------------------------------------------
** Review Log:
**---------------
** Reviewer                  Date           Version               Description
**------------------------------------------------------------------------------------------------------------
**
**  **********************************************************************************************************/
public class ValidationError {
    
    public Map<String, FieldError> errorMap {get; set;}
    public Map<String, FieldError> componentErrorMap {get; set;}
    
    /***************************************************************************************************
* @Description : This is to find out if errors occured or not.
* @Param       : void
* @Return      : boolean
****************************************************************************************************/    
    public boolean hasErrors() {
        if ( errorMap.values().size() > 0 ) return true;
        else return false;
    }
    
    /**
* constructor
*/
    public ValidationError() {  
        errorMap = new Map<String, FieldError>();   
        componentErrorMap = new Map<String, FieldError>();
    }
    
    /***************************************************************************************************
@deprecated
* @Description : Add an error to the errorMap
* @Param       : void
* @Return      : void
****************************************************************************************************/      
    public void addError( String fieldName, String sectionName, String errorMessage, Integer orderNumber ) {
        //errorMap.put(fieldName, new FieldError(fieldName, sectionName, errorMessage, orderNumber) );
    }
    
    /***************************************************************************************************
* @Description : Add an error to the errorMap
* @Param       : void
* @Return      : boolean
****************************************************************************************************/  
    public void addError( String fieldName, String errorMessage ) {
        errorMap.put(fieldName, new FieldError(fieldName, errorMessage) );
    }
    
    
    /***************************************************************************************************
* @Description : Add a component error to the errorMap
* @Param       : void
* @Return      : boolean
****************************************************************************************************/  
    public void addCompError( String componentName, String errorMessage ) {
        errorMap.put(componentName, new FieldError(null, componentName, errorMessage) );
    }
    
    /***************************************************************************************************
* @Description : Serialize the Map of errors
* @Param       : void
* @Return      : boolean
****************************************************************************************************/  
    public String serializeErrors() {
        return  JSON.serialize(errorMap);
    }
    
    /***************************************************************************************************
* @Description : Serialize the Map of errors
* @Param       : void
* @Return      : boolean
****************************************************************************************************/  
    public String serializeCompErrors() {
        return  JSON.serialize(componentErrorMap);
    }
    
    /**
* inner class to represent a database Error
*/
    public class FieldError {
        //public String sectionName     {get; set;}
        public String fieldName     {get; set;}
        public String componentName {get; set;}
        public String errorMessage  {get; set;}
        //public Integer orderNumber    {get; set;}
        /***************************************************************************************************
* @Description : This is to create a field error.
* @Param       : String,String
****************************************************************************************************/  
        public FieldError(String fieldName, String errorMessage) {
            this.fieldName = fieldName;
            //this.sectionName = sectionName;
            this.errorMessage = errorMessage;
            //this.orderNumber = orderNumber;
        }
        /***************************************************************************************************
* @Description : This is to create a field error.
* @Param       : String,String
****************************************************************************************************/  
        public FieldError(String fieldName, String componentName, String errorMessage) {
            this.fieldName = fieldName;
            this.componentName = componentName;
            this.errorMessage = errorMessage;
        }
    }   
}