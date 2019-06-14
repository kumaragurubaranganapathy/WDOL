/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class CartService implements BGBK.ICart {
    global CartService() {

    }
    global CartService(Id accountId) {

    }
    global CartService(Id pId, Id cId) {

    }
    global Boolean abandonCart() {
        return null;
    }
    global void addDepositsToCart(Set<Id> depositIds) {

    }
    global void addFeesToCart(List<MUSW__Fee__c> feesToAdd) {

    }
    global void addInvoicesToCart(List<BGBK__Bill__c> invoicesToAdd) {

    }
    global Boolean canCreate() {
        return null;
    }
    @Deprecated
    global Boolean closeCart(Decimal lastPaymentAmount, Id payerAccountId, Datetime processingDate) {
        return null;
    }
    global Boolean closeCart(Decimal lastPaymentAmount, Id payerAccountId, Id contactId, Datetime processingDate) {
        return null;
    }
    global List<MUSW__Fee__c> getAccountFees(Boolean outstandingOnly) {
        return null;
    }
    global List<BGBK__Bill__c> getAccountInvoices(Boolean outstandingOnly) {
        return null;
    }
    global List<Account> getAccountList() {
        return null;
    }
    global Account getActiveAccount() {
        return null;
    }
    global BGBK__Cart__c getActiveCart() {
        return null;
    }
    global Contact getActiveContact() {
        return null;
    }
    global BGBK__Cart__c getCart() {
        return null;
    }
    global List<MUSW__Deposit__c> getCartDeposits(Boolean outstandingOnly) {
        return null;
    }
    global List<MUSW__Fee__c> getCartFees(Boolean outstandingOnly) {
        return null;
    }
    global List<BGBK__Bill__c> getCartInvoices(Boolean outstandingOnly) {
        return null;
    }
    global List<MUSW__Receipt__c> getCartReceipts() {
        return null;
    }
    global String getErrorMessage() {
        return null;
    }
    global void removeFeesFromCart(Set<Id> feeIds) {

    }
    global void removeInvoicesFromCart(Set<Id> invoiceIds) {

    }
    global Boolean sendConfirmEmail(List<Id> feeIds, Contact con, BGBK.CartService.AttachmentFormat format, String emailTemplateName, List<String> ccEmailAddresses) {
        return null;
    }
    global Boolean sendConfirmEmail(List<Id> feeIds, Contact con, BGBK.CartService.AttachmentFormat format, String emailTemplateName, List<String> ccEmailAddresses, System.PageReference cartPrintPage) {
        return null;
    }
    global void setUserContext(Id userId, Boolean isPortalUser) {

    }
global enum AttachmentFormat {DOC, PDF}
}
