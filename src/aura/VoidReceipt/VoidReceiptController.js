({
	/*
	* Calls the ReceiptService.voidReceipt() method. If successful, closes this action and refreshes the record page. If not successful, displays
	* an error message to the user and a button to close this window.
	*
	*/
	handleVoid : function(component, event, helper) {

		var loadingText = component.find("loading");
		
		var action = component.get("c.voidReceipt");
		action.setParams({
			'receiptIds' : [component.get("v.recordId")]
		});
		action.setCallback(this, function(response){

			var state = response.getState();
			if (state === 'SUCCESS' && component.isValid()) {

				$A.get("e.force:refreshView").fire();
				$A.get("e.force:closeQuickAction").fire();
			} else {
				// hide spinner
				$A.util.addClass(loadingText, "slds-hide");
				// show error message and close button

				if (state === 'ERROR') {
					var error = response.getError();
					var message = "There has been an error. Please contact your system administrator for assistance."

					// try finding a useful error message
					if (error && error[0] && error[0].message) {
                        message = error[0].message;
					}
				}
				component.set("v.errorMessage", message);

			}
		});
		$A.enqueueAction(action);
	},

	/*
	* Click handler for close button
	*
	*/
	close: function(component, event, helper) {

		$A.get("e.force:closeQuickAction").fire();
	}
})