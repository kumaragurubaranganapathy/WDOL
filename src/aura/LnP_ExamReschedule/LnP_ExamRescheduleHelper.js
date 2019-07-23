({
    getEducationHistoryData : function(component, event, helper) {
        var action = component.get("c.getEducationHistoryData");
        var license_Id = component.get("v.licenseData");
        action.setParams({'licenseId': license_Id[0].Id });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var examRescheduleData = JSON.stringify(response.getReturnValue());
                console.log('examRescheduleData=' + examRescheduleData);
                component.set('v.examRescheduleData', response.getReturnValue());
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                console.error(JSON.stringify(errors));
            }
        });
        $A.enqueueAction(action);
    },
    
    submitReviewRecord : function(component, event, helper) {
        var action = component.get("c.createReviewRecord");
        action.setParams({'licenseRecord': component.get("v.licenseData"),
                          'requestId': component.get("v.requestId")});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var requestRecordDetails = response.getReturnValue();
                console.log('requestRecordDetails=' + requestRecordDetails);
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                console.error(JSON.stringify(errors));
            }
        });
        $A.enqueueAction(action);
        
    }
})