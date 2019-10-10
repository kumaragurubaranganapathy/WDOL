public class ContactValidator {
    
    public static ValidationError validate (ValidationError e, String recordId, String grouping, String licenseType, String applicationType){
        ValidationError error = new ValidationError();
        System.debug('movement::'+recordId);
        Contact c = [Select Id, Birthdate, Phone,Driver_s_License_Number__c,Municipality__c, Served_in_Military__c, Spouse_Served_in_the_Military__c, Email, Gender__c,
                     Country_of_Military_Service__c, Branch_of_Military_Service__c, Ethnicity__c,
                     Still_Serving_in_Military__c, Honorable_Discharge__c, Start_Date_Military_Service__c, 
                     End_Date_Military_Service__c,Maiden_Name__c, Aliases__c, Birth_Country__c, Birth_City__c, Birth_State_Province__c 
                     FROM Contact WHERE Id = :recordId];
        
        String query = DOL_AppConstants.NULL_EMPTY_STRING;
        if(applicationType==Label.API_License_Field||applicationType==Label.Api_LicenseRenewalfield||applicationType==Label.Api_Reinstatementfield){
           query = DOL_AppConstants.SOQL_CREDENTIAL_TYPE_FILTER + applicationType + DOL_AppConstants.SOQL_WHERE_FILTER_EQUALS_TRUE;
        }
        else{
            query = DOL_AppConstants.SOQL_PROGRAM_AREA_FILTER + applicationType + DOL_AppConstants.SOQL_WHERE_FILTER_EQUALS_TRUE;

        }
        List<Application_Field__c> lstRequiredFields = Database.query(query);
        Set<String> setRequiredFields = new Set<String>();
        for(Application_Field__c reqField : lstRequiredFields){
            setRequiredFields.add(reqField.Name);
        }
        system.debug(setRequiredFields);
        
        if(c != null) {
            error = validateRecord(e, c, setRequiredFields);
        }
        
        return error;
    }
    
    private static ValidationError validateRecord (ValidationError e, Contact c, Set<String> setRequiredFields) {
        System.debug('===>Contact Validation');
        
        if(setRequiredFields.contains('Email') && c.Email == null){
            e.addError('Email', 'You must enter an Email.');
        }
        
        if(setRequiredFields.contains('Birthdate') && c.Birthdate == null ) {
            e.addError('Birthdate', 'You must enter a birthdate.');
        }
        if (setRequiredFields.contains('Ethnicity__c') && (c.Ethnicity__c == null || c.Ethnicity__c == '')){
            e.addError ('Ethnicity__c', 'You must specify an Ethnicity');
        }
        if(c.Birthdate != null ){
            if(c.Birthdate >= system.today())  {
                e.addError('Birthdate', 'Birthdate must be a date in the past.');
            }
            
            // 16*365 = 5840
            if(c.Birthdate.daysBetween(system.today()) < 5840) {
                e.addError('Birthdate', 'You must be at least 16 to apply for a license.');
            }
        } 
        if(setRequiredFields.contains('Phone') && (c.Phone == null || c.Phone == '')) {
            e.addError('Phone', 'You must enter a primary phone number.');
        }
        if(setRequiredFields.contains('Gender__c') && (c.Gender__c == null || c.Gender__c == '')) {
            e.addError('Gender__c', 'You must specify your gender.');
        }
        if(setRequiredFields.contains('Driver_s_License_Number__c') && (c.Driver_s_License_Number__c == null || c.Driver_s_License_Number__c == '')) {
            e.addError('Driver_s_License_Number__c', 'You must enter your Driver\'s License Number.');
        }
        if(setRequiredFields.contains('Municipality__c') && (c.Municipality__c == null || c.Municipality__c == '')) {
            e.addError('Municipality__c', 'You must enter your Municipality.');
        }
        if (setRequiredFields.contains('Birth_Country__c') && (c.Birth_Country__c == null || c.Birth_Country__c == '')){
            e.addError('Birth_Country__c', 'You must enter a Birth Country.');
        }
        if (c.Birth_Country__c != null){
            if (setRequiredFields.contains('Birth_Country__c')&&c.Birth_Country__c == 'United States' && (c.Birth_City__c == null || c.Birth_City__c == '')) {    
                e.addError('Birth_City__c', 'With "United States" as your Birth Country, you must choose a Birth City.');
            }
            if (setRequiredFields.contains('Birth_Country__c')&&c.Birth_Country__c == 'United States' && (c.Birth_State_Province__c == null || c.Birth_State_Province__c == '')) {    
                e.addError('Birth_State_Province__c', 'With "United States" as your Birth Country, you must choose a Birth State.');
            }
        }
        return e;
    }
}