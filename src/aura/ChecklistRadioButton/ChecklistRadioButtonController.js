({

	/*
	* On initialization of this component, handles read mode and sets up the array of choices for this question.
	* @param component
	* @param event
	* @param helper
	*
	*/
	doInit : function(component, event, helper) {

		helper.handleReadMode(component);
		var choices = component.get("v.question.choices");
        component.set("v.choices", choices);
	},

	/*
	* Checks if this is the first rendering, and if it is, displays previous/default answers, and any sub-questions that
	* might be needed.
	* @param component
	* @param event
	* @param helper
	*
	*/

	getChecked : function(component, event, helper) {
		
		if(!component.get("v.isDoneRendering")) {
			
			component.set("v.isDoneRendering", true);
			var response = component.get("v.question.response.BGCK__Actual_Value2__c");
			if (response) {
				
				var  options = component.find("bgck-radio");
				var selected = [];
				if (options) {
					options.forEach(function(option){
						var input = option.getElement();
                        var inputValue = helper.getElementValue(input);
						if(response === inputValue) {
							input.checked = true;
							selected.push(inputValue);
						}
					});
				}
				
				var subQuestions = component.get("v.subQuestions");
				
				if(subQuestions.length > 0) {
					helper.manageSubQuestions(component, subQuestions, selected);
				}
			}


		}


	},

	/*
	* Change handler for the radio buttons. Displays/hides any subquestions.
	* @param component
	* @param event
	* @param helper
	*
	*/

	handleSubQuestions : function(component, event, helper) {
		
		var subQuestions = component.get("v.subQuestions");
		var inputEl = component.find("radio").getElement().querySelector("input:checked");
        var inputValue = helper.getElementValue(inputEl);
		var selected = [inputValue];
		if(subQuestions.length > 0) {
			helper.manageSubQuestions(component, subQuestions, selected);
			
		}
	},

	/*
	* If the question is in the current section, the response is found and then passed to the helper method 
	* handleResponse() which is found in the ChecklistQuestion abstract component
	* @param component
	* @param event
	* @param helper
	* @return void
	*/
	saveAnswer : function(component, event, helper) {
        
        if (helper.isInCurrentSection(component, event)) {
           	var response = '';
           	var nameResponse = '';
            var radios = component.find("bgck-radio");
            
            radios.forEach(function(radio){

            	var checked = radio.getElement().checked;
            	if (checked) {
            		var inputEl = radio.getElement();
                    response = helper.getElementValue(inputEl);
	                nameResponse = helper.trimResponseId(radio.getElement().id);
	 
	            }

            });
            
            helper.handleResponse(component, response, nameResponse);
        } 
        
	}

})