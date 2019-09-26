({	
    doInit : function(component, event, objectApi, fieldsName, auraAttr) {
        var localDate = new Date();
        //var monthShortNames = ["Jan", "Feb", "Mar", "Apr", "May", "Jun","Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];
		//var dayShortNames = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"];
        //var month = localDate.getMonth();
        //var date = localDate.getDate();
        //var year = localDate.getFullYear();
        //var day = localDate.getDay();
        //localDate = dayShortNames[day]+' '+monthShortNames[month]+' '+date+' '+year+' '+localDate.getHours()+':'+localDate.getMinutes()+':'+localDate.getSeconds();
        component.set("v.date", localDate);
        var action = component.get("c.getPicklistFieldValues");
        action.setParams({
            'objectName':objectApi,
            'pickListFieldName':fieldsName
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS"){
                var result = response.getReturnValue(); 
                if(auraAttr == 'v.professionOptions'){
                    var filteredResults = result.filter(function(item){
                        return (item != 'Delegated Municipality' && item != 'Manufactured Homes' && item != 'Misc Payments' && item != 'Regulatory Compliance' && item != 'Update/Close Company' && item != 'Update Legal Name' && item != 'Update Company Information' && item != 'Remove Owner' && item != 'Update Business Name'  && item != 'Program Unknown');
                    });
                    component.set(auraAttr, filteredResults);
                }else{
                    component.set(auraAttr, result);
                }
                component.set("v.loaded", true);
            }else{
                component.set("v.loaded", true);
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!",
                    "message": "There is some error in loading the page. Please reload the page.",
                    "type": "error"
                });
                toastEvent.fire();
            }
        });
        $A.enqueueAction(action);  
    },
    fetchLicenseTypes : function(component, event, auraAttr, licenseType) {
        var action = component.get("c.generateQuery");
        var criteria = {
            'IndividualBusinessType__c':licenseType,
        }
        action.setParams({
            'objectName':'License_Type__mdt',
            'lstFieldsName':['Credential_Type__c','IndividualBusinessType__c'],
            'mapValues':criteria,
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS"){
                var result = response.getReturnValue();               
                var filteredResults = [];
                if(result!==null){
                for(var i=0; i<result.length; i += 1){
                    if(result[i].Credential_Type__c != undefined && result[i].Credential_Type__c != "Appraiser Course" && result[i].Credential_Type__c != "Architect Firms" && result[i].Credential_Type__c != 'Appraisal Controlling Person' && filteredResults.indexOf(result[i].Credential_Type__c)==-1){
                        filteredResults.push(result[i].Credential_Type__c);
                    }
                }
                if(filteredResults !== null && filteredResults != ""){
                    filteredResults = filteredResults.sort();
                } 
                component.set(auraAttr, filteredResults);
                }
                else{
                     this.errorlog(component,event);
                }
            }else{
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!",
                    "message": "There is some error in loading the page. Please reload the page.",
                    "type": "error"
                });
                toastEvent.fire();
            }
        });
        $A.enqueueAction(action);  
    },
    errorlog:function(component,event){
        var url=$A.get("$Label.c.Polaris_Portal_Home")+'explorer-error-page';
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url": url
        });
        urlEvent.fire();
    },
    navigateToCustomPlace1 : function(component){
        component.set("v.screenOne", true);
        component.set("v.screenTwo", false);
        component.set("v.screenThree", false);
        component.set("v.data", "");
        component.set("v.dispList", "");
        component.set("v.applicationFilt","");
        component.set("v.detailData", "");
        component.set("v.endorsementData", "");
        component.set("v.licenseRelationData", "");
        component.set("v.selectedTabId", "tab1");
        component.set("v.licenseNameToDisplay", "License");        
        component.set("v.searchOne", false);
        component.set("v.searchOneArray", []);
        component.set("v.searchTwo", false);
        component.set("v.searchTwoArray", []);
    },
    navigateToCustomPlace2 : function(component, event){
        if(component.get("v.screenTwo")){
            event.preventDefault();
        } else {
            component.set("v.screenTwo", true);
            component.set("v.screenOne", false);
            component.set("v.screenThree", false);
            component.set("v.detailData", "");
            component.set("v.endorsementData", "");
            component.set("v.licenseRelationData", "");            
        }
    },
    searchWithNum : function(component) {
        component.set("v.loaded", false);
        var objectApi =  'MUSW__License_Parcel__c';
        var fieldsList = ['MUSW__License2__r.License_Printable_Name__c','MUSW__License2__r.Name','MUSW__License2__r.Credential_Type__c',
'MUSW__License2__r.MUSW__Status__c','MUSW__License2__r.Sub_Status__c','MUSW__Parcel__r.MUSW__City__c','MUSW__License2__r.Related_License__c',
'MUSW__License2__r.RecordType.Name'];
        var professionValue =  component.find("Profession").get("v.value");
        var licenseNumberValue = component.find("licenseNumber").get("v.value");
        var searchOneArray=[];
        var toastEvent = $A.get("e.force:showToast");
        //var initialRows = component.get("v.initialRows");
        if(professionValue != ""){
            searchOneArray.push({label:"Profession", value:professionValue});
        }
        if(licenseNumberValue!= "" && licenseNumberValue.trim()!= "" && licenseNumberValue.trim().length!= ""){
            searchOneArray.push({label:"License Number", value:licenseNumberValue});
        }
        if(searchOneArray.length!=0){
            var criteria = {
                "MUSW__License2__r.Application_Type__c":professionValue,
                "MUSW__License2__r.Name":licenseNumberValue,
            }
            var criteriaOR = {
                "1":'MUSW__License2__r.RecordType.Name=Individual',
                "2":'MUSW__License2__r.RecordType.Name=Business',
            }
            var action = component.get("c.generateQueryWithGenericOR");
            action.setParams({
                'objectName':objectApi,
                'lstFieldsName':fieldsList,
                'mapValues':criteria,
                'mapORValues':criteriaOR,
                'bIsStatusIncluded':false,
                'showDeciplinary':true
            });
            action.setCallback(this, function(response){
                var state = response.getState();
                if (state === "SUCCESS"){
                    var rows = response.getReturnValue();     
                    if(rows.length!=0){
                        for (var i = 0; i < rows.length; i += 1) { 
                            var row = rows[i]; 
                            if (row.MUSW__License2__c) {
                                if(row.MUSW__License2__r){
                                    if(row.MUSW__License2__r.License_Printable_Name__c){
                                    	row.Name = row.MUSW__License2__r.License_Printable_Name__c;
                                    } else {
                                        row.Name = "None";
                                    }
                                    if(row.MUSW__License2__r.Name){
                                    	row.License_Number = row.MUSW__License2__r.Name;
                                    } else {
                                        row.License_Number = "None";
                                    }
                                    if(row.MUSW__License2__r.AIDS_Affidavit__c){
                                        row.Discipline = row.MUSW__License2__r.AIDS_Affidavit__c;
                                    } else {
                                        row.Discipline = false;
                                    }
                                    if(row.MUSW__License2__r.Credential_Type__c){
                                        row.License_Type = row.MUSW__License2__r.Credential_Type__c;
                                    } else {
                                        row.License_Type = "None";
                                    }
                                    if(row.MUSW__License2__r.MUSW__Status__c){
                                        row.Status = row.MUSW__License2__r.MUSW__Status__c;
                                    } else {
                                        row.Status = "None";
                                    }
                                    if(row.MUSW__License2__r.Sub_Status__c){
                                        if(row.MUSW__License2__r.Sub_Status__c == 'Child Support Suspension' || row.MUSW__License2__r.Sub_Status__c == 'Surrendered'){
                                            row.Sub_Status = 'None';
                                        }else{
                                            row.Sub_Status = row.MUSW__License2__r.Sub_Status__c;
                                        }
                                    } else {
                                        row.Sub_Status = "None";
                                    }
                                    if(row.MUSW__License2__r.RecordType){
                                        row.Type = row.MUSW__License2__r.RecordType.Name;
                                    } else {
                                        row.Type = "None";
                                    }
                                    if(row.MUSW__License2__r.Id){
                                        row.Id = row.MUSW__License2__r.Id;
                                    } else {
                                        row.Id = "None";
                                    }
                                } else {
                                    row.Name = "None";
                                    row.License_Number = "None";
                                    row.Discipline = "None";
                                    row.License_Type = "None";
                                    row.Status = "None";
                                    row.Sub_Status = "None";
                                    row.Type = "None";
                                    row.Id = "None";
                                }
                                if(row.MUSW__Parcel__r.MUSW__City__c){
                                    row.City = row.MUSW__Parcel__r.MUSW__City__c;
                                } else {
                                    row.City = "None";
                                }
                          	}
                        } 
                        component.set('v.columns', [
                            //{label: 'Type', fieldName: 'Type', type: 'Name', sortable : true},
                            {label: 'Name', fieldName: 'Name', type: 'button', sortable : true, typeAttributes: 
                             { label: {fieldName: 'Name'}, name: 'view_details', title: {fieldName: 'Name'}}},
                            {label: 'License', fieldName: 'License_Number', type: 'Number', sortable : true},
                            {label: 'License Type', fieldName: 'License_Type', type: 'Picklist', sortable : true, title:{fieldName: 'License_Type'}},
                            {label: 'Status', fieldName: 'Status', type: 'Picklist', sortable : true},
                            {label: 'Sub Status', fieldName: 'Sub_Status', type: 'Picklist', sortable : true},
                            {label: 'Disciplinary Action', fieldName: 'Discipline', type: 'boolean', sortable : true},
                            {label: 'City', fieldName: 'City', type: 'Text', sortable : true},
                            //{label: 'View Details', type: 'button', initialWidth: 160, typeAttributes: 
                             //{ label: 'More Details', name: 'view_details', title: 'Click to View Details'}},
                        ]);
                        component.set("v.data", rows);
                        component.set("v.applicationFilt",rows);
                        component.set("v.screenTwo", true);
                        component.set("v.screenOne", false);
                        component.set("v.searchOne",true);
            			component.set("v.searchOneArray",searchOneArray);
                    } else {
                        toastEvent.setParams({
                            "title": "Error!",
                            "message": "No results found.",
                            "type": "error"
                        });
                        toastEvent.fire();
                    }
                    component.set("v.loaded", true);
                }else{
                    component.set("v.loaded", true);
                    var errors = response.getError();
                    if (errors) {
                        var message = "";
                        if (errors[0] && errors[0].message) {
                           message = "Error message: " + errors[0].message;
                        }
                    }
                    else {
                        message = "Unknown error";
                    }
                    toastEvent.setParams({
                        "title": "Error!",
                        "message": message,
                        "type": "error"
                    });
                    toastEvent.fire(); 
                }
            });
            $A.enqueueAction(action);
        } else {
            component.set("v.loaded", true);
            toastEvent.setParams({
                "title": "Error!",
                "message": "Please fill atleast one field.",
                "type": "error"
            });
            toastEvent.fire();       
		}            
    },
	cancelSearchWithNum : function(component) {
		component.find("Profession").set("v.value", "");
        component.find("licenseNumber").set("v.value", "");
	},
    fetchLicenseDetails : function(component, licenseId, licenseType) {        
        component.set("v.loaded", false);
        //var selectedTab;
        var objectApi;
        var fieldsList;
        var criteria;
        var action;
        if(licenseId != "" && licenseId != undefined){
            component.set("v.licenseId", licenseId);
            //selectedTab = component.get("v.selectedTabId");
            if(licenseType == "Business"){
                objectApi =  'MUSW__License_Parcel__c';
                component.set("v.licenseNameToDisplayDetails", "Business License Details");
                fieldsList = ['MUSW__License2__r.Name',
                                  'MUSW__License2__r.Credential_Type__c',
                                  'MUSW__License2__r.MUSW__Status__c',
                                  'MUSW__License2__r.License_Printable_Name__c',
                                  'MUSW__License2__r.MUSW__Primary_Licensee__r.Doing_Business_As_1__c',
                                  'MUSW__License2__r.Phone__c',
                                  'MUSW__License2__r.AIDS_Affidavit__c',
                                  'MUSW__License2__r.Project_Address__c',
                                  'MUSW__License2__r.Original_Issue_Date__c',
                                  'MUSW__License2__r.Sub_Status__c',
                                  'MUSW__Parcel__r.Name',
                                  'MUSW__Parcel__r.MUSW__State__c',
                                  'MUSW__Parcel__r.Zip_Postal_Code__c',
                                  'MUSW__Parcel__r.Country__c',
                                  'MUSW__License2__r.MUSW__Issue_Date__c',
                                  'MUSW__License2__r.Application_Type__c',
                                  'MUSW__License2__r.MUSW__Expiration_Date__c'];
                criteria = {
                    "MUSW__License2__r.Name":licenseId
                }
                action = component.get("c.generateQueryWithOR");
            } else {
                objectApi =  'MUSW__License_Parcel__c';
                component.set("v.licenseNameToDisplayDetails", "Professional License Details");
                fieldsList = ['MUSW__License2__r.Name',
                                  'MUSW__License2__r.Credential_Type__c',
                                  'MUSW__License2__r.MUSW__Status__c',
                                  'MUSW__License2__r.License_Printable_Name__c',
                                  'MUSW__License2__r.Original_Issue_Date__c',
                                  'MUSW__License2__r.AIDS_Affidavit__c',
                                  'MUSW__License2__r.Project_Address__c',
                                  'MUSW__License2__r.Sub_Status__c',
                                  'MUSW__Parcel__r.MUSW__City__c',
                                  'MUSW__License2__r.MUSW__Issue_Date__c',
                                  'MUSW__Parcel__r.MUSW__State__c',
                                  'MUSW__License2__r.MUSW__Expiration_Date__c',
                                  'MUSW__License2__r.Application_Type__c',
                                  'MUSW__Parcel__r.Country__c'];
                criteria = {
                    "MUSW__License2__r.Name":licenseId
                }
                action = component.get("c.generateQueryWithOR");
            }            
            action.setParams({
                'objectName':objectApi,
                'lstFieldsName':fieldsList,
                'mapValues':criteria,
                'bIsStatusIncluded':false,
                'showDeciplinary': true
            });
     		action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS"){
                var result = response.getReturnValue();
                for(var i=0; i<result.length; i += 1){
                    if(result[i].MUSW__License2__r.MUSW__Expiration_Date__c){
                        if($A.get("$SObjectType.CurrentUser.Id")){
                            component.set("v.loggedIn", true);
                        }else{
                            component.set("v.loggedIn", false);
                            var date = new Date(result[i].MUSW__License2__r.MUSW__Expiration_Date__c);
                            result[i].MUSW__License2__r.MUSW__Expiration_Date__c = new Date(date.getFullYear()+'-'+(parseInt(date.getMonth())+1));
                        }
                    }
                }
                component.set("v.detailData", result);
                component.set("v.screenOne", false);
                component.set("v.screenTwo", false);
                component.set("v.screenThree", true);
              //  this.fetchEndorsementDetails(component, event, licenseId);
                component.set("v.loaded", true);
            }else{
                component.set("v.loaded", true);
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!",
                    "message": "No results found.",
                    "type": "error"
                });
                toastEvent.fire();
            }
        });
        $A.enqueueAction(action);
    	}	              
    },
    fetchEndorsementDetails: function(component, licenseRecordId){
        if(licenseRecordId != "" && licenseRecordId != undefined){
            var objectApi =  'Endorsement__c';
            var fieldsList = ['Endorsement_Type__c'];
            var criteria = {
                "License__c":licenseRecordId
            }
            var action = component.get("c.generateQuery");
            action.setParams({
                'objectName':objectApi,
                'lstFieldsName':fieldsList,
                'mapValues':criteria,
            });
     		action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS"){
                var result = response.getReturnValue();     
                component.set("v.endorsementData", result);
                
            }else{
                 alert("error!!!!!");
            }
        });
        $A.enqueueAction(action);
    	}	            
    },
    fetchParentLicenses : function(component, licenseRecordId){
        if(licenseRecordId != "" && licenseRecordId != undefined){
            var objectApi =  'MUSW__License_Parcel__c';
            var fieldsList = ['MUSW__License2__r.Related_License__r.MUSW__Applicant__r.Full_Name__c',
                              'MUSW__License2__r.Related_License__r.Name',
                              'MUSW__License2__r.Related_License__r.Credential_Type__c',
                              'MUSW__License2__r.Related_License__r.MUSW__Status__c',
                              'MUSW__License2__r.Related_License__r.Sub_Status__c',
                              'MUSW__Parcel__r.MUSW__City__c' ];
            var criteria = {
                "MUSW__License2__c":licenseRecordId
            }
            var action = component.get("c.generateQueryWithORparent");
            action.setParams({
                'objectName':objectApi,
                'lstFieldsName':fieldsList,
                'mapValues':criteria,
                'bIsStatusIncluded':false,
            });
     		action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS"){
                var result = response.getReturnValue(); 
                component.set("v.licenseRelationData", result);
                component.set("v.parent", true);
            }else{
                 alert("error!!!!!");
            }
        });
        $A.enqueueAction(action);
    	}	            
    },
    fetchChildLicenses : function(component, licenseRecordId){
        if(licenseRecordId != "" && licenseRecordId != undefined){
            var objectApi =  'MUSW__License_Parcel__c';
            var fieldsList = ['MUSW__License2__r.MUSW__Applicant__r.Name','MUSW__License2__r.Name','MUSW__License2__r.Credential_Type__c','MUSW__License2__r.MUSW__Status__c','MUSW__License2__r.Sub_Status__c','MUSW__Parcel__r.MUSW__City__c'];
            var criteria = {
                "MUSW__License2__r.Related_License__c":licenseRecordId
            }
            var action = component.get("c.generateQueryWithOR");
            action.setParams({
                'objectName':objectApi,
                'lstFieldsName':fieldsList,
                'mapValues':criteria,
                'bIsStatusIncluded':false,
                'showDeciplinary' :false,
            });
     		action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS"){
                var result = response.getReturnValue();     
                component.set("v.licenseRelationData", result);
                component.set("v.parent", false);
            }else{
                 alert("error!!!!!");
            }
        });
        $A.enqueueAction(action);
    	}	            
    },
    searchWithDetails : function(component) {
        component.set("v.loaded", false);
        var selectedTab = component.get("v.selectedTabId");
        var objectApi =  'MUSW__License_Parcel__c';
        var searchTwoArray=[];
        var toastEvent = $A.get("e.force:showToast");
        if(selectedTab == "tab1"){
 			component.set("v.licenseNameToDisplay", "Professional License");
			var fieldsList = ['MUSW__License2__r.License_Printable_Name__c','MUSW__License2__r.Name','MUSW__License2__r.Credential_Type__c','MUSW__License2__r.MUSW__Status__c','MUSW__License2__r.Sub_Status__c','MUSW__Parcel__r.MUSW__City__c','MUSW__License2__r.RecordType.Name'];            
            var firstName = component.find("firstName").get("v.value");
            var middleName = component.find("middleName").get("v.value");
            var lastName = component.find("lastName").get("v.value");
            var licenseStatus = component.find("licenseStatus").get("v.value");
            var city = component.find("city").get("v.value");
            var country = component.find("country").get("v.value");
            var licenseType = component.find("licenseType").get("v.value");
			var endorsementType = "";
			var licenseStatusBoolean = false;            
            if(firstName!= "" && firstName.trim()!= "" && firstName.trim().length!= ""){
                searchTwoArray.push({label:"First Name", value:firstName});
            }
            if(middleName!= "" && middleName.trim()!= "" && middleName.trim().length!= ""){
                searchTwoArray.push({label:"Middle Name", value:middleName});
            }
            if(lastName!= "" && lastName.trim()!= "" && lastName.trim().length!= ""){
                searchTwoArray.push({label:"Last Name", value:lastName});
            }
            if(licenseStatus!= ""){
                searchTwoArray.push({label:"License Status", value:licenseStatus});
                licenseStatusBoolean = true;
            }
            if(city!= "" && city.trim()!= "" && city.trim().length!= ""){
                searchTwoArray.push({label:"City", value:city});
            }
            if(country!= ""){
                searchTwoArray.push({label:"County", value:country});
            }
            if(licenseType!= ""){
                searchTwoArray.push({label:"License Type", value:licenseType});
            }
            if(endorsementType!= ""){
                searchTwoArray.push({label:"Endorsement Type", value:endorsementType});
            }
            if(searchTwoArray.length!=0){
                var criteria = {
                    "MUSW__License2__r.Print_First_Name__c":firstName,
                    "MUSW__License2__r.Print_Middle_Name__c":middleName,
                    "MUSW__License2__r.Print_Last_Name__c":lastName,
                    "MUSW__License2__r.MUSW__Status__c":licenseStatus,
                    "MUSW__Parcel__r.MUSW__City__c":city,
                    "MUSW__Parcel__r.County__c":country,
                    "MUSW__License2__r.Credential_Type__c":licenseType,
                    "MUSW__License2__r.RecordType.Name":"Individual"
                }
                var action = component.get("c.generateQueryWithOR");
                action.setParams({
                    'objectName':objectApi,
                    'lstFieldsName':fieldsList,
                    'mapValues':criteria,
                    'bIsStatusIncluded':licenseStatusBoolean,
                    'showDeciplinary':true
                });
                action.setCallback(this, function(response){
                    var state = response.getState();
                    if (state === "SUCCESS"){
                        var rows = response.getReturnValue();
                        if(rows.length!=0){
                            for (var i = 0; i < rows.length; i += 1) { 
                                var row = rows[i]; 
                                if (row.MUSW__License2__r) {
                                    if(row.MUSW__License2__r){
                                        if(row.MUSW__License2__r.License_Printable_Name__c){
                                            row.Name = row.MUSW__License2__r.License_Printable_Name__c;
                                        } else {
                                            row.Name = "None";
                                        }
                                    } else {
                                        row.Name = "None";
                                    }
                                    if(row.MUSW__License2__r.Name){
                                        row.License_Number = row.MUSW__License2__r.Name;
                                    } else {
                                        row.License_Number = "None";
                                    }
                                    if(row.MUSW__License2__r.Credential_Type__c){
                                        row.License_Type = row.MUSW__License2__r.Credential_Type__c;
                                    } else {
                                        row.License_Type = "None";
                                    }
                                    if(row.MUSW__License2__r.AIDS_Affidavit__c){
                                        row.Discipline = row.MUSW__License2__r.AIDS_Affidavit__c;
                                    } else {
                                        row.Discipline = false;
                                    }
                                    if(row.MUSW__License2__r.MUSW__Status__c){
                                        row.Status = row.MUSW__License2__r.MUSW__Status__c;
                                    } else {
                                        row.Status = "None";
                                    }
                                    if(row.MUSW__License2__r.Sub_Status__c){
                                        if(row.MUSW__License2__r.Sub_Status__c == 'Child Support Suspension' || row.MUSW__License2__r.Sub_Status__c == 'Surrendered'){
                                            row.Sub_Status = 'None';
                                        }else{
                                            row.Sub_Status = row.MUSW__License2__r.Sub_Status__c;
                                        }
                                    } else {
                                        row.Sub_Status = "None";
                                    }
                                    if(row.MUSW__License2__r.RecordType){
                                        row.Type = row.MUSW__License2__r.RecordType.Name;
                                    } else {
                                        row.Type = "None";
                                    }
                                    if(row.MUSW__License2__r){
                                        row.Id = row.MUSW__License2__r;
                                    } else {
                                        row.Id = "None";
                                    }
                                    if(row.MUSW__Parcel__r.MUSW__City__c){
                                        row.City = row.MUSW__Parcel__r.MUSW__City__c;
                                    } else {
                                        row.City = "None";
                                    }
                                }
                            } 
                            component.set('v.columns', [
                                {label: 'Name', fieldName: 'Name', type: 'button', sortable : true, typeAttributes: 
                                 { label: {fieldName: 'Name'} , name: 'view_details', title: {fieldName: 'Name'}}},
                                {label: 'License Number', fieldName: 'License_Number', type: 'Number', sortable : true},
                                {label: 'License Type', fieldName: 'License_Type', type: 'Picklist', sortable : true, title:{fieldName: 'License_Type'}},
                                {label: 'Status', fieldName: 'Status', type: 'Picklist', sortable : true},
                                {label: 'Sub Status', fieldName: 'Sub_Status', type: 'Picklist', sortable : true},
                                {label: 'Disciplinary Action', fieldName: 'Discipline', type: 'boolean', sortable : true},
                                {label: 'City', fieldName: 'City', type: 'Text', sortable : true},
                                //{label: 'View Details', type: 'button', initialWidth: 160, typeAttributes: 
                                 //{ label: 'More Details', name: 'view_details', title: 'Click to View Details'}},
                            ]);
                            component.set("v.data", rows);
                            component.set("v.applicationFilt",rows);
                            component.set("v.screenTwo", true);
                            component.set("v.screenOne", false);
                            component.set("v.searchTwo",true);
                            component.set("v.searchTwoArray",searchTwoArray);
                            component.set("v.loaded", true);
                            } else {
                            component.set("v.loaded", true);
                            toastEvent.setParams({
                                "title": "Error!",
                                "message": "No results found.",
                                "type": "error"
                            });
                            toastEvent.fire();
                        }
                    }else{
                        component.set("v.loaded", true);
                        var errors = response.getError();
                        if (errors) {
                            var message = "";
                            if (errors[0] && errors[0].message) {
                               message = "Error message: " + errors[0].message;
                            }
                        }
                        else {
                            message = "Unknown error";
                        }
                        toastEvent.setParams({
                            "title": "Error!",
                            "message": message,
                            "type": "error"
                        });
                        toastEvent.fire(); 
                    }
                });
                $A.enqueueAction(action);
            } else {
                component.set("v.loaded", true);
                toastEvent.setParams({
                    "title": "Error!",
                    "message": "Please fill atleast one field.",
                    "type": "error"
                });
                toastEvent.fire();             
            }
        } else {
            component.set("v.licenseNameToDisplay", "Business License");
            var fieldsList = ['MUSW__License2__r.License_Printable_Name__c','MUSW__License2__r.MUSW__Primary_Licensee__r.Doing_Business_As_1__c','MUSW__License2__r.UBI_Number__c','MUSW__License2__r.Name','MUSW__License2__r.Credential_Type__c','MUSW__License2__r.MUSW__Status__c','MUSW__License2__r.Sub_Status__c','MUSW__Parcel__r.MUSW__City__c','MUSW__License2__r.RecordType.Name'];
            var businessName = component.find("businessName").get("v.value");
            var ubiNumber = component.find("ubiNumber").get("v.value");
            var licenseStatusBusiness = component.find("licenseStatusBusiness").get("v.value");
            var cityBusiness = component.find("cityBusiness").get("v.value");
            var countryBusiness = component.find("countryBusiness").get("v.value");
            var licenseTypeBusiness = component.find("licenseTypeBusiness").get("v.value");
			var endorsementType = "";
            var licenseStatusBoolean = false; 
            if(businessName!= "" && businessName.trim()!= "" && businessName.trim().length!= ""){
                searchTwoArray.push({label:"Business Name/Doing Business As", value:businessName});
            }
            if(ubiNumber!= "" && ubiNumber.trim()!= "" && ubiNumber.trim().length!= ""){
                searchTwoArray.push({label:"UBI Number", value:ubiNumber});
            }
            if(licenseStatusBusiness!= ""){
                searchTwoArray.push({label:"License Status", value:licenseStatusBusiness});
                licenseStatusBoolean = true;
            }
            if(cityBusiness!= "" && cityBusiness.trim()!= "" && cityBusiness.trim().length!= ""){
                searchTwoArray.push({label:"City", value:cityBusiness});
            }
            if(countryBusiness!= ""){
                searchTwoArray.push({label:"County", value:countryBusiness});
            }
            if(licenseTypeBusiness!= ""){
                searchTwoArray.push({label:"License Type", value:licenseTypeBusiness});
            }
            if(endorsementType!= ""){
                searchTwoArray.push({label:"Endorsement Type", value:endorsementType});
            }
            if(searchTwoArray.length!=0){
                var criteria = {
                    "MUSW__License2__r.UBI_Number__c":ubiNumber,
                    "MUSW__License2__r.MUSW__Status__c":licenseStatusBusiness,
                    "MUSW__Parcel__r.MUSW__City__c":cityBusiness,
                    "MUSW__Parcel__r.County__c":countryBusiness,
                    "MUSW__License2__r.Credential_Type__c":licenseTypeBusiness,
                    "MUSW__License2__r.RecordType.Name":"Business",
                }
                if(businessName!= "" && businessName.trim()!= "" && businessName.trim().length!= ""){
                    var criteriaOR = {
                        "1":'MUSW__License2__r.License_Printable_Name__c='+businessName,
                        "2":'MUSW__License2__r.MUSW__Primary_Licensee__r.Doing_Business_As_1__c='+businessName,
                    }
                    var action = component.get("c.generateQueryWithGenericOR");
                    action.setParams({
                        'objectName':objectApi,
                        'lstFieldsName':fieldsList,
                        'mapValues':criteria,
                        'mapORValues':criteriaOR,
                        'bIsStatusIncluded':licenseStatusBoolean,
                        'showDeciplinary':true
                    });
                } else {
                    var action = component.get("c.generateQueryWithOR");
                    action.setParams({
                        'objectName':objectApi,
                        'lstFieldsName':fieldsList,
                        'mapValues':criteria,
                        'bIsStatusIncluded':licenseStatusBoolean,
                        'showDeciplinary':true
                    });
                }                
                action.setCallback(this, function(response){
                    var state = response.getState();
                    if (state === "SUCCESS"){
                        var rows = response.getReturnValue();
                        if(rows.length!=0){
                            for (var i = 0; i < rows.length; i += 1) { 
                                var row = rows[i]; 
                                if (row.MUSW__License2__r) {
                                    if(row.MUSW__License2__r.License_Printable_Name__c){
                                        row.Business_Name = row.MUSW__License2__r.License_Printable_Name__c;
                                    } else {
                                        row.Business_Name = "None";
                                    }
                                    if(row.MUSW__License2__r.MUSW__Primary_Licensee__r){
                                        if(row.MUSW__License2__r.MUSW__Primary_Licensee__r.Doing_Business_As_1__c){
                                            row.Doing_Business_As = row.MUSW__License2__r.MUSW__Primary_Licensee__r.Doing_Business_As_1__c;
                                        } else {
                                            row.Doing_Business_As = "None";
                                        }
                                    }else {
                                        row.Doing_Business_As = "None";
                                    }
                                    if(row.MUSW__License2__r.UBI_Number__c){
                                        row.UBI_Number = row.MUSW__License2__r.UBI_Number__c;
                                    } else {
                                        row.UBI_Number = "None";
                                    }
                                    if(row.MUSW__License2__r.Name){
                                        row.License_Number = row.MUSW__License2__r.Name;
                                    } else {
                                        row.License_Number = "None";
                                    }
                                    if(row.MUSW__License2__r.Credential_Type__c){
                                        row.License_Type = row.MUSW__License2__r.Credential_Type__c;
                                    } else {
                                        row.License_Type = "None";
                                    }
                                    if(row.MUSW__License2__r.AIDS_Affidavit__c){
                                        row.Discipline = row.MUSW__License2__r.AIDS_Affidavit__c;
                                    } else {
                                        row.Discipline = false;
                                    }
                                    if(row.MUSW__License2__r.MUSW__Status__c){
                                        row.Status = row.MUSW__License2__r.MUSW__Status__c;
                                    } else {
                                        row.Status = "None";
                                    }
                                    if(row.MUSW__License2__r.Sub_Status__c){
                                        if(row.MUSW__License2__r.Sub_Status__c == 'Child Support Suspension' || row.MUSW__License2__r.Sub_Status__c == 'Surrendered'){
                                            row.Sub_Status = 'None';
                                        }else{
                                            row.Sub_Status = row.MUSW__License2__r.Sub_Status__c;
                                        }
                                    } else {
                                        row.Sub_Status = "None";
                                    }
                                    if(row.MUSW__License2__r.RecordType){
                                        row.Type = row.MUSW__License2__r.RecordType.Name;
                                    } else {
                                        row.Type = "None";
                                    }
                                    if(row.MUSW__License2__r){
                                        row.Id = row.MUSW__License2__r;
                                    } else {
                                        row.Id = "None";
                                    }
                                    if(row.MUSW__Parcel__r.MUSW__City__c){
                                        row.City = row.MUSW__Parcel__r.MUSW__City__c;
                                    } else {
                                        row.City = "None";
                                    }
                                }
                            }
                            component.set('v.columns', [
                                {label: 'Business Name', fieldName: 'Business_Name', type: 'button', sortable : true, typeAttributes: 
                                 { label: {fieldName: 'Business_Name'}, name: 'view_details', title: {fieldName: 'Business_Name'}}},
                                {label: 'Doing Business As', fieldName: 'Doing_Business_As', type: 'Text', sortable : true},
                                {label: 'UBI Number', fieldName: 'UBI_Number', type: 'Number', sortable : true},
                                {label: 'License Number', fieldName: 'License_Number', type: 'Number', sortable : true},
                                {label: 'License Type', fieldName: 'License_Type', type: 'Picklist', sortable : true, title:{fieldName: 'License_Type'}},
                                {label: 'Status', fieldName: 'Status', type: 'Picklist', sortable : true},
                                {label: 'Sub Status', fieldName: 'Sub_Status', type: 'Picklist', sortable : true},
                                {label: 'Disciplinary Action', fieldName: 'Discipline', type: 'boolean', sortable : true},
                                {label: 'City', fieldName: 'City', type: 'Text', sortable : true},
                                //{label: 'View Details', type: 'button', initialWidth: 160, typeAttributes: 
                                 //{ label: 'More Details', name: 'view_details', title: 'Click to View Details'}},
                            ]);
                            component.set("v.data", rows);
                            component.set("v.applicationFilt",rows);
                            component.set("v.screenTwo", true);
                            component.set("v.screenOne", false);
                            component.set("v.searchTwo",true);
                            component.set("v.searchTwoArray",searchTwoArray);
                            component.set("v.loaded", true);
                            } else {
                            component.set("v.loaded", true);
                            toastEvent.setParams({
                                "title": "Error!",
                                "message": "No results found.",
                                "type": "error"
                            });
                            toastEvent.fire();
                        }
                    }else{
                        component.set("v.loaded", true);
                        var errors = response.getError();
                        if (errors) {
                            var message = "";
                            if (errors[0] && errors[0].message) {
                               message = "Error message: " + errors[0].message;
                            }
                        }
                        else {
                            message = "Unknown error";
                        }
                        toastEvent.setParams({
                            "title": "Error!",
                            "message": message,
                            "type": "error"
                        });
                        toastEvent.fire(); 
                    }
                });
                $A.enqueueAction(action);
            } else {
                component.set("v.loaded", true);
                toastEvent.setParams({
                    "title": "Error!",
                    "message": "Please fill atleast one field.",
                    "type": "error"
                });
                toastEvent.fire();             
            }
        }
    },
    cancelSearchWithDetails : function(component) {
        var selectedTab = component.get("v.selectedTabId");
        if(selectedTab == "tab1"){
            component.find("firstName").set("v.value", "");
            component.find("middleName").set("v.value", "");
            component.find("lastName").set("v.value", "");
            component.find("licenseStatus").set("v.value", "");
            component.find("city").set("v.value", "");
            component.find("country").set("v.value", "");
            component.find("licenseType").set("v.value", "");
        } else {
            component.find("businessName").set("v.value", "");
            component.find("ubiNumber").set("v.value", "");
            component.find("licenseStatusBusiness").set("v.value", "");
            component.find("cityBusiness").set("v.value", "");
            component.find("countryBusiness").set("v.value", "");
            component.find("licenseTypeBusiness").set("v.value", "");
        }        
	},
    sortData : function(component,fieldName,sortDirection){
        var data = component.get("v.applicationFilt");
        var key = function(a) { return a[fieldName]; }
        var reverse = sortDirection == 'asc' ? 1: -1;
        
        if(fieldName == 'Discipline'){ 
            data.sort(function(a,b){
                var a = key(a) ? key(a) : '';
                var b = key(b) ? key(b) : '';
                return reverse * ((a>b) - (b>a));
            }); 
        }
        else{
            data.sort(function(a,b){ 
                var a = key(a) ? key(a).toLowerCase() : '';
                var b = key(b) ? key(b).toLowerCase() : '';
                return reverse * ((a>b) - (b>a));
            });    
        }
        component.set("v.applicationFilt",data);
    },
    convertArrayOfObjectsToCSV : function(component,objectRecords){
        // declare variables
        var csvStringResult, counter, keys, columnDivider, lineDivider;
       
        // check if "objectRecords" parameter is null, then return from function
        if (objectRecords === null || !objectRecords.length) {
            return null;
         }
        // store ,[comma] in columnDivider variabel for sparate CSV values and 
        // for start next line use '\n' [new line] in lineDivider varaible  
        columnDivider = ',';
        lineDivider =  '\n';
 
        // in the keys valirable store fields API Names as a key 
        // this labels use in CSV file header
        var tabValue = component.get("v.licenseNameToDisplay");
        if(tabValue == "License"){
            keys = ['Type','Name','License_Number','License_Type','City','Discipline','Status','Sub_Status'];
        } else if(tabValue == "Professional License"){
            keys = ['Name','License_Number','License_Type','City','Discipline','Status','Sub_Status'];
        } else if(tabValue == "Business License"){
            keys = ['Business_Name','Doing_Business_As','UBI_Number','License_Number','License_Type','Discipline','City','Status'];
        }               
        csvStringResult = '';
        csvStringResult += keys.join(columnDivider);
        csvStringResult += lineDivider; 
        for(var i=0; i < objectRecords.length; i += 1){   
             counter = 0;           
             for(var sTempkey in keys) {
                 if (keys.hasOwnProperty(sTempkey)) {
                    var skey = keys[sTempkey] ;   
                  // add , [comma] after every String value,. [except first]
                      if(counter > 0){ 
                          csvStringResult += columnDivider; 
                       }                  
                   csvStringResult += '"'+ objectRecords[i][skey]+'"';                
                   counter++;
             	}
            } // inner for loop close 
             csvStringResult += lineDivider;
          }// outer main for loop close 
       
       // return the CSV formate String 
        return csvStringResult;        
    },
    /*preventLeaving: function() {
        var evt = window.attachEvent || window.addEventListener;
        var checkEvt = window.attachEvent ? 'onbeforeunload' : 'beforeunload';
        evt(checkEvt, function(e) { 
            var msg = 'Are you sure you want to leave the page?';
            (e || window.event).returnValue = msg;
            return msg;
        });
    },
    leaveHandler: function(event) {
          event.preventDefault();
          event.returnValue = 'chel hut';
    },*/
})