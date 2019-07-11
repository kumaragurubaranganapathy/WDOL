({
    getAddressHelper : function(component, event) {
        try{
            var getLength = event.getSource().get('v.value').length;
            if(getLength >= $A.get("$Label.c.Address_Keyword_Length")){
                var getAdd = component.get("c.getAutoComplete");
                
                getAdd.setParams({strPrefix : component.get("v.parcel.Street__c")});
                getAdd.setCallback(this, function(response){
                    var state = response.getState();
                     if(state === "SUCCESS"){
                        component.set('v.lstAddress',response.getReturnValue());
                        component.set("v.showResults",true);
                    }
                });
                $A.enqueueAction(getAdd);
            }
            else
                component.set("v.showResults",false);
            
            document.onkeydown = keydown;
            function keydown(event) {
                component.set("v.showResults",false);
            }
            
            document.onclick = click;
            function click(event){
                component.set("v.showResults",false);
            }
        }
        catch(e){
            console.error('Error Stack Message for getAddress Helper' + e.stack); 
        }
    },
    
    countyFetchHelper : function(component, event){
		var getState = component.get("v.parcel.State__c");
        //alert('State::'+getState);
        //console.log('typeOf::'+typeOf(getState));
        var getCity = component.get("v.parcel.City__c");
        //alert('City::'+ getCity);
        var action = component.get("c.getCountyValue");

        action.setParams({state : getState, city : getCity});
        action.setCallback(this,function(response){
            var state = response.getState();
            if(state === "SUCCESS"){
                var result = response.getReturnValue();
                //alert('result::'+result[0].value);
                component.set("v.parcel.County__c",result[0].value);
                component.set("v.county",result);
            }
            else{
                alert('failed');
            }
        });
        $A.enqueueAction(action); 
    },
        
    
    selectAddress : function(component, event){
        try{
            var addValue = event.currentTarget.dataset.index;
            var addText = event.currentTarget.dataset.text;
            var add = component.get("v.selAddress");
            
            var addlist = addValue.split('_');
            // component.set("v.parcel.Street__c",addlist);
            component.set("v.parcel.State__c",addlist[1]);
            component.set("v.parcel.City__c",addlist[0]);
            var addTextSplit = addText.split(',');
            //console.log('addTextSplit[0]',addTextSplit[0]);
            component.set("v.prefix", addTextSplit[0]);
            component.set("v.showResults",false);
        }
        catch(e){
            console.error('Error Stack Message for selectAddress Helper' + e.stack); 
        }
    },
    
    saveAddressHelper : function(component, event, helper) {
        var address = component.get("v.parcel");
        address.County__c = component.get("v.parcel.County__c");
        if(address.City__c==''||address.State__c==''||address.County__c==''||address.Country__c==''||address.Zip_Postal_Code__c==''||address.Street__c==''||address.Address_Type__c==''){
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Missing fields!",
                "message": "Missing required fields."
            });
            toastEvent.fire();
        } else{
            helper.getData(component, event, helper);
            var elements = document.getElementsByClassName("addAddress");
            for(var i=0; i<elements.length; i++) {
                elements[i].classList.add('slds-hide');
            }
        }
    },
    
    cancelAdressHelper: function(component, event){
        var elements = document.getElementsByClassName("addAddress");
        for(var i=0; i<elements.length; i++) {
            elements[i].classList.add('slds-hide');
        }
        document.getElementsByClassName("addressTypeSelection")[0].classList.add('slds-hide');
        component.set("v.parcel.Street__c","");
        component.set("v.parcel.City__c","");
        component.set("v.parcel.Unit__c","");
        //component.set("v.parcel.State__c","");
        component.set("v.parcel.County__c","");
        component.set("v.parcel.Country__c","");
        component.set("v.parcel.Zip_Postal_Code__c","");
        component.set("v.parcel.Address_Type__c","--None--");
    },    
    getData : function(component, event, helper) {
        var address = component.get("v.parcel");
        var applicationId = component.get("v.applicationId");
        component.set('v.parcel.Application_BG__c', applicationId);
        var action=component.get("c.getAddressLines");
        if(address.Address_Type__c==''){
            action.setParams({ addr : null, applicationId:applicationId });
        }else{
            action.setParams({ addr : address, applicationId:applicationId });
        }
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.LicenseAddressList", response.getReturnValue());
                component.set("v.isHide",true);
                component.set("v.parcel.Street__c","");
                component.set("v.parcel.City__c","");
                component.set("v.parcel.State__c","");
                component.set("v.parcel.County__c","");
                component.set("v.parcel.Country__c","");
                component.set("v.parcel.Zip_Postal_Code__c","");
                component.set("v.parcel.Address_Type__c","--None--");
            }
            else
            {
                alert('failed');
            }
        });
        $A.enqueueAction(action);
        
    },
    selectExistingAddressHelper : function(component, event, helper) {
        try{
            var CompExAddr = component.get("v.existingAddr");
            var applicationId = component.get("v.applicationId");
            var parentDiv = event.target.parentNode;
            var appId = parentDiv.className;
            var addlist = CompExAddr.split(',');
            var addressType = component.get("v.parcel.Address_Type__c");
            component.set("v.parcel.Address_Type__c ",addressType);
            component.set("v.parcel.Street__c",addlist[0]);
            component.set("v.parcel.Unit__c",addlist[1]);
            component.set("v.parcel.City__c",addlist[2]);
            component.set("v.parcel.County__c",addlist[3])
            component.set("v.parcel.State__c",addlist[4]);
            component.set("v.parcel.Country__c",addlist[5]); 
            component.set("v.parcel.Zip_Postal_Code__c",parseInt(addlist[6]));
            component.set('v.parcel.Application_BG__c', applicationId);
        }
        catch(e){
            console.error('Error Stack Message for selectAddress Helper' + e.stack); 
        }
    },
    deleteRecordHelper : function(component, event, helper){
        var parentDiv = event.target.parentNode;
        var appId = parentDiv.firstElementChild.className;
        var addressType = event.getSource().get("v.name");
        var recordId = parentDiv.firstElementChild.id;
        //    var recordToDelelte = event.target.parentNode.getAttribute("data-data");
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
    /*getStateList: function(component, helper){
          console.log('states');
        var action = component.get("c.getStates");
        var parcelObject  = component.get("v.parcelObject");
        action.setParams({
            'objObject': parcelObject,
            'fld': 'MUSW__State__c'
        });
        var states = [];
        action.setCallback(this, function(response){
            var state = response.getState();
            console.log('sateOptions===');
            if (state === "SUCCESS") {              
                var stateList = response.getReturnValue();
                console.log('stateList'+ stateList);
                if (stateList != undefined && stateList.length > 0) {
                    states.push({
                        class: "optionClass",
                        label: "--- None ---",
                        value: ""
                    });
                }
                for (var i = 0; i < stateList.length; i++) {
                    states.push({
                        class: "optionClass",
                        label: stateList[i],
                        value: stateList[i]
                    });
                }
                component.set("v.selectedState",states[0].value);
                component.set("v.province",states);
                console.log('sateOptions===');
            }
            
        });
        $A.enqueueAction(action); 
    },
    */ 
    onChange : function(component , helper) {
        console.log('radiobutton');
        var selected = document.querySelector('input[name="locations"]:checked').value;
        console.log('selected'+selected);
        //$A.enqueueAction(action); 
    },
    /*toggleClassInverse: function(component,componentId,className) {
        var modal = component.find(componentId);
        $A.util.addClass(modal,className+'hide');
        $A.util.removeClass(modal,className+'open');
    },*/
    setDefaultFields: function(component) {
        component.set("v.street", "");
        component.set("v.street2", "");
        component.set("v.city", "");
        component.set("v.parcelObject.MUSW__State__c", "");
        component.set("v.zip", "");
        console.log('setDefault Start1');
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
    
    getStateList: function(component, helper){
          console.log('states');
        var action = component.get("c.getStates");
        var parcelObject  = component.get("v.parcelObject");
        action.setParams({
            'objObject': parcelObject,
            'fld': 'MUSW__State__c'
        });
        var states = [];
        action.setCallback(this, function(response){
            var state = response.getState();
            console.log('sateOptions===');
            if (state === "SUCCESS") {              
                var stateList = response.getReturnValue();
                console.log('stateList'+ stateList);
                if (stateList != undefined && stateList.length > 0) {
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
                console.log('label and value::'+stateList[4].label+'   '+stateList[4].value);
            }
            else{
                alert('Error with fetching State');
            }
            
        });
        $A.enqueueAction(action); 
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
        
      /*  if (/\s/.test(newCity)) {
        //if(newCity.includes(' ')){
           newCity.split('').forEach(function(val, i){
          if (val.toUpperCase() != oldCity.charAt(i).toUpperCase()){
              cityDiff += '<span class="highlight">'+val+'</span>'; 
                isAddressDiff = true;
                component.set("v.isAddressDiff" , isAddressDiff);
            }else{
              cityDiff += val;
            }
          });    
        }
        else{
           if(newCity.toUpperCase() === oldCity.toUpperCase()){
              cityDiff = newCity;
          }
            else  {
                cityDiff += '<span class="highlight">'+newCity+'</span>'; 
                isAddressDiff = true;
                component.set("v.isAddressDiff" , isAddressDiff);
            } 
        }*/
        
           
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
       /* else {
            var newzip1 = newZip.split('-')[0];
            var newzip2 = newZip.split('-')[1];
            
            var oldzip1 = oldZip.split('-')[0];
            var oldzip2 = oldZip.split('-')[1];
            if(newzip1 != oldzip1){
                //var zipDiff1 = '<span class="highlight">'+newzip1+'</span>';
                zipDiff += '<span class="highlight">'+newzip1+'-'+'</span>';
            }else zipDiff +=newzip1+'-';
            if(newzip2 != oldzip2){
                // var zipDiff2 = '<span class="highlight">'+newzip2+'</span>';
                zipDiff += '<span class="highlight">'+newzip2+'</span>';
            }else zipDiff +=newzip2;
            
            isAddressDiff  = true;
            component.set("v.isAddressDiff" , isAddressDiff);
        } */
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
    getallAddress : function(component, event, helper) {
         var applicationId= component.get("v.applicationId");
        console.log('getallAddress started');
        var action=component.get("c.getAllAddress");
            action.setParams({applicationId: applicationId });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                console.log('getallAddress2');
                component.set("v.LicenseAddressList", response.getReturnValue());
                component.set("v.isHide",true);
                component.set("v.parcel.Street__c","");
                component.set("v.parcel.City__c","");
                component.set("v.parcel.State__c","AL");
                component.set("v.parcel.County__c","");
                component.set("v.parcel.Country__c","");
                component.set("v.parcel.Zip_Postal_Code__c","");
                component.set("v.parcel.Address_Type__c","--None--");
            }
            else
            {
                console.log('no existing address');
            }
        });
        $A.enqueueAction(action);
        
    },
    
    sameAddHelper : function(component, event, helper){
        console.log('Called Helper Controller');
        
        var target = event.target;
        var appId = target.className;
        var recordId = target.id;
        component.get("v.sObjParcel");
        var sObj = component.get("v.sObjParcel");
        var action = component.get("c.sameAddUpdate");
        var finalIsSame = target.checked ;
        if(finalIsSame){
            finalIsSame = true;
        }else{
            finalIsSame = false;
        }
        action.setParams({
            recordId : recordId,sobjectType : sObj,applicationId : appId , isSame: finalIsSame
        });
        action.setCallback(this,function(response){
            var state = response.getState();
            if(state === "SUCCESS"){
                this.getallAddress(component, event, helper);
                var resultsToast = $A.get("e.force:showToast");
                resultsToast.setParams({
                    "title": "Updated",
                    "message": "The record was updated.",
                    "type": "success"
                });
                resultsToast.fire();
                var list = response.getReturnValue();
                for(item in list){
                    if(item.is_Physical_and_Mailing_Address_Same__c){
                        item.is_Physical_and_Mailing_Address_Same__c = "checked";
                    }else{
                        item.is_Physical_and_Mailing_Address_Same__c = "unchecked"
                    }
                }
                component.set("v.LicenseAddressList", list);
                
            }
            else{
                console.log("--Failed--"+state);
            }
        });
        $A.enqueueAction(action);
    }
})