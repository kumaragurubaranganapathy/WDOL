({
	clickCreate : function(component, event) {
        console.log('inside the click create');
       	component.set("v.spinner",true);
      
		var action = component.get("c.registerNewCommunityUser");
        var firstName = component.find("firstName").get("v.value");
        var middleName = component.find("middleName").get("v.value");
        var lastName = component.find("lastName").get("v.value");
        var phoneNum = component.find("phoneNumber").get("v.value");
        var birthdate = component.find("birthdate").get("v.value");
        var emailid = component.find("email").get("v.value");
        var password = component.find("password").get("v.value");
        var confirmpwd = component.find("confirmPassword").get("v.value");
        console.log("inside registering::");
        action.setParams({ 
            "firstN": firstName,
            "middleN": middleName,
            "lastN": lastName,
            "phoneN": phoneNum,
            "email": emailid,
            "pwd": password,
            "confirmpwd": confirmpwd,
            "birthdate":birthdate
        });

        action.setCallback(this, function(a) {
        	var state = a.getState();
            if (state === "SUCCESS") {
                console.log("Successfully returned");
                var name = a.getReturnValue();
                if(name == 'User created successfully'){
                    component.set("v.popupHeader", "Successfully Registered");
                    component.set("v.popupBody", "Please check your email to proceed!!");
                    this.resetData(component);
                    component.set("v.serverStatus", "success");
                } else {
                    component.set("v.popupHeader", "Problem!!");
                    component.set("v.popupBody", name);
                    component.set("v.serverStatus", "fail");
                }
                component.set("v.spinner",false);
                component.set("v.isOpen", true);
                
            } else {
                let errors = response.getError();
                console.log(errors);
            }
        });
      	$A.enqueueAction(action);
       
	},
    checkPassword: function(component, event){
        var valueEntered = event.getSource().get("v.value");
        if(valueEntered.length >= "10"){
            component.set("v.lengthChecker",true);
        } else{
            component.set("v.lengthChecker",false);
        }
            
        if(valueEntered.match(/[A-Z]/g)){
            component.set("v.upperChecker",true);
        } else{
            component.set("v.upperChecker",false);
        }
        
        if(valueEntered.match(/[a-z]/g)){
            component.set("v.lowerChecker",true);
        } else {
            component.set("v.lowerChecker",false);
        }
        
        if(valueEntered.match(/[0-9]/g)){
            component.set("v.numberChecker",true);
        } else {
            component.set("v.numberChecker",false);
        }
        
        if(valueEntered.match(/.[!,@,#,$,%,^,&,*,?,_,~,-,(,)]/)){
            component.set("v.specialChecker",true);
        } else {
            component.set("v.specialChecker",false);
        }
        
        this.passwordSameAsName(component, event);
        
        if(component.get("v.lengthChecker") && component.get("v.upperChecker") &&
           component.get("v.lowerChecker") && component.get("v.numberChecker") &&
           component.get("v.specialChecker") && component.get("v.sameAsNameChecker")){
           	component.set("v.validationObject.passwordValidation", true);
        } else {
            component.set("v.validationObject.passwordValidation", false);
        }
    },
    passwordSameAsName: function(component, event){
        var firstNameValue = component.find("firstName").get("v.value");
        var lastNameValue = component.find("lastName").get("v.value");
        var passwordValue = component.find("password").get("v.value");
        if((firstNameValue != "" && passwordValue.indexOf(firstNameValue) !== -1 ) || (lastNameValue != "" && passwordValue.indexOf(lastNameValue) !== -1)){
            component.set("v.sameAsNameChecker",false);
        } else {
            component.set("v.sameAsNameChecker",true);
        }
    },
    confirmPassword: function(component, event) {
        var confirmPasswordValue = event.getSource().get("v.value");
        var passwordValue = component.find("password").get("v.value");
        if(confirmPasswordValue != passwordValue){
            component.set("v.passwordMsg", "Password not matching");
            component.set("v.validationObject.confirmPasswordValidation", false);
        } else {
            component.set("v.passwordMsg", "");
            component.set("v.validationObject.confirmPasswordValidation", true);
        }
    },
    dateValidation: function(component, event) {
        console.log('Entered date val');
        var valueVal = component.find("birthdate").get("v.value");
        console.log('valueVal==' + valueVal);
        var today = new Date();
        var compareDate = today.getFullYear()+'/'+(today.getMonth().length>1?(today.getMonth()+1):'0'+(today.getMonth()+1))+'/'+today.getDate();
        compareDate = new Date(compareDate);
        var enteredDate = new Date(valueVal);
        if(enteredDate < compareDate){
            component.set("v.dateMsg", "");
            component.set("v.validationObject.birthdateValidation", true);
        }else{
            component.set("v.dateMsg", "Date must be prior to today's.");
            component.set("v.validationObject.birthdateValidation", false);
        }
    },
    validateForm: function(component, event){
        component.find("firstName").showHelpMessageIfInvalid();
        component.find("lastName").showHelpMessageIfInvalid();
        component.find("birthdate").showHelpMessageIfInvalid();
        component.find("email").showHelpMessageIfInvalid();
        var confirmEmail = component.find("confirmEmail");
        confirmEmail.showHelpMessageIfInvalid();
        component.find("password").showHelpMessageIfInvalid();
        component.find("confirmPassword").showHelpMessageIfInvalid();
        if (confirmEmail.get("v.validity").valid) {
            this.clearValidityError(confirmEmail);
            this.confirmEmail(component,confirmEmail); 
        }else{
            this.clearValidityError(confirmEmail);
            confirmEmail.showHelpMessageIfInvalid();
        } 
        this.validatePhone(component);
        if(component.find("firstName").get('v.validity').valid){
           component.set("v.validationObject.firstNameValidation", true); 
        }else{
          component.set("v.validationObject.firstNameValidation", false);   
        }
        
        if(component.find("lastName").get('v.validity').valid){
           component.set("v.validationObject.lastNameValidation", true); 
        }else{
           component.set("v.validationObject.lastNameValidation", false); 
        }
        
        if(component.find("phoneNumber").get('v.validity').valid){
           component.set("v.validationObject.phoneNumberValidation", true); 
        }else{
           component.set("v.validationObject.phoneNumberValidation", false);
        }
        
        if(component.find("email").get('v.validity').valid){
           component.set("v.validationObject.emailValidation", true); 
        }else{
           component.set("v.validationObject.emailValidation", false); 
        }
        
        if(component.find("confirmEmail").get('v.validity').valid){
           component.set("v.validationObject.confirmEmailValidation", true); 
        }else{
           component.set("v.validationObject.confirmEmailValidation", false); 
        }
        
        // flag check to enable submit function
        var validationObjectHolder = component.get("v.validationObject");
        var validationKeysArray = Object.keys(validationObjectHolder);
        var enableSubmitFinder =  validationKeysArray.every(function(item, index, array){
            return validationObjectHolder[item] === true;
        });
        component.set("v.enableSubmit", enableSubmitFinder);
        if(component.get("v.enableSubmit")){
            this.clickCreate(component, event);
        } else {
            console.log("Error");
        }
        
    },
    confirmEmail: function(component,confirmEmail) {
        var confirmEmailValue = confirmEmail.get("v.value");
        var emailValue = component.find("email").get("v.value");
        if(confirmEmailValue  != emailValue){
            confirmEmail.setCustomValidity('Confirm email does not match');
            
        }else{
            confirmEmail.setCustomValidity('');
        }
        confirmEmail.reportValidity();
    },
    clearValidityError: function(component) {
        component.setCustomValidity('');
        component.reportValidity();
    },
    validatePhone: function(component) {
        var phoneNumber = component.find("phoneNumber");
        var term = phoneNumber.get("v.value");
        const regex = /^\(?([0-9]{3})\)?[.]?([0-9]{3})[.]?([0-9]{4})$/;
        this.clearValidityError(phoneNumber);
        if(term !="" && !regex.test(term)){
            phoneNumber.setCustomValidity('Please enter phone number in correct format');
            phoneNumber.reportValidity();
        }
    },
	closeModel: function(component, event) {
		component.set("v.isOpen", false);
        if(component.get("v.serverStatus") == "success"){
            //var urlEvent = $A.get("e.force:navigateToURL");
            //urlEvent.setParams({
            //    "url": "/login/"
            //});
            //urlEvent.fire();
            window.location.href = $A.get("$Label.c.Polaris_Portal_Home")+'login/';
        }
	},
    resetData: function(component) {
        component.find("firstName").set("v.value", "");
        component.find("middleName").set("v.value", "");
        component.find("lastName").set("v.value", "");
        component.find("phoneNumber").set("v.value", "");
        component.find("birthdate").set("v.value", "");
        component.find("email").set("v.value", "");
        component.find("confirmEmail").set("v.value", "");
        component.find("password").set("v.value", "");
        component.find("confirmPassword").set("v.value", "");
        
        component.set("v.lengthChecker", false);
        component.set("v.upperChecker", false);
        component.set("v.lowerChecker", false);
        component.set("v.numberChecker", false);
        component.set("v.specialChecker", false);
    },
    showPasswordChecker: function(component, event){
        document.getElementById("passwordStrength").style.visibility = "visible";
    },
    hidePasswordChecker: function(component, event){
        document.getElementById("passwordStrength").style.visibility = "hidden";
    },
    hideOrShowSpinner: function(component, event, helper){
        var spinner = component.find('spinner');
        $A.util.toggleClass(spinner, 'slds-hide');
    },
    changepattern: function(component, event){
        var fieldval=component.find("phoneNumber").get("v.value");
        if(fieldval.length==10){
            var trimmedNo = ('' + fieldval).replace(/\D/g, '');
            var phone = trimmedNo.slice(0, 3)+'.'+trimmedNo.slice(3,6) + '.' + trimmedNo.slice(6);
            event.getSource().set('v.value',phone);    
        }
    }
})