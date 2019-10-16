({
    addAccountContact: function (component, event) {
        var action = component.get("c.createAccountContactObject");
        action.setParams({ "aId": component.get("v.accountId") });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var alertArray =[];
                alertArray.push("The record has been added successfully");
                var status = response.getReturnValue()
                var toastEvent = $A.get("e.force:showToast");
                component.set("v.loadingSpinner",false);
                if (status) {
                    // component.set('v.alertHeader','Success Status');
                    //component.set('v.alertText',alertArray);
                    //component.set('v.alertType','success');
                    //component.set('v.alertClose',true);
                    //component.set('v.redirectUrl','/business');
                    //component.set('v.refresh','businessRefresh');
                    toastEvent.setParams({
                        "type": "Success",
                        "title": "Success!",
                        "message": "The record has been added successfully."
                    }); 
                    if(component.get("v.alertClose")){
                        var compEvent = component.getEvent("businessRefresh");
                        compEvent.setParams({ "refreshFlag": "true" });
                        compEvent.fire();                    
                        /* var str ='/business';
                        var urlEvent = $A.get("e.force:navigateToURL");
                        urlEvent.setParams({
                            "url": str
                        });
                        urlEvent.fire(); */
                    } 
                } else {
                    toastEvent.setParams({
                        "type": "Error",
                        "title": "Error!",
                        "message": "Something went wrong"
                    });
                    component.set("v.buttonDisable",false);
                }
                toastEvent.fire();
                
                console.log(" setting check for lsp");
                
                var board =  sessionStorage.getItem("board");
                console.log("board-----kt",board);
                var licenseType = sessionStorage.getItem("licenseType");
                console.log("licenseType----kt",licenseType);
                var applicationMethod = sessionStorage.getItem("applicationMethod");
                console.log("applicationMethod--------",applicationMethod);
                var selectedAccountId = sessionStorage.getItem("selectedAccountId");
                console.log("selectedAccountId------",selectedAccountId);
                
                var str;
                sessionStorage.setItem("fromAddbusiness", true);
                sessionStorage.setItem("businessAccountId", component.get("v.accountId"));
                
                var accId = component.get("v.accountId");
                
                if(selectedAccountId == null || selectedAccountId == ''){
                    var str ='/business';
                    var urlEvent = $A.get("e.force:navigateToURL");
                    urlEvent.setParams({
                        "url": str
                    });
                    urlEvent.fire(); 
                }else{
                    /*if(!component.get("v.isCourseAcc")){
                        str = '/licenseSelectionPage?biz-lic&accId='+accId ;
                    }       */             
                    var action_2 = component.get("c.checkIfCourseAccount");
                    action_2.setParams({ 
                        "accntId": component.get("v.accountId") 
                    });
                    action_2.setCallback(this, function (response) {
                        var state = response.getState();
                        if (state === "SUCCESS") {
                            status = response.getReturnValue();
                            component.set("v.isCourseAcc",status);
                            str = status?'/licenseSelectionPage?course-lic&accId='+accId:str = '/licenseSelectionPage?biz-lic&accId='+accId ; ;
                            var urlEvent = $A.get("e.force:navigateToURL");
                            urlEvent.setParams({
                                "url": str
                            });
                            urlEvent.fire(); 
                            //console.log("isCourseAcc ---",isCourseAccRec);
                        }
                    });
                    
                    console.log("isCourseAcc ---",component.get("v.isCourseAcc"));
                    
                    
                    /*if(component.get("v.isCourseAcc")){
                        str = '/licenseSelectionPage?course-lic&accId='+accId ;
                    }else{
                        str = '/licenseSelectionPage?biz-lic&accId='+accId ;
                    } */
                    
                    $A.enqueueAction(action_2); 
                    
                    
                }
                
                
            } else if (state === "ERROR") {
                component.set("v.loadingSpinner",false);
                component.set("v.buttonDisable",false);
            }
        });
        
        $A.enqueueAction(action);
        
        component.set("v.isOpen", false);
    },
    handleSuccess : function(component,event,helper){
        var accntId = event.getParams().response.id;
        component.set("v.accountId",accntId);
        helper.addAccountContact(component,event,helper);
    },
    handleError : function(component,event,helper){
        component.set("v.loadingSpinner",false);
        var errors = event.getParam('detail');
        var errorMessage = "";
        if (errors) {
            if(errors.includes('DUPLICATES_DETECTED')){
                errorMessage = "Please use a unique UBI Number as Account with this number already exists.";
            }else{
                errorMessage = "Something went wrong. Please contact system admin.";
            }
        } else {
            errorMessage = "Something went wrong. Please contact system admin.";
        }
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "type": "Error",
            "title": "Error!",
            "message": errorMessage
        });
        toastEvent.fire();
        component.set("v.buttonDisable",false);
    },
    handleClick : function(component,event){
        var str ='/new-business';
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url": str
        });
        urlEvent.fire();        
        component.set("v.isOpen",true);
    },
    returnBusiness : function(component,event){
        var str ='/business';
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url": str
        });
        urlEvent.fire(); 
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
    setDefaultFields : function(component, event, helper) {
        console.log('setDefaultFields');
        component.set("v.ubiValueEntered" , "");        		
	}
})