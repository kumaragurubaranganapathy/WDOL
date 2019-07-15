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
            } else if (state === "ERROR") {
                var errors = response.getError();                
            }
        });
        $A.enqueueAction(action);
    }
    
    
   
})