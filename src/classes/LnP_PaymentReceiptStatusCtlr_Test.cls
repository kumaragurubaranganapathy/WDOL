@isTest
public class LnP_PaymentReceiptStatusCtlr_Test {
    @isTest
    public static void testMethod1() {
        Test.startTest();
        DateTime todayDateTime = DateTime.now();
        Date todayDate = Date.today();
        String parameter = 'true-true-true-true-true';
        MUSW__Receipt__c receipt1 = new MUSW__Receipt__c(MUSW__Card_Type__c='Amex',MUSW__Payment_Method__c='CreditCard',Remittance_Process_Date_Time__c=todayDateTime,US_Bank_Payment_Status__c='Processed',MUSW__Amount_Tendered__c=10.0);
        insert receipt1;
        MUSW__Receipt__c receipt2 = new MUSW__Receipt__c(MUSW__Card_Type__c='Visa',MUSW__Payment_Method__c='CreditCard',Remittance_Process_Date_Time__c=todayDateTime,US_Bank_Payment_Status__c='Processed',MUSW__Amount_Tendered__c=5.0);
        insert receipt2;
        MUSW__Receipt__c receipt3 = new MUSW__Receipt__c(MUSW__Card_Type__c='MasterCard',MUSW__Payment_Method__c='CreditCard',Remittance_Process_Date_Time__c=todayDateTime,US_Bank_Payment_Status__c='Processed',MUSW__Amount_Tendered__c=7.0);
        insert receipt3;
        MUSW__Receipt__c receipt4 = new MUSW__Receipt__c(MUSW__Card_Type__c='Discover',MUSW__Payment_Method__c='CreditCard',Remittance_Process_Date_Time__c=todayDateTime,US_Bank_Payment_Status__c='Processed',MUSW__Amount_Tendered__c=8.0);
        insert receipt4;
        MUSW__Receipt__c receipt5 = new MUSW__Receipt__c(MUSW__Card_Type__c='',MUSW__Payment_Method__c='ACH',Remittance_Process_Date_Time__c=todayDateTime,US_Bank_Payment_Status__c='Processed',MUSW__Amount_Tendered__c=5.0);
        insert receipt5;
        LnP_PaymentReceiptStatusCtlr.getPaymentTotals(parameter,todayDate);
        LnP_PaymentReceiptStatusCtlr.paymentReceiptRecordsUpdate(parameter,todayDate);
        LnP_PaymentReceiptStatusCtlr.getPmtInitialTotals();
        Test.stopTest();
    }
}