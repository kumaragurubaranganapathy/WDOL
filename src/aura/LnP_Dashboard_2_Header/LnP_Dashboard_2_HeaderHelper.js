({
    getContactId : function(component, event, helper) {
        var action = component.get("c.getContact");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var contact = response.getReturnValue();
                component.set("v.ContactObj",contact);
                component.set("v.ParcelObj",contact.MUSW__Parcels2__r);
                var parcelObj = component.get("v.ParcelObj");
                console.log('header getContactId :: '+JSON.stringify(parcelObj));
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.error("Error message: " + errors[0].message);
                    }
                } else {
                    console.error("Unknown error");
                }
            }
        });
        $A.enqueueAction(action);
        var actionLinks = component.find("action-item");
        console.log(actionLinks+" = actionLinks");
    },
    updateContactInfo: function(component, event, helper) {
        var conId = component.get("v.ContactObj.Id") ;
        //alert('ConId : ' +conId);
        var key = 'contact' ;
        //$A.get($Lable.c.Polaris_Portal_Self_Service);
        //  
        window.location.href = $A.get("$Label.c.Polaris_Portal_Self_Service")+'?par1='+conId+'&par2='+key;
		//window.location.href = "https://dev-polaris.cs32.force.com/lightningwashington/s/self-service?par1="+conId+"&par2=contact";
	},
    showAddress : function(component,event){
        var flag = component.get("v.showAddress");
        component.set("v.showAddress",!flag);
    },
    handleMenuSelectlink: function(component, event) {
        var selectedMenuItemValue = event.getParam("value");
            window.open(selectedMenuItemValue,"_self"); 
        
    },
    showMore : function(component,event){
        component.set("v.showMoreAMR",!component.get("v.showMoreAMR"));
    }
    /*updateAddress: function(component, event, helper) {
        var conId = component.get("v.ContactObj.Id") ;
        var key = 'contact' ;
        window.location.href = $A.get($Lable.c.Polaris_Portal_Self_Service)+'par1'+conId+'par2'+key;
		//window.location.href = "https://dev-polaris.cs32.force.com/lightningwashington/s/self-service?par1="+conId+"&par2=address";
	}*/
})