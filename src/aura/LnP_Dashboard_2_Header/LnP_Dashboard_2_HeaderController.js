({
	doInit : function(component, event, helper) {
		helper.getContactId(component, event, helper);
	},
    handleClick : function(component, event, helper){
        var portal_Home_URL = component.get("v.portalURL");
        var licenseSelectionPage_URI = portal_Home_URL+'licenseSelectionPage';
    	window.open(licenseSelectionPage_URI, "_self");
    }
})