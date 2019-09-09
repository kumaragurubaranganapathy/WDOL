({
    hideAddRecord : function(component, event, helper) {
        var className = component.get('v.objectRecordType');
        className = className+'addRecord';
        var addRecord = document.getElementsByClassName(className);
        for (var i = 0; i < addRecord.length; ++i) {
            var item = addRecord[i];  
            item.classList.add('slds-hide');
        }
    },
    editRecordHelper : function(component, event, helper, editNo) {
        var rows = [];
        var outFields = [];
        outFields = document.getElementsByClassName(editNo+'showHide');
        for(var i = 0; i < outFields.length; ++i){
            var item = outFields[i];  
            item.classList.toggle('slds-hide');
        }
    },
    deleteRecordHelper : function(component, event, helper, editClassNo) {
        var action = component.get('c.deleteTableRecord');
        action.setParams({ recordId : editClassNo });
        action.setCallback(this,function(response){			
            var state = response.getState();
            if (state === "SUCCESS") {
                helper.setData(component, event, helper);
                var resultsToast = $A.get("e.force:showToast");
                resultsToast.setParams({
                    "title": "Deleted",
                    "message": "The record was deleted.",
                    "type": "success"
                });
                resultsToast.fire();
            }
        });
        //helper.hideAddRecord(component, event, helper);
        $A.enqueueAction(action);
    },
    setData : function(component, event, helper) {
        if(component.get('v.sObj') != null) {
            var sectionName = component.get('v.sectionName');
            var obj = component.get('v.sObj');
            var recordTypeID = component.get('v.objectRecordType');
            var dataList;
            // var recordList =[];
            var sectionList = [];
            var appId = component.get("v.applicationId");
            var action = component.get('c.returnIds');
            var dataRows=[];
            var recordList =[];
            console.log('flowType:' + component.get("v.flowType"));
            console.log('Record Id==' + recordTypeID + 'applicationId==' + appId + 'ObjectName== ' + obj);
            action.setParams({ applicationId : appId, ObjectName: obj, recordTypeID:recordTypeID,flowType:component.get("v.flowType")});
            action.setCallback(this,function(response){
                var state = response.getState();
                if (state === "SUCCESS") {
                    dataList = response.getReturnValue();
                    var sectionList = component.get('v.sectionList');
                    sectionList = sectionList.labelFieldsMap;
                    for(var i=0;i<sectionList.length;i++){
                        if(sectionList[i].questionSectionClass== sectionName && sectionList[i].fieldObjName == 'LnP_BackgroundSection__c' && obj=='LnP_BackgroundSection__c'){
                            recordList.push({"fieldName": sectionList[i].fieldAPIName, "label": sectionList[i].label, "required":sectionList[i].isMandatoryQues, "regex":sectionList[i].regex, "error":sectionList[i].errormsg, "masking":sectionList[i].validationCriteria});
                        }
                        else if(sectionList[i].questionSectionClass== sectionName && sectionList[i].fieldObjName == 'Endorsement__c' && obj=='Endorsement__c'){
                            recordList.push({"fieldName": sectionList[i].fieldAPIName, "label": sectionList[i].label});
                        }
                        else if(sectionList[i].questionSectionClass== sectionName && sectionList[i].fieldObjName == 'Electronic_Notary_Provider_Information__c' && obj=='Electronic_Notary_Provider_Information__c'){
                            recordList.push({"fieldName": sectionList[i].fieldAPIName, "label": sectionList[i].label});
                        }
                        else if(sectionList[i].questionSectionClass== sectionName && sectionList[i].fieldObjName == 'Education_History__c' && obj=='Education_History__c'){
                            recordList.push({"fieldName": sectionList[i].fieldAPIName, "label": sectionList[i].label});
                        }
                    }
                    component.set('v.recordList', recordList);
                    for(var i=0;i<dataList.length;i++){
                        dataRows.push({"id": dataList[i].Id, "fields": recordList});
                    }
                    component.set('v.dataRows', dataRows);
                }
            });
            $A.enqueueAction(action);
        }
    },
    getLicenseData:function(component, event, helper){
        var action = component.get("c.updateEducationHistoryRecord");
        action.setParams({'educationHistoryRecordId': component.get("v.educationHistoryId"),
                          'requestId': component.get("v.applicationId")});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var educationHistoryRecordDetails = response.getReturnValue();
                console.log('educationHistoryRecordDetails=' + educationHistoryRecordDetails);
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                console.error(JSON.stringify(errors));
            }
        });
        $A.enqueueAction(action);
    },
    inputClick : function(component,event){        
        var currentValue;
        /*var outFields = component.find("outputEditfield");
        var endDateField;
        outFields.forEach(function(elem){
            if(elem.get("v.fieldName"==="End_date__c"))
                endDateField = elem;
        }); */
        var currElem = event.getSource();
        if(currElem.get("v.fieldName")==="Current__c"){
            currentValue = currElem.get("v.value");
            component.set("v.currentValue",currentValue);            
        }
		var currElement = event.getSource().get('v.value'); 
        var currfield=event.getSource().get('v.fieldName');
        var masking = event.getSource().get('v.id');
        var patternArray=masking.split(",")
        var strlength=patternArray[0];
        var sliceIndex=patternArray[1];
        var intervalIndex=patternArray[2];
        var delimiter=patternArray[3];
        var endIndex=(+sliceIndex)+(+intervalIndex);
        if(currfield=="Supervisor_Phone_Number__c"){
            if(currElement.length==strlength){
                var trimmedNo = ('' + currElement).replace(/\D/g, '');
                var phone = trimmedNo.slice(0, sliceIndex)+delimiter+trimmedNo.slice(sliceIndex,endIndex) + delimiter + trimmedNo.slice(endIndex);
                event.getSource().set('v.value',phone); 
            }
        }		
    },
    inputEditClick : function(component,event){        
        var currElem = event.getSource();
        //var inputFields = component.find("inputEditField");
        var currentValue;
        var cardIndex; 
        var cardClass;
        if(currElem.get("v.fieldName")==="Current__c"){
            currentValue = currElem.get("v.value"); 
            cardClass = currElem.get("v.class");
            cardIndex = parseInt(cardClass.split("itemRow=")[1]);
            component.set("v.currentEditValue",currentValue);
            component.set("v.cardIndex",cardIndex);            
        }
		var currElement = event.getSource().get('v.value'); 
        var currfield=event.getSource().get('v.fieldName');
        var masking = event.getSource().get('v.id');
        var patternArray=masking.split(",")
        var strlength=patternArray[0];
        var sliceIndex=patternArray[1];
        var intervalIndex=patternArray[2];
        var delimiter=patternArray[3];
        var endIndex=(+sliceIndex)+(+intervalIndex);
        if(currfield=="Supervisor_Phone_Number__c"){
            if(currElement.length==strlength){
                var trimmedNo = ('' + currElement).replace(/\D/g, '');
                var phone = trimmedNo.slice(0, sliceIndex)+delimiter+trimmedNo.slice(sliceIndex,endIndex) + delimiter + trimmedNo.slice(endIndex);
                event.getSource().set('v.value',phone); 
            }
        }
        /*inputFields.forEach(function(elem){
            var fieldName = elem.get("v.fieldName");
            if(fieldName==="Current__c"){
                currentValue = elem.get("v.value");               
            }                         
            if(fieldName==="End_date__c"&&currentValue)
                $A.util.addClass(elem,'slds-hide');            
            else if(fieldName==="End_date__c"&&!currentValue)
                $A.util.removeClass(elem,'slds-hide');            
        }); */
    },
    test: function(component,event){ 
        /*   console.log("in test");
        var currElement = event.getSource().get('v.value'); 
        var currfield=event.getSource().get('v.fieldName')
        if(currfield=="Start_date__c"){
        var d = new Date(currElement);
        var month = d.getMonth()+1;
        var year =  d.getFullYear();
        var formattedDate=month+","+year
        event.getSource().set('v.value',formattedDate);  
          console.log(formattedDate);
        }*/
    },
	validate : function(component, event, helper) {
		var classList = event.getSource().get("v.class");
		var blockID = event.getSource().get("v.name");
		var totalFieldsList = component.get("v.sectionList").labelFieldsMap;
		var sectionFieldsList = [];
		var errorMessage = "Please fill valid data";
		if(classList.includes("Qualifying Postsecondary Education")){
			sectionFieldsList = totalFieldsList.filter(function(item){
				return item.questionSectionClass == "Qualifying Postsecondary Education" && (item.isMandatoryQues || item.regex != null);
			});
		}
		if(classList.includes("Qualifying Experience")){
			sectionFieldsList = totalFieldsList.filter(function(item){
				return item.questionSectionClass == "Qualifying Experience" && (item.isMandatoryQues || item.regex != null);
			});
		}
		if(classList.includes("Qualifying Courses")){
			sectionFieldsList = totalFieldsList.filter(function(item){
				return item.questionSectionClass == "Qualifying Courses" && (item.isMandatoryQues || item.regex != null);
			});
		}
		if(classList.includes("Continuing Education")){
            sectionFieldsList = totalFieldsList.filter(function(item){
                return item.questionSectionClass == "Continuing Education" && (item.isMandatoryQues || item.regex != null);
            });
        }
		if(classList.includes("editFields")){
			component.set("v.editForm", true);
			var fieldValuesWrapper = component.find("validateEditField");
			fieldValuesWrapper = fieldValuesWrapper.filter(function(item){
				return item.get("v.class").includes('itemRow='+blockID); 
			});
		}else{
			component.set("v.editForm", false);
			var fieldValuesWrapper = component.find("validateField");
		}
		var validateFlagCheck = sectionFieldsList.every(function(item, index){
			if(!fieldValuesWrapper[index].get("v.class").includes('slds-hide')){
				if(item.isMandatoryQues){
					if(item.regex != undefined && item.regex != null && item.regex != ""){
						var valueVal = fieldValuesWrapper[index].get("v.value");
						if(valueVal != '' && valueVal != null && valueVal != "--None--" && valueVal != "--none--" && valueVal.toString().trim() != undefined && valueVal.toString().trim() != ""){
							if(item.regex == "Date-Validation"){
								var valueVal = fieldValuesWrapper[index].get("v.value");
								var today = new Date();
								var compareDate = today.getFullYear()+'-'+(today.getMonth().length>1?(today.getMonth()+1):'0'+(today.getMonth()+1))+'-'+today.getDate();
								compareDate = new Date(compareDate);
								var enteredDate = new Date(valueVal);
								if(enteredDate < compareDate){
									return true;
								}else{
									errorMessage = item.errormsg != undefined? item.errormsg: "Date is required and it should be prior to today's date";
									return false;
								}
							}  else if(item.regex == "minimum-value"){
                                var valueVal = fieldValuesWrapper[index].get("v.value");
                                var minValue = parseInt(item.minValue);
                                if(valueVal >= minValue){
                                    return true;
                                }else{
                                    errorMessage = item.errormsg != undefined? item.errormsg: item.Name+" error";
                                    return false;
                                }
                            } else {
								var regexExp = new RegExp(item.regex);
								var valueVal = fieldValuesWrapper[index].get("v.value");
								if(regexExp.test(valueVal)){
									return true;
								}else{
									errorMessage = item.errormsg != undefined? item.errormsg: item.label+" is required.";
									return false;
								}  
							}
						}else{
							errorMessage = item.errormsg != undefined? item.errormsg: item.label+" is required.";
							return false;
						}
					} else {
						var valueVal = fieldValuesWrapper[index].get("v.value");
						if(valueVal != '' && valueVal != null && valueVal != "--None--" && valueVal != "--none--" && valueVal.toString().trim() != undefined && valueVal.toString().trim() != ""){
							return true;
						} else {
							errorMessage = item.errormsg != undefined? item.errormsg: item.label+" is required.";
							return false;
						}  
					}
				} else {
					if(item.regex != undefined && item.regex != null && item.regex != ""){
						var valueVal = fieldValuesWrapper[index].get("v.value");
						if(valueVal != '' && valueVal != null && valueVal != "--None--" && valueVal != "--none--" && valueVal.toString().trim() != undefined && valueVal.toString().trim() != ""){
							if(item.Regex_Validation__c == "Date-Validation"){
								var valueVal = fieldValuesWrapper[index].get("v.value");
								var today = new Date();
								var compareDate = today.getFullYear()+'-'+(today.getMonth().length>1?(today.getMonth()+1):'0'+(today.getMonth()+1))+'-'+today.getDate();
								compareDate = new Date(compareDate);
								var enteredDate = new Date(valueVal);
								if(enteredDate < compareDate){
									return true;
								}else{
									errorMessage = item.errormsg != undefined? item.errormsg: "Date is required and it should be prior to today's date";
									return false;
								}
							} else if(item.regex == "minimum-value"){
                                var valueVal = fieldValuesWrapper[index].get("v.value");
                                var minValue = parseInt(item.minValue);
                                if(valueVal >= minValue){
                                    return true;
                                }else{
                                    errorMessage = item.errormsg != undefined? item.errormsg: item.Name+" error";
                                    return false;
                                }
                            } else {
								var regexExp = new RegExp(item.regex);
								var valueVal = fieldValuesWrapper[index].get("v.value");
								if(regexExp.test(valueVal)){
									return true;
								}else{
									errorMessage = item.errormsg != undefined? item.errormsg: item.label+" is required.";
									return false;
								}  
							}
						} else {
							return true;
						}
					} else {
						return true;
					}
				}   
			}else{
				return true;
			}
		});
		if(validateFlagCheck){
			if(component.get("v.editForm")){
				if(component.find("editFormDetails").length!=undefined){
					component.find("editFormDetails")[blockID].submit();
				}else{
					component.find("editFormDetails").submit();
				}
			}else{
				component.find("editForm").submit();
			}
			
		} else {
			var toastEvent = $A.get("e.force:showToast");
			toastEvent.setParams({
				"title": "ERROR!",
				"message": errorMessage,
				"type": "error"
			});
			toastEvent.fire();
			event.preventDefault();
		}
	}
})