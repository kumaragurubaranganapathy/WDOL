({
    doinit :  function(component, event, helper){
        debugger;
        helper.enablePrintButton(component,event);
        var _industryFormMap = component.get("v.industryFormMap");
        alert("_industryFormMap" + _industryFormMap);
        if(_industryFormMap){
          // create a empty array for store map keys(@@--->which is controller picklist values) 
                var listOfkeys = []; // for store all map keys (controller picklist values)
                var ControllerField = []; // for store controller picklist value to set on lightning:select. 
                
                // play a for loop on Return map 
                // and fill the all map key on listOfkeys variable.
                for (var singlekey in _industryFormMap) {
                    listOfkeys.push(singlekey);
                }
                
                //set the controller field value for lightning:select
                if (listOfkeys != undefined && listOfkeys.length > 0) {
                    ControllerField.push('--- None ---');
                }
                
                for (var i = 0; i < listOfkeys.length; i++) {
                    ControllerField.push(listOfkeys[i]);
                }  
                // set the ControllerField variable values to country(controller picklist field)
                component.set("v.listControllingValues", ControllerField);   
        }
        
    },
    
    onControllerFieldChange: function(component, event, helper) {     
        debugger;
        var controllerValueKey = event.getSource().get("v.value"); // get selected controller field value
        var depnedentFieldMap = component.get("v.industryFormMap");
        
        if (controllerValueKey != '--- None ---') {
            var ListOfDependentFields = depnedentFieldMap[controllerValueKey];
            
            if(ListOfDependentFields.length > 0){
                component.set("v.bDisabledDependentFld" , false);  
                helper.fetchDepValues(component, ListOfDependentFields);    
            }else{
                component.set("v.bDisabledDependentFld" , true); 
                component.set("v.listDependingValues", ['--- None ---']);
            }  
            
        } else {
            component.set("v.listDependingValues", ['--- None ---']);
            component.set("v.bDisabledDependentFld" , true);
        }
    },
    AddNewRow : function(component, event, helper){
        debugger;
        // fire the AddNewRowEvt Lightning Event 
        var currentAmount = component.find("amount");
        var _depositRec= component.get("v.depositRec");
        if(component.get("v.rowIndex") == 0){
            _depositRec.wadol_Program_Type__c = component.get("v.defaultProgramType") ;
        }    
        if(component.get("v.amountDifference") < currentAmount.get("v.value") || component.get("v.paymentSourceTotal") < currentAmount.get("v.value")  ){            
            alert("Amount Total should be equal to Payment Source Total");
        }else{
            console.log("_depositRec : "+JSON.stringify(_depositRec));
            var _AddRowEvt = component.getEvent("AddRowEvt");
            _AddRowEvt.setParams({"depositInstance" : _depositRec, "callType" : "add"});
            _AddRowEvt.fire();
            
            component.set("v.printDisabled", true);
        }
        
        
    },
    enablePrintButton : function(component,event,helper){
        helper.enablePrintButton(component,event);
    },
    Duplicate_AddNewRow : function(component,event,helper){
        debugger;
        // fire the AddNewRowEvt Lightning Event 
        var currentAmount = component.find("amount");
        var _depositRec= component.get("v.depositRec");
        if(component.get("v.rowIndex") == 0){
            _depositRec.wadol_Program_Type__c = component.get("v.defaultProgramType") ;
        }  
        if(component.get("v.amountDifference") <= currentAmount.get("v.value") || component.get("v.paymentSourceTotal") < currentAmount.get("v.value")  ){            
            alert("Amount Total should be equal to Payment Source Total");
        }else{
            console.log("_depositRec : "+JSON.stringify(_depositRec));
            var _AddRowEvt = component.getEvent("AddRowEvt");
            _AddRowEvt.setParams({"depositInstance" : _depositRec, "callType" : "clone"});
            _AddRowEvt.fire();
            
            component.set("v.cloneDisabled", true);
        }
    },
    
})