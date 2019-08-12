({
    doinit : function(component,event,helper){
        debugger;
        component.set("v.stepNumber",'1');
        var value = helper.getParameterByName(component , event, 'inContextOfRef');
        var context = JSON.parse(window.atob(value));
        component.set("v.parentRecordId", context.attributes.recordId);
        
    },
    showToast : function(component,event,helper){
        var toastEvent = $A.get("e.force:showToast");
        if(event.getParam("state")=== 'SUCCESS'){
            toastEvent.setParams({
                title:'Success',
                type : 'success',                
                duration : '1000',
                mode: 'dismissible',
                message: event.getParam("data"),
                
            });
        }else{
            toastEvent.setParams({
                title:'Error',
                type : 'error',                
                duration : '1000',
                mode: 'dismissible',
                message: 'Record creation failed',
                
            }); 
        }      
        
        toastEvent.fire();
    },
    gotoURL:function(component,event,helper){
        console.log('Enter Here');
        var evt = $A.get("e.force:navigateToComponent");
        console.log('evt'+evt);
        evt.setParams({
            componentDef: "c:LnP_PaymentSources",
            //componentAttributes :{ //your attribute}
        });
        
        evt.fire();
        //event.setParam("stepNumber", stepNumber);
        component.set("v.stepNumber",'2');
    },
    assignSteps : function(component,event,helper){
        debugger;
        var _self= this;
        var container= component.find("container");         
        var stepNumber = component.get("v.stepNumber");
        switch(stepNumber){
            case '1': container.set("v.body", []);
                var attributeMap = {"stepNumber":component.getReference("v.stepNumber"),
                                    "defaultProgramType" : component.getReference("v.defaultProgramType"),
                                    "customerEnvelopeRec" : component.getReference("v.customerEnvelopeRec")
                                   };
                helper.createDynamicCompInsideContainer(container, "c:LnP_ProgramType", attributeMap);
                break;
            case '2': container.set("v.body", []);
                var attributeMap = {"stepNumber": component.getReference("v.stepNumber"),
                                    "insertedReceiptList" : component.getReference("v.insertedReceiptList"),
                                    "numOfPaymentSources" : component.getReference("v.numOfPaymentSources"),
                                    "paymentSourceTotal" : component.getReference("v.paymentSourceTotal"),
                                    "customerEnvelopeRec" : component.get("v.customerEnvelopeRec"),
                                    "defaultProgramType" : component.get("v.defaultProgramType"),
                                   };
                helper.createDynamicCompInsideContainer(container, "c:LnP_PaymentSources", attributeMap);
                break;
            case '3' : container.set("v.body", []);
                console.log("Case 3 " + component.get("v.defaultProgramType"));
                var attributeMap = {"stepNumber": component.getReference("v.stepNumber"),
                                    "insertedDepositList" : component.getReference("v.insertedDepositList"),
                                    "insertedReceiptList" : component.getReference("v.insertedReceiptList"),
                                    "numOfPaymentSources" : component.get("v.numOfPaymentSources"),
                                    "paymentSourceTotal" : component.get("v.paymentSourceTotal"),
                                    "numberOfDocuments"  : component.getReference("v.numberOfDocuments"),
                                    "documentTotal" : component.getReference("v.documentTotal"),
                                    "defaultProgramType" : component.get("v.defaultProgramType"),
                                    "customerEnvelopeRec" : component.get("v.customerEnvelopeRec"),
                                    "parentRecordId" : component.get("v.parentRecordId")
                                   };
                helper.createDynamicCompInsideContainer(container, "c:LnP_Documents", attributeMap);
                break;
            default: alert("nothing happened!") ;
        }
    },
    
})