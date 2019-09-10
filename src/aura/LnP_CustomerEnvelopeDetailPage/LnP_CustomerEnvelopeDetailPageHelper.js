({
    fetchDeposits: function(component,event){
        var recId = component.get("v.recordId");
        console.log('recId::'+recId);
        var fetchDepositAction = component.get("c.fetchDeposits");
        fetchDepositAction.setParams({
            recordId:recId
        });
        fetchDepositAction.setCallback(this,function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                component.set("v.depositList",response.getReturnValue());
                var depositList = component.get("v.depositList");
                component.set("v.totalDoc",depositList.length);
                if(depositList.length == 0){
                    component.set("v.noDeposit",true);
                }
            }else{
                console.log('state::'+state);
            }
        });
        
        $A.enqueueAction(fetchDepositAction);
        
        
    },
    handleFormSubmit :function(component,event){
        var recId = component.get("v.recordId");
        var fetchDepositAction = component.get("c.submitDeposits");
        fetchDepositAction.setParams({
            recordId:recId
        });
        fetchDepositAction.setCallback(this,function(response){
            var state = response.getState();
            var _toastEvt = component.getEvent("toastEvt");
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                
                _toastEvt.setParams({'state' : state , 'data' : 'Customer Envelope record updated' });
                _toastEvt.fire();
                //redirect to List view
                this.gotoListView(component, event);            
            }else{
                
                _toastEvt.setParams({'state' : state , 'data' : 'Error' });
                _toastEvt.fire();
            }
        });
        $A.enqueueAction(fetchDepositAction);
    },
    gotoListView : function (component, event) {
        var action = component.get("c.getObjViews");
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                var listviews = response.getReturnValue();
                var navEvent = $A.get("e.force:navigateToList");
                navEvent.setParams({
                    "listViewId": listviews.Id,
                    "listViewName": listviews.Name,
                    "scope": "Customer_Envelope__c"
                });
                navEvent.fire();
            }
        });
        $A.enqueueAction(action);
    },
    toggleAction : function(component, event, secId) {
        if ( document.getElementById(secId).classList.contains('slds-hide') ){
            console.log('showing div');
            document.getElementById(secId).classList.add('slds-show');
		document.getElementById(secId).classList.remove('slds-hide');
        }else if ( document.getElementById(secId).classList.contains('slds-show') ){
            console.log('hiding div');
           document.getElementById(secId).classList.remove('slds-show');
		document.getElementById(secId).classList.add('slds-hide');
        }
       },
    greyOutDocument : function(component, event, secId) {
        var divBoxId = secId+'-box';
        if(document.getElementById(divBoxId).classList.contains('slds-box')){
            document.getElementById(divBoxId).classList.add('slds-theme_shade');
        }
     },
})