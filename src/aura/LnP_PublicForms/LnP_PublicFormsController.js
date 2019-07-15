({
	doInit : function(component, event, helper) {
        helper.setFormQuestions(component, event, helper);
	},
   	
    loginReq: function(component, event, helper) {
        console.log('In Login');
		helper.loginUser(component, event, helper);
	}, 
    search:function(component, event, helper) {
        console.log('In search');
		helper.search(component, event, helper);
	},
    clearfields:function(component, event, helper) {
        console.log('In reset');
		helper.search(component, event, helper);
	}
    
})