({
	 fetchData: function (cmp,event) {
        var action = cmp.get("c.getAllAccounts");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var data = response.getReturnValue();
                cmp.set('v.data',data);
            }
            // error handling when state is "INCOMPLETE" or "ERROR"
        });
        $A.enqueueAction(action);
    },
    getRowActions: function (component, row, doneCallback) {
        var actions = [];
        if (row.MUSW__Account_Contacts__r !== undefined) {
            actions.push({
                'label': 'Edit',
                'iconName': 'utility:edit',
                'name': 'edit_record'
            });
            actions.push({
                'label': 'Manage Contact',
                'name': 'manage_contact'
            });
        } else {
            actions.push({
                'label': 'No Actions',
                'iconName': 'utility:reject',
                'name': 'No Actions'
            });
            actions.disabled = 'true';
        }    
        setTimeout($A.getCallback(function(){
            doneCallback(actions);
        }), 200);
    },
    saveAccountContact : function(component,accId){
        // alert('inside saveAccount::');
        var action = component.get("c.createAccountContactObject");
        action.setParams({ aId : accId });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
            //    alert('success');
            }
            // error handling when state is "INCOMPLETE" or "ERROR"
        });
        $A.enqueueAction(action);
    },
    
    handleCancel : function(component){
        component.find("accordion").set('v.activeSectionName', ''); 
    }
})