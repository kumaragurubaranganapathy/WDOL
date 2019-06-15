({

	/*
	* On initialization, calls helper method (in ChecklistQuestions), which handles the checklist being in read mode or edit mode.
	*
	*/

	doInit : function(component, event, helper) {

		helper.handleReadMode(component);
	},
	
	/*
	* If the question is in the section that the user is trying to save, passes the response from this question
	* into the helper method of ChecklistQuestions.
	*
	*
	*/
	saveAnswer : function(component, event, helper) {

        if(helper.isInCurrentSection(component, event)) {

        	var response = component.find("checklistDate").get("v.value");            
            var dateFormat = "YYYY-MM-DD";
            var userLocaleLang = $A.get("$Locale.LangLocale");
            var dateString;
            try {
            	dateString = $A.localizationService.formatDateTime(response, dateFormat,userLocaleLang)
            } catch (e) {
            	dateString = response;
            }
            helper.handleResponse(component, dateString);
        }
    }
})