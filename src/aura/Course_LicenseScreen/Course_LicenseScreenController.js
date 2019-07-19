({
    doInit : function(component, event, helper) {
      var accId = component.get("v.accountId");
      console.log('account id----'+accId);
      console.log("accountId::"+component.get("v.accountId"));  
      helper.fetchData(component,event, helper);
    },
    renewLicense : function(component, event, helper){         
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
        var primaryAccountId = event.target.getAttribute("data-accountId");
        var compEvent = component.getEvent("businessRefresh"); 
        compEvent.setParams({"LicenseId" : licenseId});
        compEvent.setParams({"displayCourseDetails" : true});
        compEvent.setParams({"primaryAccountId" : primaryAccountId});
        compEvent.fire();
    },
    downloadDocument : function(component, event, helper) {
        console.log('Pending Application Button');
        var recordIdForPDF = event.getSource().get("v.value");
        console.log('recordIdForPDF== ' + recordIdForPDF);
        var OrgURLForPDF = $A.get("$Label.c.OrgURLForPDF");
        var url = OrgURLForPDF+'apex/DOL_PDFGenerator?id=' + recordIdForPDF;
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url": url
        });
        urlEvent.fire();
    }
})