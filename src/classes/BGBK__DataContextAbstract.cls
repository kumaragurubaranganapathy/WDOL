/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global abstract class DataContextAbstract {
    global DataContextAbstract() {

    }
    global virtual String getActionType() {
        return null;
    }
    global abstract List<SObject> getChild(String param0);
    @Deprecated
    global List<String> getCurrentRecordNames() {
        return null;
    }
    global SObject getParent() {
        return null;
    }
    global String getParentApi() {
        return null;
    }
    global String getParentField(String field) {
        return null;
    }
    global virtual String getParentFieldApiForChild(String childName) {
        return null;
    }
    global String getRecordApi() {
        return null;
    }
    global List<SObject> getRecord(String apiName) {
        return null;
    }
}
