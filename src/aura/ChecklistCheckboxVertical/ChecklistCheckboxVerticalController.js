({
	/*
	* If the question is in the current section, this finds all the checked responses, then
	* passes them as a comma seperated string to the helper's handleResponse method
	* @param component
	* @param event
	* @param helper
	* @return void
	*
	*/
	saveAnswer : function(component, event, helper) {

			if(helper.isInCurrentSection(component, event)) {

            var response = [];
            var nameResponse = [];
            var inputs = component.find("checkbox").getElement().querySelectorAll("input"); 
            // querySelectorAll returns NodeList
           	var name;
           	for (var i=0;i<inputs.length;i++) {
           		if (inputs[i].checked) {
           			response.push(inputs[i].value);
           			name = helper.trimResponseId(inputs[i].id);
           			nameResponse.push(name);
           		}
           	}

           	response = response.join(); // convert array to comma-seperated string
            nameResponse = nameResponse.join();

			helper.handleResponse(component, response, nameResponse);

        }
	},


	/*
	* Handles setting up this question's choices attribute.
	*/

	doInit : function(component, event, helper) {

		helper.handleReadMode(component);
		var choices = component.get("v.question.choices");
        component.set("v.choices", choices);
	},

	/*
	*
	* This event fires once the component has rendered, and sets up any defaults/previous answers
	* 
	*/

	getChecked : function(component, event, helper) {
		
		if(!component.get("v.isDoneRendering")) {

			component.set("v.isDoneRendering", true); // this function runs only once on initial rendering

			var responses = component.get("v.question.response.BGCK__Actual_Value2__c");
			if(responses) {
				responses = responses.split(',');
			
				// get the array of checkbox inputs and set to selected if their name is found within the array of responses
				var options = component.find("checkbox").getElement().querySelectorAll("input");
				var selected = [];
				for (var i=0;i<options.length;i++) {
					if (responses.includes(options[i].value)) {
						options[i].checked = true;
						selected.push(options[i].value);
					}
				}

				var subQuestions = component.get("v.subQuestions");
				if(subQuestions.length > 0) {
					helper.manageSubQuestions(component, subQuestions, selected);
				}
			}
		}
	},

	/*
	* This function handles user interaction with the checkboxes. It passes the currently selected answers to a helper
	* function, which handles showing/hiding of dependent questions.
	*
	*
	*/

	handleSubQuestions : function(component, event, helper) {

		var subQuestions = component.get("v.subQuestions");
		var inputs = component.find("checkbox").getElement().querySelectorAll("input");
		var selected = [];
		if(subQuestions.length > 0) {

			for (var i=0;i<inputs.length;i++) {
				if (inputs[i].checked) {
					selected.push(inputs[i].value);
				}
			}

			helper.manageSubQuestions(component, subQuestions, selected);
		}
	}

})