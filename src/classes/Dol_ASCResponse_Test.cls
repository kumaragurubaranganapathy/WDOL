@isTest
public class Dol_ASCResponse_Test {

    public static String mockSOSserviceResponse = DOL_AppConstants.NULL_EMPTY_STRING + '{"result":{"uid":"DELOITTE"}}';
     private static testmethod void test_SOSservice() {
        Dol_ASCResponse res = Dol_ASCResponse.parse(mockSOSserviceResponse);
    }
    
}