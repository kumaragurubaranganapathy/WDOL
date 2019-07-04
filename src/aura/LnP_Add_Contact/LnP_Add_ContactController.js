({
	handleClick : function(component, event) {
		component.set("v.isOpen",true);
	},
   
    closeModel : function(component,event){
     component.set("v.isOpen",false);
     component.set("v.showform",true);
     component.set("v.showMessage",false);
	},
    
    saveData : function(component,event){
       event.preventDefault();
       var eventfields = event.getParam("fields");
       if(eventfields['Role__c'] === 'Administrator' || eventfields['Account_Admin__c'] === true){
       		eventfields.isAdminContact__c = true;
            eventfields.Account_Admin__c = false;
       }
       eventfields["MUSW__Account__c"] = component.get("v.accountId");
       component.set("v.accountEmail",eventfields.Email__c);
       component.set("v.designation",eventfields["Role__c"]);
       eventfields["invitation_send_date__c "] = $A.localizationService.formatDate(new Date(), "YYYY-MM-DD");
       eventfields.Status__c = "Invited";
       //console.log('eventfields::'+JSON.stringify(eventfields));
       component.set("v.isDCP",eventfields["DCP__c"]);
        //console.log("dcp::"+eventfields["DCP__c"]);
        if(eventfields["Role__c"] == 'Controlling person' && eventfields["DCP__c"] == true){ 
            
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
        }else{
            component.find('myform').submit(eventfields); 
        }
        
        
       
	},
    
    successData : function(component,event,helper){
        component.set("v.accountContactId",event.getParam("id"));
        component.set("v.isOpen",false);
        helper.addTask(component,event,helper);
    }
})