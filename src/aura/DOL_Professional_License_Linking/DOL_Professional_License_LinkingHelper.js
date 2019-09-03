({
    doInit : function(component, event, helper) {
        var action1 = component.get("c.getLicenseType")
        action1.setCallback(this, function(response){                                
            var state = response.getState();
            if(state == "SUCCESS") {
                var result = response.getReturnValue();
                component.set("v.licenseTypeList",result);    
            }
        });
       
        $A.enqueueAction(action1);
       
    },
    getProfessional:function(component,event,helper) {
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
 searchLicenseHelper: function(component,event,helper) {
        var columnList =  $A.get("$Label.c.ProfessionalLicenseToDoList").toString().split(',');
        component.set("v.licenseColumnList",columnList);
         var securityCode = '';
         var firstname  = '';
         var licenseNumber  = '';
         var licenseType  = '';
         var dob  = null;
        var lastname  = '';
        var ssn  = '';
        if(component.find("securityTokenId") != undefined) {
            securityCode =component.find("securityTokenId").get('v.value');
        }
        var securityToken = component.find("securityToken");
        if(securityToken != undefined){
            for(var v in securityToken) {
                if(securityToken[v].get('v.name')=='licenseType'){
                    licenseType= securityToken[v].get('v.value');
                } 
                if(securityToken[v].get('v.name')=='license'){
                    licenseNumber= securityToken[v].get('v.value');
                }
                if(securityToken[v].get('v.name')=='FirstName'){
                    firstname= securityToken[v].get('v.value');
                }
                if(securityToken[v].get('v.name')=='lastName'){
                    lastname= securityToken[v].get('v.value');
                }
                if(securityToken[v].get('v.name')=='DOB'){
                    dob = securityToken[v].get('v.value') == '' ? null :securityToken[v].get('v.value');
                }
                if(securityToken[v].get('v.name')=='ssn'){
                    ssn= securityToken[v].get('v.value');
                }                
            }
        }
        var action = component.get("c.getLicenseList");
        action.setParams({
            "securityCode": securityCode, 
            "firstname": firstname,
            "lastname": lastname,
            "licenseNumber":licenseNumber,
            "licenseType":licenseType,
            "dob":dob,
            "ssn":ssn
        }); 
        action.setCallback(this, function(response){
            var state = response.getState();
            console.log("inside state::"+ state);
            if (state === "SUCCESS"){
                var result = response.getReturnValue();
                if(result != ''){
                    component.set("v.LicenseColumnListData",result);
                    $A.util.removeClass(component.find("professionalLicenseDetails"), 'slds-hide');
                } else {
                    
                    $A.util.addClass(component.find("professionalLicenseDetails"), 'slds-hide');	
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Success!",
                        "message": "No License Found!!",
                        "type": "Success"
                    });
                    toastEvent.fire();
                    
                }
            }else{
                console.log("error");
            }
            
        });
        $A.enqueueAction(action); 
      //  ar securityCode = component.find("securityTokenBusiness").get("v.value");
        
    },
    linkLicenseToContactHelper: function(component,event,helper) {
        var contactId = '';
        var action = component.get("c.updateLicenseContact");
        var licenseList = component.get("v.LicenseColumnListData");
        
        contactId = licenseList[0].MUSW__Applicant__c;
        document.body.scrollTop = document.documentElement.scrollTop = 0;
        component.set("v.loadingSpinner",true);
        action.setParams({
            "contactId": contactId, 
        }); 
        action.setCallback(this, function(response){
            var state = response.getState();
            console.log("inside state::"+ state);
            if (state === "SUCCESS"){
                var result = response.getReturnValue();
                if(result == 'Linked successfully'){
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Success!",
                        "message": "Successfully linked your license",
                        "type": "Success"
                    });
                    toastEvent.fire();                    
                    component.set("v.loadingSpinner",false);
                    var urlEvent = $A.get("e.force:navigateToURL");
                    urlEvent.setParams({
                        "url": "/newdashboard"
                    });
                    urlEvent.fire();
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
      sendActivationEmail : function(component,event,helper){
      var action = component.get("c.sendActivationEmail");
        action.setCallback(this, function(response){
            var state = response.getState();
            var result = response.getReturnValue();
            if (state === "SUCCESS"){
                   var message = response.getReturnValue();
                   component.set('v.emailID',message);
                   
                   component.set('v.disabled',false);
                } else {
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Error!",
                        "message": 'Error occoured please contact system admin!!',
                        "type": "Error"
                    });
                    toastEvent.fire();  
                    component.set("v.loadingSpinner",false);
                }
        });
        $A.enqueueAction(action); 
    },
    sendMail : function(component,event,helper){
     component.set('v.disabled',false);
    // component.set('v.emailID','')
    },
    searchLicenseHelperForActivation : function(component,event,helper) {
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
                    var email = message[0].MUSW__Applicant__r.Email;
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
                    component.set('v.ActivationCode',message[0].MUSW__Applicant__r.Security_Code__c);
                    component.set('v.ReviewName','Send Professional Activation Code');
                    component.set('v.disabled',false);                   
                } else {
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "message": $A.get("$Label.c.Activation_Code_No_License"),
                        "type": "Success"
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
    sendMailHelper : function(component,event){
      var action = component.get("c.createReviewRecord");
      var licenseId = component.get('v.LicenseID'); 
      var ReviewName = component.get('v.ReviewName'); 
      var mailtosend = 'Send Professional Activation Code to '+component.get('v.mailToSend'); 
       var mail =  component.get('v.mailID');  
       action.setParams({
            "licenseId": licenseId, 
            "Name":  ReviewName,
           "mail" : mailtosend
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
        account.getElement().scrollIntoView();
    }
})