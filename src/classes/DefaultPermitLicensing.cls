/**
* @see SObjectTriggerHandler
* @see BaseValidator
* @see ValidationError
* @author Akosa Okwudiafor*/

public class DefaultPermitLicensing extends BaseValidator {
    
    // constructor
    public DefaultPermitLicensing () {
         System.debug('===> in constructor DefaultPermitLicensing');
    }
    
         /***************************************************************************************************
* @Description :
* @Param       : NA
* @Return      : NA
***************************************************************************************************/
    public override void validate(AllSections sec, SObject newRec, SObject oldRec){
        Musw__Permit2__c l = (Musw__Permit2__c)newRec;
        //Declare three boolean variables. 
        Boolean powtsBusiness =false;
        if(l.Permit_Type__c == Label.PT_POWTS_Petition_for_Variance){
            powtsBusiness = true;
        }
        
        if(powtsBusiness&&l.Facility_Name__c==null)
        {
                  // e.addCompError('Facility_Name__c', 'Please complete all the required fields in the section');
        }
        
    }       
}