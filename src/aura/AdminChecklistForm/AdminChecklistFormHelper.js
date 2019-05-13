({


	createForm: function(component) {
		
		component.set("v.body", []);
		var fields = component.get("v.fieldset");
		var inputDesc = [];
		var cmpCount = 0;
		this.createBlankFields(component);
		
		if($A.util.isArray(fields)) {
			for (var i = 0; i < fields.length; i++) {
				var field = fields[i];
				var fieldType = field.type.toLowerCase();
				if (fieldType !== 'picklist' && fieldType !== 'reference') {

					if (fieldType === 'textarea') {
						//need to check for HTML characters and replace with safe characters
						var value = component.get("v.record." +field.fieldPath);
						if (value) {
							value = value.replace(/&(amp|quot|#39);/g, function(match, p){
								return (p === "quot" || p === "#39") ? "'" : "&";
							});
							component.set("v.record." + field.fieldPath, value);
						}
					}
					// need to make a copy of config so aren't editing the actual config map
					var config = JSON.parse(JSON.stringify(this.configMap[field.type.toLowerCase()]));
					if (config) {
						config.attributes.label = field.label;
						config.attributes.name = field.fieldPath;
						config.attributes.required = field.DBRequired || field.required;

						if (field.fieldPath === 'Name') {
							config.attributes.maxlength = '80';
						}

						config.attributes.value = component.getReference("v.record." + field.fieldPath);
						inputDesc.push([
							config.componentDef,
							config.attributes
						]);
					}

				}

			} // end for loop


			$A.createComponents(inputDesc, function(cmps){
				component.set("v.body", cmps);
			
			});	
		}


	},

	createBlankFields: function(component) {
		var obj = component.get("v.record");
		var type = component.get("v.sobject");
		var fieldset = component.get("v.fieldset");
		if (!obj) {
			obj = {'attributes' : {'type' : type}};
		}
		
		for (var i = 0; i < fieldset.length; i++) {
			var field = fieldset[i];

			if(!obj[field.fieldPath]) {
				obj = JSON.parse(JSON.stringify(obj));
				obj[field.fieldPath] = "";
			}
			
		}
		component.set("v.record", obj);
	},

	configMap: {
        'anytype': { componentDef: 'lightning:input', attributes: { type: 'text'} },
        'base64': { componentDef: 'lightning:input', attributes: { type: 'text'} },
        'boolean': {componentDef: 'lightning:input', attributes: { type: 'toggle'} },
        'combobox': { componentDef: 'lightning:input', attributes: { type: 'text'} },
        'currency': { componentDef: 'lightning:input', attributes: { type: 'number'} },
        'datacategorygroupreference': { componentDef: 'lightning:input', attributes: { type: 'text'} },
        'date': {
            componentDef: 'lightning:input',
            attributes: {
                type: 'date'
            }
        },
        'datetime': { componentDef: 'lightning:input', attributes: { type: 'datetime' } },
        'double': { componentDef: 'lightning:input', attributes: { type: 'number'} },
        'email': { componentDef: 'lightning:input', attributes: { type: 'email'} },
        'encryptedstring': { componentDef: 'lightning:input', attributes: { type: 'text'} },
        'id': { componentDef: 'lightning:input', attributes: { type: 'text'} },
        'integer': { componentDef: 'lightning:input', attributes: { type: 'number'} },
        'multipicklist': { componentDef: 'lightning:input', attributes: { type: 'text'} },
        'percent': { componentDef: 'lightning:input', attributes: { type: 'number'} },
        'phone': { componentDef: 'lightning:input', attributes: {type: 'tel'} },
        'picklist': { componentDef: 'lightning:input', attributes: {type: 'text'} },
        'reference': { componentDef: 'lightning:input', attributes: { type: 'text' } },
        'string': { componentDef: 'lightning:input', attributes: { type: 'text' } },
        'textarea': { componentDef: 'lightning:textarea', attributes: {} },
        'time': { componentDef: 'lightning:input', attributes: { type: 'text' } },
        'url': { componentDef: 'lightning:input', attributes: { type: 'url'} }
    }
})