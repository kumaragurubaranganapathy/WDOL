({
    doInit : function(component, event, helper) {
		helper.fetchLicenseDetailsHelper(component, event, helper);
		component.set("v.loadingSpinner",false);
	},
	handleClick : function(component, event) {
		component.set("v.isOpen",true);
	},
    handleAssociationClick : function(component, event) {
		component.set("v.isAssociationOpen",true);
	},
    closeAssociationModel : function(component,event){
     component.set("v.isAssociationOpen",false);
	},
    closeModel : function(component,event){
     component.set("v.isOpen",false);
	},
    
    saveData : function(component,event){
		component.set("v.loadingSpinner",true);
        //alert('Associations :'+component.get("v.licenseRecord.No_of_Associations__c")+'license Type:'+component.get("v.licenseRecord.Credential_Type__c"));
        if(component.get("v.licenseRecord.No_of_Associations__c")>=3 && (component.get("v.licenseRecord.Credential_Type__c") === 'Certified General Appraiser' || component.get("v.licenseRecord.Credential_Type__c") === 'Certified Residential Appraiser'))
        {
            event.preventDefault();
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Error!!!",
                "message": "Please Apply for AMR to add more trainee",
                "type": "error"
            });
            toastEvent.fire();
        }
        else{
            event.preventDefault();     
            var eventfields = event.getParam("fields");
            var today = new Date();
            var month = today.getMonth() + 1;
            var day = today.getDate();
            var year = today.getFullYear();
            var date = year + "-" + month + "-" + day;
            component.set("v.today", date);
            eventfields.Parent_License__c = component.get("v.parentLicense");
            //eventfields["invitation_send_date__c"] = component.get("v.today"); Putting in a workflow field update
            eventfields.Status__c= "Invited";        
            component.find('associationForm').submit(eventfields); 
        }
	},
    
    handleSuccess : function(component, event, helper) {
		component.set("v.loadingSpinner",false);
        component.find('notifLib').showToast({
            "variant": "success",
            "title": "Association Created",
            "message": "Association Created"
        });
       // alert('ID : '+event.getParam("id"));
        component.set("v.asssociationId",event.getParam("id"));
        component.set("v.isAssociationOpen",false);
        helper.addTask(component,event,helper);
    }
    
})