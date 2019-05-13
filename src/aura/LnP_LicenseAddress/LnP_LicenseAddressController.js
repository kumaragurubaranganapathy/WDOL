({
    doInit : function(component, event, helper) {
        var addDetails=[];
        var action  = component.get('c.getAddressDetailsType');
        action.setCallback(this, function(response) {
            var state = response.getState();
            console.log("state",state);
            //addDetails.push({label: '--None--', value: '--None--'}); 
            if (state === "SUCCESS") {
                for(var i=0;i< response.getReturnValue().length;i++){
                    addDetails.push({label: response.getReturnValue()[i], value: response.getReturnValue()[i]});
                }
                component.set("v.addressDType", addDetails);
                helper.getData(component, event, helper, true);
            }
            console.log('component.get("v.addressDType")',component.get("v.addressDType"));
        });
        $A.enqueueAction(action);
        
        
    },
    getAddress : function(component, event, helper) {
        helper.getAddressHelper(component, event);
    }, 
    selectAddress: function(component, event, helper) {
        helper.selectAddress(component, event);
    },
    getRecord : function(component, event, helper) {
        helper.getRecordHelper(component, event);
    },
    deleteRecord : function(component, event, helper) {
        helper.deleteRecordHelper(component, event);
    },
    saveAddress : function(component, event, helper) {        
        helper.saveAddressHelper(component, event, helper);      
    },
    cancelAddress : function(component, event, helper) {
		helper.cancelAdressHelper(component, event, helper);            
    },
    addAddress: function(component, event, helper) {  
        var elements = document.getElementsByClassName("addAddress");
        for(var i=0; i<elements.length; i++) {
            elements[i].classList.remove('slds-hide');
        }
        document.getElementsByClassName("addressTypeSelection")[0].classList.remove('slds-hide');
    },
    selectExistingAddress: function(component, event, helper) {
        helper.selectExistingAddressHelper(component, event,helper);
    },         
    handleDelete :function(component, event, helper) {        
        helper.deleteRecordHelper(component, event, helper);
    },
    onSelect : function(component, event, helper) {     
        var addressType = event.getSource().get("v.name");
        var addressType1 = event.getSource().get("v.value");
        component.set("v.typeOfAddress",addressType1);   
        var elements = document.getElementsByClassName("addAddress");
        for(var i=0; i<elements.length; i++) {
            elements[i].classList.remove('slds-hide');
        }
    }          
    
})