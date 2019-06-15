({
	/*
	* 
	* Finds the question's choices and passes them to the choices attribute of the component. Calls helper method to handle whether the checklist is in read mode.
	* @param component
	* @param event
	* @param helper
	* @return void
	*
	*
	*/
	doInit : function(component, event, helper) {

		var choices = component.get("v.question.choices");
		component.set("v.choices", choices);
		helper.handleReadMode(component);
	},

	/*
	* If the question is within the current section, this method gets  the selected answer and passes it as a string
	* to the helper method (found within the ChecklistQuestion abstract component)
	* @param component
	* @param event
	* @param helper
	* @return void
	* 
	*/
	saveAnswer : function(component, event, helper) {
        
        if(helper.isInCurrentSection(component, event)) {
            
           	var select = component.find("bgck-select");
           	var nameResponse = select.get("v.value");
           	if (nameResponse === "Not Answered Yet") {
           		nameResponse = "";
           	}
           	var response = "";
     		var choices = component.get("v.choices");
     		choices.forEach(function(choice){
     			if(choice.Name === nameResponse && choice.BGCK__Display_Value__c) {
     				
     				response = choice.BGCK__Display_Value__c;

     			}
     		});

     		if (response.length < 1) {
     			response = nameResponse;
     		}

     		helper.handleResponse(component, response, nameResponse);
     		
           	
        }

	},

	/*
	*
	* After rendering, sets the selected attribute for any default or previously answered responses
	* @param component
	* @param event
	* @param helper
	* @return void
	*/

	showSubQs : function(component, event, helper) {

		var done = component.get("v.isDoneRendering");
		if(!done) { // only run this function on the first rendering

			var response = component.get("v.question.response.BGCK__Actual_Value2__c");
			var selected = [component.find("bgck-select").get("v.value")];
			if (response){

				var subQuestions = component.get("v.subQuestions");
				
				if(subQuestions.length > 0) {
			
					helper.manageSubQuestions(component, subQuestions, selected);
				}
			}

			component.set("v.isDoneRendering", true);
		}

	},

	/*
	* When the picklist changes value, this sets things up to display the appropriate subquestions
	* @param component
	* @param event
	* @param helper
	* @return void
	*
	*/

	handleSubQuestions : function(component, event, helper) {
		var subQuestions = component.get("v.subQuestions");
		var response= component.find("bgck-select").get("v.value");
		var selected = [response];
		if(subQuestions.length > 0) {
			
			helper.manageSubQuestions(component, subQuestions, selected);
		}
	}

})