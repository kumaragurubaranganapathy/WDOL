({
    doInit : function(component, event, helper) {
        // getValueFromPaymentSource();
        //debugger;   
        var action = component.get("c.getProgramType");
        var action1 = component.get("c.getFormNumber");
        var action2 = component.get("c.getDependency");
        
        var ShowNewResultValue = event.getParam("PassResult");
        var _invalidValues = $A.get("$Label.c.Polaris_ProgramType");
        var _invalidValuesArr = _invalidValues.split(',');
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                var industryMap = [];
                
                if(result){
                    for(var key in result){                        
                        if(!_invalidValuesArr.includes(key)){
                            industryMap.push({key: key, value: result[key]}); 
                        }                      
                    }
                    //console.log("IndustryMap : " + industryMap);
                    component.set("v.industryMap", industryMap);
                }
                
            }
        });
        action1.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                var formnum = [];
                for(var key in result){
                    formnum.push({key: key, value: result[key]});
                }
                //console.log("formnum : " + formnum);
                component.set("v.formnum", formnum);
            }
        });
        
        action2.setParams({
            "objDetail" : component.get("v.programType"),
            "contrfieldApiName" : "wadol_Program_Type__c",
            "depfieldApiName" : "Form_number__c"
        });
        action2.setCallback(this, function(response) {
            var state = response.getState();
            //console.log('the data is' +JSON.stringify(response.getReturnValue()));           
            if (state === "SUCCESS") {
                component.set("v.industryFormMap",response.getReturnValue());               
                helper.addDepositRecord(component, event);  
            }
        });
        
        $A.enqueueAction(action);
        $A.enqueueAction(action1);
        $A.enqueueAction(action2);
        
        
        
    },
    addNewRow_ : function(component,event,helper){
        //debugger;  
        var _callType = event.getParam("callType");
        if(_callType === 'update'){
            helper.updateDepositList(component,event,_callType);
        }else{
            helper.saveDepositList(component,event);
        }
    },
    
    goToCustomerEnvelopePage:function(component,event,helper){
        //debugger;
        helper.CreateCERecord(component, event );        
    },
    
    saveCustomerEnvelopeRecord :function(component, event, helper){
        
        helper.CreateCERecord(component, event );
        // helper.gotoListView(component, event);
    },
    
    goToPaymentSourcePage:function(component,event,helper){
        
        //debugger;
        //console.log('Enter Here');
        var currentStep = component.get("v.stepNumber");       
        currentStep = '2';        
        component.set("v.stepNumber",currentStep);
        
    },
    
    addNewRow : function(component,event,helper){
        //debugger;
        
        helper.addDepositRecord(component, event);
        helper.updateFields(component, event);        
        helper.saveDepositList(component,event);
        
    },
    
    
    enableAddButton : function(component,event,helper){
        //debugger;
        var programType=component.find('programType').get('v.value');
        var formNumber=component.find('formNumber').get('v.value');
        var amountOnLoad=component.find('amountOnLoad').get('v.value');
        
        if((programType !== undefined ) && (formNumber!== undefined) && (amountOnLoad !== undefined)){
            component.set("v.isDisabled", false);  
        }
    },
    
    gotoListView : function (component, event, helper) {
        //for deleting the Customer Envelope record on failure or cancellations
        var servercall = component.get("c.deleteCustomerEnvelope");
        servercall.setParams({
            "custEnv": component.get("v.customerEnvelopeRec")
        });
        servercall.setCallback(this,function(response){
            var state = response.getState();
            if(state === "SUCCESS"){
                //console.log(JSON.stringify(response.getReturnValue()));
            }
        });      
        
        
        var action = component.get("c.getObjViews");
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                var listviews = response.getReturnValue();
                var navEvent = $A.get("e.force:navigateToList");
                navEvent.setParams({
                    "listViewId": listviews.Id,
                    "listViewName": null,
                    "scope": "Customer_Envelope__c"
                });
                navEvent.fire();
            }
        });
        $A.enqueueAction(servercall);
        $A.enqueueAction(action);
    },
    
})