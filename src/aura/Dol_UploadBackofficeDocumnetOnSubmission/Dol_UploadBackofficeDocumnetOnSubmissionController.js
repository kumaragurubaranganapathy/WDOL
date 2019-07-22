({
	doInit : function(component, event, helper) {
		helper.loadUser(component, event, helper);
        helper.checkProfessionCode(component, event, helper);
	},
    
    uplaod: function(component, event, helper){
        var recordId = component.get("v.recordId");
        var title = component.get("v.title");
        var docName = component.get("v.docName");
        var userName = component.get("v.userName");
        var valid = true;
        
        if(title == null || title ==""){
            valid = false;
        }
        if(docName == null || docName ==""){
            valid = false;
        }
        if(!valid){
             helper.showToast(component, event, "Error!", "error", "Please fill in all required fields.");
        }
        else{
            var profCode = component.get("v.profCodeValue");
            
            if(profCode === 'NoProfessionCode'){
                helper.showToast(component, event, "Error!", "error", "Professional code associated to the Submission License is NULL");
                helper.setDefaultFields(component);
            }
            else if(profCode === 'ProfessionCodeExists'){
            var action = component.get("c.backofficeUplaod");
       		 action.setParams({
            "recordId" : 'recordId',
            "docName": 'docName',
            "user": 'userName',
            }) ; 
            component.set("v.Spinner", true);
        	action.setCallback(this, function(response){
                component.set("v.Spinner", false);
                var status = response.getState();
                if(status === 'SUCCESS'){
                    var result = response.getReturnValue();
                    if (result == 'uploadsuccess'){
                        helper.showToast(component, event, "Success!", "success", "Your document is uploaded to SAN drive.");
                        helper.setDefaultFields(component);
                       	helper.refreshRecords();
                    	helper.closeQuickAction(component, event, helper);
                        
                    }
                    if (result == 'uploadfailed'){
                        helper.showToast(component, event, "Error!", "error", "There is some error.");
                        helper.setDefaultFields(component);
                       	helper.refreshRecords();
                    	helper.closeQuickAction(component, event, helper);
                    }
                } if(status === "ERROR"){
                var error = response.getError();
                console.log('some problem'+error[0].message);
                helper.showToast(component, event, "Error!", "error", "There is some error.");
                helper.setDefaultFields(component);
                helper.refreshRecords();
                helper.closeQuickAction(component, event, helper);
                }
        	});
        }
        $A.enqueueAction(action);  
        }       
    },
    handleCancel : function(component, event, helper) {
        $A.get("e.force:closeQuickAction").fire();
    },
})