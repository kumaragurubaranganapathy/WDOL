({
    showToast : function(component, event, title, type, message) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": title,
            "message": message,
            "type":type
        });
        toastEvent.fire();
    },
    refreshRecords : function(component, event, helper) {
        $A.get('e.force:refreshView').fire();
    },
    closeQuickAction : function(component, event, helper) {
        var dismissActionPanel = $A.get("e.force:closeQuickAction"); 
		dismissActionPanel.fire(); 
    },
   
    getRecordName: function(component, helper){
        console.log('get started');
        var action = component.get("c.getRecordName");
        var recordId  = component.get("v.recordId");
        action.setParams({
            'recordId': recordId 
        });
        
        action.setCallback(this, function(response){   
            var state = response.getState();
            if (state === "SUCCESS") {              
                var recordName = response.getReturnValue();
                console.log('recordName==='+recordName)
                if(recordName != null) {
                    component.set("v.recordName", recordName);                      
                }
            }
            
        });
        $A.enqueueAction(action); 
    }
    
})