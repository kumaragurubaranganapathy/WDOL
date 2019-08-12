({
    cancelBusiness : function(component,event,helper) {
        component.set('v.accountColumnListData',[]);
        component.find("securityTokenBusiness").set("v.value",'');
        //document.getElementById("businessDiv").addClass("slds-hide");
       // component.set()
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
})