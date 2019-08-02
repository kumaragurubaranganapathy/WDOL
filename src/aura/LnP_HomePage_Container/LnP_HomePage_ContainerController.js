({
	doInit : function(component, event, helper) {
        helper.doInit(component,event);
	helper.checkIsCommunityUser(component,event);
		
	}
})