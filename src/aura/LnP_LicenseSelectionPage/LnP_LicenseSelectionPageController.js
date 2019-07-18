({
	doInit : function(component, event, helper) {
       console.log('check if temporary license selected');
     //  helper.restrictTemporaryLicenses(component,event,helper);
     var accountID = helper.getUrlParam('accId');
        if(accountID){
            component.set("v.selectedAccountId",accountID);
            sessionStorage.setItem("accountRecordID",accountID);
        }  
	},
    resetAttributes :  function(component, event, helper){
        helper.resetAttributesHelper(component, event, helper);
    },
    fetchAppTypeEliQuestions : function(component, event, helper){
       
    	helper.fetchAppTypeEliQuestionsHelper(component, event, helper);
	},
    showOrHideQuestion : function(component, event, helper){
        helper.showOrHideQuestionHelper(component, event, helper);
    },
    showOrHideEliQuestion : function(component, event, helper){
        helper.showOrHideEliQuestionHelper(component, event, helper);
    },
    showNotAppTypeEliQuestions : function(component, event, helper){
       helper.showNotAppTypeEliQuestionsHelper(component, event, helper); 
    },
    startApplication : function(component, event, helper){
            helper.startApplicationHelper(component, event, helper);    
    },
    firePassValueEvent : function (component, event, helper){
        console.log("SD");
        helper.firePassValueEventHelper(component, event, helper);
    },
    firePassLicenseValueEvent : function (component, event, helper){
    	helper.firePassLicenseValueEventHelper(component, event, helper);
    },
    setApplicationType : function(component, event, helper){
        helper.firePassValueEventHelper(component, event, helper);
    }
})