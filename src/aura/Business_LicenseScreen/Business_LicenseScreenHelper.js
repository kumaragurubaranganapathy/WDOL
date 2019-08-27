({
    doInit : function(component) {
        var tDate = new Date();
        component.set("v.todayDate",tDate);
        
    },
    
    setCurrentLicensesTableData :function(component,event){
        var action = component.get("c.setBusinessLicenseTable");
        action.setParams({'AccountId': component.get("v.accountId"),
                          'branch': component.get("v.BranchLicenses"),
                          'LicenseId': component.get("v.licenseId")
                         });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var currentLicenseTableData = JSON.parse(response.getReturnValue());                
                
                var currentLicenseTableColumnData = currentLicenseTableData.tableHeader;
                
                
                var currentLicenseTableHeaderData = currentLicenseTableData.tableData;
                
                component.set("v.CurrentLicenseTableColumnsList",currentLicenseTableColumnData);
                
                component.set("v.CurrentLicenseTableDataList",currentLicenseTableHeaderData);
                
                component.set("v.loadingSpinner",false);
                
                console.log("currentLicenseTableColumnData::"+JSON.stringify(currentLicenseTableHeaderData));
                
                console.log("currentLicenseTableColumnheadingsData::"+JSON.stringify(currentLicenseTableColumnData));
                
            } else if (state === "ERROR") {
                var errors = response.getError();                
            }
        });
        $A.enqueueAction(action);
    },
    
    getHelptextHelper : function(component, event, obj, license_Status, license_Sub_Status){
        var action = component.get("c.helptextFetch");
        action.setCallback(this, function(response){
        var state = response.getState();
        if(state === "SUCCESS"){
        var result = response.getReturnValue();
        typeof result;
        var resultMap = JSON.parse(result);
        component.set("v.helptextmap", resultMap);
             component.set("v.loadingSpinner",false);
    }
     else if(state === 'ERROR'){                
        var errors = response.getError();
        console.error(JSON.stringify(errors));  
          component.set("v.loadingSpinner",false);
    }
    });
    
    $A.enqueueAction(action);
    },
    
      setLocationTable : function(component,event,helper){
        var action = component.get("c.setLocationTable");
        var applicationId =  component.get("v.licenseId");
        console.log('applicationId::'+applicationId);
          action.setParams({'applicationId': applicationId});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var currentLicenseTableData = JSON.parse(response.getReturnValue());                
                
                var currentLicenseTableColumnData = currentLicenseTableData.tableHeader;
                
                
                var currentLicenseTableHeaderData = currentLicenseTableData.tableData;
                 component.set("v.loadingSpinner",false);
                component.set("v.affLocationTableList",currentLicenseTableHeaderData);
                
                component.set("v.affLocTableColumnsList",currentLicenseTableColumnData);                
                
                console.log("currentLicenseTableColumnData::"+JSON.stringify(currentLicenseTableHeaderData));
                
                console.log("currentLicenseTableColumnheadingsData::"+JSON.stringify(currentLicenseTableColumnData));
                
              
            } else if (state === "ERROR") {
                var errors = response.getError();                
            }
        });
        $A.enqueueAction(action);
    },
    
      addRequestHelper : function(component, event, helper) {       
        var requestId='';        
        var action = component.get("c.insertRequest");
        action.setParams({            
            "licId": component.get("v.licenseId"),
            "licenseType": component.get("v.licenseType"),
            "board":component.get("v.board"),
            "ServiceRequestType": component.get("v.ServiceRequestType"),           
        });
        action.setCallback(this, function(actionResult){
            
            var state = actionResult.getState();
            if (state === "SUCCESS"){
                var result = actionResult.getReturnValue();
                requestId = result;
                sessionStorage.setItem("ServiceRequestType", component.get("v.ServiceRequestType"));                
                sessionStorage.setItem("board", component.get("v.board"));
                sessionStorage.setItem("licenseType", component.get("v.licenseType"));
                sessionStorage.setItem("applicationType", component.get("v.applicationMethod"));
                sessionStorage.setItem("requestId", requestId);
                sessionStorage.setItem("recordId", component.get("v.recordId"));
                window.location.href = $A.get("$Label.c.Polaris_Portal_Home")+'manage-request';                    
            }
        });
        $A.enqueueAction(action);
        console.log('componet.get("v.requestId")',componet.get("v.requestId"));
        
    },

})