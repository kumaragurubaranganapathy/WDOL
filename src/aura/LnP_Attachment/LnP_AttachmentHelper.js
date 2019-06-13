({
     handleUploadFinishedHelper : function(component, event,helper) {
		// This will contain the List of File uploaded data and status
        console.log('Uploading');
        //var ctarget = event.currentTarget;
        let uploadedFiles = event.getParam("files"); 
        let previousUploads = component.get("v.uploadedFileList");
       // let uploadFileIds =  

         var fileIds=[];
         uploadedFiles.forEach(function(file){
             fileIds.push(file.documentId);
         });
        if(!$A.util.isEmpty(component.get("v.uploadedFileList"))){
            for(var i = 0; i < previousUploads.length; i++){
                
                fileIds.push(previousUploads[i]);
            }
        }
         console.log('uploadedFiles1233'+uploadedFiles);
         component.set("v.uploadedFileList",fileIds);
         component.set("v.docList",fileIds);
       /*  
         let docList = [];
         for(var i = 0; i < uploadedFiles.length; i++){
             docList.push(uploadedFiles[i].documentId);
         }
         component.set("v.docList",docList);
         var action = component.get("c.FileSize");
        console.log('action -------->'+JSON.stringify(action));
        action.setParams({"docId" : uploadedFiles[0].documentId});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state === 'SUCCESS'){
               alert('response '+JSON.stringify(response));
            }
        })
        $A.enqueueAction(action);*/
    },
        deleteFile : function(component, event, helper) {
        var ctarget = event.currentTarget;
        var id_str = ctarget.dataset.value;
        var action = component.get("c.deleteFiles");
        action.setParams({"documentId" : id_str});
        action.setCallback(this, function(response) {
            var state = response.getState();
            var newList = [];
            if(state === 'SUCCESS'){
                alert('Deleted Succesfully');
                var uploadedFiles = component.get("v.uploadedFileList");
                for(var i = 0; i<uploadedFiles.length; i++){
                    if(uploadedFiles[i] !== id_str){
                        //console.log('push in loop'+JSON.stringify(uploadedFiles[i]));
                        //uploadedFiles.pop(uploadedFiles[i]);
                        newList.push(uploadedFiles[i]);
                    }
                }
                component.set("v.uploadedFileList",newList);
                 component.set("v.docList",newList);
            }
        });
        $A.enqueueAction(action);
    }
})