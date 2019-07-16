/****************************************************************************************************************************************
** Class Name       : CredentialParcel_CC 
** Description      : This class serves as backend controller for CredentialParcel component 
**                    (User Story: 78 - Associate addresses to a Credential Type)
** Version          : 1.0
** Built By         : Srikanth Kottam
**----------------------------------------------------------------------------------------------------------------------------------------
** Modification Log:
**----------------------------------------------------------------------------------------------------------------------------------------
** Developer                        Date            Reference               Description
** 
**----------------------------------------------------------------------------------------------------------------------------------------
** Review Log:
**---------------
** Reviewer                  Date           Version               Description
**-----------------------------------------------------------------------------------------------------------------------------------------
**
*******************************************************************************************************************************************/ 
public with sharing class CredentialParcel_CC
{
    private ApexPages.StandardController con;

    public String mailingAddressId {get; set;}
    public String publicAddressId {get; set;}
    public String physicalAddressId {get; set;}
    public MUSW__License_Parcel__c licenseParcel{get;set;}
  /*  public Newsfeed__c instructions{get;set;} 
    public Boolean showProfileAddress{get;set;}   */
    private Id licId{get;set;}
    public static List<MUSW__License_Parcel__c> ArchivP {get;set;}
    
    /**
    * Method name  : addressOptions
    * Description  : gets the address options, if the license is flagged as a business license, then get parcel 
    *                account junction objects, if the license is not a business license, then get parcel contact
    *                junction objects, creates select options out of them
    * Return Type  : the select options for the addresses
    * Parameter    : None
    **/
    public List<SelectOption> addressOptions
    {
        get
        {   
            try{
                List<MUSW__Parcel__c> aRecs;
                if(addressOptions == null){
                   
                    licId = ((MUSW__License_Parcel__c)con.getRecord()).MUSW__License2__c;
                    MUSW__License2__c license = [SELECT Business_License__c, MUSW__Primary_Licensee__c, MUSW__Applicant__c
                                            FROM MUSW__License2__c
                                            WHERE Id=:licId LIMIT 1];
                    
                    //if license is a business license, get the account parcel objects
                    if(license.Business_License__c){
                        aRecs = [SELECT Name FROM MUSW__Parcel__c 
                                                        WHERE Id in (SELECT Parcel__c FROM Parcel_Account__c 
                                                                        WHERE Account__c=:license.MUSW__Primary_Licensee__c)];
                    }else{
                    //else get the contact parcel objects
                        aRecs = [SELECT Name FROM MUSW__Parcel__c 
                                                        WHERE Id in (SELECT MUSW__Parcel__c FROM MUSW__Parcel_Contact2__c 
                                                                        WHERE MUSW__Contact__c=:license.MUSW__Applicant__c)];
                    }    
                    system.debug(aRecs);                                       
                    addressOptions = new List<SelectOption>();
                    for(MUSW__Parcel__c addressRecord : aRecs){
                        addressOptions.add(new SelectOption(addressRecord.Id, addressRecord.Name));
                    }
                }
            }catch(DmlException e){
              //  ErrorLogger.logGeneralException(e, UserInfo.getUserId(), 'MUSW__Parcel__c', 'Getting addresseson licenses', 'addressOptions', 'LicenseParcelControllerExt', 'HIGH');
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.error,System.Label.Err_pagestatement));

            }
            return addressOptions;
        }
        private set;
    }

    public CredentialParcel_CC(ApexPages.StandardController controller){
        con = controller;
    }
    
    public CredentialParcel_CC()
    {
     /*   instructions = new FetchInstructions().getInstructionObject('Apply for a license Address', 'BIZC Section Instructions');
        System.debug('The instructions are: ' +instructions);
        showProfileAddress=false;  */
        licenseParcel = new MUSW__License_Parcel__c();
    }

    /**
    * Method name  : saveCredentialAddress
    * Description  : creates license parcel junction objects out of the address user chooses
    * Return Type  : PageReference
    * Parameter    : None
    **/
    public PageReference saveCredentialAddress()
    { 
        try{
            licId = ((MUSW__License_Parcel__c)con.getRecord()).MUSW__License2__c;
            ArchivP = [SELECT Id, Account__c, Mailing__c, MUSW__Parcel__c,
                        Physical__c, Primary__c, Public__c, Type__c,
                        MUSW__License2__c, MUSW__License2__r.MUSW__Applicant__c, MUSW__License2__r.MUSW__Status__c  
                       FROM MUSW__License_Parcel__c WHERE MUSW__License2__c = :licId limit 100];
            if (Schema.sObjectType.MUSW__License_Parcel__c.isDeletable()) {
                delete [SELECT Id FROM MUSW__License_Parcel__c WHERE MUSW__License2__c = :licId];
            }
            insert new List<MUSW__License_Parcel__c>
            {
                new MUSW__License_Parcel__c(MUSW__License2__c = licId, MUSW__Parcel__c = mailingAddressId, Mailing__c = true),
                new MUSW__License_Parcel__c(MUSW__License2__c = licId, MUSW__Parcel__c = publicAddressId, Public__c = true)
            };
            
            if(physicalAddressId != null){
                insert new MUSW__License_Parcel__c(MUSW__License2__c = licId, MUSW__Parcel__c = physicalAddressId, Physical__c = true);
            }
        }catch(DmlException e){
            // ErrorLogger.logGeneralException(e, UserInfo.getUserId(), 'MUSW__License_Parcel__c', 'Inserting license parcels', 'saveLicenseAddress', 'LicenseParcelControllerExt', 'HIGH');
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.error,System.Label.Err_pagestatement));

        } 
        ApexPages.StandardController sc = new ApexPages.StandardController(new MUSW__License2__c(Id = licId, MUSW__Parcel__c = mailingAddressId, Public_Address__c = publicAddressId));
        return sc.save();
    }
}