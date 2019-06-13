({
	doInit : function(component, event, helper) {
		//helper.setFields(component, event, helper, 'Cosmetology and Barber Board', 'Cosmetologist', 'Examination');
        var sectionList  ='';
		var sectionJSON = '[{"header": "Background Information", "icon":"LnP_BackgroundInformation.svg"},{"header": "Personal Information", "icon":"LnP_PersonalInfo.svg"},{"header": "Questions Answers", "icon":"LnP_QuestionsAnswers.svg"},{"header": "Attachments", "icon":"LnP_Attachments.svg"},{"header": "Review and Submit", "icon":"LnP_ReviewnSubmit.svg"}]';
        sectionList = JSON.parse(sectionJSON);
        component.set("v.section", sectionList);
        component.set("v.totalTabs", sectionList.length);
		
        var questionList  ='';
		//var questionJSON = '[{"label": "Text Input", "type": "text"},{"label": "Picklist", "type":"picklist","options":[{"id":"Accountancy"},{"id":"Acupunture"}]},{"label": "Radio", "type":"radio","options":[{"id":"Yes"},{"id":"No"}]}]';
        //questionList = JSON.parse(questionJSON);
        //component.set("v.questionsList", questionList);
		
		var ApplicationList = '';
		var sectionBackGroundJSON = '[{"label": "Select Board", "type": "Picklist","options":[{"id":"--None--"},{"id":"Accountancy"},{"id":"Cosmetology and Barber Board"},{"id":"Funneral"}]},{"label": "License Type", "type": "Picklist","options":[{"id":"--None--"},{"id":"Cosmetologist"},{"id":"Cosmetology Instructor"},{"id":"Courtesy Card Permit"}]},{"label": "Application Type", "type": "Picklist","options":[{"id":"--None--"},{"id":"Examination"},{"id":"General Application"},{"id":"Residential"}]}]';
        ApplicationList = JSON.parse(sectionBackGroundJSON);
		component.set("v.questionsList", ApplicationList);
	},
        previousTab : function(component, event, helper) {
		helper.goToPreviousTab(component, event);
	},
    nextTab : function(component, event, helper) {
		helper.goToNextTab(component, event);
	}
})