@isTest
public class Dol_ImageTokenResponse_Test {

    public static String mockResponse = DOL_AppConstants.NULL_EMPTY_STRING + '{"ImageToken":null,"Message":"System Error","Request":{"Token":{"ErrorCode":null,"ErrorMessage":null,"ImageLink":null,"ImageName":"","ImageTokenDate":null,"ImageTokenID":null,"ProfessionCode":"27016","SourceIP":"67.188.30.169","UserName":"nswain@deloitte.com","ValidToken":false}},"HasErrors":true,"Errors":[{"ErrorMessage":"Index and length ","MemberNames":[]}]}';
     private static testmethod void test_ImageTokenResponse() {
        Dol_ImageTokenResponse res = Dol_ImageTokenResponse.parse(mockResponse);
    }
    
}