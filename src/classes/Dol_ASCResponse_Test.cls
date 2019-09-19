@isTest
public class Dol_ASCResponse_Test {

    public static String mockSOSserviceResponse = '{"result":{"uid":"DELOITTE"}}';
     private static testmethod void test_SOSservice() {
        Dol_ASCResponse res = Dol_ASCResponse.parse(mockSOSserviceResponse);
    }
    
}