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
    manageEndorsement : function(component, event, helper){         
        helper.manageEndorsementHelper(component, event, helper);
    },
    
    manageLicense : function(component,event,helper){
        helper.manageLicenseHelper(component,event,helper);
    },
    handleValueSelect : function(component, event, helper){        
        var parcedValue = event.getParam("value").split(',');       
        var selectvalue = parcedValue[0];
        var selectedfirst = parcedValue[1];
        var selectedsecond = parcedValue[2];
        if(selectvalue=='PDF')
        {
            window.location.href = '/SaveIncompleteApplication?applicationType='+selectedfirst+'&pid='+selectedsecond;
        }
        else
        helper.manageEndorsementHelper(component, event, helper);
    },
    viewMoreLicenses : function(component, event, helper){
        helper.viewMoreLicenses(component, event, helper);
    },
    
    viewMoreBusLicenses : function(component,event,helper){
        helper.viewMoreBusnesLicenses(component,event,helper);
    },
    
    viewMoreApplications : function(component, event, helper){
        helper.viewMoreApplications(component, event, helper);
    }
})