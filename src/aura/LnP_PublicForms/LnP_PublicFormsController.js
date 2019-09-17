({
	doInit : function(component, event, helper) {
        var v = $A.get("$Label.c.Dol_Login");
        var url=$A.get("$Label.c.Polaris_Portal_Home")
        if(v == 'No') {
         window.location.href = url;
   
        } else {
            helper.setFormQuestions(component, event, helper);
        }
        
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