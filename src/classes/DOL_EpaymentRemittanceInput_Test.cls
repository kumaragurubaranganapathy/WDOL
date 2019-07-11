@IsTest
public class DOL_EpaymentRemittanceInput_Test {
	
	static testMethod void testParse() {
		String json = '['+
		'    {'+
		'        \"recordIndicator\": \"Detail\",'+
		'        \"transactionConfirmationId\": \"WA3DOL000001069\",'+
		'        \"cfTransactionConfirmationID\": \"\",'+
		'        \"recurringRefId\": \"\",'+
		'        \"billerPayorId\": \"\",'+
		'        \"billerProductCode\": \"Licensing\",'+
		'        \"amountDue\": \"250\",'+
		'        \"dueDate\": \"\",'+
		'        \"paymentAmount\": \"250\",'+
		'        \"convenienceFee\": \"\",'+
		'        \"totalAmount\": \"250\",'+
		'        \"paymentEffectiveDate\": \"20190510\",'+
		'        \"billerBusinessDate\": \"\",'+
		'        \"initiationDate\": \"20190509\",'+
		'        \"initiationTime\": \"110536\",'+
		'        \"paymentMethod\": \"ACH\",'+
		'        \"cardType\": \"\",'+
		'        \"avsCode\": \"\",'+
		'        \"cvdCode\": \"\",'+
		'        \"rankRTN\": \"75000022\",'+
		'        \"bankName\": \"US BANK NA\",'+
		'        \"secCode\": \"WEB\",'+
		'        \"lastFourAccountNumber\": \"WEB\",'+
		'        \"paymentAuthorization\": \"4.2E+13\",'+
		'        \"paymentStatus\": \"PROCESSED\",'+
		'        \"achReturnCode\": \"\",'+
		'        \"reasonDescription\": \"\",'+
		'        \"returnDate\": \"\",'+
		'        \"paymentChannel\": \"WEB\",'+
		'        \"adminOrgID\": \"\",'+
		'        \"adminUserID\": \"\",'+
		'        \"userId\": \"\",'+
		'        \"firstName\": \"John\",'+
		'        \"lastName\": \"Smith\",'+
		'        \"companyName\": \"\",'+
		'        \"phone\": \"8561111111\",'+
		'        \"streetAddress1\": \"1234 1st st NE\",'+
		'        \"streetAddress2\": \"\",'+
		'        \"city\": \"Seattle\",'+
		'        \"state\": \"WA\",'+
		'        \"zipPostalCode\": \"85612\",'+
		'        \"zipCode4\": \"\",'+
		'        \"country\": \"US\",'+
		'        \"email\": \"jesnake@hotmail.com\",'+
		'        \"paymentAddress\": {'+
		'            \"streetAddress1\": \"\",'+
		'            \"streetAddress2\": \"\",'+
		'            \"city\": \"\",'+
		'            \"state\": \"\",'+
		'            \"zipPostalCode\": \"\",'+
		'            \"zipCode4\": \"\",'+
		'            \"country\": \"\"'+
		'        },'+
		'        \"sfdcParameter1Name\": \"SFDCId\",'+
		'        \"sfdcParameter1Value\": \"985641\",'+
		'        \"sfdcParameter2Name\": \"SFDCappId\",'+
		'        \"sfdcParameter2Value\": \"55281\",'+
		'        \"sfdcParameter3Name\": \"SFDCfeeId\",'+
		'        \"sfdcParameter3Value\": \"25316\",'+
		'        \"sfdcParameter4Name\": \"SFDClicId\",'+
		'        \"sfdcParameter4Value\": \"117441\",'+
		'        \"filename\": \"Biller Group Abbreviation_Biller Abbreviation_2019_05_27.csv\"'+
		'    },'+
		'    {'+
		'        \"recordIndicator\": \"Detail\",'+
		'        \"transactionConfirmationId\": \"WA3DOL000001070\",'+
		'        \"cfTransactionConfirmationID\": \"\",'+
		'        \"recurringRefId\": \"\",'+
		'        \"billerPayorId\": \"\",'+
		'        \"billerProductCode\": \"Licensing\",'+
		'        \"amountDue\": \"189\",'+
		'        \"dueDate\": \"\",'+
		'        \"paymentAmount\": \"189\",'+
		'        \"convenienceFee\": \"\",'+
		'        \"totalAmount\": \"189\",'+
		'        \"paymentEffectiveDate\": \"20190510\",'+
		'        \"billerBusinessDate\": \"\",'+
		'        \"initiationDate\": \"20190509\",'+
		'        \"initiationTime\": \"110953\",'+
		'        \"paymentMethod\": \"ACH\",'+
		'        \"cardType\": \"\",'+
		'        \"avsCode\": \"\",'+
		'        \"cvdCode\": \"\",'+
		'        \"rankRTN\": \"75000022\",'+
		'        \"bankName\": \"US BANK NA\",'+
		'        \"secCode\": \"WEB\",'+
		'        \"lastFourAccountNumber\": \"WEB\",'+
		'        \"paymentAuthorization\": \"4.2E+13\",'+
		'        \"paymentStatus\": \"PROCESSED\",'+
		'        \"achReturnCode\": \"\",'+
		'        \"reasonDescription\": \"\",'+
		'        \"returnDate\": \"\",'+
		'        \"paymentChannel\": \"WEB\",'+
		'        \"adminOrgID\": \"\",'+
		'        \"adminUserID\": \"\",'+
		'        \"userId\": \"\",'+
		'        \"firstName\": \"Linda\",'+
		'        \"lastName\": \"Johnson\",'+
		'        \"companyName\": \"\",'+
		'        \"phone\": \"8591117451\",'+
		'        \"streetAddress1\": \"56 plymouth ave\",'+
		'        \"streetAddress2\": \"\",'+
		'        \"city\": \"Seattle\",'+
		'        \"state\": \"WA\",'+
		'        \"zipPostalCode\": \"85649\",'+
		'        \"zipCode4\": \"\",'+
		'        \"country\": \"US\",'+
		'        \"email\": \"jessica.lust@usbank.com\",'+
		'        \"paymentAddress\": {'+
		'            \"streetAddress1\": \"\",'+
		'            \"streetAddress2\": \"\",'+
		'            \"city\": \"\",'+
		'            \"state\": \"\",'+
		'            \"zipPostalCode\": \"\",'+
		'            \"zipCode4\": \"\",'+
		'            \"country\": \"\"'+
		'        },'+
		'        \"sfdcParameter1Name\": \"SFDCId\",'+
		'        \"sfdcParameter1Value\": \"999812\",'+
		'        \"sfdcParameter2Name\": \"SFDCappId\",'+
		'        \"sfdcParameter2Value\": \"1111111\",'+
		'        \"sfdcParameter3Name\": \"SFDCfeeId\",'+
		'        \"sfdcParameter3Value\": \"5555\",'+
		'        \"sfdcParameter4Name\": \"SFDClicId\",'+
		'        \"sfdcParameter4Value\": \"117459\",'+
		'        \"filename\": \"Biller Group Abbreviation_Biller Abbreviation_2019_05_27.csv\"'+
		'    }'+
		']';
		List<DOL_EpaymentRemittanceInput> obj = DOL_EpaymentRemittanceInput.parseArray(json);
		System.assert(obj != null);
	}
}