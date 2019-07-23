({
    handleUploadFinished : function(component, event, helper) {
		helper.handleUploadFinishedHelper(component, event,helper);       
	},
     deleteFile : function(component, event, helper) {
        helper.deleteFile(component,event);
    },
    doInit : function(component, event, helper){
        var list = component.get("v.docList");
        var fileIds =[];
        list.forEach(function(file){
             fileIds.push(file);
         });
        console.log('list12345678'+list);
       
        component.set("v.uploadedFileList",list);
    }    
})