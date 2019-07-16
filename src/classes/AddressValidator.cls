public class AddressValidator {
    
    public static ValidationError validate (ValidationError e,  String Board, String licenseType, String applicationType, String licenseId){
        ValidationError error = new ValidationError();
        
        Boolean isMailingRequired = false;
        Boolean isPublicRequired = false;
        Boolean isPhysicalRequired = false; 
        
        String query = '';
         if(applicationType==Label.API_License_Field||applicationType==Label.Api_LicenseRenewalfield||applicationType==Label.Api_Reinstatementfield){
           query = 'Select Name From  Application_Subsection__c where Active__c=true and Component_Name__c = \'BusinessAddress\' ' + 'and Parent__r.Parent__r.Credential__c = :licenseType and ' + 
            ' Parent__r.Parent__r.Credential_Type__c = :Board and ' + applicationType + ' = true and Required__c=true';
        }
        else{
            System.debug('query for address');
            query = 'Select Name From  Application_Subsection__c where Active__c= true and Component_Name__c = \'BusinessAddress\' ' + 'and Parent__r.Parent__r.permit_type__c = :licenseType and ' + 
            ' Parent__r.Parent__r.Program_Area__c = :Board and ' + applicationType + ' = true';
        }
               
        List<Application_Subsection__c> lstRequiredComponents = Database.query(query);
        for(Application_Subsection__c comp : lstRequiredComponents){
            if(comp.Name != null && comp.Name.contains(label.Str_Mailing)){
                isMailingRequired = true;
            }else if(comp.Name != null && comp.Name.contains(label.Str_Public)){
                isPublicRequired = true;
            }else if(comp.Name != null && comp.Name.contains(label.Str_Physical)){
                isPhysicalRequired = true;
            }
        }
        
        List<String> missingAddresses = new List<String>();
        Boolean isMail = false;
        Boolean isPublic = false;
        Boolean isPhysical = false;
         list <MUSW__License_Parcel__c> addresslics= new   list <MUSW__License_Parcel__c>();
          list <MUSW__Permit_Parcel__c> addressparcels= new   list <MUSW__Permit_Parcel__c>();
          if(applicationType==Label.API_License_Field||applicationType==Label.Api_LicenseRenewalfield||applicationType==Label.Api_Reinstatementfield){
             addresslics = [SELECT Id, Mailing__c, Public__c, Physical__c, MUSW__License2__c FROM MUSW__License_Parcel__c WHERE MUSW__License2__c = :licenseId and MUSW__Parcel__r.Status__c = 'Active'];
          }
        else{
            addressparcels = [SELECT Id, Mailing__c, Public__c, Physical__c, MUSW__Permit2__c FROM MUSW__Permit_Parcel__c WHERE MUSW__Permit2__c = :licenseId and MUSW__Parcel__r.Status__c = 'Active'];
        }
        if(addresslics.size()>0){
        for (MUSW__License_Parcel__c lp:addresslics){ 
            if(lp.Mailing__c){
                isMail = true;
            }     
            if(lp.Public__c){
                isPublic = true;
            }
            if(lp.Physical__c) {
                isPhysical = true;
            }   
        }
        }
        else if(addressparcels.size()>0){
            for (MUSW__Permit_Parcel__c lp:addressparcels){ 
            if(lp.Mailing__c){
                isMail = true;
            }     
            if(lp.Public__c){
                isPublic = true;
            }
            if(lp.Physical__c) {
                isPhysical = true;
            }   
        }
        }
        
        if(isMailingRequired == true && isMail == false){
            missingAddresses.add(label.Str_Mailing);
        }
        if(isPublicRequired == true && isPublic == false){
            missingAddresses.add(label.Str_Public);
        }
        if(isPhysicalRequired == true && isPhysical == false){
            missingAddresses.add(label.Str_Physical);
        }
        
        if (missingAddresses.size() > 0) {
            String errorString = String.join(missingAddresses, ', ');
            if(missingAddresses.size()==1){
            e.addCompError('BusinessAddress', 'You must choose the following address : ' + errorString);
            }
            else{
             e.addCompError('BusinessAddress', 'You must choose the following addresses : ' + errorString);
            }
        }
        
        return e;
    }
    
}