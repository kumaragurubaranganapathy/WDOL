({
	doInit : function(component, event, helper) {        
        helper.fetchAppTypeEliQuestionsHelper(component, event, helper); 
        helper.checkForCourseProvider(component,event);
	},
    showOrHideEliQuestion : function(component, event, helper){
        helper.showOrHideEliQuestionHelper(component, event, helper);
    },
    startApplication : function(component, event, helper){
        component.set("v.isdisabled",true);
        component.set("v.spinner",true);
        helper.validateform(component, event, helper);
    },
    
})