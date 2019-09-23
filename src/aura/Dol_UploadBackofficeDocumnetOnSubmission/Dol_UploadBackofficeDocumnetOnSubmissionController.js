({
	doInit : function(component, event, helper) {
		helper.loadUser(component, event, helper);
        helper.getParentLookup(component, event, helper);
        helper.checkProfessionCode(component, event, helper);
        helper.checkImageUrlExists(component, event, helper);
        helper.getimagetypeOptions(component, event, helper);
        //helper.dateUpdate(component, event, helper);
        
	},
    
    uplaod: function(component, event, helper){
        var recordId = component.get("v.recordId");
        var title = component.get("v.title");
        var docName = component.get("v.docName");
        var userName = component.get("v.userEmail");
        var selectedimage = component.find("imageType");
        var imagetype = selectedimage.get("v.value");
        var dateValidationError = component.get("v.dateValidationError");
        
        console.log('title'+title);
        console.log('docName'+docName);
        console.log('userName'+userName);
        console.log('imagetype'+imagetype);
        var archDate = component.get("v.archieveDate");
        console.log('archDate'+archDate);
           
        var valid = true;
        
        if(title == null || title ==""){
            valid = false;
        }
        if(docName == null || docName ==""){
            valid = false;
        }
        if(imagetype == null || imagetype ==""){
            valid = false;
        }
        if(!valid){
             helper.showToast(component, event, "Error!", "error", "Please fill in all required fields.");
        }
        else{
            var valid2 = true;
            if(imagetype === 'Compliance' && (archDate === undefined || archDate === null)){
                valid2 = false;
                helper.showToast(component, event, "Error!", "error", "Archive Date can not be empty for Compliance");
                //helper.setDefaultFields(component);
            }
            if(imagetype === 'Compliance' && (archDate != undefined || archDate != null) && dateValidationError == true){
                valid2 = false;
                helper.showToast(component, event, "Error!", "error", "Archive Date can not be on past");
                //helper.setDefaultFields(component);
            }
            var profCode = component.get("v.profCodeValue");
            if(profCode === 'NoProfessionCode' && valid2 === true){
                helper.showToast(component, event, "Error!", "error", "There is No Professional code associated to the Submission");
                //helper.setDefaultFields(component);
            }
            var imageUrl = component.get("v.ImageUrlValue");
         	console.log('imageUrl=='+imageUrl);

             if(imageUrl === 'SANImageURLExists' && profCode != 'NoProfessionCode' && valid2 === true){
                helper.showToast(component, event, "Error!", "error", "Please delete the existing SAN Image URL before uploading a new one");
                //helper.setDefaultFields(component);
            }
            else if(profCode === 'ProfessionCodeExists' && imageUrl != 'SANImageURLExists' && valid2 == true){
            var action = component.get("c.backofficeUplaod");
       		 action.setParams({
            "recordId" : recordId,
            "docName": docName,
            "user": userName,
            "imagetype": imagetype,
            "archDate" : archDate,   
            }) ; 
            component.set("v.Spinner", true);
        	action.setCallback(this, function(response){
                component.set("v.Spinner", false);
                var status = response.getState();
                if(status === 'SUCCESS'){
                    var result = response.getReturnValue();
                    if (result == 'uploadsuccess'){
                        helper.showToast(component, event, "Success!", "success", "Your document is uploaded to SAN drive.");
                        helper.setDefaultFields(component);
                       	helper.refreshRecords();
                    	helper.closeQuickAction(component, event, helper);
                        
                    }
                    if (result == 'uploadfailed'){
                        helper.showToast(component, event, "Error!", "error", "There is some error.");
                        helper.setDefaultFields(component);
                       	helper.refreshRecords();
                    	helper.closeQuickAction(component, event, helper);
                    }
                }
                if(status === "ERROR"){
                var error = response.getError();
                console.log('some problem'+error[0].message);
                helper.showToast(component, event, "Error!", "error", "There is some error.");
                helper.setDefaultFields(component);
                helper.refreshRecords();
                helper.closeQuickAction(component, event, helper);
                }
        	});
                $A.enqueueAction(action);
        	}  
        }       
    },
    onImageTypeChange : function(component, event, helper){
        component.set("v.displayArchieveDate" , false);
        //Get Value of Deposit Picklist
        var selectCmp = component.find("imageType");
        var value = selectCmp.get("v.value");
        console.log("onImageTypeChange=="+value);
        if(value == 'Compliance'){
            component.set("v.displayArchieveDate" , true);  
            var displayArchieveDate = true;
            console.log("displayArchieveDate=="+displayArchieveDate);
        }
        component.set("v.sanImageType" , value);   
    }, 
    handleCancel : function(component, event, helper) {
        $A.get("e.force:closeQuickAction").fire();
    },
    dateUpdate : function(component, event, helper) {
        console.log('dateUpdate@@!==');
        var archDate = component.get("v.archieveDate");
        console.log('dateUpdate=='+archDate);
        var today = new Date();        
        var dd = today.getDate();
        var mm = today.getMonth() + 1; //January is 0!
        var yyyy = today.getFullYear();
     // if date is less then 10, then append 0 before date   
        if(dd < 10){
            dd = '0' + dd;
        } 
    // if month is less then 10, then append 0 before date    
        if(mm < 10){
            mm = '0' + mm;
        }
        
     var todayFormattedDate = yyyy+'-'+mm+'-'+dd;
        console.log('todayFormattedDate=='+todayFormattedDate);
        if(archDate != '' && archDate !=undefined && archDate < todayFormattedDate){
            component.set("v.dateValidationError" , true);
        }else{
            component.set("v.dateValidationError" , false);
        }
    },
})