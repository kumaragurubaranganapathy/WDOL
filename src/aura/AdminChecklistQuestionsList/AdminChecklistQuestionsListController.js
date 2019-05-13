({

	/*
	* Iterates through the fieldset array and creates an array of values from the question record.
	*/
	doInit : function(component, event, helper) {

		var fieldset = component.get("v.fieldset");
		var question = component.get("v.question");
		var values = [];
		var field = null;

		for (var i=0; i < fieldset.length; i++) {
			field = fieldset[i];
			var value = question;
			if(field.fieldPath.includes('.'))
			{
				var fieldPaths = field.fieldPath.split(".");
				for(var j=0; j<fieldPaths.length; j++)
				{
					if(value)
						value = value[fieldPaths[j]];
				} 
			}
			else
			{
				value = question[field.fieldPath];
			}
			values.push({
				'label' : field.label,
				'value' : value
			});
		}

		component.set("v.questionValues", values);
	},

	/*
	* Click handler for the edit button that is shown for versions whose status === Draft. 
	* Sets the app's versionId and opens the main checklist admin screen.
	*
	*
	*/

	clickViewQuestion : function(component, event, helper) {

		//helper.handleView(component);
	},

	/*
	* Placeholder click handler for the clone button
	*/

	clickEditQuestion : function(component, event, helper) {
		//helper.handleEdit(component);
	},

	/*
	* Placeholder click handler for the activate button
	*
	*/
	clickDeleteQuestion : function(component, event, helper) {
		//helper.handleDelete(component);
	}
})