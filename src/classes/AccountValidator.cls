public class AccountValidator {
    
    public static ValidationError validate (ValidationError e, String recordId, String grouping, String licenseType, String applicationType){

      ValidationError error = new ValidationError();

        Account a = [SELECT Id, Name, Type, Phone,Email__c, AccountNumber, NumberOfEmployees, Security_Code__c, FEIN_Number_Encrypted__c, Account_Status__c, Business_Name__c, Track_No__c, Issued_Number__c, Last_4_Digits_of_FEIN__c,Email_Primary_Contact__c,Phone_Primary_Contact__c
                        FROM Account WHERE Id = :recordId];
                        
        String query ='';
        if(applicationType==Label.API_License_Field||applicationType==Label.Api_LicenseRenewalfield||applicationType==Label.Api_Reinstatementfield){
           query = 'Select Name From Application_Field__c where Required__c = true and Object_Name__c = \'Account\' and Parent__r.Parent__r.Parent__r.Credential__c = :licenseType and ' + 
            ' Parent__r.Parent__r.Parent__r.Credential_Type__c = :grouping and ' + applicationType + ' = true';
        }
        else{
            query = 'Select Name From Application_Field__c where Required__c = true and Object_Name__c = \'Account\' and Parent__r.Parent__r.Parent__r.Credential__c = :licenseType and ' + 
            ' Parent__r.Parent__r.Parent__r.Program_Area__c = :grouping and ' + applicationType + ' = true';

        }
        List<Application_Field__c> lstRequiredFields = Database.query(query);
        Set<String> setRequiredFields = new Set<String>();
        for(Application_Field__c reqField : lstRequiredFields){
            setRequiredFields.add(reqField.Name);
        }
                        
        if(a != null) {
                 error = validateRecord(e, a, setRequiredFields);
        }

      return error;
    }

    private static ValidationError validateRecord (ValidationError e, Account a, Set<String> setRequiredFields) {
              
        if(setRequiredFields.contains('Email__c') && a.Email__c == null){
            e.addError('Email__c', 'You must enter an Email.');
        }
        if(setRequiredFields.contains('Email_Primary_Contact__c') && a.Email_Primary_Contact__c == null){
            e.addError('Email_Primary_Contact__c', 'You must enter the Primary Contact\'s Email.');
        }
        if(setRequiredFields.contains('Phone_Primary_Contact__c') && a.Phone_Primary_Contact__c == null){
            e.addError('Phone_Primary_Contact__c', 'You must enter the Primary Contact\'s Phone.');
        }
        return e;    
    }
}