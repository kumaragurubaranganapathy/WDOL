({
    doInit : function(component, event, helper) {
        component.set("v.userSelectedAddr", "OriginalAddress");
        component.set("v.defaultCountry" , 'United States');
        helper.getStateList(component , helper);
        var addDetails=[];
        var action  = component.get('c.getAddressDetailsType');
        action.setCallback(this, function(response) {
            var state = response.getState();
            console.log("state",state);
            //addDetails.push({label: '--None--', value: '--None--'}); 
            if (state === "SUCCESS") {
                for(var i=0;i< response.getReturnValue().length;i++){
                    addDetails.push({label: response.getReturnValue()[i], value: response.getReturnValue()[i]});
                }
                component.set("v.addressDType", addDetails);
                //helper.getData(component, event, helper, true);
                helper.getallAddress(component, event, helper, true);

            }
            console.log('component.get("v.addressDType")',component.get("v.addressDType"));
        });
        $A.enqueueAction(action);
        
        
    },
    getAddress : function(component, event, helper) {
        helper.getAddressHelper(component, event);
    }, 
    selectAddress: function(component, event, helper) {
        helper.selectAddress(component, event);
    },
    getRecord : function(component, event, helper) {
        helper.getRecordHelper(component, event);
    },
    deleteRecord : function(component, event, helper) {
        helper.deleteRecordHelper(component, event);
    },
    saveAddress : function(component, event, helper) {        
        helper.saveAddressHelper(component, event, helper);      
    },
    cancelAddress : function(component, event, helper) {
		helper.cancelAdressHelper(component, event, helper);            
    },
    addAddress: function(component, event, helper) {  
        var elements = document.getElementsByClassName("addAddress");
        for(var i=0; i<elements.length; i++) {
            elements[i].classList.remove('slds-hide');
        }
        document.getElementsByClassName("addressTypeSelection")[0].classList.remove('slds-hide');
    },
    selectExistingAddress: function(component, event, helper) {
        helper.selectExistingAddressHelper(component, event,helper);
    },         
    handleDelete :function(component, event, helper) {        
        helper.deleteRecordHelper(component, event, helper);
    },
    onSelect : function(component, event, helper) {     
        var addressType = event.getSource().get("v.name");
        console.log('addressType==**'+addressType);
        var addressType1 = event.getSource().get("v.value");
        console.log('addressType1==**'+addressType1);
        component.set("v.typeOfAddress",addressType1); 
        if(addressType1 == 'Address Verification'){
            console.log('isAddrVerification= true');
            component.set("v.isAddrVerification" ,'YES');
            var isAddr = component.get("v.isAddrVerification");
             console.log('isAddrVerification value'+ isAddr);
        }
        else{
           var elements = document.getElementsByClassName("addAddress");
        	for(var i=0; i<elements.length; i++) {
           	 elements[i].classList.remove('slds-hide');
        	} 
        }
        
    },
    
    onCountySelect : function(component, event, helper){
        var valCounty = event.getSource().get("v.value");
        component.set("v.parcel.County__c", valCounty);
    },
    
    onStateChange : function(component, event, helper) {
        if(component.get("v.parcel.State__c") != '' && component.get("v.parcel.City__c") != ''){
           helper.countyFetchHelper(component, event, helper);
        }
	},
    
    onCityChange : function(component, event, helper){
        if(component.get("v.parcel.City__c") != '' && component.get("v.parcel.State__c") != ''){
        	helper.countyFetchHelper(component, event, helper);
        }
    },
    getValidatedAddress : function(component ,event, helper) {
        var address = component.get("v.parcel");
        var street = address.Street__c;
        var street2 = address.Unit__c; 
        var city = address.City__c;
        var state = address.State__c;
        var county = address.County__c;
        var zip = address.Zip_Postal_Code__c;
        var country = component.get("v.defaultCountry");
        var addresstype = address.Address_Type__c;
        component.set("v.selectedAddressType" , addresstype);
        if(street.includes(',')){
            street = street.replace(',', ' ' );
        }
           
        var originalAddress = street+', '+city+', '+state+', '+zip+', '+country;
        if(street2!= null && street2!= undefined && street2!= ''){
            component.set("v.isOriginalAdd2" , true);
            component.set("v.isAddress2" , true);
            originalAddress += ', '+street2;
        }
       // originalAddress= originalAddress+ ', '+city+', '+state+', '+zip+', '+country;
        
        component.set("v.originalAddress", originalAddress);
        var valid = true;
        if(addresstype == null || addresstype == "") {
            valid = false;
        }
        if(street == null || street == "") {
            valid = false;
        }
        else if(city == null || city == ""){
            valid = false; 
        }         
            else if(state == null || state == "") {
                valid = false;
            }
        
                else if(zip== null || zip == "") {
                    valid = false;
                }
        if(!valid){;
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
            action.setCallback(this, function(response){
            var state = response.getState();
                if(state === "SUCCESS"){
                    console.log("step4");
                	var addr = response.getReturnValue();
                	if(addr.street != null){
                    	component.set("v.outputAddress" , addr);
                    	component.set("v.isAddAddressClicked" , true);
                        var suggestedAddress = '';
                       
                        
                        if(addr.street2 !== null && addr.street2 !== '' && addr.street2 !== undefined){
                           component.set("v.issuggestedAdd2" , true);
                           suggestedAddress = addr.street+', ' +addr.city+', '+addr.state+', '+addr.zip+', '+addr.country+', '+addr.street2;
                        }
                        else {
                           component.set("v.issuggestedAdd2" , false);
                           suggestedAddress = addr.street+', ' +addr.city+', '+addr.state+', '+addr.zip+', '+addr.country;
                        }
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
        var selectedAddress = document.querySelector('input[name="locations"]:checked').value;
        component.set("v.userSelectedAddr" , selectedAddress);
        if(selectedAddress == 'SuggestedAddress'){
           var addr = component.get("v.issuggestedAdd2");
            component.set("v.isAddress2" , addr);
            component.set("v.isSelectedAddrTrue" , true);
        }
        if(selectedAddress == 'OriginalAddress'){
           var addr = component.get("v.isOriginalAdd2");
             component.set("v.isAddress2" , addr);
        }
         var isaddress2 = component.get("v.isAddress2");
    },
    handleCancel : function(component, event, helper) {
        helper.setDefaultFields(component);
        component.set("v.isAddAddressClicked",false);
        
    },
    onsaveAddress : function(component ,event, helper) {
        console.log('onsaave1');
        var address; 
        var recordId = component.get("v.recordId");
        var isAptInfo = component.get("v.isAddress2");
        var applicationId= component.get("v.applicationId");
        var selectedAddress = component.get("v.userSelectedAddr");
        var issuggestTrue = component.get("v.isSelectedAddrTrue");
        var addresstype = component.get("v.selectedAddressType");
        if(selectedAddress === 'OriginalAddress'){
            address = component.get("v.originalAddress");
        }else if(selectedAddress === 'SuggestedAddress'){
            address = component.get("v.suggestedAddress");
        }
        console.log('address'+ address);
        console.log('isAptInfo'+ isAptInfo);
        var action = component.get("c.integrationsaveAddress");
        component.set("v.Spinner", true);
        action.setParams({
            'selectedAddress': address,
            'isAptInfo' : isAptInfo,
            'applicationId':applicationId,
            'issuggestTrue' : issuggestTrue,
            'addresstype' : addresstype,
            'licenseId' : component.get("v.licenseId"),
        });
        	action.setCallback(this, function(actionResult) {
            if(actionResult.getState() ==="SUCCESS"){ 
                var parcelList = actionResult.getReturnValue();
                console.log("parcelList=="+ parcelList);
                //component.set("v.LicenseAddressList", parcelList);
                component.set("v.Spinner", false);
                component.set("v.isAddAddressClicked",false);
                if(parcelList != null){
                   helper.cancelAdressHelper(component, event, helper); 
                   helper.getallAddress(component, event, helper);
                   helper.showToast(component, event, "Success!", "success", "Your address Entry has been successfully created.");
                      
                }
                else{
                   helper.showToast(component, event, "Error!", "Error", "Error on saving your address Entry."); 
                }
                
                //helper.setDefaultFields(component);
                //$A.get('e.force:refreshView').fire();;
                
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
    updateSameAdd: function(component ,event, helper) {
        console.log('Called JS Controller');
        helper.sameAddHelper(component, event);
        console.log('Called JS Controller end');
        //helper.getallAddress(component, event,helper);
        
    }
    
})