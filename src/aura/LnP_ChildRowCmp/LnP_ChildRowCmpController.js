({
    doinit :  function(component, event, helper){
        debugger;
     helper.enablePrintButton(component,event);
    },
    AddNewRow : function(component, event, helper){
        debugger;
       // fire the AddNewRowEvt Lightning Event 
       var _depositRec= component.get("v.depositRec");
        if(component.get("v.rowIndex") == 0){
            _depositRec.wadol_Program_Type__c = component.get("v.defaultProgramType") ;
        }        
       console.log("_depositRec : "+JSON.stringify(_depositRec));
        var _AddRowEvt = component.getEvent("AddRowEvt");
        _AddRowEvt.setParams({"depositInstance" : _depositRec});
        _AddRowEvt.fire();

        component.set("v.printDisabled", true);
        
    },
     enablePrintButton : function(component,event,helper){
       helper.enablePrintButton(component,event);
    },
    
    /*removeRow : function(component, event, helper){
     // fire the DeleteRowEvt Lightning Event and pass the deleted Row Index to Event parameter/attribute
       component.getEvent("DeleteRowEvt").setParams({"indexVar" : component.get("v.rowIndex") }).fire();
    }, */
  
})