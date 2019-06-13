({
    setJSON : function(component, event, helper) {        
        try{
            var jsonMap= [];
            var pageTitle = window.location.href;
            const server = component.find('server');
            const anAction = component.get('c.getDBJSON');
            console.log("inside getDBJSON");
            server.callServer(anAction,{}, "", 
                              $A.getCallback(response => { 
                                  jsonMap= response;
                                  var cardMenuJSON= jsonMap['Card Menu List'];
                                  var menuList = JSON.parse(cardMenuJSON);
                                  component.set("v.widgetArray", menuList);  
                                  var appHeaderJSON = jsonMap['Application Header List'];       
                                  var bottomHeaderList = JSON.parse(appHeaderJSON);
                                  component.set("v.bottomCardListHeader", bottomHeaderList);
                                  var newAppList = [];
                                  var newLicList = [];
                                  var appItems = jsonMap['Application Item List'];
                                  var licItems = jsonMap['License Item List'];
                                 
                                  var appList = JSON.parse(appItems);
                                  var licList = JSON.parse(licItems);
								  
                                  for (var key in appList){
                                  newAppList.push(appList[key]);
                              }
                                  for (var key in licList){
                                  newLicList.push(licList[key]);
                              }	  

                                  component.set("v.application", newAppList);
                                  component.set("v.licenses", newLicList);
                                  
                                  var newLicListToIterate = [];
                                  if(component.get("v.licenses").length != undefined && component.get("v.licenses").length >10){
                                  component.set("v.viewMoreLicensesBoolean", true);
                                  for(var i=0; i<10; i++ ){
                                  newLicListToIterate.push(newLicList[i]);
                              }
                              }else{
                                  newLicListToIterate = newLicList;
                              }
							  var busFlag = jsonMap['businessFlag'];
                              var busLicList = [];
							  if(busFlag == 'true'){
								  var newBusLicListToIterate =[];
								  var busItems = jsonMap['BusinessLicense'];
								  var busList = JSON.parse(busItems);
								  for(var key in busList){
								  busLicList.push(busList[key]);
									}
	
							  component.set("v.BusinessLicense",busLicList);  
							  if(component.get("v.BusinessLicense").length != undefined && component.get("v.BusinessLicense").length >10){
								  component.set("v.viewMoreBusinessLicensesBoolean", true);
								  for(var i=0; i<10; i++ ){
								  newBusLicListToIterate.push(busLicList[i]);
							  }
							  }else{
								  newBusLicListToIterate = busLicList;
							  }
							  component.set("v.BusinessLicenseToIterate",newBusLicListToIterate);
							  }
                                  component.set("v.licensesToIterate", newLicListToIterate);
								 
                                  var newAppListToIterate = [];
                                  if(component.get("v.application").length != undefined && component.get("v.application").length >10){
                                  component.set("v.viewMoreApplicationBoolean", true);
                                  for(var i=0; i<10; i++ ){
                                  newAppListToIterate.push(newAppList[i]);
                              }
                              }else{
                                  newAppListToIterate = newAppList;
                              }
                                  component.set("v.applicationToIterate", newAppListToIterate);
                              }),
                                  $A.getCallback(errors => {
                              }),false,"");
                              }
                                  catch(e){
                                  console.error('Error Stack Message for setJSON Helper' + e.stack);           
                              }		  
                              },
                                  viewMoreLicenses : function(component, event, helper){
                                      var allLicenses = component.get("v.licenses");
                                      var licensesLength = allLicenses.length;
                                      var licensesToIterateLength = component.get("v.licensesToIterate").length;
                                      var iterations = licensesLength >= licensesToIterateLength + 10? licensesToIterateLength + 10 : licensesLength; 
                                      var iterationsArray = [];
                                      component.set("v.viewMoreLicensesBoolean", licensesLength >= licensesToIterateLength + 10? true : false);
                                      if(licensesToIterateLength < licensesLength){
                                          for(var i=0; i<iterations; i++){
                                              iterationsArray.push(allLicenses[i]);
                                          }
                                          component.set("v.licensesToIterate", iterationsArray);
                                      }
                                  },
								  
								  viewMoreBusnesLicenses: function(component, event,helper){
									  var allBusLicenses = component.get("v.BusinessLicense");
                                      var licensesLength = allBusLicenses.length;
                                      var licensesToIterateLength = component.get("v.BusinessLicenseToIterate").length;
                                      var iterations = licensesLength >= licensesToIterateLength + 10? licensesToIterateLength + 10 : licensesLength; 
                                      var iterationsArray = [];
                                      component.set("v.viewMoreBusinessLicensesBoolean", licensesLength >= licensesToIterateLength + 10? true : false);
                                      if(licensesToIterateLength < licensesLength){
                                          for(var i=0; i<iterations; i++){
                                              iterationsArray.push(allBusLicenses[i]);
                                          }
                                          component.set("v.BusinessLicenseToIterate", iterationsArray);
                                      }

								
								  },
								  
                                  viewMoreApplications : function(component, event, helper){
                                      var allApplications = component.get("v.application");
                                      var applicationsLength = allApplications.length;
                                      var applicationsToIterateLength = component.get("v.applicationToIterate").length;
                                      var iterations = applicationsLength >= applicationsToIterateLength + 10? applicationsToIterateLength + 10 : applicationsLength; 
                                      var iterationsArray = [];
                                      component.set("v.viewMoreApplicationBoolean", applicationsLength >= applicationsToIterateLength + 10? true : false);
                                      if(applicationsToIterateLength < applicationsLength){
                                          for(var i=0; i<iterations; i++){
                                              iterationsArray.push(allApplications[i]);
                                          }
                                          component.set("v.applicationToIterate", iterationsArray);
                                      }
                                  },
								  
                                  openExistingAppHelper : function(component, event, helper) {
                                      var newAppList = component.get("v.application");
                                      var index = event.target.dataset.index;
                                      var appId = newAppList[index].Id;
                                      var appId2 = appId.substr(0,15);
                                      var renewal = newAppList[index].renewal;
                                      console.log(component.get("v.application")[index]);
                                      console.log('v.application@@@'+newAppList+newAppList.length);
                                      console.log('app Id @@@'+appId);
                                      console.log('type @@'+newAppList[index].type);
                                      console.log('board @@@'+newAppList[index].board);
                                      console.log('app type'+newAppList[index].applicationType);
                                      sessionStorage.setItem("applicationId", appId2);
                                      sessionStorage.setItem("licenseType", newAppList[index].type);
                                      sessionStorage.setItem("board", newAppList[index].board);
                                      sessionStorage.setItem("applicationType", newAppList[index].applicationType);
                                      sessionStorage.setItem("flowType", "Application");
                                      if(renewal == "true"){
                                          sessionStorage.setItem("renewalReinstate", "Renewal");
                                          window.location.href='/lightningwashington/s/polaris-renewal';  
                                      } else {
                                          window.location.href='/lightningwashington/s/apply-for-license';  
                                      }
                                  },
                                  /* renewApplicationHelper : function(component, event, helper) {  
		var action = component.get("c.createRenewalApplication");
		//helper.hideOrShowSpinner(component, event, helper);
		action.setParams({
		  "board": "Architects Board", 
		  "licenseType": "Licensed Architect", 
		  "appType": "Examination",
		  "licId":"a030b00000Zio4U"
		});
		action.setCallback(this, function(actionResult){
		  var state = actionResult.getState();
		  if (state === "SUCCESS"){
			  var result = actionResult.getReturnValue();
			  console.log('Dresult ' + result);
			  sessionStorage.setItem("applicationId", "a020b00000laUUD");
			  sessionStorage.setItem("licId", "a030b00000Zio4U");
			  sessionStorage.setItem("licenseType", "Licensed Architect");
			  sessionStorage.setItem("board", "Architects Board");
			  sessionStorage.setItem("applicationType", "Examination");
			  sessionStorage.setItem("flowType", "Renewal");
			  window.location.href='/lightningwashington/s/apply-for-license';                                                 
		  }
		  else{
			  //handle error as well
			  window.location.href = "./error";
		  }
	  });
	  $A.enqueueAction(action);   
	},*/
                                  renewLicenseHelper : function(component, event, helper) {	  
                                      var parcedValue = event.getSource().get("v.value").split(',');
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
                                  },
                                  manageEndorsementHelper	: function(component, event, helper) {	  
                                      var parcedValue = event.getParam("value").split(',');
                                      var manageEndorsement = parcedValue[0];
                                      var licID = parcedValue[1];
                                      var board = parcedValue[2];
                                      var licenseType = parcedValue[3];
                                      var applicationType = parcedValue[4];                                
                                      var licenseAppId = parcedValue[5];
                                      var appIsRenewal = parcedValue[6];
                                      //alert("licId :"+ licID+"  licenseType :"+ licenseType);
                                      sessionStorage.setItem("manageEndorsement", manageEndorsement);
                                      sessionStorage.setItem("licId", licID);
                                      sessionStorage.setItem("board", board);
                                      sessionStorage.setItem("licenseType", licenseType);
                                      sessionStorage.setItem("applicationMethod", applicationType);
                                      window.location.href='/lightningwashington/s/manage-endorsement';
                                  },
                                  
                                  manageLicenseHelper: function(component,event, helper) {
                                      var licID = event.getSource().get("v.value");
                                      sessionStorage.setItem("licId", licID);
                                      window.location.href='/lightningwashington/s/manage-license';
                                  },
                              })