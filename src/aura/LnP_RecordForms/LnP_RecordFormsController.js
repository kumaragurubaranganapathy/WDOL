({
	doInit : function(component, event, helper) {
       // alert('in doinit');
        var objectName = component.get("v.section.personalInfoObjectName");
        var appFieldName = component.get("v.section.fieldJson");
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
            opts.push({"apiname":fieldApaiName[i].Name,"label":fieldApaiName[i].Label__c,"value":fieldApaiName[i].Value__c});
        }
        component.set("v.fieldsList", opts);
        component.set("v.objectApiName",objectName);
        component.set("v.recordId",recordId);
       
	},
    
    createAccount: function(component, event, helper) {
        alert('Create Account');
        helper.createAccountContact(component, event, helper);
        
    }
})