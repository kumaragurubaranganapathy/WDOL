({
    
    doInit : function(component, event, helper) {
        
        helper.addReceiptRecord(component, event);
        
        var action = component.get("c.getPayment");       
        var Customer_Enveloper_PaymentMethods =$A.get("$Label.c.Customer_Enveloper_PaymentMethods");
		var Customer_Enveloper_PaymentMethodsArray = Customer_Enveloper_PaymentMethods.split(',');
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                var paymentMethodMap = [];
                for(var key in result){
                    
                    if(Customer_Enveloper_PaymentMethodsArray.includes(key)){
                        //console.log('*****'+key);
                    	paymentMethodMap.push({key: key, value: result[key]});
                    }    
                }
                component.set("v.paymentMethodMap", paymentMethodMap);
            }
        });
        $A.enqueueAction(action);
       
        
    },
    
    gotoURL:function(component,event,helper){
        //debugger;
        var _receiptList = component.get("v.receiptList"); 
        var isVitalCheck = null;
        if(_receiptList){
            for (var i= 0 ;  i < _receiptList.length  ; i++){
                if(_receiptList[i].MUSW__Payment_Method__c === 'Vitalcheck - Counter' || _receiptList[i].MUSW__Payment_Method__c === 'Vitalcheck - DHP') {
                    isVitalCheck = true;
                }                   
            }
        }
        if(isVitalCheck){
            helper.updateLinkReceiptToCstEnv(component,event);           
        }else {
            var paymentSourceTotal=component.find('paymentSourceTotal').get('v.value');   
            var currentStep = component.get("v.stepNumber");
            currentStep = '3';
            component.set("v.stepNumber",currentStep);
        }        
    },
    
    enableAddButton : function(component,event,helper){
        var paymentType=component.find('paymentType').get('v.value');
        var number=component.find('number').get('v.value');
        var amount=component.find('amountWP').get('v.value');
        
        if((paymentType !='') && (number!='') && (amount!='')){
            component.set("v.isDisabled", false);  
        }
    },
    
    
    addNewRow_ : function(component,event,helper){
        //debugger;   
        var _callType = event.getParam("callType");
        if(_callType === 'update'){
            helper.updateReceiptList(component,event,_callType);
        }else{
            helper.saveRecieptList(component,event);
        }        
    },
    
    goToPaymentSourcePage:function(component,event,helper){
        var currentStep = component.get("v.stepNumber");
        currentStep = '1';
        component.set("v.stepNumber",currentStep);
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
    }
    
})