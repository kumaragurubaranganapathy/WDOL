({
        callServerMethod : function(component, event, helper) {
			try{
				const params = event.getParam('arguments');
				const action = params.action;        
				// Pass action parameters if applicable
				if (params.params !== null) {
					action.setParams(params.params);
				}
				action.setCallback(this, function(response) {
					const state = response.getState();
					if (state === "SUCCESS") {
						// Call custom success callback if applicable
						if (params.successCallback) {
							const returnValue = response.getReturnValue();
							params.successCallback(returnValue);
						}
					}
					else if (state === "ERROR") {
						const errors = response.getError();
						
						// Display error if applicable
						if (params.disableErrorNotification === null || !params.disableErrorNotification) {
							let isUnknownError = true;
							// Retrieve and display the error message(s) sent by the server
							if (typeof errors !== 'undefined' && Array.isArray(errors) && errors.length > 0) {
								errors.forEach(error => {
									// Check for 'regular' errors
									if (typeof error.message !== 'undefined') {
										//helper.displayError(error.message, params);
										console.error('Server Error: ', error.message);
										console.error('Action: ', action.getName(), ' Params: ', params.params);
										// Fire error toast if available
										const toastEvent = $A.get("e.force:showToast");
										if (typeof toastEvent !== 'undefined') {
											toastEvent.setParams({
												title : 'Server Error',
												message : error.message,
												type : 'error',
												mode: 'sticky'
											});
											toastEvent.fire();
										}
										isUnknownError = false;
									}
									// Check for 'pageError' errors
									const pageErrors = error.pageErrors;
									if (typeof pageErrors !== 'undefined' && Array.isArray(pageErrors) && pageErrors.length > 0) {
										pageErrors.forEach(pageError => {
											if (typeof pageError.message !== 'undefined') {
												//helper.displayError(pageError.message, params);
												console.error('Server Error: ', pageError.message);
												console.error('Action: ', action.getName(), ' Params: ', params.params);
												// Fire error toast if available
												const toastEvent = $A.get("e.force:showToast");
												if (typeof toastEvent !== 'undefined') {
													toastEvent.setParams({
														title : 'Server Error',
														message : pageError.message,
														type : 'error',
														mode: 'sticky'
													});
													toastEvent.fire();
												}
												isUnknownError = false;
											}
										});
									}
								});
							}
							
							if (isUnknownError) {
								helper.displayError('Unknown error', params);
							}
							console.error(JSON.stringify(errors));
						}
						if (params.errorCallback) {
							params.errorCallback(errors);
						}
					}
				});
		
				// Set action as storable if applicable
				if (params.isStorable) {
					action.setStorable();
				}
		
				// Set action to execute in background if applicable
				if (params.isBackground) {
					action.setBackground();
				}
		
				// Call server-side action
				$A.enqueueAction(action);
		}
		
	   catch(e){
       		console.error('Error Stack Message for callServerMethod Helper' + e.stack); 
       }
            
    },
})