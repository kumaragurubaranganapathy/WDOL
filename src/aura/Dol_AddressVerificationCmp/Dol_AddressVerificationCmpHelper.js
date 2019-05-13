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
            console.log('step1***');
                newAddressLine2.split('').forEach(function(val, i){
                    console.log('step3***');
                  if (val.toUpperCase() != oldAddressLine2.charAt(i).toUpperCase()){
                        console.log('step4***');
                        add2Diff += '<span class="highlight">'+val+'</span>';
                        isAddressDiff = true;
                        component.set("v.isAddressDiff" , isAddressDiff);
              		} 
                    else {
                        add2Diff += val;
                    	console.log('step5***');
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
                        label: stateList[i],
                        value: stateList[i]
                    });
                }
                component.find("stateval").set("v.options", states);
                console.log('sateOptions===');
            }
            
        });
        $A.enqueueAction(action); 
    },
     
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
})