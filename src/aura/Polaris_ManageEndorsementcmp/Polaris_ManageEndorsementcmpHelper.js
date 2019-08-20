({
    fetchDataFromServer : function(component, event, helper) {        
        var manageEndorsement = sessionStorage.getItem("ServiceRequestType");//endorsement
        var recordID = sessionStorage.getItem("licId"); //Licence Id
        var board =sessionStorage.getItem("board"); //application type
        var licenseType =sessionStorage.getItem("licenseType"); // license type
        var applicationMethod =sessionStorage.getItem("applicationMethod"); //application method
        component.set("v.recordId",recordID);
        component.set("v.licenseType",licenseType);
        component.set("v.manageEndorsement",manageEndorsement);                      
        component.set("v.board",board);                      
        component.set("v.applicationMethod",applicationMethod);
        var action = component.get("c.fetchData");
        action.setParams({
            "licId": component.get("v.recordId")             
        });
        action.setCallback(this, function(actionResult){
            var state = actionResult.getState();
            if (state === "SUCCESS"){
                var result = actionResult.getReturnValue();
                var resultWrapper = JSON.parse(result);
                component.set("v.licenseWrapper",resultWrapper);                
                
                var sectionList = [];
                for (var index = 0; index < resultWrapper.length; index++){
                    var obj = new Object();
                    obj.header = resultWrapper[index].sectionName;
                    obj.icon = resultWrapper[index].icon;
                    obj.subheader = resultWrapper[index].subheader;
                    sectionList.push(obj);
                }
                component.set("v.section",sectionList);
                console.log("resultWrapper", JSON.stringify(component.get("v.licenseWrapper")));
                
                
            }else{
                window.location.href = "./error";
            }
        });
        $A.enqueueAction(action);
    },
    fetchAssociationHelper : function(component, event, helper) {        
        
        var action = component.get("c.fetchAssociations");
        action.setParams({
            "licId": component.get("v.recordId")             
        });
        action.setCallback(this, function(actionResult){
            var state = actionResult.getState();
            if (state === "SUCCESS"){
                var result = actionResult.getReturnValue();
                if(result > 0)
                {
                    component.set("v.disableRemove",false);
                }
                
            }else{
                window.location.href = "./error";
            }
        });
        $A.enqueueAction(action);
    },
    removeHelper : function(component, event, helper,endorsementID) {
        component.set("v.loadingSpinner",true);
        var action = component.get("c.removeEndorsement");
        
        action.setParams({            
            "endoId": endorsementID,
        });
        action.setCallback(this, function(actionResult){
            var state = actionResult.getState();
            if (state === "SUCCESS"){
                helper.fetchEndorsement(component, event, helper);
            }
        });
        $A.enqueueAction(action);
    },
    fetchEndorsement : function(component, event, helper) {
        var action = component.get("c.insertEndorsement");
        action.setParams({            
            "licId": component.get("v.recordId"),
            "licenseType": component.get("v.licenseType")
        });
        action.setCallback(this, function(actionResult){
            var state = actionResult.getState();
            if (state === "SUCCESS"){
                var result = actionResult.getReturnValue();
                console.log(result);
                component.set("v.endorsementList",result);
                 component.set("v.loadingSpinner",false);
                
            }
        });
        $A.enqueueAction(action);
    },
    viewProviderHelper: function(component, event, helper,endoId) {
        component.set("v.showProvider",false);
        var action = component.get("c.fetchProvider");
        action.setParams({            
            "endoId": endoId,
        });
        action.setCallback(this, function(actionResult){
            var state = actionResult.getState();
            if (state === "SUCCESS"){
                var result = actionResult.getReturnValue();
                if(result.length>0)
                {
                    component.set("v.showProvider",true);
                    component.set("v.providerList",result);
                }
                    
               // helper.fetchEndorsement(component, event, helper);
            }
        });
        $A.enqueueAction(action);    
    },
    deleteProviderHelper : function(component, event, helper) {
         var action = component.get("c.removeProvider");
        
        action.setParams({            
            "providerId": event.getSource().get("v.value"),
        });
        action.setCallback(this, function(actionResult){
            var state = actionResult.getState();
            if (state === "SUCCESS"){
                helper.viewProviderHelper(component, event, helper,component.get("v.endorsementID"));
                component.set("v.showProvider",false);
            }
        });
        $A.enqueueAction(action);
    },
    addEndorsemet : function(component, event, helper) {  
        component.set("v.loadingSpinner",true);
        var requestId='';
        var action = component.get("c.insertRequest");
        action.setParams({            
            "licId": component.get("v.recordId"),
            "licenseType": component.get("v.licenseType"),
            "board":component.get("v.board")            
        });
        action.setCallback(this, function(actionResult){
            
            var state = actionResult.getState();
            if (state === "SUCCESS"){
                var result = actionResult.getReturnValue();
                requestId = result;
                sessionStorage.setItem("ServiceRequestType", component.get("v.manageEndorsement"));                
                sessionStorage.setItem("board", component.get("v.board"));
                sessionStorage.setItem("licenseType", component.get("v.licenseType"));
                sessionStorage.setItem("applicationType", component.get("v.applicationMethod"));
                sessionStorage.setItem("requestId", requestId);
                window.location.href = $A.get("$Label.c.Polaris_Portal_Home")+'manage-request';
                component.set("v.loadingSpinner",false);
            }
        });
        $A.enqueueAction(action);
        console.log('component.get("v.requestId")',component.get("v.requestId"));
        
    },
    submitHelper : function(component, event, helper) {
        //alert("licId :"+ licID+"  licenseType :"+ licenseType);
        
        var action = component.get("c.updateEndorsement");
        action.setParams({
            "dataString" : JSON.stringify(component.get("v.licenseWrapper")),
            "licId": component.get("v.recordId"),
            "licenseType": component.get("v.licenseType")
        });
        action.setCallback(this, function(actionResult){
            var state = actionResult.getState();
            if (state === "SUCCESS"){
                component.set("v.popupHeader", "Successfully Submitted");
                component.set("v.popupBody", "Thank you for submission of Endorsement.");
                component.set("v.serverStatus", "success"); 
                component.set("v.isOpen", true);
            }else{
                console.log("Submit Error->"+error);
                //handle error as well
            }
        });
        $A.enqueueAction(action);
    },
    closeModel: function(component, event) {
        component.set("v.isOpen", false);        
        if(component.get("v.serverStatus") == "success"){
            window.setTimeout(
                $A.getCallback(function() {
                    window.location.href= $A.get("$Label.c.Polaris_Portal_Dashboard");        
                }), 10);
        }
    },
     addProviderHelper: function(component, event, helper) {
        var parcedValue = event.getParam("value").split(',');
        var endorsementID = parcedValue[0]; 
        component.set("v.endorsementID",endorsementID);
        
        component.set("v.isModalOpen",true);
    }
    
})