public class DOL_EpaymentRemittanceInput {

	public String recordIndicator;
	public String transactionConfirmationId;
	public String cfTransactionConfirmationID;
	public String recurringRefId;
	public String billerPayorId;
	public String billerProductCode;
	public String amountDue;
	public String dueDate;
	public String paymentAmount;
	public String convenienceFee;
	public String totalAmount;
	public String paymentEffectiveDate;
	public String billerBusinessDate;
	public String initiationDate;
	public String initiationTime;
	public String paymentMethod;
	public String cardType;
	public String avsCode;
	public String cvdCode;
	public String rankRTN;
	public String bankName;
	public String secCode;
	public String lastFourAccountNumber;
	public String paymentAuthorization;
	public String paymentStatus;
	public String achReturnCode;
	public String reasonDescription;
	public String returnDate;
	public String paymentChannel;
	public String adminOrgID;
	public String adminUserID;
	public String userId;
	public String firstName;
	public String lastName;
	public String companyName;
	public String phone;
	public String streetAddress1;
	public String streetAddress2;
	public String city;
	public String state;
	public String zipPostalCode;
	public String zipCode4;
	public String country;
	public String email;
	public PaymentAddress paymentAddress;
	public String sfdcParameter1Name;
	public String sfdcParameter1Value;
	public String sfdcParameter2Name;
	public String sfdcParameter2Value;
	public String sfdcParameter3Name;
	public String sfdcParameter3Value;
	public String sfdcParameter4Name;
	public String sfdcParameter4Value;
	public String filename;

	public class PaymentAddress {
		public String streetAddress1;
		public String streetAddress2;
		public String city;
		public String state;
		public String zipPostalCode;
		public String zipCode4;
		public String country;
	}

    public static DOL_EpaymentRemittanceInput parse(String json) {
		return (DOL_EpaymentRemittanceInput) System.JSON.deserialize(json, DOL_EpaymentRemittanceInput.class);
	}
	
	public static List<DOL_EpaymentRemittanceInput> parseArray(String json) {
		return (List<DOL_EpaymentRemittanceInput>) System.JSON.deserialize(json, List<DOL_EpaymentRemittanceInput>.class);
	}
}