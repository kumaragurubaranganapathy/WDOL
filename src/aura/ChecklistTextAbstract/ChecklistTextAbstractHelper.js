({

	/*
	* Calculates the number of characters the user has left, then sets it up to be displayed to the user. 
	* @param component Reference to the component
	* @param input Component object, reference to the specific lightning:input calling this method
	*
	*/
	setCharsLeft : function(component, input) {
		
		var maxChars = component.get("v.maxlength");
		var value = input.get("v.value");
		var chars;
		if(input.get("v.value") === undefined) {
			chars = 0;
		} else {
			chars = input.get("v.value").length;
		}

        var charsLeft = maxChars - chars;

        var charMessage = charsLeft.toString();
        component.set("v.chars", charMessage);
    },


	parseResponse : function(component) {
		var resp = component.get("v.question.response.BGCK__Actual_Value2__c");

		if (resp) {
			var escapedResp = resp.replace(/&(amp|quot|#39);/g, function(match, p){
				return (p === "quot" || p === "#39") ? "'" : "&";
			});
			component.set("v.question.response.BGCK__Actual_Value2__c", escapedResp);
		}
	}
})