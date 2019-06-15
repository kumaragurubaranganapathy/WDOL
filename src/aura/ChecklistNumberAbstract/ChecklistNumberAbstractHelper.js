({

	/*
	* Gets a concrete component's maxlength and a reference to its input element
	* and sets the inputs max value as a digit with length = maxlength
	* then sets the width of the input to an appropriate size
	*
	* @param maxlength Integer of the components maxlength
	* @param input Component reference to the input
	*
	* @return void
	*
	*/
	handleMaxLength : function(maxlength, input) {

		var max = (Math.pow(10, maxlength) -1);
		
		
		input.set("v.max", max);
		input.set("v.min", 0-max);

		if(maxlength > 50) {
			$A.util.addClass(input, "slds-size--4-of-8");
		} else if (maxlength > 20) {
			$A.util.addClass(input, "slds-size--3-of-8");
		} else if (maxlength > 10) {
			$A.util.addClass(input, "slds-size--2-of-8");
		} else {
			$A.util.addClass(input, "slds-size--2-of-12");
		}
	}
})