({
    doInit : function(component,event,helper){
    	
	}, 
    
	handleClick : function(component, event) {
		component.set("v.isOpen",true);
	},
   
    closeModel : function(component,event){
     component.set("v.isOpen",false);
     component.set("v.showform",true);
     component.set("v.showMessage",false);
	},
    
    saveData : function(component,event,helper){
       event.preventDefault();
       var eventfields = event.getParam("fields");  
	   var validationPassed = helper.validateFieldvalues(component,event);
	   if(validationPassed != null){
			var message = 'Please Enter values in ';
			for(var ind=0;ind < validationPassed.length;ind++ ){
                console.log('Error::'+validationPassed[ind]);
				if(ind != 0 && validationPassed.length > 1){
                    message = message + ',' + validationPassed[ind];
                }else{
                    message = message + validationPassed[ind];
                }
			}
		
			var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!!!",
                    "message": message,
                    "type": "error"
                });
                toastEvent.fire();
                	     
	   }else{
		   eventfields['Role__c'] = 'Administrator';
           eventfields.isAdminContact__c = true;
		   eventfields.Account_Admin__c = false;
		   eventfields["MUSW__Account__c"] = component.get("v.accountId");
		   component.set("v.accountEmail",eventfields.Email__c);
		   component.set("v.designation",eventfields["Role__c"]);
		   eventfields["invitation_send_date__c "] = $A.localizationService.formatDate(new Date(), "YYYY-MM-DD");
		   eventfields.Status__c = "Invited";
		   component.find('myform').submit(eventfields); 
			}
	},
    
    successData : function(component,event,helper){
        component.set("v.accountContactId",event.getParam("id"));
        component.set("v.isOpen",false);
        helper.addTask(component,event,helper);
    }
    
	
	
})