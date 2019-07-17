({
    doinit : function(component, event, helper){
        var sectionName = component.get('v.sectionName');
        var educationRecordType = $A.get('$Label.c.Education_RecordType').toString();
        console.log('educationRecordType'+educationRecordType);
        var trainingRecordType = $A.get('$Label.c.Training_RecordType').toString();
        var continuingEducationRecordType = $A.get('$Label.c.ContinuingEducation_RecordType').toString();
        var experienceRecordType = $A.get('$Label.c.Experience_RecordType').toString();
        var endorsementRecordType = $A.get('$Label.c.Endorsement_RecordType').toString();
        var providerRecordType = $A.get('$Label.c.Provider_RecordType').toString();
        var educationHistoryRecordType = $A.get('$Label.c.EducationHistory_RecordType').toString();
        var recordType = '';
        if(sectionName=='Endorsement'){
            component.set('v.sObj','Electronic_Notary_Provider_Information__c');
            recordType='';
            recordType = providerRecordType;
        } else if(sectionName=='Course Details'){
            component.set('v.sObj','Education_History__c');
            recordType='';
            recordType =educationHistoryRecordType;
        }      
        else{
            component.set('v.sObj','LnP_BackgroundSection__c');
            if(sectionName=='Qualifying Postsecondary Education'){
                
                // if(component.get('v.objectRecordType') !=null) {
                //console.log("type of "+ typeof(educationRecordType)) ;
                recordType='';
                recordType = educationRecordType; 
                //  }
                
            }
            else if(sectionName=='Qualifying Courses'){
                recordType='';
                recordType =trainingRecordType;
            }  
                else if(sectionName=='Qualifying Experience' ){
                    recordType='';
                    recordType =experienceRecordType;
                }
                    else if(sectionName=='Continuing Education'){
                        recordType = '';
                        recordType = continuingEducationRecordType;
                    }
        }
        component.set('v.objectRecordType',recordType);
        
        helper.setData(component, event, helper);
    },   
    handleSubmit : function(component, event, helper) {
        event.preventDefault();
        component.set("v.editForm", false);
        this.validate(component, event, helper);
    },
    handleEditSubmit : function(component, event, helper) {
        event.preventDefault();
        component.set("v.editForm", true);
        helper.validate(component, event, helper);
    },
    validate : function(component, event, helper) {
        helper.validate(component, event, helper);
    },
    handleSuccess : function(component, event, helper) {
        var payload = event.getParams().response;
        console.log('payload.id=== ' + payload.id);
        component.set("v.educationHistoryId", payload.id);
        if(!$A.util.isEmpty(payload.id) || !$A.util.isUndefined(payload.id)){
            helper.getLicenseData(component, event, helper);
        }
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
        //var parentDiv = event.target.parentNode;
        editNo =  event.getSource().get("v.name");
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
        editNo =  event.target.getAttribute('data-name');
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
    inputClick : function(component,event,helper){
        helper.inputClick(component,event);
    },
    inputEditClick : function(component,event,helper){
    	helper.inputEditClick(component,event);
	},
    test:function(component,event,helper){
    	helper.test(component,event);
	}
})