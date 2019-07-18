
;ATTACHMENTCOMPNS = {
    
    /* Function for loading all events */
    loadEvents: function() {
        // Event - Add Attachment Button Click
        $(".addAttachmentBtn").on("change", function(e) {
            // Call save function
            ATTACHMENTCOMPNS.saveRecord(e, $(this).attr("id"));
        });
        
        $(".addAttachmentBtnBB").on("click", function(e) {
            ATTACHMENTCOMPNS.saveRecordToBluebeam(e, $(this).attr("id"));
        });
        
        $(".btn-attest").on("click", function() {
            
            // Get Id
            var currId = $(this).attr("id");
            currId = currId.substring(19, currId.length)
            ATTACHMENTCOMPNS.saveHardCopy(currId);
            
        });
        $(".btn-removeAttest").on("click", function() {
            
            // Get Id
            var currId = $(this).attr("id");
            currId = currId.substring(19, currId.length)
            ATTACHMENTCOMPNS.deleteHardCopy(currId);
            
        });
        $(".btn_addAttach").on("keydown", function(e){
            var key = e.which;
            if(key == 13 || key == 32)  // the enter key code
            {	
               // e.preventDefault();
                $(e.target).find(".addAttachmentBtn").trigger( "click" );
               
            }
        });
        $('body').delegate('.glyphicon-trash', 'keydown', function (e) {
            if(e.which == '13'){
                $(this).trigger("click");
            } 
        });
    },
    
    /* Function for loading data */
    loadRecords: function() {
        
        // Clear attachments
        $(".eachNewAttachment").empty();
        //attachmentList.push(new Attachment());
        //alert(attachmentsList);
        try {
            
            // Initialize markup variable
            var innerHtml = '';
            $.each(attachmentsList, function(i, val) {
            	
            	var documentDetails = val.documentId;
            	var docHTML = "";
            	
            	if(documentDetails != null && documentDetails != "undefined"){
            		var arrDocument = documentDetails.split(";");
                    docHTML = "<br/><br/><a target='_blank' href='/servlet/servlet.FileDownload?file=" + arrDocument[0] + "'>" + arrDocument[1] + "</a>";
            	}
                
                if(val.fileLocationType == 'Bluebeam'){
                	// Build markup
	                    innerHtml += '<div class="eachNewAttachment" id="attDiv'+val.id+'"><div class="row"><h3 id="attDesc'+val.id+'">'+val.name+'</h3></div><div class="row"><div class="col-sm-7"><label>'+val.description+docHTML+'</label></div><div class="col-sm-4"><span>&nbsp;</span></div></div><div class="row"><div class="col-sm-7"><div id="multiplefilenames'+val.id+'"><div id="savemultiplefilenames'+val.id+'"></div></div></div><div class="col-sm-4"><span>&nbsp;</span></div></div><div class="row"><div class="col-sm-7"><span>&nbsp;</span></div><div class="col-sm-4"><div id="addAttachBtn'+val.id+'"><span class="btn btn-secondary btn-file btn_addAttach addAttachmentBtnBB" tabindex="0" id="'+val.id+'">Add Attachment</span></div><div id="removeAttachBtn'+val.id+'" style="display:none"><input type="button" class="btn btn-secondary removeAttachBtn" value="Remove Attachment" id="removeAttBtn' + val.id + '" style="display:none"/></div><input type="hidden" id="subId'+val.id+'" value="" style="display:none"/></div></div><div class="row"><hr></div></div>';
                }else{
	                if(val.submissionType == 'Softcopy: To be Uploaded') {
	                    
	                    // Build markup
	                    innerHtml += '<div class="eachNewAttachment" id="attDiv'+val.id+'"><div class="row"><h3 id="attDesc'+val.id+'">'+val.name+'</h3></div><div class="row"><div class="col-sm-7"></div><div class="col-sm-4"><span>&nbsp;</span></div></div><div class="row"><div class="col-sm-7"><div id="multiplefilenames'+val.id+'"><div id="savemultiplefilenames'+val.id+'"></div></div></div><div class="col-sm-4"><span>&nbsp;</span></div></div><div class="row"><div class="col-sm-7"><span>&nbsp;</span></div><div class="col-sm-4"><div id="addAttachBtn'+val.id+'"><span class="btn btn-secondary btn-file btn_addAttach" tabindex="0">Add Attachment<input type="file" multiple="multiple" class="addAttachmentBtn" id="addAttachmentBtn'+val.id+'" /></span></div><div id="removeAttachBtn'+val.id+'" style="display:none"><input type="button" class="btn btn-secondary removeAttachBtn" value="Remove Attachment" id="removeAttBtn' + val.id + '" style="display:none"/></div><input type="hidden" id="subId'+val.id+'" value="" style="display:none"/></div></div><div class="row"><hr></div></div>';
	                    
	                    //innerHtml += '<div class="eachNewAttachment" id="attDiv'+val.id+'"> <div class="row"> <div class="col-sm-7"> <div class="row"><label id="attDesc'+val.id+'">'+val.name+'</label></div> <label>'+val.description+docHTML+'</label> </div> <div class="col-sm-4"><span>&nbsp;</span></div> </div></div><div class="row"><div class="col-sm-7"> <div id="multiplefilenames'+val.id+'"> <div id="savemultiplefilenames'+val.id+'"></div> <label id="attachmentFileName'+val.id+'"></label> </div></div><div class="col-sm-4"> <div id="addAttachBtn'+val.id+'"><span class="btn btn-secondary btn-file">Add Attachment<input type="file" multiple="multiple" class="addAttachmentBtn" id="addAttachmentBtn'+val.id+'" style="width:100%;height:100%;"/></span></div> <div id="removeAttachBtn'+val.id+'" style="display:none"><input type="button" class="btn btn-secondary removeAttachBtn" value="Remove Attachment" id="removeAttBtn' + val.id + '" style="display:none"/></div> <input type="hidden" id="subId'+val.id+'" value="" style="display:none"/> </div><br/><hr/>';
	                }
	                
	                else if(val.submissionType == 'Hardcopy: To be Mailed') {
	                    
	                    // Build markup
	                    //innerHtml += '<div class="eachNewAttachment" id="attDiv'+val.id+'"><div class="row"><label id="attDesc'+val.id+'">'+val.name+'</label></div><div class="row"><div class="col-sm-7"><label>'+val.description+docHTML+'</label></div><div class="col-sm-4"><span>&nbsp;</span></div></div><div class="row"><div class="col-sm-7"><label id="attestationText'+val.id+'"></label></div><div class="col-sm-4"><div id="attestAttachBtn'+val.id+'"><span class="btn btn-secondary btn-attest" id="attestAttachmentBtn'+val.id+'">Attest</span></div><!--<div id="removeAttstBtn'+val.id+'" style="display:none"><input type="button" class="btn btn-secondary btn-removeAttest" value="Remove Attest" id="removeAttestButton' + val.id + '"/>--><input type="hidden" id="hiddenAttId'+val.id+'" value="" style="display:none"/><input type="hidden" id="subId'+val.id+'" value="" style="display:none"/><!--</div>--></div></div><br/><hr/>';
	                    innerHtml += '<div class="eachNewAttachment" id="attDiv'+val.id+'"><div class="row"><h3 id="attDesc'+val.id+'">'+val.name+'</h3></div><div class="row"><div class="col-sm-7"><label>'+val.description+docHTML+'</label></div><div class="col-sm-4"><span>&nbsp;</span></div></div><div class="row"><div class="col-sm-7"><label class="attestComplete" id="attestationText'+val.id+'"></label></div><div class="col-sm-4"><div id="attestAttachBtn'+val.id+'"><input type="button" class="btn btn-secondary btn-attest" id="attestAttachmentBtn'+val.id+'" value="Attest"></div><input type="hidden" id="hiddenAttId'+val.id+'" value="" style="display:none"/><input type="hidden" id="subId'+val.id+'" value="" style="display:none"/></div></div><div class="row"><hr></div></div>';
	                }
                }
            });
            
            // Inject markup
            $(".eachNewAttachment").append(innerHtml);
            
            // Load previously attached files
            $.each(attachmentsList, function(i, val) {
                
                if(val.isAttested == true) {
                    $("#attestationText" + val.id).text('Attestation complete.');
                    $("#attestAttachmentBtn"+val.id).val('Remove Attestation');
                    //$("#removeAttstBtn"+val.id).show();
                }
                
                $("#subId" + val.id).val(val.id);

                $.each(val.attachmentList, function(j, val2) {

                    $("#multiplefilenames"+val.id).append("<div class='fileRow' id='filetest"+j+"'></div>");
                   // $('#filetest').text(val2.Name);

                    $('#filetest'+j).append('<div id="fileName">'+val2.Name +' <span aria-label="Delete file" role="button" tabindex="0" class="glyphicon glyphicon-trash" id="glyphiconid"></span></div>');
                    
                    $("#glyphiconid").attr('id',"trashdelete"+val2.Id);
                    $("#fileName").attr('id',"fileName"+val2.Id);
                    
                     $('#filetest'+j).attr('id',"name"+val2.Id);
                    
                    // Update UI
                    var hiddenId =   $("#hiddenAttId" + val.id).val(val2.Id);

                    $("#addAttachBtn" + val.id).show();
                    //$("#removeAttachBtn" + val.id).hide();
                }); 
                $(".glyphicon-trash").on("click", function() {
                    // Call delete function
                    ATTACHMENTCOMPNS.deleteRecord($(this).attr("id"));
                    // $("#name"+val2.Id).hide();
                    
                });
            });
            
            // Load events
            ATTACHMENTCOMPNS.loadEvents();
        }catch(e) {}
    },
    
    /* Function for loading attachments based on questions */
    addConditionalAttachments : function() {
        
        // Loop through attachments
        $.each(attachmentsList, function(i, val) {
            //$("#attDiv").show();
            
            if(val.attachmentList.length > 0) {
                $("#attDiv" + val.id).show();
            }
        });
    },
    
    /* Function for deleting attachments */
    deleteRecord: function(currentId) {
        
        currentId = currentId.substring(11, currentId.length);
        
        if(currentId.substring(0, 3)=='00P')
        {            
            var attachmentquery = 'SELECT Id';
            attachmentquery = attachmentquery + " FROM Attachment"  + " WHERE ID = '" +currentId+ "'";
            var resultAttachments = sforce.connection.query(attachmentquery);
            resultAttachments = resultAttachments.getArray("records");
            var result = sforce.connection.deleteIds([currentId]);
            if(resultAttachments.length==1){
                 var result2  =sforce.connection.deleteIds([resultAttachments[0].Id]); 
            }
        }
        
        $.each(attachmentsList, function(i, val) {
            $.each(val.attachmentList, function(j, val2) {
            if(val2 !=undefined){
               if(val2.Id == currentId) {
                    val.attachmentList= val.attachmentList.splice(j,1);
                }
            }
            });
        });

        $("#fileName"+currentId).hide()
        $("#trashdelete"+currentId).hide();
        $("#name"+currentId).hide();
        $("#addAttachBtn" + currentId).show();
    },
    
    /* Create hard copy */
    saveHardCopy: function(currentId) {
        
        // Start spinner
        NOTIFICATIONS.spinnerStart();
        
        // Submission Id
        var submissionId = $("#subId" + currentId).val();
        
        $.each(attachmentsList, function(i, val) {
            if(val.id == submissionId) {
                if((!val.isAttested) || (val.isAttested == null)){
                    // Save a submission record
                    var submissionObj = new sforce.SObject("MUSW__Submission__c");
                    submissionObj.Id = val.id;
                    submissionObj.Attest__c = true;
                    submissionObj.Hardcopy__c = true;
                    submissionObj.Status__c = 'Accepted';
                    submissionObj.MUSW__Submission_DateTime__c = new Date();
                    var result = sforce.connection.upsert("Id", [submissionObj]);
                    
                    if(result[0].getBoolean("success")) {
                        // Update record
                        val.isAttested = true;
                        
                        // UI update
                        $("#attestationText" + currentId).text('Attestation complete.');
                        
                        $("#attestAttachmentBtn"+currentId).val('Remove Attestation');
                    }
                }
                else{
                    var submissionObj = new sforce.SObject("MUSW__Submission__c");
                    submissionObj.Id = val.id;
                    submissionObj.Attest__c = false;
                    submissionObj.Hardcopy__c = false;
                    //submissionObj.Status__c = 'Accepted';
                    submissionObj.MUSW__Submission_DateTime__c = new Date();
                    var result = sforce.connection.upsert("Id", [submissionObj]);
                    
                    if(result[0].getBoolean("success")) {
                        // Update record
                        val.isAttested = false;
                        
                        // UI update
                        $("#attestationText" + currentId).text('');
                        $("#attestAttachmentBtn"+currentId).val('Attest');
                    }
                }
            }
        });
        
        // Stop spinner
        NOTIFICATIONS.spinnerStop();
        
    },
    
    /* Function for removing attest */
    deleteHardCopy: function(currentId) {
        
        // Confirm deletion
        // Submission Id
        var submissionObj = new sforce.SObject("MUSW__Submission__c");
        submissionObj.Attest__c = false;
        submissionObj.Hardcopy__c = false;
        
        //Update UI
        
        $("#attestationText" + currentId).val('');
        $(".btn-removeAttest" + currentId).hide();
        $(".btn-attest"+ currentId).show();
        
    },
    
    /* Function for saving attachments */
    saveRecord: function(e, currentId) {
        //alert('in SaveRecord');
        // Start spinner
        NOTIFICATIONS.spinnerStart();
        
        // Get attachment description
        currentId = currentId.substring(16, currentId.length);
        var submissionId = $("#subId" + currentId).val();
        var attDesc = '';
        var attName = '';
        //alert('submissionId : '+submissionId);
        $.each(attachmentsList, function(i, val) {
            //console.log(attachmentsList);
			//alert('currentId'+currentId);
            if(val.id == currentId) {
                attName = val.name;
                attDesc = val.description;
            }
        });
        
        // Save a submission record
        var submissionObj = new sforce.SObject("MUSW__Submission__c");
        submissionObj.Id = submissionId;
		submissionObj.Name = attName;
        //submissionObj.Status__c = 'Accepted';
        //submissionObj.MUSW__Submission_DateTime__c = new Date();
		//alert('submissionObj : '+submissionObj);
        var result = sforce.connection.upsert("Id", [submissionObj]);
		//alert('result::'+result);
		if(result[0].getBoolean("success") && result[0].id == submissionObj.Id) {
			//alert("upsert updated the submissionObj as expected");
		}
		else{
			//alert("upsert failed!");
		}

		//alert('result : '+result);
        // Call attachment upload method
        if(submissionId != null) {
            ATTACHMENTCOMPNS.readFile(e.originalEvent.target, submissionId, attName, attDesc);
        } else {
            NOTIFICATIONS.spinnerStop();
        }
        
    },
    
    saveRecordToBluebeam: function(e, currentId) {
    	var popup = window.open("/UploadFileToBluebeam?id="+currentId, "UploadFileToBluebeam", "width=600,height=400");
        popup.focus();
    },
    
    saveRecordToBluebeamCallback: function(parentId) {
		$("#savemultiplefilenames"+ parentId).append("<div class='fileRow' id='filetestBB'></div>");
        $('#filetestBB').text("File Uploaded");
        //$('#filetest').attr('id',"savingmultiple"+parentId);
    },
    
    /* Function for handling attachments */
    readFile: function(file, parentId, attName, attDesc) {
        // Get all files
        var filesToUpload = file.files;       
        
        // Loop through all uploaded files                                          
        for(var i = 0, f; f = filesToUpload[i]; i++) {
            // Initialize reader
            var reader = new FileReader();
            
            // Load a file
            reader.file = f;
            
            // Event fires when loading is complete
            reader.onload = function(evt) {    
                // Create attachment object with required fields
                var att = new sforce.SObject("Attachment");
                att.Name = this.file.name;
                
                /*if(att.Name.length>80)
                {
                    var Diff = att.Name.length-80;
                    att.Name = att.Name.substring(0,(att.Name.indexOf(".")-Diff-1))+'.'+att.Name.substring(att.Name.indexOf("."),att.Name.length);
                }*/
                att.ContentType = this.file.type;
                att.ParentId = parentId;
                
                if(attDesc!=null && attDesc.length > 499){
                    attDesc = attDesc.substring(0,498);
                }
                att.Description = attDesc;
                
                // Populate attachment body
                var binary = "";
                var bytes = new Uint8Array(evt.target.result);
                var length = bytes.byteLength;
                
                //Check the file size before attempting to read the file body to prevent the browser from crashing.
                if(length >= 27262976){
                	NOTIFICATIONS.spinnerStop();
                	MODAL_UTILITY.errorMessageModal("The file exceeds the maximum limit of 25 MB.", 'Upload Error');
                	return;
                }
                
                for (var j = 0; j < length; j++) {
                    binary += String.fromCharCode(bytes[j]);
                }
                att.body = (new sforce.Base64Binary(binary)).toString();
                
                //Insert attachment
                sforce.connection.create([att], {
                    onSuccess : function(result, source) {
                        
                        ATTACHMENTCOMPNS.afterUploadSuccess(result, source, parentId, att.Name);
                        
                    },
                    onFailure : function(error, source) {
                        ATTACHMENTCOMPNS.afterUploadFailure(error, source, parentId);
                    }
                });                        
            };
            reader.readAsArrayBuffer(f); 
        } 
    },
    
    /* Function for handling after upload operation */
    afterUploadSuccess: function(result, source, parentId, attName) {
        if (result[0].getBoolean("success")) {
            
            var hidId=  $("#hiddenAttId" + parentId).val(result[0].id);
            
            $("#savemultiplefilenames"+ parentId).append("<div class='fileRow' id='filetest'></div>");
            $('#filetest').text(attName);
            $('#filetest').attr('id',"savingmultiple"+result[0].id);
            $("#savingmultiple"+result[0].id).append(' <span aria-label="Delete file" tabindex="0" class="glyphicon glyphicon-trash" id="glyphiconid"></span>');
            $("#glyphiconid").attr('id',"trashdelete"+result[0].id);
            $(".glyphicon-trash").on("click", function() { 
                
                // Call delete function
                ATTACHMENTCOMPNS.deleteRecord($(this).attr("id"));
                
                var uniqueId = $(this).attr("id");
                uniqueId = uniqueId.substring(11,uniqueId.length);

                $("#savingmultiple"+uniqueId).hide();

            });

            //$("#attachmentFileName" + parentId).css("word-wrap","break-word");
            $("#addAttachBtn" + parentId).show();
            NOTIFICATIONS.spinnerStop();
            
        }
        else {
            NOTIFICATIONS.spinnerStop();
            
            var msg = result[0].errors.message;
            if(msg != null && msg.includes("exceeded maximum")){
            	msg = "The file exceeds the maximum limit of 25 MB.";
            }
            MODAL_UTILITY.errorMessageModal(msg, 'Upload Error');
        }
    },
    
    afterUploadFailure: function(error, source, parentId) {
        NOTIFICATIONS.spinnerStop();
        MODAL_UTILITY.errorMessageModal('An error has occurred. ' + error, 'Upload Error');
        $("#attachmentFileName" + parentId).val("");
    }
}