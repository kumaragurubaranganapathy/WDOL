({

	/*
	*
	* Iterates throught the fieldset array and creates an array of value objects with label and name properties
	* to simplify iterating through the current question in markup
	*
	*/
	setupValues : function(component, event, helper) {

		var question = component.get("v.question");
		var fieldset = component.get("v.fieldset");
		var field = null;
		var values = [];

		for (var i = 0; i < fieldset.length; i++) {
			field = fieldset[i];
			var value = question;
			if (field.fieldPath.includes('.')) {
				var fieldPaths = field.fieldPath.split(".");
				for(var j = 0; j< fieldPaths.length; j++) {
					if(value)
						value = value[fieldPaths[j]];
				}
			} else {
				value = question[field.fieldPath];
			}

			if (value && typeof value === 'string') {
				value = value.replace(/&(amp|quot|#39);/g, function(match, p){
					return (p === "quot" || p === "#39") ? "'" : "&";
				});
			}
			values.push({
				'label' : field.label,
				'name' : value
			});
		}

		component.set("v.values", values);
		
	},

	/*
	* Click handler for the details link in the question bank item. Shows/hides via css the details
	* 
	*/
	showQDetails : function(component, event, helper) {

		var details = component.find("question-details");
		if ($A.util.isArray(details)) details = details[0];
		$A.util.toggleClass(details, "slds-hide");
	}
})