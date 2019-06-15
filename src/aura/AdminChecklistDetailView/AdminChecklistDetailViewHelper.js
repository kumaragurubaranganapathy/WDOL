({
	createView : function(component) {
		
		var fields = component.get("v.fieldset");
		var record = component.get("v.record");
		var values = [];

		for (var i = 0; i< fields.length; i++) {
			var value = record;
			var field = fields[i];
			if (field.fieldPath.includes('.')) {
				var fieldPaths = field.fieldPath.split(".");
				for(var j = 0; j< fieldPaths.length; j++) {
					if(value)
						value = value[fieldPaths[j]];
				}
			} else {
				value = record[field.fieldPath];
			}
			values.push({
				'label' : field.label,
				'name' : value
			});
		}

		if (record.BGCK__Question_Type__r && record.BGCK__Question_Type__r.Name) {
			values.push({'label' : 'Type Name', 'name': record.BGCK__Question_Type__r.Name});
		}

		component.set("v.values", values);

	},

	configMap: {
        'anytype': { componentDef: 'ui:outputText', attributes: { } },
        'base64': { componentDef: 'ui:outputText', attributes: { } },
        'boolean': {componentDef: 'ui:outputCheckbox', attributes: { } },
        'combobox': { componentDef: 'ui:outputText', attributes: { } },
        'currency': { componentDef: 'ui:outputCurrency', attributes: { } },
        'datacategorygroupreference': { componentDef: 'ui:outputText', attributes: { } },
        'date': { componentDef: 'ui:outputDate',attributes: { } },
        'datetime': { componentDef: 'ui:outputDateTime', attributes: { } },
        'double': { componentDef: 'ui:outputNumber', attributes: { } },
        'email': { componentDef: 'ui:outputEmail', attributes: { } },
        'encryptedstring': { componentDef: 'ui:outputText', attributes: { } },
        'id': { componentDef: 'ui:outputText', attributes: { } },
        'integer': { componentDef: 'ui:outputNumber', attributes: { } },
        'multipicklist': { componentDef: 'ui:outputText', attributes: { } },
        'percent': { componentDef: 'ui:outputNumber', attributes: { } },
        'phone': { componentDef: 'ui:outputPhone', attributes: { } },
        'picklist': { componentDef: 'ui:outputText', attributes: { } },
        'reference': { componentDef: 'ui:outputText', attributes: { } },
        'string': { componentDef: 'ui:outputText', attributes: { } },
        'textarea': { componentDef: 'ui:outputRichText', attributes: {} },
        'time': { componentDef: 'ui:outputDateTime', attributes: { } },
        'url': { componentDef: 'ui:outputURL', attributes: { } }
    }
})