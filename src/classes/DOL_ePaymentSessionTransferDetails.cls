/**
* User Story        : **
* Class Name        : DOL_ePaymentSessionTransferDetails
* Test Class Name   : DOL_ePaymentSessionTransferDetails_Test
* Description       : Class with all required details for session transfer 
* Date:        Developer/Company                    Description
* ---------------------------------------------------------------------------------------------------------------------------------------- *
* 06/21/2019   Laltu Banerjee/Deloitte           Initial Creation
**/
public class DOL_ePaymentSessionTransferDetails {
	
    public String billerGroupId;
    public String billerId;
    public String productCode;
    public String totalDueAmountSelected;
    public String dueDate;
    public String paymentType;
    public String paymentMethod;
    public String disallowLogin;
    public Id relatedContactId;
    
	public String lastName;
    public String firstName;
    public String streetAddress1;
    public String city;
    public String stateRegion;
    public String zipPostalcode;
    public String countryCode;
    public String emailAddress;
    public String phoneNumber;
    
    public String returnValue; 
    public String returnURL;
    public String SFDCId; // setting CartId
    public List<String> SFDCfeeIds;
    public String SFDCappId; // setting contact Id
    public String SFDClicId; // setting receipt Id 
    
    public Boolean isPortalUser;
    
	public DOL_ePaymentSessionTransferDetails(String productCode,String totalDueAmountSelected,
											String paymentMethod,String relatedContactId,String cartId,
											List<String> sfdcFeeIds, Boolean isPortalUser)
	{
		System.debug('input for ePaymentTransferDetails, productCode '+productCode+' totalDueAmountSelected '+totalDueAmountSelected+' paymentMethod '+paymentMethod+' relatedContactId '+relatedContactId+' cartId '+cartId+' sfdcFeeIds '+sfdcFeeIds);
		this.productCode = productCode;
		this.totalDueAmountSelected = totalDueAmountSelected;		
        this.paymentMethod = paymentMethod;
		this.relatedContactId = relatedContactId;
		this.SFDCId = cartId;
		this.SFDCfeeIds = sfdcFeeIds;
		this.SFDCappId = relatedContactId;
        this.isPortalUser = isPortalUser;
	}
    
	public DOL_ePaymentSessionTransferDetails() {}
    
    /**
    ** Name 			: setContactDetails
    ** Input			: NA
    ** Functionality	: Get required contact information by contactId and set the required parameters
    ** Return			: NA
    ** Author			: Laltu Banerjee
    ** Note             : method called from DOL_ePaymentSessionTransfer -> getEncryptedSessionString()
    */
    public void setContactDetails(){
        MUSW__Parcel__c mailingParcel = null;
        Contact relatedContact = new DOL_Dao().getContactDetailsForSessionTransfer(this.relatedContactId);
        if( relatedContact.MUSW__Parcels2__r != null && ! relatedContact.MUSW__Parcels2__r.isEmpty() )
            mailingParcel = relatedContact.MUSW__Parcels2__r.get(0);
        if( relatedContact != null ){
            this.lastName = relatedContact.lastName;
            this.firstName = relatedContact.FirstName;
            this.emailAddress = relatedContact.Email;
            this.phoneNumber = relatedContact.MobilePhone;
            if( mailingParcel != null ){
                this.streetAddress1 = mailingParcel.MUSW__Street2__c;
                this.city = mailingParcel.MUSW__City__c;
                this.stateRegion = mailingParcel.MUSW__State__c;
                this.countryCode = mailingParcel.Country__c;
                this.zipPostalcode = mailingParcel.MUSW__Post_Zip_Code__c;
            }
        }
        if(this.isPortalUser){
            this.returnUrl = DOL_AppConstants.integrationSettingsMetadataMap.get(DOL_AppConstants.ePaymentReturnUrlPortalUser);
        }
        else{
            this.returnUrl = DOL_AppConstants.integrationSettingsMetadataMap.get(DOL_AppConstants.ePaymentReturnUrlNonPortalUser);
        }
    }
    
    /**
    ** Name 			: getSessionDetailsMap
    ** Input			: NA
    ** Functionality	: create a map of parmeter name and value, this will be used for session transfer
                            called from DOL_ePaymentSessionTransfer -> getEncryptedSessionString()
    ** Return			: Map of parameter Name and Value 
    ** Author			: Laltu Banerjee
    ** Note             : This method called from DOL_ePaymentSessionTransfer -> getEncryptedSessionString()
    */
    public Map<String,String> getSessionDetailsMap(){
        Map<String,String> sessionDetailsMap = new Map<String,String>();
        sessionDetailsMap.put('productCode', this.productCode);
        sessionDetailsMap.put('amountDue', this.totalDueAmountSelected);
        sessionDetailsMap.put('paymentType','Single');
        sessionDetailsMap.put('paymentMethod', this.paymentMethod);
        sessionDetailsMap.put('disallowLogin', 'Y');
        if( this.lastName != null)
            sessionDetailsMap.put('lastName', this.lastName);
        if( this.firstName != null)
            sessionDetailsMap.put('firstName', this.firstName);
        if(this.streetAddress1 != null)
            sessionDetailsMap.put('streetAddress1', this.streetAddress1);
        if(this.city != null)
            sessionDetailsMap.put('city',this.city);
        if(this.stateRegion != null)
            sessionDetailsMap.put('stateRegion',this.stateRegion);
        if( this.zipPostalcode != null)
            sessionDetailsMap.put('zipPostalcode', this.zipPostalcode);
        if( this.countryCode != null)
            sessionDetailsMap.put('countryCode', this.countryCode);
        if( this.emailAddress != null)
            sessionDetailsMap.put('emailAddress', this.emailAddress);
        if( this.phoneNumber != null )
            sessionDetailsMap.put('phoneNumber', this.phoneNumber);
        sessionDetailsMap.put('returnURL', this.returnURL);
        sessionDetailsMap.put('SFDCId',this.SFDCId);
        sessionDetailsMap.put('SFDCfeeId',String.join(this.SFDCfeeIds,DOL_AppConstants.ePaymentUrlListValuesSeperator) );
        sessionDetailsMap.put('SFDCappId', ''+this.SFDCappId);
        sessionDetailsMap.put('SFDClicId', ''+this.SFDClicId);
        sessionDetailsMap.put('returnValue',this.returnValue);
        return sessionDetailsMap;
    }

}