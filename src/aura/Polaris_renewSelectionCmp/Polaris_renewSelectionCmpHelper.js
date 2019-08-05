({
    fetchAppTypeEliQuestionsHelper: function (component, event, helper) {
        var board = sessionStorage.getItem("board");
        var licenseType = sessionStorage.getItem("licenseType");
        var applicationMethod = sessionStorage.getItem("applicationType");
        var renewalReinstate = sessionStorage.getItem("flowType");
        var licID = sessionStorage.getItem("licId");
        component.set("v.RenewReinstate", renewalReinstate);
        component.set("v.board", board);
        component.set("v.licenseType", licenseType);
        component.set("v.appMethod", applicationMethod);
        component.set("v.licID", licID);

        var eliTypeGridDiv = document.getElementById("eliTypeGridDiv");
        var proceedButtonDiv = document.getElementById("proceedButtonDiv");

        var parentObjectAPIName = '';
        if (applicationMethod == 'General Application' || applicationMethod == 'Comity') {
            parentObjectAPIName = 'Renewal_Application__c';
        }


        //eliTypeGridDiv.classList.add("slds-hide");
        //proceedButtonDiv.classList.add("slds-hide");

        component.set("v.isDirectProceed", false);
        component.set("v.quesNo", 0);
        var appQuesList = [];
        var eliQuesList = [];

        if (applicationMethod != '') {
            if (licenseType != '') {
                var action = component.get("c.questionForLicenceTyep");
                component.set("v.spinner", true);
                helper.hideOrShowSpinner(component, event, helper);
                action.setParams({
                    "Board": board,
                    "LicenseType": licenseType,
                    "ApplicationType": applicationMethod,
                    "parentObjectAPIName": parentObjectAPIName,
                    "renewalReinstate": renewalReinstate
                });
                action.setCallback(this, function (actionResult) {
                    var state = actionResult.getState();
                    if (state === "SUCCESS") {
                        var response = actionResult.getReturnValue();
                        console.log('response ' + JSON.stringify(response));
                        for (var key in response) {
                            if (response[key].Eli_Ques_determines_App_Type__c == true) {
                                appQuesList.push({ "quesId": key, "quesBody": response[key].Question_Body__c, "appTypeQualifyingRes": response[key].Qualifying_Response__c, "order": response[key].Order_Number__c, "appTypeEliQues": response[key].Eli_Ques_determines_App_Type__c, "applicationType": response[key].Application_Method__c });
                                component.set("v.appTypeQues", appQuesList);
                            }
                            else {
                                eliQuesList.push({ "quesId": key, "quesBody": response[key].Question_Body__c, "eliTypeQualifyingRes": response[key].Qualifying_Response__c, "order": response[key].Order_Number__c, "appTypeEliQues": response[key].Eli_Ques_determines_App_Type__c, "applicationType": response[key].Application_Method__c });
                                component.set("v.eliTypeQues", eliQuesList);
                            }
                        }
                        console.log('eliQuesList ' + JSON.stringify(eliQuesList));

                        component.set("v.isDirectProceed", false);
                        // helper.fetchAccountList(component, event, helper);
                        helper.fetchApplicationInstructionHelper(component, event, helper);
                        helper.hideOrShowSpinner(component, event, helper);
                        if (applicationMethod) {
                            window.setTimeout(
                                $A.getCallback(function () {
                                   // eliTypeGridDiv.classList.remove("slds-hide");
                                    component.set("v.eliQuesNo", 1);
                                    if (eliQuesList.length == 0) {
                                     //   eliTypeGridDiv.classList.add("slds-hide");

                                    }
                                }), 1000);
                        }
                    }
                });
                $A.enqueueAction(action);
            }
        }
    },

    showOrHideEliQuestionHelper: function (component, event, helper) {
        var proceedButtonDiv = document.getElementById("proceedButtonDiv");
        var eliQuestions = component.find('eliRadios');
        var answersMarked = eliQuestions.every(function eliQuestionAns(qes) {
            return qes.get("v.value") != '' && qes.get("v.value") != undefined;
        });
        if (component.get("v.eliQuesNo") >= eliQuestions.length && answersMarked) {
            // proceedButtonDiv.classList.remove("slds-hide");
        }
        else {
            // proceedButtonDiv.classList.add("slds-hide");
        }
        component.set("v.eliQuesNo", component.get("v.eliQuesNo") + 1);
    },
    startApplicationHelper: function (component, event, helper) {
        sessionStorage.setItem("renewalReinstate", component.get("v.RenewReinstate"));
        sessionStorage.setItem("board", component.get("v.board"));
        sessionStorage.setItem("licenseType", component.get("v.licenseType"));
        sessionStorage.setItem("applicationType", component.get("v.appMethod"));
        sessionStorage.setItem("licId", component.get("v.licID"));
        sessionStorage.setItem("flowType", "Application");

        var quesList = component.get("v.eliTypeQues");

        var notEligible = false;
        var optionJSONArr = [];
        var eliQuestions = component.find('eliRadios');
        var account = sessionStorage.getItem("accountRecordID");
        console.log('account record id in renewal--' + account);
        //eliQuestions.forEach(function(eliQuestions){
        if (component.get("v.isDirectProceed") == false && eliQuestions != undefined) {
            for (var ii = 0; ii < eliQuestions.length; ii++) {
                console.log('loopValue ' + eliQuestions[ii].get("v.value"));
                if (eliQuestions[ii].get("v.value") != quesList[ii].eliTypeQualifyingRes || eliQuestions[ii].get("v.value") == '') {
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Error!",
                        "message": "You are not eligible for this application.",
                        "type": "error"
                    });
                    toastEvent.fire();
                    notEligible = true;
                    break;
                }
            }
        }

        var applicationId = '';
        if (!notEligible) {
            try {
                const server = component.find('server');
                const startAnApplication = component.get('c.startRenewalApplication');
                server.callServer(
                    startAnApplication, {
                        board: component.get("v.board"),
                        licenseType: component.get("v.licenseType"),
                        applicationType: component.get("v.appMethod"),
                        account: account,
                        isRenewal: true,
                        licId: component.get("v.licID")
                    }, "",
                    $A.getCallback(function (response) {
                        console.log('in cal back');
                        applicationId = response;
                        sessionStorage.setItem("applicationId", applicationId);
                        console.log('applicationId ' + applicationId);
                        var accURL = window.location.href;
                        var accUrlShort = accURL.slice(0, accURL.lastIndexOf("/"));
                        accUrlShort = accUrlShort + "/polaris-renewal";//+ applicationId;
                        console.log('URL of a particular account: ' + accUrlShort);
                        var urlEvent = $A.get("e.force:navigateToURL");
                        urlEvent.setParams({
                            "url": accUrlShort
                        });
                        urlEvent.fire();
                    }),
                    $A.getCallback(function (errors) {
                    }),
                    false, ""
                );
            }
            catch (e) {
                console.error('Error Stack Message for showApplication Helper' + e.stack);
            }
        }

    },
    hideOrShowSpinner: function (component, event, helper) {
        var spinner = component.find('spinner');
        $A.util.toggleClass(spinner, 'slds-hide');
    },

    fetchApplicationInstructionHelper: function (component, event, helper) {
        var board = component.get("v.board");
        var licenseType = component.get("v.licenseType");
        var applicationMethod = component.get("v.appMethod");
        var action = component.get("c.fetchInstructions");
        action.setParams({
            "Board": board,
            "LicenseType": licenseType,
            "ApplicationType": applicationMethod
        });
        action.setCallback(this, function (actionResult) {
            var state = actionResult.getState();
            if (state === "SUCCESS") {
                var response = actionResult.getReturnValue();
                console.log('Response::' + response);
                if(response[0] != 'null'){
                    
                    $A.util.removeClass(component.find("readyHeader"), 'slds-hide');
                    component.set("v.instructions", response[0]);
                }else{
                    $A.util.addClass(component.find("readyHeader"), 'slds-hide'); 
                }
                console.log('First Instr::' + response[0]);
                var tempList = [];
                for (var j = 1; j < response.length; j++) {
                    tempList.push(response[j]);
                }
                if (tempList.length != undefined && tempList.length > 0) {
                    $A.util.removeClass(component.find("reqDocTextDiv"), 'slds-hide');
                }
                component.set("v.otherInstructions", tempList);
                console.log('allInstructionsList::', tempList);
            } else {
                console.log('errorrrrr');
            }
        });

        $A.enqueueAction(action);
    }
})