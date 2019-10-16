@isTest
public class DREFormulaBuilderLocalController_Test {
    
    @isTest
    public static void test01(){
        DREFormulaBuilderLocalController dreFormulaBuild = new DREFormulaBuilderLocalController();
        test.startTest();
        dreFormulaBuild.selectedObject = DOL_AppConstants.LICENSE;
        dreFormulaBuild.getObjects();
        test.stopTest();
        //System.debug('Complete');
    }
    
}