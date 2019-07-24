({
	doInit : function(component, event, objectApi, fieldsName, auraAttr) {
        var localDate = new Date();
        var monthShortNames = ["Jan", "Feb", "Mar", "Apr", "May", "Jun","Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];
		var dayShortNames = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"];
        var month = localDate.getMonth();
        var date = localDate.getDate();
        var year = localDate.getFullYear();
        var day = localDate.getDay();
        localDate = dayShortNames[day]+' '+monthShortNames[month]+' '+date+' '+year+' '+localDate.getHours()+':'+localDate.getMinutes()+':'+localDate.getSeconds();
		component.set("v.date", localDate);
        var picklistArray = [];
        var action = component.get("c.getPicklistFieldValues");
        action.setParams({
            'objectName':objectApi,
            'pickListFieldName':fieldsName
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS"){
                var result = response.getReturnValue();  
                console.log('result---'+result);
               
                if(auraAttr == 'v.deliveryMethodOptions' || auraAttr == 'v.courseTopicOptions' ){
                    for(var i=0; i<result.length; i++){
                        picklistArray.push({Name: result[i] , isSelected: false});
                    }
                    component.set(auraAttr,picklistArray);
                }
				else{
                     component.set(auraAttr, result);
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
    fetchMultiSelectPicklistVal : function(component,event){
        console.log('in fetch multi select picklist values');
        var action = component.get("c.fetchMetaDataValues");
        var progOptVal = [];
        
        action.setCallback(this, function(response){
            var state = response.getState();
            console.log('state metadata '+state);
            if(state === 'SUCCESS'){
                var result = response.getReturnValue();
                console.log('result metadata'+ JSON.stringify(result));
                component.set("v.prgmLicMap",result);
                for(var key in result){
                    progOptVal.push(key);
                    console.log('progOptVal'+ progOptVal);
                }
              component.set("v.programOptions",progOptVal); 
              component.set("v.optionsExist",true);  
                console.log(JSON.stringify(component.get("v.programOptions")));
            }
        });
        $A.enqueueAction(action); 
    
    },
    searchCourse : function(component, event) {
       // alert('Search Called!!');
        var objectApi =  'MUSW__License2__c';
        var fieldsList = ['Name','Id','Course_Name__c','Course_Number__c','Credential_Type__c','Application_Type__c','What_Licensure_Level__c','What_program_are_you_interested_in__c','Course_Status__c','Course_Title__c','Course_Topic__c','Course_Type__c','Provider_School_Name__c','Clock_Hours__c','Delivery_Method__c'];
        var ProgramValue =  component.find("Program").get("v.value");
        var LicenseType;
        if(ProgramValue == 'Appraisers'){
            LicenseType = 'Appraiser Course';
        }else{
            LicenseType = ProgramValue;
        }
        var CourseTypeValue =  component.find("CourseType").get("v.value");
        var licensureLevelValue =  component.find("licensureLevel").get("v.value");
        var schoolNameValue =  component.find("schoolName").get("v.value");
        var courseNameValue =  component.find("courseName").get("v.value")
        var courseNumberValue =  component.find("courseNumber").get("v.value")
        var clockHoursValue =  component.find("clockHours").get("v.value")
        var TopicValue =  component.find("Topic").get("v.value")
        var StatusValue = component.find("Status").get("v.value");
        var DeliveryMethodValue = component.find("DeliveryMethod").get("v.value");
        var courseRecordTypeVal = component.get("v.CourseRecordTypeId");
      //  var CourseNameValue = component.find("courseName").get("v.value");
       
        
        var searchOneArray=[];
        
        var toastEvent = $A.get("e.force:showToast");
        var initialRows = component.get("v.initialRows");
        
        if(ProgramValue != ""){
            searchOneArray.push({label:"What program are you interested in?", value:LicenseType});
        }
        if(CourseTypeValue!= ""){
            searchOneArray.push({label:"Course Type", value:CourseTypeValue});
        }
        if(licensureLevelValue!= ""){
            searchOneArray.push({label:"What licensure level?", value:licensureLevelValue});
        }
        if(schoolNameValue!= "" ){
            searchOneArray.push({label:"Provider/School Name", value:schoolNameValue});
        }
        if(courseNameValue!= "" && courseNameValue!= null && courseNameValue.trim()!= "" && courseNameValue.trim().length!= ""){
            searchOneArray.push({label:"Course Name", value:courseNameValue});
        }
        if(courseNumberValue!= "" && courseNumberValue!= null && courseNumberValue.trim()!= "" && courseNumberValue.trim().length!= ""){
            searchOneArray.push({label:"Course Number", value:courseNumberValue});
        }
        if(clockHoursValue!= "" ){
            searchOneArray.push({label:"Clock Hours", value:clockHoursValue});
        }
        if(TopicValue!= ""){
            searchOneArray.push({label:"Topic", value:TopicValue});
        }
        if(StatusValue!= ""){
            searchOneArray.push({label:"Status", value:StatusValue});
        }
         if(DeliveryMethodValue!= ""){
            searchOneArray.push({label:"Delivery Method", value:DeliveryMethodValue});
             if(DeliveryMethodValue == 'One-time event / Seminar'){
                 component.set("v.showEvents", true);
             }
        }
        console.log(searchOneArray);
        
        if(searchOneArray.length!=0){
            var criteria = {
                 "Ultimate_Parent_Account__r.Name" : schoolNameValue,
                "Credential_Type__c" : LicenseType,
                "Course_Type__c" : CourseTypeValue,
                "What_Licensure_Level__c" : licensureLevelValue,
                "Course_Title__c" : courseNameValue,
                "Name" : courseNumberValue,
                "Clock_Hours__c" : clockHoursValue,
                "Course_Topic__c" : TopicValue,
                "MUSW__Status__c" : StatusValue,
                "Delivery_Method__c" : DeliveryMethodValue,
                "RecordTypeId" : courseRecordTypeVal 
            };
            var action = component.get("c.generateQuery");
            action.setParams({
                'objectName':objectApi,
                'lstFieldsName':fieldsList,
                'mapValues':criteria,
                
            });
            action.setCallback(this, function(response){
                var state = response.getState();
            //   alert("state---"+state);
                if (state === "SUCCESS"){
                    console.log("state---"+state);
                    var rows = response.getReturnValue();  
                    console.log('rows: '+response.getReturnValue());
                    if(rows.length!=0){
                        
                         
                        component.set('v.columns', [
                            {label: 'Course Name', fieldName: 'Course_Title__c', type: 'Text', sortable : true},
                            {label: 'Provider/School', fieldName: 'Provider_Account_Name__c', type: 'Text', sortable : true},
                            {label: 'Course Number', fieldName: 'Name', type: 'Text', sortable : true},
                            {label: 'Course Type', fieldName: 'Course_Type__c', type: 'Picklist', sortable : true},                            
                            {label: 'Delivery Method', fieldName: 'Delivery_Method__c', type: 'Picklist', sortable : true},
                            {label: 'Clock Hours', fieldName: 'Clock_Hours__c', type: 'Number', sortable : true},
                            {label: 'Course Status', fieldName: 'MUSW__Status__c', type: 'Picklist', sortable : true},
                            {label: 'View Details', type: 'button', initialWidth: 160, typeAttributes: 
                            { label: 'More Details', name: 'view_details', title: 'Click to View Details'}},
                         /*{label: 'Licensure Levels', fieldName: 'What_Licensure_Level__c', type: 'Picklist', sortable : true} */
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
     navigateToCustomPlace1 : function(component, event){
        component.set("v.screenOne", true);
        component.set("v.screenTwo", false);
        component.set("v.screenThree", false);
        component.set("v.data", "");
        component.set("v.dispList", "");
        component.set("v.applicationFilt","");
        component.set("v.detailData", "");
       // component.set("v.endorsementData", "");
       // component.set("v.licenseRelationData", "");
        component.set("v.selectedTabId", "tab1");
      //  component.set("v.licenseNameToDisplay", "License");
        
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
        }
    },
     fetchLicenseDetails : function(component, event, helper, licenseId, licenseType) {
         console.log('licenseId'+licenseId);
        if(licenseId != "" && licenseId != undefined){
            component.set("v.licenseId", licenseId);
            var objectApi =  'MUSW__License2__c';
            component.set("v.courseNameToDisplayDetails", "Course Details");
            var fieldsList = ['Name',
                              'What_Licensure_Level__c',
                              'What_program_are_you_interested_in__c',
                                  'Credential_Type__c',
                                  'Application_Type__c',
                                  'Course_Type__c',
                                  'License_Phone__c',
                                  'Original_Issue_Date__c',
                                  'Ultimate_Parent_Account__r.Name',
                                  'Course_Title__c',
                                  'Id',
                                  'Clock_Hours_Continuing_Education__c',
                                  'Clock_Hours_Pre_Qualifying__c',
                                  'Clock_Hours_Qualifying_Elective__c',
                                  'Clock_Hours__c',
                                  'Course_Topic__c', 
                                  'MUSW__Status__c', 
                                  'Delivery_Method__c', 
                                  'Owner_Address__c',
                                  'MUSW__Issue_Date__c',
                                  'Event_City__c',
                                  'Event_Date__c',
                                  'Event_State__c',
                                  'License_Email__c',
                              'Provider_Account_Name__c',
                              'Website__c',
                                  'MUSW__Expiration_Date__c'];
                    
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
                console.log('state-----'+state);
            if (state === "SUCCESS"){
                var result = response.getReturnValue(); 
                console.log('state 2-----'+state);
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
    cancelSearchWithNum : function(component, event) {
		component.find("Program").set("v.value", "");
        component.find("CourseType").get("v.value", "");
        component.find("licensureLevel").get("v.value", "");
        component.find("licenseNumber").set("v.value", "");
        component.find("Program").get("v.value","");
        component.find("schoolName").get("v.value","");
        component.find("courseName").get("v.value","");
        component.find("courseNumber").get("v.value","");
        component.find("clockHours").get("v.value","");
        component.find("Topic").get("v.value","")
        component.find("Status").get("v.value","");
        component.find("DeliveryMethod").get("v.value","");
	},
})