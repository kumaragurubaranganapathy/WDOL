({
	/*
    * A map of all the field data types with an appropriate component to be used 
    *
    */
	configMap: {
        'anytype': { componentDef: 'ui:inputText', attributes: { } },
        'base64': { componentDef: 'ui:inputText', attributes: { } },
        'boolean': {componentDef: 'ui:inputCheckbox', attributes: { } },
        'combobox': { componentDef: 'ui:inputText', attributes: { } },
        'currency': { componentDef: 'ui:inputCurrency', attributes: { } },
        'datacategorygroupreference': { componentDef: 'ui:inputText', attributes: { } },
        'date': { componentDef: 'ui:inputDate', attributes: { displayDatePicker: "true"} },
        'datetime': { componentDef: 'ui:inputDateTime', attributes: { displayDatePicker: "true"} },
        'double': { componentDef: 'ui:inputNumber', attributes: { } },
        'email': { componentDef: 'ui:inputEmail', attributes: { } },
        'encryptedstring': { componentDef: 'ui:inputText', attributes: { } },
        'id': { componentDef: 'ui:inputText', attributes: { } }, 
        'integer': { componentDef: 'ui:inputNumber', attributes: { } },
        'multipicklist': { componentDef: 'BGCK:DynamicPicklist', attributes: {'multiple' : 'true'} }, 
        'percent': { componentDef: 'ui:inputNumber', attributes: {} },
        'phone': { componentDef: 'ui:inputPhone', attributes: {} },
        'picklist': { componentDef: 'BGCK:DynamicPicklist', attributes: {} }, 
        'reference': { componentDef: 'BGCK:LightningLookup', attributes: {  } }, 
        'string': { componentDef: 'ui:inputText', attributes: { } },
        'textarea': { componentDef: 'ui:inputTextArea', attributes: {} },
        'time': { componentDef: 'ui:inputDateTime', attributes: {  } },
        'url': { componentDef: 'ui:inputURL', attributes: { } }
    }
})