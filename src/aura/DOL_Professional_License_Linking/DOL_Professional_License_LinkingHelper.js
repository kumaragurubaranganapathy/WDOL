({
    doInit : function(component, event, helper) {
        var action1 = component.get("c.getLicenseType")
        action1.setCallback(this, function(response){                                
            var state = response.getState();
            if(state == "SUCCESS") {
                var result = response.getReturnValue();
                component.set("v.licenseTypeList",result);    
            }
        });
        $A.enqueueAction(action1);       
    },
 searchLicenseHelper: function(component,event,helper) {
        var columnList =  $A.get("$Label.c.ProfessionalLicenseToDoList").toString().split(',');
        component.set("v.licenseColumnList",columnList);
         var securityCode = '';
         var firstname  = '';
         var licenseNumber  = '';
         var licenseType  = '';
         var dob  = null;
        var lastname  = '';
        var ssn  = '';
        if(component.find("securityTokenId") != undefined) {
            securityCode =component.find("securityTokenId").get('v.value');
        }
        var securityToken = component.find("securityToken");
        if(securityToken != undefined){
            for(var v in securityToken) {
                if(securityToken[v].get('v.name')=='licenseType'){
                    licenseType= securityToken[v].get('v.value');
                } 
                if(securityToken[v].get('v.name')=='license'){
                    licenseNumber= securityToken[v].get('v.value');
                }
                if(securityToken[v].get('v.name')=='FirstName'){
                    firstname= securityToken[v].get('v.value');
                }
                if(securityToken[v].get('v.name')=='lastName'){
                    lastname= securityToken[v].get('v.value');
                }
                if(securityToken[v].get('v.name')=='DOB'){
                    dob = securityToken[v].get('v.value') == '' ? null :securityToken[v].get('v.value');
                }
                if(securityToken[v].get('v.name')=='ssn'){
                    ssn= securityToken[v].get('v.value');
                }                
            }
        }
        var action = component.get("c.getLicenseList");
        action.setParams({
            "securityCode": securityCode, 
            "firstname": firstname,
            "lastname": lastname,
            "licenseNumber":licenseNumber,
            "licenseType":licenseType,
            "dob":dob,
            "ssn":ssn
        }); 
        action.setCallback(this, function(response){
            var state = response.getState();
            console.log("inside state::"+ state);
            if (state === "SUCCESS"){
                var result = response.getReturnValue();
                if(result != ''){
                    component.set("v.LicenseColumnListData",result);
                    $A.util.removeClass(component.find("professionalLicenseDetails"), 'slds-hide');	
                } else {
                    
                    $A.util.addClass(component.find("professionalLicenseDetails"), 'slds-hide');	
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Success!",
                        "message": "No License Found!!",
                        "type": "Success"
                    });
                    toastEvent.fire();
                    
                }
            }else{
                console.log("error");
            }
            
        });
        $A.enqueueAction(action); 
      //  ar securityCode = component.find("securityTokenBusiness").get("v.value");
        
    },
    linkLicenseToContactHelper: function(component,event,helper) {
        var contactId = '';
        var action = component.get("c.updateLicenseContact");
        var licenseList = component.get("v.LicenseColumnListData");
        
        contactId = licenseList[0].MUSW__Applicant__c;
        document.body.scrollTop = document.documentElement.scrollTop = 0;
        component.set("v.loadingSpinner",true);
        action.setParams({
            "contactId": contactId, 
        }); 
        action.setCallback(this, function(response){
            var state = response.getState();
            console.log("inside state::"+ state);
            if (state === "SUCCESS"){
                var result = response.getReturnValue();
                if(result == 'Linked successfully'){
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Success!",
                        "message": "Successfully linked your license",
                        "type": "Success"
                    });
                    toastEvent.fire();                    
                    component.set("v.loadingSpinner",false);
                    var urlEvent = $A.get("e.force:navigateToURL");
                    urlEvent.setParams({
                        "url": "/to-do"
                    });
                    urlEvent.fire();
                } else {
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Error!",
                        "message": result,
                        "type": "Error"
                    });
                    toastEvent.fire();  
                    component.set("v.loadingSpinner",false);
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
    },
    sendEmailHelper : function(component,event){
      var action = component.get("c.sendActivationCodeEmail");
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS"){
                    var toastEvent = $A.get("e.force:showToast");
                    var message = response.getReturnValue();
                    toastEvent.setParams({
                        "title": "",
                        "message": message,
                        "type": "Success"
                    });
                    toastEvent.fire();                    
                    component.set("v.loadingSpinner",false);
                    var urlEvent = $A.get("e.force:navigateToURL");
                    urlEvent.setParams({
                        "url": "/to-do"
                    });
                    urlEvent.fire();
                } else {
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Error!",
                        "message": result,
                        "type": "Error"
                    });
                    toastEvent.fire();  
                    component.set("v.loadingSpinner",false);
                }
        });
        $A.enqueueAction(action); 
    }
    
})