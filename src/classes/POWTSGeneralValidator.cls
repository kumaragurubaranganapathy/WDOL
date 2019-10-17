/**
* @see POWTSGeneralValidator
* @see BaseValidator
* @see ValidationError
* @author Akosa Okwudiafor*/

public class POWTSGeneralValidator extends BaseValidator {
    
    // constructor
    public POWTSGeneralValidator () {
      //  System.debug('===> in constructor POWTSGeneralValidator');
    }
    
    /***************************************************************************************************
* @Description :
* @Param       : NA
* @Return      : NA
***************************************************************************************************/
    public override void validate(AllSections sec, SObject newRec, SObject oldRec){
        Musw__Permit2__c l = (Musw__Permit2__c)newRec;
        /*if(l.Type_of_Plan_Review__c==null&&l.Permit_Type__c==Label.PT_POWTS_Component_Manual_Review)
        {
            e.addCompError('Type_of_Plan_Review__c', 'Please enter the Type of Plan Review');
        }*/
        if(l.MUSW__Project2__c==null&&l.Permit_Type__c!=Label.PT_POWTS_Consultation&&l.Permit_Type__c!=Label.PT_POWTS_Sanitary_Permit&&L.Permit_Type__c!=Label.PT_POWTS_Component_Manual_Review)
        {
                 e.addCompError('ProjectInformationComponent', 'You must have one site.');
        }
    }       
}