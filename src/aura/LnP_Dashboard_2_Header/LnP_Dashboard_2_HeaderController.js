({
	doInit : function(component, event, helper) {
		helper.getContactId(component, event, helper);
	},
    handleClick : function(component, event, helper){
        var portal_Home_URL = component.get("v.portalURL");
        var licenseSelectionPage_URI = portal_Home_URL+'licenseSelectionPage';
    	window.open(licenseSelectionPage_URI, "_self");
    },
    updateContactInfo : function(component, event, helper) {
		helper.updateContactInfo(component, event, helper);
	},
    showAddress : function(component, event, helper) {
		helper.showAddress(component, event);
	},
    handleMenuSelectlink :  function(component, event, helper) {
		helper.handleMenuSelectlink(component, event);
	},
    
    /*updateAddress : function(component, event, helper) {
		helper.updateAddress(component, event, helper);
	}*/
})