({
    doinit :  function(component, event, helper){
        debugger;
        //  Added this to show the selected element value.
        var defaultProgramType = component.get("v.defaultProgramType");
        if (defaultProgramType && component.get("v.rowIndex") == 0) {
            var depositRec = component.get("v.depositRec");              
            if(depositRec.wadol_Program_Type__c && depositRec.wadol_Program_Type__c !== defaultProgramType){
                depositRec.wadol_Program_Type__c = component.get("v.changedDefaultProgramType");
            }else{
                depositRec.wadol_Program_Type__c = defaultProgramType; 
            }
            
        }
        helper.enablePrintButton(component,event);
        helper.getDependentFieldValuesOnLoad(component, event);       
        var _industryFormMap = component.get("v.industryFormMap");
    },
    enablePrintButton : function(component,event,helper){        
        helper.enablePrintButton(component,event);
    },    
    onControllerFieldChange: function(component, event, helper) {     
        debugger;
        var _depositRec= component.get("v.depositRec");
        //on change of default types
        component.set("v.changedDefaultProgramType",event.getSource().get("v.value"));
        helper.getDependentFieldValues(component, event);       
    },    
    AddNewRow : function(component, event, helper){
        debugger;
        // fire the AddNewRowEvt Lightning Event 
        
        var currentAmount = component.find("amount");
        var _depositRec= component.get("v.depositRec");
        var Today_date = new window.Date();
        _depositRec['Name'] = component.get("v.ValidationNumber") +'_'+ Number(component.get("v.rowIndex")+1);
        var pad = '000';
        var sequenceNumber = String(Number(component.get("v.rowIndex"))+1);;
        var seq = pad.substring(0,pad.length - sequenceNumber.length ) + sequenceNumber;        
        _depositRec['Sequence_number__c'] = seq ;  
        _depositRec['Date__c'] = Today_date;
        
         //BUG 6416 : Slip Printer Input value '35' digits 
        //date in six digit ex. MMDDYY : 081619
        var Date = Today_date.getDate();
        var month = (Today_date.getMonth() + 1)  < 10 ?  '0'+String(Today_date.getMonth() + 1) : String(Today_date.getMonth() + 1) ;
        var year = String(Today_date.getYear()).slice(1);     
        var formattedDate = month+Date+year;     
        
        //amount should be of 10 digits ex. if amount entered is 10.00 then amount will be '    $10.00'     
        var amount = _depositRec.Amount__c ;
        var spaces = '', finalAmount = '';
        var remainingCharacters = (10 - _depositRec.Amount__c.length);
        // - 1 is for the $ sign appended after in the final amount
        for(i = 0; i < remainingCharacters-1 ; i++){
            spaces = spaces + ' ';
        }
        finalAmount = spaces +'$'+ String(_depositRec.Amount__c);
       
        var _slipPrinterInput = component.get("v.ValidationNumber") +' '+_depositRec.Sequence_number__c+' '+formattedDate +' '+finalAmount ;
        component.set("v.slipPrinterInput", _slipPrinterInput); 
        //logic ends here
        
        //Cheking amount logic starts
        if(component.get("v.amountDifference") < currentAmount.get("v.value") || component.get("v.paymentSourceTotal") < currentAmount.get("v.value")  ){            
            alert("Amount Total should be equal to Payment Source Total");
        }else{
            console.log("_depositRec : "+JSON.stringify(_depositRec));
            if(parseInt(currentAmount.get("v.value")) === component.get("v.amountDifference")){
                component.set("v.cloneDisabled", true);
                component.set("v.printDisabled", true);
                component.set("v.updateDisabled", false);
                
            }else{
                component.set("v.cloneDisabled", true);
            }
            var _AddRowEvt = component.getEvent("AddRowEvt");
            _AddRowEvt.setParams({"depositInstance" : _depositRec, "callType" : "add"});
            _AddRowEvt.fire();
            helper.onPrint(component,event,helper);
        }
    },   
    Duplicate_AddNewRow : function(component,event,helper){
        debugger;
        // fire the AddNewRowEvt Lightning Event 
        var currentAmount = component.find("amount");
        var _depositRec= component.get("v.depositRec");
               var Today_date = new window.Date();
        _depositRec['Name'] = component.get("v.ValidationNumber") +'_'+ Number(component.get("v.rowIndex")+1);
        var pad = '000';
        var sequenceNumber = String(Number(component.get("v.rowIndex"))+1);;
        var seq = pad.substring(0,pad.length - sequenceNumber.length ) + sequenceNumber;        
        _depositRec['Sequence_number__c'] = seq ;  
        _depositRec['Date__c'] = Today_date;
        
         //BUG 6416 : Slip Printer Input value '35' digits 
        //date in six digit ex. MMDDYY : 081619
        var Date = Today_date.getDate();
        var month = (Today_date.getMonth() + 1)  < 10 ?  '0'+String(Today_date.getMonth() + 1) : String(Today_date.getMonth() + 1) ;
        var year = String(Today_date.getYear()).slice(1);     
        var formattedDate = month+Date+year;     
        
        //amount should be of 10 digits ex. if amount entered is 10.00 then amount will be '    $10.00'     
        var amount = _depositRec.Amount__c ;
        var spaces = '', finalAmount = '';
        var remainingCharacters = (10 - _depositRec.Amount__c.length);
        // - 1 is for the $ sign appended after in the final amount
        for(i = 0; i < remainingCharacters-1 ; i++){
            spaces = spaces + ' ';
        }
        finalAmount = spaces +'$'+ String(_depositRec.Amount__c);
       
        var _slipPrinterInput = component.get("v.ValidationNumber") +' '+_depositRec.Sequence_number__c+' '+formattedDate +' '+finalAmount ;
        component.set("v.slipPrinterInput", _slipPrinterInput); 
        //logic ends here
        
        //Cheking amount logic starts        
        if((component.get("v.rowIndex") == 0 && component.get("v.amountDifference") <= currentAmount.get("v.value")) || 
           component.get("v.paymentSourceTotal") < parseInt(currentAmount.get("v.value")) || 
           (component.get("v.rowIndex") !== 0 && component.get("v.paymentSourceTotal") > currentAmount.get("v.value") &&  component.get("v.amountDifference") < parseInt(currentAmount.get("v.value")) ) ){            
            alert("Amount Total should be equal to Payment Source Total");
        }else{
            console.log("_depositRec : "+JSON.stringify(_depositRec));
            if(parseInt(currentAmount.get("v.value")) === component.get("v.amountDifference")){
                component.set("v.cloneDisabled", true);
                component.set("v.printDisabled", true);
                component.set("v.updateDisabled", false);
                
            }else{
                component.set("v.cloneDisabled", true);
            }
            var _AddRowEvt = component.getEvent("AddRowEvt");
            _AddRowEvt.setParams({"depositInstance" : _depositRec, "callType" : "clone"});
            _AddRowEvt.fire(); 
            helper.onPrint(component,event,helper);
            
        }
    },
    Update_AddNewRow : function(component,event,helper){
        
        var _depositRec= component.get("v.depositRec");  
        var Today_date = new window.Date();
       // _depositRec['Name'] = component.get("v.ValidationNumber") +'_'+ Number(component.get("v.rowIndex")+1);
        var pad = '000';
        var sequenceNumber = String(_depositRec.Sequence_number__c);
        var seq = pad.substring(0,pad.length - sequenceNumber.length ) + sequenceNumber;        
       // _depositRec['Sequence_number__c'] = seq ;  
       // _depositRec['Date__c'] = Today_date;
        
         //BUG 6416 : Slip Printer Input value '35' digits 
        //date in six digit ex. MMDDYY : 081619
        var Date = Today_date.getDate();
        var month = (Today_date.getMonth() + 1)  < 10 ?  '0'+String(Today_date.getMonth() + 1) : String(Today_date.getMonth() + 1) ;
        var year = String(Today_date.getYear()).slice(1);     
        var formattedDate = month+Date+year;     
        
        //amount should be of 10 digits ex. if amount entered is 10.00 then amount will be '    $10.00'     
        var amount = _depositRec.Amount__c ;
        var spaces = '', finalAmount = '';
        var remainingCharacters = (10 - _depositRec.Amount__c.length);
        // - 1 is for the $ sign appended after in the final amount
        for(i = 0; i < remainingCharacters-1 ; i++){
            spaces = spaces + ' ';
        }
        finalAmount = spaces +'$'+ String(_depositRec.Amount__c);
       
        var _slipPrinterInput = component.get("v.ValidationNumber") +' '+seq+' '+formattedDate +' '+finalAmount ;
        component.set("v.slipPrinterInput", _slipPrinterInput); 
        //logic ends here
        
        //Cheking amount logic starts
        console.log("depositRec : "+JSON.stringify(_depositRec));
        var _AddRowEvt = component.getEvent("AddRowEvt");
        _AddRowEvt.setParams({"depositInstance" : _depositRec,"callType" : "update"});
        _AddRowEvt.fire();
        helper.onPrint(component,event,helper);
        
    },
    
})