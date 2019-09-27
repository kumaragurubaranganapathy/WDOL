({
    doInit: function(component, event, helper) {
        
        helper.doInit(component,event);
        
    },
    clickon: function(component, event, helper) {
        helper.clickon(component,event,helper);
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
    },
    redirectToHelp : function(component,event,helper){
        helper.redirectToHelp(component,event);
    }
    
})