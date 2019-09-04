({
	doInit : function(component, event, helper) {
		helper.doInit(component);
	},
    starClick : function(component, event, helper) {
		helper.starClick(component,event);
	},
    
    saveFeedback: function(component,event,helper) {
        helper.saveFeedbackForm(component);
    },
    skipFeedback : function(component,event,helper){
        helper.skipFeedback(component);
    },        
})