({
	setCompletedMaintanceRequestTableData :function(component,event, helper){
        
        console.log('In LnP_Dashboard_2.aura-helper::setCompletedMaintanceRequestTableData ');
        
        var action = component.get("c.CompletedMaintananceRequestApplicationsTable");
        action.setParams({
            accountId : component.get("v.accountId") 
        });        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                //var pendingMaintanceRequestTable = JSON.parse(response.getReturnValue());
                
                //var completedMaintananceRequestApplicationsColumnData = pendingMaintanceRequestTable["tableHeader"];
                
                var completedMaintananceRequestApplicationsTableData = response.getReturnValue();
                
                //console.log('In businessDashboard.aura-helper::setPendingMaintanceRequestTableData '+JSON.stringify(pendingMaintanceRequestTable));
                
                //component.set("v.CompletedRequestColumns",completedMaintananceRequestApplicationsColumnData);
                for(var i =0; i<completedMaintananceRequestApplicationsTableData.length;i++)
                {
                    if(completedMaintananceRequestApplicationsTableData[i].End_Time__c!=null && completedMaintananceRequestApplicationsTableData[i].End_Time__c!='')
                        completedMaintananceRequestApplicationsTableData[i].End_Time__c = new Date(completedMaintananceRequestApplicationsTableData[i].End_Time__c);                    
                }
                component.set("v.CompletedRequestData",completedMaintananceRequestApplicationsTableData);
                
            } 
            else if (state === "ERROR") {
                
                var errors = response.getError();
                
                console.error(JSON.stringify(errors));
            }
        });
        $A.enqueueAction(action);    
    },
})