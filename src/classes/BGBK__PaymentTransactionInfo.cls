/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class PaymentTransactionInfo {
    global Boolean isNonGatewayTransaction {
        get;
        set;
    }
    global Decimal receiptPayableAmount {
        get;
        set;
    }
    global String transactionID {
        get;
        set;
    }
    global Map<String,String> transactionResponse {
        get;
        set;
    }
    global BGBK.PaymentTransactionInfo.TransactionStatusType transactionStatus {
        get;
        set;
    }
    global PaymentTransactionInfo() {

    }
global enum TransactionStatusType {FAIL, PAYMENT_ERROR, SESSION_ERROR, SUCCESS}
}
