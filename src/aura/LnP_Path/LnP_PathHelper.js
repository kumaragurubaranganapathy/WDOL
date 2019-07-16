({
	setCurrTabHelper : function(component, event, helper) {
        var tabIdString = event.currentTarget.dataset.id;
        var tabId = parseInt(tabIdString);
        //var Lnp_setCurrTabEv = $A.get("e.c:LnP_setCurrTabEvent");
        var Lnp_setCurrTabEv = component.getEvent("LnP_setCurrTabEvent");
    	Lnp_setCurrTabEv.setParams({"currTab" : tabId})
    	var test = Lnp_setCurrTabEv.getParam("currTab");
    	//alert(test);
        Lnp_setCurrTabEv.fire();	
	},
    getAttJSONHelper : function(component, event, helper) {
        /*var attJSONString = event.getParam("attJSON");
        console.log('DWDattJSON ' + attJSONString);
        var attJSON = JSON.parse(attJSONString);*/
    	
    },
    changeStringArray : function(component, event, helper){
        console.log('hello');
       
    },
    test : function(component, event, helper){
        console.log('test');
        var cmplength=component.get('v.path');
        comsole.log(cmplength.length);
    }
})