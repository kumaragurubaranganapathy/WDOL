({
    setJSON : function(component, event, helper) {        
        try{
            var jsonMap= [];
            var pageTitle = window.location.href;
            const server = component.find('server');
            const anAction = component.get('c.getDBJSON');
            console.log("inside getDBJSON");
            server.callServer(anAction,{}, "", 
                              $A.getCallback(function(response) { 
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
                                  if(component.get("v.licenses").length != undefined && component.get("v.licenses").length >=10){
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
                                      if(component.get("v.BusinessLicense").length != undefined && component.get("v.BusinessLicense").length >=10){
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
                                  if(component.get("v.application").length != undefined && component.get("v.application").length >=10){
                                      component.set("v.viewMoreApplicationBoolean", true);
                                      for(var i=0; i<10; i++ ){
                                          newAppListToIterate.push(newAppList[i]);
                                      }
                                  }else{
                                      newAppListToIterate = newAppList;
                                  }
                                  component.set("v.applicationToIterate", newAppListToIterate);
                              }),
                              $A.getCallback(function(errors) {
                              }),false,"");
        }
        catch(e){
            console.error('Error Stack Message for setJSON Helper' + e.stack);           
        }		  
    },
    setDefaults : function(component, event, helper){
        
        component.set("v.DisplaylicenseNumberBreadCrumb","false");
        component.set("v.DisplayLicense_Details","false");
        
        component.set("v.DisplayUploadDocumentsBreadCrumb","false");  
        component.set("v.DisplayLicense_Upload_documents","false");
        
        component.set("v.DisplayDashboardHeader","true");
        component.set("v.DisplayDashboardTabs","true");
        
        component.set("v.DisplayAdditonalQulaificationsBreadCrumb","false");
        component.set("v.DisplayLicense_Additional_Qualification","false");
        
    },  
    viewMoreLicenses : function(component, event, helper){
        var allLicenses = component.get("v.licenses");
        var licensesLength = allLicenses.length;
        var licensesToIterateLength = component.get("v.BusinessLicenseToIterate").length;
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
        var licensesLength = allLicenses.length;
        var licensesToIterateLength = component.get("v.licensesToIterate").length;
        var iterations = licensesLength >= licensesToIterateLength + 10? licensesToIterateLength + 10 : licensesLength; 
        var iterationsArray = [];
        component.set("v.viewMoreBusinessLicensesBoolean", licensesLength >= licensesToIterateLength + 10? true : false);
        if(licensesToIterateLength < licensesLength){
            for(var i=0; i<iterations; i++){
                iterationsArray.push(allLicenses[i]);
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
    
    setContactId: function(component,event, helper) {
        var action = component.get("c.getContact");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var contact = response.getReturnValue();
                component.set("v.Contact_id",contact.id);
                component.set("v.loadingSpinner",false);
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.error("Error message: " + errors[0].message);
                    }
                } else {
                    console.error("Unknown error");
                }
            }
        });
        $A.enqueueAction(action);
    },
    
    uploadPendingdocumentsHelper : function(component,event, helper,licenseId,licenseNumber){
        
        component.set("v.LicenseNumberBreadCrumb",licenseNumber);
        
        component.set("v.dsiplaySpinner",false);
        
        component.set("v.pendingLicenseId",licenseId);
        
        console.log('IN uploadPendingdocumentsHelper .... '+licenseId+'...'+licenseNumber);
        
        var action = component.get("c.uploadAdditionalDocuments");
        
        action.setParams({"licenseId":licenseId});
        
        action.setCallback(this,function(response){
            
            var state = response.getState();
            
            if (state === "SUCCESS") { 
                
                var returnValue = response.getReturnValue();
                
                component.set("v.submission_id",returnValue);
                console.log(component.get("v.submission_id"));
                component.set("v.dsiplaySpinner",false);
                component.set("v.DisplayDashboardHeader","false");
                component.set("v.DisplayDashboardTabs","false");
                component.set("v.DisplaylicenseNumberBreadCrumb","true");
                component.set("v.DisplayLicense_Details","false");
                component.set("v.DisplayUploadDocumentsBreadCrumb","true");
                component.set("v.DisplayLicense_Upload_documents","true");
                component.set("v.DisplayAdditonalQulaificationsBreadCrumb","false");
                component.set("v.DisplayLicense_Additional_Qualification","false");
                
                //this.setPendingNewLicenseApplicationsTableData(component, event, helper);
                
            }else if (state === "ERROR") {
                var errors = response.getError();
                console.error(JSON.stringify(errors));
            }    
        });
        $A.enqueueAction(action);    
    },
    
    setLicenseToInReview : function(component,event, helper,licenseId){
        
        var action = component.get("c.setLicenseToInreview");
        
        action.setParams({"licenseId":licenseId});
        
        action.setCallback(this,function(response){
            
            var state = response.getState();
            
            if (state === "SUCCESS") {
                
                helper.showToast(component, event, helper,"The documents are succesfully uploaded and you application is being reviewd","success"); 
                
                helper.setDefaults(component, event, helper);
                this.setPendingNewLicenseApplicationsTableData(component, event, helper);
                
            }else if (state === "ERROR") {
                
                var errors = response.getError();
                
                console.error(JSON.stringify(errors));
            }    
        });
        $A.enqueueAction(action);    
    },
    
    updateAdditionalQualificationsHelper : function (component, event, helper,license_Id,sobjectname){
        
        console.log('IN updateAdditionalQualificationsHelper .... '+license_Id);
        
        component.set("v.DisplayDashboardHeader","false");
        component.set("v.DisplayDashboardTabs","false");
        component.set("v.DisplaylicenseNumberBreadCrumb","false");
        component.set("v.DisplayLicense_Details","false");
        component.set("v.DisplayUploadDocumentsBreadCrumb","false");
        component.set("v.DisplayLicense_Upload_documents","false");
        component.set("v.DisplayAdditonalQulaificationsBreadCrumb","true");
        component.set("v.DisplayLicense_Additional_Qualification","true");
        
        component.set("v.pendingLicenseId",license_Id);
        component.set("v.relatedSobjectName",sobjectname);
        
    },
    
    
    fetchLicenseDetails: function(component,event, helper,licenseId) {
        
        console.log("In fetchLicenseDetails....");
        
        var isPendingLicense = component.get("v.displayPendingLicense_Details");
        
        var action = component.get("c.fetchLicenseDetailsTable");
        
        action.setParams({"licenseId":licenseId});
        
        action.setCallback(this,function(response){
            
            var state = response.getState();
            
            if (state === "SUCCESS") {
                
                var licenseData = JSON.parse(response.getReturnValue());
                /* var licenseDataList = [];
                licenseData.forEach(function(element) {
                    if(element.MUSW__Issue_Date__c != null)
                    	element.MUSW__Issue_Date__c = $A.localizationService.formatDate(element.MUSW__Issue_Date__c, "MM-dd-yyyy");
                    if(element.Original_Issue_Date__c != null)
                    	element.Original_Issue_Date__c = $A.localizationService.formatDate(element.Original_Issue_Date__c, "MM-dd-yyyy");
                    if(element.MUSW__Expiration_Date__c != null)
                    	element.MUSW__Expiration_Date__c = $A.localizationService.formatDate(element.MUSW__Expiration_Date__c, "MM-dd-yyyy");
                    licenseDataList.push(element);
                });
                console.log('licenseDataList= ',licenseDataList);
                component.set("v.detailLicenseData",licenseDataList); */
                
                component.set("v.detailLicenseData",licenseData);  
                
                component.set("v.DisplayLicense_Details","true");
                
                component.set("v.DisplayDashboardHeader","false");
                
                component.set("v.DisplayDashboardTabs","false");
                
                component.set("v.DisplaylicenseNumberBreadCrumb","true");
                
                component.set("v.LicenseNumberBreadCrumb",licenseData[0]["Name"]);
                
                console.log(JSON.stringify(licenseData));
                
                var options = { weekday: 'long', year: 'numeric', month: 'long', day: '2-digit', hour:'2-digit', minute:'2-digit', second:'2-digit', timeZoneName : 'long'};
                
                var currentDate = new Date();
                
                component.set("v.Lincese_Details_LastDate",currentDate.toLocaleDateString('en-US',options));
                
                if(!isPendingLicense){
                    
                    this.fetchPeerRelationShipDataRecords(component, event, helper,licenseData);  
                    
                }else{
                    component.set("v.displayPendingLicense_Details","true");
                }
                
                
            }else if (state === "ERROR") {
                var errors = response.getError();
                console.error(JSON.stringify(errors));
            }    
        });
        $A.enqueueAction(action);
    },
    
    fetchBusinessRelationShipRecords: function(component,event, helper,licenseId){
        
        console.log("fetchBusinessRelationShipRecords :::::");
        
        var action = component.get("c.getBusinessRelationShipData");
        
        action.setParams({"license_id":licenseId});
        
        action.setCallback(this,function(response){
            
            var state = response.getState();
            
            if (state === "SUCCESS") {
                
                var BusinessLicenseTableData = JSON.parse(response.getReturnValue());
                
                var BusinessLicenseTableColumnData = BusinessLicenseTableData["tableHeader"];
                
                var BusinessLicenseTableHeaderData = BusinessLicenseTableData["tableData"];
                
                component.set("v.BusinessLicenseTableColumnsList",BusinessLicenseTableColumnData);
                
                component.set("v.BusinessLicenseTableDataList",BusinessLicenseTableHeaderData);
                
            }else if (state === "ERROR") {
                
                var errors = response.getError();
                
                console.error(JSON.stringify(errors));
            }     
        });
        $A.enqueueAction(action);
    },
    
    fetchEndorsementDetails: function(component,event, helper,licenseId) {
        
        console.log("In fetchEndorsementDetails...."+licenseId);                    
        
        var action = component.get("c.fetchEndorsementDetails");
        
        action.setParams({"licenseId":licenseId});
        
        action.setCallback(this,function(response){
            
            console.log("In fetchEndorsementDetails....in call back "+response.getState());   
            
            var state = response.getState();
            
            if (state === "SUCCESS") {
                
                var endorsementDatavar = response.getReturnValue() ;
                
                console.log("endorsementDatavar @@"+endorsementDatavar);
                
                component.set("v.endorsementData",endorsementDatavar);
                
            }else if (state === "ERROR") {
                
                var errors = response.getError();
                
                console.error(JSON.stringify(errors));
            }    
        });
        $A.enqueueAction(action);
    },
    
    fetchPeerRelationShipDataRecords : function(component, event, helper,licenseDat){
        
        console.log("In fetchPeerRelationShipDataRecords...."+licenseDat);       
        
        var action = component.get("c.setPeerRelationShipTable");
        
        action.setParams({"licenseType":licenseDat[0]["Credential_Type__c"],
                          "licenseId" :licenseDat[0]["Id"]});
        
        action.setCallback(this,function(response){
            
            var state = response.getState();
            
            if (state === "SUCCESS") {
                
                var resp = response.getReturnValue();
                
                console.log("In fetchPeerRelationShipDataRecords....return response"+resp);
                
                var PeerRelationshipTableData = JSON.parse(resp);
                
                var PeerRelationshipTableColumnData = PeerRelationshipTableData["tableHeader"];
                
                var PeerRelationshipTableHeaderData = PeerRelationshipTableData["tableData"];
                
                var isParent  = PeerRelationshipTableData["miscellaneousData"] == "true"?true:false;
                
                component.set("v.PeerRelationTableColumnsList",PeerRelationshipTableColumnData);
                
                component.set("v.PeerRelationTableDataList",PeerRelationshipTableHeaderData);
                
                component.set("v.IsCurrentLicenseParent",isParent);
                
                console.log("fetchPeerRelationShipDataRecords   :::::  "+JSON.stringify(resp));
                
            }else if (state === "ERROR") {
                
                var errors = response.getError();
                
                console.error("fetchPeerRelationShipDataRecords   :::::  "+JSON.stringify(errors));
            }    
        });
        $A.enqueueAction(action);    
    },
    
    setCurrentLicensesTableData :function(component,event, helper){
        
        console.log('In LnP_Dashboard_2.aura-helper::setCurrentLicensesTableData ');
        
        var action = component.get("c.setCurrentLicenseTable");
        
        action.setCallback(this, function(response) {
            
            var state = response.getState();
            
            console.log('LnP_Dashboard_2.aura-helper::setCurrentLicensesTableData setCurrentLicenseTableColumns callback');
            
            if (state === "SUCCESS") {
                
                var currentLicenseTableData = JSON.parse(response.getReturnValue());
                
                console.log(JSON.stringify(currentLicenseTableData));
                
                var currentLicenseTableColumnData = currentLicenseTableData["tableHeader"];
                
                var currentLicenseTableHeaderData = currentLicenseTableData["tableData"];
                
                component.set("v.CurrentLicenseTableColumnsList",currentLicenseTableColumnData);
                
                component.set("v.CurrentLicenseTableDataList",currentLicenseTableHeaderData);
                
            } else if (state === "ERROR") {
                var errors = response.getError();
                console.error(JSON.stringify(errors));
            }
        });
        $A.enqueueAction(action);
    },
    
    setRelationshipTableData : function(component,event, helper){
        
        console.log('In LnP_Dashboard_2.aura-helper::setRelationshipTableData ');
        
        var action = component.get("c.ProfessionalRelationshipTable");
        
        action.setCallback(this, function(response) {
            
            var state = response.getState(); 
            
            
            if (state === "SUCCESS") {
                
                var relationshipTableData = JSON.parse(response.getReturnValue());
                
                console.log(JSON.stringify(relationshipTableData));
                
                var relationshipTableColumnData = relationshipTableData["tableHeader"];
                
                var relationshipTableHeaderData = relationshipTableData["tableData"];
                
                component.set("v.ProfessionalRelationshipColumnList",relationshipTableColumnData);
                
                component.set("v.ProfessionalRelationshipDataList",relationshipTableHeaderData);
                
            } else if (state === "ERROR") {
                var errors = response.getError();
                console.error(JSON.stringify(errors));
            }
        });
        $A.enqueueAction(action);
    },
    
    removeAccountContactRelationHelper : function(component,event, helper,Account_ContactId){
        
        console.log('In LnP_Dashboard_2.aura-helper::removeAccountContactRelationHelper ');
        
        var action = component.get("c.seperateAccountContactRelationship");
        
        action.setParams({"AccountContactId":Account_ContactId});
        
        action.setCallback(this, function(response) {
            
            var state = response.getState();
            
            if (state === "SUCCESS") {
                
                var resp = JSON.parse(response.getReturnValue());
                
                var message = resp["message"];
                
                var type = resp["isSuccess"] ? "success": "error";
                
                this.showToast(component, event, helper,message,type);
                
                if(type === "success"){
                    
                    this.setRelationshipTableData(component, event, helper);
                }
                
            } else if (state === "ERROR") {
                
                var errors = response.getError();
                
                console.error(JSON.stringify(errors));
            }
        });
        $A.enqueueAction(action);
    },
    
    removeremoveAssociationRelationHelper : function(component,event, helper,associateId){
        
        console.log('In LnP_Dashboard_2.aura-helper::removeAccountContactRelationHelper ');
        
        var action = component.get("c.seperateAssociateRelationship");
        
        action.setParams({"associateId":associateId});
        
        action.setCallback(this, function(response) {
            
            var state = response.getState();
            
            if (state === "SUCCESS") {
                
                var resp = JSON.parse(response.getReturnValue());
                
                var message = resp["message"];
                
                var type = resp["isSuccess"] ? "success": "error";
                
                this.showToast(component, event, helper,message,type);
                
                if(type === "success"){
                    
                    var licenseDat = component.get("v.detailLicenseData");
                    
                    this.fetchBusinessRelationShipRecords(component, event, helper,licenseDat[0].id);
                    
                    this.fetchPeerRelationShipDataRecords(component, event, helper,licenseData);
                }
                
            } else if (state === "ERROR") {
                
                var errors = response.getError();
                
                console.error(JSON.stringify(errors));
            }
        });
        $A.enqueueAction(action);
    },  
    
    showToast : function(component, event, helper,message,type) {
        
        var toastEvent = $A.get("e.force:showToast");
        
        toastEvent.setParams({
            
            "message": message,
            
            "type" : type
        });
        toastEvent.fire();
    },
    setAssociationdefaultrecordTypeIdHelper : function(component,event, helper){
        
        var action = component.get("c.getRecordTypeId");
        action.setParams({"sObjectName":"Associations__c",
                          "recordTypeDeveloperName":"Designated_Person"
                         });
        action.setCallback(this, function(response) {
            
            var state = response.getState();
            
            if (state === "SUCCESS") {
                
                var returnresponse = response.getReturnValue();
                if(returnresponse !=null){
                    component.set("v.setAssociationRecordTypeId",returnresponse);
                }
            } else if (state === "ERROR") {
                
                var errors = response.getError();
                
                console.error(JSON.stringify(errors));
            }
        });
        $A.enqueueAction(action);  
    },
    
    setDraftNewLicenseApplicationsTableData :function(component,event, helper){
        
        console.log('In LnP_Dashboard_2.aura-helper::setDraftNewLicenseApplicationsTableData ');
        
        var action = component.get("c.DraftNewLicenseApplicationsTable");
        
        action.setCallback(this, function(response) {
            
            var state = response.getState();
            
            if (state === "SUCCESS") {
                
                var DraftNewLicenseTableData = JSON.parse(response.getReturnValue());
                
                //console.log(JSON.stringify(currentLicenseTableData));
                
                var draftNewLicenseTableDataTableColumnData = DraftNewLicenseTableData["tableHeader"];
                
                var draftNewLicenseTableDataTableHeaderData = DraftNewLicenseTableData["tableData"];
                
                console.log(JSON.stringify(draftNewLicenseTableDataTableColumnData));
                
                component.set("v.DraftNewLicenseApplicationsColumnList",draftNewLicenseTableDataTableColumnData);
                
                component.set("v.DraftNewLicenseApplicationsDataList",draftNewLicenseTableDataTableHeaderData);
                
            } else if (state === "ERROR") {
                
                var errors = response.getError();
                
                console.error(JSON.stringify(errors));
            }
        });
        $A.enqueueAction(action);    
    },
    setDraftRenewalApplicationsTableData :function(component,event, helper){
        
        console.log('In LnP_Dashboard_2.aura-helper::setDraftRenewalApplicationsTableData ');
        
        var action = component.get("c.setDraftRenewApplicationsTable");
        
        action.setCallback(this, function(response) {
            
            var state = response.getState();
            
            if (state === "SUCCESS") {
                
                var draftRenewApplicationsTable = JSON.parse(response.getReturnValue());
                
                var draftRenewApplicationsTableColumnData = draftRenewApplicationsTable["tableHeader"];
                
                var draftRenewApplicationsTableHeaderData = draftRenewApplicationsTable["tableData"];
                
                console.log('In LnP_Dashboard_2.aura-helper::setDraftRenewalApplicationsTableData '+JSON.stringify(draftRenewApplicationsTable));
                
                component.set("v.DraftRenewApplicationsColumnList",draftRenewApplicationsTableColumnData);
                
                component.set("v.DraftRenewApplicationsDataList",draftRenewApplicationsTableHeaderData);
                
            } else if (state === "ERROR") {
                
                var errors = response.getError();
                
                console.error(JSON.stringify(errors));
            }
        });
        $A.enqueueAction(action);    
    },
    setDraftMaintanceRequestTableData :function(component,event, helper){
        
        console.log('In LnP_Dashboard_2.aura-helper::setDraftMaintanceRequestTableData ');
        
        var action = component.get("c.setDraftMaintananceRequestApplicationsData");
        
        action.setCallback(this, function(response) {
            
            var state = response.getState();
            
            if (state === "SUCCESS") {
                
                var draftMaintanceRequestTable = JSON.parse(response.getReturnValue());
                
                var draftMaintanceRequestColumnData = draftMaintanceRequestTable["tableHeader"];
                
                var draftMaintanceRequestTableData = draftMaintanceRequestTable["tableData"];
                
                console.log('In LnP_Dashboard_2.aura-helper::setDraftMaintanceRequestTableData '+JSON.stringify(draftMaintanceRequestTable));
                
                component.set("v.DraftMaintananceRequestApplicationsColumnList",draftMaintanceRequestColumnData);
                
                component.set("v.DraftMaintananceRequestApplicationsDataList",draftMaintanceRequestTableData);
                
            } else if (state === "ERROR") {
                
                var errors = response.getError();
                
                console.error(JSON.stringify(errors));
            }
        });
        $A.enqueueAction(action);    
    },
    
    setPendingNewLicenseApplicationsTableData :function(component,event, helper){
        
        console.log('In LnP_Dashboard_2.aura-helper::setPendingNewLicenseApplicationsTableData ');
        
        var action = component.get("c.PendingNewLicenseApplicationsTable");
        
        action.setCallback(this, function(response) {
            
            var state = response.getState();
            
            if (state === "SUCCESS") {
                
                var pendingNewLicenseTableData = JSON.parse(response.getReturnValue());
                
                //console.log(JSON.stringify(currentLicenseTableData));
                
                var pendingNewLicenseTableDataTableColumnData = pendingNewLicenseTableData["tableHeader"];
                
                var pendingNewLicenseTableDataTableHeaderData = pendingNewLicenseTableData["tableData"];
                
                console.log('setPendingNewLicenseApplicationsTableData '+JSON.stringify(pendingNewLicenseTableDataTableColumnData));
                
                component.set("v.PendingNewLicenseApplicationsColumnList",pendingNewLicenseTableDataTableColumnData);
                
                component.set("v.PendingNewLicenseApplicationsDataList",pendingNewLicenseTableDataTableHeaderData);
                
            } else if (state === "ERROR") {
                
                var errors = response.getError();
                
                console.error(JSON.stringify(errors));
            }
        });
        $A.enqueueAction(action);    
    },
    setPendingRenewalApplicationsTableData :function(component,event, helper){
        
        console.log('In LnP_Dashboard_2.aura-helper::setPendingRenewalApplicationsTableData ');
        
        var action = component.get("c.PendingRenewApplicationsTable");
        
        action.setCallback(this, function(response) {
            
            var state = response.getState();
            
            if (state === "SUCCESS") {
                
                var pendingRenewApplicationsTable = JSON.parse(response.getReturnValue());
                
                var pendingRenewApplicationsTableColumnData = pendingRenewApplicationsTable["tableHeader"];
                
                var pendingRenewApplicationsTableHeaderData = pendingRenewApplicationsTable["tableData"];
                
                console.log('In LnP_Dashboard_2.aura-helper::setPendingRenewalApplicationsTableData '+JSON.stringify(pendingRenewApplicationsTable));
                
                component.set("v.PendingRenewApplicationsColumnList",pendingRenewApplicationsTableColumnData);
                
                component.set("v.PendingRenewApplicationsDataList",pendingRenewApplicationsTableHeaderData);
                
            } else if (state === "ERROR") {
                
                var errors = response.getError();
                
                console.error(JSON.stringify(errors));
            }
        });
        $A.enqueueAction(action);    
    },
    setPendingMaintanceRequestTableData :function(component,event, helper){
        
        console.log('In LnP_Dashboard_2.aura-helper::setPendingMaintanceRequestTableData ');
        
        var action = component.get("c.PendingMaintananceRequestApplicationsTable");
        
        action.setCallback(this, function(response) {
            
            var state = response.getState();
            
            if (state === "SUCCESS") {
                
                var pendingMaintanceRequestTable = JSON.parse(response.getReturnValue());
                
                var pendingMaintanceRequestColumnData = pendingMaintanceRequestTable["tableHeader"];
                
                var pendingMaintanceRequestTableData = pendingMaintanceRequestTable["tableData"];
                
                console.log('In LnP_Dashboard_2.aura-helper::setPendingMaintanceRequestTableData '+JSON.stringify(pendingMaintanceRequestTable));
                
                component.set("v.PendingMaintananceRequestApplicationsColumnList",pendingMaintanceRequestColumnData);
                
                component.set("v.PendingMaintananceRequestApplicationsDataList",pendingMaintanceRequestTableData);
                
            } else if (state === "ERROR") {
                
                var errors = response.getError();
                
                console.error(JSON.stringify(errors));
            }
        });
        $A.enqueueAction(action);    
    },
    
    setCompletedMaintanceRequestTableData :function(component,event, helper){
        
        console.log('In LnP_Dashboard_2.aura-helper::setCompletedMaintanceRequestTableData ');
        
        var action = component.get("c.CompletedMaintananceRequestApplicationsTable");
        
        action.setCallback(this, function(response) {
            
            var state = response.getState();
            
            if (state === "SUCCESS") {
                
                var pendingMaintanceRequestTable = JSON.parse(response.getReturnValue());
                
                var completedMaintananceRequestApplicationsColumnData = pendingMaintanceRequestTable["tableHeader"];
                
                var completedMaintananceRequestApplicationsTableData = pendingMaintanceRequestTable["tableData"];
                
                console.log('In LnP_Dashboard_2.aura-helper::setPendingMaintanceRequestTableData '+JSON.stringify(pendingMaintanceRequestTable));
                
                component.set("v.CompletedMaintananceRequestApplicationsColumnList",completedMaintananceRequestApplicationsColumnData);
                
                component.set("v.CompletedMaintananceRequestApplicationsDataList",completedMaintananceRequestApplicationsTableData);
                
            } else if (state === "ERROR") {
                
                var errors = response.getError();
                
                console.error(JSON.stringify(errors));
            }
        });
        $A.enqueueAction(action);    
    },
    
    setIsAuthenticatedUser : function(component,event, helper){
        
        var action = component.get("c.isValidCommunityUser");
        
        action.setCallback(this, function(response) {
            
            var state = response.getState();
            
            if (state === "SUCCESS") {
                
                var returnValue = response.getReturnValue();
                
                component.set("v.isAuthenticatedUser",returnValue);
                
            } else if (state === "ERROR") {
                
                var errors = response.getError();
                
                console.error(JSON.stringify(errors));
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