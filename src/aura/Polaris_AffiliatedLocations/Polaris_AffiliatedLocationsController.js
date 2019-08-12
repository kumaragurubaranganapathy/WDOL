({	
    doInit : function(component,event,helper){
        console.log("requestId"+ component.get("v.requestId"));
        console.log("licenseId" + component.get("v.licenseId") );
      	console.log("isAMR" + component.get("v.isAMR"));
        if(component.get("v.isAMR") != true){
            component.set("v.addAction", true);
        }
       	component.set("v.defaultCountry" , 'United States');
        component.set("v.defaultState" , 'WA');
        component.set("v.defaultcanadianProvince" , 'British Columbia');
        component.set("v.isState", true);
        component.set("v.isOutOfCountry",true);
        helper.getCountryList(component , helper);
        helper.getStateList(component , helper);
        helper.getCountyList(component , helper);
        helper.getCanadianProvince(component , helper);
        helper.setLocationTable(component,event,helper); 
    },
	addLocation : function(component,event,helper){
        helper.addLocation(component,event);
    },
    
    cancelLoc : function(component,event,helper){
        helper.cancelLoc(component,event);
    },
    
    onChange : function(component,event,helper){
    	var actionSelected = component.find('select').get('v.value');
        if(actionSelected == "Add Affiliation"){
             component.set("v.addAction", true);
             component.set("v.removeAction", false);
        }else{
            component.set("v.removeAction", true);
            component.set("v.addAction", false);
        }
    },
    
    onSelect : function(component,event,helper){
        console.log("inside");
    	var selected = event.target.getAttribute("data-id");
        console.log('selected::'+ selected);
        
        var value = component.get("v.checkbox");
        var actionType = (value)?false:true;
        console.log('value::'+value);
        component.set("v.checkbox",actionType);
        var locList = component.get("v.locationList");
        if(actionType){
        
            locList.push(selected);
            console.log('locList::'+locList);
        }else{
            locList.remove(selected);
            var filtered = locList.filter(function(value, index, arr){
            
                return value != selected ;
            
            });
           locList =  filtered;
        }
        console.log('locList::'+locList);
        component.set("v.locationList",locList);
        if(component.get("v.locationList").length != 0){
            console.log('inside event ');
            debugger;
            var compEvent = component.getEvent("LnP_Location");
			compEvent.setParams({"callRemoveAffiliate" : true });
			compEvent.fire();
        }
        
    },
    RequestRemove : function(component,event,helper){
        console.log("inside RequestRemove::");
        helper.RemoveAffiliateRequest(component,event,helper);
    },
    onRemoveClick : function(component,event,helper){
        var dataId = event.currentTarget.getAttribute('data-id');
        component.set("v.selectedParcelId",dataId);
        component.set("v.remove",true);
    	helper.removeLocationId(component,event,helper);    
    },
    
    saveLocation : function(component,event,helper){
    if(component.get('v.isAMR') ==  true){
            component.set("v.parcel.Request__c",component.get("v.requestId"));
    }else{
         component.set("v.parcel.Application_BG__c",component.get("v.applicationId") );
    }    
    helper.saveLocation(component,event,helper);
    },
      onCountryChange: function(component, event, helper){
        var selectedCountry = event.getSource().get("v.value")
        component.set("v.parcel.Country__c",selectedCountry );
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
            component.set("v.parcel.Canadian_provinces__c",component.get("v.defaultcanadianProvince"));
        }else if(selectedCountry =='United States'){
            console.log('Entered condition 3');
            component.set("v.isCanadianProvince", false);
            component.set("v.isNotApplicable",false);
            component.set("v.isState",true);
            component.set("v.isOutOfCountry",false);
            component.set("v.parcel.County__c",'Adams');
        }
            else{
                console.log('Entered condition 4');
                component.set("v.isNotApplicable",true);
                component.set("v.isCanadianProvince", false);
                component.set("v.isState", false);
                component.set("v.isOutOfCountry",false);
            }
          
          if(component.get("v.isState")){
              component.set("v.parcel.MUSW__State__c",component.get("v.defaultState"));
          }
    },
    
    onStateChange: function(component, event, helper){
        var selectedState = event.getSource().get("v.value");
        component.set("v.parcel.MUSW__State__c",selectedState);
        console.log(event.getSource().get("v.value")); 
        var selectedCountry = component.find("countryPicklist").get("v.value");
        console.log('selectedCountry==' + selectedCountry); 
        if(selectedState =='WA' && selectedCountry=='United States'){
            component.set("v.isOutOfCountry",true);
        }else{
            component.set("v.isOutOfCountry",false);
        }
    },
    
     oncanadianProvinceChange: function(component, event, helper){
        var selectedCanadianProvince = event.getSource().get("v.value");
        component.set("v.parcel.Canadian_provinces__c",selectedCanadianProvince);
        console.log(event.getSource().get("v.value"));  
    },
    
    onCountyChange : function(component,event,helper){
        var selectedCounty = event.getSource().get("v.value");
        component.set("v.parcel.County__c",selectedCounty);
    }
    
   
})