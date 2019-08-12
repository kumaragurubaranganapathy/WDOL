({
	doinit : function(component, event, helper) {
        component.set("v.isOutOfCountry", false);
        component.set("v.isStateWA", true);
        component.set("v.issuggestTrue", false);
        component.set("v.userSelectedAddr", "OriginalAddress");
        
        helper.getCountryList(component , helper);
        helper.getStateList(component , helper);
        helper.getCountyList(component , helper);
        var pathname = window.location.href;
		console.log('pathname'+pathname);
        component.set("v.pathname", pathname);
        
        
	},
    handleCancel : function(component, event, helper) {
        console.log("handleCancel");
        helper.setDefaultFields(component,helper);
        component.set("v.isAddAddressClicked",false);
        
    }, 
    
    getValidatedAddress : function(component ,event, helper) {
        helper.getinputAddress(component, helper);
        var originalAddressValue = component.get("v.originalAddress");
        var streetValue = component.get("v.street");
        var street2Value = component.get("v.street2");
        var cityValue = component.get("v.city");
        var stateValue = component.get("v.Statevalue");
        var zipValue = component.get("v.zip");

        var action = component.get("c.validateAddress");
        action.setParams({
            'addrLine1': streetValue,
            'addrLine2': street2Value,
            'city': cityValue,
            'state': stateValue,
            'zip' : zipValue,
        });
        console.log('step2');
            action.setCallback(this, function(response){
            var state = response.getState();
                console.log('state' + state);
                if(state === "SUCCESS"){
                    console.log("step4");
                	var addr = response.getReturnValue();
                    console.log('validatedAddress'+ addr.street2);
                	if(addr.street != null){
                    	component.set("v.outputAddress" , addr);
                    	component.set("v.isAddAddressClicked" , true);
                        var suggestedAddress = '';
                       
                        
                        if(addr.street2 !== null && addr.street2 !== '' && addr.street2 !== undefined){
                           component.set("v.issuggestedAdd2" , true);
                           suggestedAddress = addr.street+', ' +addr.city+', '+addr.state+', '+addr.zip+', '+addr.country +', '+addr.street2;
                        }
                        else {
                           component.set("v.issuggestedAdd2" , false);
                           suggestedAddress = addr.street+', ' +addr.city+', '+addr.state+', '+addr.zip+', '+addr.country;
                        }
                        console.log("issuggestedAdd2"+component.get("v.issuggestedAdd2"));
                        console.log("suggestedAddress"+component.get("v.suggestedAddress"));
                        component.set("v.suggestedAddress" , suggestedAddress);
                        helper.highlight (component, helper,suggestedAddress, originalAddressValue);
                	}
            	} else if (state === "ERROR") {
                	var errors = response.getError();
                	if (errors) {
                    	if (errors[0] && errors[0].message) {
                        	console.log("Error message: " + 
                                 errors[0].message);
                    	}
                	}  
            	}     
        });
         $A.enqueueAction(action);  
    },
    onChange : function(component , event, helper) {
        var selectedAddress = document.querySelector('input[name="locations"]:checked').value;
        component.set("v.userSelectedAddr" , selectedAddress);
        if(selectedAddress == 'SuggestedAddress'){
           var addr = component.get("v.issuggestedAdd2");
             component.set("v.isAddress2" , addr);
            component.set("v.issuggestTrue" , true);
        }
        if(selectedAddress == 'OriginalAddress'){
           var addr = component.get("v.isOriginalAdd2");
             component.set("v.isAddress2" , addr);
        }
         var isaddress2 = component.get("v.isAddress2");
    },
    saveUSAAddress : function(component ,event, helper) {
        helper.getParentId(component , helper);
        var parentSobjectID = component.get("v.parentSobjectID");
        
        var address; 
        var isAptInfo = component.get("v.isAddress2");
        var selectedAddress = component.get("v.userSelectedAddr");
        var issuggestTrue = component.get("v.issuggestTrue");
        var countyValue = component.get("v.countyValue");
        
        if(selectedAddress === 'OriginalAddress'){
            address = component.get("v.originalAddress");
        }else if(selectedAddress === 'SuggestedAddress'){
            address = component.get("v.suggestedAddress");
        }
        var action = component.get("c.saveAddress");
        component.set("v.Spinner", true);
        action.setParams({
            'selectedAddress': address,
            'isAptInfo' : isAptInfo,
            'isAddrValidated' : issuggestTrue,
            'countyValue' : countyValue,
            'parentId' : parentSobjectID,
        });    
         	console.log("Spinner" + component.get("v.Spinner"));
        	action.setCallback(this, function(actionResult) {
            if(actionResult.getState() ==="SUCCESS"){ 
                component.set("v.Spinner", false);
                component.set("v.isAddAddressClicked",false);
                var result = actionResult.getReturnValue();
                if(result != null){
                   helper.showToast(component, event, "Success!", "success", "Your address Entry has been successfully created."); 
                    var navEvt = $A.get("e.force:navigateToSObject");
                	navEvt.setParams({
                    "recordId": result,
                    "slideDevName": "detail"
                });
                navEvt.fire();
                }
                if(result == null){
                   helper.showToast(component, event, "Error!", "error", "Your address Entry could not be saved.");
                    helper.setDefaultFields(component);
                	$A.get('e.force:refreshView').fire();
                }
                
                
            } else if (actionResult.getState() ==="ERROR"){
                //Error 
                component.set("v.Spinner", false);
                var errors = actionResult.getError();
                console.log(JSON.stringify(errors));
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        helper.showToast(component, event, "Error!", "error", errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
                helper.setDefaultFields(component);
                $A.get('e.force:refreshView').fire();
            }
            
        });
        $A.enqueueAction(action);
    }, 
    saveNonUSAAddress : function(component ,event, helper) {
        helper.getinputAddress(component,helper);
        helper.getParentId(component , helper);
        var parentSobjectID = component.get("v.parentSobjectID");
        var isAptInfo = component.get("v.isAddress2");
        var selectedAddress = component.get("v.nonUsAddress");
        var countyValue = component.get("v.countyValue");
        
        var action = component.get("c.saveAddress");
        component.set("v.Spinner", true);
        action.setParams({
            'selectedAddress': selectedAddress,
            'isAptInfo' : isAptInfo,
            'isAddrValidated' : false,
            'countyValue' : countyValue,
            'parentId' : parentSobjectID,
        });    
         	console.log("Spinner" + component.get("v.Spinner"));
        	action.setCallback(this, function(actionResult) {
            if(actionResult.getState() ==="SUCCESS"){ 
                component.set("v.Spinner", false);
                component.set("v.isAddAddressClicked",false);
                var result = actionResult.getReturnValue();
                if(result != null){
                   helper.showToast(component, event, "Success!", "success", "Your address Entry has been successfully created."); 
                    var navEvt = $A.get("e.force:navigateToSObject");
                	navEvt.setParams({
                    "recordId": result,
                    "slideDevName": "detail"
                });
                navEvt.fire();
                }
                if(result == null){
                   helper.showToast(component, event, "Error!", "error", "Your address Entry could not be saved.");
                    helper.setDefaultFields(component);
                	$A.get('e.force:refreshView').fire();
                }
                
                
                
            } else if (actionResult.getState() ==="ERROR"){
                //Error 
                component.set("v.Spinner", false);
                var errors = actionResult.getError();
                console.log(JSON.stringify(errors));
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        helper.showToast(component, event, "Error!", "error", errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
                helper.setDefaultFields(component);
                $A.get('e.force:refreshView').fire();
            }
            
        });
        $A.enqueueAction(action);
    }, 
    onCountryChange: function(component, event, helper){
        var selectCmp = component.find("countryVal");
        var selectedCountry = selectCmp.get("v.value");
        
        if(selectedCountry =='United States'){
            console.log('Entered condition United States');
            component.set("v.isOutOfCountry",false);
            helper.getStateList(component , helper);
            component.set("v.isStateWA",true);
            helper.getCountyList(component , helper);
        }
        else{
            console.log('Entered condition out of United States');
            component.set("v.isOutOfCountry",true);
            component.set("v.isStateWA",false);
            component.set("v.outofState","Out Of State");
            component.set("v.outofCounty","Out Of State");
            
        }
    },
    onStateUpdate: function(component, event, helper){
        console.log('onStateUpdate');
        var selectCmp = component.find("stateval");
        var selectedState = selectCmp.get("v.value");
        
        console.log('selectedState'+selectedState);
        if(selectedState =='WA'){
            console.log('Entered condition State WA');
            component.set("v.isStateWA",true);
            helper.getCountyList(component , helper);
            component.set("v.isOutOfCountry",false);
        }
        else{
            console.log('Entered condition out of WA State');
            component.set("v.isStateWA",false);
            component.set("v.outofCounty", "Out Of State");   
        }
        
    },
    handleBack : function (component, event, helper) {
    	var urlEvent = $A.get("e.force:navigateToURL");
        helper.getSobjName(component , helper);
        var navigatetoRelatedList = component.get("v.navigatetoRelatedList");
        var parentSobjectID = component.get("v.parentSobjectID");
        var sobjName = component.get("v.sobjectName");
        var uRL;

        
        if(navigatetoRelatedList){
            uRL ="/lightning.force.com/lightning/r/"+sobjName+"/"+parentSobjectID+"/view";
        }else{
            uRL = "/lightning/o/MUSW__Parcel__c/list?filterName=Recent";
            
        }
        urlEvent.setParams({
          "url": uRL
        });
        urlEvent.fire();
	},
    
    onCityChange : function(component, event, helper){
        console.log('onCityChange');
         var selectedState = component.find("stateval");
         var stateValue = selectedState.get("v.value");
        if(component.get("v.city") != null && stateValue != null){
            console.log('inside City and State');
        	helper.countyOnCityChange(component, event, helper);
        }
    },
    
})