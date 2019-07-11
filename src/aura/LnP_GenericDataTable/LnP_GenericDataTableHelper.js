({
    setColumnData : function(component, event, helper) {
        try{
            var dynamicHeaderData = [];
            var givenColumnData = component.get('v.setSobjectColumnsToDataTable');
            for (let fieldAPIName of Object.keys(givenColumnData)) {
                var colDataObj = {label:givenColumnData[fieldAPIName],fieldName:fieldAPIName};
                dynamicHeaderData.push(colDataObj);
            }
            console.log(JSON.stringify(givenColumnData));
            component.set('v.sObjectColumns',dynamicHeaderData);    
        }catch(error){
            console.error('setColumnData ---> '+error);
        }    
    },
    setRowData : function(component, event, helper) {
        try{
            var dynamicHeaderData = [];
            var givenColumnData = component.get('v.setSobjectColumnsToDataTable');
            var sObjectAPIName  = component.get('v.setsObjectAPIToDataTable');
            var setSobjectBusinessFunction = component.get('v.setSobjectBusinessFunction');
            for (let fieldAPIName of Object.keys(givenColumnData)) {
                
                dynamicHeaderData.push(fieldAPIName);
            }
            console.log(JSON.stringify(dynamicHeaderData)); 
            var action = component.get('c.getSobjectData');
            action.setParams ({"soqlFields":dynamicHeaderData,"sObjectName":sObjectAPIName,"BusinessFunction":setSobjectBusinessFunction});
            action.setCallback(this, function (response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    var tableData =  response.getReturnValue()
                    
                    if(tableData){
                       component.set('v.sObjectData', tableData); 
                    }else{
                        component.set('v.isVisible',false);
                    }
                    console.log(response.getReturnValue());
                } else if (state === "ERROR") {
                    var errors = response.getError();
                    console.error(JSON.stringify(errors));
                    component.set('isVisible',false);
                }
            });
            $A.enqueueAction(action);
        }catch(error){
            console.error('setRowData -->'+error);
        } 
    }
})