({
    doinit :  function(component, event, helper){
        debugger;
        //  Added this to show the selected element value.
        var defaultProgramType = component.get("v.defaultProgramType");
        if (defaultProgramType && component.get("v.rowIndex") == 0) {
            var depositRec = component.get("v.depositRec");              
            if(depositRec.wadol_Program_Type__c && depositRec.wadol_Program_Type__c !== defaultProgramType){
                depositRec.wadol_Program_Type__c = component.get("v.changedDefaultProgramType");
            }else{
                depositRec.wadol_Program_Type__c = defaultProgramType; 
            }
            
        }
        helper.enablePrintButton(component,event);
        helper.getDependentFieldValuesOnLoad(component, event);       
        var _industryFormMap = component.get("v.industryFormMap");
    },
    enablePrintButton : function(component,event,helper){        
        helper.enablePrintButton(component,event);
    },    
    onControllerFieldChange: function(component, event, helper) {     
        debugger;
        var _depositRec= component.get("v.depositRec");
        //on change of default types
        component.set("v.changedDefaultProgramType",event.getSource().get("v.value"));
        helper.getDependentFieldValues(component, event);       
    },    
    AddNewRow : function(component, event, helper){
        debugger;
        // fire the AddNewRowEvt Lightning Event 
        
        var currentAmount = component.find("amount");
        var _depositRec= component.get("v.depositRec");
        var Today_date = new Date();
        _depositRec['Sequence_number__c'] = Number(component.get("v.rowIndex"))+1;
        _depositRec['Date__c'] = Today_date;
        
        if(component.get("v.amountDifference") < currentAmount.get("v.value") || component.get("v.paymentSourceTotal") < currentAmount.get("v.value")  ){            
            alert("Amount Total should be equal to Payment Source Total");
        }else{
            console.log("_depositRec : "+JSON.stringify(_depositRec));
            if(parseInt(currentAmount.get("v.value")) === component.get("v.amountDifference")){
                component.set("v.cloneDisabled", true);
                component.set("v.printDisabled", true);
                component.set("v.updateDisabled", false);
                
            }else{
                component.set("v.cloneDisabled", true);
            }
            var _AddRowEvt = component.getEvent("AddRowEvt");
            _AddRowEvt.setParams({"depositInstance" : _depositRec, "callType" : "add"});
            _AddRowEvt.fire();
            
        }
    },   
    Duplicate_AddNewRow : function(component,event,helper){
        debugger;
        // fire the AddNewRowEvt Lightning Event 
        var currentAmount = component.find("amount");
        var _depositRec= component.get("v.depositRec");
        var Today_date = new Date();
        _depositRec['Sequence_number__c'] = Number(component.get("v.rowIndex"))+1;
        _depositRec['Date__c'] = Today_date;
        
        if((component.get("v.rowIndex") == 0 && component.get("v.amountDifference") <= currentAmount.get("v.value")) || 
           component.get("v.paymentSourceTotal") < parseInt(currentAmount.get("v.value")) || 
           (component.get("v.rowIndex") !== 0 && component.get("v.paymentSourceTotal") > currentAmount.get("v.value") &&  component.get("v.amountDifference") < parseInt(currentAmount.get("v.value")) ) ){            
            alert("Amount Total should be equal to Payment Source Total");
        }else{
            console.log("_depositRec : "+JSON.stringify(_depositRec));
            if(parseInt(currentAmount.get("v.value")) === component.get("v.amountDifference")){
                component.set("v.cloneDisabled", true);
                component.set("v.printDisabled", true);
                component.set("v.updateDisabled", false);
                
            }else{
                component.set("v.cloneDisabled", true);
            }
            var _AddRowEvt = component.getEvent("AddRowEvt");
            _AddRowEvt.setParams({"depositInstance" : _depositRec, "callType" : "clone"});
            _AddRowEvt.fire();            
            
        }
    },
    Update_AddNewRow : function(component,event,helper){
        
        var _depositRec= component.get("v.depositRec");    
        console.log("depositRec : "+JSON.stringify(_depositRec));
        var _AddRowEvt = component.getEvent("AddRowEvt");
        _AddRowEvt.setParams({"depositInstance" : _depositRec,"callType" : "update"});
        _AddRowEvt.fire();
        
    },
    
})