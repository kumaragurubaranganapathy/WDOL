({ 
    
    addDepositRecord: function(component, event) {
        debugger;
        if( component.find("documentTotal").get('v.value') !== component.get("v.paymentSourceTotal")){
         var _depositList = component.get("v.depositList");       
         _depositList.push(component.get("v.programType"))   ;           
         component.set("v.depositList", _depositList); 
        }else{
            component.set("v.isDisabledSubmit",false);
        }
        
        
    },
    
    saveDepositList : function(component, event){
        debugger;       
        var _depRecList = event.getParam("depositInstance");    
        console.log("_depRecList : "+JSON.stringify(_depRecList));
        
        var _insertedDepositList = component.get("v.insertedDepositList");
        var _insertedReceiptList = component.get("v.insertedReceiptList");
        var _documentTotal = component.find("documentTotal").get('v.value');
        var _paymentSourceTotal = component.get("v.paymentSourceTotal");
        var action = component.get("c.saveDeposit_Receipt_Records");
        action.setParams({
            "paymentSourceTotal" : _paymentSourceTotal,
            "docTotal" : _documentTotal,
            "depRecList" : _depRecList,
            "recRecLstArr" : _insertedReceiptList
        });        
        action.setCallback(this, function(response) {
            var state = response.getState();           
            if (state === "SUCCESS") {               
                console.log('Deposit records saved successfully');               
                var _toastEvt = component.getEvent("toastEvt");
                _toastEvt.setParams({'state' : state , 'data' : 'Deposit record created.' });
                _toastEvt.fire();
                
                
                console.log("Response : Deposit List : " + JSON.stringify(response.getReturnValue()));
                var resturnDepositRec = response.getReturnValue();                
                component.set("v.depositRec",resturnDepositRec);
                _insertedDepositList.push(resturnDepositRec);   
                console.log("after insert :" + _insertedDepositList);
                component.set("v.insertedDepositList",_insertedDepositList);
                
                //to populate the total fields
                this.updateFields(component, event);
               
            }
        }); 
        $A.enqueueAction(action);
    },
    
    CreateCERecord :function(component, event){
        debugger;
        var _programType = component.get("v.defaultProgramType");
        var _insertedReceiptList = component.get("v.insertedReceiptList"); 
        var _insertedDepositList = component.get("v.insertedDepositList");
        var action = component.get("c.putEnvelopRec");       
        action.setParams({
            "programType" : _programType,
            "recRecLstArr" : _insertedReceiptList,
            "depRecLstArr": _insertedDepositList
        });  
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {  
                console.log(JSON.stringify(response.getReturnValue()));
                 var _toastEvt = component.getEvent("toastEvt");
                _toastEvt.setParams({'state' : state , 'data' : 'Customer Envelope record created.' });
                _toastEvt.fire();
                //redirect to List view
                this.gotoListView(component, event);
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
    
    updateFields : function(component, event){
        debugger;       
        var _insertedDepositList = component.get("v.insertedDepositList");
        var i,totalAmount = 0, _insertedDepositList_size = _insertedDepositList.length;
        for(i=0 ; i < _insertedDepositList_size ; i++){
            totalAmount = totalAmount + _insertedDepositList[i].Amount__c;
        }
        component.find("numberOfDocuments").set('v.value',_insertedDepositList_size);
        component.find("documentTotal").set('v.value', totalAmount);
       
        //to disable the Submit and Next button and add new row
        this.addDepositRecord(component, event);
                
                
    }
    
    
})