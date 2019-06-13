/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class TransactionManager {
    global TransactionManager() {

    }
    global static void clearCache() {

    }
    global static void correctFeesCustom(Map<MUSW__Fee__c,Map<BGBK__Fund2__c,Double>> fees, Map<String,String> customFieldMap) {

    }
    global static void correctFees(Map<MUSW__Fee__c,Map<BGBK__Fund2__c,Double>> fees) {

    }
    global static BGBK__Transaction__c correctGeneric(Map<SObject,Map<BGBK__Fund2__c,List<Decimal>>> sobjAmts, Map<SObject,Map<BGBK__Fund2__c,List<Decimal>>> sobjAmtsRev, String transType, Id transAcc, Date effectiveDate) {
        return null;
    }
    @Deprecated
    global static List<BGBK__Transaction__c> correctGeneric(Map<SObject,Map<BGBK__Fund2__c,List<Decimal>>> sobjAmts, String transType, Date effectiveDate, Map<String,String> customItemFieldMap, Map<String,String> customTransFieldMap) {
        return null;
    }
    global static void correctPaymentsCustom(Map<BGBK__Payment__c,BGBK__Fund2__c> pmts, Map<String,String> customFieldMap) {

    }
    global static void correctPaymentsCustom(Map<BGBK__Payment__c,Map<BGBK__Fund2__c,Decimal>> pmts, Map<String,String> customFieldMap) {

    }
    global static void correctPayments(Map<BGBK__Payment__c,BGBK__Fund2__c> pmts) {

    }
    global static void correctPayments(Map<BGBK__Payment__c,Map<BGBK__Fund2__c,Decimal>> pmts) {

    }
    global static void correctReceipts(Map<MUSW__Receipt__c,BGBK__Fund2__c> rcts) {

    }
    global static void correctRefunds(Map<BGBK__Refund__c,BGBK__Fund2__c> refs) {

    }
    global static void deleteFeesCustom(List<MUSW__Fee__c> fees, Map<String,String> customFieldMap) {

    }
    global static void deleteFees(List<MUSW__Fee__c> fees) {

    }
    global static void deletePaymentsCustom(List<BGBK__Payment__c> pmts, Map<String,String> customFieldMap) {

    }
    global static void deletePayments(List<BGBK__Payment__c> pmts) {

    }
    global static void deleteReceipts(List<MUSW__Receipt__c> rs) {

    }
    global static void deleteRefunds(List<BGBK__Refund__c> refs) {

    }
    global static List<BGBK__Transaction__c> postFees2(Map<MUSW__Fee__c,Map<BGBK__Fund2__c,List<Decimal>>> feesAmts) {
        return null;
    }
    global static List<BGBK__Transaction__c> postFeesCustom2(Map<MUSW__Fee__c,Map<BGBK__Fund2__c,List<Decimal>>> feesAmts, Map<String,String> customFieldMap) {
        return null;
    }
    global static void postFeesCustom(Map<MUSW__Fee__c,Map<BGBK__Fund2__c,Double>> fees, Map<String,String> customFieldMap) {

    }
    global static void postFees(Map<MUSW__Fee__c,Map<BGBK__Fund2__c,Double>> fees) {

    }
    global static BGBK__Transaction__c postGeneric(Map<SObject,Map<BGBK__Fund2__c,List<Decimal>>> sobjAmts, String transType, Id transAcc, Date effectiveDate) {
        return null;
    }
    @Deprecated
    global static List<BGBK__Transaction__c> postGeneric(Map<SObject,Map<BGBK__Fund2__c,List<Decimal>>> sobjAmts, String transType, Date effectiveDate, Map<String,String> customItemFieldMap, Map<String,String> customTransFieldMap) {
        return null;
    }
    global static void postPaymentsCustom(Map<BGBK__Payment__c,BGBK__Fund2__c> pmts, Map<String,String> customFieldMap) {

    }
    global static void postPaymentsCustom(Map<BGBK__Payment__c,Map<BGBK__Fund2__c,Decimal>> pmts, Map<String,String> customFieldMap) {

    }
    global static void postPayments(Map<BGBK__Payment__c,BGBK__Fund2__c> pmts) {

    }
    global static void postPayments(Map<BGBK__Payment__c,Map<BGBK__Fund2__c,Decimal>> pmts) {

    }
    global static List<BGBK__Transaction__c> postReceipts2(Map<MUSW__Receipt__c,Map<BGBK__Fund2__c,List<Decimal>>> rcts) {
        return null;
    }
    global static List<BGBK__Transaction__c> postReceiptsCustom2(Map<MUSW__Receipt__c,Map<BGBK__Fund2__c,List<Decimal>>> rcts, Map<String,String> customFieldMap) {
        return null;
    }
    global static void postReceipts(Map<MUSW__Receipt__c,BGBK__Fund2__c> rcts) {

    }
    global static List<BGBK__Transaction__c> postRefunds2(Map<BGBK__Refund__c,Map<BGBK__Fund2__c,List<Decimal>>> refs) {
        return null;
    }
    global static void postRefunds(Map<BGBK__Refund__c,BGBK__Fund2__c> refs) {

    }
    global static List<BGBK__Transaction__c> withdrawTransactions2(List<BGBK__Transaction__c> ts) {
        return null;
    }
    global static void withdrawTransactions(List<BGBK__Transaction__c> ts) {

    }
}
