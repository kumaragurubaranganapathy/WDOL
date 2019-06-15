({
	getElementValue : function(inputEl) {
		var inputValue = inputEl.value;
		if( inputValue === 'on'){
            //for ie 11 value is not defined on the radio input so we need to get value from id
            var elementId = inputEl.id;
            var index = elementId.indexOf('globalId');
            inputValue = elementId.substring(0,index);
        }
        return inputValue;
	}
})