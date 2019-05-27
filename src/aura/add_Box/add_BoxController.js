({
	handleSectionToggle : function(component, event, helper) {
       var openSections = event.getParam('openSections');
	},
    
    handleSuccess : function(component,event,helper) {
         console.log(event.getParam('id'));
        var Id = event.getParam('id');
        component.find("accordion").set('v.activeSectionName', ''); 
        var action = component.get("c.createAccountContactObject");
        action.setParams({ aId : Id });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
               alert('success');
               $A.get('e.force:refreshView').fire();
            }
            // error handling when state is "INCOMPLETE" or "ERROR"
        });
        $A.enqueueAction(action);
       
    }, 
    handleCancel : function(component, event, helper){
-      	helper.handleCancel(component, event);   
    },
    doinit : function(component,event,helper){
         component.set('v.columns', [
            {label: 'Name', fieldName: 'Name', type: 'text' },
            {label: 'UBI Number', fieldName: 'UBI_Number__c', type: 'number'  },
            {label: 'Email', fieldName: 'Email__c', type: 'Email'},
            {label: 'Business Phone', fieldName: 'Business_Phone__c', type: 'phone' },
            {label: 'Extension', fieldName: 'Extension__c', type: 'number' },
            {label: 'Website', fieldName: 'Website', type: 'text'},
            {label: 'Action', type: 'button', initialWidth: 150, typeAttributes:
			{ label: 'Edit', title: 'Click to Edit', name: 'edit_record', iconName: 'utility:edit'}, class: 'btn_next'},
        ]);

	},
    handleSaveEdition: function (cmp, event, helper) {
        var draftValues = event.getParam('draftValues');
        console.log(draftValues);
        var action = cmp.get("c.updateAccount");
        action.setParams({"acc" : draftValues});
        action.setCallback(this, function(response) {
            var state = response.getState();
            $A.get('e.force:refreshView').fire();
            
        });
        $A.enqueueAction(action);
        
    },
    handleRowAction : function(component,event,helper){
      var row = event.getParam('row');
      component.set("v.recordId",row.Id);    
      component.set("v.recordTitle",row.Name);
      component.set("v.isOpen", true);
             
    },
   
    openModel: function(component, event, helper) {
      // for Display Model,set the "isOpen" attribute to "true"
      component.set("v.isOpen", true);
   },
 
   closeModel: function(component, event, helper) {
      // for Hide/Close Model,set the "isOpen" attribute to "Fasle"  
      component.set("v.isOpen", false);
   },
     
	
})