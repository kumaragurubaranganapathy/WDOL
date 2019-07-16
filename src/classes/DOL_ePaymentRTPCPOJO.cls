/************************************************************************************************************
** Name             : DOL_ePaymentRTPCPOJO
** Description   	: Input for ePayment RTPC call. 
** Version          : 1.0
**-------------------------------------------------------------------------------------------------------------------------------
** Revision History:
**---------------------------
** [Laltu Banerjee]: Created
*************************************************************************************************************/
public class DOL_ePaymentRTPCPOJO {

	public class Parameter {
		public String ParameterName;
		public String ParameterValue;
	}

	public String ConfirmationId;
	public String UserID;
	public String BillerProductCode;
	public String PaymentMethod;
	public String PaymentChannel;
	public String PaymentAmount;
	public String ConvenienceFee;
	public String PaymentEffectiveDate;
	public String AmountDue;
	public String DueDate;
	public String TransactionMode;
	public List<Parameter> Parameter;
	public String PayerFirstName;
	public String PayerLastName;
	public PaymentAddress PaymentAddress;
	public String PayerPhoneNumber;
	public String PayerEmail;
	public String LastFourAccountNumber;
	public String CardType;
	public String PaymentAuthorization;

	public class PaymentAddress {
		public String StreetAddress1;
		public String StreetAddress2;
		public String City;
		public String State;
		public String Zip;
		public String Country;
	}

	public static DOL_ePaymentRTPCPOJO parse(String json) {
		return (DOL_ePaymentRTPCPOJO) System.JSON.deserialize(json, DOL_ePaymentRTPCPOJO.class);
	}
}