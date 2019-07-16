({
    fetchRelatedEmploymentHistoryRecords : function(component, event, helper, relatedSObject_Id, relatedSobjectName){
        
        console.log('In ... fetchRelatedEmploymentHistoryRecords '+relatedSObject_Id);
        
        console.log('In ... fetchRelatedEmploymentHistoryRecords '+relatedSobjectName);
        
        var action = '';
       if(relatedSobjectName === 'License__c'){
            
            action = component.get("c.fetchLicenseRelatedEmploymentHistoryRecords");
            
        }else if(relatedSobjectName === 'Renewal_Reinstatement_Application__c'){
            
            action = component.get("c.fetchRenewalRelatedEmploymentHistoryRecords");
        }
            
            action.setParams({"relatedRecordId":relatedSObject_Id});
        
            action.setCallback(this,function(response){
                
                var state = response.getState();
                
                if (state === "SUCCESS") {
                    
                    console.log('succesfully fetched the records.....');
                  
                }else if (state === "ERROR") {
                    
                    var errors = response.getError();
                    
                    console.error(JSON.stringify(errors));
                }    
            });
            
            $A.enqueueAction(action);
        
    },
    
    fetchRelatedEducationalHistoryRecords : function(component, event, helper, relatedSObject_Id, relatedSobjectName){
        

    },
})