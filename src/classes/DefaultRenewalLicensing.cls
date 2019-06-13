/**
* @see SObjectTriggerHandler
* @see BaseValidator
* @see ValidationError
* @author Akosa Okwudiafor*/

public class DefaultRenewalLicensing extends BaseValidator {
    
    // constructor
    public DefaultRenewalLicensing () {
         System.debug('===> in constructor DefaultRenewalLicensing');
    }
    
         /***************************************************************************************************
* @Description :
* @Param       : NA
* @Return      : NA
***************************************************************************************************/
    public override void validate(AllSections sec, SObject newRec, SObject oldRec){
        
    }       
}