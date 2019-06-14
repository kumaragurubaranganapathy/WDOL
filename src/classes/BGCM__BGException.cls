/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class BGException extends Exception {
    global static Integer DRE_ACTIVITY;
    global static Integer DRE_ERROR;
    global static Integer DRE_INVALID_BATCH_LETTER;
    global static Integer DRE_INVALID_FIELD;
    global static Integer DRE_INVALID_FILTER;
    global static Integer DRE_INVALID_RESULT;
    global static Integer DRE_INVALID_RULE;
    global static Integer EMAIL_LIMIT;
    global Integer errorCode {
        get;
    }
    global Boolean isCritical {
        get;
    }
    global static Integer LETTERS_PACKAGE;
    global BGException(String msg, Boolean isCritical) {

    }
    global BGException(String msg, Boolean isCritical, Integer errorCode) {

    }
    global Integer getErrorCode() {
        return null;
    }
}
