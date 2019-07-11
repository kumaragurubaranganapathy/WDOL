({
    doInit : function(component, event, helper) {
        var picklistArray = component.get("v.picklistList");
        var objectApi;
        var fieldsName;
        var auraAttr;
        for(var i=0; i<picklistArray.length; i++){
            objectApi = picklistArray[i].objectApi;
            fieldsName = picklistArray[i].fieldsName;
            auraAttr = picklistArray[i].auraAttr;
            helper.doInit(component, event, objectApi, fieldsName, auraAttr);
        }
	},
	goToNext : function(component, event, helper) {
		helper.goToNext(component, event, helper);
	},
    backToPrevious : function(component, event, helper) {
		helper.backToPrevious(component, event, helper);
	},
    showOtherFields : function(component, event, helper) {
		helper.showOtherFields(component, event, helper);
	},
    submitComplaint : function(component, event, helper) {
		helper.submitComplaint(component, event, helper);
	},
    cancelComplaint : function(component, event, helper) {
		helper.cancelComplaint(component, event, helper);
	},
    changepattern: function(component, event, helper) {
		helper.changepattern(component, event);
	},
})