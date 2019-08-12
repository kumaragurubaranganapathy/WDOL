({
	fetchData: function (component,event,helper) {
        var accountId = decodeURIComponent(window.location.search.substring(1).split('id=')[1]);
        if(accountId != "" && accountId != undefined){
            component.set("v.accountId", accountId);
            var action = component.get("c.getAllContacts");
            action.setParams({ "accountId" : accountId });
            var rowActions = this.getRowActions.bind(this, component);
            var accountPromise = this.executeAction(component, action);
            accountPromise.then(
                $A.getCallback(function(result){
                    if(result != null || result != ""){
                        component.set('v.data',result);
                        component.set("v.accountName",result[0].MUSW__Account__r.Name);
                        component.set('v.columns', [
                            {label: 'Title', fieldName: 'Title__c', type: 'text'  },
                            {label: 'First Name', fieldName: 'First_Name__c', type: 'text' },
                            {label: 'Last Name', fieldName: 'Last_Name__c', type: 'text' },
                            {label: 'Role', fieldName: 'Role__c', type: 'Picklist'},
                            {label: 'Ownership Percentage', fieldName: 'Ownership_Percentage__c', type: 'text' },
                            { type: 'action', typeAttributes: { rowActions: rowActions } }
                        ]);
                    }
                }),
                $A.getCallback(function(error){
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Error!",
                        "message": error.message,
                        "type": "error"
                    });
                    toastEvent.fire();
                })
             );
        }else {
            var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!",
                    "message": "Error in loading the page.",
                    "type": "error"
                });
                toastEvent.fire();
        	}
    },
    executeAction: function(component, action, callback) {
        return new Promise(function(resolve, reject) {
            action.setCallback(this, function(response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    var retVal=response.getReturnValue();
                    resolve(retVal);
                }
                else if (state === "ERROR") {
                    var errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            reject(Error("Error message: " + errors[0].message));
                        }
                    }
                    else {
                        reject(Error("Unknown error"));
                    }
                }
            });
            $A.enqueueAction(action);
        });
    },
    getRowActions: function (component, row, doneCallback) {
        var actions = [{
            'label': 'Edit',
            'iconName': 'utility:edit',
            'name': 'edit contact'
        }];
        if (row['Associate_Status__c'] == 'Active') {
            actions.push({
                'label': 'Deactivate',
                'iconName': 'utility:block_visitor',
                'name': 'deactivate'
            });
        } else if(row['Associate_Status__c'] == 'Inactive'){
            actions.push({
                'label': 'Activate',
                'iconName': 'utility:adduser',
                'name': 'activate'
            });
        }
        
        if(row['resend_Invitation__c'] == true){
            actions.push({
                'label': 'Re-invite',
                'iconName': 'utility:following',
                'name': 'reinvite'
            });
        }
        // simulate a trip to the server
        setTimeout($A.getCallback(function () {
            doneCallback(actions);
        }), 200);
    },
    changeContactStatus: function (component, event, recordId, name) {
        var contactId = recordId;
        var accountId = component.get("v.accountId");
        var action = component.get("c.updateContactAccountStatus");
        action.setParams({ 
            "Id" : contactId,
            "status" : name,
            "accountId" : accountId,
        });
        action.setCallback(this, function(response){
           	var state = response.getState();
            var toastEvent = $A.get("e.force:showToast");
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                component.set('v.data',result);
                toastEvent.setParams({
                    "title": "Success!",
                    "message": "Your contact is updated sucessfully!",
                    "type": "success"
                });
                toastEvent.fire();
            }else{
                var errors = response.getError();
                if (errors) {
                    var message = "";
                    if (errors[0] && errors[0].message) {
                       message = "Error message: " + errors[0].message;
                    }
                }
                else {
                    message = "Unknown error";
                }
                toastEvent.setParams({
                    "title": "Error!",
                    "message": message,
                    "type": "error"
                });
                toastEvent.fire();
            } 
        });
        $A.enqueueAction(action);
    },
    reinviteContact : function(component, event, recordId) {
        var contactId = recordId;
        var accountId = component.get("v.accountId");
        var action = component.get("c.resendEmailInvitation");
        action.setParams({ 
            "Id" : contactId,
            "accountId" : accountId,
        });
        action.setCallback(this, function(response){
           	var state = response.getState();
            var toastEvent = $A.get("e.force:showToast");
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                component.set('v.data',result);
                toastEvent.setParams({
                    "title": "Success!",
                    "message": "An email has been sent sucessfully!",
                    "type": "success"
                });
                toastEvent.fire();
            }else{
                var errors = response.getError();
                if (errors) {
                    var message = "";
                    if (errors[0] && errors[0].message) {
                       message = "Error message: " + errors[0].message;
                    }
                }
                else {
                    message = "Unknown error";
                }
                toastEvent.setParams({
                    "title": "Error!",
                    "message": message,
                    "type": "error"
                });
                toastEvent.fire();
            } 
        });
        $A.enqueueAction(action);
    },
	handleSuccess : function(component, event, helper) {
        this.fetchData(component, event, helper);
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": "Success!",
            "message": "Contact added to the account!",
            "type": "success"
        });
        toastEvent.fire();
        component.set("v.refreshForm", false);
        component.set("v.isOpen", false);
    },
    handleError : function(component, event, helper) {
        var message = event.getParams().response;
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": "Error!",
            "message": message,
            "type": "error"
        });
        toastEvent.fire(); 
    },
    handleSubmit : function (component, event, helper) {
        var requiredFields = component.find('requiredField');
        if(requiredFields != "" && requiredFields != undefined){
            var validity = requiredFields.every(function(item, index, array){
                if(item.get('v.value') == null || item.get('v.value') == '' || item.get('v.value').trim().length == 0 ){
                    return false;
                } else{
                    return true;
                }
            });
        }
        if(!validity){
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Error!",
                "message": "Please fill the required fields",
                "type": "error"
            });
            toastEvent.fire();
            event.preventDefault();
        }
    },
    handleEditSubmit : function (component, event, helper) {
        var requiredFields = component.find('requiredFieldEdit');
        if(requiredFields != "" && requiredFields != undefined){
            var validity = requiredFields.every(function(item, index, array){
                if(item.get('v.value') == null || item.get('v.value') == '' || item.get('v.value').trim().length == 0 ){
                    return false;
                } else{
                    return true;
                }
            });
        }
        if(!validity){
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Error!",
                "message": "Please fill the required fields",
                "type": "error"
            });
            toastEvent.fire();
            event.preventDefault();
        }
    },
    cancelAdd : function(component, event, helper){
        
    }
})