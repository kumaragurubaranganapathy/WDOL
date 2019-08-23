({
    getContactId : function(component, event, helper) {
        var action = component.get("c.getContact");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var contact = response.getReturnValue();
                component.set("v.ContactObj",contact);
                // component.set("v.ParcelObj",contact.MUSW__Parcels2__r);
                var parcelObj = component.get("v.ParcelObj");
                console.log('header getContactId :: '+JSON.stringify(parcelObj));
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.error("Error message: " + errors[0].message);
                    }
                } else {
                    console.error("Unknown error");
                }
            }
        });
        $A.enqueueAction(action);
        var actionLinks = component.find("action-item");
        console.log(actionLinks+" = actionLinks");
    },
    getAddressDetails : function(component, event, helper) {
        var action = component.get("c.getAddressDetails");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var contact = response.getReturnValue();
                //component.set("v.ContactObj",contact);
                component.set("v.ParcelObj",contact);
                var parcelObj = component.get("v.ParcelObj");
                console.log('header getContactId :: '+JSON.stringify(parcelObj));
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.error("Error message: " + errors[0].message);
                    }
                } else {
                    console.error("Unknown error");
                }
            }
        });
        $A.enqueueAction(action);
    },
    updateContactInfo: function(component, event, helper) {
        var conId = component.get("v.ContactObj.Id") ;
        
        //alert('ConId : ' +conId);
        var key = 'contact' ;
        //$A.get($Lable.c.Polaris_Portal_Self_Service);
        //  
        window.location.href = $A.get("$Label.c.Polaris_Portal_Self_Service")+'?par1='+conId+'&par2='+key;
        //window.location.href = "https://dev-polaris.cs32.force.com/lightningwashington/s/self-service?par1="+conId+"&par2=contact";
    },
    showAddress : function(component,event){
        var flag = component.get("v.showAddress");
        component.set("v.showAddress",!flag);
    },
    handleMenuSelectlink: function(component, event) {
        var selectedMenuItemValue = event.getParam("value");
        window.open(selectedMenuItemValue,"_self"); 
        
    },
    showMore : function(component,event){
        component.set("v.showMoreAMR",!component.get("v.showMoreAMR"));
    },
    updateLegalNameHelper : function(component,event){
        var requestId='';
        var ServiceRequestType = 'Update Legal Name';
        
        var action = component.get("c.insertRequest");
        action.setParams({
            "ServiceRequestType": ServiceRequestType,           
        });
        action.setCallback(this, function(actionResult){
            
            var state = actionResult.getState();
            if (state === "SUCCESS"){
                var result = actionResult.getReturnValue();
                requestId = result;
                sessionStorage.setItem("ServiceRequestType", ServiceRequestType);                
                sessionStorage.setItem("board", ServiceRequestType);
                sessionStorage.setItem("licenseType", ServiceRequestType);
                sessionStorage.setItem("applicationType", ServiceRequestType);
                sessionStorage.setItem("requestId", requestId);
                //sessionStorage.setItem("recordId", component.get("v.recordId"));
                window.location.href = $A.get("$Label.c.Polaris_Portal_Home")+'manage-request';                    
            }
        });
        $A.enqueueAction(action);
        console.log('componet.get("v.requestId")',componet.get("v.requestId"));
    },
    goToCart : function(component,event){
        /*var action = component.get("c.checkActiveCart");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var checkResult = response.getReturnValue();
                if(checkResult){
                    var str ='/cart';
                    var urlEvent = $A.get("e.force:navigateToURL");
                    urlEvent.setParams({
                        "url": str
                    });
                    urlEvent.fire(); 
                }else{
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Error!",
                        "message": "You do not have an active cart currently",
                        "type": "error"
                    });
                    toastEvent.fire();
                }
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.error("Error message: " + errors[0].message);
                    }
                } else {
                    console.error("Unknown error");
                }
            }
        });
        $A.enqueueAction(action); */
        var str ='/cart';
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url": str
        });
        urlEvent.fire(); 
        
        
    },
    checkForCart : function(component,event,helper){
        var action = component.get("c.checkActiveCart");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var checkResult = response.getReturnValue();
                if(checkResult){
                    component.set("v.activeCart",true);
                }
                else component.set("v.activeCart",false);
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.error("Error message: " + errors[0].message);
                    }
                } else {
                    console.error("Unknown error");
                }
            }
        });
        $A.enqueueAction(action);
    },
    updateAddress: function(component, event, helper) {
        var conId = component.get("v.ContactObj.Id") ;
        var key = 'mailingaddress' ;
        // var whatodo =''
        window.location.href = $A.get("$Label.c.Polaris_Portal_Self_Service")+'?par1='+conId+'&par2='+key;
        //window.location.href = "https://dev-polaris.cs32.force.com/lightningwashington/s/self-service?par1="+conId+"&par2=address";
    }
})