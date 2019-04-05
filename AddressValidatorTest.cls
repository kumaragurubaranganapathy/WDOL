@istest
public class AddressValidatorTest {
    static testmethod void Validatetest()
    {
        ValidationError e = new ValidationError();
        String B='Delegated Municipality Agent';
        String LicType='Delegated Agent - Boiler';
        String App='License__c';
        MUSW__License2__c license=new MUSW__License2__c(
        	MUSW__Expiration_Date__c=Date.today(),
            CE_Hours__c=3.321,
            Name='Test License1',
            Credential__c='Dwelling Contractor',
            Credential_Type__c='Dwelling Contractor',
            Application_Type__c='Trades Credential'
        );
        insert license;
       
        String LicID=String.valueOf(license.Id);
        System.debug(LicID);
       AddressValidator.validate(e,b,LicType,App,LicID);
    }

}