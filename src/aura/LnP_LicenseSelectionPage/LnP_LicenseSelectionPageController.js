({
	doInit : function(component, event, helper) {
       console.log('check if temporary license selected');
      // helper.getAccountName(component, event, helper);
     //  helper.restrictTemporaryLicenses(component,event,helper);
     var accountID = helper.getUrlParam('accId');
        if(accountID){
          component.set("v.selectedAccountId",accountID);
           // 
           
            sessionStorage.setItem("accountRecordID",accountID);
        }        
	},
    resetAttributes :  function(component, event, helper){
        helper.resetAttributesHelper(component, event, helper);
    },
    fetchAppTypeEliQuestions : function(component, event, helper){
       component.find("button1").set('v.disabled',true);
         helper.firePassValueEventHelper(component, event, helper);
    	helper.fetchAppTypeEliQuestionsHelper(component, event, helper);
       
	},
    showOrHideQuestion : function(component, event, helper){
        component.find("button1").set('v.disabled',true);
        helper.showOrHideQuestionHelper(component, event, helper);
    },
    showOrHideEliQuestion : function(component, event, helper){
        component.find("button1").set('v.disabled',true);
        helper.firePassValueEventHelper(component, event, helper);
        helper.showOrHideEliQuestionHelper(component, event, helper);
       
    },
    showNotAppTypeEliQuestions : function(component, event, helper){
       helper.showNotAppTypeEliQuestionsHelper(component, event, helper); 
        helper.firePassValueEventHelper(component, event, helper);
    },
    startApplication : function(component, event, helper){
            
            
    },
    firePassValueEvent : function (component, event, helper){
        console.log("SD");
        helper.firePassValueEventHelper(component, event, helper);
    },
    firePassLicenseValueEvent : function (component, event, helper){
    	helper.firePassLicenseValueEventHelper(component, event, helper);
    },
	goBack : function (component, event, helper){
    	window.history.back();
    },
    setApplicationType : function(component, event, helper){
        helper.firePassValueEventHelper(component, event, helper);
    },
    getAccountName : function(component, event, helper){
       helper.getAccountName(component, event, helper);
    },
    resetApplicationMethod: function(component, event, helper){
        component.find("getApplicationMethod").set('v.value',"");
        component.find("button1").set('v.disabled',true);
        $A.util.addClass(component.find("accountPickerId"), "slds-hide");
        helper.fetchAppTypeEliQuestionsHelper(component, event, helper);
    },
    validateForm : function(component,event,helper) {
        var accountRec = component.find("accountPickerId");
        
        var getEligibility = document.getElementById("eliTypeGridDiv").classList.contains('slds-hide');
        
        
        if(accountRec == undefined && getEligibility ) {
            helper.startApplicationHelper(component, event, helper);         
        }
        else if(!getEligibility && accountRec == undefined) {
            var eliQuestions= component.find('eliRadios');
            var answersMarked = true;
            if(component.get("v.eliTypeQues").length == 1){
                if(eliQuestions.get('v.value') != 'Yes') {
                    answersMarked = false;
                }
                
            } else {
                answersMarked = eliQuestions.every(function eliQuestionAns(qes) {
                    return qes.get("v.value") != 'No' && qes.get("v.value") != undefined;
                });  
            }

            if(!answersMarked){
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Failure!",
                    "message": "You do not appear to meet the eligibility criteria for this profession at this time. Please do not apply until you meet all eligibility criteria",
                    "type": "Error"
                });
                toastEvent.fire();
                component.find("button1").set('v.disabled',true);
            } else {
                component.find("button1").set('v.disabled',false);
                helper.startApplicationHelper(component, event, helper);
            }
        } else if(getEligibility && accountRec != undefined){
            var pickerValue = component.find("accountPickerId").get("v.value");
            if(pickerValue != ""){
                component.find("button1").set('v.disabled',false);
                helper.startApplicationHelper(component, event, helper);
            } else {
                component.find("button1").set('v.disabled',true);
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Failure!",
                    "message": "Please select account to proceed if account is not present please create business account and then apply ",
                    "type": "Error"
                });
                toastEvent.fire();
                component.find("button1").set('v.disabled',true);
            }
        } else if(!getEligibility && accountRec != undefined) {
            var pickerValue = component.find("accountPickerId").get("v.value");
            var eliQuestions= component.find('eliRadios');
            var answersMarked = true;
            if(component.get("v.eliTypeQues").length == 1){
                if(eliQuestions.get('v.value') != 'No') {
                    answersMarked = true;
                }
                
            } else {
                answersMarked = eliQuestions.every(function eliQuestionAns(qes) {
                    return qes.get("v.value") != 'No' && qes.get("v.value") != undefined;
                });  
            }
            if(pickerValue == '' || !answersMarked) {
               component.find("button1").set('v.disabled',true);
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Failure!",
                    "message": "Please do not apply until you meet all eligibility criteria",
                    "type": "Error"
                });
                toastEvent.fire();
                component.find("button1").set('v.disabled',true);
            } else {
                component.find("button1").set('v.disabled',false);   
                helper.startApplicationHelper(component, event, helper);
            }
        }
    }
    
})