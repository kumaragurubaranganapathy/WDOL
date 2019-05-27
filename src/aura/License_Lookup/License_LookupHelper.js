({	
    doInit : function(component, event, objectApi, fieldsName, auraAttr) {
        var localDate = new Date();
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
                component.set(auraAttr, result);
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
    navigateToCustomPlace1 : function(component, event){
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
    searchWithNum : function(component, event) {
        var objectApi =  'MUSW__License2__c';
        var fieldsList = ['MUSW__Applicant__r.Name','Name','Credential_Type__c','MUSW__Status__c','Sub_Status__c','MUSW__Applicant__r.Birth_City__c','Related_License__c','RecordType.Name'];
        var professionValue =  component.find("Profession").get("v.value");
        var licenseNumberValue = component.find("licenseNumber").get("v.value");
        var searchOneArray=[];
        var toastEvent = $A.get("e.force:showToast");
        var initialRows = component.get("v.initialRows");
        if(professionValue != ""){
            searchOneArray.push({label:"Profession", value:professionValue});
        }
        if(licenseNumberValue!= "" && licenseNumberValue.trim()!= "" && licenseNumberValue.trim().length!= ""){
            searchOneArray.push({label:"License Number", value:licenseNumberValue});
        }
        if(searchOneArray.length!=0){
            var criteria = {
                "Application_Type__c":professionValue,
                "Name":licenseNumberValue,
            }
            var action = component.get("c.generateQuery");
            action.setParams({
                'objectName':objectApi,
                'lstFieldsName':fieldsList,
                'mapValues':criteria
            });
            action.setCallback(this, function(response){
                var state = response.getState();
                if (state === "SUCCESS"){
                    var rows = response.getReturnValue();     
                    if(rows.length!=0){
                        for (var i = 0; i < rows.length; i++) { 
                            var row = rows[i]; 
                            if (row.MUSW__Applicant__r) {
                                if(row.MUSW__Applicant__r.Name){
                                    row.ApplicantName = row.MUSW__Applicant__r.Name;
                                }
                                if(row.MUSW__Applicant__r.Birth_City__c){
                                    row.ApplicantCity = row.MUSW__Applicant__r.Birth_City__c;
                                }
                            }
                            if(row.RecordType){
                                row.recordType = row.RecordType.Name;
                            }
                        } 
                        component.set('v.columns', [
                            {label: 'Type', fieldName: 'recordType', type: 'Name', sortable : true},
                            {label: 'Name', fieldName: 'ApplicantName', type: 'Name', sortable : true},
                            {label: 'License Number', fieldName: 'Name', type: 'Number', sortable : true},
                            {label: 'License Type', fieldName: 'Credential_Type__c', type: 'Picklist', sortable : true},
                            {label: 'Status', fieldName: 'MUSW__Status__c', type: 'Picklist', sortable : true},
                            {label: 'Sub Status', fieldName: 'Sub_Status__c', type: 'Picklist', sortable : true},
                            {label: 'City', fieldName: 'ApplicantCity', type: 'Text', sortable : true},
                            {label: 'Actions', type: 'button', initialWidth: 160, typeAttributes: 
                             { label: 'More Details', name: 'view_details', title: 'Click to View Details'}},
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
                }else{
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
            toastEvent.setParams({
                "title": "Error!",
                "message": "Please fill atleast one field.",
                "type": "error"
            });
            toastEvent.fire();       
		}            
    },
	cancelSearchWithNum : function(component, event) {
		component.find("Profession").set("v.value", "");
        component.find("licenseNumber").set("v.value", "");
	},
    fetchLicenseDetails : function(component, event, helper, licenseId, licenseType) {
        if(licenseId != "" && licenseId != undefined){
            component.set("v.licenseId", licenseId);
            var selectedTab = component.get("v.selectedTabId");
            var objectApi =  'MUSW__License2__c';
            if(licenseType == "Business"){
                component.set("v.licenseNameToDisplayDetails", "Business License Details");
                var fieldsList = ['Name',
                                  'Credential_Type__c',
                                  'MUSW__Status__c',
                                  'MUSW__Primary_Licensee__r.Name',
                                  'Phone__c',
                                  'Original_Issue_Date__c',
                                  'Sub_Status__c',
                                  'Owner_Address__c',
                                  'MUSW__Issue_Date__c',
                                  'Application_Type__c',
                                  'MUSW__Expiration_Date__c'];
            } else {
                component.set("v.licenseNameToDisplayDetails", "Professional License Details");
                var fieldsList = ['Name',
                                  'Credential_Type__c',
                                  'MUSW__Status__c',
                                  'MUSW__Applicant__r.Name',
                                  'Original_Issue_Date__c',
                                  'Sub_Status__c',
                                  'MUSW__Applicant__r.Birth_City__c',
                                  'MUSW__Issue_Date__c',
                                  'MUSW__Applicant__r.State_of_residency__c',
                                  'MUSW__Expiration_Date__c',
                                  'Application_Type__c',
                                  'MUSW__Applicant__r.Birth_Country__c'];
            }            
            var criteria = {
                "Name":licenseId
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
                component.set("v.detailData", result);
                component.set("v.screenOne", false);
                component.set("v.screenTwo", false);
                component.set("v.screenThree", true);
            }else{
                 alert("error!!!!!");
            }
        });
        $A.enqueueAction(action);
    	}	              
    },
    fetchEndorsementDetails: function(component, event, helper, licenseRecordId){
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
    fetchParentLicenses : function(component, event, helper, licenseRecordId){
        if(licenseRecordId != "" && licenseRecordId != undefined){
            var objectApi =  'MUSW__License2__c';
            var fieldsList = ['Related_License__r.MUSW__Applicant__r.Full_Name__c',
                              'Related_License__r.Name',
                              'Related_License__r.Credential_Type__c',
                              'Related_License__r.MUSW__Status__c',
                              'Related_License__r.Sub_Status__c',
                              'Related_License__r.MUSW__Applicant__r.Birth_City__c' ];
            var criteria = {
                "Id":licenseRecordId
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
                component.set("v.licenseRelationData", result);
                component.set("v.parent", true);
            }else{
                 alert("error!!!!!");
            }
        });
        $A.enqueueAction(action);
    	}	            
    },
    fetchChildLicenses : function(component, event, helper, licenseRecordId){
        if(licenseRecordId != "" && licenseRecordId != undefined){
            var objectApi =  'MUSW__License2__c';
            var fieldsList = ['MUSW__Applicant__r.Name','Name','Credential_Type__c','MUSW__Status__c','Sub_Status__c','MUSW__Applicant__r.Birth_City__c'];
            var criteria = {
                "Related_License__c":licenseRecordId
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
                component.set("v.licenseRelationData", result);
                component.set("v.parent", false);
            }else{
                 alert("error!!!!!");
            }
        });
        $A.enqueueAction(action);
    	}	            
    },
    searchWithDetails : function(component, event) {
        var selectedTab = component.get("v.selectedTabId");
        var objectApi =  'MUSW__License2__c';
        var searchTwoArray=[];
        var toastEvent = $A.get("e.force:showToast");
        if(selectedTab == "tab1"){
 			component.set("v.licenseNameToDisplay", "Professional License");
			var fieldsList = ['MUSW__Applicant__r.Name','Name','Credential_Type__c','MUSW__Status__c','Sub_Status__c','MUSW__Applicant__r.Birth_City__c','RecordType.Name'];            
            var firstName = component.find("firstName").get("v.value");
            var middleName = component.find("middleName").get("v.value");
            var lastName = component.find("lastName").get("v.value");
            var licenseStatus = component.find("licenseStatus").get("v.value");
            var city = component.find("city").get("v.value");
            var country = component.find("country").get("v.value");
            var licenseType = component.find("licenseType").get("v.value");
			var endorsementType = "";            
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
            }
            if(city!= "" && city.trim()!= "" && city.trim().length!= ""){
                searchTwoArray.push({label:"City", value:city});
            }
            if(country!= ""){
                searchTwoArray.push({label:"Country", value:country});
            }
            if(licenseType!= ""){
                searchTwoArray.push({label:"License Type", value:licenseType});
            }
            if(endorsementType!= ""){
                searchTwoArray.push({label:"Endorsement Type", value:endorsementType});
            }
            if(searchTwoArray.length!=0){
                var criteria = {
                    "MUSW__Applicant__r.FirstName":firstName,
                    "MUSW__Applicant__r.MiddleName":middleName,
                    "MUSW__Applicant__r.LastName":lastName,
                    "MUSW__Status__c":licenseStatus,
                    "MUSW__Applicant__r.Birth_City__c":city,
                    "MUSW__Applicant__r.Birth_Country__c":country,
                    "Credential_Type__c":licenseType,
                    "Endorsements__r.Endorsement_Type__c":endorsementType
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
                        var rows = response.getReturnValue();
                        if(rows.length!=0){
                            for (var i = 0; i < rows.length; i++) { 
                                var row = rows[i]; 
                                if (row.MUSW__Applicant__r) {
                                    if(row.MUSW__Applicant__r.Name){
                                        row.ApplicantName = row.MUSW__Applicant__r.Name;
                                    }
                                    if(row.MUSW__Applicant__r.Birth_City__c){
                                        row.ApplicantCity = row.MUSW__Applicant__r.Birth_City__c;
                                    }
                                }
                                if(row.RecordType){
                                    row.recordType = row.RecordType.Name;
                                }
                            } 
                            component.set('v.columns', [
                                {label: 'Name', fieldName: 'ApplicantName', type: 'Name', sortable : true},
                                {label: 'License Number', fieldName: 'Name', type: 'Number', sortable : true},
                                {label: 'License Type', fieldName: 'Credential_Type__c', type: 'Picklist', sortable : true},
                                {label: 'Status', fieldName: 'MUSW__Status__c', type: 'Picklist', sortable : true},
                                {label: 'Sub Status', fieldName: 'Sub_Status__c', type: 'Picklist', sortable : true},
                                {label: 'City', fieldName: 'ApplicantCity', type: 'Text', sortable : true},
                                {label: 'Actions', type: 'button', initialWidth: 160, typeAttributes: 
                                 { label: 'More Details', name: 'view_details', title: 'Click to View Details'}},
                            ]);
                            component.set("v.data", rows);
                            component.set("v.applicationFilt",rows);
                            component.set("v.screenTwo", true);
                            component.set("v.screenOne", false);
                            component.set("v.searchTwo",true);
                            component.set("v.searchTwoArray",searchTwoArray);
                            } else {
                            toastEvent.setParams({
                                "title": "Error!",
                                "message": "No results found.",
                                "type": "error"
                            });
                            toastEvent.fire();
                        }
                    }else{
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
                toastEvent.setParams({
                    "title": "Error!",
                    "message": "Please fill atleast one field.",
                    "type": "error"
                });
                toastEvent.fire();             
            }
        } else {
            component.set("v.licenseNameToDisplay", "Business License");
            var fieldsList = ['MUSW__Primary_Licensee__r.Name','UBI_Number__c','Name','Credential_Type__c','MUSW__Status__c','Sub_Status__c','MUSW__Applicant__r.Birth_City__c','RecordType.Name'];
            var businessName = component.find("businessName").get("v.value");
            var ubiNumber = component.find("ubiNumber").get("v.value");
            var licenseStatusBusiness = component.find("licenseStatusBusiness").get("v.value");
            var cityBusiness = component.find("cityBusiness").get("v.value");
            var countryBusiness = component.find("countryBusiness").get("v.value");
            var licenseTypeBusiness = component.find("licenseTypeBusiness").get("v.value");
			var endorsementType = "";            
            if(businessName!= "" && businessName.trim()!= "" && businessName.trim().length!= ""){
                searchTwoArray.push({label:"Business Name/Doing Business As", value:businessName});
            }
            if(ubiNumber!= "" && ubiNumber.trim()!= "" && ubiNumber.trim().length!= ""){
                searchTwoArray.push({label:"UBI Number", value:ubiNumber});
            }
            if(licenseStatusBusiness!= ""){
                searchTwoArray.push({label:"License Status", value:licenseStatusBusiness});
            }
            if(cityBusiness!= "" && cityBusiness.trim()!= "" && cityBusiness.trim().length!= ""){
                searchTwoArray.push({label:"City", value:cityBusiness});
            }
            if(countryBusiness!= ""){
                searchTwoArray.push({label:"Country", value:countryBusiness});
            }
            if(licenseTypeBusiness!= ""){
                searchTwoArray.push({label:"License Type", value:licenseTypeBusiness});
            }
            if(endorsementType!= ""){
                searchTwoArray.push({label:"Endorsement Type", value:endorsementType});
            }
            if(searchTwoArray.length!=0){
                var criteria = {
                    "MUSW__Primary_Licensee__r.Name":businessName,
                    "UBI_Number__c":ubiNumber,
                    "MUSW__Status__c":licenseStatusBusiness,
                    "MUSW__Applicant__r.Birth_City__c":cityBusiness,
                    "MUSW__Applicant__r.Birth_Country__c":countryBusiness,
                    "Credential_Type__c":licenseTypeBusiness,
                    "Endorsements__r.Endorsement_Type__c":endorsementType
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
                        var rows = response.getReturnValue();
                        if(rows.length!=0){
                            for (var i = 0; i < rows.length; i++) { 
                                var row = rows[i]; 
                                if (row.MUSW__Applicant__r) {
                                    if(row.MUSW__Applicant__r.Birth_City__c){
                                        row.ApplicantCity = row.MUSW__Applicant__r.Birth_City__c;
                                    }
                                }
                                if(row.MUSW__Primary_Licensee__r){
                                    if(row.MUSW__Primary_Licensee__r.Name){
                                        row.ApplicantName = row.MUSW__Primary_Licensee__r.Name;
                                    }
                                }
                                if(row.RecordType){
                                    row.recordType = row.RecordType.Name;
                                }
                            } 
                            component.set('v.columns', [
                                {label: 'Business Name', fieldName: 'ApplicantName', type: 'Text', sortable : true},
                                {label: 'UBI Number', fieldName: 'UBI_Number__c', type: 'Number', sortable : true},
                                {label: 'License Number', fieldName: 'Name', type: 'Number', sortable : true},
                                {label: 'License Type', fieldName: 'Credential_Type__c', type: 'Picklist', sortable : true},
                                {label: 'Status', fieldName: 'MUSW__Status__c', type: 'Picklist', sortable : true},
                                {label: 'Sub Status', fieldName: 'Sub_Status__c', type: 'Picklist', sortable : true},
                                {label: 'City', fieldName: 'ApplicantCity', type: 'Text', sortable : true},
                                {label: 'Actions', type: 'button', initialWidth: 160, typeAttributes: 
                                 { label: 'More Details', name: 'view_details', title: 'Click to View Details'}},
                            ]);
                            component.set("v.data", rows);
                            component.set("v.applicationFilt",rows);
                            component.set("v.screenTwo", true);
                            component.set("v.screenOne", false);
                            component.set("v.searchTwo",true);
                            component.set("v.searchTwoArray",searchTwoArray);
                            } else {
                            toastEvent.setParams({
                                "title": "Error!",
                                "message": "No results found.",
                                "type": "error"
                            });
                            toastEvent.fire();
                        }
                    }else{
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
                toastEvent.setParams({
                    "title": "Error!",
                    "message": "Please fill atleast one field.",
                    "type": "error"
                });
                toastEvent.fire();             
            }
        }
    },
    cancelSearchWithDetails : function(component, event) {
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
        
        if(fieldName == 'NumberOfEmployees'){ 
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
        if (objectRecords == null || !objectRecords.length) {
            return null;
         }
        // store ,[comma] in columnDivider variabel for sparate CSV values and 
        // for start next line use '\n' [new line] in lineDivider varaible  
        columnDivider = ',';
        lineDivider =  '\n';
 
        // in the keys valirable store fields API Names as a key 
        // this labels use in CSV file header  
        keys = ['ApplicantName','Name','Credential_Type__c','MUSW__Status__c','Sub_Status__c','ApplicantCity' ];
        
        csvStringResult = '';
        csvStringResult += keys.join(columnDivider);
        csvStringResult += lineDivider; 
        for(var i=0; i < objectRecords.length; i++){   
             counter = 0;           
             for(var sTempkey in keys) {
                var skey = keys[sTempkey] ;   
              // add , [comma] after every String value,. [except first]
                  if(counter > 0){ 
                      csvStringResult += columnDivider; 
                   }                  
               csvStringResult += '"'+ objectRecords[i][skey]+'"';                
               counter++;
 
            } // inner for loop close 
             csvStringResult += lineDivider;
          }// outer main for loop close 
       
       // return the CSV formate String 
        return csvStringResult;        
    },
})