({
	doinit : function(component, event, helper) {
        component.set("v.country", "United States");
        component.set("v.userSelectedAddr", "OriginalAddress");
        helper.getStateList(component , helper);
	},
    handleCancel : function(component, event, helper) {
        helper.setDefaultFields(component);
        component.set("v.isAddAddressClicked",false);
        
    }, 
    /*hideConfirmModal : function(component, event, helper) {
        //Toggle CSS styles for hiding Modal
        helper.toggleClassInverse(component,'backdrop','slds-backdrop--');
        helper.toggleClassInverse(component,'modaldialog','slds-fade-in-');
    },*/
    getValidatedAddress : function(component ,event, helper) {
        console.log("step1");
        var street = component.get("v.street");
        var street2 = component.get("v.street2");
        console.log("street"+street2);
        var city = component.get("v.city");
        var state = component.get("v.parcelObject.MUSW__State__c");
        var zip = component.get("v.zip");
        var country = component.get("v.country");
       
        if(street.includes(',')){
            street = street.replace(',', ' ' );
        }
           
        var originalAddress = street+', '+city+', '+state+', '+zip+', '+country;
        if(street2!= null && street2!= undefined && street2!= ''){
            var isAddress2 = component.set("v.isOriginalAdd2" , true);
            originalAddress += ', '+street2;
        }
       // originalAddress= originalAddress+ ', '+city+', '+state+', '+zip+', '+country;
        
        component.set("v.originalAddress", originalAddress);
        var valid = true;
        console.log("step2"+originalAddress);

        if(street == null || street == "") {
            console.log("step3");
            valid = false;
        }
        else if(city == null || city == ""){
             console.log("step3");
           valid = false; 
        }         
        else if(state == null || state == "") {
             console.log("step3");
            valid = false;
        }
        
        else if(zip== null || zip == "") {
             console.log("step3");
            valid = false;
        }
        if(!valid){
             console.log("step3");
             helper.showToast(component, event, "Error!", "error", "Please fill in all required fields.");
        }
        else if(isNaN(zip)){
            helper.showToast(component, event, "Error!", "error", "Please enter numeric value for zip.");
        }
        //else if(city.includes(',')){
            else if(/[^a-zA-Z \-\/]/.test( city )){
            helper.showToast(component, event, "Error!", "error", "Please remove special character from city.");
        }
        else {
            var action = component.get("c.validateAddress");
        action.setParams({
            'addrLine1': street,
            'addrLine2': street2,
            'city': city,
            'state': state,
            'zip' : zip,
        });
        console.log('step2');
        console.log('step3'+ street);
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
                           suggestedAddress = addr.street+', ' +addr.city+', '+addr.state+', '+addr.zip+', '+addr.country+', '+addr.street2;
                           console.log("addr.street2=="+addr.street2);
                        }
                        else {
                           component.set("v.issuggestedAdd2" , false);
                           suggestedAddress = addr.street+', ' +addr.city+', '+addr.state+', '+addr.zip+', '+addr.country;
                           console.log("addr.street2**"+addr.street2);
                        }
                        console.log("issuggestedAdd2"+component.get("v.issuggestedAdd2"));
                        console.log("suggestedAddress"+suggestedAddress);
                        component.set("v.suggestedAddress" , suggestedAddress);
                        helper.highlight (component, helper,suggestedAddress, originalAddress);
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
        }  
    },
    onChange : function(component , event, helper) {
        console.log('radiobutton');
        var selectedAddress = document.querySelector('input[name="locations"]:checked').value;
        component.set("v.userSelectedAddr" , selectedAddress);
        console.log('selectedAddress'+selectedAddress);
        if(selectedAddress == 'SuggestedAddress'){
           var addr = component.get("v.issuggestedAdd2");
            console.log('addr=='+addr);
             component.set("v.isAddress2" , addr);
        }
        if(selectedAddress == 'OriginalAddress'){
           var addr = component.get("v.isOriginalAdd2");
            console.log('addr=='+addr);
             component.set("v.isAddress2" , addr);
        }
         var isaddress2 = component.get("v.isAddress2");
        console.log('isaddress2'+isaddress2);
    },
    onsaveAddress : function(component ,event, helper) {
        console.log('onsaave');
        var address; 
        var recordId = component.get("v.recordId");
        var isAptInfo = component.get("v.isAddress2");
         console.log('isAptInfo'+isAptInfo);
        var selectedAddress = component.get("v.userSelectedAddr");
        
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
            'parentId': recordId, 
        });    
         	console.log("Spinner" + component.get("v.Spinner"));
        	action.setCallback(this, function(actionResult) {
            if(actionResult.getState() ==="SUCCESS"){ 
                var isSave = actionResult.getReturnValue();
                console.log("isSave=="+ isSave);
                component.set("v.Spinner", false);
                component.set("v.isAddAddressClicked",false);
                if(isSave === true){
                   helper.showToast(component, event, "Success!", "success", "Your address Entry has been successfully created."); 
                }
                if(isSave === false){
                   helper.showToast(component, event, "Error!", "Error", "Error on saving your address Entry."); 
                }
                
                helper.setDefaultFields(component);
                $A.get('e.force:refreshView').fire();;
                
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
            }
            
        });
        $A.enqueueAction(action);
    },    
})