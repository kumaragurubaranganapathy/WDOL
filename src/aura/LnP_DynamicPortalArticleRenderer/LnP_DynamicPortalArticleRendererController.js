({
    doInit: function(component, event, helper) {
        
        helper.doInit(component,event);
    },
    
    handleFooterButtonAction : function(component, event, helper) {
        helper.handleFooterButtonActionHelper(component,event,helper);
    },
    
    handleBodyButtonAction : function(component, event, helper) {
        helper.handleBodyButtonActionnHelper(component,event,helper);
    },
    /*doRender : function(component,event,helper){
        helper.doRender(component,event);
    }, */
    showMore : function(component,event,helper){
        helper.showMore(component,event);
    },
    showLess : function(component,event,helper){
        helper.showLess(component,event);
    }
    
})