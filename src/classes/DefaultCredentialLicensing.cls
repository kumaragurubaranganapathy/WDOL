/**
* @see SObjectTriggerHandler
* @see BaseValidator
* @see ValidationError
* @author Akosa Okwudiafor*/

public class DefaultCredentialLicensing extends BaseValidator {
    
    // constructor
    public DefaultCredentialLicensing () {
         System.debug('===> in constructor DefaultCredentialLicensing');
    }
    
         /***************************************************************************************************
* @Description :
* @Param       : NA
* @Return      : NA
***************************************************************************************************/
    public override void validate(AllSections sec, SObject newRec, SObject oldRec){

    }       
}