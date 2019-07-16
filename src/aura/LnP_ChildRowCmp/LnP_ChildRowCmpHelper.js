({
    enablePrintButton : function(component,event){
        debugger;
        var paymentType=component.find('programType').get('v.value');
        var number=component.find('formNumber').get('v.value');
        var amount=component.find('amount').get('v.value');
        if(component.get("v.rowIndex") == 0){
            if( (number!='') && (amount!='')){
                component.set("v.printDisabled", false);  
            }else{
                component.set("v.printDisabled", true);
            }   
        }else{
            if( (paymentType!='') &&(number!='') && (amount!='')){
                component.set("v.printDisabled", false);  
            }else{
                component.set("v.printDisabled", true);
            }   
        }
        
        
        
    },
})