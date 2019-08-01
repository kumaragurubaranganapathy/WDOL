({
    fetchDataFromServer : function(component, event, helper){
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
            "appId": component.get("v.applicationId"),
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
                //alert(resultWrapper);
                
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
        console.log('applicationId::'+applicationId);
        var recordID =  sessionStorage.getItem("accountRecordID");
        var licenseRecordID =  sessionStorage.getItem("LicenseRecordID");
        var flowType = sessionStorage.getItem("flowType");
        var objectName = "";
        if(applicationId!=null){
            //set licenseType, etc -> coming from dashboard
        }else{
            if(licenseType==null||applicationType==null||board==null){
                window.location.href = "./error";
            }
        }
        
        component.set("v.licenseType", licenseType);
        component.set("v.board", board);
        component.set("v.applicationType", applicationType);
        component.set("v.applicationId", applicationId);
        component.set("v.flowType", flowType);
        if((recordID !='' && recordID != null) || recordID != null ){
            recordID = recordID;
            objectName = "Account";
        } 
        component.set("v.recordId",recordID);
        component.set("v.licenseRecordID",licenseRecordID);
        component.set("v.objectName",objectName);
        sessionStorage.clear();
        
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
        	component.set("v.showEndoMessage",false);
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
                    if(component.get("v.saveAndSubmit") == true){
                        this.SaveAndSubmit(component,event,helper); 
                    }
                    var tabsList = component.get("v.licenseWrapper");
                    var currentTab = component.get("v.currentTab");
                    
                    if(component.get("v.licenseType")=='Notary Public' && tabsList[currentTab-1].labelFieldsMap[0].questionSectionClass =='Endorsement' && tabsList[currentTab-1].labelFieldsMap[0].value == tabsList[currentTab-1].labelFieldsMap[0].messageTriggerResponse)
                    {
                        component.set("v.showNotaryEndo",true);
                    }
                    // helper.showDependentQuestionsOnPageLoadHelper(component, event, helper);
                } else {
                    //handle error as well
                    console.log('error on insert application');
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
                    if(tabsList[key].sectionName =='License Information'  ){
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
            if( component.get("v.saveAndSubmit") !=true){
                 window.scrollTo({ top: 0, behavior: 'smooth' });
            }
        }
    },
    SaveAndSubmit : function(component, event, helper) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": "Warning!",
            "message": "You will have 30 days to complete this application before it expires.",
            "type": "Warning"
        });
        
        toastEvent.fire();
        window.setTimeout(
            $A.getCallback(function() {
                // smth after two seconds
                // check component.isValid() if you want to work with component
                var isBizLic = component.get("v.isbusinsessLicense");                
                var str = isBizLic?'/business':'/newdashboard';
                var urlEvent = $A.get("e.force:navigateToURL");
                urlEvent.setParams({
                    "url": str
                });
                urlEvent.fire();
            }), 2000
        );
    },
    submit : function(component, event, helper) {
        this.checkboxValidation(component, event);
        var id;
        var noFees;
        var that = this;
        if(component.get("v.attestationStatus") == true && component.get("v.certificateValues") == true && component.get("v.AttFlagForsubmit") == "true" && component.get("v.declarationFlag") == true)
        {                      
            var action = component.get("c.callCompositeAPI");
            action.setParams({
                "applicationId" : component.get("v.applicationId"),
                "childlicenseRecordID" : component.get("v.licenseRecordID"),
            });
            this.showSpinner(component, event);
            //helper.AttestVal(component, event, helper);
            action.setCallback(this, function(actionResult){
                var state = actionResult.getState();
                if (state === "SUCCESS"){
                    var result = actionResult.getReturnValue();
                    //var noFees;
                    //this.hideSpinner(component, event);
                    component.set("v.storeServerValue", result[0].Id);
                    id = component.get("v.storeServerValue");
                    try{
                        return new Promise($A.getCallback(function(resolve, reject) {
                            var action = component.get("c.getTotalBalance");
                            action.setParams({"licId" : id });
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
                            $A.getCallback(function(result){ 
                                var str = '';
                                component.set("v.loadingSpinner", false);
                                if(noFees){
                                    /*str ='/dashboard';
                                    var urlEvent = $A.get("e.force:navigateToURL");
                                    urlEvent.setParams({
                                        "url": str
                                    });
                                    urlEvent.fire(); */
                                    // below code is for no fees case
                                    that.hideSpinner(component, event);
                                    component.set("v.popupHeader", "Successfully Submitted");
                                    component.set("v.popupBody", "Thank you for submission of your application.");
                                    component.set("v.serverStatus", "success"); 
                                    //component.set("v.storeServerValue", result[0].Id);
                                    component.set("v.isOpen", true); 
                                    // no fees code ends
                                }else{ 
                                    that.hideSpinner(component, event);
                                    var str ='/cart?id='+id;
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
                    // Set popup property values before displayiong pop up.
                    /*component.set("v.popupHeader", "Successfully Submitted");
                    component.set("v.popupBody", "Thank you for submission of your application.");
                    component.set("v.serverStatus", "success"); 
                    component.set("v.storeServerValue", result[0].Id);
                    component.set("v.isOpen", true); */
                }else{
                    console.log("Error");
                    //handle error as well
                }
                
            });
            $A.enqueueAction(action);
            
            window.scrollTo({ top: 0, behavior: 'smooth' });
        }
    },    
    showDependentQuestionsHelper : function(component, event, helper) {        
        component.set("v.showEndoMessage",false);
        component.set("v.showNotaryEndo",false);
        var response = event.getSource().get("v.value").trim();
        var responsePlaceholder = response;
        var questionNumber = '';
        if(event.getSource().get("v.name").includes('License Information'))
        {
            questionNumber = event.getSource().get("v.name").split('License Information')[1];
        }
        else if(event.getSource().get("v.name").includes('Questions'))
        {
            questionNumber = event.getSource().get("v.name").split('Questions')[1];
        }
        else
        {          
            questionNumber = event.getSource().get("v.name").split('Endorsement')[1];
        }
        var tabsList = component.get("v.licenseWrapper");
        var currentTab = component.get("v.currentTab");
        if(component.get("v.licenseType")=='Notary Public' && tabsList[currentTab-1].labelFieldsMap[questionNumber].messageTriggerResponse == response)
        {
            component.set("v.showNotaryEndo",true);
			//component.set("v.showEndoMessage",true);
            //component.set("v.endoMessage",tabsList[currentTab-1].labelFieldsMap[questionNumber].message);  
        }
        if(tabsList[currentTab-1].labelFieldsMap[questionNumber].messageTriggerResponse == response)
        {            
            component.set("v.showEndoMessage",true);
            component.set("v.endoMessage",tabsList[currentTab-1].labelFieldsMap[questionNumber].message);            
        }
        var hasChildQuestion = tabsList[currentTab-1].labelFieldsMap[questionNumber].hasChild;
        var questionNumberId = tabsList[currentTab-1].labelFieldsMap[questionNumber].labelId;
        var childQuestionsArray = [];
        var subChildQuestionsArray=[];
        if(hasChildQuestion){
            for(var index=0; index<tabsList[currentTab-1].labelFieldsMap.length ; index++){
                if(tabsList[currentTab-1].labelFieldsMap[index].parentQuestionId == questionNumberId){
                    childQuestionsArray.push(index);
                } 
            }
            if(childQuestionsArray.length>0){
                for(var i=0; i<childQuestionsArray.length; i++){
                    response = responsePlaceholder;
                    var mapIndex = childQuestionsArray[i];
                    if(tabsList[currentTab-1].labelFieldsMap[mapIndex].conditionalAnswer == response){
                        tabsList[currentTab-1].labelFieldsMap[mapIndex].renderedOnUi=true;
                    } else {
                        for(var j=0; j<tabsList[currentTab-1].labelFieldsMap.length; j++){
                            if(tabsList[currentTab-1].labelFieldsMap[j].parentQuestionId == questionNumberId){
                                if(tabsList[currentTab-1].labelFieldsMap[j].conditionalAnswer == response){
                                    tabsList[currentTab-1].labelFieldsMap[j].renderedOnUi=true;                       
                                }else{
                                    if(tabsList[currentTab-1].labelFieldsMap[j].hasChild){
                                        subChildQuestionsArray=[]; 
                                        for(var k=j; k<tabsList[currentTab-1].labelFieldsMap.length ; k++){
                                            if(tabsList[currentTab-1].labelFieldsMap[k].parentQuestionId == questionNumberId){
                                                subChildQuestionsArray.push(k);
                                            } 
                                        }
                                        if(subChildQuestionsArray.length == 1){
                                            questionNumberId = tabsList[currentTab-1].labelFieldsMap[j].labelId;
                                            response = '';
                                            tabsList[currentTab-1].labelFieldsMap[j].value = '';
                                            tabsList[currentTab-1].labelFieldsMap[j].renderedOnUi=false;
                                        }else{
                                            var newVar;
                                            for(var l=0; l<subChildQuestionsArray.length ; l++){
                                                newVar = subChildQuestionsArray[l];
                                                if(tabsList[currentTab-1].labelFieldsMap[newVar].renderedOnUi){
                                                    questionNumberId = tabsList[currentTab-1].labelFieldsMap[newVar].labelId;
                                                    response = '';
                                                    tabsList[currentTab-1].labelFieldsMap[newVar].value = '';
                                                    tabsList[currentTab-1].labelFieldsMap[newVar].renderedOnUi=false;
                                                } else {
                                                    tabsList[currentTab-1].labelFieldsMap[newVar].value = '';
                                                    tabsList[currentTab-1].labelFieldsMap[newVar].renderedOnUi=false;
                                                }
                                            }
                                        }   
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
        var str ='/user-feedback';
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url": str
        });
        urlEvent.fire(); 
        /*var id = component.get("v.storeServerValue");
        var noFees;
        component.set("v.loadingSpinner", true);
        if(component.get("v.serverStatus") == "success"){
            try{
                return new Promise($A.getCallback(function(resolve, reject) {
                    var action = component.get("c.getTotalBalance");
                    action.setParams({"licId" : id });
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
                    $A.getCallback(function(result){ 
                        var str = '';
                        component.set("v.loadingSpinner", false);
                        if(noFees){
                            str ='/dashboard';
                            var urlEvent = $A.get("e.force:navigateToURL");
                            urlEvent.setParams({
                                "url": str
                            });
                            urlEvent.fire();
                            
                        }else{
                            window.location.href = $A.get("$Label.c.Polaris_Portal_URL")+'cart?id='+id;
                        } 
                    }));
            }    
            catch(e){
                console.error('Error Stack Message for showQuestionHelper Helper' + e.stack);	
            }
        }*/},                               
    onDeclarationChange: function(component, event, helper){
        this.toEnableSubmitButtonCheck(component, event);
        if(component.get("v.attestationStatus") == true && component.get("v.certificateValues") == true && component.get("v.AttFlagForsubmit") == "true" && component.get("v.declarationFlag") == true){
            component.set("v.submitButtonDisable", "false");
        }
        else {
            component.set("v.submitButtonDisable", "true");
        }
    },  
    onCheckboxChange: function(component, event){
        this.toEnableSubmitButtonCheck(component, event);
        if(component.get("v.attestationStatus") == true && component.get("v.certificateValues") == true && component.get("v.AttFlagForsubmit") == "true" && component.get("v.declarationFlag") == true){
            component.set("v.submitButtonDisable", "false");
        }
        else {
            component.set("v.submitButtonDisable", "true");
        }
    },
    onAttestationChange: function(component, event, helper) {
        this.toEnableSubmitButtonCheck(component, event);
        if(component.get("v.attestationStatus") == true && component.get("v.certificateValues") == true && component.get("v.AttFlagForsubmit") == "true" && component.get("v.declarationFlag") == true){
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
            if(!totalCheckbox[i].classList.contains('slds-hide')){
                if(document.getElementById('cert'+i).checked === true){
                    counter = counter + 1;
                }
            }else{
                counter = counter + 1;
            }  
        }
        if(totalCheckbox.length == counter) {
            component.set("v.certificateValues", true);
            
        } else {
            component.set("v.certificateValues", false);
            //component.set("v.certificateError", "All checkbox's must be checked.");
        }
        
        var totalDeclarationCheckbox = document.getElementsByClassName("declaration-checkbox");
        var declarationCounter = 0;
        for(var i=0; i < totalDeclarationCheckbox.length; i++ ){
            if(document.getElementById('declaration').checked === true){
                declarationCounter = declarationCounter + 1;
            }
        }
        if(totalDeclarationCheckbox.length == declarationCounter) {
            component.set("v.declarationFlag", true);
            
        } else {
            component.set("v.declarationFlag", false);
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
            if(!totalCheckbox[i].classList.contains('slds-hide')){
                if(document.getElementById('cert'+i).checked === true){
                    counter = counter + 1;
                }
            }else{
                counter = counter + 1;
            }
        }    
        if(totalCheckbox.length == counter) {
            component.set("v.certificateValues", true);
            component.set("v.certificateError", "");
        } else {
            component.set("v.certificateError", "All checkboxes must be checked.");
        }
        var totalDeclarationCheckbox = document.getElementsByClassName("declaration-checkbox");
        var declarationCounter = 0;
        for(var i=0; i < totalDeclarationCheckbox.length; i++ ){
            if(document.getElementById('declaration').checked === true){
                declarationCounter = declarationCounter + 1;
            }
        }
        if(totalDeclarationCheckbox.length == declarationCounter) {
            component.set("v.declarationFlag", true);
            component.set("v.declarationError", "");
            
        } else {
            component.set("v.declarationError", "Declation checkbox must be checked.");
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
        if(licenseWrapper[tabNumber].subheader == 'Personal Information' || licenseWrapper[tabNumber].subheader == 'Business Information') {
            var fieldsWrapper = JSON.parse(licenseWrapper[tabNumber].fieldJson);
            var validateFields = fieldsWrapper.filter(function(item){
                return  item.Required__c == true || (item.Regex_Validation__c != undefined && item.Regex_Validation__c != "");
            });                
            var fieldValuesWrapper = component.find("recordObjectForm").find("validateField");                 
            var errorMessage = "Please fill valid data";
            var PatternAndFlagCheck = validateFields.every(function validateFields(item, index) {
                if(!$A.util.hasClass(fieldValuesWrapper[index], "slds-hide")){
                    if(item.Required__c){
                        if(item.Regex_Validation__c != undefined && item.Regex_Validation__c != ""){
                            if(item.Regex_Validation__c == "Date-Validation"){
                                var valueVal = fieldValuesWrapper[index].get("v.value");
                                if(valueVal != "" && valueVal != null){
                                    var today = new Date();
                                    var compareDate = today.getFullYear()+'-'+(today.getMonth().length>1?(today.getMonth()+1):'0'+(today.getMonth()+1))+'-'+today.getDate();
                                    compareDate = new Date(compareDate);
                                    var enteredDate = new Date(valueVal);
                                    if(enteredDate < compareDate){
                                        return true;
                                    }else{
                                        errorMessage = item.Error_Message__c != undefined? item.Error_Message__c: item.Name+" error";
                                        return false;
                                    }
                                }else{
                                    errorMessage = item.Error_Message__c != undefined? item.Error_Message__c: item.Name+" error";
                                    return false;
                                }
                            } else if(item.Regex_Validation__c == "itin-validation"){
                                var valueVal = fieldValuesWrapper[index].get("v.value");
                                if(valueVal!= "" && valueVal!="111-11-1111" && valueVal!="333-33-3333" && valueVal!="666-66-6666" && valueVal!="123-45-6789" && valueVal.charAt(0) != "9"){
                                    if(valueVal.slice(4, 6) != "00" && valueVal.slice(7, 11)){
                                        return true;
                                    } else {
                                        errorMessage = item.Error_Message__c != undefined? item.Error_Message__c: item.Name+" error";
                                    	return false;
                                    }
                                } else {
                                    errorMessage = item.Error_Message__c != undefined? item.Error_Message__c: item.Name+" error";
                                    return false;
                                }
                            } else {
                                var regexExp = new RegExp(item.Regex_Validation__c);
                                var valueVal = fieldValuesWrapper[index].get("v.value");
                                if(fieldValuesWrapper[index].get("v.value") != '' && fieldValuesWrapper[index].get("v.value") != null && regexExp.test(valueVal)){
                                    return true;
                                }else{
                                    errorMessage = item.Error_Message__c != undefined? item.Error_Message__c: item.Name+" error";
                                    return false;
                                }  
                            }
                        } else {
                            if(fieldValuesWrapper[index].get("v.value") != '' && fieldValuesWrapper[index].get("v.value") != null){
                                return true;
                            } else {
                                errorMessage = item.Error_Message__c != undefined? item.Error_Message__c: item.Name+" error";
                                return false;
                            }  
                        }
                    } else {
                        if(item.Regex_Validation__c != undefined && item.Regex_Validation__c != ""){
                            if(fieldValuesWrapper[index].get("v.value") != '' && fieldValuesWrapper[index].get("v.value") != null){
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
                                        return false;
                                    }  
                                } else {
                                    var regexExp = new RegExp(item.Regex_Validation__c);
                                    var valueVal = fieldValuesWrapper[index].get("v.value");
                                    if(regexExp.test(valueVal)){
                                        return true;
                                    }else{
                                        errorMessage = item.Error_Message__c != undefined? item.Error_Message__c: item.Name+" error";
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
            //Address validation code
            /*var addressValidation = licenseWrapper[tabNumber].mandatorySubsection;
            var addressValid = false;
            if(addressValidation != null){
                if(document.getElementsByClassName("address-title").length != undefined && document.getElementsByClassName("address-title").length != 0){
                    var addresses = document.getElementsByClassName("address-title");
                    var addedAddressArray = [];
                    for(var i=0; i<addresses.length; i++){
                        addedAddressArray.push(document.getElementsByClassName("address-title")[i].textContent);
                    }
                    var mandatoryAddress = addressValidation.split(",");
                    var addressflag = mandatoryAddress.every(function(item){
                        return addedAddressArray.includes(item);
                    });
                    if(addressflag){
                        addressValid = true;
                    }else{
                        addressValid = false;
                    	errorMessage = "Address error";
                    }
                } else {
                    addressValid = false;
                    errorMessage = "Address error";
                }
            } else {
                addressValid = true;
            }*/
            // Address validation check && addressValid
            if(PatternAndFlagCheck){
                component.set("v.nextFlag", true);                    
            }
            else{
                component.set("v.nextFlag", false);
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "ERROR!",
                    "message": errorMessage,
                    "type": "error"
                });
                toastEvent.fire();
            }
        }
        else if(licenseWrapper[tabNumber].subheader == "License Information"){
            var fieldsWrapper = licenseWrapper[tabNumber].labelFieldsMap;
            var validateFields = fieldsWrapper.filter(function(item){
                return  item.isMandatoryQues == true || (item.regex != undefined && item.regex != "");
            });                            
            var errorMessage = "Please fill valid data";
            var questionsFlagCheck = validateFields.every(function validateFields(item, index) {
                if(item.renderedOnUi){
                    if(item.isMandatoryQues){
                        if(item.regex != undefined && item.regex != ""){
                            if(item.regex == "Date-Validation"){
                                //
                            } else {
                                var regexExp = new RegExp(item.regex);
                                var valueVal = item.value;
                                if( valueVal != '' && valueVal != null && valueVal != "--None--" && valueVal != "--none--" && valueVal.trim() != "" && regexExp.test(valueVal)){
                                    return true;
                                }else{
                                    errorMessage = item.errormsg != undefined? item.errormsg: item.label+" is required.";
                                    return false;
                                }  
                            }
                        } else {
                            var valueVal = item.value;
                            if( valueVal != '' && valueVal != null && valueVal != "--None--" && valueVal != "--none--" && valueVal.trim() != "" ){
                                return true;
                            } else {
                                errorMessage = item.errormsg != undefined? item.errormsg: item.label+" is required.";
                                return false;
                            }  
                        }
                    } else {
                        if(item.regex != undefined && item.regex != ""){
                            var valueVal = item.value;
                            if( valueVal != '' && valueVal != null && valueVal != "--None--" && valueVal != "--none--" && valueVal.trim() != "" ){
                                if(item.regex == "Date-Validation"){
                                    //
                                } else {
                                    var regexExp = new RegExp(item.regex);
                                    var valueVal = item.value;
                                    if( valueVal != '' && valueVal != null && valueVal != "--None--" && valueVal != "--none--" && valueVal.trim() != "" && regexExp.test(valueVal)){
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
                    "message": errorMessage,
                    "type": "error"
                });
                toastEvent.fire();
            }            
        } else if(licenseWrapper[tabNumber].subheader == "Financial Guarantee"){
            var fieldsWrapper = licenseWrapper[tabNumber].labelFieldsMap;
            var validateFields = fieldsWrapper.filter(function(item){
                return  item.isMandatoryQues == true || (item.regex != undefined && item.regex != "");
            });                            
            var errorMessage = "Please fill valid data";
            var financequestionsFlagCheck = validateFields.every(function validateFields(item, index) {
                if(item.renderedOnUi){
                    if(item.isMandatoryQues){
                        if(item.regex != undefined && item.regex != ""){
                            if(item.regex == "Future-Date"){
                                var valueVal = item.value;
                                if(valueVal!="" && valueVal!=null){
                                    var today = new Date();
                                    var compareDate = today.getFullYear()+'-'+(today.getMonth().length>1?(today.getMonth()+1):'0'+(today.getMonth()+1))+'-'+today.getDate();
                                    compareDate = new Date(compareDate);
                                    var enteredDate = new Date(valueVal);
                                    if(enteredDate > compareDate){
                                        return true;
                                    }else{
                                        errorMessage = item.errormsg != undefined? item.errormsg: item.Name+" error";
                                        return false;
                                    }
                                }else{
                                    errorMessage = item.errormsg != undefined? item.errormsg: item.Name+" error";
                                    return false;
                                }
                            } else if(item.regex == "Policy-Amount"){
                                var valueVal = item.value;
                                if(valueVal!="" && valueVal!=null){
                                    var minValue = parseInt(item.minValue);
                                    if(valueVal >= minValue){
                                        return true;
                                    }else{
                                        errorMessage = item.errormsg != undefined? item.errormsg: item.Name+" error";
                                        return false;
                                    }
                                }else{
                                    errorMessage = item.errormsg != undefined? item.errormsg: item.Name+" error";
                                    return false;
                                }
                            }else {
                                var regexExp = new RegExp(item.regex);
                                var valueVal = item.value;
                                if( valueVal != '' && valueVal != null && valueVal != "--None--" && valueVal != "--none--" && valueVal.trim() != "" && regexExp.test(valueVal)){
                                    return true;
                                }else{
                                    errorMessage = item.errormsg != undefined? item.errormsg: item.Name+" error";
                                    return false;
                                }  
                            }
                        } else {
                            var valueVal = item.value;
                            if( valueVal != '' && valueVal != null && valueVal != "--None--" && valueVal != "--none--" && valueVal.trim() != "" ){
                                return true;
                            } else {
                                errorMessage = item.errormsg != undefined? item.errormsg: item.Name+" error";
                                return false;
                            }  
                        }
                    } else {
                        if(item.regex != undefined && item.regex != ""){
                            var valueVal = item.value;
                            if( valueVal != '' && valueVal != null && valueVal != "--None--" && valueVal != "--none--" && valueVal.trim() != "" ){
                                if(item.regex == "Future-Date"){
                                    var valueVal = item.value;
                                    if(valueVal != "" && valueVal != null){
                                        var today = new Date();
                                        var compareDate = today.getFullYear()+'-'+(today.getMonth().length>1?(today.getMonth()+1):'0'+(today.getMonth()+1))+'-'+today.getDate();
                                        compareDate = new Date(compareDate);
                                        var enteredDate = new Date(valueVal);
                                        if(enteredDate > compareDate){
                                            return true;
                                        }else{
                                            errorMessage = item.errormsg != undefined? item.errormsg: item.Name+" error";
                                            return false;
                                        } 
                                    }else{
                                        errorMessage = item.errormsg != undefined? item.errormsg: item.Name+" error";
                                        return false;
                                    } 
                                } else if(item.regex == "Policy-Amount"){
                                    var valueVal = item.value;
                                    if(valueVal!="" && valueVal!=null){
                                        var minValue = parseInt(item.minValue);
                                        if(valueVal >= minValue){
                                            return true;
                                        }else{
                                            errorMessage = item.errormsg != undefined? item.errormsg: item.Name+" error";
                                            return false;
                                        }
                                    }else{
                                        errorMessage = item.errormsg != undefined? item.errormsg: item.Name+" error";
                                        return false;
                                    }
                                }else {
                                    var regexExp = new RegExp(item.regex);
                                    var valueVal = item.value;
                                    if( valueVal != '' && valueVal != null && valueVal != "--None--" && valueVal != "--none--" && valueVal.trim() != "" && regexExp.test(valueVal)){
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
            if(financequestionsFlagCheck){
                component.set("v.nextFlag", true);                    
            }
            else{
                component.set("v.nextFlag", false);
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "ERROR!",
                    "message": errorMessage,
                    "type": "error"
                });
                toastEvent.fire();
            }            
        } else if(licenseWrapper[tabNumber].subheader == "Qualifying Information"){
            var qualificationValidation = licenseWrapper[tabNumber].mandatorySubsection;
            var qualificationValid = false;
            var counter = 0;
            if(qualificationValidation != null){
                if(document.getElementsByClassName('tile-wrap').length != undefined && document.getElementsByClassName('tile-wrap').length != 0){
                    var qualifications = document.getElementsByClassName('tile-wrap');
                    for(var i=0; i<qualifications.length; i++){
                        if(qualifications[i].firstElementChild != null){
                            if(qualifications[i].firstElementChild.classList.contains('recordDetail')){
                                counter = counter+1;
                            }
                        }
                    }
                    var mandatoryqualification = qualificationValidation.split(",");
                    if(mandatoryqualification.length != undefined && mandatoryqualification.length !=0 && mandatoryqualification.length == counter){
                        qualificationValid = true;
                    } else {
                        qualificationValid = false;
                        errorMessage = "Please fill the mandatory sections";
                    }
                } else {
                    qualificationValid = false;
                    errorMessage = "Please fill the mandatory sections";
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
                    "message": errorMessage,
                    "type": "error"
                });
                toastEvent.fire();
            }     
        }
        else {
            component.set("v.nextFlag", true);  
        }
    },    
    handleComponentEventHelper : function(component, event){
        var messageReceived = event.getParam("message");
        var tabsList = component.get("v.licenseWrapper");
        for(var i=0;i<tabsList.length; i++){
            if(tabsList[i].sectionName == "Review and Submit"){
                var labelFieldsMap = tabsList[i].labelFieldsMap;
                for(var j=0;j<labelFieldsMap.length; j++){
                    if(labelFieldsMap[j].label == "I certify that I do not have a Social Security Number or Individual Taxpayer Identification Number."){
                        if(messageReceived == "Reason for No SSN"){
                            labelFieldsMap[j].renderedOnUi = true;
                        }
                        else{
                            labelFieldsMap[j].renderedOnUi = false;
                        }
                    }
                }
            }
        } 
        component.set("v.licenseWrapper",tabsList);
    }
})