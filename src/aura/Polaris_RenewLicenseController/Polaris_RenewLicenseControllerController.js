({
	doInit : function(component, event, helper) {
		window.onbeforeunload = function(e) {
          e.preventDefault();
          e.returnValue = '';
        };
        if(window.performance.navigation.type == 1) {
            //event.preventDefault();
            var url=$A.get("$Label.c.Polaris_Portal_Home")+'explorer-error-page';
            var urlEvent = $A.get("e.force:navigateToURL");
            urlEvent.setParams({
                "url": url
            });
            urlEvent.fire();
            return false;
        }
        console.log('inside init');
        helper.setApplicationType(component, event, helper);
        helper.fetchDataFromServer(component, event, helper); 
        var flowType = component.get('v.RenewReinstate');
        if(flowType != undefined){
            document.title = flowType;
        }

    },
    previousTab : function(component, event, helper) {
		helper.goToPreviousTab(component, event, helper);
	},
    nextTab : function(component, event, helper) {
		helper.goToNextTab(component, event, helper);
        
       // helper.checkMandatory(component, event, helper);
      
  },
  
  onDeclarationChange: function(component, event, helper){
    /*if(component.get("v.declarationFlag") ==  false){
        component.set("v.declarationFlag", true);
    } else{
        component.set("v.declarationFlag", false);
    }
    helper.onCheckboxChange(component, event, helper);*/
    helper.onDeclarationChange(component, event, helper);
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
        alert(event.getSource().get("v.value"));
    },
    submit : function(component, event, helper) { 
		window.onbeforeunload = null;      
        helper.submit(component, event, helper);
    },
     handlePassValuesEvent :  function(component, event, helper){
     // alert('The item is: '); 

    },
    getCurrTab : function(component, event, helper){
      helper.getCurrTabHelper(component, event, helper);
    },
    //Addition over
    //Close popup 
    closeModel: function(component, event, helper) {
		helper.closeModel(component, event);
	},
    
    //US- 1723
    SaveAndSubmit : function(component, event, helper) {
	   window.onbeforeunload = null;
       component.set("v.saveAndSubmit",true);
       helper.goToNextTab(component, event, helper);
       helper.SaveAndSubmit(component, event, helper); 
    },
    
    handleComponentEvent : function(component,event,helper){
    var PhysicalAddressModified = event.getParam("physicalAddressModifiedonRenewal");
        console.log('inside PhysicalAddressModified::' + PhysicalAddressModified );
        if(PhysicalAddressModified){
           component.set("v.PhysicalAddressModified",true);
        }
    },
    
    handleEvent: function (component, event, helper) {
        helper.handleEventHelper(component, event);
        console.log("Event listener..." + event.getParam("message"));
        
	}
})