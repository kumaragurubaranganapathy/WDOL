@isTest
public class LnP_ProgramTypeTest {

     @testSetup
    public static void setupMethod(){
        //creating Deposit
        MUSW__Deposit__c deposit = new MUSW__Deposit__c(Name = DOL_AppConstants.NULL_EMPTY_STRING + 'System Number');
        deposit.Amount__c = 100.00;
        deposit.wadol_Program_Type__c = DOL_AppConstants.NULL_EMPTY_STRING + 'Misc Payments';
        insert deposit;
        
        MUSW__Receipt__c receipt = new MUSW__Receipt__c();
        receipt.MUSW__Amount_Tendered__c = 100.00;
        receipt.MUSW__Payment_Method__c = DOL_AppConstants.NULL_EMPTY_STRING + 'Cash';
        insert receipt;
        }
        
    public static void testMethod1(){
        
        list<MUSW__Deposit__c> depLst = [Select Id, Amount__c, wadol_Program_Type__c from MUSW__Deposit__c];
        list<MUSW__Receipt__c> recLst = [Select Id,MUSW__Amount_Tendered__c,MUSW__Payment_Method__c from MUSW__Receipt__c];
       // system.debug('depLst : '+depLst);
        //system.debug('recLst : '+recLst);
        
        Test.startTest();
     //   LnP_ProgramType.getDependency(objDetail, contrfieldApiName, depfieldApiName);
             LnP_ProgramType.getDefaultProgramType();
             LnP_ProgramType.getPayment();
             LnP_ProgramType.getProgramType();
             LnP_ProgramType.getFormNumber();
             LnP_ProgramType.getDepositInfo();
            // LnP_ProgramType.saveReciept(recList);
             LnP_ProgramType.getObjViews();
           LnP_ProgramType.saveReciptRecords(recLst[0]);
            LnP_ProgramType.updateRecieptRec(recLst[0]);
             LnP_ProgramType.saveDeposit_Receipt_Records(depLst[0]);
             LnP_ProgramType.updateDepositRec(depLst[0]);
           //  LnP_ProgramType.updateEnvelopRec(programType, recRecLstArr, depRecLstArr, customerEnvelopeRec, parRecordId);
             LnP_ProgramType.getValidationNumberInfo();
        Test.stopTest();
    }
}