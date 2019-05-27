({
    fetchDataFromServer : function(component, event, helper){
        var licenseType = component.get("v.licenseType");        
        var board = component.get("v.board");
        var applicationType = component.get("v.applicationType");
        var flowType = component.get("v.flowType");
        
        var action = component.get("c.fetchRenewalData");
        action.setParams({
            "appId": component.get("v.applicationId"),
            "renewReinstate": component.get("v.RenewReinstate"),
            "board": board, 
            "licenseType": licenseType, 
            "applicationType": applicationType,
            "flowType": flowType 
        });
        action.setCallback(this, function(actionResult){
            var state = actionResult.getState();
            if (state === "SUCCESS"){
                var result = actionResult.getReturnValue();
                var resultWrapper = JSON.parse(result);
                component.set("v.licenseWrapper",resultWrapper);
                var sectionList = [];
                for (var index = 0; index < resultWrapper.length; index++){
                    var obj = new Object();
                    obj.header = resultWrapper[index].sectionName;
                    obj.icon = resultWrapper[index].icon;
                    obj.subheader = resultWrapper[index].subheader;
                    sectionList.push(obj);
                }
                component.set("v.section",sectionList);
                console.log("resultWrapper", JSON.stringify(component.get("v.licenseWrapper")));
                component.set("v.totalTabs", sectionList.length);
                this.hideSpinner(component, event);
            }else{
                window.location.href = "./error";
            }
        });
        $A.enqueueAction(action);
    },
    setApplicationType : function(component, event, helper) {
        var licenseType = sessionStorage.getItem("licenseType");
        var applicationType = sessionStorage.getItem("applicationType");
        var board = sessionStorage.getItem("board");
        var applicationId = sessionStorage.getItem("applicationId");
        var recordID =  sessionStorage.getItem("accountRecordID");
        var flowType = sessionStorage.getItem("flowType");
        var RenewReinstate= sessionStorage.getItem("renewalReinstate");
        var licID = sessionStorage.getItem("licId");
        var objectName = "";
        if(applicationId!=null){
            //set licenseType, etc -> coming from dashboard
        }else{
            if(licenseType==null||applicationType==null||board==null){
                window.location.href = "./error";
            }
        }
        component.set("v.RenewReinstate",RenewReinstate);
        component.set("v.licenseType", licenseType);
        component.set("v.board", board);
        component.set("v.applicationType", applicationType);
        component.set("v.applicationId", applicationId);
        component.set("v.licID",licID);
        component.set("v.flowType", flowType);
        if((recordID !='' && recordID != null) || recordID != null ){
            recordID = recordID;
            objectName = "Account";
        } 
        component.set("v.recordId",recordID);
        component.set("v.objectName",objectName);
        sessionStorage.clear();
    },
    goToPreviousTab : function(component, event, helper) {
        component.set("v.AttFlagForsubmit","false");
        var tabNumber = component.get("v.currentTab");
        component.set("v.currentTab", tabNumber-1);
    },
    goToNextTab : function(component, event, helper) {
        var curTab= component.get("v.currentTab");		
        var tabNumber = component.get("v.currentTab");
        var totalTabNumber = component.get("v.totalTabs");
        component.set("v.submitButtonDisable", "true");  
        component.set("v.currentTab", tabNumber+1);
        tabNumber++;
        var action = component.get("c.insertApplication");
        action.setParams({"dataString" : JSON.stringify(component.get("v.licenseWrapper")), "tabNumber" : component.get("v.currentTab"), "appId" : component.get("v.applicationId"),"Board": component.get("v.board"), "LicenseType": component.get("v.licenseType"),  "ApplicationType": component.get("v.applicationType")});
      	var serverActionStatus = false;
        this.showSpinner(component, event);
        action.setCallback(this, function(actionResult){
            var state = actionResult.getState();
            if (state === "SUCCESS"){
                serverActionStatus = true;
                var result = actionResult.getReturnValue();
                var resultWrapper = JSON.parse(result);
                component.set("v.licenseWrapper",resultWrapper);
                if(totalTabNumber ==tabNumber){
                    var resultObject = component.get("v.licenseWrapper");
                    var newlst =[];
                    Object.keys(resultObject).forEach(function(key) {
                        console.log(key, resultObject[key]);
                        if(resultObject[key].sectionError){
                            newlst.push(resultObject[key].sectionName);
                        }
                    });
                    if(newlst.length==0){
                        component.set("v.AttFlagForsubmit","true");
                    }
                    component.set("v.SectionError",newlst);
                    
                }
                var sectionList = [];
                for (var index = 0; index < resultWrapper.length; index++){
                    var obj = new Object();
                    obj.header = resultWrapper[index].sectionName;
                    obj.errorImage=resultWrapper[index].sectionError;;
                    obj.icon = resultWrapper[index].icon;
                    obj.subheader = resultWrapper[index].subheader;
                    //obj.sectionNumber = resultWrapper[index].currentTab;
                    sectionList.push(obj);
                }
                component.set("v.section",sectionList);
                console.log('licenseWrapper ' + JSON.stringify(component.get("v.licenseWrapper")));
                component.set("v.totalTabs", sectionList.length);
                this.hideSpinner(component, event);
               // helper.showDependentQuestionsOnPageLoadHelper(component, event, helper);
            } else {
                //handle error as well
                console.log('error on insert application');
            }
        });
        $A.enqueueAction(action);
        //Added to save the personal imformation
        if(component.find("recordObjectForm") != null){
         component.find("recordObjectForm").find("editForm").submit();   
        }
	   var tabsList = component.get("v.licenseWrapper");
        console.log('tabsList '+tabsList);
	   var a = [];
       var attRes = [];
       var certArray =[]; 
	   for (var key in tabsList) {
			if (tabsList.hasOwnProperty(key)) {
				if(tabsList[key].sectionName =='License Information'){
					for (var question in tabsList[key].labelFieldsMap){
                        if(tabsList[key].labelFieldsMap[question].renderedOnUi == true){
                            a.push({"question": tabsList[key].labelFieldsMap[question].label, "answer":tabsList[key].labelFieldsMap[question].value});
                        }						
					}
				}
                else if(tabsList[key].sectionName =='Attachments'){
                    for (var att in tabsList[key].labelFieldsMap){
                        var fileNos = tabsList[key].labelFieldsMap[att].multiValues.length;
                        attRes.push({"attachment": tabsList[key].labelFieldsMap[att].label, "genericSub":tabsList[key].labelFieldsMap[att].isGenericSub, "uploadOrAck":tabsList[key].labelFieldsMap[att].uploadFile, "fileNos": fileNos, "acknowledgeResponse":tabsList[key].labelFieldsMap[att].acknowledgeResponse, "isMandatorySub":tabsList[key].labelFieldsMap[att].isMandatorySub});
					}
                }
			}
		}
	   component.set('v.questionsAnswers',a);
       component.set('v.attachmentResponse',attRes);
       window.scrollTo({ top: 0, behavior: 'smooth' });
    },
    submit : function(component, event, helper) {
       // var enteredAttestText = component.get("v.attestValue");
       // var userName = component.get("v.currentUser.Name");
       // if(enteredAttestText==userName)
        //debugger;
        this.checkboxValidation(component, event);
        if(component.get("v.attestationStatus") == true && component.get("v.certificateValues") == true && component.get("v.AttFlagForsubmit") == "true")
        {         
            
            var action = component.get("c.callCompositeAPI");
            action.setParams({
                "applicationId" : component.get("v.applicationId"),
                "renewReinstate": component.get("v.RenewReinstate")
                //"licID" : component.get("v.licID")
            });
            this.showSpinner(component, event);
            //helper.AttestVal(component, event, helper);
            action.setCallback(this, function(actionResult){
                var state = actionResult.getState();
                if (state === "SUCCESS"){
                    var result = actionResult.getReturnValue();
                    this.hideSpinner(component, event);
                    // Set popup property values before displayiong pop up.
                    component.set("v.popupHeader", "Successfully Submitted");
                    component.set("v.popupBody", "Thank you for submission of your application.");
                    component.set("v.serverStatus", "success"); 
                    component.set("v.storeServerValue", result);
                    component.set("v.isOpen", true);
                }else{
                    console.log("Submit Error->"+error);
                    //handle error as well
                }
                
            });
            $A.enqueueAction(action);
        
        window.scrollTo({ top: 0, behavior: 'smooth' });
            }
    },

    showDependentQuestionsHelper : function(component, event, helper){
        var response = event.getSource().get("v.value").trim();
        var questionNumber = event.getSource().get("v.name");
        var tabsList = component.get("v.licenseWrapper");
        var currentTab = component.get("v.currentTab");
        var hasChildQuestion = tabsList[currentTab-1].labelFieldsMap[questionNumber].hasChild;
        var questionNumberId = tabsList[currentTab-1].labelFieldsMap[questionNumber].labelId;
        var childQuestionsArray = [];
        if(hasChildQuestion){
            for(var index=0; index<tabsList[currentTab-1].labelFieldsMap.length ; index++){
                if(tabsList[currentTab-1].labelFieldsMap[index].parentQuestionId == questionNumberId){
                    childQuestionsArray.push(index);
                } 
            }
            if(childQuestionsArray.length>0){
                for(var i=0; i<childQuestionsArray.length; i++){
                    var mapIndex = childQuestionsArray[i];
                    if(tabsList[currentTab-1].labelFieldsMap[mapIndex].conditionalAnswer == response){
                        tabsList[currentTab-1].labelFieldsMap[mapIndex].renderedOnUi=true;
                    } else {
                        for(var j=0; j<tabsList[currentTab-1].labelFieldsMap.length ; j++){
                            if(tabsList[currentTab-1].labelFieldsMap[j].parentQuestionId == questionNumberId){
                                if(tabsList[currentTab-1].labelFieldsMap[j].conditionalAnswer == response){
                                    tabsList[currentTab-1].labelFieldsMap[j].renderedOnUi=true;                       
                                }else{
                                    if(tabsList[currentTab-1].labelFieldsMap[j].hasChild){
                                        questionNumberId = tabsList[currentTab-1].labelFieldsMap[j].labelId;
                                        tabsList[currentTab-1].labelFieldsMap[j].value = '';
                                        tabsList[currentTab-1].labelFieldsMap[j].renderedOnUi=false;    
                                    } else {
                                        tabsList[currentTab-1].labelFieldsMap[j].value = '';
                                    	tabsList[currentTab-1].labelFieldsMap[j].renderedOnUi=false;
                                    }                                             
                                }
                            }
                        }
                    } 
                }
            }
        }
        //console.log("")
        component.set("v.licenseWrapper",tabsList);
    },
    showSpinner: function(component, event){
        console.log('show spinner');
        //var spinner = component.find('spinner');
        //$A.util.removeClass(spinner, 'slds-hide');
        component.set("v.loadingSpinner", true); 
    },
    hideSpinner: function(component, event){
        console.log('hide spinner');
        //var spinner = component.find('spinner');
        //$A.util.addClass(spinner, 'slds-hide');
        component.set("v.loadingSpinner", false); 
    },
    getCurrTabHelper : function(component, event, helper){
        var currTab = event.getParam("currTab");
    	component.set("v.currentTab", currTab);
    },
    showDependentQuestionsOnPageLoadHelper : function(component, event, helper){
        var tabsList = component.get("v.licenseWrapper");
        var currentTab = component.get("v.currentTab");
        var childQuestionId, parentQuestionId,expectedResponse, isChild;
        for(var index=0; index<tabsList[currentTab-1].labelFieldsMap.length ; index++){
            isChild = tabsList[currentTab-1].labelFieldsMap[index].isChild;
            if(isChild == true){
                parentQuestionId = tabsList[currentTab-1].labelFieldsMap[index].parentQuestionId;
                expectedResponse = tabsList[currentTab-1].labelFieldsMap[index].conditionalAnswer;
                for(var i=0; i<tabsList[currentTab-1].labelFieldsMap.length ; i++){
                    if(tabsList[currentTab-1].labelFieldsMap[i].labelId == parentQuestionId &&tabsList[currentTab-1].labelFieldsMap[i].value == expectedResponse ){
                        childQuestionId = document.getElementById('q'+index);
                        if(childQuestionId !=null){
                           childQuestionId.classList.remove('slds-hide'); 
                        }
                        
                    }
                }
            }
        }
    },
    //Close the modal popup and redirect to cart page
    closeModel: function(component, event) {
		component.set("v.isOpen", false);
        var id = component.get("v.storeServerValue");
        var action = component.get("c.getTotalBalance");
        action.setParams({"licId" : id });
        action.setCallback(this, function(actionResult){
            var state = actionResult.getState();
            if (state === "SUCCESS"){
                var noFees = actionResult.getReturnValue();
                if(noFees){
                    window.location.href=$A.get("$Label.c.Polaris_Portal_URL")+'s/dashboard';
                }else{
                    window.location.href= $A.get("$Label.c.Polaris_Portal_URL")+'cart?id='+id;        
                }
                
            }
            
        });
        $A.enqueueAction(action);
	},
    onCheckboxChange: function(component, event){
        this.toEnableSubmitButtonCheck(component, event);
        if(component.get("v.attestationStatus") == true && component.get("v.certificateValues") == true && component.get("v.AttFlagForsubmit") == "true"){
            component.set("v.submitButtonDisable", "false");
        }
        else {
            component.set("v.submitButtonDisable", "true");
        }
    },
    onAttestationChange: function(component, event, helper) {
		this.toEnableSubmitButtonCheck(component, event);
        if(component.get("v.attestationStatus") == true && component.get("v.certificateValues") == true && component.get("v.AttFlagForsubmit") == "true"){
            component.set("v.submitButtonDisable", "false");
        }
        else {
            component.set("v.submitButtonDisable", "true");
        }
	},
    toEnableSubmitButtonCheck: function(component, event, helper) {
		var totalCheckbox = document.getElementsByClassName("certificate-checkbox");
        var counter = 0;
        for(var i=0; i < totalCheckbox.length; i++ ){
            if(document.getElementById('cert'+i).checked === true){
                counter = counter + 1;
            }
        }        
        if(totalCheckbox.length == counter) {
            component.set("v.certificateValues", true);
            //component.set("v.certificateError", "");
        } else {
            component.set("v.certificateValues", false);
            //component.set("v.certificateError", "All checkbox's must be checked.");
        }
		var attestedName = component.get("v.currentUser").Name.trim().toLowerCase();
        var givenName = component.get("v.attestValue").trim().toLowerCase();
        if(attestedName == givenName){
            component.set("v.attestationStatus", true);
            //component.set("v.attestationError", "");
        } else {
            component.set("v.attestationStatus", false);
            //component.set("v.attestationError", "Name should be same.");
        }        
    },
    checkboxValidation: function(component, event){
        var totalCheckbox = document.getElementsByClassName("certificate-checkbox");
        var counter = 0;
        for(var i=0; i < totalCheckbox.length; i++ ){
            if(document.getElementById('cert'+i).checked === true){
                counter = counter + 1;
            }
        }        
        if(totalCheckbox.length == counter) {
            component.set("v.certificateValues", true);
            component.set("v.certificateError", "");
        } else {
            component.set("v.certificateError", "All checkbox's must be checked.");
        }
        var attestedName = component.get("v.currentUser").Name.trim().toLowerCase();
        var givenName = component.get("v.attestValue").trim().toLowerCase();
        if(attestedName == givenName){
            component.set("v.attestationStatus", true);
            component.set("v.attestationError", "");
        } else {
            component.set("v.attestationError", "Name should be same.");
        }
    }
})