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
    skipFeedback : function(component,event,helper){
        helper.skipFeedback(component,event);
    }
        
})