({
    doinit :  function(component, event, helper){
        //debugger;
        helper.enablePrintButton(component,event);
    },
    AddNewRow : function(component, event, helper){
        debugger;
        // fire the AddNewRowEvt Lightning Event 
        
        var _receiptRec= component.get("v.receiptRec");
        var objToday = new window.Date();
        var sequenceNumber =  String(Number(component.get("v.rowIndex"))+1);
        var pad = "000";
        var seqNo = pad.substring(0, pad.length - sequenceNumber.length) + sequenceNumber;        
        _receiptRec['Sequence_number__c'] = seqNo;
        _receiptRec['Date__c'] = objToday;
         console.log("receiptRec : "+JSON.stringify(_receiptRec));
        
         //BUG 6416 : Slip Printer Input value '35' digits 
        //date in six digit ex. MMDDYY : 081619
        var Date = objToday.getDate();
        var month = (objToday.getMonth() + 1)  < 10 ?  '0'+String(objToday.getMonth() + 1) : String(objToday.getMonth() + 1) ;
        var year = String(objToday.getYear()).slice(1);     
        var formattedDate = month+Date+year;      
        
        //amount should be of 10 digits ex. if amount entered is 10.00 then amount will be '    $10.00'     
        var amount = _receiptRec.MUSW__Amount_Tendered__c ;
        var spaces = '', finalAmount = '';
        var remainingCharacters = (10 - _receiptRec.MUSW__Amount_Tendered__c.length);
        for(i = 0; i < remainingCharacters-1 ; i++){
            spaces = spaces + ' ';
        }
        finalAmount = spaces +'$'+ String(_receiptRec.MUSW__Amount_Tendered__c);
       
        var _slipPrinterInput = component.get("v.ValidationNumber") +' '+_receiptRec.Sequence_number__c+' '+formattedDate +' '+finalAmount ;
        component.set("v.slipPrinterInput", _slipPrinterInput); 
        
        var _AddRowEvt = component.getEvent("AddRowEvt");
        _AddRowEvt.setParams({"receiptInstance" : _receiptRec,"callType" : "add"});
        _AddRowEvt.fire();
        component.set("v.printDisabled", true);
        helper.onPrint(component,event,helper);
        
    },
    enablePrintButton : function(component,event,helper){
        helper.enablePrintButton(component,event);
        console.log(component.get('v.receiptRec.MUSW__Payment_Method__c'));
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
        var sequenceNumber =  String(Number(component.get("v.rowIndex"))+1);
        var pad = "000";
        var seqNo = pad.substring(0, pad.length - sequenceNumber.length) + sequenceNumber;        
        _receiptRec['Sequence_number__c'] = seqNo;
        _receiptRec['Date__c'] = objToday;
         console.log("receiptRec : "+JSON.stringify(_receiptRec));
        
         //BUG 6416 : Slip Printer Input value '35' digits 
        //date in six digit ex. MMDDYY : 081619
        var Date = objToday.getDate();
        var month = (objToday.getMonth() + 1)  < 10 ?  '0'+String(objToday.getMonth() + 1) : String(objToday.getMonth() + 1) ;
        var year = String(objToday.getYear()).slice(1);     
        var formattedDate = month+Date+year;      
        
        //amount should be of 10 digits ex. if amount entered is 10.00 then amount will be '    $10.00'     
        var amount = _receiptRec.MUSW__Amount_Tendered__c ;
        var spaces = '', finalAmount = '';
        var remainingCharacters = (10 - _receiptRec.MUSW__Amount_Tendered__c.length);
        for(i = 0; i < remainingCharacters-1 ; i++){
            spaces = spaces + ' ';
        }
        finalAmount = spaces +'$'+ String(_receiptRec.MUSW__Amount_Tendered__c);
       
        var _slipPrinterInput = component.get("v.ValidationNumber") +' '+_receiptRec.Sequence_number__c+' '+formattedDate +' '+finalAmount ;
        component.set("v.slipPrinterInput", _slipPrinterInput);  
                      
        var _AddRowEvt = component.getEvent("AddRowEvt");
        _AddRowEvt.setParams({"receiptInstance" : _receiptRec,"callType" : "clone"});
        _AddRowEvt.fire();
        component.set("v.cloneDisabled", true);
        helper.onPrint(component,event,helper);
    },
    Update_AddNewRow : function(component,event,helper){
        
        var _receiptRec= component.get("v.receiptRec");    
        var objToday = new window.Date();
        var sequenceNumber =  String(Number(component.get("v.rowIndex"))+1);
        var pad = "000";
        var seqNo = pad.substring(0, pad.length - sequenceNumber.length) + sequenceNumber;        
        _receiptRec['Sequence_number__c'] = seqNo;
        _receiptRec['Date__c'] = objToday;
         console.log("receiptRec : "+JSON.stringify(_receiptRec));
        
         //BUG 6416 : Slip Printer Input value '35' digits 
        //date in six digit ex. MMDDYY : 081619
        var Date = objToday.getDate();
        var month = (objToday.getMonth() + 1)  < 10 ?  '0'+String(objToday.getMonth() + 1) : String(objToday.getMonth() + 1) ;
        var year = String(objToday.getYear()).slice(1);     
        var formattedDate = month+Date+year;      
        
        //amount should be of 10 digits ex. if amount entered is 10.00 then amount will be '    $10.00'     
        var amount = _receiptRec.MUSW__Amount_Tendered__c ;
        var spaces = '', finalAmount = '';
        var remainingCharacters = (10 - _receiptRec.MUSW__Amount_Tendered__c.length);
        for(i = 0; i < remainingCharacters-1 ; i++){
            spaces = spaces + ' ';
        }
        finalAmount = spaces +'$'+ String(_receiptRec.MUSW__Amount_Tendered__c);
       
        var _slipPrinterInput = component.get("v.ValidationNumber") +' '+_receiptRec.Sequence_number__c+' '+formattedDate +' '+finalAmount ;
        component.set("v.slipPrinterInput", _slipPrinterInput);  
        
        var _AddRowEvt = component.getEvent("AddRowEvt");
        _AddRowEvt.setParams({"receiptInstance" : _receiptRec,"callType" : "update"});
        _AddRowEvt.fire();
        helper.onPrint(component,event,helper);
      
    }, 
})