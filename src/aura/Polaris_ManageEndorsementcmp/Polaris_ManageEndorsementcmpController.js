({
    doInit : function(component, event, helper) {   
        helper.fetchDataFromServer(component, event, helper);
        helper.fetchEndorsement(component, event, helper);
    },
    showDependentQuestions : function(component, event, helper){
        //helper.showDependentQuestionsHelper(component, event, helper);
       
        //console.log('onchange : ',JSON.stringify(component.get("v.licenseWrapper")));
    },
    closeModel: function(component, event, helper) {
		helper.closeModel(component, event);
	},
    remove: function(component, event, helper) {
		helper.removeHelper(component, event,helper);
	},
    showAddRecord : function(component, event, helper){
        helper.addEndorsemet(component, event, helper);        
    },
    submit : function(component, event, helper){
       console.log('onchange : ',JSON.stringify(component.get("v.licenseWrapper")));
       helper.submitHelper(component, event, helper);
    }
})