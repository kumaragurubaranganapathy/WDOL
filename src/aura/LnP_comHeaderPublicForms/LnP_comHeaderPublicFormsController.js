({
	init: function(component, event, helper) {
        helper.setItemsList(component, event, helper);
        helper.setUserInfo(component, event, helper);           
    },
    burgerIconOnClick: function(component, event, helper){
		helper.burgerIconClicked(component, event);
	},
    handleMenuSelect: function(component, event, helper){
        helper.handleMenuSelect(component, event);
    },
    toggleMenu: function(component, event, helper){
        helper.toggleMenu(component, event);
    }
})