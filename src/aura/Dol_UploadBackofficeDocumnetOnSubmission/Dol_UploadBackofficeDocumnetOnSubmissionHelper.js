({
	loadUser : function(component, event, helper) {
		var action = component.get("c.getUser");
       action.setCallback(this, function(response){
        	if(response.getState() === "SUCCESS") {
                var result = response.getReturnValue();
                if(result!= null && result.Name!= null){
                    component.set("v.userName" ,result.Name ); 
                    var email = result.Email;
                    if(email.includes('@')){
                        var emaiaddress = email.split('@');
        				var emailWithoutDomain = emaiaddress[0];
                        console.log('emailWithoutDomain'+emailWithoutDomain);
                        component.set("v.userEmail" ,emailWithoutDomain ); 
                    }
                }            
        	}           
      });
    $A.enqueueAction(action);
	},
    checkProfessionCode : function(component, event, helper) {	
        var recordId = component.get("v.recordId");
		var action = component.get("c.getProfCode");
        action.setParams({
            "recordId" : recordId
            }) ; 
       	action.setCallback(this, function(response){
        	if(response.getState() === "SUCCESS") {
                var result = response.getReturnValue();
                var noProfCode = false;
                
                if(result!= null && result === 'NoProfessionCode'){
                    component.set("v.profCodeValue", 'NoProfessionCode');
                }
                if(result!= null && result === 'ProfessionCodeExists'){
                    component.set("v.profCodeValue", 'ProfessionCodeExists');
                } 
            } 
            if(response.getState() === "ERROR"){
                var error = response.getError();
                console.log('some problem'+error[0].message);}
    
      });
    $A.enqueueAction(action);
	},
    checkImageUrlExists : function(component, event, helper) {	
        var recordId = component.get("v.recordId");
		var action = component.get("c.getImageUrl");
        action.setParams({
            "recordId" : recordId
            }) ; 
       	action.setCallback(this, function(response){
        	if(response.getState() === "SUCCESS") {
                var result = response.getReturnValue();
                console.log('checkImageUrlExists result=='+result);
                if(result!= null && result === 'SANImageURLExists'){
                    component.set("v.ImageUrlValue", 'SANImageURLExists');
                }
            } 
            if(response.getState() === "ERROR"){
                var error = response.getError();
                console.log('some problem'+error[0].message);}
    
      });
    $A.enqueueAction(action);
	},
    
    showToast : function(component, event, title, type, message) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": title,
            "message": message,
            "type":type
        });
        toastEvent.fire();
    },  
    
    setDefaultFields: function(component) {
        component.set("v.title", "");
        component.set("v.docName", "");
        component.set("v.submission.SAN_Image_Type__c", ""); 
        
    },
    refreshRecords : function(component, event, helper) {
        $A.get('e.force:refreshView').fire();
    },
    closeQuickAction : function(component, event, helper) {
        var dismissActionPanel = $A.get("e.force:closeQuickAction"); 
		dismissActionPanel.fire(); 
    },
     getimagetypeOptions: function(component, helper){
        var action = component.get("c.getSelectOptionValues");
        var submission  = component.get("v.submission");
        action.setParams({
            'objObject': submission,
            'fld': 'SAN_Image_Type__c'
        });
        var optsimageType = [];
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {              
                var imageTypeValue = response.getReturnValue();
                if (imageTypeValue != undefined && imageTypeValue.length > 0) {
                    optsimageType.push({
                        class: "optionClass",
                        label: "--- None ---",
                        value: ""
                    });
                }
                for (var i = 0; i < imageTypeValue.length; i++) {
                    optsimageType.push({
                        class: "optionClass",
                        label: imageTypeValue[i],
                        value: imageTypeValue[i]
                    });
                }
                component.find("imageType").set("v.options", optsimageType);  
            } 
        });
        $A.enqueueAction(action); 
    },
})