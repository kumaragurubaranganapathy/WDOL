({
    doInit: function(component, event, helper){
        component.set("v.defaultCountry" , 'United States');
        component.set("v.defaultState" , 'WA');
        component.set("v.defaultCounty" , 'Adams');
        component.set("v.defaultcanadianProvince" , 'British Columbia');
        component.set("v.defaultPhysicalCountry" , 'United States');
        component.set("v.defaultPhysicalState" , 'WA');
        component.set("v.defaultPhysicalcanadianProvince" , 'British Columbia');
        component.set("v.defaultPhysicalCounty" , 'Adams');
        component.set("v.isState", true);
        component.set("v.isOutOfCountry",true);
        component.set("v.isPhysicalState", true);
        component.set("v.isPhysicalOutOfCountry",true);
        helper.getCountryList(component , helper);
        helper.getStateList(component , helper);
        helper.getCountyList(component , helper);
        helper.getCanadianProvince(component , helper);
        if(component.get('v.changeAddress')=== true){
            helper.getAddress(component, event, helper);  
        } else {
             helper.getallAddress(component, event, helper);       
        }

    },
    
    addAddress: function(component, event, helper){  
        console.log('affiliatedLoc==' + component.get("v.affiliatedLoc"));
        var elements = document.getElementsByClassName("addAddress");
        for(var i=0; i<elements.length; i++) {
            elements[i].classList.remove('slds-hide');
        }
    },
    
    getValidatedAddress: function(component, event, helper){
        event.preventDefault();
        var selectedAddressType = event.getSource().get("v.value");
        console.log('selectedAddressType===' + selectedAddressType);
        component.set("v.selectedAddressType", selectedAddressType);
        var street;
        var street2;
        var city;
        var country;
        var state;
        var county;
        var zip;
        var mailingPhysicalAddress;
        var isPhysicalAndMailingSame =  component.get("v.isPhysicalAndMailingSame");
        console.log('isPhysicalAndMailingSame====' + isPhysicalAndMailingSame);
        if(selectedAddressType == 'MAILING ADDRESS' ||  isPhysicalAndMailingSame){
            mailingPhysicalAddress = component.get("v.mailingAddressparcel");
            console.log('address of mailing === ' + JSON.stringify(mailingPhysicalAddress));
            street = mailingPhysicalAddress.MUSW__Street2__c;
            street2 = mailingPhysicalAddress.MUSW__Unit__c; 
            city = mailingPhysicalAddress.MUSW__City__c;
            country = component.get("v.defaultCountry");
            console.log('country==' + country);
            if(country =="United States"){
                state = component.get("v.defaultState");
            }
            else if(country =="Canada"){
                state = component.get("v.defaultcanadianProvince"); 
            }else{
                state = 'Not Applicable';
            }
            console.log('state==' + state);
            if(state =='WA'){
                county = component.get("v.defaultCounty");
            }
            else{
                component.set("v.isOutOfCountry",false);
            }
            component.set("v.selectedCounty",county);
            zip = mailingPhysicalAddress.Zip_Postal_Code__c;
        }else{
            mailingPhysicalAddress = component.get("v.physicalAddressParcel");
            console.log('address=== ' + JSON.stringify(mailingPhysicalAddress));
            street = mailingPhysicalAddress.MUSW__Street2__c;
            street2 = mailingPhysicalAddress.MUSW__Unit__c; 
            city = mailingPhysicalAddress.MUSW__City__c;
            country = component.get("v.defaultPhysicalCountry");
            console.log('country==' + country);
            if(country =="United States"){
                state = component.get("v.defaultPhysicalState");
            }
            else if(country =="Canada"){
                state = component.get("v.defaultPhysicalcanadianProvince"); 
            }else{
                state = 'Not Applicable';
            }
            console.log('state==' + state);
            if(state =='WA'){
                county = component.get("v.defaultPhysicalCounty");
            }
            else{
                component.set("v.isOutOfCountry",false);
            }
            component.set("v.selectedPhysicalCounty",county);
            zip = mailingPhysicalAddress.Zip_Postal_Code__c;
        }
        helper.getValidatedAddressHelper(component, event, helper, selectedAddressType, mailingPhysicalAddress, street, street2, state, city, country, county, zip);
        
    },
    
    cancelAddress: function(component, event, helper){
        helper.cancelAdressHelper(component, event, helper);  
    },
    tolocation: function(component, event, helper){
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url": "/newdashboard"
        });
        urlEvent.fire();
    },
    
    onCountryChange: function(component, event, helper){
        var selectedCountry = event.getSource().get("v.value")
        console.log('component.get("v.isNotApplicable")==' + component.get("v.isNotApplicable"));
        console.log('selectedCountry===' + selectedCountry);
        if(selectedCountry == 'United States'){
            var selectedState = component.get("v.defaultState");
            console.log('selectedState==' + selectedState); 
        }
        if(selectedCountry =='United States' && selectedState=='WA'){
            console.log('Entered condition');
            component.set("v.isOutOfCountry",true);
            component.set("v.isCanadianProvince", false);
            component.set("v.isNotApplicable",false);
            component.set("v.isState",true);
        }else if(selectedCountry =='Canada' ){
            console.log('Entered condition 2');
            component.set("v.isCanadianProvince", true);
            component.set("v.isState",false);
            component.set("v.isNotApplicable",false);
            component.set("v.isOutOfCountry",false);
        }else if(selectedCountry =='United States'){
            console.log('Entered condition 3');
            component.set("v.isCanadianProvince", false);
            component.set("v.isNotApplicable",false);
            component.set("v.isState",true);
            component.set("v.isOutOfCountry",false);
        }
            else{
                console.log('Entered condition 4');
                component.set("v.isNotApplicable",true);
                component.set("v.isCanadianProvince", false);
                component.set("v.isState", false);
                component.set("v.isOutOfCountry",false);
            }
    },
    
    onPhysicalCountryChange:function(component, event, helper){
        var selectedCountry = event.getSource().get("v.value")
        if(selectedCountry == 'United States'){
            var selectedState = component.get("v.defaultPhysicalState");
            console.log('selectedState==' + selectedState); 
        }
        if(selectedCountry =='United States' && selectedState=='WA'){
            console.log('Entered condition');
            component.set("v.isPhysicalOutOfCountry",true);
            component.set("v.isPhysicalCanadianProvince", false);
            component.set("v.isPhysicalNotApplicable",false);
            component.set("v.isPhysicalState",true);
        }else if(selectedCountry =='Canada' ){
            console.log('Entered condition 2');
            component.set("v.isPhysicalCanadianProvince", true);
            component.set("v.isPhysicalState",false);
            component.set("v.isPhysicalNotApplicable",false);
            component.set("v.isPhysicalOutOfCountry",false);
        }else if(selectedCountry =='United States'){
            console.log('Entered condition 3');
            component.set("v.isPhysicalCanadianProvince", false);
            component.set("v.isPhysicalNotApplicable",false);
            component.set("v.isPhysicalState",true);
            component.set("v.isPhysicalOutOfCountry",false);
        }
            else{
                console.log('Entered condition 4');
                component.set("v.isPhysicalNotApplicable",true);
                component.set("v.isPhysicalCanadianProvince", false);
                component.set("v.isPhysicalState", false);
                component.set("v.isPhysicalOutOfCountry",false);
            }
    },
    
    onStateChange: function(component, event, helper){
        var selectedState = event.getSource().get("v.value");
        console.log(event.getSource().get("v.value")); 
        var selectedCountry = component.find("countryPicklist").get("v.value");
        console.log('selectedCountry==' + selectedCountry); 
        if(selectedState =='WA' && selectedCountry=='United States'){
            component.set("v.isOutOfCountry",true);
        }else{
            component.set("v.isOutOfCountry",false);
        }
    },
    
    
    onCityChange : function(component, event, helper){
        console.log('reaching');
        if(component.get("v.mailingAddressparcel.MUSW__City__c") != null && component.get("v.mailingAddressparcel.MUSW__State__c") != null){
        	//helper.countyFetchHelper(component, event, helper);
        }
    },
    
    onPhysicalStateChange: function(component, event, helper){
        var selectedState = event.getSource().get("v.value");
        console.log(event.getSource().get("v.value")); 
        var selectedCountry = component.find("physicalCountryPicklist").get("v.value");
        console.log('selectedCountry==' + selectedCountry); 
        if(selectedState =='WA' && selectedCountry=='United States'){
            component.set("v.isPhysicalOutOfCountry",true);
        }else{
            component.set("v.isPhysicalOutOfCountry",false);
        }
    },
    
    oncanadianProvinceChange: function(component, event, helper){
        var selectedCanadianProvince = event.getSource().get("v.value")
        console.log(event.getSource().get("v.value"));  
    },
    
    onPhysicalcanadianProvinceChange: function(component, event, helper){
        var selectedCanadianProvince = event.getSource().get("v.value")
        console.log(event.getSource().get("v.value"));  
    },
    
    onChange: function(component , event, helper) {
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
    handleCancel: function(component, event, helper) {
        helper.setDefaultFields(component);
        component.set("v.isAddAddressClicked",false);
        
    },
    onsaveAddress: function(component ,event, helper) {
        if(component.get("v.changeAddress")== true) {
           helper.onsaveContactAddressHelper(component ,event, helper); 
        } else {
            helper.onsaveAddressHelper(component ,event, helper); 
        }
       
    },
    handleDelete: function(component ,event, helper) {
        helper.deleteRecordHelper(component, event, helper);
    },
    autoPopulatePhysicalAddress: function(component ,event, helper){
        var physicalCountry = component.get("v.defaultPhysicalCountry");
        console.log('physicalCountry==' + physicalCountry + component.get("v.defaultState"));
        var county = component.get("v.defaultCounty");
        
        var countyValue;
        var isChecked = component.find("isPhysicalAndMailingSame").get("v.checked");
        console.log("isChecked==" + isChecked);
        component.set("v.isPhysicalAndMailingSame", isChecked);
        if(isChecked){
            var mailingPhysicalAddress = component.get("v.mailingAddressparcel");
            var street = mailingPhysicalAddress.MUSW__Street2__c;
            var street2 = mailingPhysicalAddress.MUSW__Unit__c; 
            var city = mailingPhysicalAddress.MUSW__City__c;
            var country = component.get("v.defaultCountry");
            console.log('****county************'+ county);
            if(country =='United States' && component.get("v.defaultState") == 'WA'){
                console.log('Enteredd method===' );
                component.set("v.defaultPhysicalCounty", county);
                component.set("v.isPhysicalOutOfCountry",true);
            }else{
                component.set("v.isPhysicalOutOfCountry",false);
            }
            var zip = mailingPhysicalAddress.Zip_Postal_Code__c;
            component.set("v.defaultPhysicalCountry", country);
            component.set("v.physicalAddressParcel.MUSW__Street2__c", street);
            component.set("v.physicalAddressParcel.MUSW__Unit__c", street2);
            component.set("v.physicalAddressParcel.MUSW__City__c", city);
            if(country =='Canada' ){
                component.set("v.isPhysicalCanadianProvince", true);
                component.set("v.defaultPhysicalcanadianProvince",component.get("v.defaultcanadianProvince"));
                component.set("v.isPhysicalState",false);
                component.set("v.isPhysicalNotApplicable",false);
            }else if(country =='United States'){
                component.set("v.isPhysicalCanadianProvince", false);
                component.set("v.isPhysicalNotApplicable",false);
                component.set("v.isPhysicalState",true);
                component.set("v.defaultPhysicalState",component.get("v.defaultState"));
            }
                else{
                    component.set("v.isPhysicalNotApplicable",true);
                    component.set("v.isPhysicalCanadianProvince", false);
                    component.set("v.isPhysicalState", false);
                }
            component.set("v.physicalAddressParcel.Zip_Postal_Code__c", zip);
            //component.set("v.defaultPhysicalCounty", county);
            helper.updateExistingMailingAddress(component, event, helper, isChecked);
        }else{
            component.set("v.defaultPhysicalCountry", physicalCountry);
            component.set("v.physicalAddressParcel.MUSW__Street2__c", "");
            component.set("v.physicalAddressParcel.MUSW__Unit__c", "");
            component.set("v.physicalAddressParcel.MUSW__City__c", "");
            component.set("v.defaultPhysicalState", component.get("v.defaultPhysicalState"));
            component.set("v.isPhysicalState", true);
            component.set("v.isPhysicalCanadianProvince", false);
            component.set("v.isPhysicalNotApplicable",false);
            component.set("v.physicalAddressParcel.Zip_Postal_Code__c", "");
            component.set("v.physicalAddressParcel.County__c", county);
            helper.updateExistingMailingAddress(component, event, helper, isChecked);
        }
        
    },
	
    handleEvent : function(component,event,helper){
        console.log("inside handleEvent::");
        var isRenewal = event.getParam("isRenewal");
        component.set("v.isRenewal",isRenewal);
        console.log("inside Address"+ component.get("v.isRenewal",isRenewal));
    }
    
})