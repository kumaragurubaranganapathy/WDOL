public class DOL_ePaymentSessionTransferDetails {
	
    public String billerGroupId {get; set;}
    public String billerId {get; set;} 
    public String productCode {get; set;}
    public String totalDueAmountSelected {get; set;}
    public String dueDate {get; set;}
    public String paymentType {get; set;}
    public String paymentMethod {get; set;}
    public String disallowLogin {get; set;}
    public Id relatedContactId {get; set;}
    
	public String lastName {get; set;}
    public String firstName {get; set;}
    public String streetAddress1 {get; set;}
    public String city {get; set;}
    public String stateRegion {get; set;}
    public String zipPostalcode {get; set;}
    public String countryCode {get; set;}
    public String emailAddress {get; set;}
    public String phoneNumber {get; set;}
    
    public String returnValue {get; set;} // setting ReceiptId in returnValue, setting From Cart Controller
    public String returnURL {get; set;}
    public String SFDCId {get; set;} // setting CartId
    public List<String> SFDCfeeIds {get; set;}
    public String SFDCappId {get; set;} // setting applicant Id
    public String SFDClicId {get; set;} // setting receipt Id to get it return back in RTPC call, setting From Cart Controller
    
    public Boolean isPortalUser { get; private set;}
    
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
    public DOL_ePaymentSessionTransferDetails(String productCode,String totalDueAmountSelected, 
                                              String paymentMethod, Id relatedContactId) {
        system.debug('input for ePayment Transfer productCode = '+productCode+' '+totalDueAmountSelected+' '+paymentMethod+' '+relatedContactId);
		this.productCode = productCode;
		this.totalDueAmountSelected = totalDueAmountSelected;
        this.paymentMethod = paymentMethod;
		this.relatedContactId = relatedContactId;
	}

	public DOL_ePaymentSessionTransferDetails() {}

    public void setContactDetails(){
        DOL_Dao dao = new DOL_Dao();
        Contact relatedContact = dao.getContactDetailsForSessionTransfer(this.relatedContactId);
        if( relatedContact != null ){
            this.lastName = relatedContact.lastName;
            this.firstName = relatedContact.FirstName;
            this.streetAddress1 = relatedContact.mailingstreet;
            this.city = relatedContact.mailingcity;
            this.stateRegion = relatedContact.mailingstate;
            this.countryCode = relatedContact.mailingcountry;
            this.emailAddress = relatedContact.Email;
            this.phoneNumber = relatedContact.MobilePhone;
            this.zipPostalcode = relatedContact.MailingPostalCode;
        }
        if(this.isPortalUser){
            this.returnUrl = DOL_AppConstants.integrationSettingsMetadataMap.get(DOL_AppConstants.ePaymentReturnUrlPortalUser);
        }
        else{
            this.returnUrl = DOL_AppConstants.integrationSettingsMetadataMap.get(DOL_AppConstants.ePaymentReturnUrlNonPortalUser);
        }
    }
    
    public Map<String,String> getSessionDetailsMap(){
        Map<String,String> sessionDetailsMap = new Map<String,String>();
        sessionDetailsMap.put('productCode', this.productCode);
        sessionDetailsMap.put('amountDue', this.totalDueAmountSelected);
        //sessionDetailsMap.put('MaximumAmountAllowed', this.getTotalDueAmountSelected());
        //sessionDetailsMap.put('dueDate',DOL_AppUtility.getDate('YYYY-MM-dd'));
        sessionDetailsMap.put('paymentType','Single');
        sessionDetailsMap.put('paymentMethod', this.paymentMethod);
        sessionDetailsMap.put('disallowLogin', 'Y');
        sessionDetailsMap.put('lastName', this.lastName);
        sessionDetailsMap.put('firstName', this.firstName);
        sessionDetailsMap.put('streetAddress1', this.streetAddress1);
        sessionDetailsMap.put('city',this.city);
        sessionDetailsMap.put('stateRegion',this.stateRegion);
        sessionDetailsMap.put('zipPostalcode', this.zipPostalcode);
        sessionDetailsMap.put('countryCode', this.countryCode);
        sessionDetailsMap.put('emailAddress', this.emailAddress);
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