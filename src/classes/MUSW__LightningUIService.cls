/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class LightningUIService {
    global LightningUIService() {

    }
    global MUSW.LightningUIService.UILayout getCreateUILayout(String objectType, String recordTypeId) {
        return null;
    }
    global MUSW.LightningUIService.UILayout getEditOrViewUILayout(String recordId, String objectType, Boolean isEdit) {
        return null;
    }
    global static MUSW.LightningUIService getInstance() {
        return null;
    }
    global List<MUSW.LightningUIService.UIRelatedList> getLayoutRelatedList(String objectType, String recordTypeId) {
        return null;
    }
    global List<String> getPickListValuesForRecordType(String recordTypeId, String objectType, String fieldType) {
        return null;
    }
global class UIFieldInfo {
    global String apiName {
        get;
        set;
    }
    global Boolean compound {
        get;
        set;
    }
    global String compoundComponentName {
        get;
        set;
    }
    global String compoundFieldName {
        get;
        set;
    }
    global List<MUSW.LightningUIService.UIFieldInfo> compoundFields {
        get;
        set;
    }
    global String dataType {
        get;
        set;
    }
    global String inlineHelpText {
        get;
        set;
    }
    global Boolean isReadOnly {
        get;
        set;
    }
    global String label {
        get;
        set;
    }
    global Integer length {
        get;
        set;
    }
    global Integer precision {
        get;
        set;
    }
    global Boolean reference {
        get;
        set;
    }
    global String referenceTo {
        get;
    }
    global Boolean required {
        get;
        set;
    }
    global Integer scale {
        get;
        set;
    }
    global UIFieldInfo() {

    }
}
global class UILayout {
    global String layoutType {
        get;
        set;
    }
    global String mode {
        get;
        set;
    }
    global List<MUSW.LightningUIService.UILayoutSection> sections {
        get;
        set;
    }
    global UILayout() {

    }
}
global class UILayoutSection {
    global List<MUSW.LightningUIService.UIFieldInfo> fields {
        get;
        set;
    }
    global String heading {
        get;
        set;
    }
    global UILayoutSection() {

    }
}
global class UIRelatedList {
    global Boolean accessLevelRequiredForCreate {
        get;
        set;
    }
    global Boolean custom {
        get;
        set;
    }
    global String field {
        get;
        set;
    }
    global String label {
        get;
        set;
    }
    global String name {
        get;
        set;
    }
    global String sobjectName {
        get;
        set;
    }
    global UIRelatedList() {

    }
}
}
