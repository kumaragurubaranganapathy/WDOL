({
    doInit : function(component, event, helper) {
      var accId = component.get("v.accountId");
      console.log('account id----'+accId);
      helper.fetchData(component,event, helper);
    },
    
    editApplication : function(component,event,helper){
          var ctarget = event.currentTarget;
          console.log('inside draftLicense::');
          sessionStorage.setItem("applicationId", ctarget.getAttribute("data-recordId"));
          sessionStorage.setItem("licenseType", ctarget.getAttribute("data-licenseType"));
          sessionStorage.setItem("board", ctarget.getAttribute("data-board"));
          sessionStorage.setItem("applicationType", ctarget.getAttribute("data-applicationType"));
          sessionStorage.setItem("flowType", "Application");
          if(ctarget.getAttribute("data-isrenewal") == "true"){
              console.log('inside renewreinstate::');
              sessionStorage.setItem("renewalReinstate", "Renewal");
              window.location.href='/lightningwashington/s/polaris-renewal';  
          } else {
              window.location.href='/lightningwashington/s/apply-for-license';  
          }
    },
    
    displayCourseDetails : function (component,event,helper) {
        console.log('dsiplayCourseDetails........');
        var licenseId = event.target.getAttribute("data-licenseId");
        component.set("v.licenseId",licenseId);
        var compEvent = component.getEvent("businessRefresh"); 
        compEvent.setParams({"LicenseId" : licenseId});
        compEvent.setParams({"displayCourseDetails" : true});
        compEvent.fire();
    }
})