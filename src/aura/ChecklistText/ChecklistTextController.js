({
   
    /*
    * Gets the components maxlength from the Question_Type. If it's out of range or 
    * not provided, sets it to 255, then sets the maxlength value for the component
    * @param component
    * @param event
    * @param helper
    * @return void
    * 
    */
    doInit : function(component, event, helper) {

        var maxlength = component.get("v.question.type.BGCK__Maximum_Length__c");
        
        if(maxlength < 0 || maxlength === undefined || maxlength > 255) {
            maxlength = 255;
        }
        component.set("v.maxlength", maxlength);
        helper.parseResponse(component);
        helper.handleReadMode(component);

    },

	/* If the question is in the section firing the SaveSection event, this method will
	* find the response from the text input and pass it to a helper method in the 
	* ChecklistQuestion abstract component.
	* @param component
	* @param event
	* @param helper
	* @return void
	*/
	
    saveAnswer : function(component, event, helper) {
        
        if(helper.isInCurrentSection(component, event)) {
            var response = component.find("bgck-text").get("v.value");
            helper.handleResponse(component, response);

        }
     
    },

    /*
    * Gets the components maxlength and sets the input to have that value as its
    * maxlength attribute. Sets the size of the input to be appropriate based
    * on the maxlength. Called by the aura:doneRendering action
    * @param component
    * @param event
    * @param helper
    * @return void

    */

    handleMaxLength : function(component, event, helper) {

    	var maxlength = component.get("v.maxlength");
    	if(maxlength) {
    		var input = component.find("bgck-text");
            if(input) {
                input.set("v.maxlength", maxlength);

                if(maxlength > 50) {
                    $A.util.addClass(input, "slds-size--7-of-8");
                } else if (maxlength > 15) {
                    $A.util.addClass(input, "slds-size--3-of-8");
                } else if (maxlength > 10) {
                    $A.util.addClass(input, "slds-size--2-of-8");
                } else {
                    $A.util.addClass(input, "slds-size--1-of-8");
                }
            }
    		
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

        var input = component.find("bgck-text");
        helper.setCharsLeft(component,  input);
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

        var input = component.find("bgck-text");
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
    }
})