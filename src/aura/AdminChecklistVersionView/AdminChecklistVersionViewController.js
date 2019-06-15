({

	/*
	* Iterates through the fieldset array and creates an array of values from the version record.
	*
	*
	*/
	doInit : function(component, event, helper) {

		helper.handleValues(component);
	},

	updateValues: function(component, event, helper) {


		helper.handleValues(component);

	},

	/*
	* Click handler for the edit button that is shown for versions whose status === Draft. 
	* Sets the app's versionId and opens the main checklist admin screen.
	*
	*
	*/

	clickEditDraftVersion : function(component, event, helper) {
		var app = $A.getRoot();
		var version = component.get("v.version");
		var fieldset = version.BGCK__BG_Field_Set_Name__c;
		var myId = version.Id;
		app.set("v.isViewMode", false);
		app.set("v.versionId", myId);
		app.set("v.checklistPQFieldSet", fieldset);
		app.openChecklistVersion();
	},

	/*
	* Placeholder click handler for the clone button
	*/

	clickCloneActiveVersion : function(component, event, helper) {
		helper.handleClone(component);
	},

	/*
	* Placeholder click handler for the activate button
	*
	*/
	clickActivateVersion : function(component, event, helper) {
		var versionId = component.get("v.version.Id");
		var name = component.get("v.version.BGCK__BG_Checklist_Name__c");
		var app = $A.getRoot();
		app.activateVersion(versionId, name);
	},

	clickViewMode: function(component, event, helper) {
		var myId = component.get("v.version.Id");
		var fieldset = component.get("v.version.BGCK__BG_Field_Set_Name__c");
		var app = $A.getRoot();
		app.set("v.isViewMode", true);
		app.set("v.versionId", myId);
		app.set("v.checklistPQFieldSet", fieldset);
		app.openChecklistVersion();
	}
})