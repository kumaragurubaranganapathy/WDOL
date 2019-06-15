({
	/*
    * A map of all the field data types with an appropriate component to be used 
    *
    */
	viewConfigMap: {
        'anytype': { componentDef: 'ui:outputText', attributes: { } },
        'base64': { componentDef: 'ui:outputText', attributes: { } },
        'boolean': {componentDef: 'ui:outputCheckbox', attributes: { } },
        'combobox': { componentDef: 'ui:outputText', attributes: { } },
        'currency': { componentDef: 'ui:outputCurrency', attributes: { } },
        'datacategorygroupreference': { componentDef: 'ui:outputText', attributes: { } },
        'date': { componentDef: 'ui:outputDate', attributes: {} },
        'datetime': { componentDef: 'ui:outputDateTime', attributes: { } },
        'double': { componentDef: 'ui:outputNumber', attributes: { } },
        'email': { componentDef: 'ui:outputEmail', attributes: { } },
        'encryptedstring': { componentDef: 'ui:outputText', attributes: { } },
        'id': { componentDef: 'ui:outputText', attributes: { } }, 
        'integer': { componentDef: 'ui:outputNumber', attributes: { } },
        'multipicklist': { componentDef: 'ui:outputText', attributes: { } }, 
        'percent': { componentDef: 'ui:outputNumber', attributes: {} },
        'phone': { componentDef: 'ui:outputPhone', attributes: {} },
        'picklist': { componentDef: 'ui:outputText', attributes: {} }, 
        'reference': { componentDef: 'ui:outputText', attributes: {  } }, 
        'string': { componentDef: 'ui:outputText', attributes: { } },
        'textarea': { componentDef: 'ui:outputTextArea', attributes: {} },
        'time': { componentDef: 'ui:outputDateTime', attributes: {  } },
        'url': { componentDef: 'ui:outputURL', attributes: { } }
    },

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
        'date': { componentDef: 'ui:inputDate', attributes: {} },
        'datetime': { componentDef: 'ui:inputDateTime', attributes: { } },
        'double': { componentDef: 'ui:inputNumber', attributes: { } },
        'email': { componentDef: 'ui:inputEmail', attributes: { } },
        'encryptedstring': { componentDef: 'ui:inputText', attributes: { } },
        'id': { componentDef: 'ui:inputText', attributes: { } }, 
        'integer': { componentDef: 'ui:inputNumber', attributes: { } },
        'multipicklist': { componentDef: 'BGCM:DynamicPicklist', attributes: { multiple: 'true'} }, 
        'percent': { componentDef: 'ui:inputNumber', attributes: {} },
        'phone': { componentDef: 'ui:inputPhone', attributes: {} },
        'picklist': { componentDef: 'BGCM:DynamicPicklist', attributes: {} }, 
        'reference': { componentDef: 'BGCM:Lookup', attributes: {  } }, 
        'string': { componentDef: 'ui:inputText', attributes: { } },
        'textarea': { componentDef: 'ui:inputTextArea', attributes: {} },
        'time': { componentDef: 'ui:inputDateTime', attributes: {  } },
        'url': { componentDef: 'ui:inputURL', attributes: { } }
    }
})