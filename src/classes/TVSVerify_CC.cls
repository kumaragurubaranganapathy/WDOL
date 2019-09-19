public with sharing class TVSVerify_CC {
    public String dorResponse {get; set;}
    public String dorResponseDescription {get; set;}
    public DateTime dorResponseTime {get; set;}
    
    public Id credentialId {get; set;}
    public Boolean certificateSent {get; set;}
    
    public TVSVerify_CC(){
        credentialId = (Id) ApexPages.currentPage().getParameters().get('id');
        String certSent = ApexPages.currentPage().getParameters().get('certificateSent');
        
        certificateSent = false;
        if(certSent != null && certSent == 'true'){
            certificateSent = true;
        }
    }
    
    public void verifyDetails(){
        try{
            if(credentialId != null){
                String recId = DOL_AppConstants.NULL_EMPTY_STRING + '';
                String customerType = DOL_AppConstants.NULL_EMPTY_STRING + '';
                String idType = DOL_AppConstants.NULL_EMPTY_STRING + '';
                String objectToUpdate = DOL_AppConstants.NULL_EMPTY_STRING + '';
                String objectName = DOL_AppConstants.NULL_EMPTY_STRING + '';
                String objectId = DOL_AppConstants.NULL_EMPTY_STRING + '';
                String applicantId = DOL_AppConstants.NULL_EMPTY_STRING + '';
                String applicantLastName = DOL_AppConstants.NULL_EMPTY_STRING + '';
                String applicantFirstName = DOL_AppConstants.NULL_EMPTY_STRING + '';
                String credentialType = DOL_AppConstants.NULL_EMPTY_STRING + '';
                String credentialNumber = DOL_AppConstants.NULL_EMPTY_STRING + '';
                Boolean isOnHold = false;
                datetime certMailedDate;
                
                if(credentialId.getSobjectType().getDescribe().getName() == 'MUSW__License2__c'){
                    MUSW__License2__c lic = [Select Id, Name, MUSW__Applicant__c, MUSW__Applicant__r.Social_Security_Number_Encrypted__c, 
                                             MUSW__Applicant__r.FirstName, MUSW__Applicant__r.LastName, Credential__c, Business_License__c, 
                                             MUSW__Primary_Licensee__c, MUSW__Primary_Licensee__r.FEIN_Number_Encrypted__c, MUSW__Primary_Licensee__r.Name,
                                             MUSW__Applicant__r.Contact_Status__c, MUSW__Primary_Licensee__r.Account_Status__c, 
                                             MUSW__Primary_Licensee__r.Certificate_Mailed_Date__c, MUSW__Applicant__r.Certificate_Mailed_Date__c
                                             From MUSW__License2__c where Id = :credentialId];
                    
                    if(lic.Business_License__c == true){
                        idType = DOL_AppConstants.NULL_EMPTY_STRING + 'FEIN';
                        recId = lic.MUSW__Primary_Licensee__r.FEIN_Number_Encrypted__c;
                        applicantLastName = lic.MUSW__Primary_Licensee__r.Name;
                        applicantFirstName = DOL_AppConstants.NULL_EMPTY_STRING + '';
                        customerType = DOL_AppConstants.NULL_EMPTY_STRING + 'Business';
                        objectToUpdate = DOL_AppConstants.NULL_EMPTY_STRING + 'Account';
                        objectName = lic.MUSW__Primary_Licensee__r.Name;
                        objectId = lic.MUSW__Primary_Licensee__c;
                        isOnHold = (lic.MUSW__Primary_Licensee__r.Account_Status__c == 'On Hold');
                        certMailedDate = lic.MUSW__Primary_Licensee__r.Certificate_Mailed_Date__c;
                    }else{
                        idType = DOL_AppConstants.NULL_EMPTY_STRING + 'SSN';
                        recId = lic.MUSW__Applicant__r.Social_Security_Number_Encrypted__c;
                        applicantLastName = lic.MUSW__Applicant__r.LastName;
                        applicantFirstName = lic.MUSW__Applicant__r.FirstName;
                        customerType = DOL_AppConstants.NULL_EMPTY_STRING + 'Individual';
                        objectToUpdate = DOL_AppConstants.NULL_EMPTY_STRING + 'Contact';
                        objectName = lic.MUSW__Applicant__r.FirstName + ' ' + lic.MUSW__Applicant__r.LastName;
                        objectId = lic.MUSW__Applicant__c;
                        isOnHold = (lic.MUSW__Applicant__r.Contact_Status__c == 'On Hold');
                        certMailedDate = lic.MUSW__Applicant__r.Certificate_Mailed_Date__c;
                    }
                    
                    applicantId = lic.MUSW__Applicant__c;
                    // applicantId = String.valueOf(lic.MUSW__Applicant__c).substring(0, 15);
                    credentialType = lic.Credential__c;
                    credentialNumber = lic.Name;
                }else if(credentialId.getSobjectType().getDescribe().getName() == 'MUSW__Permit2__c'){
                    MUSW__Permit2__c lic = [Select Id, Name, MUSW__Applicant__c, MUSW__Applicant__r.Social_Security_Number_Encrypted__c, 
                                            MUSW__Applicant__r.FirstName, MUSW__Applicant__r.LastName, Permit_Type__c, Business_License__c, 
                                            MUSW__Account__c, MUSW__Account__r.FEIN_Number_Encrypted__c, MUSW__Account__r.Name,
                                            MUSW__Applicant__r.Contact_Status__c, MUSW__Account__r.Account_Status__c,
                                            MUSW__Applicant__r.Certificate_Mailed_Date__c, MUSW__Account__r.Certificate_Mailed_Date__c
                                            From MUSW__Permit2__c where Id = :credentialId];
                    
                    if(lic.Business_License__c == true){
                        idType = DOL_AppConstants.NULL_EMPTY_STRING + 'FEIN';
                        recId = lic.MUSW__Account__r.FEIN_Number_Encrypted__c;
                        applicantLastName = lic.MUSW__Account__r.Name;
                        applicantFirstName = DOL_AppConstants.NULL_EMPTY_STRING + '';
                        customerType = DOL_AppConstants.NULL_EMPTY_STRING + 'Business';
                        objectToUpdate = DOL_AppConstants.NULL_EMPTY_STRING + 'Account';
                        objectName = lic.MUSW__Account__r.Name;
                        objectId = lic.MUSW__Account__c;
                        isOnHold = (lic.MUSW__Account__r.Account_Status__c == 'On Hold');
                        certMailedDate = lic.MUSW__Account__r.Certificate_Mailed_Date__c;
                        system.debug('Entered Business Account');
                        system.debug('isOnHold>>>>'+isOnHold);
                    }else{
                        idType = DOL_AppConstants.NULL_EMPTY_STRING + 'SSN';
                        recId = lic.MUSW__Applicant__r.Social_Security_Number_Encrypted__c;
                        applicantLastName = lic.MUSW__Applicant__r.LastName;
                        applicantFirstName = lic.MUSW__Applicant__r.FirstName;
                        customerType = DOL_AppConstants.NULL_EMPTY_STRING + 'Individual';
                        objectToUpdate = DOL_AppConstants.NULL_EMPTY_STRING + 'Contact';
                        objectName = lic.MUSW__Applicant__r.FirstName + ' ' + lic.MUSW__Applicant__r.LastName;
                        objectId = lic.MUSW__Applicant__c;
                        isOnHold = (lic.MUSW__Applicant__r.Contact_Status__c == 'On Hold');
                        certMailedDate = lic.MUSW__Applicant__r.Certificate_Mailed_Date__c;
                        system.debug('Entered Contact');
                        system.debug('isOnHold>>>>'+isOnHold);
                    }
                    
                    applicantId = lic.MUSW__Applicant__c;
                    //applicantId = String.valueOf(lic.MUSW__Applicant__c).substring(0, 15);
                    credentialType = lic.Permit_Type__c;
                    credentialNumber = lic.Name;
                }
                
                if(objectId == null || objectId == ''){
                    if(objectToUpdate == 'Account'){
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'ERROR: Primary Licensee reference is not populated.'));
                    }else{
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'ERROR: Applicant is not populated.'));
                    }
                    
                    return;
                }
                
                transient Boolean org = [Select Id, isSandbox From Organization][0].isSandbox;
                String url = DOL_AppConstants.NULL_EMPTY_STRING + '';
                if(org == true){
                    url = DOL_AppConstants.NULL_EMPTY_STRING + 'callout:Wisconsin_Endpoint_Test/tvs/v1/verify';
                }else{
                    url = DOL_AppConstants.NULL_EMPTY_STRING + 'callout:Wisconsin_Endpoint_Prod/tvs/v1/verify';
                }
                
                url = url + '?Id={0}&ApplicantId={1}&IdType={2}&LastName={3}&FirstName={4}&LicenseType={5}&LicenseNumber={6}&CustomerType={7}';
                List<String> fillers = new String[]{recId, applicantId, idType, applicantLastName, applicantFirstName, credentialType, credentialNumber, customerType};
                    
                    url = String.format(url, fillers);
                url = url.replace(' ', '+');
                
                if(certificateSent){
                    url = url + '&CertificateSent=true';
                    
                    if(isOnHold == false){
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Contact/Account should be \'On Hold\' in order to send an AA response.'));
                        return;
                    }
                }
                system.debug(url);
                
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
                            }else if(fieldName == 'Timestamp'){
                                try{
                                    dorResponseTime = DateTime.valueOf(fieldValue);
                                }catch(Exception ex){}
                            }
                        }
                    }
                    
                    String onHoldStatus = DOL_AppConstants.NULL_EMPTY_STRING + '';
                    if(dorResponse == 'CD' || dorResponse == 'HD' || dorResponse == 'AA'){
                        onHoldStatus = label.ST_OnHold;
                    }else if(dorResponse == 'CL' || dorResponse == 'IC' || dorResponse == 'HO' || dorResponse == 'OK'){
                        onHoldStatus = label.ST_Active;
                    }
                    system.debug('dorResponse>>>'+dorResponse);
                    sObject sObj;
                    if(objectToUpdate == 'Account'){
                        sObj = Account.sObjectType.NewSObject(objectId);
                        
                        if(onHoldStatus != null && onHoldStatus != ''){
                            sObj.put('Account_Status__c', onHoldStatus);
                        }
                    }else if(objectToUpdate == 'Contact'){
                        sObj = Contact.sObjectType.NewSObject(objectId);
                        
                        if(onHoldStatus != null && onHoldStatus != ''){
                            sObj.put('Contact_Status__c', onHoldStatus);
                        }
                    }
                    sObj.put('DOR_Response__c', dorResponse);
                    sObj.put('DOR_Response_Date__c', dorResponseTime);
                    if(certificateSent && certMailedDate == null){
                        sObj.put('Certificate_Mailed_Date__c', datetime.now());
                    } 
                    if(onHoldStatus == label.ST_Active){
                        sObj.put('Certificate_Mailed_Date__c', null);
                    }
                    update sObj;
                    
                    Id sObjId = (Id) sObj.get('Id');
                    if(objectToUpdate == 'Account'){
                        Account acc = [Select Id, DOR_Response_Description__c From Account where Id = :sObjId];
                        dorResponseDescription = acc.DOR_Response_Description__c;
                    }else if(objectToUpdate == 'Contact'){
                        Contact con = [Select Id, DOR_Response_Description__c From Contact where Id = :sObjId];
                        dorResponseDescription = con.DOR_Response_Description__c;
                    }        
                if(certificateSent){
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, 'AA Code successfully sent to DOR.'));
                }else{
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, 'Successfully retrieved following DOR Details. ' + objectToUpdate + ' object for ' + objectName + ' has been updated.'));
                }
            }else{
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Credential ID not passed'));
            }
        }catch(Exception ex){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'There was an error. Please contact the system administrator.'));
            ErrorLogger.logGeneralException(ex, UserInfo.getUserId(), 'TVSVerify_CC', 'General Exception', 'verifyDetails', 'TVSVerify_CC', label.Str_High);
        }
    }
}
