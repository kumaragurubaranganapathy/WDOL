({
    doInit : function(component, event, helper) {
        debugger;
        
        
        
        var action = component.get("c.getDefaultProgramType");
        //var action1 = component.get("c.getcustomerEnvelopeInfo");
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var result = response.getReturnValue();           
                var industryMap = [];
                if(result){
                    for(var key in result){
                        if( key !== 'Delegated Municipality' && key !== 'Manufactured Homes' && key !== 'Program Unknown' && key !== 'Misc Payments'){
                            industryMap.push({key: key, value: result[key]});
                        }                        
                    }
                    
                    component.set("v.industryMap", industryMap);
                }
            }
        });
        
        /* action1.setCallback(this, function(response) {
                var state = response.getState();
                console.log('the data is' +response.getReturnValue());
                 if (state === "SUCCESS") {
                     component.set("v.customerEnvelopDetails",response.getReturnValue());
                 }
            });
*/            
        var action2 = component.get("c.getValidationNumberInfo");
        action2.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.customerEnvelopeRec",response.getReturnValue());
            }
        });
        
        $A.enqueueAction(action); 
        //   $A.enqueueAction(action1);
        $A.enqueueAction(action2);
        if(component.get("v.defaultProgramType")){
            component.set("v.isDisabled", false);
        }
    },
    
    selectChange: function(component,event,helper) {
        //alert(JSON.stringify(component.get("v.customerEnvelopeRec")));
      //var checkCmp = component.find("dhp");
       // alert("checkCmp : "+checkCmp.get("v.value"));
       // resultCmp = cmp.find("checkResult");
       // resultCmp.set("v.value", ""+checkCmp.get("v.value"));
        
    },
    gotoURL:function(component,event,helper){
        debugger;
        console.log('Enter Here');
        var currentStep = component.get("v.stepNumber");
        currentStep = '2';
        component.set("v.stepNumber",currentStep);
    },
    
    enableNextButton : function(component,event,helper){
        var defaultPgmType=component.find('defaultPgmType').get('v.value');
        if(defaultPgmType !=null || defaultPgmType!= ''){
            component.set("v.isDisabled", false);  
        }
    },
    gotoListView : function (component, event, helper) {
        debugger;
        var servercall = component.get("c.deleteCustomerEnvelope");
        servercall.setParams({
            "custEnv": component.get("v.customerEnvelopeRec")
        });
        servercall.setCallback(this,function(response){
            var state = response.getState();
            if(state === "SUCCESS"){
                console.log(JSON.stringify(response.getReturnValue()));
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
    }
    
})