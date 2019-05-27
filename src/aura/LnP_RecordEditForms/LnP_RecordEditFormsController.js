({
    doinit : function(component, event, helper){
        console.log("inside do:init::");
        var sectionName = component.get('v.sectionName');
        var educationRecordType = $A.get('$Label.c.Education_RecordType').toString();
        console.log('educationRecordType'+educationRecordType);
        var trainingRecordType = $A.get('$Label.c.Training_RecordType').toString();
        var experienceRecordType = $A.get('$Label.c.Experience_RecordType').toString();
        var recordType = '';
        component.set('v.sObj','LnP_BackgroundSection__c');
        if(sectionName=='Qualifying Education'){
            
           // if(component.get('v.objectRecordType') !=null) {
                //console.log("type of "+ typeof(educationRecordType)) ;
               recordType='';
               recordType = educationRecordType; 
          //  }

        }
       else if(sectionName=='Qualifying Training'){
           recordType='';
            recordType =trainingRecordType;
        }  
        else if(sectionName=='Qualifying Experience' ){
            recordType='';
            recordType =experienceRecordType;
        }
        component.set('v.objectRecordType',recordType);
        helper.setData(component, event, helper);
    },   
    handleSuccess : function(component, event, helper) {

        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": "Success!",
            "message": "Done!",
            "type": "success"
        });
        //toastEvent.fire();
        
		helper.hideAddRecord(component, event, helper);
		helper.setData(component, event, helper);
        
    },
    handleError : function(component, event, helper) { 
        console.log('Error!');
    },
    /**
     * Control the component behavior here when record is changed (via any component)
     */
    handleRecordUpdated: function(component, event, helper) {
    },
    toggleButton : function(component, event, helper) {
        helper.toggleButtonHelper(component, event, helper);
    },
    handleCancel : function(component, event, helper) {
        //helper.showHide(component);
		helper.hideAddRecord(component, event, helper);
        event.preventDefault();
    },
    handleHiddenCancel : function(component, event, helper) {
		var editNo = '';
        var parentDiv = event.target.parentNode;
       	editNo =  parentDiv.id;
        helper.editRecordHelper(component, event, helper, editNo);
		//event.preventDefault();
    },
    editRecord : function(component, event, helper) {
        //helper.showHide(component);//
        var className = '';
		var editNo = '';
        /*className = event.target.class;
        console.log('DeditNo ' + className);*/
        //editNo = $(event.target).parent().attr('id');
        var parentDiv = event.target.parentNode;
        /*var parentDiv = event.target;
        console.log('parentDiv ' + JSON.stringify(parentDiv));*/
        //var id = parentDiv.getAttribute("id");
        
        //console.log('editNo ' + id);
        //editNo = '1';
       	editNo =  parentDiv.id;
        helper.editRecordHelper(component, event, helper, editNo);
        //event.preventDefault();
    },
    deleteRecord : function(component, event, helper) {
        var parentDiv = event.target.parentNode;
        var editClassNo = parentDiv.className;
		helper.deleteRecordHelper(component, event, helper, editClassNo);
	},
	showAddRecord : function(component, event, helper) {
		var className = component.get('v.objectRecordType');
		className = className+'addRecord';
        var addRecord = document.getElementsByClassName(className);
		for (var i = 0; i < addRecord.length; ++i) {
			var item = addRecord[i];  
			item.classList.remove('slds-hide');
		}
    },
    getRecord : function(component, event, helper) {
		helper.getRecordHelper(component, event);
	},
    validate : function(component, event, helper) {
        var inputCmp = component.find("inputCmp");
        var errorFound = false;
        inputCmp.forEach(function(entry) {
            var value = entry.get("v.value");
            var classes = entry.get("v.class");
            if(classes !=  undefined && classes.includes('mandatory')&&value==null){
                errorFound = true;
            }       
        });
        if(errorFound== true){
            console.log('errors!');
            var resultsToast = $A.get("e.force:showToast");
            resultsToast.setParams({
                "title": "Missing fields",
                "message": "Add mandatory fields."
            });
            resultsToast.fire();
            event.preventDefault();
        }else{
            console.log('no errors!');
             //component.find("editForm").submit();
        }
    },

})