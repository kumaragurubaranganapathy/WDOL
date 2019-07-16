public with sharing class TVSVerifyApplication {
    public static String dorResponse;
    
    public TVSVerifyApplication(){
        
    }
    public static string verifyDetails(Id credentialId, Boolean certificateSent){
        String recId = '';
        String customerType = '';
        String idType = '';
        String objectToUpdate = '';
        String objectName = '';
        String objectId = '';
        String applicantId = '';
        String applicantLastName = '';
        String applicantFirstName = '';
        String credentialType = '';
        String credentialNumber = '';
        Boolean isOnHold = false;
        String onHoldStatus = label.ST_NoAction;
        
        system.debug('Entered verifyDetails');
        
        try{
        if(credentialId.getSobjectType().getDescribe().getName() == 'MUSW__License2__c'){
            MUSW__License2__c lic = [Select Id, Name, MUSW__Applicant__c, MUSW__Applicant__r.Social_Security_Number_Encrypted__c, 
                                     MUSW__Applicant__r.FirstName, MUSW__Applicant__r.LastName, Credential__c, Business_License__c, 
                                     MUSW__Primary_Licensee__c, MUSW__Primary_Licensee__r.FEIN_Number_Encrypted__c, MUSW__Primary_Licensee__r.Name,
                                     MUSW__Applicant__r.Contact_Status__c, MUSW__Primary_Licensee__r.Account_Status__c 
                                     From MUSW__License2__c where Id = :credentialId];
            
            if(lic.Business_License__c == true){
                idType = 'FEIN';
                recId = lic.MUSW__Primary_Licensee__r.FEIN_Number_Encrypted__c;
                applicantLastName = lic.MUSW__Primary_Licensee__r.Name;
                applicantFirstName = '';
                customerType = 'Business';
                objectToUpdate = 'Account';
                objectName = lic.MUSW__Primary_Licensee__r.Name;
                objectId = lic.MUSW__Primary_Licensee__c;
                isOnHold = (lic.MUSW__Primary_Licensee__r.Account_Status__c == 'On Hold');
            }else{
                idType = 'SSN';
                recId = lic.MUSW__Applicant__r.Social_Security_Number_Encrypted__c;
                applicantLastName = lic.MUSW__Applicant__r.LastName;
                applicantFirstName = lic.MUSW__Applicant__r.FirstName;
                customerType = 'Individual';
                objectToUpdate = 'Contact';
                objectName = lic.MUSW__Applicant__r.FirstName + ' ' + lic.MUSW__Applicant__r.LastName;
                objectId = lic.MUSW__Applicant__c;
                isOnHold = (lic.MUSW__Applicant__r.Contact_Status__c == 'On Hold');
            }
            
            applicantId = lic.MUSW__Applicant__c;
            //applicantId = String.valueOf(lic.MUSW__Applicant__c).substring(0, 15);
            credentialType = lic.Credential__c;
            credentialNumber = lic.Name;
        }else if(credentialId.getSobjectType().getDescribe().getName() == 'MUSW__Permit2__c'){
            MUSW__Permit2__c lic = [Select Id, Name, MUSW__Applicant__c, MUSW__Applicant__r.Social_Security_Number_Encrypted__c, 
                                    MUSW__Applicant__r.FirstName, MUSW__Applicant__r.LastName, Permit_Type__c, Business_License__c, 
                                    MUSW__Account__c, MUSW__Account__r.FEIN_Number_Encrypted__c, MUSW__Account__r.Name,
                                    MUSW__Applicant__r.Contact_Status__c, MUSW__Account__r.Account_Status__c     
                                    From MUSW__Permit2__c where Id = :credentialId];
            
            if(lic.Business_License__c == true){
                idType = 'FEIN';
                recId = lic.MUSW__Account__r.FEIN_Number_Encrypted__c;
                applicantLastName = lic.MUSW__Account__r.Name;
                applicantFirstName = '';
                customerType = 'Business';
                objectToUpdate = 'Account';
                objectName = lic.MUSW__Account__r.Name;
                objectId = lic.MUSW__Account__c;
                isOnHold = (lic.MUSW__Account__r.Account_Status__c == 'On Hold');
            }else{
                idType = 'SSN';
                recId = lic.MUSW__Applicant__r.Social_Security_Number_Encrypted__c;
                applicantLastName = lic.MUSW__Applicant__r.LastName;
                applicantFirstName = lic.MUSW__Applicant__r.FirstName;
                customerType = 'Individual';
                objectToUpdate = 'Contact';
                objectName = lic.MUSW__Applicant__r.FirstName + ' ' + lic.MUSW__Applicant__r.LastName;
                objectId = lic.MUSW__Applicant__c;
                isOnHold = (lic.MUSW__Applicant__r.Contact_Status__c == 'On Hold');
            }
            
            applicantId = lic.MUSW__Applicant__c;
            //applicantId = String.valueOf(lic.MUSW__Applicant__c).substring(0, 15);
            credentialType = lic.Permit_Type__c;
            credentialNumber = lic.Name;
        } else if(credentialId.getSobjectType().getDescribe().getName() == 'Renewal_Application__c'){
            Renewal_Application__c renReins = [Select Id, name, Applicant__c, Applicant__r.Social_Security_Number_Encrypted__c, 
                                               Applicant__r.FirstName, Applicant__r.LastName, Applicant__r.Contact_Status__c,
                                               Credential__c, Permit_Type__c, Permit__r.Name, License__r.Name,
                                               Business_License__c, Licensee__c, Licensee__r.FEIN_Number_Encrypted__c, Licensee__r.Name,
                                               Licensee__r.Account_Status__c from Renewal_Application__c where Id = :credentialId];
            if(renReins.Business_License__c == true){
                idType = 'FEIN';
                recId = renReins.Licensee__r.FEIN_Number_Encrypted__c;
                applicantLastName = renReins.Licensee__r.Name;
                applicantFirstName = '';
                customerType = 'Business';
                objectToUpdate = 'Account';
                objectName = renReins.Licensee__r.Name;
                objectId = renReins.Licensee__c;
                isOnHold = (renReins.Licensee__r.Account_Status__c == 'On Hold');
            }else{
                idType = 'SSN';
                recId = renReins.Applicant__r.Social_Security_Number_Encrypted__c;
                applicantLastName = renReins.Applicant__r.LastName;
                applicantFirstName = renReins.Applicant__r.FirstName;
                customerType = 'Individual';
                objectToUpdate = 'Contact';
                objectName = renReins.Applicant__r.FirstName + ' ' + renReins.Applicant__r.LastName;
                objectId = renReins.Applicant__c;
                isOnHold = (renReins.Applicant__r.Contact_Status__c == 'On Hold');
            }
            applicantId = renReins.Applicant__c;
            //applicantId = String.valueOf(lic.MUSW__Applicant__c).substring(0, 15);
            if(renReins.License__r.Name != null && renReins.License__r.Name != ''){
                credentialType = renReins.Credential__c;
            	credentialNumber = renReins.License__r.Name;
            }else if(renReins.Permit__r.Name != null && renReins.Permit__r.Name != ''){
                credentialType = renReins.Permit_Type__c;
            	credentialNumber = renReins.Permit__r.Name;
            } else{
                if(renReins.Permit_Type__c != null && renReins.Permit_Type__c != ''){
                	credentialType = renReins.Permit_Type__c;
                }else{
                    credentialType = renReins.Credential__c;
                }
                credentialNumber = renReins.Name;
            }
			system.debug('credentialNumber>>>'+credentialNumber);
            system.debug('credentialType>>>'+credentialType);
            system.debug('renReins.License__r.Name>>>'+renReins.License__r.Name);
            system.debug('renReins.Credential__c>>>'+renReins.Credential__c);
            
            system.debug('renReins.Permit__r.Name>>>'+renReins.Permit__r.Name);
            system.debug('renReins.Permit_Type__c>>>'+renReins.Permit_Type__c);
        }
        
        transient Boolean org = [Select Id, isSandbox From Organization][0].isSandbox;
        String url = '';
        if(org == true){
            url = 'callout:Wisconsin_Endpoint_Test/tvs/v1/verify';
            // Un-comment status to bypass TVS check in sandbox
             string status = label.ST_Active;
             return status;
            
        }else{
            url = 'callout:Wisconsin_Endpoint_Prod/tvs/v1/verify';
        }
        
        url = url + '?Id={0}&ApplicantId={1}&IdType={2}&LastName={3}&FirstName={4}&LicenseType={5}&LicenseNumber={6}&CustomerType={7}';
        List<String> fillers = new String[]{recId, applicantId, idType, applicantLastName, applicantFirstName, credentialType, credentialNumber, customerType};
            
        url = String.format(url, fillers);
        url = url.replace(' ', '+');
        
        if(certificateSent){
            url = url + '&CertificateSent=true';
        }
        system.debug(url);
        system.debug('isOnHold>>>'+isOnHold);
        
            HttpRequest req = new HttpRequest();
            req.setEndpoint(url);
            req.setMethod('GET');
            // Set Timeout request for 2 min
            req.setTimeout(120000);
            
            Http h = new Http();
            HttpResponse res = h.send(req);
            
            system.debug(res.getBody());
            
            JSONParser parser = JSON.createParser(res.getBody());
            while (parser.nextToken() != null) {
                if (parser.getCurrentToken() == JSONToken.FIELD_NAME){
                    String fieldName = parser.getText();
                    parser.nextToken();
                    String fieldValue = parser.getText();
                    if(fieldName == 'Response'){
                        dorResponse = fieldValue;
                    }
                }
            }
            system.debug('dorResponse>>>'+dorResponse);
            if(dorResponse == 'CD' || dorResponse == 'HD' || dorResponse == 'AA'){
                onHoldStatus = label.ST_OnHold;
            }else{
                onHoldStatus = label.ST_Active;
            }
            system.debug('onHoldStatus>>>'+onHoldStatus);
            
        }catch(exception ex){
            ErrorLogger.logGeneralException(ex, UserInfo.getUserId(), 'TVSVerifyApplication', 'Error Occured while Submitting the application from Portal TVS integration', 'verifyDetails', dorResponse, label.Str_HIGH);
        }finally{
            return onHoldStatus;
        } 
        return onHoldStatus;
    }
}