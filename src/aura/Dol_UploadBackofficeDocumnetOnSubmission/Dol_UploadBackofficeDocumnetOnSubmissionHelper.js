({
	loadUser : function(component, event, helper) {
		var action = component.get("c.getUser");
       action.setCallback(this, function(response){
        	if(response.getState() === "SUCCESS") {
                var result = response.getReturnValue();
                if(result!= null && result.Name!= null){
                    component.set("v.userName" ,result.Name ); 
                    
                }            
        	}           
      });
    $A.enqueueAction(action);
	},
    checkProfessionCode : function(component, event, helper) {	
        var recordId = component.get("v.recordId");
		var action = component.get("c.getProfCode");
        action.setParams({
            "recordId" : recordId
            }) ; 
       	action.setCallback(this, function(response){
        	if(response.getState() === "SUCCESS") {
                var result = response.getReturnValue();
                var noProfCode = false;
                
                if(result!= null && result === 'NoProfessionCode'){
                    component.set("v.profCodeValue", 'NoProfessionCode');
                }
                if(result!= null && result === 'ProfessionCodeExists'){
                    component.set("v.profCodeValue", 'ProfessionCodeExists');
                } 
            } if(response.getState() === "ERROR"){
                var error = response.getError();
                console.log('some problem'+error[0].message);}
    
      });
    $A.enqueueAction(action);
	},
    
    showToast : function(component, event, title, type, message) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": title,
            "message": message,
            "type":type
        });
        toastEvent.fire();
    },  
    
    setDefaultFields: function(component) {
        component.set("v.title", "");
        component.set("v.docName", "");
    },
    refreshRecords : function(component, event, helper) {
        $A.get('e.force:refreshView').fire();
    },
    closeQuickAction : function(component, event, helper) {
        var dismissActionPanel = $A.get("e.force:closeQuickAction"); 
		dismissActionPanel.fire(); 
    },
})