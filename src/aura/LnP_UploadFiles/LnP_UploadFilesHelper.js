({
	handleUploadFinished : function(component, event) {
		// This will contain the List of File uploaded data and status
        console.log('Uploading');
        let uploadedFiles = event.getParam("files");
        let previousUploads = component.get("v.uploadedFileList");
        console.log('previousUploads-->'+JSON.stringify(previousUploads));
        if(!$A.util.isEmpty(component.get("v.uploadedFileList"))){
            for(var i = 0; i < previousUploads.length; i++){
                uploadedFiles.push(previousUploads[i]);
            }
        }
        console.log('uploadedFiles-->'+JSON.stringify(uploadedFiles));
        component.set("v.uploadedFileList",uploadedFiles);
	},
    deleteFile : function(component, event, helper) {
        var ctarget = event.currentTarget;
        var id_str = ctarget.dataset.value;
        console.log(id_str);
        var action = component.get("c.deleteFiles");
        action.setParams({"documentId" : id_str});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state === 'SUCCESS'){
                alert('Deleted Succesfully');
                var uploadedFiles = component.get("v.uploadedFileList");
                console.log('uploadedFiles'+JSON.stringify(uploadedFiles));
                for(var i = 0; i<uploadedFiles.length; i++){
                    if(uploadedFiles[i].documentId == id_str){
                        uploadedFiles.pop(uploadedFiles[i]);
                        
                    }
                }
                component.set("v.uploadedFileList",uploadedFiles);
            }
        });
        $A.enqueueAction(action);
    }
})