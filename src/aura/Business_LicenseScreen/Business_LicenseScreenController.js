({
	doInit : function(component, event, helper) {
        helper.doInit(component);
        var branch = component.get("v.BranchLicenses");
        console.log("branch::"+branch);
        console.log("accountId::"+component.get("v.accountId"));
        helper.setCurrentLicensesTableData(component, event);
        
    },
    
    displayLicenseDetails : function(component,event){
        var licenseId = event.target.getAttribute("data-licenseId");
        var primaryAccountId = event.target.getAttribute("data-accountId");
        console.log("licenseId::"+licenseId);
        console.log("primaryAccountId::"+primaryAccountId);
        component.set("v.licenseId",licenseId);
        var compEvent = component.getEvent("businessRefresh"); 
        compEvent.setParams({"LicenseId" : licenseId});
        compEvent.setParams({"displayLicenseDetails" : true});
        compEvent.setParams({"primaryAccountId" : primaryAccountId});
        compEvent.setParams({"isbranch":component.get("v.BranchLicenses")});
        compEvent.fire();
    },
    
    renewLicense : function(component,event,helper){
          var ctarget = event.currentTarget;
          console.log('inside draftLicense::');
          sessionStorage.setItem("licId", ctarget.getAttribute("data-recordId"));
          sessionStorage.setItem("licenseType", ctarget.getAttribute("data-licenseType"));
          sessionStorage.setItem("board", ctarget.getAttribute("data-board"));
          sessionStorage.setItem("applicationType", ctarget.getAttribute("data-applicationType"));
          sessionStorage.setItem("applicationId", ctarget.getAttribute("data-app"));                                      
          var appIsRenewal = ctarget.getAttribute("data-appisRenewal");
          
          var renewreinstate = ctarget.getAttribute("data-renewereinstate");
          if(appIsRenewal == 'true'){
              console.log('inside renewreinstate::');
              sessionStorage.setItem("renewalReinstate", renewreinstate);
              sessionStorage.setItem("flowType", "Application");
              window.location.href='/lightningwashington/s/polaris-renewal';  
          } else
          { 	sessionStorage.setItem("flowType", renewreinstate);
                window.location.href='/lightningwashington/s/renewreinstate';
           }
              
   }
})