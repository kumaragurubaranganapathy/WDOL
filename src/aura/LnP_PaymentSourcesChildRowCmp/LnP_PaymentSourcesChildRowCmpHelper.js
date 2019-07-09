({
    enablePrintButton : function(component,event){
        debugger;
        var receiptRec = component.get("v.receiptRec");
        var paymentType=component.find('paymentMethod').get('v.value');
        var number=component.find('checkNumber').get('v.value');
        var amount=component.find('receiptAmount').get('v.value');
        if(receiptRec.Id){
            component.set("v.printDisabled", true);
            component.set("v.cloneDisabled", true);
            component.set("v.updateDisabled", false);
        }else if(component.get("v.rowIndex") == 0){
            if( (number!='') && (amount!='') && (paymentType!='')){
                component.set("v.printDisabled", false);
                component.set("v.cloneDisabled",false);  
            }else{
                component.set("v.printDisabled", true);
                component.set("v.cloneDisabled", true);
            }   
        }else{
            if( (paymentType!='') &&(number!='') && (amount!='')){
                component.set("v.printDisabled", false);
                component.set("v.cloneDisabled", false);
            }else{
                component.set("v.printDisabled", true);
                component.set("v.cloneDisabled", true);
            }   
        }
        
        
        
    },
})