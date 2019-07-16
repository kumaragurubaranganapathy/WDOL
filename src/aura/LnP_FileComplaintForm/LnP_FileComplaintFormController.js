({
	doInit : function(component, event, helper) {
        helper.setFormQuestions(component, event, helper);
	},
    previousTab : function(component, event, helper) {
		helper.goToPreviousTab(component, event);
	},
    nextTab : function(component, event, helper) {
		helper.goToNextTab(component, event);
	},
     onchangeControl : function(component, event, helper) {
		helper.fillSubSections(component, event);
	},
	getAddress : function(component, event, helper) {
		helper.getAddress(component, event);
	},    
    selectAddress: function(component, event, helper) {
		helper.selectAddress(component, event);
	}
              
})