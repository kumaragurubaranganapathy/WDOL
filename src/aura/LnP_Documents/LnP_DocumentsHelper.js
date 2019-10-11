({ 
    
    addDepositRecord: function(component, event) {
        //debugger;
        //below if logic will limit the creation of child row once 'documentTotal' == 'paymentSourceTotal'
        if( component.find("documentTotal").get('v.value') <= component.get("v.paymentSourceTotal")){
            //below if checks is for back logic : if the already inserted record have value then use 'insertedDepositList' for iteration 
            if(component.get("v.insertedDepositList").length !== 0){              
                var _insertedDepositList = [];
                _insertedDepositList = component.get("v.insertedDepositList");  
                //adding the blank record to the existing list 
                if(component.find("documentTotal").get('v.value') !== component.get("v.paymentSourceTotal")){
                    _insertedDepositList.push(component.get("v.programType"))   ;
                    component.set("v.depositList", _insertedDepositList);   
                    _insertedDepositList.pop();
                }else{
                    component.set("v.isDisabledSubmit",false);
                    component.set("v.depositList", _insertedDepositList); 
                }              
                //console.log("original insertedDepositList "+JSON.stringify(component.get("v.insertedDepositList")));
                
                //component.set("v.isDisabledSubmit",false);
            }else{
                //else use the new 'depositList' for iteration
                var _depositList = component.get("v.depositList");       
                _depositList.push(component.get("v.programType"))   ;           
                component.set("v.depositList", _depositList); 
            }            
        }else{
            component.set("v.isDisabledSubmit",false);
        }
        
        
    },
    
    //this function will execute when there is a update call from Child row
    updateDepositList : function(component, event,_callType){
        //debugger; 
        
        var _insertedDepositList = component.get("v.insertedDepositList");
        var savedTotalAmount = 0;
        var _insertedDepositList_Size = _insertedDepositList.length;
        for(var i=0  ; i < _insertedDepositList_Size ; i++){
            savedTotalAmount += parseInt(_insertedDepositList[i].Amount__c);
        }
        //this logic if checks once document total == payment source total then no furture updates should happen
        if(component.get("v.paymentSourceTotal") < savedTotalAmount){
            alert("Amount Total should be equal to Payment Source Total");
        }else{    
            //else update the current record
            component.set("v.showSpinner", true);       
            var _depRecList = event.getParam("depositInstance");   
            //console.log("_depRecList : "+JSON.stringify(_depRecList));
            var action = component.get("c.updateDepositRec");        
            action.setParams({
                "depList": _depRecList
            });
            action.setCallback(this, function(response) {
                component.set("v.showSpinner", false);
                var state = response.getState();
                var _toastEvt = component.getEvent("toastEvt");
                _toastEvt.setParams({'state' : state , 'data' : 'Receipt record updated' });
                _toastEvt.fire();
                
                if (state === "SUCCESS") {
                    //console.log("updated Record " + JSON.stringify(response.getReturnValue()));
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
            
        }//if-else close
        
        
    },
    //this function will execute when there is a add or clone call from Child row
    saveDepositList : function(component, event){
        //debugger;   
        component.set("v.showSpinner", true);
        var _depRecList = event.getParam("depositInstance");    
        var _callType = event.getParam("callType");
        //console.log("_depRecList : "+JSON.stringify(_depRecList));
        
        var _insertedDepositList = component.get("v.insertedDepositList");
        
        var action = component.get("c.saveDeposit_Receipt_Records");
        action.setParams({
            "depRecList" : _depRecList
        });        
        action.setCallback(this, function(response) {
            
            var state = response.getState();  
            var _toastEvt = component.getEvent("toastEvt");
            _toastEvt.setParams({'state' : state , 'data' : 'Deposit record created.' });
            _toastEvt.fire();
            component.set("v.showSpinner", false);
            
            if (state === "SUCCESS") {               
                //console.log('Deposit records saved successfully');               
                
                //console.log("Response : Deposit List : " + JSON.stringify(response.getReturnValue()));
                var returnDepositRec = response.getReturnValue();                
                component.set("v.depositRec",returnDepositRec);
                
                var _depositList = component.get("v.depositList"); 
                _depositList.pop();
                _depositList.push(returnDepositRec)   ;           
                //component.set("v.depositList", _depositList); 
                
                //populating parent list
                _insertedDepositList.push(returnDepositRec);   
                //console.log("after insert :" + JSON.stringify(_insertedDepositList));
                component.set("v.insertedDepositList",_insertedDepositList);
                
                //to populate the total fields
                this.updateFields(component, event,_callType);
                
            }
        }); 
        $A.enqueueAction(action);
        
    },
    
    // this function will update the 'depositList' child iteration according to Add or clone cal from Child 
    // also update the fields 'numberOfDocuments' and 'documentTotal' on parent 
    updateFields : function(component, event,_callType){
        //debugger;       
        var _insertedDepositList = component.get("v.insertedDepositList");
        var i,totalAmount = 0, _insertedDepositList_size = _insertedDepositList.length;
        for(i=0 ; i < _insertedDepositList_size ; i++){
            totalAmount = Number((totalAmount + Number(_insertedDepositList[i].Amount__c)).toFixed(2));
        }
        component.find("numberOfDocuments").set('v.value',_insertedDepositList_size);
        component.find("documentTotal").set('v.value', totalAmount);
        var _depositList ;
        if( component.find("documentTotal").get('v.value') === component.get("v.paymentSourceTotal")){
            component.set("v.isDisabledSubmit",false);
            //console.log("_callType : "+_callType);
            if(_callType.toUpperCase() === 'ADD' || _callType.toUpperCase() === 'CLONE'){
                 _depositList = component.get("v.depositList");           
                component.set("v.depositList", _depositList); 
            }
            
        }else{
             _depositList = component.get("v.depositList");             
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
                    var currentDepositRec = component.get("v.depositRec");
                    var _programType = {'sobjectType':'MUSW__Deposit__c',
                                        'Amount__c':  currentDepositRec.Amount__c,
                                        'Form_number__c': currentDepositRec.Form_number__c,
                                        'wadol_Program_Type__c': currentDepositRec.wadol_Program_Type__c
                                       };
                    _depositList.push(_programType)   ;                        
                    component.set("v.depositList", _depositList);    
                    break;
                case 'UPDATE' : component.set("v.amountDifference",(component.get("v.paymentSourceTotal") - component.find("documentTotal").get('v.value')));
                    break;
                default : console.log("do nothing");
                    
            }
            
        }
        
    },
    
    //this function will link the deposit and receipt records to the customer envelope record in backend 
    //also calls the basic-gov api to link the receipt and deposit through 'Payable Receipt' junction object
    CreateCERecord :function(component, event){
        component.set("v.showSpinner", true);
        var eventName = event.getSource().get("v.name");
        //console.log("eventName : "+eventName);
        //debugger;
        var _programType = component.get("v.defaultProgramType");
        var _insertedReceiptList = component.get("v.insertedReceiptList"); 
        var _insertedDepositList = component.get("v.insertedDepositList");
        var _customerEnvelopeRec = component.get("v.customerEnvelopeRec");
        _customerEnvelopeRec['Number_of_documents__c'] = component.find("numberOfDocuments").get('v.value');
        _customerEnvelopeRec['Number_of_payments__c'] = component.get("v.numOfPaymentSources");
        _customerEnvelopeRec['Total_amount__c'] = component.get("v.paymentSourceTotal");
        _customerEnvelopeRec['wadol_DefaultProgramType__c'] = component.get("v.defaultProgramType");
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
            var _toastEvt = component.getEvent("toastEvt");
            _toastEvt.setParams({'state' : state , 'data' : 'Customer Envelope record created.' });
            _toastEvt.fire();
            component.set("v.showSpinner", false);
            
            if (state === "SUCCESS") { 
                //console.log(JSON.stringify(response.getReturnValue()));
                //redirect to List view
                if(eventName === 'submit_close'){
                    this.gotoListView(component, event);
                }else if(eventName === 'submit_next'){                    
                    component.set("v.insertedReceiptList",[]);
                    component.set("v.insertedDepositList",[]);
                    component.set("v.numberOfDocuments",0);
                    component.set("v.documentTotal",0);
                    var currentStep = component.get("v.stepNumber");       
                    currentStep = '1';      
                    component.set("v.stepNumber",currentStep);
                }
                
            }
        });
        $A.enqueueAction(action);
    },
    
    //function will redirect this back to customer envelope list view
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