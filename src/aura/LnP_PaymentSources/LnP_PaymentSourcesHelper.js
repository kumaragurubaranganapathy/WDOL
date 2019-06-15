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
                this.updateFields(component, event,_callType); 
            }
            
        });
        $A.enqueueAction(action); 
    },
    
    saveRecieptList : function(component, event){
        debugger;
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
            if (state === "SUCCESS") {
                var _toastEvt = component.getEvent("toastEvt");
                _toastEvt.setParams({'state' : state , 'data' : 'Receipt record created.' });
                _toastEvt.fire();
                
                console.log("Response : Receipt List : " + JSON.stringify(response.getReturnValue()));                
                var returnReceiptRec = response.getReturnValue();                
                component.set("v.receiptRec",returnReceiptRec);
                
                var _receiptList = component.get("v.receiptList"); 
                _receiptList.pop();
                _receiptList.push(returnReceiptRec)   ;           
                component.set("v.receiptList", _receiptList); 
                
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
            totalAmount = totalAmount + _insertedReceiptList[i].MUSW__Amount_Tendered__c ;
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
                                              'MUSW__Amount_Tendered__c' : ''
                                             };
                
                _receiptList.push(_paymentType)   ;           
                component.set("v.receiptList", _receiptList);
                break;
            case 'CLONE': 	_receiptList.push(component.get("v.paymentType"))   ;           
                component.set("v.receiptList", _receiptList); 
                break;
            case 'UPDATE' : console.log("in progress");
                break;
            default : console.log("do nothing");
                
        }
        
    } 
})