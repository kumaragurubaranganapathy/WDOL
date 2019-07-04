({
	 fetchData : function (component,event,helper) {
        var accountIdValue = component.get("v.accountId");
        console.log('acccount id value in fetch data ',accountIdValue)
        var action = component.get("c.getAllCourses");
      
          action.setParams({
              accountId : component.get("v.accountId") 
          });
       action.setCallback(this, function(response) {
            var state = response.getState();
            console.log('state---'+state);
            if (state === "SUCCESS") {
                var data = response.getReturnValue();
                console.log('return value '+response.getReturnValue());
                console.log('course::'+ JSON.stringify(data));
                component.set('v.courseList',data);
                               
            }                          
        });
        $A.enqueueAction(action);
    },
    

})