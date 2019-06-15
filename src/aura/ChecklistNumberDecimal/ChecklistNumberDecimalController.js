({
	/*
	* If the question is in the current section, gets the response from the input
	* and converts it to a string. Pass the response to the helper's handleResponse()
	* method
	* @param component
	* @param event
	* @param helper
	* @return void
	*/
	saveAnswer : function(component, event, helper) {

		if(helper.isInCurrentSection(component, event)) {

			var response = component.find('bgck-number').get('v.value');
			if ($A.util.isUndefinedOrNull(response)) {
				response = null;
			} else {
				response = response.toString();
			}
			
			helper.handleResponse(component, response);
		}
	},


	/*
	*
	*  Converts the response's actual value into a number so that it displays back in the input,
	*  Sets up the components maxlength attribute, providing a fallback of 20 chars if no
	*  BGCK__Maximum_Length__c on the question type is provided (or is out of range)
	*
	* @param component
	* @param event
	* @param helper
	* @return void
	*/

	doInit : function(component, event, helper) {

		// parse string number into a float
		
		var response = component.get("v.question.response.BGCK__Actual_Value2__c");

		if(response === undefined || response === "") {
			response = null;
		} else {
				
			// convert to a number and save back to the component
			response = parseFloat(response);

		}

		component.set("v.question.response.BGCK__Actual_Value2__c", response);

		// set the component's maxlength attribute

		var maxlength = component.get("v.question.type.BGCK__Maximum_Length__c");
		if(maxlength < 0 || maxlength === undefined || maxlength > 255) {
			maxlength = 255;
		}

		component.set("v.maxlength", maxlength);

		// set read mode attribute
		helper.handleReadMode(component);
	},

	/*
	* Gets the components maxlength and a reference to the input and passes to a helper function
	* in the ChecklistNumberAbstract helper.
	* @param component
	* @param event
	* @param helper
	* @return void
	*
	*
	*/

	handleMax : function(component, event, helper) {

		
		var maxlength = component.get("v.maxlength");
		var input = component.find("bgck-number");
		helper.handleMaxLength(maxlength, input);
		
	}	
})