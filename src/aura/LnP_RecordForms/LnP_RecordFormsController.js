({
    doInit : function(component, event, helper) {
        // alert('in doinit');
        var objectName = component.get("v.section.personalInfoObjectName");
        var appFieldName = component.get("v.section.fieldJson");
        console.log("isRenewal:::"+ component.get("v.isRenewal"));
        console.log("objectName"+objectName);
        var accountRecordId =  component.get("v.recordId");
        var savedAccountId = component.get("v.section.accountId");
        console.log("accountRecordID"+accountRecordId);
        console.log("accountRecordID"+savedAccountId);
        var recordId = '';
        var fieldsJSON ="";
        if(objectName == "Contact")
        {
            recordId  = component.get("v.section.contactId");
            console.log("objectName::"+objectName);
            console.log("recordId::"+recordId);
        } 
        else 
        {
            if(savedAccountId == null && accountRecordId != null) 
            {
                component.set("v.section.accountId",accountRecordId);
            }
            objectName = "Account";
            recordId  = component.get("v.section.accountId"); 
        }
        var fieldApaiName = JSON.parse(appFieldName);
        console.log("fieldApaiName",fieldApaiName);
        var opts=[];
        
        for(var i=0; i<fieldApaiName.length; i++ )
        {
            opts.push({"apiname":fieldApaiName[i].Name,"label":fieldApaiName[i].Label__c,"value":fieldApaiName[i].Value__c, "required":fieldApaiName[i].Required__c, "regex":fieldApaiName[i].Regex_Validation__c, "readOnly":fieldApaiName[i].Read_Only__c,"patternText":fieldApaiName[i].ValidationCriteria__c});
        }
        console.log("opts",opts); 
        component.set("v.fieldsList", opts);
        component.set("v.objectApiName",objectName);
        component.set("v.recordId",recordId);
        window.setTimeout(
            $A.getCallback(function() {
               	var fields = component.get("v.fieldsList");
                var validFields = fields.filter(function(item){
                    return item.required || item.regex != undefined;
                });
                var fieldValues = component.find("validateField");
                for (var i=0; i<validFields.length; i++){
                    console.log('validFields[i].apiname::'+validFields[i].apiname);
                    if(validFields[i].apiname == 'Unique_ID_To_Provide__c'){
                        var uniqueID = fieldValues[i].get("v.value");  
                        var compEvent = component.getEvent("CmpEvent");
                        if(fieldValues[i].get("v.value") == "No_SSN_or_ITIN"){
                            console.log('NO_SSN_or_ITIN::'+fieldValues[i].get("v.value"));
                            component.set("v.flagHideAndShow", "NO_SSN_ITIN__c");  
                            compEvent.setParams({"message" : "No SSN or ITIN" }); 	
                            compEvent.fire();
                            console.log('xyz::'+xyz);
                        } else {
                            component.set("v.flagHideAndShow", uniqueID);  
                            compEvent.setParams({"message" : uniqueID });
                            compEvent.fire(); 
                            console.log('xyz::'+xyz);
                        } 
                    }
                }         
            }), 3000
        );
    },
    
    createAccount: function(component, event, helper) {
        alert('Create Account');
        helper.createAccountContact(component, event, helper);
        
    },
    
    selectUniqueID:function(component, event, helper){
        var uniqueID = event.getSource().get("v.value");  
        console.log("uniqueID::"+ uniqueID);
       	var compEvent = component.getEvent("CmpEvent");
        if(uniqueID != "No_SSN_or_ITIN"){
            component.set("v.flagHideAndShow", uniqueID);  
        	compEvent.setParams({"message" : uniqueID });
        	var xyz = compEvent.fire(); 
            console.log('xyz::'+xyz);
        } else {
            component.set("v.flagHideAndShow", "NO_SSN_ITIN__c");  
            compEvent.setParams({"message" : "No SSN or ITIN" });
        	compEvent.fire();
            console.log('xyz::'+xyz);
        }       
    },
    getpattern : function(component, event, helper) {
		helper.getpattern(component, event,helper);
	},
    
 
    
})