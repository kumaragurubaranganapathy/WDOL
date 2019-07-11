({
	doInit : function(component, event, helper) {
      var accId = component.get("v.accountId");
      console.log('draft account id----'+accId);
      helper.fetchData(component,event, helper);
      helper.fetchActionDetails(component,event,helper);
    },
    
    editDraftLicenseApplication :  function(component,event,helper){
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
    
     deleteDraftLicenseApplication: function(component, event, helper) {
      var ctarget = event.currentTarget;
      var application_Id = ctarget.getAttribute("data-recordId");
  },
    
    ActionClick :  function(component,event,helper){
        console.log("inside action");
        var ctarget = event.currentTarget;
        var task = ctarget.getAttribute("data-record");
        console.log("task:"+ JSON.stringify(task));
        var actionName = ctarget.getAttribute("data-action");
        console.log("actionName:"+actionName);
        var taskType = ctarget.getAttribute("data-type");
        console.log("taskType:"+taskType);
        component.set("v.tasktype",taskType);
        var hasTask = false;
        var taskList = component.get("v.DraftMandatoryActionsApplicationsData");
        for(var i=0;i<taskList.length;i++){
            if(taskList[i].Id == task){
                 component.set("v.task",taskList[i]);
                 hasTask = true;
                 break;
            }
        }
       
        component.set("v.actionclicked",actionName); 
       
        if(hasTask){
         helper.actionRequest(component, event, helper);     
        }
        
    } 
})