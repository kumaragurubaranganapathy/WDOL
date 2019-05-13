({
 	/*
    * Gets the components maxlength from the Question_Type. If it's out of range or 
    * not provided, sets it to 130000, then sets the maxlength value for the component
    * @param component
    * @param event
    * @param helper
    * @return void
    * 
    */
	doInit : function(component, event, helper) {

		var maxlength = component.get("v.question.type.BGCK__Maximum_Length__c");

		if(maxlength < 0 || maxlength > 130000 || maxlength === undefined) {
			maxlength = 130000;
		}

		component.set("v.maxlength", maxlength);
        helper.parseResponse(component);
        helper.handleReadMode(component);
	},
	/*
	* If the component is in the section being saved, this method will be called by the 
	* SaveSection event. It finds the response then passes it to the helper method 
	* handleResponse, which is found in the abstract ChecklistQuestion component
	*
	* @param component
	* @param event
	* @param helper
	* @return void
	*/
	saveAnswer : function(component, event, helper) {
        
        if(helper.isInCurrentSection(component, event)) {
            var response = component.find("bgck-textarea").get("v.value");
            helper.handleResponse(component, response);
        }
	
	},

	/*
    * Called by change event on the components text input. Calls a helper method in the ChecklistTextAbstract
    * helper to set the number of characters left. 
    * @param component
    * @param event
    * @param helper
    * @return void
    * 
    */

	handleChange : function(component, event, helper) {
		
		var input = component.find("bgck-textarea");
		helper.setCharsLeft(component, input);
	},

    /*
    * Called by focus event on the components text input. Calls a helper method in the ChecklistTextAbstract
    * helper to set the number of characters left. Displays the number of characters left to the user.
    * @param component
    * @param event
    * @param helper
    * @return void
    * 
    */
	showCharMsg : function(component, event, helper) {

		
		var input = component.find("bgck-textarea");
		helper.setCharsLeft(component, input);
		var charMsg = component.getSuper().find("char-msg");
        $A.util.removeClass(charMsg, "slds-hidden");
        $A.util.addClass(charMsg, "slds-visible");


	},

    /*
    * Called by blur event on the components text input (when it loses focus). Hides the number of characters left from the user.
    * @param component
    * @param event
    * @param helper
    * @return void
    * 
    */
	hideCharMsg : function(component, event, helper) {
		var charMsg = component.getSuper().find("char-msg");
        $A.util.removeClass(charMsg, "slds-visible");
        $A.util.addClass(charMsg, "slds-hidden");
	},
})