/**
* Name: BaseValidator
* Type: Class
* Description: Helps in validating por
* Date:        Developer/Company                 	Description
* ---------------------------------------------------------------------------------------------------------------------------------------- *
* 06/1/2018   Akosa Okwudiafor/Deloitte           Initial Creation
**/
public virtual class BaseValidator {
    
    protected ValidationError e = new ValidationError();
    /**
* enum to list the valid SObject Types
*/
    public enum ApplicationObjectType {LICENSE, RENEWAL, REINSTATEMENT,PERMIT, SERVICEREQUEST}
    
    
    /***************************************************************************************************
* @Description : Decide which Validator to instantiate based on the record type and the objType can be a License, Renewal, Reinstatement or Endorsement
* @Param       : ApplicationObjectType objType, String recordTypeName
* @Return      : NA
****************************************************************************************************/
    public static BaseValidator createValidator(ApplicationObjectType objType, String recordTypeName)
    {
        //The contact, account and address valiations are enterprise level and are determined based on the Pages, Sections.. config.
        //Therefore, there are common validators for these validations. Only create a record type specific validator if any additional
        //validation is to be added. Otherwise, return the empty default validator.
        System.debug('Basevalidator  '+recordTypeName);
        if ( ApplicationObjectType.LICENSE == objType && recordTypeName == Label.RT_Delegated_Agent_Record_Type) {
            return new ValidatorDAGeneralLicensing();
        }
        else if ( ApplicationObjectType.LICENSE == objType && recordTypeName == Label.RT_Manufactured_Homes_Record_Type) {
            return new ManufacturedHomesValidator();
        }
        else if ( ApplicationObjectType.PERMIT == objType && recordTypeName == Label.RT_Permit) {
            return new ManufacturedHomesCommunityValidator();
        }
        else if ( ApplicationObjectType.PERMIT == objType && recordTypeName == Label.RT_POWTS_Plan_Review) {
            return new POWTSGeneralValidator();
        }else if ( ApplicationObjectType.RENEWAL == objType && recordTypeName ==Label.RT_Universal_Default_Renewal_Reinstatement) {
            return new DefaultRenewalLicensing();
        }
        else{
            return new DefaultValidator();
        }

    }
    
    
    
    
    /***************************************************************************************************
* @Description : Method to validate Contact
* @Param       : ApplicationObjectType objType, SObject newRecord
* @Return      : NA
****************************************************************************************************/
    public void validateContact(ApplicationObjectType objType, SObject newRecord) {
        if(ApplicationObjectType.LICENSE == objType) {
            MUSW__License2__c l = (MUSW__License2__c)newRecord;
            e = ContactValidator.validate(e, l.MUSW__Applicant__c, l.Credential_Type__c, l.Credential__c, Label.API_License_Field);
        }
        else if(ApplicationObjectType.PERMIT == objType) {
            MUSW__Permit2__c p= (MUSW__Permit2__c)newRecord;
            e = ContactValidator.validate(e, p.MUSW__Applicant__c, p.Program_Area__c, p.Permit_Type__c, Label.Api_Permitfield);
        }
        else {
            Renewal_Application__c r = (Renewal_Application__c)newRecord;
            String appType = '';
            String licType = '';
            String grouping='';
            if(r.Renewal_Reinstatement_Type__c == Label.RNT_Renewal&&r.License__c!=null){
                licType = r.Credential__c;
                appType = Label.Api_LicenseRenewalfield;
                grouping=r.Credential_Type__c;
            }else if(r.Renewal_Reinstatement_Type__c == Label.RNT_Reinstatement){
                appType = Label.Api_Reinstatementfield;
                licType = r.Credential__c;
                grouping=r.Credential_Type__c;
            }else if(r.Renewal_Reinstatement_Type__c == Label.RNT_RenewalPTO&&r.Permit__c!=null ){
                appType = Label.Api_PermitRenewalfield;
                licType = r.Permit_Type__c;
                grouping= r.Program_Area__c;
            }
            
            e = ContactValidator.validate(e, r.Applicant__c, grouping, licType, appType);
        }
        
        System.debug('===>Value of e: ' + e);
    }
    
    
    
    /***************************************************************************************************
* @Description : Method to validate Account
* @Param       : ApplicationObjectType objType, SObject newRecord
* @Return      : NA
****************************************************************************************************/
    public void validateAccount(ApplicationObjectType objType, SObject newRecord) {
        if(ApplicationObjectType.LICENSE == objType) {
            MUSW__License2__c l = (MUSW__License2__c)newRecord;
            e = AccountValidator.validate(e, l.MUSW__Primary_Licensee__c, l.Credential_Type__c, l.Credential__c, Label.API_License_Field);
        }
        else if(ApplicationObjectType.PERMIT == objType) {
            MUSW__Permit2__c p = (MUSW__Permit2__c)newRecord;
            e = AccountValidator.validate(e, p.MUSW__Account__c, p.Program_Area__c, p.Permit_Type__c, Label.Api_Permitfield);
        }
        else {
            Renewal_Application__c r = (Renewal_Application__c)newRecord;            
            String appType = '';
            String licType = '';
            String grouping='';
            if(r.Renewal_Reinstatement_Type__c == Label.RNT_Renewal&&r.License__c!=null){
                appType = Label.Api_LicenseRenewalfield;
                licType = r.Credential__c;
                grouping=r.Credential_Type__c;
            }else if(r.Renewal_Reinstatement_Type__c == Label.RNT_Reinstatement){
                appType = Label.Api_Reinstatementfield;
                licType = r.Credential__c;
                grouping=r.Credential_Type__c;
            }else if(r.Renewal_Reinstatement_Type__c == Label.RNT_RenewalPTO&&r.Permit__c!=null){
                appType = Label.Api_PermitRenewalfield;
                licType = r.Permit_Type__c;
                grouping= r.Program_Area__c;
            }
            
            e = AccountValidator.validate(e, r.Licensee__c,grouping,licType, appType);
        }
    }
    
    /***************************************************************************************************
* @Description : Method to validate address
* @Param       : ApplicationObjectType objType, SObject newRecord
* @Return      : NA
****************************************************************************************************/    
    public void validateAddress(ApplicationObjectType objType, SObject newRecord) {
        System.debug('validateAddress ');
        if(ApplicationObjectType.LICENSE == objType) {
            MUSW__License2__c l = (MUSW__License2__c)newRecord;
            e = AddressValidator.validate(e,l.Credential_Type__c, l.Credential__c, Label.API_License_Field,l.Id);
        }
        else if(ApplicationObjectType.PERMIT == objType) {
            System.debug(' validateAddress');
            MUSW__Permit2__c q = (MUSW__Permit2__c)newRecord;
            e = AddressValidator.validate(e,q.Program_Area__c, q.Permit_Type__c, Label.Api_Permitfield,q.Id);
        }
        else {
            Renewal_Application__c r = (Renewal_Application__c)newRecord;  
            String licType = '';
            String grouping='';
            String appType = '';
            if(r.Renewal_Reinstatement_Type__c == Label.RNT_Renewal&&r.License__c!=null){
                licType = r.Credential__c;
                appType = Label.Api_LicenseRenewalfield;
                grouping=r.Credential_Type__c;
            }else if(r.Renewal_Reinstatement_Type__c == Label.RNT_Reinstatement){
                licType = r.Credential__c;
                appType = Label.Api_Reinstatementfield;
                grouping=r.Credential_Type__c;
            }else if(r.Renewal_Reinstatement_Type__c== Label.RNT_RenewalPTO &&r.Permit__c!=null ){
                appType = Label.Api_PermitRenewalfield;
                licType = r.Permit_Type__c;
                grouping= r.Program_Area__c;
            }            
            String licenseId;
            if (r.License__c != null) {
                licenseId = r.License__c;
            }   
            else if(r.Permit__c!=null){
                licenseId=  r.Permit__c;
            }             
            e = AddressValidator.validate(e, grouping, licType, appType, licenseId);
        }
    }
    
    public void validateServiceRequest(ApplicationObjectType objType, SObject newRecord) {
        Decimal secNum = (Decimal)newRecord.get(Label.Api_SectionNumber);
        System.debug('===> section number:' + secNum);
        
        if ( secNum == 99 ) {
            System.debug('===> section number is 99, ... validating all sections');
            if(ApplicationObjectType.SERVICEREQUEST == objType) {
                MUSW__Application2__c sr = (MUSW__Application2__c)newRecord;
                e = ServiceRequestValidator.validate(e, sr);
                
                // now add the errors ( if there were any )
                if ( e.hasErrors() ) {
                    System.debug('***** GOT ERRORS *****');
                    System.debug(e.errorMap);
                    newRecord.addError( e.serializeErrors() );
                }
            }
            System.debug('===>Value of e: ' + e);
        }
    }
    
    /***************************************************************************************************
* @Description : Use Polymorphism to avoid "poluting" the validation with if statements.  We still need to create the specif classes that will perform the validation but that logic
is in one central place - here. Based on the value of the section, instantiate a subclass of the Section class to be used as a parameter to the validate method
* @Param       : SObject newRecord, SObject oldRecord
* @Return      : NA
****************************************************************************************************/
    public void validate(SObject newRecord, SObject oldRecord) {   
        Decimal secNum = (Decimal)newRecord.get(Label.Api_SectionNumber);
        System.debug('===> section number:' + secNum);
        // DO_NOT_VALIDATE VALIDATE_SECTION VALIDATE_FOR_REVIEW VALIDATION_COMPLETE VALIDATION_INCOMPLETE
        // if ( 'DO_NOT_VALIDATE' == l.ValidationStatus__c ) {
        
        if ( secNum == 99 ) {
            System.debug('===> section number is 99, ... validating all sections');
            validate( new AllSections(), newRecord, oldRecord);
            
            // now add the errors ( if there were any )
            if ( e.hasErrors() ) {
                System.debug('***** GOT ERRORS *****');
                System.debug(e.errorMap);
                newRecord.addError( e.serializeErrors() );
            }
        } 
    }
    
    protected virtual void validate(AllSections sec, SObject newRecord, SObject oldRecord) { } 
    /***************************************************************************************************
* @Description : Method to run the validations done through configuration on the FieldsObj 
* @Param       : Map<Id,MUSW__License2__c> newLicenseMap
* @Return      : NA
****************************************************************************************************/
    
    public void runConfigurableValidations() {
        
    }
    
    /**
* Utility Section (and subclasses) to allow for polymorphic validation implementation
*/
    public interface Section{}
    public class AllSections    implements Section{}
    
    /**
* this gives us the ability to validate by different section - if needed in the future
*/
    public class SectionOne     implements Section{}
}