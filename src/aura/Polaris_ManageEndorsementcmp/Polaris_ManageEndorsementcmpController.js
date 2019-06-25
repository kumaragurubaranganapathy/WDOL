({
    doInit : function(component, event, helper) {   
        helper.fetchDataFromServer(component, event, helper);
        helper.fetchEndorsement(component, event, helper);
    },
    showDependentQuestions : function(component, event, helper){
        //helper.showDependentQuestionsHelper(component, event, helper);
       
        //console.log('onchange : ',JSON.stringify(component.get("v.licenseWrapper")));
    },
    viewProvider: function(component, event, helper) {
		helper.viewProviderHelper(component, event, helper);
	},
    deleteProvider: function(component, event, helper){
        helper.deleteProviderHelper(component, event, helper);
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
    saveData : function(component,event,helper){
       event.preventDefault();     
       var eventfields = event.getParam("fields");
       eventfields["Endorsement__c"] = component.get("v.endorsementID");              
       component.find('providerForm').submit(eventfields); 
	},
    addProvider : function(component, event, helper){        
        component.set("v.endorsementID",event.getSource().get("v.value"));        
        component.set("v.isModalOpen",true);      
    },   
    closeProviderModel : function(component,event,helper){
     component.set("v.isModalOpen",false);
	},
    
    handleSuccess : function(component, event, helper) {
        component.find('notifLib').showToast({
            "variant": "success",
            "title": "Provider Added",
            "message": "Provider Added"
        });
        component.set("v.isModalOpen",false);
    },
    submit : function(component, event, helper){
       console.log('onchange : ',JSON.stringify(component.get("v.licenseWrapper")));
       helper.submitHelper(component, event, helper);
    }
})