({
    doInit : function(component, event, helper) {
        helper.doInit(component, event, helper);
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
    },
    linkLicenseToContact :function(component,event,helper) {
      helper.linkLicenseToContactHelper(component,event,helper);
    },
    redirectRequest : function(component,event,helper){
        helper.redirectRequest(component,event,helper);
    }
})