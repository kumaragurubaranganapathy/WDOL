@IsTest
public class DOL_ePaymentRTPCPOJO_Test {
	
	static testMethod void testParse() {
		String json = DOL_AppConstants.NULL_EMPTY_STRING + '{'+
		'   \"ConfirmationId\": \"ABCABC000001566\",'+
		'   \"UserID\": \"1234567\",'+
		'   \"BillerProductCode\": \"Payment\",'+
		'   \"PaymentMethod\": \"ACH\",'+
		'   \"PaymentChannel\": \"WEB\",'+
		'   \"PaymentAmount\": \"133.00\",'+
		'   \"ConvenienceFee\": \"1.00\",'+
		'   \"PaymentEffectiveDate\": \"2012-06-07\",'+
		'   \"AmountDue\": \"133.00\",'+
		'   \"DueDate\": \"2012-06-06\",'+
		'   \"TransactionMode\": \"PAYMENT\",'+
		'   \"Parameter\": ['+
		'      {'+
		'         \"ParameterName\": \"PassedReq\",'+
		'         \"ParameterValue\": \"abc123\"'+
		'      },'+
		'      {'+
		'         \"ParameterName\": \"CollectNum\",'+
		'         \"ParameterValue\": \"123\"'+
		'      }'+
		'   ],'+
		'   \"PayerFirstName\": \"John\",'+
		'   \"PayerLastName\": \"Smith\",'+
		'   \"PaymentAddress\": {'+
		'      \"StreetAddress1\": \"123 Main St.\",'+
		'      \"StreetAddress2\": \"Street Address2\",'+
		'      \"City\": \"Chicago\",'+
		'      \"State\": \"IL\",'+
		'      \"Zip\": \"60103\",'+
		'      \"Country\": \"US\"'+
		'   },'+
		'   \"PayerPhoneNumber\": \"6308554686\",'+
		'   \"PayerEmail\": \"john.smith@usbank.com\",'+
		'   \"LastFourAccountNumber\": \"0001\",'+
		'   \"BillerBusinessDate\": \"2012-06-06\"'+
		'}';
		DOL_ePaymentRTPCPOJO obj = DOL_ePaymentRTPCPOJO.parse(json);
		System.assert(obj != null);
	}
}