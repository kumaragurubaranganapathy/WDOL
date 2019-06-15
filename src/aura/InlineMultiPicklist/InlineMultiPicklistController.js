({
	init : function(component, event, helper) {

		var value = (component.get("v.value")) ? component.get("v.value").split(';') : [];
		var options = component.get("v.options");
		var cmps = [];
		if ($A.util.isArray(options)) {
			
			for (var i=0; i<options.length; i++) {
				var opt = options[i];
				var attributes = {
						tag: 'option',
						HTMLAttributes: {
							label: opt.label,
							value: opt.value,

						}
					};
				if (value.includes(opt.value)) attributes.HTMLAttributes.selected = 'true';

				$A.createComponent(
					'aura:html',
					attributes,
					function(cmp, status, msg) {
						cmps.push(cmp);
					}
				);
			}
		}
		component.set("v.body", cmps);
	},	

	clickEdit: function(component, event, helper) {

		var select = component.find("edit-popover");
		$A.util.toggleClass(select, "slds-hide");
	},

	handleChange: function(component, event, helper) {

		var value = null;
		var selectedOptions = event.target.selectedOptions;
		if (selectedOptions.length > 0) {
			value = [];
			for (var i=0;i<selectedOptions.length;i++) {
				value.push(selectedOptions[i].value);
			}
			value = value.join(';');
		} 
		component.set("v.value", value);
	}
})