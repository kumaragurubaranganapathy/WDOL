@isTest
public class DepositTriggerHandlerTest {

    public static testMethod void depositHandlerTest(){
        
        MUSW__Deposit__c depRec = new MUSW__Deposit__c();
        depRec.Agency_Code__c = '5400';
        depRec.Amount__c = 100;
        depRec.MUSW__Transfered_In_Amount__c = 100;
        insert depRec;
        
        MUSW__Receipt__c rptRec =  new MUSW__Receipt__c();
        rptRec.MUSW__Amount_Tendered__c = 100;
        insert rptRec;
        
        MUSW__Payable_Receipt__c payrec = new MUSW__Payable_Receipt__c();
        payrec.MUSW__Deposit__c = depRec.Id;
        payrec.MUSW__Receipt__c = rptRec.Id;
        payrec.MUSW__Amount__c = 100;
        insert payrec;
        
        test.startTest();
        depRec.Overshort_Amount__c = 1000;
        depRec.MUSW__Transfered_In_Amount__c = 10;
        depRec.Agency_Code__c = '3000';
        update depRec;
        test.stopTest();
        
    }
}