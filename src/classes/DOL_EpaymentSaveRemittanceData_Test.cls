@isTest
public class DOL_EpaymentSaveRemittanceData_Test {
	@isTest
    public static void saveRemittanceDataTest(){
        DOL_EpaymentRemittanceInput input1 = TestUtility.getDOLEpaymentRemittanceInput(null,null,null,null);
        List<DOL_EpaymentRemittanceInput> inputList = new List<DOL_EpaymentRemittanceInput>();
        inputList.add(input1);
        inputList.add(input1);
        
        new DOL_EpaymentSaveRemittanceData().saveRemittanceData(JSON.serialize(inputList));
        new DOL_EpaymentSaveRemittanceData().saveRemittanceData('');
    }
}