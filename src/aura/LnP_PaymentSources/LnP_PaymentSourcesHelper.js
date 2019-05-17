({
		addReceiptRecord: function(component, event) {
        //get the account List from component  
         debugger;
         var recieptList = component.get("v.recieptList");
         
         
        //Add New Account Record
        recieptList.push({
            'sobjectType': 'MUSW__Receipt__c',
            'Sequence_number__c': '',
            'Payment_type__c': '',
            'MUSW__Check_Number__c': '',
            'Payment_amount__c': ''
        });
           
        component.set("v.recieptList", recieptList);
       //component.set("v.isDisabledSPB", 'true');
	},
       
    saveRecieptList : function(component, event){
        debugger;
        var action = component.get("c.saveReciptRecords");
        var firstRecList=component.get("v.paymentType");       
        console.log('after ' + JSON.stringify(firstRecList));    
        var _insertedDepositList = component.get("v.insertedReceiptList");
       
        action.setParams({
           "receiptRecord": firstRecList
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
                _insertedDepositList.push(returnReceiptRec);    
                console.log("after insert :" + _insertedDepositList);
                                
            }
        }); 
        $A.enqueueAction(action);
    },
    
    updateFields : function(component, event){
    var rowCount=component.get("v.recieptList");
    component.set("v.numOfPaymentSources",rowCount.length);
    var totalAmount=parseInt(component.find('amountWP').get('v.value'));
      var totalAmountAfterPrint=component.find('test');
        
        for(var i in totalAmountAfterPrint){
            if(i !== null && i !== undefined && i !== '' & i >= 0){
                if(totalAmountAfterPrint[i].get('v.value') !== undefined){                    
                    totalAmount += parseInt(totalAmountAfterPrint[i].get('v.value'));
                }
            }
        }
    component.set("v.paymentSourceTotal",totalAmount);
    } 
})