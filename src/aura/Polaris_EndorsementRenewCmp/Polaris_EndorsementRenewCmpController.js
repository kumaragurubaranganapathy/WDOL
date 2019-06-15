({
	doInit : function(component, event, helper) {        
        helper.fetchEndorsement(component, event, helper);
    },
    handleValueSelect : function(component, event, helper) {        
        helper.changeStatusHelp(component, event, helper);
    },
})