/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class DREInterface {
    global DREInterface() {

    }
global interface IFormulaHandler {
    Object evaluate(List<Object> param0);
}
global interface IObject {
    void addError(String param0);
    DRE.DREInterface.IObject cloneThis(Boolean param0);
    Boolean equals(Object param0);
    List<DRE.DREInterface.IObject> getChildren(String param0);
    Object getFieldValue(String param0);
    Object getFieldValueOld(String param0);
    Id getId();
    DRE.DREInterface.IObject getParent(String param0);
    String getSObjectType_Str();
    Integer hashCode();
    Boolean isDirty();
    void setFieldValue(String param0, Object param1);
}
global interface IResultActionHandler {
    DRE.DREResultActionOutput execute(DRE.DREResultContext param0);
}
global interface IResultActionProcessorHandler {
    void saveChanges(List<Object> param0);
}
}
