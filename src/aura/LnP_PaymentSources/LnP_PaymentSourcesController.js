({

      doInit : function(component, event, helper) {
        var action = component.get("c.getPayment");
        var action1 = component.get("c.getReceiptInfo");
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
          
          action1.setCallback(this, function(response) {
                var state = response.getState();
                console.log('the data is' +response.getReturnValue());
                 if (state === "SUCCESS") {
                     component.set("v.receiptDetails",response.getReturnValue());
                 }
            });
           action2.setCallback(this, function(response) {
                var state = response.getState();
                 if (state === "SUCCESS") {
                     component.set("v.validationNumber",response.getReturnValue());
                 }
            });
            
          
        $A.enqueueAction(action);
        $A.enqueueAction(action1);
        $A.enqueueAction(action2);
      },
    
    gotoURL:function(component,event,helper){
       var paymentSourceTotal=component.find('paymentSourceTotal').get('v.value');   
        var currentStep = component.get("v.stepNumber");
        currentStep = '3';
        component.set("v.stepNumber",currentStep);
      /*  var resultData = $A.get("e.c:Result");
        //alert("paymentSourceTotal"+'Result'+resultData);
        resultData.setParams({"PassResult" : paymentSourceTotal, "NewResult" : 44});
        //alert("after setting params"+resultData);
        resultData.fire();*/
    },
    
     enableAddButton : function(component,event,helper){
        var paymentType=component.find('paymentType').get('v.value');
        var number=component.find('number').get('v.value');
        var amount=component.find('amountWP').get('v.value');
       
        if((paymentType !='') && (number!='') && (amount!='')){
          component.set("v.isDisabled", false);  
        }
    },
  
    
    addNewRow : function(component,event,helper){
       debugger;
         helper.addReceiptRecord(component, event);
        helper.updateFields(component, event);
        helper.saveRecieptList(component,event);
    },
   
    goToPaymentSourcePage:function(component,event,helper){
        var currentStep = component.get("v.stepNumber");
        currentStep = '1';
        component.set("v.stepNumber",currentStep);
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