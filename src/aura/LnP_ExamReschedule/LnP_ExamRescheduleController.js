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
        var requestId='';
        var action = component.get("c.insertRequestExam");
        action.setParams({            
            "licId": ctarget.getAttribute("data-license"),
            "licenseType": ctarget.getAttribute("data-licenseType"),
            "board":ctarget.getAttribute("data-board"),
            "ServiceRequestType": ctarget.getAttribute("data-requestType"),
            "ExamRecordId" :ctarget.getAttribute("data-recordId"), 
        });
        action.setCallback(this, function(actionResult){
            console.log('get results----');
            var state = actionResult.getState();
            console.log('state---'+state);
            if (state === "SUCCESS"){
                var result = actionResult.getReturnValue();
                console.log('result----'+result);
                requestId = result;
                sessionStorage.setItem("ServiceRequestType", ctarget.getAttribute("data-requestType"));                
                sessionStorage.setItem("board", ctarget.getAttribute("data-board"));
                sessionStorage.setItem("licenseType", ctarget.getAttribute("data-licenseType"));
                //   sessionStorage.setItem("applicationType", component.get("v.applicationMethod"));
                sessionStorage.setItem("requestId", requestId);
                sessionStorage.setItem("recordId", ctarget.getAttribute("data-license"));
                window.location.href = $A.get("$Label.c.Polaris_Portal_Home")+'manage-request';                    
            }
        });
        $A.enqueueAction(action);
       
     
    },
    submitResults : function(component, event, helper){
        var ctarget = event.currentTarget;
        var requestId = '';
        var action = component.get("c.insertRequestExam");
        action.setParams({            
            "licId": ctarget.getAttribute("data-license"),
            "licenseType": ctarget.getAttribute("data-licenseType"),
            "board":ctarget.getAttribute("data-board"),
            "ServiceRequestType": ctarget.getAttribute("data-requestType"),
            "ExamRecordId" :ctarget.getAttribute("data-recordId"), 
        });
        action.setCallback(this, function(actionResult){
            console.log('get results----');
            var state = actionResult.getState();
            console.log('state---'+state);
            if (state === "SUCCESS"){
                var result = actionResult.getReturnValue();
                console.log('result----'+result);
                requestId = result;
                alert('requestId--'+requestId); 
                sessionStorage.setItem("ServiceRequestType", ctarget.getAttribute("data-requestType"));                
                sessionStorage.setItem("board", ctarget.getAttribute("data-board"));
                sessionStorage.setItem("licenseType", ctarget.getAttribute("data-licenseType"));
                sessionStorage.setItem("requestId", requestId);
                sessionStorage.setItem("recordId", ctarget.getAttribute("data-license"));
                window.location.href = $A.get("$Label.c.Polaris_Portal_Home")+'manage-request';                    
            }
        });
        $A.enqueueAction(action);
    

   
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