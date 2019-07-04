/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class DREManager {
    global DREManager() {

    }
    global static void commitResults(DRE.DREOutput result, Boolean commitUpserts, Boolean commitDeletes, Boolean commitCustomResults, Boolean sendEmails) {

    }
    global static void releaseLock() {

    }
    global static DRE.DREOutput runRules(List<SObject> records, List<SObject> oldRecords, String mode, List<DRE__DRE_Rule__c> runRules, Boolean commitResults, Boolean commitLogs, Boolean handleErrors) {
        return null;
    }
    global static DRE.DREOutput runTrigger() {
        return null;
    }
    global static DRE.DREOutput runTrigger(Boolean commitResults) {
        return null;
    }
    global static DRE.DREOutput runTrigger(List<SObject> records, List<SObject> recordsOld, Boolean commitResults) {
        return null;
    }
    global static DRE.DREOutput runView(List<SObject> records) {
        return null;
    }
    global static void setBulkMode() {

    }
    global static void setBulkMode(String objectName) {

    }
    global static void setLock() {

    }
}
