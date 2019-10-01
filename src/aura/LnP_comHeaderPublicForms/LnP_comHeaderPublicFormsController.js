({
	init: function(component, event, helper) {
	    var headerval = sessionStorage.getItem("header");
        var conRecId= sessionStorage.getItem("contactRecId");
        console.log('headerval'+sessionStorage.getItem("header"));
        console.log('ConatctId'+sessionStorage.getItem("contactRecId"));
        
        component.set("v.headerfromsession", headerval);
        component.set("v.conIdfromsession", conRecId);
        helper.setItemsList(component, event, helper);
        helper.setUserInfo(component, event, helper); 
        //helper.checkURL(component, event); 
        

     },
  
    burgerIconOnClick: function(component, event, helper){
		helper.burgerIconClicked(component, event);
	},
    handleMenuSelect: function(component, event, helper){
        helper.handleMenuSelect(component, event);
    },
    handleLogout: function(component, event, helper){
        helper.handleLogout(component, event);
    },
    
    toggleMenu: function(component, event, helper){
        helper.toggleMenu(component, event);
    },
    toggleimg:function(component, event, helper){
        helper.toggleimg(component, event);
    },
    displayMoreLinks:function(component, event, helper){
         helper.displayMoreLinks(component, event);
    },
     handleMenuSelectlink:function(component, event, helper){
         helper.handleMenuSelectlink(component, event);
    },
    redirectToHome : function(component,event,helper){
        helper.redirectToHome(component,event);
    },
    checkURL : function(component,event,helper){
        helper.checkURL(component,event);
    }
})