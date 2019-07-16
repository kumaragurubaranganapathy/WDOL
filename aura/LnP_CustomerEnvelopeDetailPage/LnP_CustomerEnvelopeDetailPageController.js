({
    doinit : function(component,event,helper){
        helper.fetchDeposits(component,event);
    },
    
    handleCancel:function(component,event,helper){
        helper.gotoListView(component,event);
    },
    
    handleFormSubmit: function(component,event,helper){
        console.log('Inside Final submit');
        helper.handleFormSubmit(component,event,helper);
    },
    
    handleOnSuccess : function(component, event, helper) {
        var record = event.getParam("response");
        var list = component.get("v.depositList");
        var totalDocCount = list.length;
        var savedRecord = component.get("v.newRecSaved") || new Set();
        savedRecord.add(record.id);
        component.set("v.newRecSaved",savedRecord);
        var savedRecord = component.get("v.newRecSaved");
        var savedRecordLength = savedRecord.size;
        component.set("v.completedDoc",savedRecordLength);
       
        if(savedRecordLength == totalDocCount){
            component.set("v.disableSave",false);
        }
    },
    
    showToast : function(component,event,helper){
        var toastEvent = $A.get("e.force:showToast");
        if(event.getParam("state")=== 'SUCCESS'){
            toastEvent.setParams({
                title:'Success',
                type : 'success',                
                duration : '1000',
                mode: 'dismissible',
                message: event.getParam("data"),
                
            });
        }else{
            toastEvent.setParams({
                title:'Error',
                type : 'error',                
                duration : '1000',
                mode: 'dismissible',
                message: 'Record creation failed',
                
            }); 
        }      
        
        toastEvent.fire();
    },
    
    panelClose : function(component,event,helper){
        //var editCard = event.target.dataset.item;
        console.log('inside panelClose');
        var editCard = event.getSource().get("v.name");
        console.log('editCard');
        console.log(editCard);
        helper.toggleAction(component,event,editCard);
        helper.greyOutDocument(component,event,editCard);
    },
    panelOpen : function(component,event,helper){
        var editCard = event.target.dataset.item;
        console.log('editCard');
        console.log(editCard);
        helper.toggleAction(component,event,editCard);
    },
    
})