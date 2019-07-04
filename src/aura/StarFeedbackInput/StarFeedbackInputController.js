({
	doInit : function(component, event, helper) {
		helper.doInit(component,event);
	},
    starClick : function(component, event, helper) {
		helper.starClick(component,event);
	},
    
    saveFeedback: function(component,event,helper) {
        helper.saveFeedbackForm(component,event);
    },
    cancelFeedback : function(component,event,helper){
        helper.cancelFeedback(component,event);
    }
        
})