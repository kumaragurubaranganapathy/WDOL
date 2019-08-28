({
    fetchServiceLinkFromServerHelper : function(component, event, helper) {
        var action = component.get("c.fetchServiceLinksServer");
        action.setParams({
            "board": component.get("v.board"),
            "licenseType": component.get("v.licenseType"),
            "applicationMethod": component.get("v.applicationMethod")
        });
        action.setCallback(this, function(actionResult){
            var state = actionResult.getState();
            if (state === "SUCCESS"){
                var result = actionResult.getReturnValue();
                var amrLength = result.length;
                component.set("v.ServiceLink",result);                 
                component.set("v.amrLinkNum",amrLength);
            }else{
                window.location.href = "./error";
            }
            
        });
        $A.enqueueAction(action);
    },
    
    startAMRHelper : function(component, event, helper) {
        var parcedValue = event.getSource().get("v.value").split(',');
        var licID = parcedValue[0];
        var link = parcedValue[1];
        var board = parcedValue[2];
        var licenseType = parcedValue[3];
        var applicationmethod = parcedValue[4];                                
        var serviceRequestType = parcedValue[5];
        var AMRType = parcedValue[6];
        component.set("v.ServiceRequestType",serviceRequestType);
        //alert(licID);
        if(link == 'Add Branch License'){
			component.set("v.isModalOpen",true);  
            helper.getpickListValues(component,event,helper);
        }else{         
        if(AMRType== 'Self Service')
        {
            if(link == 'Update Mailing Address'){
                window.location.href = $A.get("$Label.c.Polaris_Portal_Self_Service")+'?par1='+licID+'&par2=address';
            }
            else if(link == 'Update License Webaddress')
            {
                window.location.href = $A.get("$Label.c.Polaris_Portal_Self_Service")+'?par1='+licID+'&par2=License';
            }else if(link == 'Print License'){
                window.location.href = $A.get("$Label.c.Polaris_Portal_Self_Service")+'?par1='+licID+'&par2=print';
            }
            
        }
        else {
            if(serviceRequestType == 'Endorsement')
            {
                sessionStorage.setItem("ServiceRequestType", serviceRequestType);
                sessionStorage.setItem("licId", licID);
                sessionStorage.setItem("board", board);
                sessionStorage.setItem("licenseType", licenseType);
                sessionStorage.setItem("applicationMethod", applicationmethod);
                window.location.href=$A.get("$Label.c.Polaris_Portal_Home")+'manage-endorsement';
            }
            else
            {
                helper.addRequestHelper(component, event, helper);
            }
        }
        }        
        
    },
    
    addRequestHelper : function(component, event, helper) {       
        var requestId='';        
        var action = component.get("c.insertRequest");
        action.setParams({            
            "licId": component.get("v.recordId"),
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
    
    getpickListValues : function(component,event,helper) {
        console.log("inside piclistvalues");
		var action = component.get("c.getPickListData");
        action.setParams({"mainLicense": component.get("v.licenseType")});
         action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                component.set("v.options",result);
            } else {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + 
                                    errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
        });
         $A.enqueueAction(action);
	},
    
    licensePage : function(component,event,helper){
        sessionStorage.setItem("board", component.get("v.board"));
        sessionStorage.setItem("licenseType",component.get("v.branchLicense") );
        sessionStorage.setItem("applicationType", component.get("v.applicationMethod"));
        sessionStorage.setItem("flowType", "Application");
        sessionStorage.setItem("accountRecordID",component.get("v.accountId"));
        sessionStorage.setItem("LicenseRecordID",component.get("v.recordId"));
        return new Promise($A.getCallback(function(resolve, reject) {
				console.log('inside eligible::');
          		var applicationId =''; 
                var startAnApplication = component.get('c.createApplication');
                startAnApplication.setParams({"board": component.get("v.board"),
										"licenseType" : component.get("v.branchLicense"),
										"applicationType" : component.get("v.applicationMethod"),
                                        "account" : sessionStorage.getItem("accountRecordID"),
                                        "LicenseUpgradeRecordID" : sessionStorage.getItem("LicenseRecordID")
                 });
            		console.log('inside params::');
                    startAnApplication.setCallback(this, function(actionResult){
					    var state = actionResult.getState();
						 if (state === "SUCCESS"){
                            console.log('inside  startAn Application::');
							resolve(actionResult.getReturnValue());
                              
						}
        		});
             $A.enqueueAction(startAnApplication);
             })).then(
                $A.getCallback(function(result){   
                sessionStorage.setItem("header","true");
                sessionStorage.setItem("applicationId",result);  
                console.log("result::"+ result);
                console.log('121233' + sessionStorage.getItem("applicationId"));
                console.log('test::'+sessionStorage.getItem("header"));
                   if(sessionStorage.getItem("header")){
                        console.log('inside headertrue');
                        sessionStorage.setItem("header","true");
                        sessionStorage.setItem("applicationId",result); 
                       window.location.href=$A.get("$Label.c.Polaris_Portal_Home")+"apply-for-license";
                    } 
                else if(sessionStorage.getItem("header")){
                var urlEvent = $A.get("e.force:navigateToURL");
                console.log('%%%%%'+urlEvent);
                var str = "/lightningwashington/s/apply-for-license";
                console.log('$$$$$$'+str);
                urlEvent.setParams({
                    "url": str
                });

               console.log('****'+str);//console.log(str);
                    urlEvent.fire();}
      		}));
    },
    showMoreActions : function(component,event){
        component.set("v.showMore",!component.get("v.showMore"));
    },
    updateBusinessAMR : function(component,event){
        var licenseType = component.get("v.licenseType");
        var businessLicenseType =$A.get("$Label.c.Business_Licenses");        
        var businsessLicenseArray = businessLicenseType.split(',');
        var isbusinsessLicense = businsessLicenseArray.includes(licenseType);        
        component.set('v.isBusinessLicense',isbusinsessLicense);
        component.set("v.isAMRLoaded",true);
    }
})