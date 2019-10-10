({  
    doInit : function(component, event) {
        var action2 = component.get("c.getProgramPicklist")
        action2.setCallback(this, function(response){                                
            var state = response.getState();
            if(state == "SUCCESS") {
                var resultprogram = response.getReturnValue();
                component.set("v.programTypeList",resultprogram);    
            }
        });
        
        $A.enqueueAction(action2);
        
    },
    searchAccountHelper: function(component,event) {
        var securityCode = component.find("securityTokenBusiness").get("v.value");
        var action = component.get("c.getAccountList");
        action.setParams({
            "securityCode": securityCode,
        }); 
        action.setCallback(this, function(response){
            var state = response.getState();
            console.log("inside state::"+ state);
            if (state === "SUCCESS"){
                var result = response.getReturnValue();
                if(result != ''){
                    component.set("v.accountColumnListData",result);
                    $A.util.removeClass(component.find("business"), 'slds-hide');                    
                } else {
                    $A.util.addClass(component.find("business"), 'slds-hide');	
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Warning!",
                        "message": "No business found, please try again or contact DOL",
                        "type": "Warning"
                    });
                    toastEvent.fire();
                    
                }
            }else{
                console.log("error");
            }
            
        });
        $A.enqueueAction(action); 
    },
    
    linkContactToAccountHelper: function(component,event) {
        
        var accName = '';
        var accountDetails = component.get("v.accountColumnListData");        
        accName = accountDetails[0].Id;
        var action = component.get("c.createAccountContact");
        
        document.body.scrollTop = document.documentElement.scrollTop = 0;
        component.set("v.loadingSpinner",true);
        action.setParams({
            "accID": accName, 
        }); 
        action.setCallback(this, function(response){
            var state = response.getState();
            console.log("inside state::"+ state);
            if (state === "SUCCESS"){
                var result = response.getReturnValue();
                if(result != ''){
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Success!",
                        "message": result,
                        "type": "Success"
                    });
                    toastEvent.fire();
                //    component.set("v.loadingSpinner",false);
                //    toastEvent.fire();
                    var urlEvent = $A.get("e.force:navigateToURL");
                    urlEvent.setParams({
                        "url": "/business"
                    });
                    urlEvent.fire();
                    //  this.searchAccountHelper();
                }
            }else{
                console.log("error");
            }
            
        });
        $A.enqueueAction(action); 
        
    },
    redirectRequest : function(component,event){
        component.set("v.linkingScreen",false);
        /*var str ='/business-license-linking';
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url": str
        });
        urlEvent.fire();*/
    },
    searchLicenseHelperForActivation : function(component,event) {
        var action = component.get("c.searchLicenseNumber");
        var ProgramType = component.find('programToken').get('v.value');
        var LicenseNumber = component.find('licenseNumber').get('v.value');
        component.set('v.mailToSend','');
        component.set('v.mailID', '');
        component.set('v.emailToSend','');
        component.set('v.emailID','');
        action.setParams({
            "ProgramType": ProgramType, 
            "LicenseNumber": LicenseNumber,
        }); 
        action.setCallback(this, function(response){
            var state = response.getState();
            var result = response.getReturnValue();
            if (state === "SUCCESS"){
                var message = response.getReturnValue();
                if(message != null && message != '' ) {
                    var email = message[0].Ultimate_Parent_Account__r.Email__c;
                    component.set('v.emailToSend',email);
                    email = email.split('@')[0].slice(0,2)+'****@'+email.split('@')[1];
                    if( message[0].MUSW__License2_Parcels__r != null &&  message[0].MUSW__License2_Parcels__r != '') {
                        var mail = message[0].MUSW__License2_Parcels__r[0].Parcel_Address__c.split(',');
                        component.set('v.mailToSend',mail);
                        mail = mail[0].slice(0,2)+'*****'+mail.splice(1);
                        // mail = mail.split(',')[0].slice(0,2)+'****@'+mail.split(',')[1]; 
                        component.set('v.mailID', 'Activation code will be mailed to '+mail);
                    }
                    component.set('v.emailID', 'Activation code will be emailed to '+email);
                    component.set('v.LicenseID',message[0].Id);
                    component.set('v.ActivationCode',message[0].Ultimate_Parent_Account__r.Security_Code__c);
                    component.set('v.ReviewName','Send Business Activation Code');
                    component.set('v.disabled',false); 
                    component.set("v.showEmail",true);
                } else {
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "message": $A.get("$Label.c.Activation_Code_No_License"),
                        "type": "Error"
                    });
                    toastEvent.fire();  
                }
                
            } else {
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!",
                    "message": 'Error occoured please contact system admin!!',
                    "type": "Error"
                });
                toastEvent.fire();  
            }
        });
        $A.enqueueAction(action); 
    } ,
    sendEmailHelper : function(component,event){
        var action = component.get("c.sendActivationCodeEmail");
        var ActivationCode = component.get('v.ActivationCode'); 
        var emailID = component.get('v.emailToSend'); 
        action.setParams({
            "activationCode": ActivationCode, 
            "emailAdd":  emailID
        });   
        action.setCallback(this, function(response){
            var state = response.getState();
            var result = response.getReturnValue();
            if (state === "SUCCESS"){
                
                var toastEvent = $A.get("e.force:showToast");
                var message = response.getReturnValue();
                toastEvent.setParams({
                    "title": "",
                    "message": message,
                    "type": "Success"
                });
                toastEvent.fire();  
                window.setTimeout(
                    $A.getCallback(function() {
                        var urlEvent = $A.get("e.force:navigateToURL");
                        urlEvent.setParams({
                            "url": '/'
                        });
                        urlEvent.fire();
                    }), 2000)
            } else {
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!",
                    "message": result,
                    "type": "Error"
                });
                toastEvent.fire();  
                component.set("v.loadingSpinner",false);
            }
        });
        $A.enqueueAction(action); 
    },
    sendMailHelper : function(component,event){
        var action = component.get("c.createReviewRecord");
        var licenseId = component.get('v.LicenseID'); 
        var ReviewName = component.get('v.ReviewName'); 
        var mail = component.get('v.mailID');  
        var mailtosend = 'Send Business Activation Code to '+component.get('v.mailToSend');    
        action.setParams({
            "licenseId": licenseId, 
            "Name":  ReviewName,
            "mail" :mailtosend
        });   
        action.setCallback(this, function(response){
            var state = response.getState();
            var result = response.getReturnValue();
            if (state === "SUCCESS"){
                
                var toastEvent = $A.get("e.force:showToast");
                var message = response.getReturnValue();
                toastEvent.setParams({
                    "title": "",
                    "message": mail,
                    "type": "Success"
                });
                toastEvent.fire();  
                window.setTimeout(
                    $A.getCallback(function() {
                        var urlEvent = $A.get("e.force:navigateToURL");
                        urlEvent.setParams({
                            "url": '/'
                        });
                        urlEvent.fire();
                    }), 2000
                )
            } else {
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!",
                    "message": result,
                    "type": "Error"
                });
                toastEvent.fire();  
                component.set("v.loadingSpinner",false);
            }
        });
        $A.enqueueAction(action); 
    },
    onRender : function(component,event){
        var account =  component.find("account-id");
        if(account){
        	account.getElement().scrollIntoView();
        }
    }
})