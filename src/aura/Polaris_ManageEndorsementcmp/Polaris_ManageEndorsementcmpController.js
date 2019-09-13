({
    doInit : function(component, event, helper) {   
        helper.fetchDataFromServer(component, event, helper);
        helper.fetchEndorsement(component, event, helper);
        helper.fetchAssociationHelper(component, event, helper);
        helper.fetchDisplayEndorsementDetails(component, event, helper);
    },
     handleValueSelect : function(component, event, helper) {   
        var parcedValue = event.getParam("value").split(',');
        var endorsementID = parcedValue[0];       
        var status = parcedValue[1];
        if(status == 'Show Provider')
        {               
            helper.viewProviderHelper(component, event, helper);
        }
        else if(status == 'Add Provider')
        {
            helper.addProviderHelper(component, event, helper);
        }
        else{
            
            helper.removeHelper(component, event,helper,endorsementID);
        }        
    },
    showDependentQuestions : function(component, event, helper){
        //helper.showDependentQuestionsHelper(component, event, helper);
       
        //console.log('onchange : ',JSON.stringify(component.get("v.licenseWrapper")));
    },
    viewProvider: function(component, event, helper) {
        component.set("v.endorsementID",event.getSource().get("v.value"));
		helper.viewProviderHelper(component, event, helper,component.get("v.endorsementID"));
	},
    goBack : function (component, event, helper){
        window.history.back();
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
        helper.viewProviderHelper(component, event, helper,component.get("v.endorsementID"));
    },
    submit : function(component, event, helper){
       console.log('onchange : ',JSON.stringify(component.get("v.licenseWrapper")));
       helper.submitHelper(component, event, helper);
    },
     saveData : function(component,event,helper){
       event.preventDefault();     
       var eventfields = event.getParam("fields");
       eventfields["Endorsement__c"] = component.get("v.endorsementID");              
       component.find('providerForm').submit(eventfields); 
	}
})