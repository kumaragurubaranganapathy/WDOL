({
	doInit : function(component, event, helper) {
        console.log('License Id=== '+ JSON.stringify(component.get('v.licenseData')));
        helper.getEducationHistoryData(component, event, helper);
	},
    
    openModelReschedule : function(component, event, helper) {
        console.log(event.getSource().get("v.value"));
        component.set("v.isOpen", true);
    },
    
    closeModel : function(component, event, helper) {
        component.set("v.isOpen", false);
    },
    
    handleSubmit : function(component, event, helper) {
        var fields = event.getParam("fields");
        console.log('fields=== ' + JSON.stringify(fields));
        component.set("v.examfields",fields);
    },
    
    handleSuccess : function(component, event, helper) {
        var payload = event.getParams().response;
        console.log('record Id==' + payload.id);
        component.set('v.requestId', payload.id);
        console.log("Fields after success=== " + JSON.stringify(component.get('v.examfields')));
        var sMsg = 'Record Created Successfully';
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            message: sMsg,
            type : 'success'
        });
        toastEvent.fire();
        component.set("v.isOpen", false);
        helper.submitReviewRecord(component, event, helper);
        
    }
})