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
    setDefaultFields : function(component, event, helper) {
        console.log('setDefaultFields');
        var accountId = component.get("v.recordId");
        var action = component.get("c.getAccountUBI");
        action.setParams({
            'accountId' : accountId
        });
        action.setCallback(this, function(actionResult) { 
            var state = actionResult.getState();
            if(state == 'SUCCESS') {
                var returnValue = actionResult.getReturnValue();
                returnValue = returnValue.replace(/\./g,'-');
                if(!returnValue.includes("-")){
                    console.log('Inside payment');
                    returnValue = returnValue.match(/.{1,3}/g).join('-');
                }
                /*var string1 = returnValue.substring(0,11);
                var string2 = returnValue.substring(11);
                console.log('1st half'+string1+'2nd half'+string2);
                if(string2.includes("-"))
                {
                    string2 = string2.replace(/-/g, '');
                }
                returnValue = string1+string2;*/
                
                component.set('v.ubiNumber', returnValue);
            }
            //var returnValue = actionResult.getReturnValue();           
        });
        $A.enqueueAction(action);
        //component.set("v.ubiNumber" , "");
        
		
	},
    closeQuickAction : function(component, event, helper) {
        var dismissActionPanel = $A.get("e.force:closeQuickAction"); 
		dismissActionPanel.fire(); 
    },
        
})