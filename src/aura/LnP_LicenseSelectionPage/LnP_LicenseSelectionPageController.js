({
	doInit : function(component, event, helper) {
 
	},
    resetAttributes :  function(component, event, helper){
        helper.resetAttributesHelper(component, event, helper);
    },
    fetchAppTypeEliQuestions : function(component, event, helper){
    	helper.fetchAppTypeEliQuestionsHelper(component, event, helper);
	},
    showOrHideQuestion : function(component, event, helper){
        helper.showOrHideQuestionHelper(component, event, helper);
    },
    showOrHideEliQuestion : function(component, event, helper){
        helper.showOrHideEliQuestionHelper(component, event, helper);
    },
    showNotAppTypeEliQuestions : function(component, event, helper){
       helper.showNotAppTypeEliQuestionsHelper(component, event, helper); 
    },
    startApplication : function(component, event, helper){
            helper.startApplicationHelper(component, event, helper);    
    },
    firePassValueEvent : function (component, event, helper){
        console.log("SD");
        helper.firePassValueEventHelper(component, event, helper);
    },
    setApplicationType : function(component, event, helper){
        helper.firePassValueEventHelper(component, event, helper);
    }
})