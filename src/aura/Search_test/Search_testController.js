({
    doInit: function(component, event, helper) {
        var action = component.get('c.getLabel');
        //action.setParams({ imagefile : file});
        
        action.setCallback(this,function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set('v.customLblMap',response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
    },
   
    doSave: function(component, event, helper) {
        if (component.find("fileId").get("v.files").length > 0) {
            helper.uploadHelper(component, event);
        } else {
            alert('Please Select a Valid File');
        }
    },

    handleFilesChange: function(component, event, helper) {
        var fileName = 'No File Selected..';
        if (event.getSource().get("v.files").length > 0) {
            fileName = event.getSource().get("v.files")[0]['name'];
        }
        component.set("v.fileName", fileName);
    }
})