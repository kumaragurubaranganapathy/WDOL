({
	doInit : function(component, event, helper) {
        console.log('License Id=== '+ JSON.stringify(component.get('v.licenseData')));
        helper.getEducationHistoryData(component, event, helper);
	},
    
    openModelReschedule : function(component, event, helper) {
        console.log(event.getSource().get("v.value"));
        console.log('License data==' + component.get("v.licenseData"));
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
    rescheduleExam: function(component,event,helper){
        var ctarget = event.currentTarget;
        console.log('inside draftLicense::');
       
				sessionStorage.setItem("ServiceRequestType", ctarget.getAttribute("data-requestType"));                
                sessionStorage.setItem("board", ctarget.getAttribute("data-board"));
                sessionStorage.setItem("licenseType", ctarget.getAttribute("data-licenseType"));
           //     sessionStorage.setItem("applicationType", );
                sessionStorage.setItem("requestId", ctarget.getAttribute("data-recordId"));
                sessionStorage.setItem("recordId", ctarget.getAttribute("data-license"));
                window.location.href = $A.get("$Label.c.Polaris_Portal_Home")+'manage-request'; 
 

        var appIsRenewal = ctarget.getAttribute("data-reschedule");
     
        if(appIsRenewal == 'true'){
            console.log('inside ce audit request ::');
            sessionStorage.setItem("renewalReinstate", renewreinstate);
            sessionStorage.setItem("flowType", "Application");
            window.location.href='/lightningwashington/s/manage-request';  
        } 
    },
    submitResults : function(component, event, helper){
         var ctarget = event.currentTarget;
        console.log('inside draftLicense::');
       
				sessionStorage.setItem("ServiceRequestType", ctarget.getAttribute("data-requestType"));                
                sessionStorage.setItem("board", ctarget.getAttribute("data-board"));
                sessionStorage.setItem("licenseType", ctarget.getAttribute("data-licenseType"));
           //     sessionStorage.setItem("applicationType", );
                sessionStorage.setItem("requestId", ctarget.getAttribute("data-recordId"));
                sessionStorage.setItem("recordId", ctarget.getAttribute("data-license"));
                window.location.href = $A.get("$Label.c.Polaris_Portal_Home")+'manage-request'; 
 

        var appIsRenewal = ctarget.getAttribute("data-status");
     /*
        if(appIsRenewal == 'Pass'){
            console.log('inside ce audit request ::');
       //     sessionStorage.setItem("renewalReinstate", renewreinstate);
            sessionStorage.setItem("flowType", "Application");
            window.location.href='/lightningwashington/s/manage-request';  
        } */
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