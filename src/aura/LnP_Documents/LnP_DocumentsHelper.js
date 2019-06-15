({ 
    
    addDepositRecord: function(component, event) {
        debugger;
        if( component.find("documentTotal").get('v.value') !== component.get("v.paymentSourceTotal")){
            if(component.get("v.insertedDepositList").length !== 0){
                //back logic
                var _insertedDepositList = [];
                _insertedDepositList = component.get("v.insertedDepositList");  
                //adding the blank record to the existing list 
                _insertedDepositList.push(component.get("v.programType"))   ;
                console.log("original insertedDepositList "+JSON.stringify(component.get("v.insertedDepositList")));
                component.set("v.depositList", _insertedDepositList);   
                _insertedDepositList.pop();
                component.set("v.isDisabledSubmit",false);
            }else{
                var _depositList = component.get("v.depositList");       
                _depositList.push(component.get("v.programType"))   ;           
                component.set("v.depositList", _depositList); 
            }            
        }else{
            component.set("v.isDisabledSubmit",false);
        }
        
        
    },
    updateDepositList : function(component, event,_callType){
        debugger; 
        var _depRecList = event.getParam("depositInstance");   
        console.log("_depRecList : "+JSON.stringify(_depRecList));
        var action = component.get("c.updateDepositRec");        
        action.setParams({
            "depList": _depRecList
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            var _toastEvt = component.getEvent("toastEvt");
            _toastEvt.setParams({'state' : state , 'data' : 'Receipt record updated' });
            _toastEvt.fire();
            if (state === "SUCCESS") {
                console.log("updated Record " + JSON.stringify(response.getReturnValue()));
                var updatedDepositRec = response.getReturnValue();
                var _insertedDepositList = component.get("v.insertedDepositList");
                var _insertedDepositList_Size = _insertedDepositList.length;
                for(var i=0  ; i < _insertedDepositList_Size ; i++){
                    if(_insertedDepositList[i].Id === _insertedDepositList.Id){
                        _insertedDepositList[i] = _insertedDepositList;
                    }
                }
                component.set("v.insertedDepositList",_insertedDepositList);
                this.updateFields(component, event,_callType); 
            }
            
        });
        $A.enqueueAction(action); 
    },
    
    saveDepositList : function(component, event){
        debugger;       
        var _depRecList = event.getParam("depositInstance");    
        var _callType = event.getParam("callType");
        console.log("_depRecList : "+JSON.stringify(_depRecList));
        
        var _insertedDepositList = component.get("v.insertedDepositList");
        
        var action = component.get("c.saveDeposit_Receipt_Records");
        action.setParams({
            "depRecList" : _depRecList
        });        
        action.setCallback(this, function(response) {
            var state = response.getState();           
            if (state === "SUCCESS") {               
                console.log('Deposit records saved successfully');               
                var _toastEvt = component.getEvent("toastEvt");
                _toastEvt.setParams({'state' : state , 'data' : 'Deposit record created.' });
                _toastEvt.fire();
                
                console.log("Response : Deposit List : " + JSON.stringify(response.getReturnValue()));
                var returnDepositRec = response.getReturnValue();                
                component.set("v.depositRec",returnDepositRec);
                
                var _depositList = component.get("v.depositList"); 
                _depositList.pop();
                _depositList.push(returnDepositRec)   ;           
                component.set("v.depositList", _depositList); 
                
                //populating parent list
                _insertedDepositList.push(returnDepositRec);   
                console.log("after insert :" + JSON.stringify(_insertedDepositList));
                component.set("v.insertedDepositList",_insertedDepositList);
                
                //to populate the total fields
                this.updateFields(component, event,_callType);
                
            }
        }); 
        $A.enqueueAction(action);
        
    },
    updateFields : function(component, event,_callType){
        debugger;       
        var _insertedDepositList = component.get("v.insertedDepositList");
        var i,totalAmount = 0, _insertedDepositList_size = _insertedDepositList.length;
        for(i=0 ; i < _insertedDepositList_size ; i++){
            totalAmount = totalAmount + _insertedDepositList[i].Amount__c;
        }
        component.find("numberOfDocuments").set('v.value',_insertedDepositList_size);
        component.find("documentTotal").set('v.value', totalAmount);
        
        if( component.find("documentTotal").get('v.value') === component.get("v.paymentSourceTotal")){
            component.set("v.isDisabledSubmit",false);
        }else{
            var _depositList = component.get("v.depositList");             
            switch(_callType.toUpperCase()){
                    
                case 'ADD' : component.set("v.amountDifference",(component.get("v.paymentSourceTotal") - component.find("documentTotal").get('v.value')));
                    var _programType = {'sobjectType':'MUSW__Deposit__c',
                                        'Amount__c': (component.get("v.paymentSourceTotal") - component.find("documentTotal").get('v.value')) ,
                                        'Form_number__c':'',
                                        'wadol_Program_Type__c':''
                                       };
                    _depositList.push(_programType)   ;           
                    component.set("v.depositList", _depositList);
                    break;
                case 'CLONE' : component.set("v.amountDifference",(component.get("v.paymentSourceTotal") - component.find("documentTotal").get('v.value')));
                    _depositList.push(component.get("v.programType"))   ;           
                    component.set("v.depositList", _depositList);    
                    break;
                case 'UPDATE' : console.log("In progress");
                    break;
                default : console.log("do nothing");
                    
            }
            
        }
        //to disable the Submit and Next button and add new row
        //this.addDepositRecord(component, event);
        
        
    },
    CreateCERecord :function(component, event){
        
        var eventName = event.getSource().get("v.name");
        console.log("eventName : "+eventName);
        debugger;
        var _programType = component.get("v.defaultProgramType");
        var _insertedReceiptList = component.get("v.insertedReceiptList"); 
        var _insertedDepositList = component.get("v.insertedDepositList");
        var _customerEnvelopeRec = component.get("v.customerEnvelopeRec");
        var _parentRecordId = component.get("v.parentRecordId");
        
        var action = component.get("c.updateEnvelopRec");       
        action.setParams({
            "programType" : _programType,
            "recRecLstArr" : _insertedReceiptList,
            "depRecLstArr": _insertedDepositList,
            "customerEnvelopeRec" : _customerEnvelopeRec,
            "parRecordId" : _parentRecordId
            
        });  
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {  
                console.log(JSON.stringify(response.getReturnValue()));
                var _toastEvt = component.getEvent("toastEvt");
                _toastEvt.setParams({'state' : state , 'data' : 'Customer Envelope record created.' });
                _toastEvt.fire();
                //redirect to List view
                if(eventName === 'submit_close'){
                    this.gotoListView(component, event);
                }else if(eventName === 'submit_next'){                    
                    component.set("v.insertedReceiptList",[]);
                    component.set("v.insertedDepositList",[]);
                    var currentStep = component.get("v.stepNumber");       
                    currentStep = '1';      
                    component.set("v.stepNumber",currentStep);
                }
                
            }
        });
        $A.enqueueAction(action);
    },
    
    gotoListView : function (component, event) {
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
    
    
    
    
})