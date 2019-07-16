({
	doInit : function(component, event, helper) {
        helper.setJSON(component, event, helper); 
	},
    radioSelection : function(component, event, helper){
		helper.radioSelectionHelper(component, event, helper);
	},
    nextQuestion : function(component, event, helper){
		helper.nextQuestionHelper(component, event, helper);
	},
    showApplication: function(component, event, helper){
		helper.showApplicationHelper(component, event, helper);
	},
    checkEligibility : function (component, event, helper){
       // console.log("inside helperwals");
        helper.checkEligibilityHelper(component, event, helper); 
    }
})