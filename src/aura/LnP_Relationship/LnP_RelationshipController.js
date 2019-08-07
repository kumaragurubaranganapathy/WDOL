({
	doInit : function(component, event, helper) {
        helper.doInit(component,event);
        helper.getRelationShipTableData(component, event, helper);
		helper.fetchPeerRelationShipDataRecords(component, event, helper);
    },
    
    onCancelAccnConClick: function(component,event,helper){
        console.log("inside cancel");
    	var recData = event.currentTarget.getAttribute("data-id");
        var toRemove = true;
        var buttonName = event.currentTarget.getAttribute("data-button");
        console.log("recData::"+recData);
        console.log("buttonName::"+ buttonName);
        var accountName = component.get("v.accountName");
        var Objectlist = component.get("v.CurrentLicenseTableDataList");
        console.log("Objectlist::"+JSON.stringify(Objectlist));
        for(var j=0;j<Objectlist.length;j++){
            console.log("recData::"+recData);
            console.log("Objectlist[j]::"+Objectlist[j].Id);
            if(recData == Objectlist[j].Id){
                console.log("inside for:"+Objectlist[j]);
                delete Objectlist[j].attributes;
                delete Objectlist[j].url;
                if(component.get("v.sObjectName") === 'MUSW__Account_Contact__c'){
                    console.log("inside object name check::"+ component.get("v.sObjectName"));
                    console.log("Objectlist[j].Role__c::" +Objectlist[j].Role__c);
                    console.log("account Name ::"+component.get("v.accountName"));
                    if(Objectlist[j].Role__c == 'Administrator'){
                        if(component.get("v.adminCount") == 1){
                            toRemove  = false; 
                            var toastEvent = $A.get("e.force:showToast");
                             toastEvent.setParams({
                                "type":"Error",
                                "title": "Warning",
                                "message": "You can’t remove, please contact DOL"
                            });
                            toastEvent.fire();
                        }else{
                            component.set("v.isModalOpen", true);
                        	component.set("v.adminFlag",true);  
                        }
                        
                    }else if(Objectlist[j].Role__c == 'Designated Controlling Person' && buttonName === 'remove' && accountName.includes("Appraisal Management Company") && Objectlist[j].DCP__c == true ){
						console.log("inside Appraisal Mangement");
                        toRemove  = false;                    
                    }
                    else{
                         component.set("v.otherFlag",true);
                         component.set("v.isModalOpen", true);
                    } 
                    component.set("v.accountContact",Objectlist[j]);
                }else{
                   component.set("v.association",Objectlist[j]); 
                }
                break;
            }
        }
        component.set("v.actionClicked",'Remove');
        if(component.get("v.sObjectName") != 'MUSW__Account_Contact__c' ){
            component.set("v.isModalOpen", true);
            component.set("v.associateFlag",true);
           // helper.removeAssociationRecord(component,event,helper);   
        }else if(toRemove){
            console.log("inside helper call::");
           helper.removeAccountContactRecord(component,event,helper);
        } else{
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                                "type":"Error",
                                "title": "Warning",
                                "message": "You cannot remove Designated Controlling person from this Account"
                            });
             toastEvent.fire();
        }
    }, 
    
    removeClick: function(component,event,helper){
        console.log("inside removeClick");
        var recData = event.getSource().get("v.value");
        console.log("recData::"+recData);
        var Objectlist = component.get("v.CurrentLicenseTableDataList");
        console.log("Objectlist::"+JSON.stringify(Objectlist));
        for(var j=0;j<Objectlist.length;j++){
            console.log("recData::"+recData);
            console.log("Objectlist[j]::"+Objectlist[j].Id);
            if(recData == Objectlist[j].Id){
                console.log("inside for:"+Objectlist[j]);
                delete Objectlist[j].attributes;
                delete Objectlist[j].url;
                if(component.get("v.sObjectName") == 'MUSW__Account_Contact__c'){
                    if(Objectlist[j].Role__c == 'Administrator'){
                        if(component.get("v.adminCount") == 1){
                            var toastEvent = $A.get("e.force:showToast");
                             toastEvent.setParams({
                                "type":"Error",
                                "title": "Warning",
                                "message": "You can’t remove, please contact DOL"
                            });
                            toastEvent.fire();
                        }else{
                            component.set("v.isModalOpen", true);
                        	component.set("v.adminFlag",true);  
                        }
                        
                    }else{
                         component.set("v.otherFlag",true);
                         component.set("v.isModalOpen", true);
                    }                    
                }else{
                   component.set("v.association",Objectlist[j]); 
                }
                break;
            }
        }
        component.set("v.actionClicked",'Remove');
        if(component.get("v.sObjectName") == 'MUSW__Account_Contact__c'){
        	helper.removeAccountContactRecord(component,event,helper);
        }
        else{
             component.set("v.isModalOpen", true);
            component.set("v.associateFlag",true);
            // helper.removeAssociationRecord(component,event,helper);
        }
           
    },
    
    resendClick : function(component,event,helper){
        var recData = event.getSource().get("v.value");
        console.log("recData::"+recData);
        var Objectlist = component.get("v.CurrentLicenseTableDataList");
        console.log("Objectlist::"+JSON.stringify(Objectlist));
        for(var j=0;j<Objectlist.length;j++){
            console.log("recData::"+recData);
            console.log("Objectlist[j]::"+Objectlist[j].Id);
            if(recData == Objectlist[j].Id){
                console.log("inside for:"+Objectlist[j]);
                delete Objectlist[j].attributes;
                delete Objectlist[j].url;
                if(component.get("v.sObjectName") == 'MUSW__Account_Contact__c'){
                   
                    component.set("v.accountContact",Objectlist[j]);
                }else{
                   component.set("v.association",Objectlist[j]); 
                }
                break;
            }
        }
        component.set("v.actionClicked",'Resend');
        if(component.get("v.sObjectName") == 'MUSW__Account_Contact__c'){
        helper.removeAccountContactRecord(component,event,helper);
        }
        else
            helper.removeAssociationRecord(component,event,helper);
    },
    
     handleComponentEvent :  function(component,event,helper){
        var refresh = event.getParam("refresh");
        console.log('inside refresh::');
        if(refresh){
           helper.getRelationShipTableData(component, event, helper); 
        }
        
    },
        
   openModel: function(component, event, helper) {
      // Set isModalOpen attribute to true
      component.set("v.isModalOpen", true);
   },
  
   closeModel: function(component, event, helper) {
      // Set isModalOpen attribute to false  
      component.set("v.isModalOpen", false);
   },
   
   submitDetails : function(component,event,helper){
       console.log("Inside submitDetails ::");
            helper.removeAccountContactRecord(component,event,helper);
            component.set("v.isModalOpen", false);
  },
    
    submit : function(component,event,helper){
         component.set("v.isModalOpen", false);
         helper.removeAssociationRecord(component,event,helper);
         component.set("v.associateFlag", false);
    }
        
})