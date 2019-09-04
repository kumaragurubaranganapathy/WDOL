({
    fetchData : function (component,event) {
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
               console.log('**All Courses'+data);
               component.set('v.courseList',data);
               component.set("v.loadingSpinner",false);
                              
           }                          
       });
       $A.enqueueAction(action);
   },
 /*   renewLicenseHelper : function(component, event, helper) {	  
       var parcedValue = event.getSource().get("v.value").split(',');
        console.log('parcedValue---'+parcedValue);
       var renewReinstate = parcedValue[0];
       var licID = parcedValue[1];
       var board = parcedValue[2];
       var licenseType = parcedValue[3];
       var applicationType = parcedValue[4];                                
       var licenseAppId = parcedValue[5];
       var appIsRenewal = parcedValue[6];
       
       sessionStorage.setItem("licId", licID);
       sessionStorage.setItem("licenseType", licenseType);
       sessionStorage.setItem("board", board );
       sessionStorage.setItem("applicationType", applicationType);
       sessionStorage.setItem("applicationId", licenseAppId);                                      
       if(appIsRenewal == 'true'){
           sessionStorage.setItem("renewalReinstate", renewReinstate);
           sessionStorage.setItem("flowType", "Application");
           window.location.href='/lightningwashington/s/polaris-renewal';
       } else{
           sessionStorage.setItem("flowType", renewReinstate);
           window.location.href='/lightningwashington/s/renewreinstate';
       }
       //sessionStorage.setItem("applicationId", "a020b00000laUUD");
       // window.location.href='/lightningwashington/s/renewreinstate';                                                 	  
   }, */
   

})