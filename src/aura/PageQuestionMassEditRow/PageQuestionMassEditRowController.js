({
	/*
	* Configures the correct type of input component to be used for the current row of the table. 
	*
	*/
	doInit : function(component, event, helper) {

		var type = component.get("v.fieldsetMember.type").toLowerCase();
		var path = component.get("v.fieldsetMember.fieldPath");
		var config = JSON.parse(JSON.stringify(helper.configMap[type])); // make a copy of the config
		if (type === 'reference') { 
			config.attributes.childAPIName = component.get("v.record.sobjectType");
			config.attributes.instanceId = component.get("v.fieldsetMember.fieldPath");
			config.attributes.fieldName = component.get("v.fieldsetMember.fieldPath");
			config.attributes.label = component.get("v.fieldsetMember.label");
			config.attributes.pluralLabel = component.get("v.fieldsetMember.label") + 's';
			config.attributes.updateLookupIdEvent = component.getReference("c.handleLookupChange");
			config.attributes.clearLookupIdEvent = component.getReference("c.handleLookupClear");
		} else {
			config.attributes.value = component.getReference("v.record." + path);
			config.attributes.change = component.getReference("c.handleChange");
			config.attributes.required = component.get("v.fieldsetMember.DBRequired") || component.get("v.fieldsetMember.required");
			config.attributes.class = "slds-input";
		}
		
		if (type === 'picklist' || type === 'multipicklist') {
			config.attributes.sobjectName = component.get("v.record.sobjectType");
			config.attributes.fieldName = path;
			config.attributes.class = "slds-select";
		}

		if (type === 'boolean') {
			config.attributes.class = "slds-checkbox";
		}

		if (type === "textarea") {
			config.attributes.rows = 4;
		}

		if (type === "date" || type === "datetime") {
			config.attributes.blur = component.getReference("c.handleChange");
		}
		$A.createComponent(config.componentDef, config.attributes, function(cmp){

			component.set("v.body", cmp);
		});

	},

	/*
	* Handles the ui:change event that is fired by all the ui:input* components (being used for all field types except reference)
	* Sets the filled attribute so that the checkbox gets updated based on if the user has provided a value for this field.
	*/
	handleChange: function(component, event, helper) {
		
		var path = component.get("v.fieldsetMember.fieldPath");
		var recordValue = component.get("v.record")[path];
		if (recordValue) {
			component.set("v.filled", true);
		} else {
			component.set("v.filled", false);
		}
		
	},

	/*
	* Handles the LookupUpdateId event. Sets the record's field for this row to be the Id value passed from the lookup, then
	* updates the component's filled attribute to be true.
	*
	*/
	handleLookupChange: function(component, event, helper) {

		var instanceId = event.getParam("instanceId");
		var path = component.get("v.fieldsetMember.fieldPath");
		if (instanceId === path) {
			var record = component.get("v.record");
			record[path] = event.getParam("sObjectId");
			component.set("v.filled", true);
			component.set("v.record", record);
		}

	},

	/*
	* Handles the LookupClearId event. Sets the record's field for this row to be null, then updates the component's filled
	* attribute to false.
	*/
	handleLookupClear: function(component, event, helper) {
		var instanceId = event.getParam("instanceId");
		var path = component.get("v.fieldsetMember.fieldPath");
		if (instanceId === path) {
			var record = component.get("v.record");
			record[path] = null;
			component.set("v.filled", false);
			component.set("v.record", record);
		}
	}
})