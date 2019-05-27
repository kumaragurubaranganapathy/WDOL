({
    //To reset the values when there is change in program type....
    resetAttributesHelper :  function(component, event, helper){
        var eliTypeGridDiv = document.getElementById("eliTypeGridDiv");
        //var eliTextDiv = document.getElementById("eliTextDiv");
        //var eliQuesDiv = document.getElementById("eliQuesDiv");
        //var proceedButtonDiv = document.getElementById("proceedButtonDiv");
        
        $A.util.removeClass(component.find("licenseType"), 'slds-hide');
        $A.util.removeClass(component.find("credentialType"), 'slds-hide');	
        $A.util.removeClass(component.find("getApplicationMethod"), 'slds-hide');
        
        eliTypeGridDiv.classList.add("slds-hide");
        //proceedButtonDiv.classList.add("slds-hide");        
        component.find("button1").set('v.disabled',true);
    },
    fetchAppTypeEliQuestionsHelper : function(component, event, helper) {
		var board = component.find("board").get("v.value");
        var licenseType = component.find("licenseType").get("v.value");
        var applicationMethod = component.find("getApplicationMethod").get("v.value");
        
        //var appTypeGridDiv = document.getElementById("appTypeGridDiv");
        //var appQuesDiv = document.getElementById("appQuesDiv");
        //var appTypeDiv = document.getElementById("appTypeDiv");
        //var appTypeTextDiv = document.getElementById("appTypeTextDiv");
        
        var eliTypeGridDiv = document.getElementById("eliTypeGridDiv");
        //var eliTextDiv = document.getElementById("eliTextDiv");
        //var eliQuesDiv = document.getElementById("eliQuesDiv");
		//var proceedButtonDiv = document.getElementById("proceedButtonDiv");
        
        var parentObjectAPIName = '';
        if(applicationMethod == 'General Application' || applicationMethod == 'Comity' ){
            parentObjectAPIName = 'MUSW__License2__c';
        } 
        
        //console.log("board " + board + " licenseType " + licenseType + "applicationMethod " + applicationMethod);
        component.set("v.board",board);
        component.set("v.licenseType",licenseType);
        
        //appQuesDiv.classList.add("slds-hide");
        //appTypeGridDiv.classList.add("slds-hide");
        eliTypeGridDiv.classList.add("slds-hide");
        //proceedButtonDiv.classList.add("slds-hide");
        component.find("button1").set('v.disabled',true);
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
                    helper.fetchAccountList(component, event, helper);                   
                    
                    helper.hideOrShowSpinner(component, event, helper);
                    if(applicationMethod){  
                      window.setTimeout(
                      $A.getCallback(function() {
                          eliTypeGridDiv.classList.remove("slds-hide");
                          component.set("v.eliQuesNo",1);
                          if(eliQuesList.length == 0){
                              eliTypeGridDiv.classList.add("slds-hide");
                              //proceedButtonDiv.classList.remove("slds-hide");
                              if(component.get("v.showAccountDropdown") == true){
                                  component.find("button1").set('v.disabled',true);
                              }else {
                                  component.find("button1").set('v.disabled',false);
                              }                              
                          }
                          //var eliChild = document.getElementById('eliQuesDiv').children;
                          //for(var i=0; i<eliChild.length; i++){
                          //eliChild[0].classList.remove("slds-hide");
                          //}
                      }), 1000);
                    }
                 } 
            });
            $A.enqueueAction(action);
        }
    	}
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
        eliQuestions.forEach(eliQuestions => {
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
        	appQuestions.forEach(appQuestions => {
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
                component.find("button1").set('v.disabled',true);
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
                return qes.get("v.value") != '' && qes.get("v.value") != undefined;
            });
            if(component.get("v.eliQuesNo") >= eliQuestions.length && answersMarked){
                component.find("button1").set('v.disabled',false);
            }
            else{
                component.find("button1").set('v.disabled',true);
            }
        }else {
            var valueMarked = eliQuestions.get("v.value");
            if(valueMarked != '' && valueMarked != undefined ){
                component.find("button1").set('v.disabled',false);
            }
            else {
                component.find("button1").set('v.disabled',true);
            }
        }           
        component.set("v.eliQuesNo",component.get("v.eliQuesNo") + 1);
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
        // To disable button on click.
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
        //eliQuestions.forEach(eliQuestions => {
        if(eliQuestions != undefined){
            if(component.get("v.isDirectProceed") == false){
                for(var ii=0; ii<eliQuestions.length; ii++){
                    console.log('loopValue ' + eliQuestions[ii].get("v.value"));
                    if(eliQuestions[ii].get("v.value") != quesList[ii].eliTypeQualifyingRes || eliQuestions[ii].get("v.value") == ''){
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
        }
        var applicationId = '';
        if(!notEligible){
            try{
                const server = component.find('server');
                const startAnApplication = component.get('c.startAnApplication');
                server.callServer(
                    startAnApplication,{board: component.get("v.board"),
										licenseType: component.get("v.licenseType"),
										applicationType: applicationMethod,
                                        account :account},"",
                    $A.getCallback(response => {
						applicationId=response;
                        console.log("applicationId::"+applicationId);
						sessionStorage.setItem("applicationId", applicationId);
                        sessionStorage.setItem("header",component.get("v.header"));
                        debugger;
						window.location.href = $A.get("$Label.c.Polaris_Portal_Home")+'apply-for-license/';
						}),
						$A.getCallback(errors => {
						}),
						false,""
					);
        } 
        catch(e){
            console.error('Error Stack Message for showApplication Helper' + e.stack);	
        }
        }
		
    },
    hideOrShowSpinner: function(component, event, helper){
        var spinner = component.find('spinner');
        $A.util.toggleClass(spinner, 'slds-hide');
    },
        
    fetchAccountList : function (component, event, helper){
        var board=component.get("v.board");
        var licenseType=component.get("v.licenseType");
        var result ='';
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
                    console.log('result',JSON.stringify(result));
                    var accwrapper = result;
                    
                    component.set("v.accounts", accwrapper.lstAccount);
                    if(accwrapper.accountType == 'Business' ){
                        console.log("component.get"+component.get("v.accounts"));
                        component.set("v.showAccountDropdown",true);
                        //component.find("button1").set('v.disabled',true);
                    } else {
                       component.set("v.showAccountDropdown",false);
                        //component.find("button1").set('v.disabled',false);
                    }
                })
            )
            
            
        } 
        catch(e){
            console.error('Error Stack Message for showQuestionHelper Helper' + e.stack);	
        }
    },
    firePassValueEventHelper : function (component, event, helper){
        var pickerValue = component.find("accountPickerId").get("v.value");
        console.log("pickerValue"+pickerValue);
        if(pickerValue != "--None--"){
            component.find("button1").set('v.disabled',false);
        }else {
            component.find("button1").set('v.disabled',true);
        }
        sessionStorage.setItem("accountRecordID",pickerValue);
    },
    setApplicationTypeHelper : function (component, event, helper){
          var appTypeValue = component.find("appTypeField").get("v.value");  
    }
})