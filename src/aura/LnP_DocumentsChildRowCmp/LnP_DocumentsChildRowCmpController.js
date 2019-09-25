({
    doinit :  function(component, event, helper){
        //debugger;
        var pad = '000';
        var sequenceNumber = String(component.get("v.rowIndex"));
        component.set("v.formattedRowIndex",pad.substring(0,pad.length - sequenceNumber.length ) + sequenceNumber);
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
        //debugger;
        var _depositRec= component.get("v.depositRec");
        //on change of default types
        component.set("v.changedDefaultProgramType",event.getSource().get("v.value"));
        helper.getDependentFieldValues(component, event);       
    },    
    AddNewRow : function(component, event, helper){
        //debugger;
        // fire the AddNewRowEvt Lightning Event 
        
        var currentAmount = component.find("amount");
        var _depositRec= component.get("v.depositRec");
        var Today_date = new window.Date();
        _depositRec['Name'] = component.get("v.ValidationNumber") +'_'+ Number(component.get("v.rowIndex")+1);
        var pad = '000';
        var sequenceNumber = String(component.get("v.rowIndex"));
        var seq = pad.substring(0,pad.length - sequenceNumber.length ) + sequenceNumber;        
        _depositRec['Sequence_number__c'] = seq ;  
        _depositRec['Date__c'] = Today_date;
        
        //slip printer logic
        var _slipPrinterInput = component.get("v.ValidationNumber").replace("-","");
        //length : 12
        
        //for slip printer : sequence number  should start with 000
        var slipSequenceNumber =  String(component.get("v.rowIndex"));        
        _slipPrinterInput = _slipPrinterInput +' '+ seq;
        //length : 16
        
        //BUG 6416 : Slip Printer Input value '35' digits 
        //date in eight digit ex. MM/DD/YY : 081619
        var Date = Today_date.getDate();
        var month = (Today_date.getMonth() + 1)  < 10 ?  "0"+String(Today_date.getMonth() + 1) : String(Today_date.getMonth() + 1) ;
        var year = String(Today_date.getYear()).slice(1);     
        var formattedDate = month+'/'+Date+'/'+year;        
        _slipPrinterInput = _slipPrinterInput  + ' ' + formattedDate;
        //lenght : 25
        
        //-1 for space while 35 is standard size
        var remainingChars = 35 - _slipPrinterInput.length - 1 ; //9
        //logic for adding comma for thousand separator
        var formattedAmount = String(Number(_depositRec.Amount__c).toFixed(2)).replace(/\B(?=(\d{3})+(?!\d))/g, ",") ;
        
        //logic for amount with preceeding spaces 
        var spaces = '';
        var remainingCharacters = (remainingChars - formattedAmount.length);        
        for(i = 0; i < remainingCharacters ; i++){
            spaces = spaces + ' ';
        }
        formattedAmount = spaces + formattedAmount;        
        _slipPrinterInput =_slipPrinterInput + ' ' + formattedAmount ;
        component.set("v.slipPrinterInput", _slipPrinterInput); 
        //logic ends here
        
        //Cheking amount logic starts
        if(component.get("v.amountDifference") < currentAmount.get("v.value") || component.get("v.paymentSourceTotal") < currentAmount.get("v.value")  ){            
            alert("Amount Total should be equal to Payment Source Total");
        }else{
            //console.log("_depositRec : "+JSON.stringify(_depositRec));
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
        //debugger;
        // fire the AddNewRowEvt Lightning Event 
        var currentAmount = component.find("amount");
        var _depositRec= component.get("v.depositRec");
        var Today_date = new window.Date();
        _depositRec['Name'] = component.get("v.ValidationNumber") +'_'+ Number(component.get("v.rowIndex")+1);
        var pad = '000';
        var sequenceNumber = String(component.get("v.rowIndex"));
        var seq = pad.substring(0,pad.length - sequenceNumber.length ) + sequenceNumber;        
        _depositRec['Sequence_number__c'] = seq ;  
        _depositRec['Date__c'] = Today_date;
        
        //slip printer logic
        var _slipPrinterInput = component.get("v.ValidationNumber").replace("-","");
        //length : 12
        
        //for slip printer : sequence number  should start with 000
        var slipSequenceNumber =  String(component.get("v.rowIndex"));        
        _slipPrinterInput = _slipPrinterInput +' '+ seq;
        //length : 16
        
             //BUG 6416 : Slip Printer Input value '35' digits 
        //date in eight digit ex. MM/DD/YY : 081619
        var Date = Today_date.getDate();
        var month = (Today_date.getMonth() + 1)  < 10 ?  "0"+String(Today_date.getMonth() + 1) : String(Today_date.getMonth() + 1) ;
        var year = String(Today_date.getYear()).slice(1);     
        var formattedDate = month+'/'+Date+'/'+year;        
        _slipPrinterInput = _slipPrinterInput  + ' ' + formattedDate;
        //lenght : 25
        
        //-1 for space while 35 is standard size
        var remainingChars = 35 - _slipPrinterInput.length - 1 ; //9
        //logic for adding comma for thousand separator
        var formattedAmount = String(Number(_depositRec.Amount__c).toFixed(2)).replace(/\B(?=(\d{3})+(?!\d))/g, ",") ;
        
        //logic for amount with preceeding spaces 
        var spaces = '';
        var remainingCharacters = (remainingChars - formattedAmount.length);        
        for(i = 0; i < remainingCharacters ; i++){
            spaces = spaces + ' ';
        }
        formattedAmount = spaces + formattedAmount;        
        _slipPrinterInput =_slipPrinterInput + ' ' + formattedAmount ;
        component.set("v.slipPrinterInput", _slipPrinterInput); 
        //logic ends here
        
        //Cheking amount logic starts        
        if((component.get("v.rowIndex") == 0 && component.get("v.amountDifference") <= currentAmount.get("v.value")) || 
           component.get("v.paymentSourceTotal") < parseInt(currentAmount.get("v.value")) || 
           (component.get("v.rowIndex") !== 0 && component.get("v.paymentSourceTotal") > currentAmount.get("v.value") &&  component.get("v.amountDifference") < parseInt(currentAmount.get("v.value")) ) ){            
            alert("Amount Total should be equal to Payment Source Total");
        }else{
            //console.log("_depositRec : "+JSON.stringify(_depositRec));
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
        //console.log("depositRec : "+JSON.stringify(_depositRec));
        
        //slip printer logic
        var Today_date = new window.Date();
        var pad = '000';
        var _slipPrinterInput = component.get("v.ValidationNumber").replace("-","");
        //length : 12
        
        //for slip printer : sequence number  should start with 000
        var slipSequenceNumber =  String(component.get("v.rowIndex"));        
        _slipPrinterInput = _slipPrinterInput +' '+ (pad.substring(0, pad.length - slipSequenceNumber.length) + slipSequenceNumber);
        //length : 16
        
             //BUG 6416 : Slip Printer Input value '35' digits 
        //date in eight digit ex. MM/DD/YY : 081619
        var Date = Today_date.getDate();
        var month = (Today_date.getMonth() + 1)  < 10 ?  "0"+String(Today_date.getMonth() + 1) : String(Today_date.getMonth() + 1) ;
        var year = String(Today_date.getYear()).slice(1);     
        var formattedDate = month+'/'+Date+'/'+year;        
        _slipPrinterInput = _slipPrinterInput  + ' ' + formattedDate;
        //lenght : 25
        
        //-1 for space while 35 is standard size
        var remainingChars = 35 - _slipPrinterInput.length - 1 ; //9
        //logic for adding comma for thousand separator
        var formattedAmount = String(Number(_depositRec.Amount__c).toFixed(2)).replace(/\B(?=(\d{3})+(?!\d))/g, ",") ;
        
        //logic for amount with preceeding spaces 
        var spaces = '';
        var remainingCharacters = (remainingChars - formattedAmount.length);        
        for(i = 0; i < remainingCharacters ; i++){
            spaces = spaces + ' ';
        }
        formattedAmount = spaces + formattedAmount;        
        _slipPrinterInput =_slipPrinterInput + ' ' + formattedAmount ;
        component.set("v.slipPrinterInput", _slipPrinterInput); 
        //logic ends here
        
        
        var _AddRowEvt = component.getEvent("AddRowEvt");
        _AddRowEvt.setParams({"depositInstance" : _depositRec,"callType" : "update"});
        _AddRowEvt.fire();
        helper.onPrint(component,event,helper);
        
    },
    
})