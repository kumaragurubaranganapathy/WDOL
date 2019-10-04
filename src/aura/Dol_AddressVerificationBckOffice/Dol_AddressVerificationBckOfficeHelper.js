({
    highlight: function (component, helper,newAddr, oldAddr){

        var newAddress = [];
        newAddress = newAddr.split(',');
        var newAddressline1 = newAddress[0];
        var newCity = newAddress[1];
        var newState = newAddress[2];
        var newZip = newAddress[3];
        var newCountry = newAddress[4];
        var newAddressLine2 = newAddress[5] != null ?newAddress[5].trim() : '';


        
    var oldAddress = [];
        oldAddress = oldAddr.split(',');
        var oldAddressline1 = oldAddress[0];
        var oldCity = oldAddress[1];
        var oldState = oldAddress[2];
        var oldZip = oldAddress[3];
        var oldCountry = oldAddress[4];
        var oldAddressLine2 = oldAddress[5] != null ? oldAddress[5].trim() : '';

      var originalAddress;
        if(oldAddressLine2 != null && oldAddressLine2 != ''){
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
        }else if(newAddressLine2 != null && newAddressLine2 != '' && (oldAddressLine2 == '' || oldAddressLine2 == null || oldAddressLine2 == undefined)){
            add2Diff += '<span class="highlight">'+newAddressLine2+'</span>';
        }
        
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
            highlightedAddress = add1Diff+', ' +add2Diff+', '+cityDiff+', '+stateDiff+', '+zipDiff+', '+newCountry; 
        }
        else {
            highlightedAddress = add1Diff+', ' +cityDiff+', '+stateDiff+', '+zipDiff+', '+newCountry; 
     	}
     
      component.set("v.suggestedAddress" , highlightedAddress);
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
            var state = response.getState();
            if (state === "SUCCESS") {              
                var stateList = response.getReturnValue();
                for (var i = 0; i < stateList.length; i++) {
                    states.push({
                        class: "optionClass",
                        label: stateList[i],
                        value: stateList[i]
                    });
                }
                component.find("stateval").set("v.options", states);
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
            var state = response.getState();
            if (state === "SUCCESS") {              
                var countryList = response.getReturnValue();
                /*if (stateList != undefined && stateList.length > 0) {
                    states.push({
                        class: "optionClass",
                        label: "--- None ---",
                        value: ""
                    });
                }*/
                for (var i = 0; i < countryList.length; i++) {
                    countries.push({
                        class: "optionClass",
                        label: countryList[i],
                        value: countryList[i]
                    });
                }
                component.find("countryVal").set("v.options", countries);
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
            var state = response.getState();
            if (state === "SUCCESS") {              
                var countyList = response.getReturnValue();            
                for (var i = 0; i < countyList.length; i++) {
                    counties.push({
                        class: "optionClass",
                        label: countyList[i],
                        value: countyList[i]
                    });
                }
                component.find("county").set("v.options", counties);
            }
            
        });
        $A.enqueueAction(action); 
    },

    onChange : function(component , helper) {
        var selected = document.querySelector('input[name="locations"]:checked').value; 
    },
	getParentId : function(component , helper) {
        var pathname = component.get("v.pathname");
        var objId = '';
        if(pathname.includes('lkid')){
            var splitUrl = pathname.split('lkid');
           if(splitUrl.length > 0){
                var splitFirst = splitUrl[splitUrl.length-1];
               	objId = splitFirst.slice(3, 18);
        	}
        }
        if(objId != '' && objId != undefined){
          component.set("v.navigatetoRelatedList" ,true);
          component.set("v.parentSobjectID" ,objId)
        }
        else{
            component.set("v.parentSobjectID" ,'')
            component.set("v.navigatetoRelatedList" ,false);
        }
        //helper.getParentId(component , helper);
        var parentSobjectID = component.get("v.parentSobjectID");
        var navigatetoRelatedList = component.get("v.navigatetoRelatedList");
   
    },
        
     setDefaultFields: function(component) {
        component.set("v.street", "");
        component.set("v.street2", "");
        component.set("v.city", "");
        component.set("v.parcelObject.MUSW__Country__c", "United States");
        component.set("v.parcelObject.MUSW__State__c", "WA"); 
        component.set("v.isStateWA", true);
        component.set("v.parcelObject.County__c", "Asotin");
        component.set("v.zip", "");
         var a = component.get('c.doinit');
         $A.enqueueAction(a);
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
    getinputAddress: function(component, helper){
        var isIntenationalAddr = component.get("v.isOutOfCountry");
        var street = component.get("v.street");
        var street2 = component.get("v.street2");
        var city = component.get("v.city");
        var state;
        var county;
        if(isIntenationalAddr){
            state = 'Out Of State';
            county = 'Out Of State';
        }
        else{
            var selectedState = component.find("stateval");
        	state = selectedState.get("v.value");
            
            if(state != 'WA'){
               	county = 'Out Of State' 
            }else{
                var selectedcounty = component.find("county");
                county = selectedcounty.get("v.value");         	
            }
        }
        var zip = component.get("v.zip");
        var selectCmp = component.find("countryVal");
        var country = selectCmp.get("v.value");
       
        if(street.includes(',')){
            street = street.replace(',', ' ' );
        }
           
        var originalAddress = '';
        originalAddress+= street+', '+city+', '+state+', '+zip+', '+country;
        if(street2!= null && street2!= undefined && street2!= ''){
            var isAddress2 = component.set("v.isAddress2" , true);
            originalAddress += ', '+street2;
        }
        
        var nonUsAddress = '';
        nonUsAddress+= street;
        if(street2!= null && street2!= undefined && street2!= ''){
            var isAddress2 = component.set("v.isAddress2" , true);
            nonUsAddress+= ', '+street2;
        }
        nonUsAddress+= ', '+city+', '+state+', '+zip+', '+country;
        
        component.set("v.originalAddress", originalAddress);
        component.set("v.nonUsAddress", nonUsAddress);
        component.set("v.countyValue", county);
        component.set("v.Statevalue", state);
        
        
        var valid = true;
        if(street === 'undefined' || street == null || street == "" || city === 'undefined' || city == null || city == "" || state === 'undefined' || state == null || state == "" || zip === 'undefined' || zip== null || zip == "") {
            valid = false;
        }
        /*else if(city === 'undefined' || city == null || city == ""){
             console.log("step3");
           valid = false; 
        }         
        else if(state === 'undefined' || state == null || state == "") {
             console.log("step3");
            valid = false;
        }
        
        else if(zip === 'undefined' || zip== null || zip == "") {
             console.log("step3");
            valid = false;
        } */
        if(!valid){
             this.showToast(component, event, "Error!", "error", "Please fill in all required fields.");
            $A.enqueueAction(action); 
        }
        /*else if(isNaN(zip)){
            this.showToast(component, event, "Error!", "error", "Please enter numeric value for zip.");
        }*/
        //else if(city.includes(',')){
            else if(/[^a-zA-Z \-\/]/.test( city )){
            this.showToast(component, event, "Error!", "error", "Please remove special character from city.");
                $A.enqueueAction(action); 
        }
        //$A.enqueueAction(action); 

    },
    
    getSobjName: function(component, helper){
        helper.getParentId(component , helper);
        var objectID = component.get("v.parentSobjectID");
        if(objectID != null){
            var action = component.get("c.getObjAPI");
            action.setParams({
                'recordId': objectID 
            });
            
            action.setCallback(this, function(response){
                
                var state = response.getState();
                if (state === "SUCCESS") {              
                    var sobjectName = response.getReturnValue();
                    component.set("v.sobjectName", sobjectName);
                }
                
            });
        }
        
        //$A.enqueueAction(action); 
    },
    countyOnCityChange : function(component, event){
        var selectedState = component.find("stateval");
        var stateValue = selectedState.get("v.value");
        var cityValue = component.get("v.city");
        var action = component.get("c.getCountyValue");
        action.setParams({state : stateValue, city : cityValue});
        action.setCallback(this,function(response){
            var state = response.getState();
            
            if(state === "SUCCESS"){
                var result = response.getReturnValue();
                component.set("v.selectedValue",result[0].value);
            }
            else{
                alert('failed');
            }
        });
        $A.enqueueAction(action); 
    },
})