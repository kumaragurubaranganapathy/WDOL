({
	doInit : function(component, event, helper) {
        helper.setFormQuestions(component, event, helper);
	},
   	
    loginReq: function(component, event, helper) {
        console.log('In Login');
		helper.loginUser(component, event, helper);
	},            
})