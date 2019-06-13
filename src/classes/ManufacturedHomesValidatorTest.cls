@istest
public class ManufacturedHomesValidatorTest extends BaseValidator {
    static testmethod void validate_homes_dealer_test()
    {
        BaseValidator.AllSections all=new AllSections();
        MUSW__License2__c newrc = new MUSW__License2__c(
        	credential__c='Manufactured Homes Dealer'            
        );
        //this is not being used in the class
        MUSW__License2__c oldrc = new MUSW__License2__c();
        ManufacturedHomesValidator obj=new ManufacturedHomesValidator();
        obj.validate(all, newrc, oldrc);
        System.assert(obj.e.hasErrors());
    }

    static testmethod void validate_homes_certificate_test()
    {
        BaseValidator.AllSections all=new AllSections();
        MUSW__License2__c newrc = new MUSW__License2__c(
        	credential__c='Manufactured Homes Certificate of Title'            
        );
        //this is not being used in the class
        MUSW__License2__c oldrc = new MUSW__License2__c();
        ManufacturedHomesValidator obj=new ManufacturedHomesValidator();
        obj.validate(all, newrc, oldrc);
        System.assert(obj.e.hasErrors());
    }

}