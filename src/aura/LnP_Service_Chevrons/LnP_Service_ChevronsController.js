({
	doInit : function(component, event, helper) {
        console.log('Inside DoInit');
        helper.setApplicationType(component, event, helper);
        helper.fetchDataFromServer(component, event, helper);
    },
    previousTab : function(component, event, helper) {
		helper.goToPreviousTab(component, event, helper);
	},
    nextTab : function(component, event, helper) {
		 if(component.get("v.removeAffiliate")){
                var affilComp = component.find("affiliated");
                console.log("affilComp::"+ affilComp);
                affilComp.performRemove();
        }        
		helper.goToNextTab(component, event, helper);		    
       // helper.checkMandatory(component, event, helper);
    },
    
    onDeclarationChange: function(component, event, helper){
        if(component.get("v.declarationFlag") ==  false){
            component.set("v.declarationFlag", true);
        } else{
            component.set("v.declarationFlag", false);
        }
        helper.onCheckboxChange(component, event, helper);    
	},
    
    onCheckboxChange: function(component, event, helper) {        
		helper.onCheckboxChange(component, event, helper);
	},
    onAttestationChange: function(component, event, helper) {
		helper.onAttestationChange(component, event, helper);
	},
    showDependentQuestions : function(component, event, helper){
        helper.showDependentQuestionsHelper(component, event, helper);
    },
     attestValue: function(component, event, helper) {        
       // alert(event.getSource().get("v.value"));
    },
    submit : function(component, event, helper) { 
        helper.submit(component, event, helper);
    },
     handlePassValuesEvent :  function(component, event, helper){
     // alert('The item is: ');
    },
    
    handleLocationEvent : function(component,event,helper){
        var message = event.getParam("callRemoveAffiliate");
        console.log("message inside Event::"+ message);
        if(message){
            component.set("v.removeAffiliate",true);
        }
    },
    
    getCurrTab : function(component, event, helper){
      helper.getCurrTabHelper(component, event, helper);
    },
    //Addition over
    //Close popup 
    closeModel: function(component, event, helper) {
		helper.closeModel(component, event);
	},
    certificateCheckbox: function(component, event, helper) {
		helper.certificateCheckbox(component, event);
	}
})