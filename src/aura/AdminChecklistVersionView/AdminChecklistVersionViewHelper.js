({
	handleClone : function(component) {

		var activeVersion = component.get("v.version");
		var activeVersionId = activeVersion.Id;
		var cloneAction = component.get("c.cloneChecklistVersion");
		cloneAction.setParams({'versionId' : activeVersionId});
		cloneAction.setCallback(this, function(response){
			var state = response.getState();
			if (component.isValid() && state == "SUCCESS") {
				var newVersionId = response.getReturnValue();
				var app = $A.getRoot();
				app.set("v.isViewMode", false);
				app.set("v.versionId", newVersionId);
				app.set("v.checklistPQFieldSet", activeVersion.BGCK__BG_Field_Set_Name__c);
				app.openChecklistVersion();
			} else {
				console.log('Error: ', response.getError());
				throw new Error('There has been an error. Please contact your system administrator for assistance.');
			}
		});

		$A.enqueueAction(cloneAction);
	},

	handleValues: function(component) {
		
		var fieldset = component.get("v.fieldset");
		var version = component.get("v.version");
		var values = [];
		var field = null;
		var value = '';

		for (var i=0; i < fieldset.length; i++) {
			field = fieldset[i];
			value = version[field.fieldPath];
			if (field.type.toLowerCase() === 'datetime') {
				value = $A.localizationService.formatDateTime(value);
			}
			
			values.push({
				'label' : field.label,
				'value' : value
			});
		}

		component.set("v.versionValues", values);
	}
})