({
	doInit : function(component, event, helper) {
        helper.doInit(component,event);
        helper.getRelationShipTableData(component, event, helper);
        helper.fetchPeerRelationShipDataRecords(component, event, helper);
    },
    
    onCancelAccnConClick: function(component,event,helper){
        console.log("inside cancel");
    	var recData = event.currentTarget.getAttribute("data-id");
        var buttonClicked = event.currentTarget.getAttribute("data-button");
        var toRemove = true;
        var buttonName = event.currentTarget.getAttribute("data-button");
        console.log("buttonName::"+ buttonName);
        var accountName = component.get("v.accountName");
        var Objectlist = component.get("v.CurrentLicenseTableDataList");
        for(var j=0;j<Objectlist.length;j++){
            if(recData == Objectlist[j].Id){
                console.log("inside for:"+Objectlist[j]);
                delete Objectlist[j].attributes;
                delete Objectlist[j].url;
                if(component.get("v.sObjectName") === 'MUSW__Account_Contact__c'){
                    if(Objectlist[j].Role__c == 'Administrator' && buttonClicked != 'cancel'){
                        console.log('admincount::'+component.get("v.adminCount"));
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
                        
                        }else{
                         	component.set("v.isModalOpen", true);
                         component.set("v.adminFlag",true);
                                                 
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
        }
    }, 
    removeClickOwner:function(component,event,helper){
        component.set("v.isModalOpen",false);
        component.set("v.ownerFlag",false);        
        var Objectlist = component.get("v.CurrentLicenseTableDataList");
        for(var j=0;j<Objectlist.length;j++){
            component.set("v.accountContact",Objectlist[j]);
        }
        helper.removeOwnerRecordHelper(component,event,helper);
    },
    saveClickOwner:function(component,event,helper){
        console.log("inside saveClickOwner");
        var Objectlist = component.get("v.CurrentLicenseTableDataList");
        for(var j=0;j<Objectlist.length;j++){
            component.set("v.accountContact",Objectlist[j]);
        }
        helper.saveOwnerRecordHelper(component,event,helper);
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
    },
    openOwnerModal : function(component,event,helper){
        component.set("v.ownerFlag",true);
        component.set("v.isModalOpen",true);
        var ownerId = event.getSource().get("v.value");
        component.set("v.ownerId",ownerId);
    }
        
})