({
	/*fetchData : function (component,event) {
        var accountIdValue = component.get("v.accountId");        
        var action = component.get("c.getAllLicenses");        
        action.setParams({
              accountId : component.get("v.accountId") 
        });
       action.setCallback(this, function(response) {
            var state = response.getState();            
            if (state === "SUCCESS") {
                var data = response.getReturnValue();                
                component.set('v.licenseList',data);
                var appList = component.get("v.licenseList");
                var draftAppList = [];
                for(var i = 0 ;i<appList.length;i++){
                    
                    if(appList[i].MUSW__Status__c === 'Generate Fee' ){                        
                        draftAppList.push(appList[i]);                        
                     }        
                 
                }    
                  component.set("v.PendingNewLicenseApplications", draftAppList);     
            }                          
        });
        $A.enqueueAction(action);
    },*/
    
   /* fetchRenewalData : function(component,event){
        var accountIdValue = component.get("v.accountId");        
        var action = component.get("c.getAllRenewalApplications");
        action.setParams({
              accountId : component.get("v.accountId") 
        });
        action.setCallback(this, function(response) {
            var state = response.getState();            
            if (state === "SUCCESS") {
                var data = response.getReturnValue();                
                component.set('v.renewalAppList',data);
                var renAppList = component.get("v.renewalAppList");
                var draftRenAppList = [];
                for(var i = 0 ;i<renAppList.length;i++){
                    
                    if(renAppList[i].MUSW__Status__c === 'Generate Fee'){                        
                        draftRenAppList.push(renAppList[i]);
                       
                     }        
                 
                }    
                  component.set("v.PendingRenewalApplications", draftRenAppList);                 
            }                          
        });
        $A.enqueueAction(action);
    },*/
    
    fetchPendingCourseData :function(component, event, helper, selectedAccountId){
    
    
            var action = component.get("c.fetchPendingCourseData");
            
            action.setParams({'accountID': selectedAccountId});
             
            action.setCallback(this, function(response) {
                
                var state = response.getState();
                
                if (state === "SUCCESS") {
                    
                    var pendingcourseTable = JSON.parse(response.getReturnValue());
                    
                    var pendingCourseColumnData = pendingcourseTable["tableHeader"];
                    
                    var pendingCourseTableData = pendingcourseTable["tableData"];
                    
                    component.set("v.PendingCourseApplicationsColumns",pendingCourseTableData);
                    
                    component.set("v.PendingCourseApplicationsData",pendingCourseTableData);
                    
                } else if (state === "ERROR") {
                    
                    var errors = response.getError();
                    
                    console.error(JSON.stringify(errors));
                }
            });
            $A.enqueueAction(action);
        
        
        
    },
    
    setPendingNewLicenseApplicationsTableData : function(component, event, helper){
        
        try{
            
            console.log("In ...setPendingNewLicenseApplicationsTableData ::"+ component.get("v.accountId"));

        var action = component.get("c.pendingNewLicenseApplicationsTbl");
        
        action.setParams({'accountID': component.get("v.accountId")});
         
        action.setCallback(this, function(response) {
            
            var state = response.getState();
            
            if (state === "SUCCESS") {
                
            var pendingNewLicenseTableData = JSON.parse(response.getReturnValue());
            
            //console.log(JSON.stringify(currentLicenseTableData));
            
            var pendingNewLicenseTableDataTableColumnData = pendingNewLicenseTableData["tableHeader"];
            
            var pendingNewLicenseTableDataTableHeaderData = pendingNewLicenseTableData["tableData"];
            
            console.log('setPendingNewLicenseApplicationsTableData '+JSON.stringify(pendingNewLicenseTableDataTableColumnData));
            
            component.set("v.PendingNewLicenseApplicationColumns",pendingNewLicenseTableDataTableColumnData);
            
            component.set("v.PendingNewLicenseApplications",pendingNewLicenseTableDataTableHeaderData);
                
            } else if (state === "ERROR") {
                
                var errors = response.getError();
                
                console.error(JSON.stringify(errors));
            }
        });
        
        $A.enqueueAction(action);
        }catch(e){
            console.error('setPendingNewLicenseApplicationsTableData......'+e);
        }
    },
    
    setPendingRenewalApplicationsTableData : function(component, event, helpert, selectedAccountId){
        
        var action = component.get("c.PendingRenewApplicationsTable");
        
        action.setParams({'accountID': selectedAccountId});
         console.log('selectedAccountId ---->'+selectedAccountId);
        action.setCallback(this, function(response) {
            
            var state = response.getState();
            
            if (state === "SUCCESS") {
                
                var pendingRenewApplicationsTable = JSON.parse(response.getReturnValue());
                
                var pendingRenewApplicationsTableColumnData = pendingRenewApplicationsTable["tableHeader"];
                
                var pendingRenewApplicationsTableHeaderData = pendingRenewApplicationsTable["tableData"];
                
                console.log('setPendingRenewalApplicationsTableData '+JSON.stringify(pendingRenewApplicationsTable));
                
                component.set("v.PendingRenewalApplicationColumns",pendingRenewApplicationsTableColumnData);
                
                component.set("v.PendingRenewalApplications",pendingRenewApplicationsTableHeaderData);
                
            } else if (state === "ERROR") {
                
                var errors = response.getError();
                
                console.error(JSON.stringify(errors));
            }
        });
        $A.enqueueAction(action);
    },
    
    setPendingMaintanceRequestTableData : function(component, event, helper, selectedAccountId){
        
        var action = component.get("c.PendingMaintananceRequestApplicationsTable");
        
        action.setParams({'accountID': selectedAccountId});
         
        action.setCallback(this, function(response) {
            
            var state = response.getState();
            
            if (state === "SUCCESS") {
                
            var pendingMaintanceRequestTable = JSON.parse(response.getReturnValue());
            
            var pendingMaintanceRequestColumnData = pendingMaintanceRequestTable["tableHeader"];
            
            var pendingMaintanceRequestTableData = pendingMaintanceRequestTable["tableData"];
            
            console.log('setPendingMaintanceRequestTableData '+JSON.stringify(pendingMaintanceRequestTable));
            
            component.set("v.PendingMaintenanceRequestApplicationColumns",pendingMaintanceRequestColumnData);
            
            component.set("v.PendingMaintenanceRequestApplications",pendingMaintanceRequestTableData);
                
            component.set("v.loadingSpinner",false);
                
            } else if (state === "ERROR") {
                
                var errors = response.getError();
                
                console.error(JSON.stringify(errors));
            }
        });
        $A.enqueueAction(action);
    },
        
})