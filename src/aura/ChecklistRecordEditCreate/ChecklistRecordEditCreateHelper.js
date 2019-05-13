({

	/*
	* Creates a blank object with its attribute set to be the correct sobjectType.
	* Needs to be in this format for the apex controller.
	* @param component Reference to component
	* @return Object with type set to be the API name required.
	*
	*/
	createBlankFieldsOnRecord : function(component) {

		var obj = component.get("v.record");
		var type = component.get("v.APIName");
		var fieldset = component.get("v.fieldset");
		obj = {'attributes' : {'type' : type} };
		for(var i=0; i < fieldset.length; i++) {
			var field = fieldset[i];
			obj[field.fieldPath] = null;
		}
		component.set("v.record", obj);
		
	},
	
	/*
	* Creates a form that has its data bound to the component's record object.
	* Uses a configuration map to create the component definitions of the input required
	* for each member of the fieldset. Based on http://salesforce.stackexchange.com/questions/56047/how-to-use-fieldsets-with-lightning
	* 
	* @param component Reference to component
	* @return void
	*
	*/

	createForm: function(component) {
	        
	        // clear any existing form out of the view
	        component.set("v.form", []);
	        var newForm = component.get("v.form");
	        var fields = component.get('v.fieldset');
	    
	        var mode = component.get("v.mode");
	        
	        if (mode === "CREATE") {
	        	this.createBlankFieldsOnRecord(component);
	        } else {
	        	// this is where I will handle when the form edits an existing record 
	        	
	        }
	        
	        var inputDesc = [];
	        var fieldPaths = [];
	        for (var i = 0; i < fields.length; i++) {
	            var field = fields[i];
	            // need to make a copy of config (so aren't editing the actual config map)
 				var config = JSON.parse(JSON.stringify(this.configMap[field.type.toLowerCase()]));
	            if (config) {
	                config.attributes.label = field.label;
	                
	                config.attributes.required = field.required;
	                config.attributes.value = component.getReference("v.record." + field.fieldPath);

	                if (field.type.toLowerCase() === 'picklist' || field.type.toLowerCase() === 'multipicklist') {
	                	config.attributes.sobjectName = component.get("v.APIName");
	                	config.attributes.fieldName = field.fieldPath;
	                	config.attributes.class="slds-select";
	                } else {
	                	config.attributes.name = field.fieldPath;
	                }
	                inputDesc.push([
	                    config.componentDef,
	                    config.attributes
	                ]);
	                fieldPaths.push(field.fieldPath);
	            } else {
	                
	            }
        	}
	        $A.createComponents(inputDesc, function(cmps) {
	            
	            component.set('v.form', cmps);
	           
	        });
	},

	/*
	* Passes parameters  (the record, the mode and the user's choice of creating a new record after) 
	* via an event to the parent component which will handle actual saving of the record to the server
	* @param component Reference to the component object
	* @param createNewAfter Boolean from the click handler
	* @return void
	*
	*/

	handleSave : function(component) {

		
		var record = component.get("v.record");
		var isValidRecord = this.checkRecord(component);
		var mode = component.get("v.mode");

		if (isValidRecord) {
			component.set("v.errorMessage", "");
			// $A.util.removeClass(component.find("save-record-spinner"), "slds-hide");
			var evt = component.getEvent("createEdit");
			evt.setParams({'record' : record,
							'mode' : mode,
							'createNewAfter' : false});
			evt.fire();
		} else {
			component.set("v.errorMessage", "You must fill in all required fields and cannot submit a blank record");

		}

	},

	/*
	* Checks if the record is blank or missing any required fields
	* @param component
	*
	* @return Boolean
	*/
	checkRecord: function(component) {
		
		var record = component.get("v.record");
		var fieldset = component.get("v.fieldset");
		var isValid = true;
		var isNotBlank = false;
		var isValidRecord;
		for(var i=0; i<fieldset.length; i++) {
			var field = fieldset[i];

			if (! $A.util.isEmpty(record[field.fieldPath])) { // if any fields are filled in, the record is not blank
				isNotBlank = true;
			}

			if (field.required || field.DBRequired) { // if a required field is skipped, the record is not valid
				if ($A.util.isEmpty(record[field.fieldPath])) {
					isValid = false;
				}
			}
		}

		isValidRecord = (isValid && isNotBlank);
		return isValidRecord;

	},
	 /*
     *  Map the Schema.FieldSetMember to the desired component config, including specific attribute values
     *  Source: https://www.salesforce.com/us/developer/docs/apexcode/index_Left.htm#CSHID=apex_class_Schema_FieldSetMember.htm|StartTopic=Content%2Fapex_class_Schema_FieldSetMember.htm|SkinName=webhelp
     *
     *  Change the componentDef and attributes as needed for other components
     */
    configMap: {
        'anytype': { componentDef: 'lightning:input', attributes: { type: 'text'} },
        'base64': { componentDef: 'lightning:input', attributes: { type: 'text'} },
        'boolean': {componentDef: 'lightning:input', attributes: { type: 'toggle'} },
        'combobox': { componentDef: 'lightning:input', attributes: { type: 'text'} },
        'currency': { componentDef: 'ui:inputNumber', attributes: { 'class' : 'slds-input', labelClass: 'slds-form-element__label'} },
        'datacategorygroupreference': { componentDef: 'lightning:input', attributes: { type: 'text'} },
        'date': { componentDef: 'lightning:input', attributes: { type: 'date' } },
        'datetime': { componentDef: 'lightning:input', attributes: { type: 'datetime' } },
        'double': { componentDef: 'ui:inputNumber', attributes: { 'class' : 'slds-input', labelClass: 'slds-form-element__label'} },
        'email': { componentDef: 'lightning:input', attributes: { type: 'email'} },
        'encryptedstring': { componentDef: 'lightning:input', attributes: { type: 'text'} },
        'id': { componentDef: 'lightning:input', attributes: { type: 'text'} },
        'integer': { componentDef: 'lightning:input', attributes: { type: 'number'} },
        'multipicklist': { componentDef: 'BGCM:DynamicPicklist', attributes: { multiple: 'true'} },
        'percent': { componentDef: 'ui:inputNumber', attributes: { 'class' : 'slds-input', labelClass: 'slds-form-element__label'} },
        'phone': { componentDef: 'lightning:input', attributes: {type: 'tel'} },
        'picklist': { componentDef: 'BGCM:DynamicPicklist', attributes: {} },
        'reference': { componentDef: 'lightning:input', attributes: { type: 'text' } },
        'string': { componentDef: 'lightning:input', attributes: { type: 'text' } }, 
        'textarea': { componentDef: 'lightning:textarea', attributes: {} },
        'time': { componentDef: 'lightning:input', attributes: { type: 'text' } },
        'url': { componentDef: 'lightning:input', attributes: { type: 'url'} }
    }
})