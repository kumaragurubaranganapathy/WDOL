({
    doInit : function(component, event, helper) {
        var picklistArray = component.get("v.picklistList");
        var objectApi;
        var fieldsName;
        var auraAttr;
        for(var i=0; i<picklistArray.length; i += 1){
            objectApi = picklistArray[i].objectApi;
            fieldsName = picklistArray[i].fieldsName;
            auraAttr = picklistArray[i].auraAttr;
            helper.doInit(component, event, objectApi, fieldsName, auraAttr);
        }
	},
	goToNext : function(component, event, helper) {
		helper.goToNext(component, event);
	},
    backToPrevious : function(component, event, helper) {
		helper.backToPrevious(component, event);
	},
    showOtherFields : function(component, event, helper) {
		helper.showOtherFields(component, event);
	},
    submitComplaint : function(component, event, helper) {
		helper.submitComplaint(component, event);
	},
    cancelComplaint : function(component, event, helper) {
		helper.cancelComplaint(component, event);
	},
    changepattern: function(component, event, helper) {
		helper.changepattern(component, event);
	},
    redirectToHome: function(component, event, helper) {
		helper.redirectToHome(component, event);
	},
    printAcknowledgement: function(component, event, helper) {
		helper.printAcknowledgement(component, event);
	},
    hideProfCounty: function(component, event, helper){
        var selectedValue = event.getSource().get('v.value');
        if(selectedValue == "Washington" || selectedValue =="WA"){
            component.set("v.showProfCounty", true);
        }else{
            component.set("v.showProfCounty", false);
        }
    },
    hideBusinessCounty: function(component, event, helper){
        var selectedValue = event.getSource().get('v.value');
        if(selectedValue == "Washington" || selectedValue =="WA"){
            component.set("v.showBusinessCounty", true);
        }else{
            component.set("v.showBusinessCounty", false);
        }
    }
})