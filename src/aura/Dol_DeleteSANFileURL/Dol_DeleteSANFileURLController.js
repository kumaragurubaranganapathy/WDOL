({
	doInit : function(component, event, helper) {
		component.set("v.isEnableDelete", true);
        helper.getRecordName(component);		
	},
    deleteURL: function(component,event, helper){
        console.log('get started');
        var action = component.get("c.deleteDocumentLink");
        var recordId  = component.get("v.recordId");
        //helper.toggleClassInverse(component,'backdrop','slds-backdrop--');
        //helper.toggleClassInverse(component,'modaldialog','slds-fade-in-');
        action.setParams({
            'recordId': recordId 
        });
        component.set("v.Spinner", true);
        action.setCallback(this, function(response){
            component.set("v.Spinner", false);
            var state = response.getState();
            console.log(state);
            console.log('state=======');
            if (state === "SUCCESS") {  
                var responseValues = response.getReturnValue();
                console.log('responseValues'+responseValues);
                if (responseValues == 'No Image url'){
					component.set("v.isEnableDelete", false);
                    helper.showToast(component, event, "Error!", "error", "No SAN Image URL exists for this record");
            		helper.refreshRecords();
                    helper.closeQuickAction(component, event, helper);
                }else if(responseValues == 'success') {
                    component.set("v.isEnableDelete", false);
                    console.log('Your SAN Image URL is deleted');  
                    //Success               
                	helper.showToast(component, event, "Success!", "success", "Your SAN Image URL has been successfully deleted.");
                    helper.refreshRecords();
                    helper.closeQuickAction(component, event, helper);
                }else if (responseValues == 'fail'){
					component.set("v.isEnableDelete", false);
                    helper.showToast(component, event, "Error!", "error", "something went wrong");
            		helper.refreshRecords();
                    helper.closeQuickAction(component, event, helper);
                }    
            }
            if(state === "ERROR"){
                var error = response.getError();
                console.log('some problem'+error[0].message);
                helper.showToast(component, event, "Error!", "error", "There is some error.");}
            
        });
        $A.enqueueAction(action); 
    },
    handleCancel : function(component, event, helper) {
        $A.get("e.force:closeQuickAction").fire();
    }
})