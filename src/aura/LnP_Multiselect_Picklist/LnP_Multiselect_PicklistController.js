({
    //To update the count of selected options or display the single selected option
    doInit : function(component, event, helper) {
        console.log(component.get("v.options"));
        helper.doInit(component, event);
    },
    //To open/close the picklist dropdown
	toggleOpen : function(component, event, helper) {
		helper.toggleOpen(component, event);
	},
    //To remove the pill or deselect an option
    handleRemoveOnly : function(component, event, helper) {
		helper.handleRemoveOnly(component, event);
	},
    //To close the picklist on blur of the select input
    closePicklist : function(component, event, helper) {
		helper.closePicklist(component, event);
    },
    closeMenu : function(componente,event,helper){
        helper.closeMenu(component,event);
    }
})