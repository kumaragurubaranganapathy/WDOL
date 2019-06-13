({
    doSave: function(component, event, helper) {
        if (component.find("fileId").get("v.files").length > 0) {
            helper.uploadHelper(component, event);
        } else {
            alert('Please Select a Valid File');
        }
    },
 
    handleFilesChange: function(component, event, helper) {
        var fileName = component.get("v.fileName");
        var files = event.getSource().get("v.files");
        if(files.length >0){
            for(var i = 0 ; i < files.length; i++){
                fileName.push(files[i]['name']);
            }
        }
        else{
			fileName.push('No Files Selected...');            
        }
        
        component.set("v.fileName", fileName);
        console.log('hellloo'+component.get("v.fileName"));
    },
})