({
    doInit : function(component, event, helper) {
        console.log('Entering task doInit');
        var action = component.get("c.getTodoList");
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS"){
                var result = response.getReturnValue();
                console.log('result123'+ JSON.stringify(result));
                if(result == '') {
                    /*var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "No result found!",
                        "message": "No task to display",
                        "type": "SUCCESS"
                    });
                    toastEvent.fire(); */
                } else  {
                    component.set("v.taskList",result);
                }
                
                
                ///console.log('result::'+ JSON.stringify(result));
            }else{
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!",
                    "message": "There is some error in loading the page. Please reload the page.",
                    "type": "error"
                });
                toastEvent.fire();
            }
        });
        var actionName = component.get("c.getContactName");
        actionName.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS"){
                var result = response.getReturnValue();               
                var firstName = result.substr(0,result.indexOf(" "));
                component.set("v.contactName",firstName);
                console.log('result::'+ JSON.stringify(result));
            }else{
                /*var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!",
                    "message": "There is some error in loading the page. Please reload the page.",
                    "type": "error"
                });
                toastEvent.fire(); */
            }
        });
        $A.enqueueAction(action); 
        $A.enqueueAction(actionName); 
    },
    
    showBusinessAccountAlert : function(component, event, helper) {
        var action = component.get("c.hasBusinessAccounts");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var hasBusinessAccounts = response.getReturnValue();
                console.log(hasBusinessAccounts);
                component.set('v.AddBusinessAccountsStatusAlert',!hasBusinessAccounts);
                component.set('v.isLoaded',true);
            }                          
        });
        $A.enqueueAction(action);    
    },
    
    actionRequest : function(component, event, helper,subject) {
        console.log('inside actionRequest');
        var action = component.get("c.updateTask");
        action.setParams({"taskId": component.get("v.taskId"),"subStatus": component.get("v.actionclicked")});
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS"){
                var result = response.getReturnValue();
                console.log('inside result::'+result);
                var toastEvent = $A.get("e.force:showToast");
                if(result=='Success'){
                    toastEvent.setParams({
                        "title": "Success",
                        "message": "Action Completed Successfully",
                        "type": "success"
                    });
                    if(subject === "Invitation to be a Business Admin"){
                        var str ='/business';
                        var urlEvent = $A.get("e.force:navigateToURL");
                        urlEvent.setParams({
                            "url": str
                        });
                        urlEvent.fire();
                    }
                }else if(result=='Pay Fee')
                {
                    // Set popup property values before displayiong pop up.
                    component.set("v.popupHeader", "License Relationship");
                    component.set("v.popupBody", "Click on Ok to proceed for payment.");
                    component.set("v.serverStatus", "success"); 
                    //component.set("v.storeServerValue", result[0].Id);
                    component.set("v.isOpen", true);
                }
                    else if(result=='Pay Fee Near Expiration')
                    {
                        // Set popup property values before displayiong pop up.
                        component.set("v.popupHeader", "License Relationship");
                        component.set("v.popupBody", "Your license is going to expire in the next 120 days or less.  Are you sure you want to proceed with this payment as this relationship will need to be renewed before expiration date? Click on Ok to proceed for payment.");
                        component.set("v.serverStatus", "success"); 
                        //component.set("v.storeServerValue", result[0].Id);
                        component.set("v.isOpen", true);
                    }
                        else{
                            toastEvent.setParams({
                                "title": "Error",
                                "message": "Action not Completed",
                                "type": "error"
                            });
                        }
                toastEvent.fire();
                this.doInit(component,event,helper);
            }else{
                console.log('inside error');
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!",
                    "message": "Something went wrong",
                    "type": "error"
                });
                toastEvent.fire();
            }
        });
        $A.enqueueAction(action);  
    },
    
    insertRequest : function(component,event,helper){
        console.log("inside insertRequest::");
        
        var action = component.get("c.insertRequest");
        action.setParams({"accountContactId": component.get("v.accountContact"),
                          "licenseType": component.get("v.licenseType"),
                          "board": component.get("v.board"),
                          "ServiceRequestType":component.get("v.ServiceRequestType")
                         })
        action.setCallback(this, function(response){
            var state = response.getState();
            console.log("inside state::"+ state);
            if (state === "SUCCESS"){
                var result = response.getReturnValue();
                console.log('result::'+ JSON.stringify(result));
                sessionStorage.setItem("ServiceRequestType", component.get("v.ServiceRequestType"));                
                sessionStorage.setItem("board", component.get("v.board"));
                sessionStorage.setItem("licenseType", component.get("v.licenseType"));
                sessionStorage.setItem("applicationType","General Application");
                sessionStorage.setItem("requestId", result);
                window.location.href = $A.get("$Label.c.Polaris_Portal_Home")+'manage-request';
            }else{
                console.log("error");
            }
        }); 
        $A.enqueueAction(action);         
    },
    //Close the modal popup and redirect to cart page
    closeModel: function(component, event) {
        component.set("v.isOpen", false);
        var action = component.get("c.fetchChildLicense");
        action.setParams({
            "taskId": component.get("v.taskId"),                          
        })
        action.setCallback(this, function(response){
            var state = response.getState();
            console.log("inside state::"+ state);
            if (state === "SUCCESS"){
                var id = response.getReturnValue();
                console.log('id',id);
                if(component.get("v.serverStatus") == "success"){
                    window.location.href= $A.get("$Label.c.Polaris_Portal_URL")+'cart?id='+id;
                }
            }else{
                console.log("error");
            }
        }); 
        $A.enqueueAction(action);   
    },
    
    proceedRequest: function(component, event, helper){
        
    },
    linkProfLic : function(component,event){
        var str ='/professional-license-linking';
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url": str
        });
        urlEvent.fire();
    },
    linkBizLic : function(component,event){
        var str ='/business-license-linking';
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url": str
        });
        urlEvent.fire();
    },
    redirectLicense : function(component,event){
        var str ='/licenseSelectionPage';
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url": str
        });
        urlEvent.fire();
    },
    redirectBusiness : function(component,event){
        var str ='/new-business';
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url": str
        });
        urlEvent.fire();
    },
    goToProfDashboard : function(component,event){
        var str ='/newdashboard';
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url": str
        });
        urlEvent.fire();
    },
    bizLicApp : function(component,event){
        var str ='/licenseSelectionPage?biz-lic';
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url": str
        });
        urlEvent.fire();
    },
    goToBizDashboard : function(component,event){
        var str ='/business';
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url": str
        });
        urlEvent.fire();
    },
    openTrainingApp : function(component,event){
        var str ='/licenseSelectionPage';
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url": str
        });
        urlEvent.fire();
    },
	
    fetchData : function (component,event,helper) {
        var action = component.get("c.getAllAccounts");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var data = response.getReturnValue();                
                if(data.length!==0){
                    component.set("v.isBusiness",true);
                }                                  
            }                          
        });
        $A.enqueueAction(action);
    }
    
})