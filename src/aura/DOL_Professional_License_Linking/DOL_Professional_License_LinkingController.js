({
    doInit : function(component, event, helper) {
        helper.doInit(component, event, helper);
        helper.getProfessional(component, event, helper);
    },   
    displayProfessionalForm : function(component,event,helper) {
         $A.util.removeClass(component.find("professionalForm"), 'slds-hide');
         $A.util.addClass(component.find("professionalLicenseDetails"), 'slds-hide');	
    },
    showSecurityCode :function(component,event,helper) {
        component.set("v.hasSecurityCode",true);
        component.set("v.doesNotHaveSecurityCode",false);
        var buttonData = document.getElementById("buttonData");
        buttonData.classList.remove("slds-hide"); 
    },
    hideSecurityCode :function(component,event,helper) {
        var buttonData = document.getElementById("buttonData");
        buttonData.classList.remove("slds-hide"); 
    },
    searchLicense : function(component,event,helper) {
        var allValid= false;
        var inputCmp = component.find("securityTokenId");
        var value = inputCmp.get("v.value");
        if(value === '') {
            inputCmp.set('v.validity', {valid:false, badInput :true});
            inputCmp.showHelpMessageIfInvalid();
            return false;
        } else {
            allValid=  true;
        }
        if (allValid) {
            helper.searchLicenseHelper(component,event,helper);
        } else {
            return false;
        }
    },
     searchLicense2 : function(component,event,helper) {
        var allValid= false;
            allValid = component.find('securityToken').reduce(function (validSoFar, inputCmp) {
                inputCmp.showHelpMessageIfInvalid();
                return validSoFar && !inputCmp.get('v.validity').valueMissing;
            }, true);
        if (allValid) {
            helper.searchLicenseHelper(component,event,helper);
        } else {
            return false;
        }
    },
    cancelBusiness : function(component,event,helper) {
        component.set('v.LicenseColumnListData',[]); 
        component.find('securityToken').reduce(function (validSoFar, inputCmp) {
           inputCmp.set('v.value','');
        }, true);
        component.find('securityTokenId').set("v.value",'');
        window.history.back();
    },
    linkLicenseToContact :function(component,event,helper) {
      helper.linkLicenseToContactHelper(component,event,helper);
    },
    redirectRequest : function(component,event,helper){
        helper.redirectRequest(component,event,helper);
    },
    sendEmail : function(component,event,helper){
       var value=event.getSource().get('v.value'); 
       component.set('v.media',value); 
    },
    sendEmailFinal : function(component,event,helper) {
        var value = component.get('v.media');
        if(value == null || value =='') {
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Error!",
                "message": 'Please select a method to receive activation code',
                "type": "Error"
            });
            toastEvent.fire();  
        }
        if(value =='Email') {
            var valueEmail = component.get('v.emailID');
            if(valueEmail == null || valueEmail== '') {
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!",
                    "message": 'No email address found in the records, please contact DOL support',
                    "type": "Error"
                });
                toastEvent.fire(); 
            } else{
                helper.sendEmailHelper(component,event,helper);  
            }
                
        } 
        if(value == 'Mail') {
            var valueEmail = component.get('v.mailID');
            if(valueEmail == null || valueEmail== '') {
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!",
                    "message": 'No mailing address found in the records, please contact DOL support',
                    "type": "Error"
                });
                toastEvent.fire(); 
                window.setTimeout(
                    $A.getCallback(function() {
                        var urlEvent = $A.get("e.force:navigateToURL");
                        urlEvent.setParams({
                            "url": '/'
                        });
                        urlEvent.fire();
                    }), 2000
                  )
            } else{
                helper.sendMailHelper(component,event,helper);  
            }
        }
    },
    goBack:function(){
        window.history.back();
    },
    searchLicenseActivation: function(component,event,helper){
        var LicenseNumber = component.find('licenseNumber').get('v.value');
        var ProgramType = component.find('programToken').get('v.value');
        if(LicenseNumber =='' || ProgramType =='') {
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "",
                "message": 'Program Type and License number are required',
                "type": "Warning"
            });
            toastEvent.fire(); 
        } else {
            helper.searchLicenseHelperForActivation(component,event,helper);
        }
        
    }

})