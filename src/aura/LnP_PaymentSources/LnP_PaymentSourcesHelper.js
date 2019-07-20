({
    addReceiptRecord: function(component, event) {
        //get the account List from component  
        debugger;
        if(component.get("v.insertedReceiptList").length !== 0){
            //back logic
            var _insertedReceiptList = [];
            _insertedReceiptList = component.get("v.insertedReceiptList");  
            //adding the blank record to the exixting list 
            _insertedReceiptList.push(component.get("v.paymentType"))   ;
            console.log("original insertedReceiptList "+JSON.stringify(component.get("v.insertedReceiptList")));
            component.set("v.receiptList", _insertedReceiptList);   
            _insertedReceiptList.pop();
            component.set("v.isDisabled",false);
        }else{
            //next logic
            component.find("numOfPaymentSources").set('v.value',0);
            component.find("paymentSourceTotal").set('v.value',0);
            var _receiptList = component.get("v.receiptList");       
            _receiptList.push(component.get("v.paymentType"))   ;           
            component.set("v.receiptList", _receiptList); 
        }
        
    },
    updateReceiptList : function(component, event,_callType){
        component.set("v.showSpinner", true);
        var _recRecList = event.getParam("receiptInstance");
        console.log("_recRecList : "+JSON.stringify(_recRecList));
        var action = component.get("c.updateRecieptRec");        
        action.setParams({
            "recList": _recRecList
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            var _toastEvt = component.getEvent("toastEvt");
            _toastEvt.setParams({'state' : state , 'data' : 'Receipt record updated' });
            _toastEvt.fire();
            component.set("v.showSpinner", false);
            if (state === "SUCCESS") {
                console.log("updated Record " + JSON.stringify(response.getReturnValue()));
                var updatedReceiptRec = response.getReturnValue();
                var _insertedReceiptList = component.get("v.insertedReceiptList");
                var _insertedReceiptList_Size = _insertedReceiptList.length;
                for(var i=0  ; i < _insertedReceiptList_Size ; i++){
                    if(_insertedReceiptList[i].Id === updatedReceiptRec.Id){
                        console.log("before : "+_insertedReceiptList[i]);
                        _insertedReceiptList[i] = updatedReceiptRec;
                        console.log("after : "+_insertedReceiptList[i]);
                    }
                }
                component.set("v.insertedReceiptList",_insertedReceiptList);
                
                //to clear the non saved data 
                var _receiptList = component.get("v.receiptList"); 
                var _receiptList_size = _receiptList.length;
                for(var i=0 ; i < _receiptList_size ;i++){                   
                    if(!("Id" in _receiptList[i])){
                        _receiptList[i].MUSW__Amount_Tendered__c = '';
                        _receiptList[i].MUSW__Check_Number__c = '';
                        _receiptList[i].MUSW__Payment_Method__c = '';
                        _receiptList[i].IAP_Doc__c = '';
                        _receiptList[i].Sender_Agency__c = '';
                        _receiptList[i].License_Number__c = '';
                        _receiptList[i].Applicant_Name__c = '';
                        _receiptList[i].JV_Number__c = '';
                    }
                }
                component.set("v.receiptList",_receiptList); 
                 
                this.updateFields(component, event,_callType); 
            }
            
        });
        $A.enqueueAction(action); 
    },
    
    saveRecieptList : function(component, event){
        debugger;
        component.set("v.showSpinner", true);
        var _recRecList = event.getParam("receiptInstance");
        //component.set("v.currentReceiptRec",_recRecList);
        var _callType = event.getParam("callType");
        console.log("_recRecList : "+JSON.stringify(_recRecList));
        var _insertedReceiptList = component.get("v.insertedReceiptList");
        
        var action = component.get("c.saveReciptRecords");
        action.setParams({
            "receiptRecord": _recRecList
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            var _toastEvt = component.getEvent("toastEvt");
            _toastEvt.setParams({'state' : state , 'data' : 'Receipt record created.' });
            _toastEvt.fire();
            component.set("v.showSpinner", false);
            if (state === "SUCCESS") {
                
                
                console.log("Response : Receipt List : " + JSON.stringify(response.getReturnValue()));                
                var returnReceiptRec = response.getReturnValue();                
                component.set("v.receiptRec",returnReceiptRec);
                
                var _receiptList = component.get("v.receiptList"); 
                _receiptList.pop();
                _receiptList.push(returnReceiptRec)   ;           
                // component.set("v.receiptList", _receiptList); 
                
                //populating record to parent list
                _insertedReceiptList.push(returnReceiptRec);    
                console.log("after insert :" + JSON.stringify(_insertedReceiptList));
                component.set("v.insertedReceiptList",_insertedReceiptList);
                
                //to populate the total fields
                this.updateFields(component, event,_callType);           
            }else {
                var _toastEvt = component.getEvent("toastEvt");
                _toastEvt.setParams({'state' : state , 'data' : 'Something went Wrong' });
                _toastEvt.fire();
            }
        }); 
        $A.enqueueAction(action); 
        
        
    },
    
    updateFields : function(component, event,_callType){
        debugger;       
        var _insertedReceiptList = component.get("v.insertedReceiptList");
        var i,totalAmount = 0, _insertedReceiptList_size = _insertedReceiptList.length;
        for(i=0 ; i < _insertedReceiptList_size ; i++){
            totalAmount = totalAmount + Number(_insertedReceiptList[i].MUSW__Amount_Tendered__c) ;
        }
        component.find("numOfPaymentSources").set('v.value',_insertedReceiptList_size);
        component.find("paymentSourceTotal").set('v.value', totalAmount);
        component.set("v.isDisabled",false);
        
        
        console.log("payment type :" +JSON.stringify(component.get("v.paymentType")));
        
        //to disable the Submit and Next button and add new row
        var _receiptList = component.get("v.receiptList");  
        
        switch(_callType.toUpperCase()){
            case 'ADD' :  var _paymentType = {'sobjectType': 'MUSW__Receipt__c',
                                              'MUSW__Check_Number__c' : '', 
                                              'MUSW__Amount_Tendered__c' : '',
                                              'IAP_Doc__c': '',
                                              'Sender_Agency__c': '',
                                              'License_Number__c' : '',
                                              'Applicant_Name__c' : '',
                                              'JV_Number__c' :''
                                             };
                
                _receiptList.push(_paymentType)   ;           
                component.set("v.receiptList", _receiptList);
                break;
            case 'CLONE':
                var currentReceiptRec =  component.get("v.receiptRec");
                var _paymentType = {'sobjectType': 'MUSW__Receipt__c',
                                    'MUSW__Payment_Method__c': currentReceiptRec.MUSW__Payment_Method__c,
                                    'MUSW__Check_Number__c' : currentReceiptRec.MUSW__Check_Number__c, 
                                    'MUSW__Amount_Tendered__c' : currentReceiptRec.MUSW__Amount_Tendered__c,
                                    'IAP_Doc__c' : currentReceiptRec.IAP_Doc__c,
                                    'Sender_Agency__c' : currentReceiptRec.Sender_Agency__c,
                                    'License_Number__c' : currentReceiptRec.License_Number__c,
                                    'Applicant_Name__c' : currentReceiptRec.Applicant_Name__c,
                                    'JV_Number__c' : currentReceiptRec.JV_Number__c
                                   };
                _receiptList.push(_paymentType)  ; 
                console.log("IN CLONE : " + JSON.stringify(_receiptList));
                component.set("v.receiptList", _receiptList); 
                
                break;
            case 'UPDATE' : console.log("in progress");
                break;
            default : console.log("do nothing");
                
        }
        
    } ,
    updateLinkReceiptToCstEnv : function(component,event){
        debugger;
          component.set("v.showSpinner", true);
        var _insertedReceiptList = component.get("v.insertedReceiptList"); 
        var _customerEnvelopeRec = component.get("v.customerEnvelopeRec");       
        _customerEnvelopeRec['Number_of_payments__c'] = component.get("v.numOfPaymentSources");
        _customerEnvelopeRec['Total_amount__c'] = component.get("v.paymentSourceTotal");
        _customerEnvelopeRec['wadol_DefaultProgramType__c'] = component.get("v.defaultProgramType");
        var action = component.get("c.updateEnvelopRec");       
        action.setParams({
            "programType" : null,
            "recRecLstArr" : _insertedReceiptList,
            "depRecLstArr": null,
            "customerEnvelopeRec" : _customerEnvelopeRec,
            "parRecordId" : null
            
        });  
        action.setCallback(this, function(response){
            var state = response.getState();
            var _toastEvt = component.getEvent("toastEvt");
            _toastEvt.setParams({'state' : state , 'data' : 'Customer Envelope record created.' });
            _toastEvt.fire();
            component.set("v.showSpinner", false);            
            if (state === "SUCCESS") {                              
                this.gotoListView(component,event);
            }
        });
        $A.enqueueAction(action);
    },
    gotoListView : function(component,event){
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