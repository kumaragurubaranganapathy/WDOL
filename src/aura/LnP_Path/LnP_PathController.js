({
	doinit : function(component, event, helper) {
		console.log("In do init");
		helper.changeStringArray(component, event, helper);
        helper.test(component, event, helper);
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