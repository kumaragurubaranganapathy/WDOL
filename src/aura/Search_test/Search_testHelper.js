({
    MAX_FILE_SIZE: 7000000, //Max file size 4.5 MB 
    CHUNK_SIZE: 750000,      //Chunk Max size 750Kb 
    
    uploadHelper: function(component, event) {
       // alert('iniside helper');
        //component.set("v.showLoadingSpinner", true);
        var fileInput = component.find("fileId").get("v.files");
        var file = fileInput[0];
        var self = this;
        console.log('outside if cond ' +file.size);
        if (file.size <= self.MAX_FILE_SIZE ) {
            //component.set("v.showLoadingSpinner", false);
            console.log('inside if cond' +file.size);
            //component.set("v.fileName", 'Alert : File size cannot exceed ' + self.MAX_FILE_SIZE + ' bytes.\n' + ' Selected file size: ' + file.size);
            //return;
        }
        var objFileReader = new FileReader();
        objFileReader.onload = $A.getCallback(function() {
            var fileContents = objFileReader.result;
            var base64 = 'base64,';
            var dataStart = fileContents.indexOf(base64) + base64.length;
            fileContents = fileContents.substring(dataStart);
            self.uploadProcess(component, file, fileContents);
        });
        console.log('inside obj File reader');
        objFileReader.readAsDataURL(file);
    },
    
    uploadProcess: function(component, file, fileContents) {
        var startPosition = 0;
        var endPosition = Math.min(fileContents.length, startPosition + this.CHUNK_SIZE);
        this.uploadInChunk(component, file, fileContents, startPosition, endPosition, '');
    },
    
    
    uploadInChunk: function(component, file, fileContents, startPosition, endPosition, attachId) {
        var getchunk = fileContents.substring(startPosition, endPosition);
        var action = component.get("c.saveChunk");
        var fileId = "";
        action.setParams({
            fileName: file.name,
            base64Data: encodeURIComponent(getchunk),
            contentType: file.type,
            fileId: attachId
        });
        
        action.setCallback(this, function(response) {
            attachId = response.getReturnValue();
            console.log('responsefrom savechunk' + attachId);
            console.log('the value response outside' +attachId);
            var state = response.getState();
            if (state === "SUCCESS") {
                //alert('inside if');
                
                startPosition = endPosition;
                endPosition = Math.min(fileContents.length, startPosition + this.CHUNK_SIZE);
                if (startPosition < endPosition) {
                    this.uploadInChunk(component, file, fileContents, startPosition, endPosition, attachId);
                    
                    console.log('the value of is:' +attachId);
                } else {
                    fileId =  response.getReturnValue();
                   // alert('the fileId is' +fileId);
                    component.set("v.fileId",fileId);
                
                    this.imageTotextConversion(component,event); 
                    //alert('your File is uploaded successfully');
                    //console.log('the value of is inside else:' +attachId);
                  //  component.set("v.recordId", attachId);
                    
                }
            } else if (state === "INCOMPLETE") {
                alert("From server: " + response.getReturnValue());
            } else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
        });
       
        $A.enqueueAction(action);
       // if(fileId != ''){
            
      //  }
    },
    imageTotextConversion : function (component,event){
       //alert('inside the imageTextConversion method');
         component.set("v.showLoadingSpinner", true);
          //console.log('the spinner val is' +v.showLoadingSpinner);
        try{
            return new Promise($A.getCallback(function(resolve, reject) {
                console.log('inside promise');
                var action =  component.get('c.getImageText');
                 var fileId = component.get('v.fileId');
                //alert('the value of fileId:' +fileId);
                action.setParams({ "imageId" : fileId });
                console.log(action);
                action.setCallback(this, function(response){
                    console.log('inside callback');
                    var state = response.getState();
                    if(state==='SUCCESS'){
                        resolve(response.getReturnValue());
                         component.set("v.showLoadingSpinner", false);
                        // alert('success'); 
                         //alert('inside success if' +response.getReturnValue())
                        console.log(result);
                        // window.open(approvedURl.substring(7,approvedURl.length));
                    }else{
                        
                        alert('response.getReturnValue()' +response.getReturnValue());
                    }
                    
                })
                $A.enqueueAction(action);
                
            })).then(
               
                $A.getCallback(function(result){
                    //alert('inside getCall back');
                   // component.set("v.accounts", result);
                   console.log('the resulessss'+result);
                   console.log("v.recordId",result);
                    if(result != null && result != ''){
                        //alert('inside if');
                   component.set("v.recordId",result);
                    
                    alert('your File is uploaded successfully');
                    }
                   else{
                        //alert('inside else');
                   component.set("v.invalidRecord",true);
                    
                    alert('your File is uploaded successfully');
                    }
                    
                })
            )
            
            
        } 
        catch(e){
            console.error('Error Stack Message for showQuestionHelper Helper' + e.stack);	
        }
    }
})