/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class Logger {
    global Logger(String codeName, Id userId) {

    }
    global ApexPages.Message addExceptionAndCommit(Exception e) {
        return null;
    }
    global void addLog(String msg) {

    }
    global void addLog(String msg, MUSW.Logger.Severity severity) {

    }
    global void addLog(String msg, MUSW.Logger.Type type) {

    }
    global void addLog(String msg, String methodName) {

    }
    global void addLog(String msg, MUSW.Logger.Type type, MUSW.Logger.Severity severity) {

    }
    global void addLog(String msg, MUSW.Logger.Type type, MUSW.Logger.Severity severity, Id recordId) {

    }
    global void addLog(String msg, MUSW.Logger.Type type, MUSW.Logger.Severity severity, String methodName) {

    }
    global void addLog(String msg, MUSW.Logger.Type type, MUSW.Logger.Severity severity, String methodName, Id recordId) {

    }
    webService static void clearDRELogs() {

    }
    global void commitLogs() {

    }
    global static void removeLogs(Boolean onlyDreLogs, Boolean onlyCurrentUserLogs, Integer historicMonths) {

    }
global enum Severity {ERROR, INFO}
global enum Type {DML, EMAIL, GENERAL, SOQL, SOSL, WEBSERVICES}
}
