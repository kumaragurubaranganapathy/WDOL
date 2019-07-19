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
        console.log('helptextmap::'+result);
        console.log('size::'+result.prototype.size);
    }
     else if(state === 'ERROR'){                
        var errors = response.getError();
        console.error(JSON.stringify(errors));               
    }
    });
    
    $A.enqueueAction(action);
    }

})