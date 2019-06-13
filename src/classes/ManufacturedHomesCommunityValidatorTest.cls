@istest
public class ManufacturedHomesCommunityValidatorTest extends BaseValidator {
 static testmethod void validate_test()
{
        BaseValidator.AllSections all=new AllSections();
        MUSW__Permit2__c newrc = new MUSW__Permit2__c(Permit_Type__c='Manufactured Homes Community Permit');
        //oldrc
        MUSW__Permit2__c oldrc = new MUSW__Permit2__c();
        ManufacturedHomesCommunityValidator obj=new ManufacturedHomesCommunityValidator();
        obj.validate(all, newrc, oldrc);  
}
}