({
    searchAccountHelper: function(component,event,helper) {
        var securityCode = component.find("securityTokenBusiness").get("v.value");
        var action = component.get("c.getAccountList");
        action.setParams({
            "securityCode": securityCode,
        }); 
        action.setCallback(this, function(response){
            var state = response.getState();
            console.log("inside state::"+ state);
            if (state === "SUCCESS"){
                var result = response.getReturnValue();
                if(result != ''){
                    component.set("v.accountColumnListData",result);
                    $A.util.removeClass(component.find("business"), 'slds-hide');	
                } else {
                    $A.util.addClass(component.find("business"), 'slds-hide');	
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Warning!",
                        "message": "No business found, please try again or contact DOL",
                        "type": "Warning"
                    });
                    toastEvent.fire();
                    
                }
            }else{
                console.log("error");
            }
            
        });
        $A.enqueueAction(action); 
    },
    
    linkContactToAccountHelper: function(component,event,helper) {
        
        var accName = '';
        var accountDetails = component.get("v.accountColumnListData");        
        accName = accountDetails[0].Id;
        var action = component.get("c.createAccountContact");
        
        document.body.scrollTop = document.documentElement.scrollTop = 0;
        component.set("v.loadingSpinner",true);
        action.setParams({
            "accID": accName, 
        }); 
        action.setCallback(this, function(response){
            var state = response.getState();
            console.log("inside state::"+ state);
            if (state === "SUCCESS"){
                var result = response.getReturnValue();
                if(result != ''){
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Success!",
                        "message": result,
                        "type": "Success"
                    });
                    toastEvent.fire();
                    component.set("v.loadingSpinner",false);
                    toastEvent.fire();
                    var urlEvent = $A.get("e.force:navigateToURL");
                    urlEvent.setParams({
                        "url": "/to-do"
                    });
                    urlEvent.fire();
                    //  helper.searchAccountHelper();
                }
            }else{
                console.log("error");
            }
            
        });
        $A.enqueueAction(action); 
        
    },
    redirectRequest : function(component,event){
        component.set("v.linkingScreen",false);
        /*var str ='/business-license-linking';
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url": str
        });
        urlEvent.fire();*/
    }
})