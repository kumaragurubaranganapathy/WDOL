({
   doInit : function(component, event, helper) {
       helper.setJSON(component, event, helper);
  },
    openExistingApp : function(component, event, helper){
        helper.openExistingAppHelper(component, event, helper);
    },
    renewApplication : function(component, event, helper){
        helper.renewApplicationHelper(component, event, helper);
    },
    renewLicense : function(component, event, helper){         
        helper.renewLicenseHelper(component, event, helper);
    },
    viewMoreLicenses : function(component, event, helper){
        helper.viewMoreLicenses(component, event, helper);
    },
    viewMoreApplications : function(component, event, helper){
        helper.viewMoreApplications(component, event, helper);
    }
})