/************************************************************************************************************
** Name             : DOL_DOR_Input
** Description   	: Input for DOR transaction from DOL system to Salesforce via Mulesoft.
** Version          : 1.0
** Story			: US-2298
**-------------------------------------
** Revision History:
**---------------------------
** [Laltu Banerjee]: Created
*************************************************************************************************************/

public class DOL_DOR_Input {
    
    	public String polarisID;
		public String dorLicenseFullUBI;
		public String dorLicenseUBI;
		public String dorLicenseBusID;
		public String dorLicenseLocID;
		public String dorLicenseStatus;
		public String dorLicenseCode;
		public String dorLicenseFirstIssuanceDate;
		public String dorLicenseExpirationDate;
		public String dorLicenseNumber;
		public String dorBusinessType;
		public String dorEntityName;
		public String dorBusinessName;
		public String dorOwnerFirstName;
		public String dorOwnerMiddleName;
		public String dorOwnerLastName;
		public String dorLocMailAddr1;
		public String dorLocMailAddr2;
		public String dorLocMailCity;
		public String dorLocMailState;
		public String dorLocMailZip;
		public String dorLocPhysicalAddr1;
		public String dorLocPhysicalAddr2;
		public String dorLocPhysicalCity;
		public String dorLocPhysicalState;
		public String dorLocPhysicalZip;
		public String dorLocOpenDate;
		public String dorGovPerFirstName;
		public String dorGovPerMiddleName;
		public String dorGovPerLastName;
		public String dorTradeName;
		public String dolProfCode;
		public String fileName;
    
    public static DOL_DOR_Input parse(String json) {
		return (DOL_DOR_Input) System.JSON.deserialize(json, DOL_DOR_Input.class);
	}

	public static List<DOL_DOR_Input> parseArray(String json) {
		return (List<DOL_DOR_Input>) System.JSON.deserialize(json, List<DOL_DOR_Input>.class);
	}

}