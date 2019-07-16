@isTest
public class DOL_ePaymentReturnSession_Test {
	@isTest
    public static void test(){
        DOL_ePaymentReturnSession returnSession = new DOL_ePaymentReturnSession();
        returnSession.mapDataFromSessionString('This is for test');
    }
}