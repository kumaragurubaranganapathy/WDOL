/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class PaymentService implements BGBK.ICart {
    global PaymentService() {

    }
    global Boolean canCreate() {
        return null;
    }
    global Id processDepositPaymentByBatch(Map<BGBK.Payable,List<MUSW__Deposit__c>> payableDeposits, Datetime processingDatetime) {
        return null;
    }
    global Set<Id> processDepositPayment(Map<BGBK.Payable,List<MUSW__Deposit__c>> payableDeposits, Datetime processingDatetime) {
        return null;
    }
    global virtual List<Id> processGatewayPayment2(List<BGBK.Payable> payables, Map<MUSW__Receipt__c,BGBK.PaymentTransactionInfo> receiptTransMap, Id payerAccountId, Datetime processingDatetime) {
        return null;
    }
    global virtual Boolean processGatewayPayment(List<BGBK.Payable> payables, Map<MUSW__Receipt__c,BGBK.PaymentTransactionInfo> receiptTransMap, Id payerAccountId, Datetime processingDatetime) {
        return null;
    }
    global virtual List<Id> processPayment2(List<BGBK.Payable> payables, Map<MUSW__Receipt__c,Decimal> receiptAmounts, Id payerAccountId, Datetime processingDatetime) {
        return null;
    }
    @Deprecated
    global virtual Boolean processPaymentBatch(List<BGBK.Payable> payables, Map<MUSW__Receipt__c,Decimal> receiptAmounts, Id payerAccountId, Datetime processingDatetime) {
        return null;
    }
    global virtual Id processPaymentByBatch(List<BGBK.Payable> payables, Map<MUSW__Receipt__c,Decimal> receiptAmounts, Id payerAccountId, Datetime processingDatetime) {
        return null;
    }
    global virtual Boolean processPayment(List<BGBK.Payable> payables, Map<MUSW__Receipt__c,Decimal> receiptAmounts, Id payerAccountId, Datetime processingDatetime) {
        return null;
    }
}
