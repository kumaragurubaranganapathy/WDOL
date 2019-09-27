({
	doInit : function(component, event, helper) {
        helper.doInit(component,event);
        helper.checkIsCommunityUser(component,event);
		
	},
    handlePortalArticle:function(component, event, helper) {
       var displayVar=event.getParam("displayPage");
       component.set("v.displayotherprofessionspage",displayVar);
   }
})