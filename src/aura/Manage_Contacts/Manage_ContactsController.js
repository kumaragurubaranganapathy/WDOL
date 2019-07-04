({
	doInit : function(component,event,helper){
        helper.fetchData(component, event, helper);
	},
    addContact : function(component, event, helper){
        component.set('v.refreshForm', true);
    },
    handleSubmit : function(component,event,helper){
        helper.handleSubmit(component, event);
    },
    handleEditSubmit : function(component,event,helper){
        helper.handleEditSubmit(component, event);
    },
    handleSuccess : function(component,event,helper){
        helper.handleSuccess(component, event);
    },
    handleError : function(component,event,helper){
        helper.handleError(component, event);
    },
    openModel: function(component, event, helper) {
        component.set("v.isOpen", true);
   	},
   	closeModel: function(component, event, helper) { 
      	component.set("v.isOpen", false);
    },
    handleRowAction: function (component, event, helper) {
        var action = event.getParam('action');
        var row = event.getParam('row');
        var recordId = row.Id;
        var name = action.name;
        switch (action.name) {
            case 'edit contact':
             	component.set("v.recordId",recordId);
             	component.set("v.isOpen", true);
                break;
            case 'activate':
                name = 'Active';
                helper.changeContactStatus(component, event, recordId, name);
                break;
            case 'deactivate': 
                name = 'Inactive';
                helper.changeContactStatus(component, event, recordId, name);
                break;
            case 'reinvite':
                helper.reinviteContact(component, event, recordId);
                break;
            default:
                break;
        }
    },
    cancelEdit : function (component, event, helper) {
        component.set("v.recordId","");
        component.set("v.isOpen", false);
    },
	cancelAdd : function (component, event, helper) {
        event.preventDefault();
        component.set('v.refreshForm', false);
    }      
})