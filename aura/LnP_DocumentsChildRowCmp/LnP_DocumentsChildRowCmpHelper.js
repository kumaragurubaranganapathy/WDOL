({
    enablePrintButton : function(component,event){
        debugger;   
        var depositRec = component.get("v.depositRec");
        var paymentType=component.find('programType').get('v.value');
        var number=component.find('formNumber').get('v.value');
        var amount=component.find('amount').get('v.value');
        if(depositRec.Id){
            component.set("v.printDisabled", true);
            component.set("v.cloneDisabled", true);
            component.set("v.updateDisabled", false);
        }else if(component.get("v.rowIndex") == 0){
            if((paymentType!='')&& (number!='') && (amount!='')){
                component.set("v.printDisabled", false);
                component.set("v.cloneDisabled", false);
            }else{
                component.set("v.printDisabled", true);
                component.set("v.cloneDisabled", true);
            }   
        }else{
            if( (paymentType!='') &&(number!='') && (amount!='')){
                component.set("v.printDisabled", false); 
                component.set("v.cloneDisabled", false);
            }else{
                component.set("v.printDisabled", true);
                component.set("v.cloneDisabled", true);
            }   
        }        
    },
    getDependentFieldValuesOnLoad : function(component, event){
       // var controllerValueKey = event.getSource().get("v.value"); // get selected controller field value
        var depnedentFieldMap = component.get("v.industryFormMap");
        
        //for on Load:
        console.log("Prrogram type "+component.get("v.depositRec").wadol_Program_Type__c )  ;
        if(component.get("v.depositRec").wadol_Program_Type__c !== ''){
            var ListOfDependentFields = depnedentFieldMap[component.get("v.depositRec").wadol_Program_Type__c];
            
            if(ListOfDependentFields.length > 0){
                component.set("v.bDisabledDependentFld" , false);  
                this.fetchDepValues(component, ListOfDependentFields);   
            }
        }
    },
    
    getDependentFieldValues : function(component, event){
        
        var controllerValueKey = event.getSource().get("v.value"); // get selected controller field value
        var depnedentFieldMap = component.get("v.industryFormMap");         
        console.log('controllerValueKey --> ' + controllerValueKey);
        if (controllerValueKey != '') {
            var ListOfDependentFields = depnedentFieldMap[controllerValueKey];
            
            if(ListOfDependentFields.length > 0){
                component.set("v.bDisabledDependentFld" , false);  
                this.fetchDepValues(component, ListOfDependentFields);    
            }else{
                component.set("v.bDisabledDependentFld" , true); 
                component.set("v.listDependingValues", '');
            }  
            
        } else {
            component.set("v.listDependingValues", '');
            component.set("v.bDisabledDependentFld" , true);
        }
    },
    
    fetchDepValues: function(component, ListOfDependentFields) {
        // create a empty array var for store dependent picklist values for controller field  
        var dependentFields = [];
        //  dependentFields.push('--- None ---');
        for (var i = 0; i < ListOfDependentFields.length; i++) {
            dependentFields.push(ListOfDependentFields[i]);
        }
        // set the dependentFields variable values to store(dependent picklist field) on lightning:select
        component.set("v.listDependingValues", dependentFields);
        
    },
})