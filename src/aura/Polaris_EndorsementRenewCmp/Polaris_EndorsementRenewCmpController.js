({
	doInit : function(component, event, helper) {        
        helper.fetchEndorsement(component, event, helper);
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
            helper.changeStatusHelp(component, event, helper);
        }        
    },
    deleteProvider: function(component, event, helper){
        helper.deleteProviderHelper(component, event, helper);
    },
    saveData : function(component,event,helper){
       event.preventDefault();     
       var eventfields = event.getParam("fields");
       eventfields["Endorsement__c"] = component.get("v.endorsementID");              
       component.find('providerForm').submit(eventfields); 
	},
   
    closeModel : function(component,event,helper){
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
})