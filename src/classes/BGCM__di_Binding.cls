/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global abstract class di_Binding implements System.Comparable {
    global Schema.SObjectType BindingObject {
        get;
    }
    global Integer BindingSequence {
        get;
    }
    global BGCM.di_Binding.BindingType BindingType {
        get;
    }
    global String BindingTypeAsString {
        get;
    }
    global Object Data {
        get;
    }
    global String DeveloperName {
        get;
    }
    global BGCM.di_InstanceProvider InstanceProvider {
        get;
        set;
    }
    global String NamespacePrefix {
        get;
    }
    global Object To {
        get;
    }
    global di_Binding() {

    }
    global Object getInstance() {
        return null;
    }
    global Object getInstance(Object params) {
        return null;
    }
    global static BGCM.di_Binding newInstance(BGCM.di_Binding.BindingType bindType, String developerName, Schema.SObjectType bindingObject, Integer bindingSequence, Object to, Object bindingData) {
        return null;
    }
    global abstract Object newInstance(Object param0);
global enum BindingType {Apex, Flow, LightningComponent, Module, VisualforceComponent}
global interface Provider {
    Object newInstance(Object param0);
}
global class Resolver {
    global Resolver(List<BGCM.di_Module> modules) {

    }
    global BGCM.di_Binding.Resolver add(BGCM.di_Module module) {
        return null;
    }
    global BGCM.di_Binding.Resolver byName(String developerName) {
        return null;
    }
    global BGCM.di_Binding.Resolver bySObject(Schema.SObjectType bindingObject) {
        return null;
    }
    global List<BGCM.di_Binding> get() {
        return null;
    }
    global BGCM.di_Binding.Resolver replaceBindingWith(Object mockType) {
        return null;
    }
    global BGCM.di_Binding.Resolver set(BGCM.di_Module module) {
        return null;
    }
}
}
