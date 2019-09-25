({
    doinit :  function(component, event, helper){
        //debugger;
        var sequenceNumber =  String(component.get("v.rowIndex"));
        var pad = "000";       
        component.set("v.formattedRowIndex",pad.substring(0, pad.length - sequenceNumber.length) + sequenceNumber);
        helper.enablePrintButton(component,event);  
    },
    AddNewRow : function(component, event, helper){
        //debugger;
        // fire the AddNewRowEvt Lightning Event 
        
        var _receiptRec= component.get("v.receiptRec");
        var objToday = new window.Date();
        var sequenceNumber =  String(component.get("v.rowIndex"));
        var pad = "000";
        var seqNo = pad.substring(0, pad.length - sequenceNumber.length) + sequenceNumber;        
        _receiptRec['Sequence_number__c'] = seqNo;
        _receiptRec['Date__c'] = objToday;
        //console.log("receiptRec : "+JSON.stringify(_receiptRec));
        
        //slip printer logic
        var _slipPrinterInput = component.get("v.ValidationNumber").replace("-","");
        //length : 12
        
        //for slip printer : sequence number  should start with 000                
        _slipPrinterInput = _slipPrinterInput +' '+ seqNo;
        //length : 16
        
        //BUG 6416 : Slip Printer Input value '35' digits 
        //date in eight digit ex. MM/DD/YY : 081619
        var Date = objToday.getDate();
        var month = (objToday.getMonth() + 1)  < 10 ?  "0"+String(objToday.getMonth() + 1) : String(objToday.getMonth() + 1) ;
        var year = String(objToday.getYear()).slice(1);     
        var formattedDate = month+'/'+Date+'/'+year;        
        _slipPrinterInput = _slipPrinterInput  + ' ' + formattedDate;
        //lenght : 25
        
        //-1 for space 
        var remainingChars = 35 - _slipPrinterInput.length - 1 ; //9
        //logic for adding comma for thousand separator
        var formattedAmount = String(Number(_receiptRec.MUSW__Amount_Tendered__c).toFixed(2)).replace(/\B(?=(\d{3})+(?!\d))/g, ",") ;
        
        //logic for amount with preceeding spaces 
        var spaces = '';
        var remainingCharacters = (remainingChars - formattedAmount.length);        
        for(i = 0; i < remainingCharacters ; i++){
            spaces = spaces + ' ';
        }
        formattedAmount = spaces + formattedAmount;        
        _slipPrinterInput =_slipPrinterInput + ' ' + formattedAmount ;
        component.set("v.slipPrinterInput", _slipPrinterInput); 
        
        var _AddRowEvt = component.getEvent("AddRowEvt");
        _AddRowEvt.setParams({"receiptInstance" : _receiptRec,"callType" : "add"});
        _AddRowEvt.fire();
        component.set("v.printDisabled", true);
       
        helper.onPrint(component,event,helper);
        
    },
    enablePrintButton : function(component,event,helper){
        helper.enablePrintButton(component,event);
        //console.log(component.get('v.receiptRec.MUSW__Payment_Method__c'));
        if(component.get('v.receiptRec.MUSW__Payment_Method__c') != 'Inter-agency Payment'){
            component.set('v.receiptRec.IAP_Doc__c','');
            component.set('v.receiptRec.Sender_Agency__c','') ;
            component.set('v.receiptRec.License_Number__c','') ;
            component.set('v.receiptRec.Applicant_Name__c','') ;
            component.set('v.receiptRec.JV_Number__c','') ;
            
        }
    },
    Duplicate_AddNewRow : function(component,event,helper){
        //debugger;
        
        // fire the AddNewRowEvt Lightning Event 
        var _receiptRec= component.get("v.receiptRec");
        var objToday = new window.Date();
        var sequenceNumber =  String(component.get("v.rowIndex"));
        var pad = "000";
        var seqNo = pad.substring(0, pad.length - sequenceNumber.length) + sequenceNumber;        
        _receiptRec['Sequence_number__c'] = seqNo;
        _receiptRec['Date__c'] = objToday;
        //console.log("receiptRec : "+JSON.stringify(_receiptRec));
        
        //slip printer logic
        var _slipPrinterInput = component.get("v.ValidationNumber").replace("-","");
        //length : 12
        
        //for slip printer : sequence number  should start with 000                
        _slipPrinterInput = _slipPrinterInput +' '+ seqNo;
        //length : 16
        
        //BUG 6416 : Slip Printer Input value '35' digits 
        //date in eight digit ex. MM/DD/YY : 081619
        var Date = objToday.getDate();
        var month = (objToday.getMonth() + 1)  < 10 ?  "0"+String(objToday.getMonth() + 1) : String(objToday.getMonth() + 1) ;
        var year = String(objToday.getYear()).slice(1);     
        var formattedDate = month+'/'+Date+'/'+year;        
        _slipPrinterInput = _slipPrinterInput  + ' ' + formattedDate;
        //lenght : 25
        
        //-1 for space while 35 is standard size
        var remainingChars = 35 - _slipPrinterInput.length - 1 ; //9
        //logic for adding comma for thousand separator
        var formattedAmount = String(Number(_receiptRec.MUSW__Amount_Tendered__c).toFixed(2)).replace(/\B(?=(\d{3})+(?!\d))/g, ",") ;
        
        //logic for amount with preceeding spaces 
        var spaces = '';
        var remainingCharacters = (remainingChars - formattedAmount.length);        
        for(i = 0; i < remainingCharacters ; i++){
            spaces = spaces + ' ';
        }
        formattedAmount = spaces + formattedAmount;        
        _slipPrinterInput =_slipPrinterInput + ' ' + formattedAmount ;
        component.set("v.slipPrinterInput", _slipPrinterInput);  
        
        var _AddRowEvt = component.getEvent("AddRowEvt");
        _AddRowEvt.setParams({"receiptInstance" : _receiptRec,"callType" : "clone"});
        _AddRowEvt.fire();
        component.set("v.cloneDisabled", true);
       
        helper.onPrint(component,event,helper);
    },
    Update_AddNewRow : function(component,event,helper){
        
        var _receiptRec= component.get("v.receiptRec");  
        //console.log("receiptRec : "+JSON.stringify(_receiptRec));
        
        //slip printer logic
        var objToday = new window.Date();        
        var pad = "000";  
        var _slipPrinterInput = component.get("v.ValidationNumber").replace("-","");
        //length : 12
        
        //for slip printer : sequence number  should start with 000
        var slipSequenceNumber =  String(component.get("v.rowIndex"));        
        _slipPrinterInput = _slipPrinterInput +' '+ (pad.substring(0, pad.length - slipSequenceNumber.length) + slipSequenceNumber);
        //length : 16
        
        //BUG 6416 : Slip Printer Input value '35' digits 
        //date in eight digit ex. MM/DD/YY : 081619
        var Date = objToday.getDate();
        var month = (objToday.getMonth() + 1)  < 10 ?  "0"+String(objToday.getMonth() + 1) : String(objToday.getMonth() + 1) ;
        var year = String(objToday.getYear()).slice(1);     
        var formattedDate = month+'/'+Date+'/'+year;        
        _slipPrinterInput = _slipPrinterInput  + ' ' + formattedDate;
        //lenght : 25
        
        //-1 for space 
        var remainingChars = 35 - _slipPrinterInput.length - 1 ; //9
        //logic for adding comma for thousand separator
        var formattedAmount = String(Number(_receiptRec.MUSW__Amount_Tendered__c).toFixed(2)).replace(/\B(?=(\d{3})+(?!\d))/g, ",") ;
        
        //logic for amount with preceeding spaces 
        var spaces = '';
        var remainingCharacters = (remainingChars - formattedAmount.length);        
        for(i = 0; i < remainingCharacters ; i++){
            spaces = spaces + ' ';
        }
        formattedAmount = spaces + formattedAmount;        
        _slipPrinterInput =_slipPrinterInput + ' ' + formattedAmount ;
        component.set("v.slipPrinterInput", _slipPrinterInput);  
        
        var _AddRowEvt = component.getEvent("AddRowEvt");
        _AddRowEvt.setParams({"receiptInstance" : _receiptRec,"callType" : "update"});
        _AddRowEvt.fire();
        helper.onPrint(component,event,helper);
        
    }, 
})