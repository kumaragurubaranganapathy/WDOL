({
    doInit : function(component,event) {
        var tDate = new Date();
        component.set("v.todayDate",tDate);        
    },
    
    fetchPeerRelationShipDataRecords : function(component, event, helper){        
        // console.log("In fetchPeerRelationShipDataRecords...."+licenseDat);        
        var action = component.get("c.setPeerRelationShipTable");        
        action.setParams({"licenseId" : component.get("v.parentLicense")});        
        action.setCallback(this,function(response){            
            var state = response.getState();            
            if (state === "SUCCESS") {                
                var resp = response.getReturnValue();
                console.log("In fetchPeerRelationShipDataRecords....return response"+resp);                
                var PeerRelationshipTableData = JSON.parse(resp);                
                var PeerRelationshipTableColumnData = PeerRelationshipTableData["tableHeader"];                
                var PeerRelationshipTableHeaderData = PeerRelationshipTableData["tableData"];                
                var isParent  = PeerRelationshipTableData["miscellaneousData"] == "true"?true:false;                
                component.set("v.PeerRelationTableColumnsList",PeerRelationshipTableColumnData);                
                component.set("v.PeerRelationTableDataList",PeerRelationshipTableHeaderData);                
                component.set("v.IsCurrentLicenseParent",isParent);                
                console.log("fetchPeerRelationShipDataRecords   :::::  "+JSON.stringify(resp));
                
            }else if (state === "ERROR") {
                
                var errors = response.getError();
                
                //console.error("fetchPeerRelationShipDataRecords   :::::  "+JSON.stringify(errors));
            }    
        });
        $A.enqueueAction(action);    
    },
    
    getRelationShipTableData :function(component,event, helper){
        console.log("inside helper ::sObjectName::"+ component.get("v.sObjectName"));
        console.log("inside helper ::queryId::"+ component.get("v.queryId"));
        console.log('Type::'+ component.get("v.Type"));        
        var action = component.get("c.getRelationShip");
        action.setParams({'sObjectName': component.get("v.sObjectName"),
                          'queryId': component.get("v.queryId"),
                          'Type': component.get("v.Type"),
                          'isAMR': component.get("v.isAMR"),
                         });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var currentLicenseTableData = JSON.parse(response.getReturnValue());
                console.log("realtionship::"+JSON.stringify(currentLicenseTableData));
                
                var currentLicenseTableColumnData = currentLicenseTableData["tableHeader"];
                
                var currentLicenseTableHeaderData = currentLicenseTableData["tableData"];
                
                component.set("v.CurrentLicenseTableColumnsList",currentLicenseTableColumnData);
                
                component.set("v.CurrentLicenseTableDataList",currentLicenseTableHeaderData);
                component.set("v.loadingSpinner",false);
                if(component.get("v.sObjectName") == 'MUSW__Account_Contact__c'){
                    var Objectlist = component.get("v.CurrentLicenseTableDataList");
                    var countAdmin = 0;
                    for(var j=0;j<Objectlist.length;j++){
                        if(Objectlist[j].Role__c == 'Administrator' && Objectlist[j].Status__c=='Active'){
                            countAdmin ++;
                        }
                    }
                    component.set("v.adminCount",countAdmin);
                }
            } else if (state === "ERROR") {
                var errors = response.getError();
                console.error(JSON.stringify(errors));
            }
        });
        $A.enqueueAction(action);
    },
    saveOwnerRecordHelper:function(cmp,event,helper){   
       
        var acctCont = event.getSource().get("v.value");
        var count = 0;
        var successInfo = '';
        for(var i=0;i<acctCont.length;i+=1)
        {
            if(acctCont[i].DCP__c==true)
            {
                count+=1;
            }
        }
        if(count>1)
        {
             var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "type":"Error",
                "title": "Error!",
                "message": "You can not add more than one DCP"
            });
           
            toastEvent.fire(); 
        }
        else
        {
            var action = cmp.get("c.saveOwnerRecord");
            action.setParams ({"accCon": JSON.stringify(acctCont) });
            action.setCallback(this, function (response) {
                var state = response.getState();
                console.log('state--' + state);
                if (state === "SUCCESS") {
                    console.log('inside success');
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": 'Success!',
                        "type": 'Success',
                        "message": 'DCP Changed Successfully'
                    });
                    toastEvent.fire(); 
                    
                    this.getRelationShipTableData(cmp,event,helper); 
                    window.location.href = $A.get("$Label.c.Polaris_Portal_Business_Dashboard");
                } else if (state === "ERROR") {
                    var errors = response.getError();
                    console.error(JSON.stringify(errors));
                }
                component.set("v.loadingSpinner",false);
            });
            $A.enqueueAction(action);
        }  
        
    },
    
    removeOwnerRecordHelper:function(cmp,event,helper){
        var ownerId = cmp.get("v.ownerId");
        var action = cmp.get("c.removeOwnerRecord");
        action.setParams ({"accConId": ownerId});
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                console.log('inside success');                    
                this.getRelationShipTableData(cmp,event,helper);  
                
            } else if (state === "ERROR") {
                var errors = response.getError();
                console.error(JSON.stringify(errors));
            }
            component.set("v.loadingSpinner",false);
        });
        $A.enqueueAction(action); 
    },
    removeAccountContactRecord : function(cmp,event,helper){
        var action = cmp.get("c.removeAcconContactRecord");
        action.setParams ({"accConId": cmp.get("v.accountContact"),"action":cmp.get("v.actionClicked")});
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                console.log('inside success');
                var taskCompleted =  response.getReturnValue();
                console.log('task::'+taskCompleted);
                var toastEvent = $A.get("e.force:showToast");
                if(taskCompleted){
                    toastEvent.setParams({
                        "type":"Success",
                        "title": "Success!",
                        "message": "The record has been updated successfully."
                    });
                    this.getRelationShipTableData(cmp,event,helper);  
                }else{
                    toastEvent.setParams({
                        "type":"Error",
                        "title": "Error!",
                        "message": "Something went wrong"
                    });
                }
                toastEvent.fire();
            } else if (state === "ERROR") {
                var errors = response.getError();
                console.error(JSON.stringify(errors));
            }
        });
        $A.enqueueAction(action); 
    },
    removeAssociationRecord: function(cmp,event,helper){
        var action = cmp.get("c.removeAssociationRecord");
        
        console.log('inside delete record');
        
        var asscoiationRecord = cmp.get("v.association");
        
        var actionParam = cmp.get("v.actionClicked");
        
        console.log("cmp.get(v.association)::"+ JSON.stringify(cmp.get("v.association")));
        
        action.setParams ({"associationObj": JSON.stringify(asscoiationRecord),"action":actionParam});
        
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                console.log('inside success');
                var taskCompleted =  response.getReturnValue()
                console.log('task::'+taskCompleted);
                var toastEvent = $A.get("e.force:showToast");
                if(taskCompleted){
                    toastEvent.setParams({
                        "type":"Success",
                        "title": "Success!",
                        "message": "The record has been updated successfully."
                    });
                    this.getRelationShipTableData(cmp,event,helper);  
                }else{
                    toastEvent.setParams({
                        "type":"Error",
                        "title": "Error!",
                        "message": "Something went wrong"
                    });
                }
                toastEvent.fire();
            } else if (state === "ERROR") {
                var errors = response.getError();
                console.error(JSON.stringify(errors));
            }
        });
        $A.enqueueAction(action); 
    }
    
    
    
})