({
    getloggedInContactDetails: function(component , helper){
        var action = component.get("c.getloggedInContactData");
        action.setCallback(this, function(response){
            var stateResponse = response.getState();
            if (stateResponse === "SUCCESS") {              
                var contactRecordId = response.getReturnValue();
                if (!($A.util.isEmpty(contactRecordId) || $A.util.isUndefined(contactRecordId))) {
                    component.set("v.contactId",contactRecordId);
                    console.log('set contactId' + component.get("v.contactId"));
                    //if(component.get('v.changeAddress')=== true){
                    // this.getAddress(component, event, helper);  
                    //} else {
                           
                    //}
                    if(!component.get("v.isAMR")){
                        
                        this.getallAddress(component, event, helper);
                    }
        
                }
            }
            else{
                alert('Error with fetching contactId');
            }
        });
        $A.enqueueAction(action); 
    },
    
    getCountryList: function(component, helper){
        var action = component.get("c.getStates");
        var parcelObject  = component.get("v.parcelObject");
        action.setParams({
            'objObject': parcelObject,
            'fld': 'Country__c'
        });
        var countries = [];
        action.setCallback(this, function(response){
            var stateResponse = response.getState();
            if (stateResponse === "SUCCESS") {              
                var countryList = response.getReturnValue();
                console.log('countryList==' + JSON.stringify(countryList));
                if (!($A.util.isEmpty(countryList) || $A.util.isUndefined(countryList))) {
                    countries.push({
                        class: "optionClass",
                        label: "--- None ---",
                        value: ""
                    });
                }
                for (var i = 0; i < countryList.length; i++) {
                    countries.push({
                        class: "optionClass",
                        label: countryList[i].label,
                        value: countryList[i].value
                    });
                }
                component.set("v.countryList",countryList);
                console.log('set country' + component.get("v.countryList"));
            }
            else{
                alert('Error with fetching Country');
            }
            
        });
        $A.enqueueAction(action); 
    },
    
    getStateList: function(component, helper){
        var action = component.get("c.getStates");
        var parcelObject  = component.get("v.parcelObject");
        action.setParams({
            'objObject': parcelObject,
            'fld': 'MUSW__State__c'
        });
        var states = [];
        action.setCallback(this, function(response){
            var stateResponse = response.getState();
            if (stateResponse === "SUCCESS") {              
                var stateList = response.getReturnValue();
                console.log('stateList'+ JSON.stringify(stateList));
                if (!($A.util.isEmpty(stateList) || $A.util.isUndefined(stateList))) {
                    states.push({
                        class: "optionClass",
                        label: "--- None ---",
                        value: ""
                    });
                }
                for (var i = 0; i < stateList.length; i++) {
                    states.push({
                        class: "optionClass",
                        label: stateList[i].label,
                        value: stateList[i].value
                    });
                }
                component.set("v.stateList",stateList);
                console.log('sateOptions==='+component.get("v.stateList"));
            }
            else{
                alert('Error with fetching State');
            }
            
        });
        $A.enqueueAction(action); 
    },
    
    getCanadianProvince: function(component, helper){
        var action = component.get("c.getStates");
        var parcelObject  = component.get("v.parcelObject");
        action.setParams({
            'objObject': parcelObject,
            'fld': 'Canadian_provinces__c'
        });
        var canadianProvince = [];
        action.setCallback(this, function(response){
            var stateResponse = response.getState();
            if (stateResponse === "SUCCESS") {              
                var canadianProvinceList = response.getReturnValue();
                console.log('canadianProvinceList==' + JSON.stringify(canadianProvinceList));
                if (!($A.util.isEmpty(canadianProvinceList) || $A.util.isUndefined(canadianProvinceList))) {
                    canadianProvince.push({
                        class: "optionClass",
                        label: "--- None ---",
                        value: ""
                    });
                }
                for (var i = 0; i < canadianProvinceList.length; i++) {
                    canadianProvince.push({
                        class: "optionClass",
                        label: canadianProvinceList[i].label,
                        value: canadianProvinceList[i].value
                    });
                }
                component.set("v.canadianProvinceList",canadianProvinceList);
                console.log('set canadian province' + component.get("v.canadianProvinceList"));
            }
            else{
                alert('Error with fetching Canadian Provinces');
            }
            
        });
        $A.enqueueAction(action);
    },
    
    getCountyList: function(component, helper){
        var action = component.get("c.getStates");
        var parcelObject  = component.get("v.parcelObject");
        action.setParams({
            'objObject': parcelObject,
            'fld': 'County__c'
        });
        var counties = [];
        action.setCallback(this, function(response){
            var stateResponse = response.getState();
            if (stateResponse === "SUCCESS") {              
                var countyList = response.getReturnValue();
                console.log('countryList==' + JSON.stringify(countyList));
                if (!($A.util.isEmpty(countyList) || $A.util.isUndefined(countyList))) {
                    counties.push({
                        class: "optionClass",
                        label: "--- None ---",
                        value: ""
                    });
                }
                for (var i = 0; i < countyList.length; i++) {
                    counties.push({
                        class: "optionClass",
                        label: countyList[i].label,
                        value: countyList[i].value
                    });
                }
                component.set("v.countyList",countyList);
                component.set("v.physicalAddressCounty", countyList);
                console.log('set county' + component.get("v.countyList"));
            }
            else{
                alert('Error with fetching Country');
            }
            
        });
        $A.enqueueAction(action); 
    },
    
    cancelAdressHelper: function(component, event){
        var elements = document.getElementsByClassName("addAddress");
        for(var i=0; i<elements.length; i++) {
            elements[i].classList.add('slds-hide');
        }
    },
    
    getValidatedAddressHelper: function(component, event, helper, selectedAddressType, mailingPhysicalAddress, street, street2, state, city, country, county, zip){
        console.log('county==' + county);
        if(street.includes(',')){
            street = street.replace(',', ' ' );
        }
        
        var originalAddress = street+', '+city+', '+state+', '+zip+', '+country;
        console.log('originalAddress==' + originalAddress);
        component.set("v.isAddress2" , false);
        if(!($A.util.isEmpty(street2) || $A.util.isUndefined(street2))){
            component.set("v.isOriginalAdd2" , true);
            component.set("v.isAddress2" , true);
            originalAddress += ', '+street2;
        }
        component.set("v.originalAddress", originalAddress);
        console.log('originalAddress with street2==' + originalAddress);
        var valid = true;
        var regexForUS = /(^[0-9]+[-]*[0-9]+$)/;
        var regexForCanada = /[a-zA-Z][0-9][a-zA-Z](-| |)[0-9][a-zA-Z][0-9]/;;
        if(($A.util.isEmpty(street) || $A.util.isUndefined(street))) {
            valid = false;
        }
        else if(($A.util.isEmpty(city) || $A.util.isUndefined(city))){
            valid = false; 
        }         
            else if(($A.util.isEmpty(state) || $A.util.isUndefined(state))) {
                valid = false;
                
            }
                else if(($A.util.isEmpty(zip) || $A.util.isUndefined(zip))) {
                    valid = false;
                }
        if(!valid){;
                   helper.showToast(component, event, "Error!", "error", "Please fill in all required fields.");
                  }
        
        else if(!regexForUS.test(zip) && country =="United States"){
            helper.showToast(component, event, "Error!", "error", "Please enter numeric value for zip for country United States.");
        }
            else if(!regexForCanada.test(zip) && country =="Canada"){
                helper.showToast(component, event, "Error!", "error", "Please enter ANA NAN format for zip for country Canada.");
            }
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
                                    
                                    if(!($A.util.isEmpty(addr.street2) || $A.util.isUndefined(addr.street2))){
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
    
    showToast : function(component, event, title, type, message) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": title,
            "message": message,
            "type":type
        });
        toastEvent.fire();
    }, 
    
    highlight: function (component, helper,newAddr, oldAddr){
        console.log("highlight start");     
        var newAddress = [];
        newAddress = newAddr.split(',');
        var newAddressline1 = newAddress[0];
        var newCity = newAddress[1];
        var newState = newAddress[2];
        var newZip = newAddress[3];
        var newCountry = newAddress[4];
        var newAddressLine2 = newAddress[5] != null ?newAddress[5].trim() : '';
        console.log('newAddressLine2'+newAddressLine2);
        
        
        var oldAddress = [];
        oldAddress = oldAddr.split(',');
        var oldAddressline1 = oldAddress[0];
        var oldCity = oldAddress[1];
        var oldState = oldAddress[2];
        var oldZip = oldAddress[3];
        var oldCountry = oldAddress[4];
        var oldAddressLine2 = oldAddress[5] != null ? oldAddress[5].trim() : '';
        console.log('oldAddressLine2'+oldAddressLine2);
        var originalAddress;
        if(!($A.util.isEmpty(oldAddressLine2) || $A.util.isUndefined(oldAddressLine2))){
            originalAddress = oldAddressline1+', ' +oldAddressLine2+', '+oldCity+', '+oldState+', '+oldZip+', '+oldCountry; 
        }
        else {
            originalAddress = oldAddressline1+', '+oldCity+', '+oldState+', '+oldZip+', '+oldCountry;}
        component.set("v.originalAddress" , originalAddress);
        
        
        var add1Diff = '';
        var add2Diff = '';
        var cityDiff = '';
        var stateDiff = '';
        var zipDiff = '';
        var isAddressDiff = false;
        if(newAddressline1.toUpperCase() === oldAddressline1.toUpperCase()){
            add1Diff =  newAddressline1;
        }
        else{
            newAddressline1.split('').forEach(function(val, i){
                if (val.toUpperCase() != oldAddressline1.charAt(i).toUpperCase()){
                    add1Diff += '<span class="highlight">'+val+'</span>'; 
                    isAddressDiff = true;
                    component.set("v.isAddressDiff" , isAddressDiff);
                }
                else{
                    add1Diff += val;
                }
            });
        }
        
        console.log('newAddressLine2'+newAddressLine2);
        if(newAddressLine2 != null && newAddressLine2 != '' && oldAddressLine2 != '' && oldAddressLine2 != null){
            newAddressLine2.split('').forEach(function(val, i){
                if (val.toUpperCase() != oldAddressLine2.charAt(i).toUpperCase()){
                    add2Diff += '<span class="highlight">'+val+'</span>';
                    isAddressDiff = true;
                    component.set("v.isAddressDiff" , isAddressDiff);
                } 
                else {
                    add2Diff += val;
                }
                
            });
        }
        console.log('add2Diff=='+add2Diff);
        
        if(newCity.toUpperCase() === oldCity.toUpperCase()){
            cityDiff =  newCity;
        }
        else{
            newCity.split('').forEach(function(val, i){
                if (val.toUpperCase() != oldCity.charAt(i).toUpperCase()){
                    cityDiff += '<span class="highlight">'+val+'</span>'; 
                    isAddressDiff = true;
                    component.set("v.isAddressDiff" , isAddressDiff);
                }
                else{
                    cityDiff += val;
                }
            });
        } 
        if(newState.toUpperCase() === oldState.toUpperCase()){
            stateDiff = newState;
            
        }
        else {
            stateDiff += '<span class="highlight">'+newState+'</span>';
            isAddressDiff = true;
            component.set("v.isAddressDiff" , isAddressDiff);
        }
        
        if(newZip === oldZip){
            zipDiff = newZip;  
        }
        else {
            newZip.split('').forEach(function(val, i){
                if (val.toUpperCase() != oldZip.charAt(i).toUpperCase()){
                    zipDiff += '<span class="highlight">'+val+'</span>'; 
                    isAddressDiff = true;
                    component.set("v.isAddressDiff" , isAddressDiff);
                }
                else{
                    zipDiff += val;
                }
            });
        } 
        var highlightedAddress; 
        if(add2Diff != null && add2Diff != ''){
            console.log('add2Diff!=null');
            highlightedAddress = add1Diff+', ' +add2Diff+', '+cityDiff+', '+stateDiff+', '+zipDiff+', '+newCountry; 
        }
        else {
            highlightedAddress = add1Diff+', ' +cityDiff+', '+stateDiff+', '+zipDiff+', '+newCountry; 
            console.log('add2Diff=null');        }
        
        component.set("v.suggestedAddress" , highlightedAddress);
    },
    
    onsaveAddressHelper : function(component ,event, helper) {
        var accountRecordId= component.get("v.accountId");
        var objectRecordName= component.get("v.objectName");
        var accountOrContactId;
        if($A.util.isEmpty(accountRecordId) || $A.util.isUndefined(accountRecordId) || accountRecordId =='null'){
            accountOrContactId = component.get("v.contactId");
        }else{
            accountOrContactId = component.get("v.accountId");
        }
        console.log('onsaave1----' + accountOrContactId);
        var address; 
        var isAptInfo = component.get("v.isAddress2");
        console.log('isAptInfo=='+ isAptInfo);
        var applicationId = '';
        if(component.get("v.isAMR"))
        {
            applicationId= component.get("v.requestId");
        }
        else
        {
            applicationId= component.get("v.applicationId");
        }
        
        console.log('applicationId=='+ applicationId);
        var selectedAddress = component.get("v.userSelectedAddr");
        var selectedAddressFromDocument = document.querySelector('input[name="locations"]:checked').value;
        console.log('selectedAddress from document===' + selectedAddressFromDocument);
        console.log('selectedAddress===' + selectedAddress);
        if(($A.util.isEmpty(selectedAddress) || $A.util.isUndefined(selectedAddress)) || selectedAddressFromDocument == 'OriginalAddress'){
            selectedAddress = 'OriginalAddress';
        }
        console.log('selectedAddress=='+ selectedAddress);
        var issuggestTrue = component.get("v.isSelectedAddrTrue");
        console.log('issuggestTrue=='+ issuggestTrue);
        var addresstype = component.get("v.selectedAddressType");
        console.log('addresstype=='+ addresstype);
        var isPhysicalAndMailingSame =  component.get("v.isPhysicalAndMailingSame");
        console.log('isPhysicalAndMailingSame on save====' + isPhysicalAndMailingSame);
        var finalAddresstype;
        if(addresstype == 'PHYSICAL ADDRESS' &&  isPhysicalAndMailingSame){
            finalAddresstype = 'MAILING ADDRESS';
        }else{
            finalAddresstype = addresstype;
        }
        console.log('Final address type===' + finalAddresstype);
        var county;
        if(finalAddresstype == 'MAILING ADDRESS'){
            county = component.get("v.selectedCounty");
        }else{
            county = component.get("v.selectedPhysicalCounty");
        }
        console.log('county=== '+ county);
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
            'addresstype' : finalAddresstype,
            'county' : county,
            'accountOrContactId': accountOrContactId,
            'objectRecordName' : objectRecordName,
            'isAMR':component.get("v.isAMR"),
        });
        action.setCallback(this, function(actionResult) {
            if(actionResult.getState() ==="SUCCESS"){ 
                var parcelList = actionResult.getReturnValue();
                console.log("parcelList=="+ JSON.stringify(parcelList));
                console.log('withor json==' + parcelList[0].Address_Type__c);
                component.set("v.Spinner", false);
                component.set("v.isAddAddressClicked",false);
                if(!($A.util.isEmpty(parcelList) || $A.util.isUndefined(parcelList))){
                    if(parcelList[0].Address_Type__c == 'MAILING ADDRESS'){
                        component.set("v.saveAddressList", parcelList);
                        console.log('Entered block 1');
                        component.set("v.mailingAddressparcel.MUSW__Street2__c", parcelList[0].MUSW__Street2__c);
                        component.set("v.mailingAddressparcel.MUSW__City__c", parcelList[0].MUSW__City__c);
                        component.set("v.defaultCountry",parcelList[0].Country__c);
                        if(!($A.util.isEmpty(parcelList[0].County__c) || $A.util.isUndefined(parcelList[0].County__c))){
                            component.set("v.defaultCounty",parcelList[0].County__c);
                            component.set("v.OutOfCountry", true);
                        }else{
                            component.set("v.isOutOfCountry", false);
                        }
                        
                        if(parcelList[0].Country__c =='Canada' ){
                            component.set("v.isCanadianProvince", true);
                            component.set("v.defaultcanadianProvince",parcelList[0].Canadian_provinces__c);
                            component.set("v.isState",false);
                            component.set("v.isNotApplicable",false);
                        }else if(parcelList[0].Country__c =='United States'){
                            component.set("v.isCanadianProvince", false);
                            component.set("v.isNotApplicable",false);
                            component.set("v.isState",true);
                            component.set("v.defaultState",parcelList[0].MUSW__State__c);
                        }
                            else{
                                component.set("v.isNotApplicable",true);
                                component.set("v.isCanadianProvince", false);
                                component.set("v.isState", false);
                            }
                        component.set("v.mailingAddressparcel.Zip_Postal_Code__c", parcelList[0].Zip_Postal_Code__c);
                    }else{
                        console.log('Entered block 2');
                        component.set("v.physicalAddressParcel.MUSW__Street2__c", parcelList[0].MUSW__Street2__c);
                        component.set("v.physicalAddressParcel.MUSW__City__c", parcelList[0].MUSW__City__c);
                        component.set("v.defaultPhysicalCountry",parcelList[0].Country__c);
                        if(!($A.util.isEmpty(parcelList[0].County__c) || $A.util.isUndefined(parcelList[0].County__c))){
                            component.set("v.defaultPhysicalCounty",parcelList[0].County__c);
                            component.set("v.isPhysicalOutOfCountry", true);
                        }else{
                            component.set("v.isPhysicalOutOfCountry", false);
                        }
                        if(parcelList[0].Country__c =='Canada' ){
                            component.set("v.isCanadianProvince", true);
                            component.set("v.defaultPhysicalAddressParcelcanadianProvince",parcelList[0].Canadian_provinces__c);
                            component.set("v.isPhysicalAddressParcelState",false);
                            component.set("v.isPhysicalNotApplicable",false);
                        }else if(parcelList[0].Country__c =='United States'){
                            component.set("v.isPhysicalCanadianProvince", false);
                            component.set("v.isPhysicalNotApplicable",false);
                            component.set("v.isPhysicalState",true);
                            component.set("v.defaultPhysicalState",parcelList[0].MUSW__State__c);
                        }
                            else{
                                component.set("v.isPhysicalNotApplicable",true);
                                component.set("v.isPhysicalCanadianProvince", false);
                                component.set("v.isPhysicalState", false);
                            }
                        component.set("v.physicalAddressParcel.Zip_Postal_Code__c", parcelList[0].Zip_Postal_Code__c);
                        console.log("inside physical address::::");
                        console.log("isRenewal::"+component.get("v.isRenewal"));
                        if(component.get("v.isRenewal")){
                            console.log("inside event call");
                            var compEvent = $A.get("e.c:RefreshComponentEvent"); 
                            compEvent.setParams({"physicalAddressModifiedonRenewal" : "true" });
                            compEvent.fire();
                        }
                    }
                    helper.showToast(component, event, "Success!", "success", "Your address Entry has been successfully created."); 
                }
                else{
                    helper.showToast(component, event, "Error!", "Error", "Error on saving your address Entry."); 
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
            }
            
        });
        $A.enqueueAction(action);
    },    
    
    getallAddress : function(component, event, helper) {
        var accountRecordId= component.get("v.accountId");
        var objectRecordName= component.get("v.objectName");
        console.log('accountRecordId===' + accountRecordId + 'Obhjecjjhjk---' + objectRecordName);  
        var accountOrContactId;
        if($A.util.isEmpty(accountRecordId) || $A.util.isUndefined(accountRecordId) || accountRecordId == 'null'){
            accountOrContactId = component.get("v.contactId");
        }else{
            accountOrContactId = component.get("v.accountId");
        }
        console.log('accountOrContactId on get alladdress=== ' + accountOrContactId);
        var action=component.get("c.getAllAddress");
        action.setParams({accountOrContactId: accountOrContactId });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.allAddressList", response.getReturnValue());
                var allAddressList = component.get("v.allAddressList");
                console.log('allAddressList===' + JSON.stringify(allAddressList));
                if(!($A.util.isEmpty(allAddressList) || $A.util.isUndefined(allAddressList))){
                    for(var i=0; i<allAddressList.length; i++){
                        if(allAddressList[i].Address_Type__c == 'MAILING ADDRESS' && !(allAddressList[i].is_Physical_and_Mailing_Address_Same__c)){
                            console.log('Entered block 1' + allAddressList[i].County__c + allAddressList[i].is_Physical_and_Mailing_Address_Same__c);
                            component.set("v.mailingAddressparcel.MUSW__Street2__c", allAddressList[i].MUSW__Street2__c);
                            component.set("v.mailingAddressparcel.MUSW__City__c", allAddressList[i].MUSW__City__c);
                            component.set("v.defaultCountry",allAddressList[i].Country__c);
                            console.log('Country__c :' +allAddressList[i].Country__c);
                            console.log('defaultCountry :' +component.get("v.defaultCountry"));
                            component.set("v.isPhysicalAndMailingSame", false);
                            if(!($A.util.isEmpty(allAddressList[i].County__c) || $A.util.isUndefined(allAddressList[i].County__c))){
                                component.set("v.defaultCounty",allAddressList[i].County__c);
                                component.set("v.isOutOfCountry", true);
                            }else{
                                component.set("v.isOutOfCountry", false);
                            }
                            if(allAddressList[i].Country__c =='Canada' ){
                                component.set("v.isCanadianProvince", true);
                                component.set("v.defaultcanadianProvince",allAddressList[i].Canadian_provinces__c);
                                component.set("v.isState",false);
                                component.set("v.isNotApplicable",false);
                            }else if(allAddressList[i].Country__c =='United States'){
                                component.set("v.isCanadianProvince", false);
                                component.set("v.isNotApplicable",false);
                                component.set("v.isState",true);
                                component.set("v.defaultState",allAddressList[i].MUSW__State__c);
                            }
                                else{
                                    component.set("v.isNotApplicable",true);
                                    component.set("v.isCanadianProvince", false);
                                    component.set("v.isState", false);
                                }
                            component.set("v.mailingAddressparcel.Zip_Postal_Code__c", allAddressList[i].Zip_Postal_Code__c);
                        }else if(allAddressList[i].Address_Type__c == 'MAILING ADDRESS' && allAddressList[i].is_Physical_and_Mailing_Address_Same__c){
                            console.log('Entered block 2' + allAddressList[i].is_Physical_and_Mailing_Address_Same__c);
                            component.set("v.mailingAddressparcel.MUSW__Street2__c", allAddressList[i].MUSW__Street2__c);
                            component.set("v.mailingAddressparcel.MUSW__City__c", allAddressList[i].MUSW__City__c);
                            component.set("v.physicalAddressParcel.MUSW__Street2__c", allAddressList[i].MUSW__Street2__c);
                            component.set("v.physicalAddressParcel.MUSW__City__c", allAddressList[i].MUSW__City__c);
                            component.set("v.defaultCountry",allAddressList[i].Country__c);
                            component.set("v.defaultPhysicalCountry",allAddressList[i].Country__c);
                            console.log('Country__c :' +allAddressList[i].Country__c);
                            console.log('defaultCountry :' +component.get("v.defaultCountry"));
                            component.set("v.isPhysicalAndMailingSame", true);
                            if(!($A.util.isEmpty(allAddressList[i].County__c) || $A.util.isUndefined(allAddressList[i].County__c))){
                                component.set("v.defaultPhysicalCounty",allAddressList[i].County__c);
                                component.set("v.isPhysicalOutOfCountry", true);
                                component.set("v.defaultCounty",allAddressList[i].County__c);
                                component.set("v.isOutOfCountry", true);
                            }else{
                                component.set("v.isPhysicalOutOfCountry", false);
                                component.set("v.isOutOfCountry", false);
                            }
                            if(allAddressList[i].Country__c =='Canada' ){
                                component.set("v.isPhysicalCanadianProvince", true);
                                component.set("v.defaultPhysicalcanadianProvince",allAddressList[i].Canadian_provinces__c);
                                component.set("v.isPhysicalState",false);
                                component.set("v.isPhysicalNotApplicable",false);
                                component.set("v.isCanadianProvince", true);
                                component.set("v.defaultcanadianProvince",allAddressList[i].Canadian_provinces__c);
                                component.set("v.isState",false);
                                component.set("v.isNotApplicable",false);
                            }else if(allAddressList[i].Country__c =='United States'){
                                component.set("v.isCanadianProvince", false);
                                component.set("v.isNotApplicable",false);
                                component.set("v.isState",true);
                                component.set("v.defaultState",allAddressList[i].MUSW__State__c);
                                component.set("v.isPhysicalCanadianProvince", false);
                                component.set("v.isPhysicalNotApplicable",false);
                                component.set("v.isPhysicalState",true);
                                component.set("v.defaultPhysicalState",allAddressList[i].MUSW__State__c);
                            }
                                else{
                                    component.set("v.isNotApplicable",true);
                                    component.set("v.isCanadianProvince", false);
                                    component.set("v.isState", false);
                                    component.set("v.isPhysicalNotApplicable",true);
                                    component.set("v.isPhysicalCanadianProvince", false);
                                    component.set("v.isPhysicalState", false);
                                }
                            component.set("v.physicalAddressParcel.Zip_Postal_Code__c", allAddressList[i].Zip_Postal_Code__c);
                            component.set("v.mailingAddressparcel.Zip_Postal_Code__c", allAddressList[i].Zip_Postal_Code__c);
                            
                        }else{
                            console.log('Entered block 3');
                            component.set("v.physicalAddressParcel.MUSW__Street2__c", allAddressList[i].MUSW__Street2__c);
                            component.set("v.physicalAddressParcel.MUSW__City__c", allAddressList[i].MUSW__City__c);
                            component.set("v.isPhysicalAndMailingSame", false);
                            component.set("v.defaultPhysicalCountry",allAddressList[i].Country__c);
                            if(!($A.util.isEmpty(allAddressList[i].County__c) || $A.util.isUndefined(allAddressList[i].County__c))){
                                component.set("v.defaultPhysicalCounty",allAddressList[i].County__c);
                                component.set("v.isPhysicalOutOfCountry", true);
                            }else{
                                component.set("v.isPhysicalOutOfCountry", false);
                            }
                            if(allAddressList[i].Country__c =='Canada' ){
                                component.set("v.isCanadianProvince", true);
                                component.set("v.defaultPhysicalcanadianProvince",allAddressList[i].Canadian_provinces__c);
                                component.set("v.isPhysicalState",false);
                                component.set("v.isPhysicalNotApplicable",false);
                            }else if(allAddressList[i].Country__c =='United States'){
                                component.set("v.isPhysicalCanadianProvince", false);
                                component.set("v.isPhysicalNotApplicable",false);
                                component.set("v.isPhysicalState",true);
                                component.set("v.defaultPhysicalState",allAddressList[i].MUSW__State__c);
                            }
                                else{
                                    component.set("v.isPhysicalNotApplicable",true);
                                    component.set("v.isPhysicalCanadianProvince", false);
                                    component.set("v.isPhysicalState", false);
                                }
                            component.set("v.physicalAddressParcel.Zip_Postal_Code__c", allAddressList[i].Zip_Postal_Code__c);
                        }
                        
                    }
                }
                console.log('defaultCountry last:' +component.get("v.defaultCountry"));
            }
            else
            {
                console.log('No existing address');
            }
        });
        $A.enqueueAction(action);
        
    },
    
    //To fetch existing physical address from parcel
    fetchPhysiscalAddHelper: function(component, event, helper){
        var action=component.get("c.getPhysicalAddress");
        action.setParams({licId: component.get("v.amrLicId") });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.physicalAddressParcelAMRRead", response.getReturnValue());
                var allAddressList = component.get("v.allAddressList");
                console.log('allAddressList===' + JSON.stringify(allAddressList));
                /*if(!($A.util.isEmpty(allAddressList) || $A.util.isUndefined(allAddressList))){
                    component.set("v.physicalAddressParcelAMRRead.Address_Type__c", allAddressList.Address_Type__c);
                    component.set("v.physicalAddressParcelAMRRead.MUSW__Street2__c", allAddressList.MUSW__Street2__c);
                    component.set("v.physicalAddressParcelAMRRead.MUSW__Unit__c", allAddressList.MUSW__Unit__c);
                    component.set("v.physicalAddressParcelAMRRead.MUSW__City__c", allAddressList.MUSW__City__c);
                    component.set("v.physicalAddressParcelAMRRead.MUSW__State__c", allAddressList.MUSW__State__c);
                    component.set("v.physicalAddressParcelAMRRead.County__c", allAddressList.County__c);
                    component.set("v.physicalAddressParcelAMRRead.Country__c", allAddressList.Country__c);
                    component.set("v.physicalAddressParcelAMRRead.Zip_Postal_Code__c", allAddressList.Zip_Postal_Code__c);
                }*/
            }
            else
            {
                console.log('No existing address');
            }
        });
        $A.enqueueAction(action);        
    },
    
    //forcontactupdate
    //
    
    /*getAddress : function(component, event, helper) {
        var applicationId= component.get("v.contactId");
        console.log('applicationId=== ' + applicationId);
        console.log('getallAddress started');
        var action=component.get("c.getAddress");
        action.setParams({applicationId: applicationId });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                console.log('getallAddress2');
                component.set("v.allAddressList", response.getReturnValue());
                var allAddressList = component.get("v.allAddressList");
                console.log('allAddressList===' + JSON.stringify(allAddressList));
                if(!($A.util.isEmpty(allAddressList) || $A.util.isUndefined(allAddressList))){
                    for(var i=0; i<allAddressList.length; i++){
                        if(allAddressList[i].Address_Type__c == 'MAILING ADDRESS' && !(allAddressList[i].is_Physical_and_Mailing_Address_Same__c)){
                            console.log('Entered block 1' + allAddressList[i].County__c + allAddressList[i].is_Physical_and_Mailing_Address_Same__c);
                            component.set("v.mailingAddressparcel.MUSW__Street2__c", allAddressList[i].MUSW__Street2__c);
                            component.set("v.mailingAddressparcel.MUSW__City__c", allAddressList[i].MUSW__City__c);
                            component.set("v.defaultCountry",allAddressList[i].Country__c);
                            console.log('Country__c :' +allAddressList[i].Country__c);
                            console.log('defaultCountry :' +component.get("v.defaultCountry"));
                            component.set("v.isPhysicalAndMailingSame", false);
                            if(!($A.util.isEmpty(allAddressList[i].County__c) || $A.util.isUndefined(allAddressList[i].County__c))){
                                component.set("v.defaultCounty",allAddressList[i].County__c);
                                component.set("v.isOutOfCountry", true);
                            }else{
                                component.set("v.isOutOfCountry", false);
                            }
                            if(allAddressList[i].Country__c =='Canada' ){
                                component.set("v.isCanadianProvince", true);
                                component.set("v.defaultcanadianProvince",allAddressList[i].Canadian_provinces__c);
                                component.set("v.isState",false);
                                component.set("v.isNotApplicable",false);
                            }else if(allAddressList[i].Country__c =='United States'){
                                component.set("v.isCanadianProvince", false);
                                component.set("v.isNotApplicable",false);
                                component.set("v.isState",true);
                                component.set("v.defaultState",allAddressList[i].MUSW__State__c);
                            }
                                else{
                                    component.set("v.isNotApplicable",true);
                                    component.set("v.isCanadianProvince", false);
                                    component.set("v.isState", false);
                                }
                            component.set("v.mailingAddressparcel.Zip_Postal_Code__c", allAddressList[i].Zip_Postal_Code__c);
                        }else if(allAddressList[i].Address_Type__c == 'MAILING ADDRESS' && allAddressList[i].is_Physical_and_Mailing_Address_Same__c){
                            console.log('Entered block 2' + allAddressList[i].is_Physical_and_Mailing_Address_Same__c);
                            component.set("v.mailingAddressparcel.MUSW__Street2__c", allAddressList[i].MUSW__Street2__c);
                            component.set("v.mailingAddressparcel.MUSW__City__c", allAddressList[i].MUSW__City__c);
                            component.set("v.physicalAddressParcel.MUSW__Street2__c", allAddressList[i].MUSW__Street2__c);
                            component.set("v.physicalAddressParcel.MUSW__City__c", allAddressList[i].MUSW__City__c);
                            component.set("v.defaultCountry",allAddressList[i].Country__c);
                            component.set("v.defaultPhysicalCountry",allAddressList[i].Country__c);
                            console.log('Country__c :' +allAddressList[i].Country__c);
                            console.log('defaultCountry :' +component.get("v.defaultCountry"));
                            component.set("v.isPhysicalAndMailingSame", true);
                            if(!($A.util.isEmpty(allAddressList[i].County__c) || $A.util.isUndefined(allAddressList[i].County__c))){
                                component.set("v.defaultPhysicalCounty",allAddressList[i].County__c);
                                component.set("v.isPhysicalOutOfCountry", true);
                                component.set("v.defaultCounty",allAddressList[i].County__c);
                                component.set("v.isOutOfCountry", true);
                            }else{
                                component.set("v.isPhysicalOutOfCountry", false);
                                component.set("v.isOutOfCountry", false);
                            }
                            if(allAddressList[i].Country__c =='Canada' ){
                                component.set("v.isPhysicalCanadianProvince", true);
                                component.set("v.defaultPhysicalcanadianProvince",allAddressList[i].Canadian_provinces__c);
                                component.set("v.isPhysicalState",false);
                                component.set("v.isPhysicalNotApplicable",false);
                                component.set("v.isCanadianProvince", true);
                                component.set("v.defaultcanadianProvince",allAddressList[i].Canadian_provinces__c);
                                component.set("v.isState",false);
                                component.set("v.isNotApplicable",false);
                            }else if(allAddressList[i].Country__c =='United States'){
                                component.set("v.isCanadianProvince", false);
                                component.set("v.isNotApplicable",false);
                                component.set("v.isState",true);
                                component.set("v.defaultState",allAddressList[i].MUSW__State__c);
                                component.set("v.isPhysicalCanadianProvince", false);
                                component.set("v.isPhysicalNotApplicable",false);
                                component.set("v.isPhysicalState",true);
                                component.set("v.defaultPhysicalState",allAddressList[i].MUSW__State__c);
                            }
                                else{
                                    component.set("v.isNotApplicable",true);
                                    component.set("v.isCanadianProvince", false);
                                    component.set("v.isState", false);
                                    component.set("v.isPhysicalNotApplicable",true);
                                    component.set("v.isPhysicalCanadianProvince", false);
                                    component.set("v.isPhysicalState", false);
                                }
                            component.set("v.physicalAddressParcel.Zip_Postal_Code__c", allAddressList[i].Zip_Postal_Code__c);
                            component.set("v.mailingAddressparcel.Zip_Postal_Code__c", allAddressList[i].Zip_Postal_Code__c);
                            
                        }else{
                            console.log('Entered block 3');
                            component.set("v.physicalAddressParcel.MUSW__Street2__c", allAddressList[i].MUSW__Street2__c);
                            component.set("v.physicalAddressParcel.MUSW__City__c", allAddressList[i].MUSW__City__c);
                            component.set("v.isPhysicalAndMailingSame", false);
                            component.set("v.defaultPhysicalCountry",allAddressList[i].Country__c);
                            if(!($A.util.isEmpty(allAddressList[i].County__c) || $A.util.isUndefined(allAddressList[i].County__c))){
                                component.set("v.defaultPhysicalCounty",allAddressList[i].County__c);
                                component.set("v.isPhysicalOutOfCountry", true);
                            }else{
                                component.set("v.isPhysicalOutOfCountry", false);
                            }
                            if(allAddressList[i].Country__c =='Canada' ){
                                component.set("v.isCanadianProvince", true);
                                component.set("v.defaultPhysicalcanadianProvince",allAddressList[i].Canadian_provinces__c);
                                component.set("v.isPhysicalState",false);
                                component.set("v.isPhysicalNotApplicable",false);
                            }else if(allAddressList[i].Country__c =='United States'){
                                component.set("v.isPhysicalCanadianProvince", false);
                                component.set("v.isPhysicalNotApplicable",false);
                                component.set("v.isPhysicalState",true);
                                component.set("v.defaultPhysicalState",allAddressList[i].MUSW__State__c);
                            }
                                else{
                                    component.set("v.isPhysicalNotApplicable",true);
                                    component.set("v.isPhysicalCanadianProvince", false);
                                    component.set("v.isPhysicalState", false);
                                }
                            component.set("v.physicalAddressParcel.Zip_Postal_Code__c", allAddressList[i].Zip_Postal_Code__c);
                        }
                        
                    }
                }
                console.log('defaultCountry last:' +component.get("v.defaultCountry"));
            }
            else
            {
                console.log('No existing address');
            }
        });
        $A.enqueueAction(action);
        
    },*/
    //function not working
    setDefaultFields: function(component) {
        component.set("v.street", "");
        component.set("v.street2", "");
        component.set("v.city", "");
        component.set("v.parcelObject.MUSW__State__c", "");
        component.set("v.zip", "");
        console.log('setDefault Start1');
    },
    deleteRecordHelper: function(component, event, helper){
        var parentDiv = event.target.parentNode;
        var appId = parentDiv.firstElementChild.className;
        var addressType = event.getSource().get("v.name");
        var recordId = parentDiv.firstElementChild.id;
        console.log("recordToDelelte"+recordId);  
        console.log('appId'+appId);
        console.log('addressType'+addressType);
        component.get("v.sObjParcel");
        console.log('component.get("v.sObjParcel")'+component.get("v.sObjParcel"));
        var sObj = component.get("v.sObjParcel");
        var action = component.get("c.deleteTableRecord");
        action.setParams({
            recordId : recordId,addrType : addressType,sobjectType : sObj,applicationId : appId 
        });
        action.setCallback(this,function(response){
            var state = response.getState();
            if(state === "SUCCESS"){
                var resultsToast = $A.get("e.force:showToast");
                resultsToast.setParams({
                    "title": "Deleted",
                    "message": "The record was deleted.",
                    "type": "success"
                });
                resultsToast.fire();
                component.set("v.LicenseAddressList", response.getReturnValue());
            }
            else{
                console.log("--Failed--"+state);
            }
        });
        $A.enqueueAction(action);
    },
    
    updateExistingMailingAddress: function(component, event, helper, isChecked){
        var accountOrContactId;
        var addressRecordData= component.get("v.saveAddressList");
        console.log('addressRecordData==' + JSON.stringify(addressRecordData));
        if(!($A.util.isEmpty(addressRecordData) || $A.util.isUndefined(addressRecordData))){
            if($A.util.isEmpty(addressRecordData[0].Primary_Account__c) || $A.util.isUndefined(addressRecordData[0].Primary_Account__c) || addressRecordData[0].Primary_Account__c == 'null'){
                accountOrContactId = addressRecordData[0].MUSW__Primary_Contact__c;
            }else{
                accountOrContactId = addressRecordData[0].Primary_Account__c;
            }
            //var contactRecordId = addressRecordData[0].MUSW__Primary_Contact__c;
            var recordId = addressRecordData[0].Id;
            var sObj = component.get("v.parcelObject");
            console.log('appId==' + appId + 'recordId==' + recordId + 'sObj=' + JSON.stringify(sObj) + 'accountOrContactId=' + accountOrContactId);
            var action = component.get("c.sameAddUpdate");
            action.setParams({
                recordId : recordId,sobjectType : sObj.sobjectType, accountOrContactId : accountOrContactId , isSame: isChecked
            });
            action.setCallback(this,function(response){
                var state = response.getState();
                console.debug('state: '+state);
                if(state === "SUCCESS"){
                    var updatedAddressList = response.getReturnValue();
                    console.log('updatedAddressList===' + JSON.stringify(updatedAddressList));
                    /*this.getallAddress(component, event, helper);
                    var resultsToast = $A.get("e.force:showToast");
                    resultsToast.setParams({
                        "title": "Updated",
                        "message": "The record was updated.",
                        "type": "success"
                    });
                    resultsToast.fire();*/
                }
                else{
                    console.log("--Failed--"+state);
                }
            });
            $A.enqueueAction(action);
        }
    },
    /*onsaveContactAddressHelper : function(component ,event, helper) {
        console.log('onsaave1');
        var address; 
        var isAptInfo = component.get("v.isAddress2");
        console.log('isAptInfo=='+ isAptInfo);
        var contactId= component.get("v.contactId");
        //  console.log('applicationId=='+ applicationId);
        var selectedAddress = component.get("v.userSelectedAddr");
        if(($A.util.isEmpty(selectedAddress) || $A.util.isUndefined(selectedAddress))){
            selectedAddress = 'OriginalAddress';
        }
        console.log('selectedAddress=='+ selectedAddress);
        var issuggestTrue = component.get("v.isSelectedAddrTrue");
        console.log('issuggestTrue=='+ issuggestTrue);
        var addresstype = component.get("v.selectedAddressType");
        console.log('addresstype=='+ addresstype);
        var isPhysicalAndMailingSame =  component.get("v.isPhysicalAndMailingSame");
        console.log('isPhysicalAndMailingSame on save====' + isPhysicalAndMailingSame);
        var finalAddresstype;
        if(addresstype == 'PHYSICAL ADDRESS' &&  isPhysicalAndMailingSame){
            finalAddresstype = 'MAILING ADDRESS';
        }else{
            finalAddresstype = addresstype;
        }
        console.log('Final address type===' + finalAddresstype);
        var county;
        if(finalAddresstype == 'MAILING ADDRESS'){
            county = component.get("v.selectedCounty");
        }else{
            component.get("v.selectedPhysicalCounty");
        }
        console.log('county=== '+ county);
        if(selectedAddress === 'OriginalAddress'){
            address = component.get("v.originalAddress");
        }else if(selectedAddress === 'SuggestedAddress'){
            address = component.get("v.suggestedAddress");
        }
        console.log('address'+ address);
        console.log('isAptInfo'+ isAptInfo);
        var action = component.get("c.updateContactParcel");
        component.set("v.Spinner", true);
        action.setParams({
            'selectedAddress': address,
            'isAptInfo' : isAptInfo,
            'contactId':contactId,
            'issuggestTrue' : issuggestTrue,
            'addresstype' : finalAddresstype,
            'county' : county
        });
        action.setCallback(this, function(actionResult) {
            if(actionResult.getState() ==="SUCCESS"){ 
                var parcelList = actionResult.getReturnValue();
                console.log("parcelList=="+ JSON.stringify(parcelList));
                console.log('withor json==' + parcelList[0].Address_Type__c);
                component.set("v.Spinner", false);
                component.set("v.isAddAddressClicked",false);
                if(!($A.util.isEmpty(parcelList) || $A.util.isUndefined(parcelList))){
                    if(parcelList[0].Address_Type__c == 'MAILING ADDRESS'){
                        component.set("v.saveAddressList", parcelList);
                        console.log('Entered block 1');
                        component.set("v.mailingAddressparcel.MUSW__Street2__c", parcelList[0].MUSW__Street2__c);
                        component.set("v.mailingAddressparcel.MUSW__City__c", parcelList[0].MUSW__City__c);
                        component.set("v.defaultCountry",parcelList[0].Country__c);
                        if(!($A.util.isEmpty(parcelList[0].County__c) || $A.util.isUndefined(parcelList[0].County__c))){
                            component.set("v.defaultCounty",parcelList[0].County__c);
                            component.set("v.OutOfCountry", true);
                        }else{
                            component.set("v.isOutOfCountry", false);
                        }
                        
                        if(parcelList[0].Country__c =='Canada' ){
                            component.set("v.isCanadianProvince", true);
                            component.set("v.defaultcanadianProvince",parcelList[0].Canadian_provinces__c);
                            component.set("v.isState",false);
                            component.set("v.isNotApplicable",false);
                        }else if(parcelList[0].Country__c =='United States'){
                            component.set("v.isCanadianProvince", false);
                            component.set("v.isNotApplicable",false);
                            component.set("v.isState",true);
                            component.set("v.defaultState",parcelList[0].MUSW__State__c);
                        }
                            else{
                                component.set("v.isNotApplicable",true);
                                component.set("v.isCanadianProvince", false);
                                component.set("v.isState", false);
                            }
                        component.set("v.mailingAddressparcel.Zip_Postal_Code__c", parcelList[0].Zip_Postal_Code__c);
                    }else{
                        console.log('Entered block 2');
                        component.set("v.physicalAddressParcel.MUSW__Street2__c", parcelList[0].MUSW__Street2__c);
                        component.set("v.physicalAddressParcel.MUSW__City__c", parcelList[0].MUSW__City__c);
                        component.set("v.defaultPhysicalCountry",parcelList[0].Country__c);
                        if(!($A.util.isEmpty(parcelList[0].County__c) || $A.util.isUndefined(parcelList[0].County__c))){
                            component.set("v.defaultPhysicalCounty",parcelList[0].County__c);
                            component.set("v.isPhysicalOutOfCountry", true);
                        }else{
                            component.set("v.isPhysicalOutOfCountry", false);
                        }
                        if(parcelList[0].Country__c =='Canada' ){
                            component.set("v.isCanadianProvince", true);
                            component.set("v.defaultPhysicalAddressParcelcanadianProvince",parcelList[0].Canadian_provinces__c);
                            component.set("v.isPhysicalAddressParcelState",false);
                            component.set("v.isPhysicalNotApplicable",false);
                        }else if(parcelList[0].Country__c =='United States'){
                            component.set("v.isPhysicalCanadianProvince", false);
                            component.set("v.isPhysicalNotApplicable",false);
                            component.set("v.isPhysicalState",true);
                            component.set("v.defaultPhysicalState",parcelList[0].MUSW__State__c);
                        }
                            else{
                                component.set("v.isPhysicalNotApplicable",true);
                                component.set("v.isPhysicalCanadianProvince", false);
                                component.set("v.isPhysicalState", false);
                            }
                        component.set("v.physicalAddressParcel.Zip_Postal_Code__c", parcelList[0].Zip_Postal_Code__c);
                        console.log("inside physical address::::");
                        console.log("isRenewal::"+component.get("v.isRenewal"));
                        if(component.get("v.isRenewal")){
                            console.log("inside event call");
                            var compEvent = $A.get("e.c:RefreshComponentEvent"); 
                            compEvent.setParams({"physicalAddressModifiedonRenewal" : "true" });
                            compEvent.fire();
                        }
                    }
                    helper.showToast(component, event, "Success!", "success", "Your address Entry has been successfully created."); 
                }
                else{
                    helper.showToast(component, event, "Error!", "Error", "Error on saving your address Entry."); 
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
            }
            
        });
        $A.enqueueAction(action);
    },*/
})