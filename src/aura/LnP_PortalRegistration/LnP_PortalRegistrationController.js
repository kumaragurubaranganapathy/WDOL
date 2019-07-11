({
    clickCreate : function(component, event,helper) {
        helper.validateForm(component, event);
       // helper.clickCreate(component, event);  
  	},
    checkPassword: function(component, event, helper){
        helper.checkPassword(component, event);
        //helper.passwordSameAsName(component, event);
    },
    confirmPassword: function(component, event, helper) {
        helper.confirmPassword(component, event);
    },
    dateValidation: function(component, event, helper) {
        helper.dateValidation(component, event);
    },
    handlePaste: function(component, event, helper) {
        event.preventDefault(); 
    },    
    handleContext: function(component, event, helper) {
        event.preventDefault(); 
    },
	closeModel: function(component, event, helper) {
		helper.closeModel(component, event);
	},
    showPasswordChecker: function(component, event, helper){
        helper.showPasswordChecker(component, event);
    },
    hidePasswordChecker: function(component, event, helper){
        helper.hidePasswordChecker(component, event);
    },
    changepattern: function(component, event, helper){
        helper.changepattern(component, event);
    }
})