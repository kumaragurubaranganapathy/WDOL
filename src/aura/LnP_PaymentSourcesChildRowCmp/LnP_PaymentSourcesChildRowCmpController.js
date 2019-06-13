({
    doinit :  function(component, event, helper){
        debugger;
        helper.enablePrintButton(component,event);
    },
    AddNewRow : function(component, event, helper){
        debugger;
        // fire the AddNewRowEvt Lightning Event 
        var _receiptRec= component.get("v.receiptRec");    
        console.log("receiptRec : "+JSON.stringify(_receiptRec));
        var _AddRowEvt = component.getEvent("AddRowEvt");
        _AddRowEvt.setParams({"receiptInstance" : _receiptRec,"callType" : "add"});
        _AddRowEvt.fire();
        component.set("v.printDisabled", true);
        
    },
    enablePrintButton : function(component,event,helper){
        helper.enablePrintButton(component,event);
    },
    Duplicate_AddNewRow : function(component,event,helper){
        debugger;
        // fire the AddNewRowEvt Lightning Event 
        var _receiptRec= component.get("v.receiptRec");    
        console.log("receiptRec : "+JSON.stringify(_receiptRec));
        var _AddRowEvt = component.getEvent("AddRowEvt");
        _AddRowEvt.setParams({"receiptInstance" : _receiptRec,"callType" : "clone"});
        _AddRowEvt.fire();
        component.set("v.cloneDisabled", true);
    },
    Update_AddNewRow : function(component,event,helper){
        var _receiptRec= component.get("v.receiptRec");    
        console.log("receiptRec : "+JSON.stringify(_receiptRec));
        var _AddRowEvt = component.getEvent("AddRowEvt");
        _AddRowEvt.setParams({"receiptInstance" : _receiptRec,"callType" : "update"});
        _AddRowEvt.fire();
      
    },
    
    
})