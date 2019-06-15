({
	doInit : function(component, event, helper) {

		var response = component.get("v.question.response.BGCK__Actual_Value2__c");
		if (response === undefined || response === "") {
			response = null;
		} else {
			response = parseInt(response);
		}
		component.set("v.question.response.BGCK__Actual_Value2__c", response);

		//set component's maxlength attribute

		var maxlength = component.get("v.question.type.BGCK__Maximum_Length__c");
		if(maxlength < 0 || maxlength === undefined || maxlength > 255) {
			maxlength = 255;
		}
		component.set("v.maxlength", maxlength);
		helper.handleReadMode(component);
	},

	handleMarkupChanges : function(component, event, helper) {

		var maxlength = component.get("v.maxlength");
		var input = component.find("bgck-integer");
		helper.handleMaxLength(maxlength, input);
		
	},

	saveAnswer : function(component, event, helper) {

		if(helper.isInCurrentSection(component, event)) {
			var response;
			var input = component.find("bgck-integer");
			response = input.get("v.value");
			if ($A.util.isUndefinedOrNull(response)) {
				response = null;
			} else {
				response = response.toString();
			}
			helper.handleResponse(component, response);
		}
	}
})