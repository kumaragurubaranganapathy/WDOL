({
    doInit : function(component, event, helper) {
        helper.doInit(component, event, helper);
      
    },
    cancelBusiness : function(component,event,helper) {
        component.set('v.accountColumnListData',[]);
        component.find("securityTokenBusiness").set("v.value",'');
        //document.getElementById("businessDiv").addClass("slds-hide");
       // component.set()
        window.history.back();
    },
    displayBusinessForm : function (component,event,helper) {
        $A.util.removeClass(component.find("businessForm"), 'slds-hide');	 
        $A.util.addClass(component.find("business"), 'slds-hide');	
    },
    searchAccount : function(component,event,helper) {
		var inputCmp = component.find("securityTokenBusiness");
        var value = inputCmp.get("v.value");

        if (value == '') {
            inputCmp.set('v.validity', {valid:false, badInput :true});
            inputCmp.showHelpMessageIfInvalid();
            return false;
        } else {
            inputCmp.set("v.validity", null);
            helper.searchAccountHelper(component,event,helper);
        }
    },
    linkContactToAccount : function(component,event,helper){
        helper.linkContactToAccountHelper(component,event,helper);
    },    
    redirectRequest : function(component,event,helper){
        helper.redirectRequest(component,event,helper);
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
    }
})