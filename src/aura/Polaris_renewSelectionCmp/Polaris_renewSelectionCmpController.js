({
	doInit : function(component, event, helper) {        
        helper.fetchAppTypeEliQuestionsHelper(component, event, helper); 
	},
    showOrHideEliQuestion : function(component, event, helper){
        helper.showOrHideEliQuestionHelper(component, event, helper);
    },
    startApplication : function(component, event, helper){ 
        helper.validateform(component, event, helper);
    },
})