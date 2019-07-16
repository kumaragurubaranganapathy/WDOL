({
    handleClick : function(component,event){
        component.set("v.isOpen",true);
        //var elem = document.querySelector(".lightning-record-form-cancel");         
    },
    addTask : function(component,event) {
        var action = component.get("c.createTask");
        //console.log("designation::"+component.get("v.designation"));
        action.setParams({"accountContact": component.get("v.accountContactId"),
                          "Email": component.get("v.accountEmail"),
                          "accountName": component.get("v.accountName"),
                          "accountId": component.get("v.accountId"),
                          "designation": component.get("v.designation"),
                          "DCP": component.get("v.isDCP")});
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var status =  response.getReturnValue()
                var toastEvent = $A.get("e.force:showToast");
                if(status){
                    toastEvent.setParams({
                        "type":"Success",
                        "title": "Success!",
                        "message": "The record has been added successfully."
                    });
                }else{
                    toastEvent.setParams({
                        "type":"Error",
                        "title": "Error!",
                        "message": "Something went wrong"
                    });
                }
                toastEvent.fire();
            } else if (state === "ERROR") {
                //console.error(state);
            }
        });
        $A.enqueueAction(action);
        var compEvent = $A.get("e.c:RefreshComponentEvent"); 
        compEvent.setParams({"refresh" : "true" });
        compEvent.fire();
    },
    
    designatedCheck : function(component,eventfields){
        var action = component.get("c.checkDCP");
				   action.setParams({ "accountId" : component.get("v.accountId")});
				   action.setCallback(this,function(response){
					   var state = response.getState();
					   //console.log("state::"+state);
					   if(state === 'SUCCESS'){
						   var result = response.getReturnValue();
						   //console.log("result::"+result);
						   if(result){
							   component.set("v.showform",false);
							   component.set("v.showMessage",true);
						   }else{
							 component.find('myform').submit(eventfields); 
						   }
					   }
				   });
				$A.enqueueAction(action);
    },
    
    
     validateFieldvalues : function(component,event){
		var eventFields = event.getParam("fields");
		var fieldNames = ['First_Name__c','Middle_Name__c','Last_Name__c','Role__c','Phone__c','Email__c','Other_Position__c','Ownership_Percentage__c','Title_select__c'];
		var ErrorFields = [];
			 if (!eventFields.First_Name__c) {  
				ErrorFields.push('First Name');
			 }
			/* if (!eventFields.Middle_Name__c){  
				ErrorFields.push('Middle Name');
			 }*/
			 if (!eventFields.Last_Name__c) {  
				ErrorFields.push('Last Name');
			 }
			 if (!eventFields.Role__c) {  
				ErrorFields.push('Role');
			 }
			 if (!eventFields.Phone__c) {  
				ErrorFields.push('Phone');
			 }
			 if (!eventFields.Email__c ) {  
				ErrorFields.push('Email');
			 }
			/* if (!eventFields.Other_Position__c) {  
				ErrorFields.push('Other Position');
			 }*/
			 if (!eventFields.Ownership_Percentage__c ) {  
				ErrorFields.push('OwnerShip Percentage');
			 }
			/* if (!eventFields.Title_select__c ) {  
				ErrorFields.push('Title');
			 }*/
		if(ErrorFields.length != 0){
			return ErrorFields;
		}else{
			return null;
		}
		
	}
    
   
})