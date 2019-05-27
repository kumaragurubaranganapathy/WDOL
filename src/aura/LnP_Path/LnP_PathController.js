({
	doinit : function(component, event, helper) {
		//console.log('LnP_BackgroundInformation'+component.get("v.path"));
		helper.changeStringArray(component, event, helper);
	},
    setCurrTab : function(component, event, helper){
		helper.setCurrTabHelper(component, event, helper);
    },
    getAttJSON : function(component, event, helper){
        debugger;
        console.log("DPathHere");
     	//helper.getAttJSONHelper(component, event, helper);   
    },
})