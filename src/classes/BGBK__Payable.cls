/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class Payable {
    global Decimal amount {
        get;
        set;
    }
    global MUSW__Deposit__c deposit {
        get;
    }
    global MUSW__Fee__c fee {
        get;
    }
    global BGBK__Bill__c invoice {
        get;
    }
    global Payable(BGBK__Bill__c i) {

    }
    global Payable(BGBK__Bill__c i, Decimal amt) {

    }
    global Payable(MUSW__Deposit__c depos, Decimal amt) {

    }
    global Payable(MUSW__Fee__c f, Decimal amt) {

    }
    global override String toString() {
        return null;
    }
}
