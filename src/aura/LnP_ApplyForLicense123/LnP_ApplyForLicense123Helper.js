({
	setFields:function(component,event, helper, inputCmp, inputCmp1, inputCmp2){
		var action = component.get("c.fetchQuestions4");
		action.setParams({
			"Board": inputCmp, 
			"LicenseType": inputCmp1, 
			"ApplicationType": inputCmp2
		});
		action.setCallback(this, function(actionResult){
			var state = actionResult.getState();
			var questions = [];
			var arrayMapValues;
			if (state === "SUCCESS"){
				var result = actionResult.getReturnValue();
				for (var key in result){
                    questions.push({"label": result[key].Question_Body__c, "type": result[key].Data_Type__c, "options": result[key].Possible_Responses__c});
				}
				component.set('v.questionsList', questions);
                console.log('questions'+JSON.stringify(questions));
			}            
		});  
		$A.enqueueAction(action);
	},
    goToPreviousTab : function(component, event) {
    	var tabNumber = component.get("v.currentTab");
        component.set("v.currentTab", tabNumber-1);
    },
    goToNextTab : function(component, event, inputCmp, inputCmp1, inputCmp2){
        var curTab= component.get("v.currentTab");		
		var tabNumber = component.get("v.currentTab");
		component.set("v.currentTab", tabNumber+1);
		var action = component.get("c.QuestionMethod");
		action.setParams({
			"Board": inputCmp, 
			"LicenseType": inputCmp1, 
			"ApplicationType": inputCmp2
		});
		action.setCallback(this, function(actionResult){
			var state = actionResult.getState();
			if (state === "SUCCESS"){
				var result = actionResult.getReturnValue();
				component.set('v.ApplicationList', result);
                alert('result--'+result);
			}            
		});  
		$A.enqueueAction(action);
    }
})