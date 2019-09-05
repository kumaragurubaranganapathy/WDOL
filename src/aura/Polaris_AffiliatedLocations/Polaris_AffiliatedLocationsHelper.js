({
	addLocation : function(component,event){
        component.set("v.isAddLocation",true);
        
    },
    cancelLoc : function(component,event){
        component.set("v.isAddLocation",false);
    },
    
    saveLocation :  function (component,event,helper){
        var toastEvent;
    console.log('parcel Object::'+ JSON.stringify(component.get("v.parcel")));
    console.log("remove::"+ component.get("v.remove"));
    var action = component.get("c.AffiliatedLocation");
    action.setParams({"parcel" : JSON.stringify(component.get("v.parcel")),
                      "removeLocation" : component.get("v.remove"),
                      "isAMR" : component.get("v.isAMR")});
	action.setCallback(this, function(actionResult) {
            if(actionResult.getState() ==="SUCCESS"){ 
                var Result = actionResult.getReturnValue();
                console.log('Result::'+ Result);
                
                 toastEvent = $A.get("e.force:showToast");
                if(component.get("v.remove")){
                     toastEvent.setParams({
                        "title": 'Success',
                        "message": 'Record Removed Succesfully' ,
                        "type": 'Success'
                    });
                }else{
                    toastEvent.setParams({
                        "title": 'Success',
                        "message": 'Record inserted Succesfully' ,
                        "type": 'Success'
                    });
                }
                toastEvent.fire(); 
                component.set("v.isOneLocation",true);
                component.set("v.isAddLocation",false);
                component.set("v.remove",false);
                helper.setLocationTable(component,event,helper);
                
            }else{
                console.log('Error');
                 toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": 'Error',
                        "message": 'Something Went Wrong' ,
                        "type": 'Error'
                    });
                    toastEvent.fire(); 
            }
         
     });
	 $A.enqueueAction(action);
    
	},
    
    setRequestLocationTable : function(component,event,helper){
   	var action = component.get("c.setRequestLocationTable");
        action.setParams({'requestId': component.get("v.requestId")});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var currentLicenseTableData = JSON.parse(response.getReturnValue());                
                
                var currentLicenseTableColumnData = currentLicenseTableData.tableHeader;
                
                
                var currentLicenseTableHeaderData = currentLicenseTableData.tableData;
               
                component.set("v.requestedLocationTableList",currentLicenseTableHeaderData);
                
                component.set("v.requestedHeaderList",currentLicenseTableColumnData);
              
            } else if (state === "ERROR") {
                var errors = response.getError();                
            }
        });
        $A.enqueueAction(action);
    },
    
    getCountryList: function(component, helper){
        var action = component.get("c.getStates");
      
        action.setParams({
            'objObject': component.get("v.parcel"),
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
                component.set("v.parcel.Country__c",component.get("v.defaultCountry"));
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
        action.setParams({
            'objObject': component.get("v.parcel"),
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
        action.setParams({
            'objObject': component.get("v.parcel"),
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
        action.setParams({
            'objObject': component.get("v.parcel"),
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
                console.log('set county' + component.get("v.countyList"));
                component.set("v.parcel.County__c",'Adams');
            }
            else{
                alert('Error with fetching Country');
            }
            
        });
        $A.enqueueAction(action); 
    },
    
    setLocationTable : function(component,event,helper){
        var action = component.get("c.setLocationTable");
        var applicationId = component.get("v.isAMR") ? component.get("v.licenseId") : component.get("v.applicationId");
        console.log('applicationId::'+applicationId);
        action.setParams({'applicationId': applicationId,
                          'requestId' : component.get("v.requestId"),
                          'isAMR': component.get("v.isAMR")});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var currentLicenseTableData = JSON.parse(response.getReturnValue());                
                
                var currentLicenseTableColumnData = currentLicenseTableData.tableHeader;
                
                
                var currentLicenseTableHeaderData = currentLicenseTableData.tableData;
               
                component.set("v.affLocationTableList",currentLicenseTableHeaderData);
                
                component.set("v.affLocTableColumnsList",currentLicenseTableColumnData);                
                
                console.log("currentLicenseTableColumnData::"+JSON.stringify(currentLicenseTableHeaderData));
                
                console.log("currentLicenseTableColumnheadingsData::"+JSON.stringify(currentLicenseTableColumnData));
                if(currentLicenseTableHeaderData.length != 0){
                     component.set("v.isOneLocation",true); 
                }
              
            } else if (state === "ERROR") {
                var errors = response.getError();                
            }
        });
        $A.enqueueAction(action);
    },
    
    removeLocationId : function(component,event,helper){
    var action = component.get("c.removeLocation");
        var toastEvent = $A.get("e.force:showToast");
    action.setParams({"parcelId" : component.get("v.selectedParcelId"),
                      "isAMR" : component.get("v.isAMR")});
	action.setCallback(this, function(actionResult) {
            if(actionResult.getState() ==="SUCCESS"){ 
                var Result = actionResult.getReturnValue();
                console.log('Result::'+ Result);
                if(Result){
                    
                    if(component.get("v.isAMR")){
                          toastEvent.setParams({
                            "title": 'Success',
                            "message": 'Record removed requested Succesfully' ,
                            "type": 'Success'
                            });  
                    }else{
                        toastEvent.setParams({
                            "title": 'Success',
                            "message": 'Record removed Succesfully' ,
                            "type": 'Success'
                            }); 
                    }
                    
                    toastEvent.fire(); 
                component.set("v.remove",false);
                helper.setLocationTable(component,event,helper);
                }else{
                    
                    toastEvent.setParams({
                        "title": 'Error',
                        "message": 'Something Went Wrong' ,
                        "type": 'Error'
                    });
                    toastEvent.fire(); 
                }
                
            }else{
                console.log('Error');
             
            }
         
     });
	 $A.enqueueAction(action);
    
    },
    
    RemoveAffiliateRequest : function(component,event,helper){
        var action = component.get("c.removeAffiliationRequest");
        action.setParams({
            'parcelIdList': component.get("v.locationList"),
            'RequestId': component.get("v.requestId")
        });
        action.setCallback(this, function(response){
            var stateResponse = response.getState();
            if (stateResponse === "SUCCESS") {              
            	   var Result = response.getReturnValue();
                if(Result){
                    Console.log('Request Updated Succeed');
                }else{
                    Console.log('Request Update Failed');
                }
            }else{
                Console.log('Request Errored');
            }
            
        });
        $A.enqueueAction(action); 
    },
    
    undoAffiliateRequest : function(component,event,helper){
        var action = component.get("c.undoAffiliateRequest");
        action.setParams({"parcelId" : component.get("v.selectedParcelId"),
                      "status" : component.get("v.status"),
                      "license":  component.get("v.licenseData") });
        action.setCallback(this, function(response){
            var stateResponse = response.getState();
            if (stateResponse === "SUCCESS") {              
            	   var Result = response.getReturnValue();
                 helper.setLocationTable(component,event,helper);
                if(Result){
                    console.log('Action Updated Succeed');
                }else{
                    console.log('Action Update Failed');
                }
            }else{
                console.log('Request Errored');
            }
            
        });
        $A.enqueueAction(action); 
    }
    
})