({
    doInit : function(component, event, helper) {
        // getValueFromPaymentSource();
        debugger;           
        
        
        
        var action = component.get("c.getProgramType");
        var action1 = component.get("c.getFormNumber");
        var action2 = component.get("c.getDependency");
        // var action3 = component.get("c.getValidationNumberInfo");
        
        var ShowNewResultValue = event.getParam("PassResult");
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                var industryMap = [];
                for(var key in result){
                    industryMap.push({key: key, value: result[key]});
                }
                console.log("IndustryMap : " + industryMap);
                component.set("v.industryMap", industryMap);
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
                console.log("formnum : " + formnum);
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
            console.log('the data is' +JSON.stringify(response.getReturnValue()));           
            if (state === "SUCCESS") {
                component.set("v.industryFormMap",response.getReturnValue());               
                helper.addDepositRecord(component, event);  
            }
        });
        
        /*  action3.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.validationNumber",response.getReturnValue());
            }
        });*/
        
        
        $A.enqueueAction(action);
        $A.enqueueAction(action1);
        $A.enqueueAction(action2);
        // $A.enqueueAction(action3);
        
        
    },
    addNewRow_ : function(component,event,helper){
        debugger;  
        var _callType = event.getParam("callType");
        if(_callType === 'update'){
            helper.updateDepositList(component,event,_callType);
        }else{
            helper.saveDepositList(component,event);
        }
    },
    
    goToCustomerEnvelopePage:function(component,event,helper){
        debugger;
         helper.CreateCERecord(component, event );        
    },
    saveCustomerEnvelopeRecord :function(component, event, helper){
        
        helper.CreateCERecord(component, event );
        // helper.gotoListView(component, event);
    },
    
    goToPaymentSourcePage:function(component,event,helper){
        
        debugger;
        console.log('Enter Here');
        var currentStep = component.get("v.stepNumber");       
        currentStep = '2';        
        component.set("v.stepNumber",currentStep);
        
    },
    
    
    
    addNewRow : function(component,event,helper){
        debugger;
        
        helper.addDepositRecord(component, event);
        helper.updateFields(component, event);        
        helper.saveDepositList(component,event);
        
    },
    
    
    enableAddButton : function(component,event,helper){
        debugger;
        var programType=component.find('programType').get('v.value');
        var formNumber=component.find('formNumber').get('v.value');
        var amountOnLoad=component.find('amountOnLoad').get('v.value');
        
        if((programType !== undefined ) && (formNumber!== undefined) && (amountOnLoad !== undefined)){
            component.set("v.isDisabled", false);  
        }
    },
    
    gotoListView : function (component, event, helper) {
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
        $A.enqueueAction(action);
    },
    
    
    /* getValueFromPaymentSource : function(component, event, helper) {
     // alert('1');
var ShowResultValue = event.getParam("PassResult");
var NewFinal = event.getParam("NewResult");
     
     // alert('inside getvaluefromapp' +ShowResultValue);
// set the handler attributes based on event data
console.log("list of PODs" +JSON.stringify(ShowResultValue));
 // alert('Test '+ShowResultValue);
component.set("v.Get_Result", ShowResultValue);
     component.set("v.NewResult", NewFinal);
}*/
    
})