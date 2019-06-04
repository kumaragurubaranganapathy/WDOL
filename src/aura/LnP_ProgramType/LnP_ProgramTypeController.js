({
        doInit : function(component, event, helper) {
            debugger;
        var action = component.get("c.getDefaultProgramType");
        //var action1 = component.get("c.getcustomerEnvelopeInfo");
        var action2 = component.get("c.getValidationNumberInfo");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                var industryMap = [];
                for(var key in result){
                    industryMap.push({key: key, value: result[key]});
                }
                component.set("v.industryMap", industryMap);
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
               action2.setCallback(this, function(response) {
                var state = response.getState();
                 if (state === "SUCCESS") {
                     component.set("v.customerEnvelopeRec",response.getReturnValue());
                 }
            });
            
             $A.enqueueAction(action); 
          //   $A.enqueueAction(action1);
            $A.enqueueAction(action2);
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
}
        
    })