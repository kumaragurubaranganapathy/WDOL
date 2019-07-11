({
    doInit : function(component,event,helper){
    	 console.log("accountName::"+ component.get("v.accountName"));
	}, 
    
	handleClick : function(component, event) {
		component.set("v.isOpen",true);
        console.log("accountName::"+ component.get("v.accountName"));
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
				message = message + ' , '+validationPassed[ind];
			}
		
			var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!!!",
                    "message": message,
                    "type": "error"
                });
                toastEvent.fire();
                	     
	   }else{
		   if(eventfields['Role__c'] === 'Administrator'){
				eventfields.isAdminContact__c = true;
				eventfields.Account_Admin__c = false;
		   }
		   if(eventfields['Role__c'] == 'Designated Controlling Person' ){
				eventfields["DCP__c"] = true;
		   }
		   eventfields["MUSW__Account__c"] = component.get("v.accountId");
		   component.set("v.accountEmail",eventfields.Email__c);
		   component.set("v.designation",eventfields["Role__c"]);
		   eventfields["invitation_send_date__c "] = $A.localizationService.formatDate(new Date(), "YYYY-MM-DD");
		   eventfields.Status__c = "Invited";
		   //console.log('eventfields::'+JSON.stringify(eventfields));
		   component.set("v.isDCP",eventfields["DCP__c"]);
			//console.log("dcp::"+eventfields["DCP__c"]);
			if(eventfields["Role__c"] == 'Designated Controlling Person' && component.get("v.accountName").includes('Appraisal Management Company') ){ 
				helper.designatedCheck(component,eventfields);
			}else{
				component.find('myform').submit(eventfields); 
			}
        }
	},
    
    successData : function(component,event,helper){
        component.set("v.accountContactId",event.getParam("id"));
        component.set("v.isOpen",false);
        helper.addTask(component,event,helper);
    }
    
	
	
})