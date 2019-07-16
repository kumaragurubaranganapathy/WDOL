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
      
    } 
})