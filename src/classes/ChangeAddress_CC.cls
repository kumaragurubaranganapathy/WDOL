/**
* User Story: 
* Class Name: ChangeAddress_CC
* Test Class Name: ChangeAddress_CC_Test
* Description: Controller for ChangeAddress VF Page
* Date:        Developer/Company                    Description
* ---------------------------------------------------------------------------------------------------------------------------------------- *
* 07/27/2018   Sharad Maheshwari/Deloitte           Initial Creation
**/
public with sharing class ChangeAddress_CC {
    //public MUSW__Application2__c serviceRequest{get;set;}
    public String licenseOrPermitNumber{get;set;}
    public String licenseType{get;set;}
    public String applicationType{get;set;}
    public String credentialType{get;set;}
    public String credential{get;set;}
    public String permitType{get;set;}
    public String programArea{get;set;}
    //public String licenseBoard{get;set;}
    public Boolean isError{get;set;}
    public String errorMessage{get;set;}
    public List<SelectOption> addressList{get;set;}
    public String mailingAddressId{get;set;}
    public String publicAddressId{get;set;}
    //public String physicalAddressId{get;set;}
    public Boolean showMailingAddress{get;set;}
    public Boolean showPublicAddress{get;set;}
    //public Boolean showPhysicalAddress{get;set;}
    
    private Id licenseOrPermitId;
    private String licenseOrPermit;
    private MUSW__License2__c license;
    private MUSW__Permit2__c permit;
    private String individualOrBusiness ='';
    private Id contactId;
    /*The below variables were added to fetch Account ID, Applicant/Contact ID and to determine whether the license type is business  or individual*/
    public Id accID{get;set;}
    public Id conID{get;set;}
    public boolean business_license{get;set;}
    /***************************************************************************************************
* @Description : Constructor
* @Param       : NA
* @Return      : NA
***************************************************************************************************/
    public ChangeAddress_CC() {
        //serviceRequest = new MUSW__Application2__c();
        licenseOrPermitId = ApexPages.currentPage().getParameters().get('licenseOrPermitId');
        licenseOrPermit = ApexPages.currentPage().getParameters().get('licenseOrPermit');
        
        try{
            if(licenseOrPermit == Label.Str_Credential){
            license = [SELECT Id,Name,Application_Type__c, Credential__c, Credential_Type__c, MUSW__Primary_Licensee__c, MUSW__Applicant__c 
                       FROM MUSW__License2__c 
                       WHERE Id=:licenseOrPermitId limit 1];
            
            individualOrBusiness = [SELECT IndividualBusinessType__C
                                   FROM License_Type__mdt
                                   WHERE Credential__c = :license.Credential__c
                                   AND Object_Name__c = :Label.API_License2].IndividualBusinessType__C;
            
            accID = license.MUSW__Primary_Licensee__c;
            conID = license.MUSW__Applicant__c;
            
            if(individualOrBusiness == 'Business')
                {business_license = true;}
                else
                {business_license = false;}
            
            licenseOrPermitNumber = license.Name;
            applicationType = license.Application_Type__c;
            credentialType = license.Credential_Type__c;
            credential = license.Credential__c;
            
            User user = [SELECT Id, ContactId FROM User WHERE Id = :UserInfo.getUserId()];
            
            contactId = user.contactId;
            populateAddressList();
                
            showMailingAddress = true;
            showPublicAddress = true;            
                
                for(MUSW__License_Parcel__c lpRecord : [SELECT MUSW__Parcel__c, Mailing__c, Public__c 
                                                        FROM MUSW__License_Parcel__c 
                                                        WHERE MUSW__License2__c = :licenseOrPermitId]){
                    if(lpRecord.Mailing__c){
                        mailingAddressId = lpRecord.MUSW__Parcel__c;                        
                    }
                    if(lpRecord.Public__c){
                        publicAddressId = lpRecord.MUSW__Parcel__c;
                    }
                    
                }
            
        }else if(licenseOrPermit == Label.Str_Permit){
            permit = [SELECT Id, Name, Application_Type__c, Program_Area__c, Permit_Type__c, MUSW__Account__c, MUSW__Applicant__c 
                       FROM MUSW__Permit2__c 
                       WHERE Id=:licenseOrPermitId limit 1];
            
            accID = permit.MUSW__Account__c;
            conID = permit.MUSW__Applicant__c;
            
            
            
            licenseOrPermitNumber = permit.Name;
            ApplicationType = permit.Application_Type__c;
            programArea = permit.Program_Area__c;
            permitType = permit.Permit_Type__c;
            User user = [SELECT Id, ContactId FROM User WHERE Id = :UserInfo.getUserId()];
            contactId = user.contactId;
            populateAddressList();
                
            showMailingAddress = true;
            showPublicAddress = true;            
                
                for(MUSW__Permit_Parcel__c ppRecord : [SELECT MUSW__Parcel__c, Mailing__c, Public__c 
                                                        FROM MUSW__Permit_Parcel__c 
                                                        WHERE MUSW__Permit2__c = :licenseOrPermitId]){
                    if(ppRecord.Mailing__c){
                        mailingAddressId = ppRecord.MUSW__Parcel__c;                        
                    }
                    if(ppRecord.Public__c){
                        publicAddressId = ppRecord.MUSW__Parcel__c;
                    }
                    
                }
            
            individualOrBusiness = [SELECT IndividualBusinessType__C
                                   FROM License_Type__mdt
                                   WHERE Permit_Type__c = :permit.Permit_Type__c
                                   AND Object_Name__c = :Label.API_Permit].IndividualBusinessType__C;
            
            IF(individualOrBusiness == 'Business')
                {business_license = true;}
                else
                {business_license = false;}
            
        }else{
                isError = true;
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please pass Id of license/permit as url parameter with name licenseOrPermitId'));
            }
        }catch(QueryException queryEx){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Make sure that you are logged in as a portal User '+queryEx.getMessage()));
        }catch(Exception ex){
            System.debug('in exception >> ');
            System.debug(ex);
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Unexpected error occurred '+ex.getMessage()));
        }        
    }
    
    /***************************************************************************************************
* @Description : Method to populate different address associated with the license/permit
* @Param       : NA
* @Return      : void 
***************************************************************************************************/
    public void populateAddressList(){
        addressList = new List<SelectOption>();
        
        if(individualOrBusiness == 'Business'){
            for(MUSW__Parcel__c address: [SELECT Name FROM MUSW__Parcel__c WHERE Id in (SELECT Parcel__c 
                                                                                        FROM Parcel_Account__c 
                                                                                        WHERE Account__c =:accID)]){
                                                                                            addressList.add(new SelectOption(address.Id,address.Name));
                                                                                        }
        }else{
            for(MUSW__Parcel__c address: [SELECT Name FROM MUSW__Parcel__c WHERE Id in (SELECT MUSW__Parcel__c 
                                                                                        FROM MUSW__Parcel_Contact2__c 
                                                                                        WHERE MUSW__Contact__c =:contactId)]){
                                                                                            addressList.add(new SelectOption(address.Id,address.Name));
                                                                                        }
        }
    }
    
    /***************************************************************************************************
* @Description : Method to update address mapping with new values
* @Param       : NA
* @Return      : PageReference 
***************************************************************************************************/
    public PageReference customSave(){
        isError = false;
        errorMessage = '';
        if(showMailingAddress && mailingAddressId == null){
            isError = true;
            errorMessage = errorMessage + 'Mailing address is mandatory.';
        }
        if(showPublicAddress && publicAddressId==null){
            isError = true;
            errorMessage = errorMessage = ' Public addresses is mandatory.';
        }
        /*if(showPhysicalAddress && physicalAddressId==null){
            isError = true;
            errorMessage = errorMessage + ' Physical addresses is mandatory';
        }*/
        if(isError){
            return null;
        }
        
        try{//Delete existing MUSW__License_Parcel__c records
            
            if(licenseOrPermit == Label.Str_Credential){
                delete [SELECT Id FROM MUSW__License_Parcel__c WHERE MUSW__License2__c = :licenseOrPermitId];			            
                List<MUSW__License_Parcel__c> licenseParcelList = new List<MUSW__License_Parcel__c>();
                licenseParcelList.add(new MUSW__License_Parcel__c(MUSW__License2__c = license.Id, MUSW__Parcel__c = mailingAddressId, Mailing__c = true));
                if(publicAddressId != null){
                    licenseParcelList.add(new MUSW__License_Parcel__c(MUSW__License2__c = license.Id, MUSW__Parcel__c = publicAddressId, Public__c = true));
                }                
                insert licenseParcelList;
                license.MUSW__Parcel__c = mailingAddressId;
                license.Public_Address__c = publicAddressId;
                update license;
                isError = false;
            }else if(licenseOrPermit == Label.Str_Permit){
                
                delete [SELECT Id FROM MUSW__Permit_Parcel__c WHERE MUSW__Permit2__c = :licenseOrPermitId];			            
                
                List<MUSW__Permit_Parcel__c> permitParcelList = new List<MUSW__Permit_Parcel__c>();
                permitParcelList.add(new MUSW__Permit_Parcel__c(MUSW__Permit2__c = permit.Id, MUSW__Parcel__c = mailingAddressId, Mailing__c = true));
                if(publicAddressId != null){
                    permitParcelList.add(new MUSW__Permit_Parcel__c(MUSW__Permit2__c = permit.Id, MUSW__Parcel__c = publicAddressId, Public__c = true));
                }
                
                insert permitParcelList;
                permit.MUSW__Parcel__c = mailingAddressId;
                permit.Public_Address__c = publicAddressId;
                update permit;
                isError = false;
            
            
            }
        }catch(Exception ex){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Unexpected error occurred '+ex.getMessage()));
            isError = true;
            errorMessage = ex.getMessage();
        }
        return null;
    }

    /***************************************************************************************************
* @Description : Method to create contact parcel.
* @Param       : NA
* @Return      : void 
***************************************************************************************************/    
    public void createParcelContact(){
        try{
            String accountId = ApexPages.currentPage().getParameters().get('accountId');
            String contactId = ApexPages.currentPage().getParameters().get('contactId');
            String parcelId = ApexPages.currentPage().getParameters().get('parcelId');
            
            if(contactId != '' && parcelId != ''){
                Boolean existingParcel = false;
                for(SelectOption option : addressList){
                    if(option.getValue() == parcelId){
                        existingParcel = true;
                        break;
                    }
                }
                
                if(existingParcel == false){
                    if(Business_License == true){
                        Parcel_Account__c parcelAccount = new Parcel_Account__c();
                        parcelAccount.Account__c = accID;
                        parcelAccount.Parcel__c = parcelId;
                        
                        insert parcelAccount;
                    }else{
                        MUSW__Parcel_Contact2__c parcelContact = new MUSW__Parcel_Contact2__c();
                        parcelContact.MUSW__Contact__c = contactId;
                        parcelContact.MUSW__Parcel__c = parcelId;
                        
                        insert parcelContact;
                    }
                }
                
                populateAddressList();
            }
        }catch(Exception ex){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Unexpected error occurred '+ex.getMessage()));
        }
    }
}