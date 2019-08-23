({
    enablePrintButton : function(component,event){
        //debugger;
        var receiptRec = component.get("v.receiptRec");
        var paymentType=component.find('paymentMethod').get('v.value');
        var number=component.find('checkNumber').get('v.value');
        var amount=component.find('receiptAmount').get('v.value');
        if(amount){
            if(amount < 1){
                component.find('receiptAmount').setCustomValidity("Amount cannot be Negative or 0 ");
            }else{
                component.find('receiptAmount').setCustomValidity(""); // if there was a custom error before, reset it
            }
           
        }
        
        
        if(receiptRec.Id){
            component.set("v.printDisabled", true);
            component.set("v.cloneDisabled", true);
            component.set("v.updateDisabled", false);
        }else if(component.get("v.rowIndex") == 0){
            component.set("v.disableNext",true);
            if( (paymentType!='') &&(number!='') && (amount != '' && amount > 0)){
                component.set("v.printDisabled", false);
                component.set("v.cloneDisabled", false);                
            }else{
                component.set("v.printDisabled", true);
                component.set("v.cloneDisabled", true);
                
            }   
        }else{
            if( (paymentType!='') &&(number!='') && (amount != '' && amount > 0)){
                component.set("v.printDisabled", false);
                component.set("v.cloneDisabled", false);
                component.set("v.disableNext",true);
            }else{
                component.set("v.printDisabled", true);
                component.set("v.cloneDisabled", true);
                component.set("v.disableNext",false);
            }   
        }
        
        
    },
    onPrint : function(component,event,helper){
        var printInput = component.get("v.slipPrinterInput");
        //console.log('printInput='+printInput);
        var printTwice = component.get("v.printTwice");
        //console.log('printTwice='+printTwice);
        
        if(printTwice === true){
            var printblabk = '                                   ';
            window.open('/apex/Dol_ConnectToSlipPrinter?validationNo='+printblabk,'_blank');
            window.open('/apex/Dol_ConnectToSlipPrinter?validationNo='+printInput,'_blank');
        }
        else{
            window.open('/apex/Dol_ConnectToSlipPrinter?validationNo='+printInput,'_blank');
        }
        component.set("v.isClickedFirstTime", false);
        //console.log('isClickedFirstTimeafter print='+component.get("v.isClickedFirstTime"));
    },
})