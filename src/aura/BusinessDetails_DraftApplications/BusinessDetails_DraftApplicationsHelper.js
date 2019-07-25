({
    fetchData : function (component,event,helper) {
        var accountIdValue = component.get("v.accountId");
        console.log('acccount id value draftapp ',accountIdValue)
        var action = component.get("c.getAllApplications");
        console.log('get all applications called')
        action.setParams({
            accountId : component.get("v.accountId") 
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            console.log('state---'+state);
            if (state === "SUCCESS") {
                var data = response.getReturnValue();
                console.log('return value ',response.getReturnValue());
                console.log('applications::', JSON.stringify(data));
                component.set('v.applicationList',data);
                var appList = component.get("v.applicationList");
                var draftAppList = [];
                var draftCourseAppList = [];
                var draftRenAppList = [];
                for(var i = 0 ;i<appList.length;i++){
                    console.log('inside for ::'+ appList[i].MUSW__Status__c +' '+ appList[i].isRenewal__c + ' '+ appList[i].Credential_Type__c );
                    if(appList[i].isRenewal__c == false && appList[i].Credential_Type__c != 'Apprasier Course'){
                        console.log('appList::'+ appList[i]);
                        draftAppList.push(appList[i]);
                        console.log(component.get("v.DraftNewLicenseApplications"));
                        component.set("v.draftListNotEmpty",true);
                    }else if(appList[i].isRenewal__c == false && appList[i].Credential_Type__c =='Apprasier Course') {
                        console.log('courseList::'+ appList[i]);
                        draftCourseAppList.push(appList[i]);
                        component.set("v.courseListNotEmpty",true);
                    }else if(appList[i].isRenewal__c == true){
                        console.log('renewalList::'+ appList[i]);
                        draftRenAppList.push(appList[i]);
                        component.set("v.renewalListNotEmpty",true);
                    }    
                    
                }
                component.set("v.DraftNewLicenseApplicationsData", draftAppList);  
                component.set("v.DraftCourseApplicationsData",draftCourseAppList);
                component.set("v.DraftRenewalApplicationsData", draftRenAppList);
                
            }                   
        });
        $A.enqueueAction(action);
    },
    
    fetchActionDetails : function(component,event,helper){
        var action = component.get("c.getMandatoryActions");
        action.setCallback(this, function(response) {
            var state = response.getState();
            console.log('state---'+state);
            if (state === "SUCCESS") {
                var data = response.getReturnValue();
                console.log('renewal applications::', JSON.stringify(data));
                component.set("v.DraftMandatoryActionsApplicationsData",data);
                if(data != null && data != ''){
                    component.set("v.mandatoryListNotEmpty",true); 
                }
                component.set("v.loadingSpinner",false);
                
            }
        });
        $A.enqueueAction(action);
    },
    
    actionRequest : function(component,event,helper){
        console.log("inside actionrequest");
        console.log("actionClicked::"+component.get("v.actionclicked"));
        var action = component.get("c.actionOnTask");
        action.setParams({"type" :  component.get("v.tasktype"),
                          "actionClicked" : component.get("v.actionclicked"),
                          "tsk" : component.get("v.task")
                         });
        var toastEvent = $A.get("e.force:showToast");
        action.setCallback(this, function(response) {
            var state = response.getState();
            console.log('state---'+state);
            if (state === "SUCCESS") {
                var taskCompleted =  response.getReturnValue();
                
                if(taskCompleted){
                    toastEvent.setParams({
                        "type":"Success",
                        "title": "Success!",
                        "message": "The action completed successfully."
                    });
                }else{
                    toastEvent.setParams({
                        "type":"Error",
                        "title": "Error!",
                        "message": "Something went wrong"
                    });
                }
                toastEvent.fire();
                this.fetchActionDetails(component,event,helper);
            }else{
                toastEvent.setParams({
                    "type":"Error",
                    "title": "Error!",
                    "message": "Something went wrong"
                });
                toastEvent.fire();
            }
        });
        $A.enqueueAction(action);
    }, 
    
    getHelptextHelper : function(component, event, obj, license_Status, license_Sub_Status){
        var action = component.get("c.helptextFetch");
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state === "SUCCESS"){
                var result = response.getReturnValue();
                typeof result;
                var resultMap = JSON.parse(result);
                component.set("v.helptextmap", resultMap);
                console.log('helptextmap::'+result);
                console.log('size::'+result.prototype.size);
            }
            else if(state === 'ERROR'){                
                var errors = response.getError();
                console.error(JSON.stringify(errors));               
            }
        });
        
        $A.enqueueAction(action);
    }
    
})