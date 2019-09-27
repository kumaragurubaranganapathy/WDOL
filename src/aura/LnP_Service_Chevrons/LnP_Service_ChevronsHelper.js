({
    fetchDataFromServer : function(component, event, helper){
        console.log('fetchData');
        var licenseType = component.get("v.licenseType");
        var businessLicenseType =$A.get("$Label.c.Business_Licenses");        
        var businsessLicenseArray = businessLicenseType.split(',');
        var isbusinsessLicense = businsessLicenseArray.includes(licenseType);        
        component.set('v.isbusinsessLicense',isbusinsessLicense);
        var board = component.get("v.board");
        var applicationType = component.get("v.applicationType");
        var flowType = component.get("v.flowType");
        var action = component.get("c.fetchData");
        action.setParams({
            "requestId": component.get("v.applicationId"),
            "board": board, 
            "licenseType": licenseType, 
            "requestType": applicationType,
            "flowType": flowType,
            "licID":component.get("v.recordId")
        });
        action.setCallback(this, function(actionResult){
            var state = actionResult.getState();
            console.log("inside fetchData"+ state);
            if (state === "SUCCESS"){
                var result = actionResult.getReturnValue();
                var resultWrapper = JSON.parse(result);
                component.set("v.licenseWrapper",resultWrapper);
                console.log("wrapper::"+JSON.stringify(resultWrapper));
                
                var sectionList = [];
                for (var index = 0; index < resultWrapper.length; index++){
                    var obj = new Object();
                    obj.header = resultWrapper[index].sectionName;
                    obj.icon = resultWrapper[index].icon;
                    obj.subheader = resultWrapper[index].subheader;
                    component.set("v.AMRlabel",resultWrapper[index].AMRlabel);
                    sectionList.push(obj);
                }
                component.set("v.section",sectionList);
                console.log("resultWrapper", JSON.stringify(component.get("v.licenseWrapper")));
                component.set("v.totalTabs", sectionList.length);
                this.hideSpinner(component, event);
                this.getAMRMetadata(component,event,helper);
                this.showWarningMessage(component,event,helper)
            }else{
                //  window.location.href = "./error";
                console.log("error" +  state);
            }
        });
        $A.enqueueAction(action);
    },
    setApplicationType : function(component, event, helper) {
        console.log('Set');
        var licenseType = sessionStorage.getItem("licenseType");
        var applicationType = sessionStorage.getItem("applicationType");
        var board = sessionStorage.getItem("board");
        var applicationId = sessionStorage.getItem("requestId");
        //var recordID =  sessionStorage.getItem("accountRecordID");
        var flowType = sessionStorage.getItem("ServiceRequestType");
        var recordId = sessionStorage.getItem("recordId");
        var accountRecordId = sessionStorage.getItem("accountRecordID");
        var taskDescription  = sessionStorage.getItem("taskDescription");
        var contactRecordId = sessionStorage.getItem("contactRecordId");        
        var objectName = "";
        /* if(applicationId!=null){
            //set licenseType, etc -> coming from dashboard
        }else{
            if(licenseType==null||applicationType==null||board==null){
                window.location.href = "./error";
            }
        }*/
        if(accountRecordId!=null)
        {
            component.set("v.objectName",'Account');
        }
        component.set("v.taskDescription", taskDescription);
        component.set("v.licenseType", licenseType);
        component.set("v.board", board);
        component.set("v.applicationType", applicationType);
        component.set("v.applicationId", applicationId);
        component.set("v.flowType", flowType);
        component.set("v.recordId", recordId);
        component.set("v.accountRecordId", accountRecordId);
        component.set("v.contactRecordId", contactRecordId);
        sessionStorage.clear();
    },
    
    getAMRMetadata : function(component,event,helper){
        console.log("inside amr::");
        var action = component.get("c.getMetadata");
        action.setParams({"board" : component.get("v.board"),
                          "ServiceRequestType" :  component.get("v.flowType"),
                          "licenseType" :  component.get("v.licenseType")})
        action.setCallback(this, function(actionResult){
            var state = actionResult.getState();
            console.log("state::"+state);
            if (state === "SUCCESS"){
                var result = actionResult.getReturnValue();
                console.log("AMR::"+JSON.stringify(result));
                component.set("v.amrData",result);                
                component.set("v.feesRequired",result.Generate_Fee__c);
            }else{
                console.log("Error");
            }
            
        });
        $A.enqueueAction(action);
    },
    
    goToPreviousTab : function(component, event, helper) {
        component.set("v.AttFlagForsubmit","false");
        var tabNumber = component.get("v.currentTab");
        component.set("v.currentTab", tabNumber-1);
        component.set("v.certificateError", "");
        component.set("v.attestationError", "");
    },
    goToNextTab : function(component, event, helper) {
        this.checkFieldValidations(component, event);
        if(component.get("v.nextFlag")==true){
            component.set("v.isSSNchanged", false);
            //component.set("v.showEndoMessage",false);
            component.set("v.errorMsgsList", []);
            component.set("v.showErrorMsgs", false); 
        var curTab= component.get("v.currentTab");		
        var tabNumber = component.get("v.currentTab");
        var totalTabNumber = component.get("v.totalTabs");
        component.set("v.submitButtonDisable", "true"); 
        component.set("v.currentTab", tabNumber+1);
        tabNumber++;
        var action = component.get("c.insertApplication");
        action.setParams({"dataString" : JSON.stringify(component.get("v.licenseWrapper")),
                          "tabNumber" : component.get("v.currentTab"), 
                          "appId" : component.get("v.applicationId"),
                          "Board": component.get("v.board"), 
                          "LicenseType": component.get("v.licenseType"),  
                          "ApplicationType": component.get("v.applicationType")});
        var serverActionStatus = false;
        this.showSpinner(component, event);
        action.setCallback(this, function(actionResult){
            var state = actionResult.getState();
            if (state === "SUCCESS"){
                serverActionStatus = true;
                var result = actionResult.getReturnValue();
                if(result!=null){
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
                }
                else{
                    console.log('error on insert application');
                     this.errorlog(component,event);
                }
                } 
                else {
                //handle error as well
                       console.log('error on insert application');
                       this.errorlog(component,event);
            }
        });
        $A.enqueueAction(action);
        //Added to save the personal imformation
        
        if(component.find("recordObjectForm") != null && component.find("recordObjectForm").find("editForm") != null){
            component.find("recordObjectForm").find("editForm").submit();            
        }
        if(component.find("recordObjectForm") != null && component.find("recordObjectForm").find("createAccountForm") != null){
            //var fields = event.getParam("fields");
            component.find("recordObjectForm").find("createAccountForm").submit();            
        }
        var tabsList = component.get("v.licenseWrapper");
        console.log('tabsList '+tabsList);
        var a = [];
        var attRes = [];
        for (var key in tabsList) {
            if (tabsList.hasOwnProperty(key)) {
                if(tabsList[key].sectionName =='License Information' || tabsList[key].sectionName =='Request Information'  ){
                    for (var question in tabsList[key].labelFieldsMap){
                        if(tabsList[key].labelFieldsMap[question].renderedOnUi == true){
                            a.push({"question": tabsList[key].labelFieldsMap[question].label, "answer":tabsList[key].labelFieldsMap[question].value, "fieldType":tabsList[key].labelFieldsMap[question].fieldType}); 
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
        }
    },
	submit : function(component, event, helper) {
        // var enteredAttestText = component.get("v.attestValue");
        // var userName = component.get("v.currentUser.Name");
        // if(enteredAttestText==userName)
        this.checkboxValidation(component, event);
        var noFees;
            var action = component.get("c.callCompositeAPI");
            action.setParams({"applicationId" : component.get("v.applicationId"),
                              "description" : component.get("v.Description")});
            this.showSpinner(component, event);
            //helper.AttestVal(component, event, helper);
            action.setCallback(this, function(actionResult){
                var state = actionResult.getState();
                if (state === "SUCCESS"){
                    var result = actionResult.getReturnValue();
                    if(result!=null){
                    
                    component.set("v.storeServerValue", result[0].Id);
					//component.set("v.serverStatus", "success");                     
                    try{
                            return new Promise($A.getCallback(function(resolve) {
                                var action = component.get("c.getTotalBalance");
                                action.setParams({"reqId" : result[0].Id });
                                action.setCallback(this, function(actionResult){
                                    var state = actionResult.getState();
                                    if (state === "SUCCESS"){
                                        console.log("state::"+state);
                                        noFees = actionResult.getReturnValue();
                                        resolve(actionResult.getReturnValue());
                                        console.log("state::"+state);
                                    }
                                    
                                });
                                $A.enqueueAction(action);
                            })).then(
                                $A.getCallback(function(){ 
                                    var str = '';
                                    component.set("v.loadingSpinner", false);
                                    if(noFees){
                                        
                                        // below code is for no fees case
                                       // this.hideSpinner(component,event);
                                        component.set("v.popupHeader", "Successfully Submitted");
                                        component.set("v.popupBody", "Thank you for submission of the request.");
                                        component.set("v.serverStatus", "success"); 
                                        //component.set("v.storeServerValue", result[0].Id);
                                        component.set("v.isOpen", true); 
                                        var isBLic = component.get("v.isbusinsessLicense");
                                        sessionStorage.setItem('isBuz',isBLic);
                                        // no fees code ends
                                    }else{ 
                                       // this.hideSpinner(component,event);
                                        var isBizLic = component.get("v.isbusinsessLicense");
                                        var isBLic = component.get("v.isbusinsessLicense");
                                        console.log('***************'+isBizLic);
                                        sessionStorage.setItem('isBuz',isBLic);
                                        var str ='/cart?id='+result[0].Id+'&isBLic='+isBizLic;
                                        var urlEvent = $A.get("e.force:navigateToURL");
                                        urlEvent.setParams({
                                            "url": str
                                        });
                                        urlEvent.fire();
                                        //window.location.href = $A.get("$Label.c.Polaris_Portal_URL")+'cart?id='+id;
                                    } 
                                }));
                        }    
                        catch(e){
                            console.error('Error Stack Message for showQuestionHelper Helper' + e.stack);	
                        }
                    }
                    else{
                        console.log("Submit Error->"+error);
                    
                       this.errorlog(component,event);
                    }
                    
                }else{
                    console.log("Submit Error->"+error);
                    
                      this.errorlog(component,event);
                    //handle error as well
                }
                
            });
            $A.enqueueAction(action);
            
            window.scrollTo({ top: 0, behavior: 'smooth' });
        
    },
    errorlog:function(component,event){
        var url=$A.get("$Label.c.Polaris_Portal_Home")+'explorer-error-page';
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url": url
        });
        urlEvent.fire();
    },
    showWarningMessage: function(component, event, helper){
        var tabsList = component.get("v.licenseWrapper");
        var currentTab = component.get("v.currentTab");
        if(tabsList[currentTab-1].labelFieldsMap[0].warningMessages != null)
        {            
            component.set("v.showWarningMessage",true);
            component.set("v.warningMessage",tabsList[currentTab-1].labelFieldsMap[0].warningMessages);            
        }
    },
    showDependentQuestionsHelper : function(component, event, helper){        
        component.set("v.showEndoMessage",false);
        component.set("v.showNotaryEndo",false);
        component.set("v.showOwnerInfo",false);
        var response = event.getSource().get("v.value").trim();
        //alert(response);
        var questionNumber = '';
        if(event.getSource().get("v.name").includes('License Information'))
        {
            questionNumber = event.getSource().get("v.name").split('License Information')[1];
        }
        else if(event.getSource().get("v.name").includes('Request Information'))
        {
            questionNumber = event.getSource().get("v.name").split('Request Information')[1];
        }
            else 
            {          
                questionNumber = event.getSource().get("v.name").split('Endorsement')[1];
            }
        
        if(component.get("v.flowType")=='Update Owners' && response=='Replace DCP')
        {
            component.set("v.showOwnerInfo",true);
        }
        var tabsList = component.get("v.licenseWrapper");
        var currentTab = component.get("v.currentTab");
        //alert('trigger : '+tabsList[currentTab-1].labelFieldsMap[questionNumber].messageTriggerResponse);
        //alert('message : '+tabsList[currentTab-1].labelFieldsMap[questionNumber].message);
        if(component.get("v.licenseType")=='Notary Public' && tabsList[currentTab-1].labelFieldsMap[questionNumber].messageTriggerResponse == response)
        {
            component.set("v.showNotaryEndo",true);
        }
        if(tabsList[currentTab-1].labelFieldsMap[questionNumber].messageTriggerResponse == response && component.get("v.licenseType")!='Notary Public')
        {            
            component.set("v.showEndoMessage",true);
            component.set("v.endoMessage",tabsList[currentTab-1].labelFieldsMap[questionNumber].message);            
        }
        
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
        var amr = component.get("v.amrData");
        console.log('id',id);
        if(component.get("v.serverStatus") == "success"){
            window.setTimeout(
                $A.getCallback(function() {
                    if(amr.Generate_Fee__c ){
                        sessionStorage.setItem('isBuz', component.get("v.isbusinsessLicense"));
                        window.location.href= $A.get("$Label.c.Polaris_Portal_URL")+'cart?id='+id+'&isBLic='+component.get("v.isbusinsessLicense");
                    }else{                        
                        sessionStorage.setItem('isBuz', component.get("v.isbusinsessLicense"));
                        document.location = $A.get("$Label.c.Polaris_Portal_URL")+"s/user-feedback";
                    }
                    
                }), 2000);
        }
    },
    certificateCheckbox: function(component, event){
        //var selectedValue = event.getSource().get("v.checked");
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
		var a = component.get('c.onCheckboxChange');
        $A.enqueueAction(a); 
        var attestedName = component.get("v.currentUser").Name.trim().toLowerCase();
        var givenName = component.get("v.attestValue").trim().toLowerCase();
        if(attestedName == givenName){
            component.set("v.attestationStatus", true);
            component.set("v.attestationError", "");
        } else {
            component.set("v.attestationStatus", false);
            component.set("v.attestationError", "Entered name should be same as name below the box.");
        }
        if(component.get("v.attestationStatus") == true && component.get("v.certificateValues") == true && component.get("v.AttFlagForsubmit") == "true"){
            component.set("v.submitButtonDisable", "false");
        }
        else {
            component.set("v.submitButtonDisable", "true");
        }
        if(component.get("v.attestationStatus") == true)
        {
            component.set("v.submitButtonDisable", "false");
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
        /*var attestedName = component.get("v.currentUser").Name.trim().toLowerCase();
        var givenName = component.get("v.attestValue").trim().toLowerCase();
        if(attestedName == givenName){
            component.set("v.attestationStatus", true);
            //component.set("v.attestationError", "");
        } else {
            component.set("v.attestationStatus", false);
            //component.set("v.attestationError", "Name should be same.");
        }   */     
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
    },
    
    checkFieldValidations : function(component, event){
        var licenseWrapper = component.get("v.licenseWrapper");
        var tabNumber = component.get("v.currentTab") - 1;
        var valueVal;
        
        if(licenseWrapper[tabNumber].subheader == 'Personal Information' || licenseWrapper[tabNumber].subheader == 'Business Information' || licenseWrapper[tabNumber].subheader == 'Course Information') {
            var fieldsWrapper = JSON.parse(licenseWrapper[tabNumber].fieldJson);
            var validateFields = fieldsWrapper.filter(function(item){
                return  item.Required__c == true || (item.Regex_Validation__c != undefined && item.Regex_Validation__c != "");
            });   
            //console.log('validatingFields'+ component.find("recordObjectForm").find("validateField"));
            var fieldValuesWrapper = (component.find("recordObjectForm")!=undefined && component.find("recordObjectForm").length!=undefined)?component.find("recordObjectForm")[0].find("validateField"):component.find("recordObjectForm").find("validateField");                 
            var errorMessage = "Please fill valid data";
            var errorMsgsArray = [];
            var PatternAndFlagCheck = validateFields.filter(function(item, index) {
                if(!$A.util.hasClass(fieldValuesWrapper[index], "slds-hide")){
                    if(item.Required__c){
                        if(item.Regex_Validation__c != undefined && item.Regex_Validation__c != ""){
                            valueVal = fieldValuesWrapper[index].get("v.value");
                            if(valueVal != '' && valueVal != null && valueVal != "--None--" && valueVal != "--none--" && valueVal != "--Select one--" && valueVal != "--Select One--" && valueVal.toString()!= undefined && valueVal.toString().trim() != undefined && valueVal.toString().trim() != ""){
                                if(item.Regex_Validation__c == "Date-Validation"){
                                    valueVal = fieldValuesWrapper[index].get("v.value");
                                    var today = new Date();
                                    var compareDate = today.getFullYear()+'-'+(today.getMonth().length>1?(today.getMonth()+1):'0'+(today.getMonth()+1))+'-'+today.getDate();
                                    compareDate = new Date(compareDate);
                                    var enteredDate = new Date(valueVal);
                                    if(enteredDate < compareDate){
                                        return true;
                                    }else{
                                        errorMessage = item.Error_Message__c != undefined? item.Error_Message__c: item.Name+" error";
                                        errorMsgsArray.push(errorMessage);
                                        return false;
                                    }
                                }else if(item.Regex_Validation__c == "ssn-validation"){
                                    valueVal = fieldValuesWrapper[index].get("v.value");
                                    var regexExp = new RegExp('^[0-9]{9}$');
                                    var ssn = component.get("v.isSSNchanged");
                                    if(!ssn){
                                        return true;
                                    }else{
                                        if(valueVal.charAt(0) == "9"){
                                            if(valueVal.charAt(3) == "9" || valueVal.charAt(3) == "7"){
                                                if(valueVal.slice(0,3)!= "000" && regexExp.test(valueVal)){
                                                    return true;
                                                }else{
                                                    errorMessage = item.Error_Message__c != undefined? item.Error_Message__c: item.Name+" error";
                                                    errorMsgsArray.push(errorMessage);
                                                    return false;
                                                }
                                            }else{
                                                errorMessage = item.Error_Message__c != undefined? item.Error_Message__c: item.Name+" error";
                                                errorMsgsArray.push(errorMessage);
                                                return false;
                                            }
                                        }else{
                                            if(valueVal.slice(0,3)!= "000" && regexExp.test(valueVal)){
                                                return true;
                                            }else{
                                                errorMessage = item.Error_Message__c != undefined? item.Error_Message__c: item.Name+" error";
                                                errorMsgsArray.push(errorMessage);
                                                return false;
                                            }
                                        }
                                    }
                                } else if(item.Regex_Validation__c == "itin-validation"){
                                    valueVal = fieldValuesWrapper[index].get("v.value");
                                    var regexExp = new RegExp('^[0-9]{3}\-[0-9]{2}\-[0-9]{4}$');
                                    if(valueVal!="111-11-1111" && valueVal!="333-33-3333" && valueVal!="666-66-6666" && valueVal!="123-45-6789" && valueVal.charAt(0) == "9" && regexExp.test(valueVal)){
                                        if(valueVal.slice(0,3)!= "000" && valueVal.slice(0,3)!= "666" && valueVal.slice(4, 6) != "00" && valueVal.slice(7, 11) != "0000"){
                                            return true;
                                        } else {
                                            errorMessage = item.Error_Message__c != undefined? item.Error_Message__c: item.Name+" error";
                                            errorMsgsArray.push(errorMessage);
                                            return false;
                                        }
                                    } else {
                                        errorMessage = item.Error_Message__c != undefined? item.Error_Message__c: item.Name+" error";
                                        errorMsgsArray.push(errorMessage);
                                        return false;
                                    }
                                } else {
                                    var regexExp = new RegExp(item.Regex_Validation__c);
                                    valueVal = fieldValuesWrapper[index].get("v.value");
                                    if(regexExp.test(valueVal)){
                                        return true;
                                    }else{
                                        errorMessage = item.Error_Message__c != undefined? item.Error_Message__c: item.Name+" error";
                                        errorMsgsArray.push(errorMessage);
                                        return false;
                                    }  
                                }
                            }else{
                                errorMessage = item.Error_Message__c != undefined? item.Error_Message__c: item.Name+" error";
                                errorMsgsArray.push(errorMessage);
                                return false;
                            }
                        } else {
                            //if(fieldValuesWrapper[index].get("v.value") !=)
                            valueVal = fieldValuesWrapper[index].get("v.value");
                            if(valueVal != '' && valueVal != null && valueVal != "--None--" && valueVal != "--none--" && valueVal != "--Select one--" && valueVal != "--Select One--" && valueVal.toString()!= undefined && valueVal.toString().trim() != undefined && valueVal.toString().trim() != ""){
                                return true;
                            } else {
                                errorMessage = item.Error_Message__c != undefined? item.Error_Message__c: item.Name+" error";
                                errorMsgsArray.push(errorMessage);
                                return false;
                            }  
                        }
                    } else {
                        if(item.Regex_Validation__c != undefined && item.Regex_Validation__c != ""){
                            valueVal = fieldValuesWrapper[index].get("v.value");
                            if(valueVal != "" && valueVal != null && valueVal != "--None--" && valueVal != "--none--" && valueVal != "--Select one--" && valueVal != "--Select One--" && valueVal.toString()!= undefined && valueVal.toString().trim() != undefined && valueVal.toString().trim() != ""){
                                if(item.Regex_Validation__c == "Date-Validation"){
                                    var valueVal = fieldValuesWrapper[index].get("v.value");
                                    var today = new Date();
                                    var compareDate = today.getFullYear()+'-'+(today.getMonth().length>1?(today.getMonth()+1):'0'+(today.getMonth()+1))+'-'+today.getDate();
                                    compareDate = new Date(compareDate);
                                    var enteredDate = new Date(valueVal);
                                    if(enteredDate < compareDate){
                                        return true;
                                    }else{
                                        errorMessage = item.Error_Message__c != undefined? item.Error_Message__c: item.Name+" error";
                                        errorMsgsArray.push(errorMessage);
                                        return false;
                                    }  
                                } else if(item.Regex_Validation__c == "ssn-validation"){
                                    var valueVal = fieldValuesWrapper[index].get("v.value");
                                    var regexExp = new RegExp('^[0-9]{9}$');
                                    var ssn = component.get("v.isSSNchanged");
                                    if(!ssn){
                                        return true;
                                    }else{
                                        if(valueVal.charAt(0) == "9"){
                                            if(valueVal.charAt(3) == "9" || valueVal.charAt(3) == "7"){
                                                if(valueVal.slice(0,3)!= "000" && regexExp.test(valueVal)){
                                                    return true;
                                                }else{
                                                    errorMessage = item.Error_Message__c != undefined? item.Error_Message__c: item.Name+" error";
                                                    errorMsgsArray.push(errorMessage);
                                                    return false;
                                                }
                                            }else{
                                                errorMessage = item.Error_Message__c != undefined? item.Error_Message__c: item.Name+" error";
                                                errorMsgsArray.push(errorMessage);
                                                return false;
                                            }
                                        }else{
                                            if(valueVal.slice(0,3)!= "000" && regexExp.test(valueVal)){
                                                return true;
                                            }else{
                                                errorMessage = item.Error_Message__c != undefined? item.Error_Message__c: item.Name+" error";
                                                errorMsgsArray.push(errorMessage);
                                                return false;
                                            }
                                        }
                                    }
                                } else if(item.Regex_Validation__c == "itin-validation"){
                                    valueVal = fieldValuesWrapper[index].get("v.value");
                                    var regexExp = new RegExp('^[0-9]{3}\-[0-9]{2}\-[0-9]{4}$');
                                    if(valueVal!="111-11-1111" && valueVal!="333-33-3333" && valueVal!="666-66-6666" && valueVal!="123-45-6789" && valueVal.charAt(0) == "9" && regexExp.test(valueVal)){
                                        if(valueVal.slice(0,3)!= "000" && valueVal.slice(0,3)!= "666" && valueVal.slice(4, 6) != "00" && valueVal.slice(7, 11) != "0000"){
                                            return true;
                                        } else {
                                            errorMessage = item.Error_Message__c != undefined? item.Error_Message__c: item.Name+" error";
                                            errorMsgsArray.push(errorMessage);
                                            return false;
                                        }
                                    } else {
                                        errorMessage = item.Error_Message__c != undefined? item.Error_Message__c: item.Name+" error";
                                        errorMsgsArray.push(errorMessage);
                                        return false;
                                    }
                                } else {
                                    var regexExp = new RegExp(item.Regex_Validation__c);
                                    valueVal = fieldValuesWrapper[index].get("v.value");
                                    if(regexExp.test(valueVal)){
                                        return true;
                                    }else{
                                        errorMessage = item.Error_Message__c != undefined? item.Error_Message__c: item.Name+" error";
                                        errorMsgsArray.push(errorMessage);
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
                } else {
                    return true;
                }  
            });
            if(errorMsgsArray.length==0){
                component.set("v.nextFlag", true);                    
            }
            else{
                component.set("v.nextFlag", false);
                component.set("v.errorMsgsList", errorMsgsArray);
                component.set("v.showErrorMsgs", true); 
                window.scrollTo({ top: 0, behavior: 'smooth' });
            }
        }
        else if(licenseWrapper[tabNumber].subheader == "License Information" || licenseWrapper[tabNumber].subheader == 'Questions' || licenseWrapper[tabNumber].subheader == 'Request Information'){
            var fieldsWrapper = licenseWrapper[tabNumber].labelFieldsMap;
            var validateFields = fieldsWrapper.filter(function(item){
                return  item.isMandatoryQues == true || (item.regex != undefined && item.regex != "");
            });                            
            var errorMessage = "Please fill valid data";
            var questionsFlagCheck = validateFields.every(function validateFields(item) {
                if(item.renderedOnUi){
                    if(item.isMandatoryQues){
                        if(item.regex != undefined && item.regex != ""){
                            if(item.regex == "Date-Validation"){
                                valueVal = item.value;
								var today = new Date();
								var compareDate = today.getFullYear()+'-'+(today.getMonth().length>1?(today.getMonth()+1):'0'+(today.getMonth()+1))+'-'+today.getDate();
								compareDate = new Date(compareDate);
                                var enteredDate = new Date(valueVal);
								if(enteredDate < compareDate){
									return true;
								}else{
									errorMessage = item.errormsg != undefined? item.errormsg: item.label+" is required.";
                                    return false;
								}
                            } else if(item.regex == "Future-Date"){
                                valueVal = item.value;
                                var enteredDate = new Date(valueVal);
                                var today = new Date();
                                var compareDate = today.getFullYear()+'-'+(today.getMonth().length>1?(today.getMonth()+1):'0'+(today.getMonth()+1))+'-'+today.getDate();
                                compareDate = new Date(compareDate);
                                if(enteredDate > today){
                                    return true;
                                }else{
                                    errorMessage = item.errormsg != undefined? item.errormsg: item.Name+" error";
                                    return false;
                                } 
                            } else if(item.regex == "minimum-value"){
                                valueVal = item.value;
                                var minValue = parseInt(item.minValue);
                                if(valueVal >= minValue){
                                    return true;
                                }else{
                                    errorMessage = item.errormsg != undefined? item.errormsg: item.Name+" error";
                                    return false;
                                }
                            } else {
                                var regexExp = new RegExp(item.regex);
                                valueVal = item.value;
                                if( item.multiValues.length > 0 || valueVal != '' && valueVal != null && valueVal != "--None--" && valueVal != "--none--" && valueVal != "--Select one--" && valueVal != "--Select One--" && valueVal.toString()!= undefined && valueVal.toString().trim() != undefined && valueVal.toString().trim() != "" && regexExp.test(valueVal)){
                                    return true;
                                }else{                                    
                                    errorMessage = item.errormsg != undefined? item.errormsg: item.label+" is required.";                                                                       
                                    return false;
                                }  
                            }
                        } else {
                            valueVal = item.value;
                            if( item.multiValues.length > 0 || valueVal != '' && valueVal != null && valueVal != "--None--" && valueVal != "--none--" && valueVal != "--Select one--" && valueVal != "--Select One--" && valueVal.toString()!= undefined && valueVal.toString().trim() != undefined && valueVal.toString().trim() != "" ){
                                return true;
                            } else {

                                    if(item.label=='Manager&#39;s Email:')
                                    {
                                        item.label = 'Managers Email:'
                                    }
                                errorMessage = item.errormsg != undefined? item.errormsg: item.label+" is required.";
                                return false;
                            }  
                        }
                    } else {
                        if(item.regex != undefined && item.regex != ""){
                            valueVal = item.value;
                            if( item.multiValues.length > 0 || valueVal != '' && valueVal != null && valueVal != "--None--" && valueVal != "--none--" && valueVal != "--Select one--" && valueVal != "--Select One--" && valueVal.toString()!= undefined && valueVal.toString().trim() != undefined && valueVal.toString().trim() != "" ){
                                if(item.regex == "Date-Validation"){
                                    var valueVal = item.value;
                                    var today = new Date();
                                    var compareDate = today.getFullYear()+'-'+(today.getMonth().length>1?(today.getMonth()+1):'0'+(today.getMonth()+1))+'-'+today.getDate();
                                    compareDate = new Date(compareDate);
                                    var enteredDate = new Date(valueVal);
                                    if(enteredDate < compareDate){
                                        return true;
                                    }else{
                                        errorMessage = item.errormsg != undefined? item.errormsg: item.label+" is required.";
                                        return false;
                                    }
                                } else if(item.regex == "Future-Date"){
                                    valueVal = item.value;
                                    var enteredDate = new Date(valueVal);
                                    var today = new Date();
                                    //var compareDate = today.getFullYear()+'-'+(today.getMonth().length>1?(today.getMonth()+1):'0'+(today.getMonth()+1))+'-'+today.getDate();
                                    //compareDate = new Date(compareDate);
                                    if(enteredDate > today){
                                        return true;
                                    }else{
                                        errorMessage = item.errormsg != undefined? item.errormsg: item.Name+" error";
                                        return false;
                                    } 
                                } else if(item.regex == "minimum-value"){
                                    valueVal = item.value;
                                    var minValue = parseInt(item.minValue);
                                    if(valueVal >= minValue){
                                        return true;
                                    }else{
                                        errorMessage = item.errormsg != undefined? item.errormsg: item.Name+" error";
                                        return false;
                                    }
                                } else {
                                    var regexExp = new RegExp(item.regex);
                                    valueVal = item.value;
                                    if(regexExp.test(valueVal)){
                                        return true;
                                    }else{
                                        errorMessage = item.errormsg != undefined? item.errormsg: item.label.replace(/<\/?[^>]+(>|$)/g, "");+" is required.";
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
                } else {
                    return true;
                }  
            });
            if(questionsFlagCheck){
                component.set("v.nextFlag", true);                    
            }
            else{
                component.set("v.nextFlag", false);
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "ERROR!",
                    "message": errorMessage.replace(/<\/?[^>]+(>|$)/g, "").replace(/&quot;/g, '"'),
                    "type": "error"
                });
                toastEvent.fire();
            }            
        } 
            else if(licenseWrapper[tabNumber].subheader == "Endorsement"){
                var fieldsWrapper = licenseWrapper[tabNumber].labelFieldsMap;
                var validateFields = fieldsWrapper.filter(function(item){
                    return  item.isMandatoryQues == true || (item.regex != undefined && item.regex != "");
                });                            
                var errorMessage = "Please fill valid data";
                var questionsFlagCheck = validateFields.every(function validateFields(item) {
                    if(item.renderedOnUi){
                        if(item.isMandatoryQues){
                            if(item.regex != undefined && item.regex != ""){
                                if(item.regex == "Date-Validation"){
                                    //
                                } else {
                                    var regexExp = new RegExp(item.regex);
                                    var valueVal = item.value;
                                    if( valueVal != '' && valueVal != null && valueVal != "--None--" && valueVal != "--none--" && valueVal != "--Select one--" && valueVal != "--Select One--" && valueVal.toString()!= undefined && valueVal.toString().trim() != undefined && valueVal.toString().trim() != "" && regexExp.test(valueVal)){
                                        return true;
                                    }else{
                                        errorMessage = item.errormsg != undefined? item.errormsg: item.label.replace(/<\/?[^>]+(>|$)/g, "")+" is required.";
                                        return false;
                                    }  
                                }
                            } else {
                                var valueVal = item.value;
                                if( valueVal != '' && valueVal != null && valueVal != "--None--" && valueVal != "--none--" && valueVal != "--Select one--" && valueVal != "--Select One--" && valueVal.toString()!= undefined && valueVal.toString().trim() != undefined && valueVal.toString().trim() != "" ){
                                    return true;
                                } else {
                                    errorMessage = item.errormsg != undefined? item.errormsg: item.label.replace(/<\/?[^>]+(>|$)/g, "")+" is required.";
                                    return false;
                                }  
                            }
                        } else {
                            if(item.regex != undefined && item.regex != ""){
                                var valueVal = item.value;
                                if( valueVal != '' && valueVal != null && valueVal != "--None--" && valueVal != "--none--" && valueVal != "--Select one--" && valueVal != "--Select One--" && valueVal.toString()!= undefined && valueVal.toString().trim() != undefined && valueVal.toString().trim() != "" ){
                                    if(item.regex == "Date-Validation"){
                                        //
                                    } else {
                                        var regexExp = new RegExp(item.regex);
                                        var valueVal = item.value;
                                        if( valueVal != '' && valueVal != null && valueVal != "--None--" && valueVal != "--none--" && valueVal != "--Select one--" && valueVal != "--Select One--" && valueVal.toString()!= undefined && valueVal.toString().trim() != undefined && valueVal.toString().trim() != "" && regexExp.test(valueVal)){
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
                    } else {
                        return true;
                    }  
                });
                if(questionsFlagCheck){
                    component.set("v.nextFlag", true);                    
                }
                else{
                    component.set("v.nextFlag", false);
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "ERROR!",
                        "message": errorMessage.replace(/<\/?[^>]+(>|$)/g, "").replace(/&quot;/g, '"'),
                        "type": "error"
                    });
                    toastEvent.fire();
                }            
            }else if(licenseWrapper[tabNumber].subheader == "Financial Guarantee"){
                var fieldsWrapper = licenseWrapper[tabNumber].labelFieldsMap;
                var validateFields = fieldsWrapper.filter(function(item){
                    return  item.isMandatoryQues == true || (item.regex != undefined && item.regex != "");
                });                            
                var errorMessage = "Please fill valid data";
                var approExpirationFlag = component.get("v.approExpirationFlag");
                var financequestionsFlagCheck = validateFields.every(function validateFields(item) {
                    if(item.renderedOnUi){
                        if(item.isMandatoryQues){
                            if(item.regex != undefined && item.regex != ""){
                                var valueVal = item.value;
                                if(valueVal!="" && valueVal!=null && valueVal != "--None--" && valueVal != "--none--" && valueVal != "--Select one--" && valueVal != "--Select One--" && valueVal.toString()!= undefined && valueVal.toString().trim() != undefined && valueVal.toString().trim() != ""){
                                    if(item.regex == "Future-Date"){
                                        // Date should be future and not greater than 4 years
                                        var valueVal = item.value;
                                        var today = new Date();
                                        var compareDate = (today.getFullYear()+4)+'-'+(today.getMonth().length>1?(today.getMonth()+1):'0'+(today.getMonth()+1))+'-'+today.getDate();
                                        compareDate = new Date(compareDate);
                                        var enteredDate = new Date(valueVal);
                                        if(enteredDate > today && enteredDate < compareDate){
                                            return true;
                                        }else{
                                            errorMessage = item.errormsg != undefined? item.errormsg: item.Name+" error";
                                            return false;
                                        }
                                    } else if(item.regex == "Policy-Amount"){
                                        var valueVal = item.value;
                                        var minValue = parseInt(item.minValue);
                                        if(valueVal >= minValue){
                                            return true;
                                        }else{
                                            errorMessage = item.errormsg != undefined? item.errormsg: item.Name+" error";
                                            return false;
                                        }
                                    }else {
                                        var regexExp = new RegExp(item.regex);
                                        var valueVal = item.value;
                                        if(regexExp.test(valueVal)){
                                            return true;
                                        }else{
                                            errorMessage = item.errormsg != undefined? item.errormsg: item.Name+" error";
                                            return false;
                                        }  
                                    }
                                }else{
                                    errorMessage = item.errormsg != undefined? item.errormsg: item.Name+" error";
                                    return false;
                                }
                            } else {
                                var valueVal = item.value;
                                if( valueVal != '' && valueVal != null && valueVal != "--None--" && valueVal != "--none--" && valueVal != "--Select one--" && valueVal != "--Select One--" && valueVal.toString()!= undefined && valueVal.toString().trim() != undefined && valueVal.toString().trim() != "" ){
                                    return true;
                                } else {
                                    errorMessage = item.errormsg != undefined? item.errormsg: item.Name+" error";
                                    return false;
                                }  
                            }
                        } else {
                            if(item.regex != undefined && item.regex != ""){
                                var valueVal = item.value;
                                if( valueVal != '' && valueVal != null && valueVal != "--None--" && valueVal != "--none--" && valueVal != "--Select one--" && valueVal != "--Select One--" && valueVal.toString()!= undefined && valueVal.toString().trim() != undefined && valueVal.toString().trim() != "" ){
                                    if(item.regex == "Future-Date"){
                                        // Date should be future and not greater than 4 years
                                        var valueVal = item.value;
                                        var today = new Date();
                                        var compareDate = (today.getFullYear()+4)+'-'+(today.getMonth().length>1?(today.getMonth()+1):'0'+(today.getMonth()+1))+'-'+today.getDate();
                                        compareDate = new Date(compareDate);
                                        var enteredDate = new Date(valueVal);
                                        if(enteredDate > today && enteredDate < compareDate){
                                            return true;
                                        }else{
                                            errorMessage = item.errormsg != undefined? item.errormsg: item.Name+" error";
                                            return false;
                                        } 
                                    } else if(item.regex == "Policy-Amount"){
                                        var valueVal = item.value;
                                        var minValue = parseInt(item.minValue);
                                        if(valueVal >= minValue){
                                            return true;
                                        }else{
                                            errorMessage = item.errormsg != undefined? item.errormsg: item.Name+" error";
                                            return false;
                                        }
                                    }else {
                                        var regexExp = new RegExp(item.regex);
                                        var valueVal = item.value;
                                        if(regexExp.test(valueVal)){
                                            return true;
                                        }else{
                                            errorMessage = item.errormsg != undefined? item.errormsg: item.Name+" error";
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
                    } else {
                        return true;
                    }  
                });
                var finExpirationDate = "";
                var finEffectiveDate = "";
                for(var i=0; i<fieldsWrapper.length; i += 1){
                    if(fieldsWrapper[i].fieldAPIName == "Expiration_Date_of_Bond__c" && fieldsWrapper[i].value != "")  {
                            finExpirationDate = fieldsWrapper[i].value;
                    }
                    if(fieldsWrapper[i].fieldAPIName == "Effective_Date_of_Bond__c" && fieldsWrapper[i].value != "")  {
                            finEffectiveDate = fieldsWrapper[i].value;
                    }
                } 
                if(finExpirationDate < finEffectiveDate){
                    approExpirationFlag = false;
                    errorMessage = 'Expiration Date should be greater than Effective Date!';
                }
                else if(finExpirationDate > finEffectiveDate){
                    approExpirationFlag = true;
                }
                
                if(financequestionsFlagCheck && approExpirationFlag){
                    component.set("v.nextFlag", true);     
                    component.set("v.approExpirationFlag", true);
                }
                else{
                    component.set("v.nextFlag", false);
                    component.set("v.approExpirationFlag", false);                
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "ERROR!",
                        "message": errorMessage.replace(/<\/?[^>]+(>|$)/g, "").replace(/&quot;/g, '"'),
                        "type": "error"
                    });
                    toastEvent.fire();
                }            
            }else if(licenseWrapper[tabNumber].subheader == "Qualifying Information"){
                var qualificationValidation = licenseWrapper[tabNumber].mandatorySubsection;
                var qualificationValid = false;
                var sectionName = "";
                var errorSections =[];
                var enteredSections = [];
                if(qualificationValidation != "" && qualificationValidation != null){
                    if(document.getElementsByClassName('tile-wrap').length != undefined && document.getElementsByClassName('tile-wrap').length != 0){
                        var qualifications = document.getElementsByClassName('tile-wrap');
                        for(var i=0; i<qualifications.length; i += 1){
                            if(qualifications[i].firstElementChild != null){
                                if(qualifications[i].firstElementChild.classList.contains('recordDetail')){
                                    sectionName = qualifications[i].firstElementChild.firstChild.innerHTML
                                    enteredSections.push(sectionName);
                                }
                            }
                        }
                        var mandatoryqualification = qualificationValidation.split(",");
                        var qualificationValid = mandatoryqualification.filter(function(item){
                            if(enteredSections.includes(item.trim())){
                                return true;
                            }else{
                                errorSections.push(item);
                            }
                        })
                        var errorMsg = "";
                        if(errorSections.length==0){
                            qualificationValid = true;
                        } else {
                            qualificationValid = false;
                            for(var j=0;j<errorSections.length; j += 1){
                                errorMsg = errorMsg!=""?errorMsg+","+errorSections[j]:errorMsg+""+errorSections[j];
                        	}
                            errorMessage = errorMsg.includes(",")?"Please fill "+errorMsg+" sections":"Please fill "+errorMsg+" section";
                        }
                    } else {
                        qualificationValid = false;
                        errorMessage = "Please fill "+qualificationValidation+" sections";
                    }
                } else {
                    qualificationValid = true;
                }
                
                if(qualificationValid){
                    component.set("v.nextFlag", true);                    
                }
                else{
                    component.set("v.nextFlag", false);
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "ERROR!",
                        "message": errorMessage.replace(/<\/?[^>]+(>|$)/g, "").replace(/&quot;/g, '"'),
                        "type": "error"
                    });
                    toastEvent.fire();
                }     
            }
			else if(licenseWrapper[tabNumber].subheader === "Attachments"){
				var fieldsWrapper = licenseWrapper[tabNumber].labelFieldsMap;
				var validateFields = fieldsWrapper.every(function(item){
					if(item.isMandatorySub){
						if(item.multiValues.length != undefined && item.multiValues.length > 0){
							return true;
						}
						else{
							return false;
						}
					}else{
						return true;
					}
				});
				if(validateFields){
					component.set("v.nextFlag", true);
					component.set("v.showErrorMsgsOfAttachments", false);
				}
				else{
					component.set("v.nextFlag", false);
					component.set("v.showErrorMsgsOfAttachments", true);
					var toastEvent = $A.get("e.force:showToast");
					toastEvent.setParams({
						"title": "ERROR!",
						"message": "Please upload the required attachments.",
						"type": "error"
					});
					toastEvent.fire();
				} 
			}
            else {
                component.set("v.nextFlag", true);  
            }
    },
    updateAffiliation : function(component,event,helper){
        var action = component.get("c.updateAffiliation");
        action.setParams({"requestId": component.get("v.applicationId") });
        action.setCallback(this, function(actionResult){
            var state = actionResult.getState();
            console.log("inside fetchData"+ state);
            if (state === "SUCCESS"){
                var result = actionResult.getReturnValue();
                console.log('result::'+result);
            }else{
                //  window.location.href = "./error";
                console.log("error" +  state);
            }
        });
        $A.enqueueAction(action);
    }
    
})