({
    doInit : function(component, event, helper) {
         helper.fetchMultiSelectPicklistVal(component,event,helper);
        var picklistArray = component.get("v.picklistList");
        var objectApi;
        var fieldsName;
        var auraAttr;
        
        console.log('picklistArray---'+picklistArray);
        for(var i=0; i<picklistArray.length; i++){
            objectApi = picklistArray[i].objectApi;
            fieldsName = picklistArray[i].fieldsName;
            auraAttr = picklistArray[i].auraAttr;
            helper.doInit(component, event, objectApi, fieldsName, auraAttr);
        }
        //
    /*    var objectApi =  'RecordType';
        var SobjectTypeValue = 'MUSW__License2__c';
        var recordTypeName = 'Course';
        var fieldsList = ['Name','Id','SobjectType'];
        var criteria = {
            'SobjectType' : SobjectTypeValue,
            'Name' : recordTypeName
        };
        var action = component.get("c.generateQuery");
        action.setParams({
                'objectName':objectApi,
                'lstFieldsName':fieldsList,
                'mapValues':criteria
                
            });
        action.setCallback(this, function(response){
                var state = response.getState();
              // alert("state---"+state);
            if (state === "SUCCESS"){
                console.log('state'+state);
                var result = response.getReturnValue();
               // alert(result);
                component.set("v.CourseRecordTypeId",result[0].Id);
                
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
        $A.enqueueAction(action);  */
    },
    
    searchCourse : function(component, event, helper) {
        var Program = component.find("Program").get("v.value");
        var CourseType = component.find("CourseType").get("v.value");
        var credOptVal = [];
        if(Program !=""){
            component.set("v.disableLicenseType",false);
            var temp = component.get("v.prgmLicMap");
            console.log('temp::'+JSON.stringify(temp));
            console.log('program:'+ Program);
            var valueList = temp[Program];
            component.set("v.licensureLevelOptions",valueList);
        }
        var Licensurelevel = component.find("licensureLevel").get("v.value");
        console.log('Licensurelevel'+Licensurelevel);
       
      //  var toastEvent = $A.get("e.force:showToast");
        if(Program != "" && CourseType != ""){
            component.set("v.showSearchFields", true);
            
        }
		
	},
    fetchCourseDetails: function(component, event, helper){
        helper.searchCourse(component, event);
    },
    navigateToCustomPlace1 : function(component, event, helper) {
		helper.navigateToCustomPlace1(component, event);
	},
    navigateToCustomPlace2 : function(component, event, helper) {
		helper.navigateToCustomPlace2(component, event);
	},
    navigateToCustomPlace3 : function(component, event, helper) {
		event.preventDefault();
	},
    modifySearch : function(component, event, helper) {
		helper.navigateToCustomPlace1(component, event);
	},
    handleSort : function(component,event,helper){
        var sortBy = event.getParam("fieldName");
        var sortDirection = event.getParam("sortDirection");
        component.set("v.sortBy",sortBy);
        component.set("v.sortDirection",sortDirection);
        helper.sortData(component,sortBy,sortDirection);
    },
     handleRowAction : function(component, event, helper) {
		var action = event.getParam('action');
        var row = event.getParam('row');
        var licenseId = row.Name;
        var licenseRecordId = row.Id;
        var licenseType = row.recordType;
        component.set("v.licenseRecordType", licenseType);
        switch (action.name) {
            case 'view_details':
             	component.set("v.licenseId",licenseId);
                helper.fetchLicenseDetails(component, event, helper, licenseId, licenseType);
              //  helper.fetchEndorsementDetails(component, event, helper, licenseRecordId);
             /*   if(relatedLicense!=undefined){
                    helper.fetchParentLicenses(component, event, helper, licenseRecordId);
                } else {
                    helper.fetchChildLicenses(component, event, helper, licenseRecordId); 
                }*/
                break;
            default:
                break;
        }
	},
   cancelSearchWithNum : function(component, event, helper) {
		helper.cancelSearchWithNum(component, event);
	},
})