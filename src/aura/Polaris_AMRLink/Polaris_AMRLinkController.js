({
	doInit : function(component, event, helper) {   
        console.log('record ID : ',component.get("v.recordId"));
        console.log('board ID : ',component.get("v.board"));
        console.log('licensetype ID : ',component.get("v.licenseType"));
        console.log('application tyep ID : ',component.get("v.applicationMethod"));
        helper.fetchServiceLinkFromServerHelper(component, event, helper); 
        helper.getpickListValues(component,event,helper);
    },
    
    startAMR : function(component, event, helper) {   
        helper.startAMRHelper(component, event, helper);        
    },
    
    closeModel : function(component,event,helper){
        component.set("v.isModalOpen",false);
    },
    
    submitDetails : function(component,event,helper){
        var license = component.find("branchId").get("v.value");
        console.log("license::"+license);
        component.set("v.branchLicense",license);
        helper.licensePage(component,event,helper);
    }
    
})