({
	doInit : function(component, event, helper) {
		helper.loadUser(component, event, helper);
        helper.checkProfessionCode(component, event, helper);
        helper.checkImageUrlExists(component, event, helper);
        helper.getimagetypeOptions(component, event, helper);
	},
    
    uplaod: function(component, event, helper){
        var recordId = component.get("v.recordId");
        var title = component.get("v.title");
        var docName = component.get("v.docName");
        var userName = component.get("v.userEmail");
        var selectedimage = component.find("imageType");
        var imagetype = selectedimage.get("v.value");
        
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
            var imageUrl = component.get("v.ImageUrlValue");
         	console.log('imageUrl=='+imageUrl);

            if(imageUrl === 'SANImageURLExists'){
                helper.showToast(component, event, "Error!", "error", "Please delete the existing SAN Image URL before uploading a new one");
                helper.setDefaultFields(component);
            }
            var profCode = component.get("v.profCodeValue");
            if(profCode === 'NoProfessionCode'){
                helper.showToast(component, event, "Error!", "error", "Professional code associated to the Submission License is NULL");
                helper.setDefaultFields(component);
            }
            if(imagetype === 'Compliance' && (archDate === undefined || archDate === null)){
                helper.showToast(component, event, "Error!", "error", "Archieve Date can not be empty for Compliance");
                helper.setDefaultFields(component);
            }
            else if(profCode === 'ProfessionCodeExists' && imageUrl != 'SANImageURLExists'){
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
})