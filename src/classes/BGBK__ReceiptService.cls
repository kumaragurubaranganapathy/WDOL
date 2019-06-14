/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class ReceiptService implements BGBK.ICart {
    global ReceiptService() {

    }
    global ReceiptService(Id rId) {

    }
    global Boolean canCreate() {
        return null;
    }
    global List<MUSW__Receipt__c> getAvailableReceiptsFor(Id conId) {
        return null;
    }
    global Attachment getPrintableReceipt(Id cartId, List<Id> feeIds, Contact con, BGBK.ReceiptService.AttachmentFormat format) {
        return null;
    }
    global Attachment getPrintableReceipt(Id cartId, List<Id> feeIds, Contact con, BGBK.ReceiptService.AttachmentFormat format, System.PageReference cartPrintPage) {
        return null;
    }
    global MUSW__Receipt__c getReceipt(Id receiptId) {
        return null;
    }
    global Boolean sendEmailWithReceipt(Id cartId, List<Id> feeIds, Contact con, List<String> emailAddresses, Boolean isPortalUser, BGBK.ReceiptService.AttachmentFormat format, String emailTemplateName) {
        return null;
    }
    global Boolean sendEmailWithReceipt(Id cartId, List<Id> feeIds, Contact con, List<String> ccEmailAddresses, Boolean isPortalUser, BGBK.ReceiptService.AttachmentFormat format, String emailTemplateName, System.PageReference cartPrintPage) {
        return null;
    }
    global Boolean updateReceiptForPaymentGateway(BGBK.PaymentTransactionInfo transactionInfo, String paymentMethod, Decimal totalAmountPaid) {
        return null;
    }
    @AuraEnabled
    webService static void voidReceipt(List<Id> receiptIds) {

    }
global enum AttachmentFormat {DOC, PDF}
}
