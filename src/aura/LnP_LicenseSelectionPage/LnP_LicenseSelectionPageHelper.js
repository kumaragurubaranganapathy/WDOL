({
    //To reset the values when there is change in program type....
    resetAttributesHelper :  function(component, event, helper){
        var eliTypeGridDiv = document.getElementById("eliTypeGridDiv");
        var appInstructions = document.getElementById("applicationInstuctionDiv");
        console.log("inside reset::");
        $A.util.removeClass(component.find("licenseType"), 'slds-hide');	
        $A.util.removeClass(component.find("getApplicationMethod"), 'slds-hide');
        console.log("inside reset12::");
        eliTypeGridDiv.classList.add("slds-hide");  
        appInstructions.classList.add("slds-hide"); 
        component.find("button1").set('v.disabled',true);
        component.set("v.proceedTemporaryLicense",false);
        $A.util.addClass(component.find("accountPickerId"), 'slds-hide');	
        component.set("v.otherInstructions", []);
        $A.util.addClass(component.find("reqDocTextDiv"), 'slds-hide');
        
        
    },
    
    getUrlParam : function(paramName) {
        var sPageURL = decodeURIComponent(window.location.search.substring(1)); //You get the whole decoded URL of the page.
        var sURLVariables = sPageURL.split('&'); //Split by & so that you get the key value pairs separately in a list
        var sParameterName;
        var paramValue;
        var i;
        
        for (i = 0; i < sURLVariables.length; i++) {
            sParameterName = sURLVariables[i].split('='); //to split the key from the value
            
            if (sParameterName[0] === paramName) { //parameter name you are looking for
                paramValue = (sParameterName[1] === undefined) ? null : sParameterName[1];
            }
        }
        console.log('Param name'+paramName);
        console.log('Param value'+paramValue);
        return paramValue;
    },

    
    restrictTemporaryLicenses : function(component,event,helper){
        var board = component.find("board").get("v.value");
        var licenseType = component.find("licenseType").get("v.value");
        var applicationMethod = component.find("getApplicationMethod").get("v.value");
        var parentObjectAPIName = 'MUSW__License2__c';
        var tempLicenseList = $A.get("$Label.c.Temporary_Licenses");
        console.log(tempLicenseList);
        var templicenseListArr =  tempLicenseList.split(',');
        component.set("v.tempLicenses",tempLicenseList);
        if(board == 'Appraisers - Real Estate'){
            if(templicenseListArr.includes(licenseType)){
                console.log('licenseType---'+licenseType);
                
                var action = component.get("c.validationForTemporaryLicenses");
                //    component.set("v.spinner",true);
                //  helper.hideOrShowSpinner(component, event, helper);
                action.setParams({
                    "Board": board, 
                    "LicenseType": licenseType, 
                    "ApplicationType": applicationMethod,
                    "parentObjectAPIName": parentObjectAPIName,
                }); 
                // component.set("v.isDirectProceed",false);
                action.setCallback(this, function(actionResult){
                    var state = actionResult.getState();
                    var response = actionResult.getReturnValue();
                    if (state === "SUCCESS"){
                        console.log('success');  
                        console.log(response);
                        if(response >= 3){
                            //component.set("v.isDirectProceed",true);
                            component.set("v.proceedTemporaryLicense",true);
                            var toastEvent = $A.get("e.force:showToast");
                            toastEvent.setParams({
                                "title": "Error!",
                                "message": "You have reached the maximum allowed 3 temporary permits for this calendar year.  Please contact the Washington Dept. of Licensing Appraiser's program if you have any questions.",
                                "type": "error"
                            });
                            toastEvent.fire();
                        }
                        else{
                            component.set("v.isDirectProceed",true);  
                            component.set("v.proceedTemporaryLicense",false);
                        }
                    }
                });
                $A.enqueueAction(action);
            }
        }
    },
    
    fetchAppTypeEliQuestionsHelper : function(component, event, helper) {
		component.find("button1").set('v.disabled',true);
        component.set("v.eliTypeQues",[]);
        helper.fetchApplicationInstructionHelper(component,event,helper);
        
        var board = component.find("board").get("v.value");
        var licenseType = component.find("licenseType").get("v.value");
        var applicationMethod = component.find("getApplicationMethod").get("v.value");
        component.set("v.proceedTemporaryLicense",false);
        component.set("v.accounts",'');
        $A.util.addClass(component.find("accountPickerId"), 'slds-hide');	
        var eliTypeGridDiv = document.getElementById("eliTypeGridDiv");
        //var eliTextDiv = document.getElementById("eliTextDiv");
        //var eliQuesDiv = document.getElementById("eliQuesDiv");
        //var proceedButtonDiv = document.getElementById("proceedButtonDiv");
        //Instructions
        var appInstructions = document.getElementById("applicationInstuctionDiv");
        var parentObjectAPIName = '';
        if(applicationMethod == 'General Application' || applicationMethod == 'Comity' || applicationMethod == 'Upgrade' ){
            parentObjectAPIName = 'MUSW__License2__c';
        } 
        
        //console.log("board " + board + " licenseType " + licenseType + "applicationMethod " + applicationMethod);
        component.set("v.board",board);
        component.set("v.licenseType",licenseType);
        
        //appQuesDiv.classList.add("slds-hide");
        //appTypeGridDiv.classList.add("slds-hide");
        eliTypeGridDiv.classList.add("slds-hide");
        appInstructions.classList.add("slds-hide");
        
        //appTypeDiv.classList.add("slds-hide");
        //appTypeGridDiv.classList.add("slds-hide");
        
        component.set("v.isDirectProceed",false);
        //component.set("v.appTypeFieldDisabled",true);
        component.set("v.quesNo",0);
        
        var appQuesList = [];
        var eliQuesList = []; 
        
        if(applicationMethod!=''){
            if(licenseType != ''){
                var action = component.get("c.questionForLicenceTyep");
                component.set("v.spinner",true);
                helper.hideOrShowSpinner(component, event, helper);
                action.setParams({
                    "Board": board, 
                    "LicenseType": licenseType, 
                    "ApplicationType": applicationMethod,
                    "parentObjectAPIName": parentObjectAPIName,
                }); 
                action.setCallback(this, function(actionResult){
                    var state = actionResult.getState();
                    if (state === "SUCCESS"){
                        var response = actionResult.getReturnValue();
                        console.log('response ' + JSON.stringify(response));
                        for(var key in response){
                            if(response[key].Eli_Ques_determines_App_Type__c == true){
                                appQuesList.push({"quesId" : key, "quesBody" : response[key].Question_Body__c, "appTypeQualifyingRes" : response[key].Qualifying_Response__c, "order" : response[key].Order_Number__c, "appTypeEliQues" : response[key].Eli_Ques_determines_App_Type__c, "applicationType" : response[key].Application_Method__c});
                                component.set("v.appTypeQues",appQuesList);
                            }
                            else{
                                eliQuesList.push({"quesId" : key, "quesBody" : response[key].Question_Body__c, "eliTypeQualifyingRes" : response[key].Qualifying_Response__c, "order" : response[key].Order_Number__c, "appTypeEliQues" : response[key].Eli_Ques_determines_App_Type__c, "applicationType" : response[key].Application_Method__c});
                                component.set("v.eliTypeQues",eliQuesList);
                            }
                        }                    
                        console.log('eliQuesList ' + JSON.stringify(eliQuesList));
                        
                        component.set("v.isDirectProceed",false);
                        if(applicationMethod=='Upgrade')
                        {
                            helper.fetchLicenseList(component, event, helper);
                        }
                        
                        helper.fetchAccountList(component, event, helper); 
                        //helper.fetchApplicationInstructionHelper(component,event,helper);
                        if(board == 'Appraisers - Real Estate') {
                            helper.restrictTemporaryLicenses(component,event,helper);
                        }
                        
                        //helper.hideOrShowSpinner(component, event, helper);
                        if(applicationMethod != ''){  
                            window.setTimeout(
                                $A.getCallback(function() {
                                    var instruction = component.get("v.instructions");
                                    console.log("appInstructions",instruction)
                                    if(component.get("v.proceedTemporaryLicense")==true){
                                        component.find("button1").set('v.disabled',true);
                                    } else {
                                        if(instruction != '') {
                                            appInstructions.classList.remove("slds-hide");
                                        }
                                        if(component.get("v.accounts") == '') {
                                            component.find("button1").set('v.disabled',true);
                                            return false;
                                        } 
                                        if(component.get("v.accounts") != ''){
                                            $A.util.removeClass(component.find("accountPickerId"), 'slds-hide');
                                        } else {
                                            component.find("button1").set('v.disabled',true);
                                        }
                                        eliTypeGridDiv.classList.remove("slds-hide");
                                        component.set("v.eliQuesNo",1);
                                        if(eliQuesList.length == 0){
                                            eliTypeGridDiv.classList.add("slds-hide");
                                            //proceedButtonDiv.classList.remove("slds-hide");
                                            if($A.util.hasClass(component.find("accountPickerId"), "slds-hide")){
                                                component.find("button1").set('v.disabled',true);
                                            }else {
                                                component.find("button1").set('v.disabled',false);
                                                eliTypeGridDiv.classList.add("slds-hide");
                                                return false;
                                            }                              
                                        }
                                        
                                    }
                                    
                                    //var eliChild = document.getElementById('eliQuesDiv').children;
                                    //for(var i=0; i<eliChild.length; i++){
                                    //eliChild[0].classList.remove("slds-hide");
                                    //}
                                }), 2000);
                        }
						window.setTimeout($A.getCallback(function() {
                              helper.hideOrShowSpinner(component, event, helper);      
                        }), 2000);
                    } 
                });
                $A.enqueueAction(action);
            }
        }
    },
    
    fetchApplicationInstructionHelper : function(component, event, helper) {
        var board = component.find("board").get("v.value");
        var licenseType = component.find("licenseType").get("v.value");
        var applicationMethod = component.find("getApplicationMethod").get("v.value");
        var action = component.get("c.fetchInstructions");
        action.setParams({
            "Board": board, 
            "LicenseType": licenseType, 
            "ApplicationType": applicationMethod,
            "Obj":'MUSW__License2__c',
            "RenewReinstate":''
        });
        action.setCallback(this, function(actionResult){
            var state = actionResult.getState();
            if (state === "SUCCESS"){ 
                var response = actionResult.getReturnValue();
                console.log('Response::'+response);
                if(response[0] != ''){
                    $A.util.removeClass(component.find("readyHeader"), 'slds-hide');
                    component.set("v.instructions", response[0]);
                }else{
                    $A.util.addClass(component.find("readyHeader"), 'slds-hide'); 
                }
                console.log('First Instr::'+response[0]);
                var tempList = [];
                for(var j = 1; j < response.length; j++){
                    tempList.push(response[j]);
                }
                if(tempList.length != undefined && tempList.length > 0){
                    $A.util.removeClass(component.find("reqDocTextDiv"), 'slds-hide');
                }
                component.set("v.otherInstructions", tempList);
                //console.log('heyy',response);
                console.log('allInstructionsList::',tempList);
            } else  {
                console.log('errorrrrr');
            }
            
        });
        $A.enqueueAction(action);
        
    },
    
    showOrHideQuestionHelper : function(component, event, helper) {        
        var quesItem = event.getSource().get("v.name");
        var optionValue = event.getParam("value"); 
        var quesItemSplit = quesItem.split("-");
        var quesIndex = parseInt(quesItemSplit[0]);
        var quesId = quesItemSplit[1];
        
        //var quesList = component.get("v.appTypeQues");
        //var appTypeDiv = document.getElementById("appTypeDiv");
        //var appTypeMesDiv = document.getElementById("appTypeMesDiv");
        
        var eliTextDiv = document.getElementById("eliTextDiv");
        var eliQuesDiv = document.getElementById("eliQuesDiv");
        var eliTypeGridDiv = document.getElementById("eliTypeGridDiv");
        //var proceedButtonDiv = document.getElementById("proceedButtonDiv");
        
        //console.log('quesIndex ' + quesIndex + ' quesId ' + quesId);
        //console.log('optionValue ' + optionValue);
        
        component.set("v.eliQuesNo",0);
        //var appQuestions= component.find('appRadios');
        
        var eliQuestions= component.find('eliRadios');
        eliQuestions.forEach(function(eliQuestions) {
            eliQuestions.set("v.value","");
        })
        
        /*for(var i=quesIndex;i<appQuestions.length;i++){
            if((i+1)!=appQuestions.length){
            	appQuestions[i+1].set("v.value","");
        	}
        }*/
        
        if(optionValue == 'Yes' && quesList[quesIndex].quesId == quesId){
            console.log('quesList[quesIndex].applicationType ' + quesList[quesIndex].applicationType);
            component.set("v.applicationType",quesList[quesIndex].applicationType);
            //component.set("v.appTypeFieldDisabled",true);
            appTypeDiv.classList.remove("slds-hide");
            appTypeMesDiv.classList.add('slds-hide')
            component.find("appTypeField").set("v.value",quesList[quesIndex].applicationType);
            component.set("v.quesNo",quesIndex + 1);
            
            if(component.get("v.eliTypeQues").length > 0){
                console.log('eliTypeQuesLen ' + component.get("v.eliTypeQues").length);
                //eliQuesDiv.classList.remove("slds-hide");
                //eliTextDiv.classList.remove("slds-hide");
                eliTypeGridDiv.classList.remove("slds-hide");
                component.set("v.eliQuesNo",component.get("v.eliQuesNo") + 1);
            }
            else{
                //proceedButtonDiv.classList.remove("slds-hide");
                component.find("button1").set('v.disabled',false);
            }
        }
        else{
            appTypeDiv.classList.add("slds-hide");
            appTypeMesDiv.classList.add('slds-hide');
            component.set("v.quesNo",component.get("v.quesNo") + 1);
            var count = 0;
            var appQuestions= component.find('appRadios');
            appQuestions.forEach(function(appQuestions) {
                console.log('loopValue ' + appQuestions.get("v.value"));
                if(appQuestions.get("v.value") == 'No'){
                    count++;
                }
            })
            
            if(appQuestions.length == count){
                appTypeDiv.classList.remove("slds-hide");
                appTypeMesDiv.classList.remove('slds-hide');
                if(component.get("v.eliTypeQues").length > 0){
                    eliTypeGridDiv.classList.remove("slds-hide");
                    component.set("v.eliQuesNo",component.get("v.eliQuesNo") + 1);
                }
                //proceedButtonDiv.classList.remove("slds-hide");
                //component.set("v.appTypeFieldDisabled",false);
                component.find("appTypeField").set("v.value","");
            }
            else{
                component.find("button1").set('v.disabled',false);
                //proceedButtonDiv.classList.add("slds-hide");
                //eliQuesDiv.classList.add("slds-hide");
                //eliTextDiv.classList.add("slds-hide");
                eliTypeGridDiv.classList.add("slds-hide");
                appTypeDiv.classList.add("slds-hide");
                appTypeMesDiv.classList.add('slds-hide');
            }
        }
    },
    
    showOrHideEliQuestionHelper : function(component, event, helper){
        //var proceedButtonDiv = document.getElementById("proceedButtonDiv");
        var eliQuestions= component.find('eliRadios');
        if(eliQuestions.length != undefined){
            var answersMarked = eliQuestions.every(function eliQuestionAns(qes) {
                return qes.get("v.value") != 'No' && qes.get("v.value") != undefined;
            });
            if(component.get("v.eliQuesNo") >= eliQuestions.length && answersMarked){
                if(component.get("v.accounts") != undefined){
                    if(!$A.util.hasClass(component.find("accountPickerId"), 'slds-hide')){
                        if(component.find("accountPickerId").get("v.value") != ""){
                            component.find("button1").set('v.disabled',false);
                        }
                    }else{
                        component.find("button1").set('v.disabled',false);
                    }   
                }else{
                    component.find("button1").set('v.disabled',false);
                }                                             
            }
            else{
                component.find("button1").set('v.disabled',true);
            }
        } else {
            var valueMarked = eliQuestions.get("v.value");
            if(valueMarked != '' && valueMarked != undefined && valueMarked  == 'Yes' ){
                component.find("button1").set('v.disabled',false);
            }
            else {
                component.find("button1").set('v.disabled',true);
            }
        }           
        component.set("v.eliQuesNo",component.get("v.eliQuesNo") + 1);
        component.find("button1").set('v.disabled',false);

    },
    showNotAppTypeEliQuestionsHelper : function(component, event, helper){
        component.set("v.isDirectProceed",true);
        $A.util.removeClass(component.find("noAppTypeQuesField"), 'slds-hide');
        //var proceedButtonDiv = document.getElementById("proceedButtonDiv");
        var optionValue = event.getParam("value"); 
        component.set("v.applicationType",optionValue);
        console.log('Sd ' + optionValue);
        //proceedButtonDiv.classList.remove("slds-hide");
        //console.log('proceedButtonDiv ' + proceedButtonDiv);
        component.find("button1").set('v.disabled',false);
    },
    startApplicationHelper : function(component, event, helper){
        console.log('inside startApplicationHelper');
        // To disable button on click.
        var applicationId = "";
       let button = event.getSource();
        button.set('v.disabled',true);
        var applicationMethod = component.find("getApplicationMethod").get("v.value");
        sessionStorage.setItem("board", component.get("v.board"));
        sessionStorage.setItem("licenseType", component.get("v.licenseType"));
        sessionStorage.setItem("applicationType", applicationMethod);
        sessionStorage.setItem("flowType", "Application");
        var quesList = component.get("v.eliTypeQues");
        var notEligible = false;
        var optionJSONArr=[];
        var eliQuestions= component.find('eliRadios');
        var account = sessionStorage.getItem("accountRecordID");
        // var account = '001r000000DQcLt';
        console.log('@@@@@@@'+account);
        //eliQuestions.forEach(function(eliQuestions) {
        if(eliQuestions != undefined){
            if(component.get("v.isDirectProceed") == false){
                for(var ii=0; ii<eliQuestions.length; ii++){
                    console.log('loopValue ' + eliQuestions[ii].get("v.value"));
                    if(eliQuestions[ii].get("v.value") != quesList[ii].eliTypeQualifyingRes || eliQuestions[ii].get("v.value") == ''){
                        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            "title": "Error!",
                            "message": "You do not appear to meet the eligibility criteria for this profession at this time. Please do not apply until you meet all eligibility criteria.",
                            "type": "error"
                        });
                        toastEvent.fire();
                        notEligible = true;
                        break;
                    }
                }
            }
        }
        console.log("till here ::");
        notEligible =false;
        if(!notEligible){
            try{
                return new Promise($A.getCallback(function(resolve, reject) {
                    console.log('inside eligible::');
                    var applicationId =''; 
                    var startAnApplication = component.get('c.startAnApplication');
                    startAnApplication.setParams({"board": component.get("v.board"),
                                                  "licenseType" : component.get("v.licenseType"),
                                                  "applicationType" : component.find("getApplicationMethod").get("v.value"),
                                                  "account" : sessionStorage.getItem("accountRecordID"),
                                                  "LicenseUpgradeRecordID" : sessionStorage.getItem("LicenseRecordID")
                                                 });
                    console.log('inside params::');
                    startAnApplication.setCallback(this, function(actionResult){
                        var state = actionResult.getState();
                        if (state === "SUCCESS"){
                            console.log('inside  startAn Application::');
                            resolve(actionResult.getReturnValue());
                            
                        }
                    });
                    $A.enqueueAction(startAnApplication);
                })).then(
                    $A.getCallback(function(result){   
                        sessionStorage.setItem("header","true");
                        sessionStorage.setItem("applicationId",result);  
                        var contactRecId=component.get("v.contactRecId");
                        console.log("result::"+ result);
                        console.log('121233' + sessionStorage.getItem("applicationId"));
                        console.log('test::'+sessionStorage.getItem("header"));
                        if(sessionStorage.getItem("header")){
                            console.log('inside headertrue');
                            sessionStorage.setItem("header","true");
                            sessionStorage.setItem("applicationId",result); 
                            sessionStorage.setItem("contactRecId",contactRecId); 
                            window.location.href= $A.get("$Label.c.Polaris_Portal_URL")+'s/apply-for-license';
                        } 
                        else if(sessionStorage.getItem("header")){
                            var urlEvent = $A.get("e.force:navigateToURL");
                            console.log('%%%%%'+urlEvent);
                            var str = "/lightningwashington/s/apply-for-license";
                            console.log('$$$$$$'+str);
                            urlEvent.setParams({
                                "url": str
                            });
                            
                            console.log('****'+str);//console.log(str);
                            urlEvent.fire();}
                    }));
            }    
            catch(e){
                console.error('Error Stack Message for showQuestionHelper Helper' + e.stack);	
            }
        }
        
    },
    hideOrShowSpinner: function(component, event, helper){
        var spinner = component.find('spinner');
        $A.util.toggleClass(spinner, 'slds-hide');
    },
    fetchLicenseList  : function (component, event, helper){
        var board=component.get("v.board");
        var licenseType=component.get("v.licenseType");
        var result ='';
        try{
            return new Promise($A.getCallback(function(resolve, reject) {
                console.log('inside promise');
                var action =  component.get('c.fetchLicenseList');
                action.setParams({ "Board" : board, "LicenseType":licenseType });
                console.log(action);
                action.setCallback(this, function(response){
                    console.log('inside callback');
                    var state = response.getState();
                    if(state==='SUCCESS'){
                        resolve(response.getReturnValue());
                        // alert('success'); 
                        console.log(result);
                        // window.open(approvedURl.substring(7,approvedURl.length));
                    }
                    
                })
                $A.enqueueAction(action);
            })).then(
                $A.getCallback(function(result){
                    console.log('result',JSON.stringify(result));
                    var licwrapper = result;
                    
                    component.set("v.licenses", licwrapper);
                    if( licwrapper.length>0)
                    {
                        console.log("component.get license"+component.get("v.licenses"));
                        component.set("v.showLicenseDropdown",true);
                        //component.find("button1").set('v.disabled',true); 
                    }                       
                    else 
                    {
                        component.set("v.showLicenseDropdown",false);
                        //component.find("button1").set('v.disabled',false);
                    }
                })
            )
            
            
        } 
        catch(e){
            console.error('Error Stack Message for showQuestionHelper Helper' + e.stack);	
        }
    },
    fetchAccountList : function (component, event, helper){
        var board=component.get("v.board");
        var licenseType=component.get("v.licenseType");
        var result ='';
        //component.find("button1").set('v.disabled',false);
        try{
            return new Promise($A.getCallback(function(resolve, reject) {
                console.log('inside promise');
                var action =  component.get('c.fetchAccountList');
                action.setParams({ "Board" : board, "LicenseType":licenseType });
                console.log(action);
                action.setCallback(this, function(response){
                    console.log('inside callback');
                    var state = response.getState();
                    if(state==='SUCCESS'){
                        resolve(response.getReturnValue());
                        // alert('success'); 
                        console.log(result);
                        // window.open(approvedURl.substring(7,approvedURl.length));
                    }
                    
                })
                $A.enqueueAction(action);
            })).then(
                $A.getCallback(function(result){
                    console.log('result accounts list',JSON.stringify(result));
                    var accwrapper = result;
                    var accountList = [];
                    var courseList = [];
                    var businessList = [];
                    
                    accountList = accwrapper.lstAccount;
                    if(accountList != undefined && accountList !='' &&  (accwrapper.accountType == 'Business' || accwrapper.accountType == 'Course' )){
                        for(var i in accountList){
                            var accRecord = accountList[i];
                            if(accRecord.RecordType.Name = 'Course Provider' && accRecord.Course_Provider__c){
                                courseList.push(accRecord);
                            }else if(accRecord.RecordType.Name = 'Business Account'){
                                businessList.push(accRecord);
                            }
                        }    
                        
                        if(accwrapper.accountType == 'Business'){
                            component.set("v.accounts", businessList);
                            var v = document.getElementById("accountPickerId");
                            v.classList.remove('slds-hide');
                            console.log("component.get"+component.get("v.accounts"));
                            component.find("button1").set('v.disabled',false);
                            if(component.get("v.accounts") == ''){
                                var toastEvent = $A.get("e.force:showToast");
                                toastEvent.setParams({
                                    "title": "No Business Account!",
                                    "message": "Please add atleast one business account to  proceed."
                                });
                                toastEvent.fire();
                            }
                            
                        } else if(accwrapper.accountType == 'Course' ){
                            component.set("v.accounts", courseList);
                            console.log("component.get"+component.get("v.accounts"));
                            var v = document.getElementById("accountPickerId");
                            v.classList.remove('slds-hide');
                            component.set("v.showAccountDropdown",true);
                            component.find("button1").set('v.disabled',true);
                            if(component.get("v.accounts") == ''){
                                var toastEvent = $A.get("e.force:showToast");
                                toastEvent.setParams({
                                    "title": "No Course Account!",
                                    "message": "Please add atleast one course account to  proceed."
                                });
                                toastEvent.fire();
                            }
                        }
                    } 
                    else {
                        if(accwrapper.accountType == 'Business'){
                            component.set("v.showAccountDropdown",false);
                            //alert('No business');
                            var toastEvent = $A.get("e.force:showToast");
                            toastEvent.setParams({
                                "title": "No Business Account!",
                                "message": "Please create atleast one business account to  proceed."
                            });
                            toastEvent.fire();
                        } 
                        else if(accwrapper.accountType == 'Course') {
                            component.set("v.showAccountDropdown",false);
                            var toastEvent = $A.get("e.force:showToast");
                            toastEvent.setParams({
                                "title": "No Course Account!",
                                "message": "Please add atleast one course account to  proceed."
                            });
                            toastEvent.fire();
                        }
                            else {
                                component.set("v.showAccountDropdown",true);
                                component.set("v.accounts", null);
                            }
                        
                    }
                    
                })
            )
            
            
        } 
        catch(e){
            console.error('Error Stack Message for showQuestionHelper Helper' + e.stack);	
        }
    },
    getAccountName : function (component, event, helper){
        var AccountName = event.getParam("acccountName");
        component.set("v.Get_Result", AccountName);
    },
    firePassValueEventHelper : function (component, event, helper){
        component.find("button1").set('v.disabled',false);
        if(component.find("accountPickerId") != undefined){
             var pickerValue = component.find("accountPickerId").get("v.value");
        if(pickerValue)
            console.log('Check ');
        else
            pickerValue = component.get("v.selectedAccountId");
        var getEligibility = document.getElementById("eliTypeGridDiv").classList.contains('slds-hide');
        console.log("pickerValue"+pickerValue);
        
        var eliQuestions= component.find('eliRadios');
        var questionsChecker = false;
        if(eliQuestions != undefined){
            if(eliQuestions.length != undefined){
                var answersMarked = eliQuestions.every(function eliQuestionAns(qes) {
                    return qes.get("v.value") != 'No' && qes.get("v.value") != undefined;
                });
                if(answersMarked){
                    questionsChecker = true;
                } else {
                    questionsChecker = false;
                }
            }
        }else{
            questionsChecker = true;
        }
        if(getEligibility) {
            if(pickerValue != "" && questionsChecker){
                component.find("button1").set('v.disabled',false);
                
            } else {
                component.find("button1").set('v.disabled',false);
            }
        } else if(pickerValue != "" && questionsChecker) {
            component.find("button1").set('v.disabled',false);
            
        } else {
            component.find("button1").set('v.disabled',false);
        }
        
        sessionStorage.setItem("accountRecordID",pickerValue);
        }
       
        
    },
    firePassLicenseValueEventHelper : function (component, event, helper){
        var pickerValue = component.find("licensePickerId").get("v.value");
        
        //component.set("LicenseUpgradeRecordID",pickerValue);
        console.log("pickerValue"+pickerValue);
        if(pickerValue != ""){
            component.find("button1").set('v.disabled',false);
        }else {
            component.find("button1").set('v.disabled',true);
        }
        sessionStorage.setItem("LicenseRecordID",pickerValue);
    },
    setApplicationTypeHelper : function (component, event, helper){
        var appTypeValue = component.find("appTypeField").get("v.value");  
    }
})