({
    doInit : function(component, event, helper) {
        var recordId = decodeURIComponent(window.location.search.substring(1).split('par1=')[1].split('&par2=')[0]);
        console.log('recordId==' + recordId);
        var value = decodeURIComponent(window.location.search.substring(1).split('par1=')[1].split('&par2=')[1]);  
        console.log('value==' + value);
        if(value.toLowerCase() == "contact"){
            component.set("v.objectApiName", 'Contact');
            component.set("v.fieldApiNames", ['Email','Other_Email__c','MobilePhone','Phone']);
            component.set("v.recordIDforSSAMR",recordId);
            component.set("v.recordEditForm", true);
            
            component.set("v.AMRName",'Update Contact Information');
            component.set("v.redirectURL", $A.get("$Label.c.Polaris_Portal_NewDashboard"));
        }
        else if(value.toLowerCase() == "license"){            
            component.set("v.customForm", true);
            component.set("v.recordIDforSSAMR",recordId);   
            component.set("v.AMRName",'Update Website');
            component.set("v.redirectURL", $A.get("$Label.c.Polaris_Portal_Home"));
            helper.fetchWebiste(component, event, helper);
        }
            else if(value.toLowerCase() == "print"){            
                component.set("v.showPrintForm", true);
                component.set("v.recordIDforSSAMR",recordId);            
                component.set("v.redirectURL", $A.get("$Label.c.Polaris_Portal_Home"));
                component.set("v.AMRName",'Generate License Document');
                helper.fetchWebiste(component, event, helper);
            }
                else if(value.toLowerCase() == "businesscontact"){
                    component.set("v.objectApiName", 'Account');
                    component.set("v.fieldApiNames", ['First_Name_Primary_Contact__c','Last_Name_Primary_Contact__c','Email_Primary_Contact__c','Email__c','Phone_Primary_Contact__c','Extension__c','Business_Phone__c']);
                    component.set("v.recordIDforSSAMR",recordId);
                    component.set("v.recordEditForm",true);
                    component.set("v.AMRName",'Update Business Information');
                    component.set("v.redirectURL", $A.get("$Label.c.Polaris_Portal_Business_Dashboard"));
                }
                    else if(value.toLowerCase() == "mailingaddress"){
                        component.set("v.contactId",recordId);
                        component.set("v.iscontactAddress", true);
                        
                    }
                        else if(value.toLowerCase() == "billingcode"){
                            component.set("v.objectApiName", 'Account');
                            component.set("v.fieldApiNames", ['ThirdPary_Billing_Code__c']);
                            component.set("v.recordIDforSSAMR",recordId);
                            component.set("v.thirdpartybillingcode", true);
                            //component.set("v.recordIDforSSAMR",recordId);
                            var action = component.get("c.fetchAccountInfo");
                            action.setParams({
                                "licId": recordId    
                            });
                            action.setCallback(this, function(response) {
                                var state = response.getState();
                                if (state === "SUCCESS") {
                                    var appId = response.getReturnValue();
                                    if(appId != null && appId.ThirdPary_Billing_Code__c != undefined && appId.ThirdPary_Billing_Code__c != null && appId.ThirdPary_Billing_Code__c != ''){
                                        component.set("v.existingBillingCode",appId.ThirdPary_Billing_Code__c);
                                    }
                                }
                                else if (state === "ERROR") {
                                    var errors = response.getError();
                                    if (errors) {
                                        if (errors[0] && errors[0].message) {
                                            console.error("Error message: " + errors[0].message);
                                        }
                                    } else {
                                        console.error("Unknown error");
                                    }
                                }
                            });
                            $A.enqueueAction(action);              
                            component.set("v.redirectURL",$A.get("$Label.c.Polaris_Portal_Home"));
                        }
        
                            else if(value.toLowerCase() == "address"){			
                                component.set("v.recordIDforSSAMR",recordId);
                                component.set("v.AMRName",'Update your Mailing Address');
                                var action = component.get("c.fetchAppId");
                                action.setParams({
                                    "licId": recordId    
                                });
                                action.setCallback(this, function(response) {
                                    var state = response.getState();
                                    if (state === "SUCCESS") {
                                        var appId = response.getReturnValue();
                                        component.set("v.appId",appId);
                                        component.set("v.address", true);
                                    }
                                    else if (state === "ERROR") {
                                        var errors = response.getError();
                                        if (errors) {
                                            if (errors[0] && errors[0].message) {
                                                console.error("Error message: " + errors[0].message);
                                            }
                                        } else {
                                            console.error("Unknown error");
                                        }
                                    }
                                });
                                $A.enqueueAction(action);              
                                component.set("v.redirectURL", $A.get("$Label.c.Polaris_Portal_Home"));             
                            }
    },
    
    getBusiness : function(component, event, helper){
        var action = component.get("c.fetchBusinessInfo");
        action.setParams({
            "accId": component.get("v.recordIDforSSAMR"),            
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var accountInfo = response.getReturnValue();
                component.set("v.accountName",accountInfo);
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.error("Error message: " + errors[0].message);
                    }
                } else {
                    console.error("Unknown error");
                }
            }
        });
        $A.enqueueAction(action);
        
    },
    getContact : function(component, event, helper){
        var action = component.get("c.fetchContactInfo");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var contactInfo = response.getReturnValue();
                component.set("v.contactName",contactInfo);
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.error("Error message: " + errors[0].message);
                    }
                } else {
                    console.error("Unknown error");
                }
            }
        });
        $A.enqueueAction(action);
        
    },
    fetchWebiste : function(component, event, helper){
        var licId  = component.get("v.recordIDforSSAMR");        
        var action = component.get("c.fetchWebsiteInfo");
        action.setParams({
            "licId": licId    
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var websiteInfo = response.getReturnValue();
                component.set("v.existWebsite",websiteInfo);
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.error("Error message: " + errors[0].message);
                    }
                } else {
                    console.error("Unknown error");
                }
            }
        });
        $A.enqueueAction(action);   
        
    },
    saveWebsitehelper : function(component, event, helper){
        var licId = component.get("v.recordIDforSSAMR");
        var updatedValue = component.get("v.existWebsite");
        var action = component.get("c.updateWebsiteInfo");
        action.setParams({
            "licId": licId,
            "websiteInfo":updatedValue
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                //response.getReturnValue();
                //window.location.href = component.get("v.redirectURL");
                // window.history.back();
                component.set("v.popupHeader", "Successfully Submitted");
                component.set("v.popupBody", "Thank you for your submission.");
                component.set("v.isOpen", true);
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.error("Error message: " + errors[0].message);
                    }
                } else {
                    console.error("Unknown error");
                }
            }
        });
        $A.enqueueAction(action);       
    },
    
    createcode : function(component, event, helper){
        var licId = component.get("v.recordIDforSSAMR");
        var updatedValue = 'createCode';
        var action = component.get("c.updateWebsiteInfo");
        action.setParams({
            "licId": licId,
            "websiteInfo":updatedValue
        });
        /*var action = component.get("c.createCodeValue");
        action.setParams({
            "test": 'hello'
        });*/
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var output = response.getReturnValue();
                component.set("v.outputcode",output);
                
                
                //window.location.href = component.get("v.redirectURL");
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.error("Error message: " + errors[0].message);
                    }
                } else {
                    console.error("Unknown error");
                }
            }
        });
        $A.enqueueAction(action);       
    },
    printUpdatehelper : function(component, event, helper){
        var licId = component.get("v.recordIDforSSAMR");
        var action = component.get("c.printUpdateLicense");
        action.setParams({
            "licId": licId,
            "printType":component.find("printLicenseId").get("v.value")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                if(component.find("printLicenseId").get("v.value")=='download')
                {
                    var conVerId = response.getReturnValue();
                    console.log('conVerId==' + conVerId);
                    //windows.location = 'https://wadolbuspro--dev--c.cs32.content.force.com/sfc/servlet.shepherd/version/download/'+conVerId+'?asPdf=false&operationContext=CHATTER';
                    /* var urlEvent = $A.get("e.force:navigateToURL");
                    urlEvent.setParams({
                       "url": $A.get("$Label.c.Polaris_Portal_URL")+'sfc/servlet.shepherd/document/download/'+conVerId+'?operationContext=S1'
                        //"url": $A.get("$Label.c.Polaris_Portal_URL")+'sfc/servlet.shepherd/version/download/'+conVerId+'?asPdf=false&operationContext=CHATTER'
                    });
                    urlEvent.fire();*/
                    var urlinfo = $A.get("$Label.c.Polaris_Portal_URL")+'sfc/servlet.shepherd/document/download/'+conVerId+'?operationContext=S1';
                    window.location.href=urlinfo;
                    window.setTimeout(
                        $A.getCallback(function() {
                            window.history.back();
                        }), 5000
                    ); 
                }
                else if(component.find("printLicenseId").get("v.value")=='DES')
                {
                    component.set("v.popupHeader", "Successfully Submitted");
                    component.set("v.popupBody", "Thank you for your submission. You will receive printed license by mail within 7 days.");
                    component.set("v.isOpen", true);
                }
                
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.error("Error message: " + errors[0].message);
                    }
                } else {
                    console.error("Unknown error");
                }
            }
        });
        $A.enqueueAction(action);
        
    },
    
    
    cancel : function(component, event, helper){
        var buttonSource = event.getSource().get("v.name");
        if(buttonSource === "Back"){
            var urlEvent = $A.get("e.force:navigateToURL");
            urlEvent.setParams({
                "url": "/business"
            });
            urlEvent.fire();
        }
        else{
            component.set("v.popupHeader", "Successfully Submitted");
            component.set("v.popupBody", "Thank you for your submission.");
            component.set("v.isOpen", true);
        }
    },
    
    maskInput : function(component,event){  
        var numbers=event.getSource().get('v.value');
        var fieldname=event.getSource().get('v.fieldName');
        if(fieldname=="MobilePhone" || fieldname=="Phone"||fieldname=="Phone_Primary_Contact__c"||fieldname=="Business_Phone__c"){
            if(numbers.length==10){
                var trimmedNo = ('' + numbers).replace(/\D/g, '');
                var phone = trimmedNo.slice(0, 3)+'.'+trimmedNo.slice(3,6) + '.' + trimmedNo.slice(6);
                event.getSource().set('v.value',phone); 
            }
        }
    },
    //Close the modal popup and redirect to cart page
    closeModel: function(component, event) {
        window.history.back();
    },
    validateFields : function(component,event){
        var toastEvent = $A.get("e.force:showToast");
        var inputFields = component.find("input-fields");
        // var inputFields = component.find("UpdateContactId");
        var errorCount = 0;
        inputFields.forEach(function(elem){
            if(elem.get("v.value")!== null)
            {
                if(elem.get("v.fieldName") === "MobilePhone" && elem.get("v.value").length!==12 && elem.get("v.value").length!==0){
                    errorCount++;
                    
                    toastEvent.setParams({
                        "title": "ERROR!",
                        "message": "Mobile Phone should be 10 digits",
                        "type": "error"
                    });
                    toastEvent.fire();
                    
                }
                else if(elem.get("v.fieldName") === "Phone" && elem.get("v.value").length!==12 && elem.get("v.value").length!==0){
                    errorCount++;
                    
                    toastEvent.setParams({
                        "title": "ERROR!",
                        "message": "Business Phone should be 10 digits",
                        "type": "error"
                    });
                    toastEvent.fire();
                    
                }
                if(elem.get("v.fieldName") === "Phone_Primary_Contact__c" && elem.get("v.value").length!==12 && elem.get("v.value").length!==0){
                    errorCount++;
                    
                    toastEvent.setParams({
                        "title": "ERROR!",
                        "message": "Mobile Phone should be 10 digits",
                        "type": "error"
                    });
                    toastEvent.fire();
                    
                }
                else if(elem.get("v.fieldName") === "Business_Phone__c" && elem.get("v.value").length!==12 && elem.get("v.value").length!==0){
                    errorCount++;
                    
                    toastEvent.setParams({
                        "title": "ERROR!",
                        "message": "Business Phone should be 10 digits",
                        "type": "error"
                    });
                    toastEvent.fire();
                    
                }
            }
        });
        if(errorCount===0){
            component.set("v.fieldsValidated",true);
            component.find("UpdateContactId").submit();
        }
        else
            component.set("v.fieldsValidated",false);
    }
    
    
    
})