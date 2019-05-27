;REVIEWCOMPNS = {
    
    loadEvents: function() {
        $("#applicationFinalSubmit").on("click", function() {
            // Signature string
            var signStr = licGlobalObj.contactFirstName + ' ' + licGlobalObj.contactLastName;
            signStr = signStr.trim();
            var userSignStr = $("[id$='eSignature']").val().trim();
            
            // If attestation section is incomplete
            if (($("[id$='iAttest']").is(":checked") != true) || ($("[id$='eSignature']").val() == '')) {
                // Show error
                MODAL_UTILITY.errorMessageModal('Please complete attestation section.');
            } else if (userSignStr.toUpperCase() != signStr.toUpperCase()) {
                // Show error
                MODAL_UTILITY.errorMessageModal('Your signature does not match your First Name and Last Name. Please rectify it before continuing.');
            }
            // If all sections are complete
                else {
                    
                    // Start spinner
                    NOTIFICATIONS.spinnerStart();
                    
                    // Submit
                    submitRecord();
                }
        });
        
        $("#applicationPrintConfirmation").on("click", function() {
            // Application print preview popup
            window.open("/ApplicationPrint?board=" + licGlobalObj.boardApiName + "&licenseType=" + licGlobalObj.licenseType + "&applicationType=" + licGlobalObj.applicationType + "&pid=" + licGlobalObj.currentRecId, target = "_blank", "width=900,height=600");
        });
        
        $("#applicationMakePayment").on("click", function() {
            // Navigate to cart
            window.location.href = '/eCart';
        });
        
        $("#applicationToDashboard").on("click", function() {
            // Navigate to dashboard
            window.location.href = '/Dashboard';
        });
        
        $("#applicationDownloadAffidavit").on("click", function() {
            // Navigate to affidavit page
            window.open("{!affidavitLink}");
        });
    },
    
    loadDynamicEvents: function() {
        $(".errorLink").on("click", function() {
            
            reloadQuestions();
            
            // Read data from DOM
            var currErrorRec = $(this).attr("id");
            var currErrorSection = 0;
            var currErrorText = $(this).text();
            
            var nextErrorSection = 0;
            var reviewSection = parseInt(progressBarWidget.progressbar("getReviewSection"));
            
            // Get error message
            currErrorText = currErrorText.substring(currErrorText.indexOf('-') + 2, currErrorText.length);
            
            // Get section
            currErrorSection = parseInt(currErrorRec.substring(3, currErrorRec.indexOf('errorLink')));
            
            // Get record id
            currErrorRec = currErrorRec.substring(currErrorRec.indexOf('errorLink') + 9, currErrorRec.length);
            
            // Redirect to corresponding section
            var currErrSec = progressBarWidget.progressbar("getActiveSection");
            
            // Loop through and build markup
            $.each(validationObj, function(i, val) {
                if (val.orderNumber == reviewSection) {
                    val.progressBarStatus = '';
                }
                
                if (val.orderNumber == currErrorSection) {
                    nextErrorSection = validationObj[i + 1].orderNumber;
                }
            });
            
            progressBarWidget.progressbar("update"); 
            progressBarWidget.progressbar("setActiveSection", currErrorSection);
            progressBarWidget.progressbar("setNextSection", nextErrorSection);
            
            PBAR.handleJustContinue();
        });
    },
    
    /* Function for validating questions */
    validateQuestions: function() {
        
        var isAnswered = true;
        var hasQuestionComp = false;
        var errHtml = '';
        var orderNumber = 0;
        var errorLabel = 'Questions';
        var errorMessage = 'Please answer all questions.';
        
        // Find question section
        $.each(validationObj, function(i, val) {
            $.each(val.subSectionObjMap, function(j, val2) {
                if (val2.componentName == 'QuestionAnswer') {
                    orderNumber = val.orderNumber;
                    hasQuestionComp = true;
                }
            });
        });
        
        if (hasQuestionComp) {
            // Loop through questions list
            $.each(questionsList, function(i, val) {
                
                // Unanswered
                if (val.answerText == '') {
                    // Add error
                    isAnswered = false;
                }
                // Loop through child questions list
                $.each(val.childQueList, function(j, val2) {
                    
                    if (val.answerText == val2.qualifyingParentResponse) {
                        
                        // Unanswered
                        if (val2.answerText == '') {
                            // Add error
                            isAnswered = false;
                        }
                    }
                });
                // Fix for Bug 39683
                if(val.Map_Of_AnswerGroup_childQuestionsGroup_JSON != null) {
                    Object.keys(val.Map_Of_AnswerGroup_childQuestionsGroup).map(function(key, index) {
                        $.each(val.Map_Of_AnswerGroup_childQuestionsGroup[key], function(k, val3) {
                            if(val3.answerText == ''&&val.answerText== val3.qualifyingParentResponse){
                                isAnswered = false;
                            }
                        });
                    });
                }
            });
            
            // Add errors
            if (!isAnswered) {
                
                // Build markup
                errHtml = '<div class="row"><h3>' + errorLabel + ':</h3><div class="errorDetail"><div class="reviewsectionerror"><div><span></span></div></div><p><a id="sec' + orderNumber + 'errorLink" href="#" class="errorLink">' + errorLabel + ' - ' + errorMessage + '</a></p></div></div>';
                
                // Append markup
                $("#appendErrorList").append(errHtml);
                
                $("div[ordernumber='" + orderNumber + "']").removeClass("in-progress").addClass("error");
                
                // Return
                return true;
            } else {
                $("div[ordernumber='" + orderNumber + "']").removeClass("error").addClass("complete");
                return false;
            }
        } else {
            return false;
        }
    },
    
    /* Function for validating questions */
    validateAttachments: function() {
        var isAttached = true;
        var hasAttachmentComp = false;
        var errHtml = '';
        var orderNumber = 0;
        var errorLabel = 'Attachments';
        var errorMessage = 'Please complete all attachments/ attestations.';
        
        // Find attachments section
        $.each(validationObj, function(i, val) {
            $.each(val.subSectionObjMap, function(j, val2) {
                if (val2.componentName == 'AttachmentsComp') {
                    orderNumber = val.orderNumber;                    
                        hasAttachmentComp = true;                  
                    
                }
            });
        });
        
        if (hasAttachmentComp) {
            
            // Loop through attachments list
            $.each(attachmentsList, function(i, val) {
                
                // For soft copy
                if (val.fileLocationType != 'Bluebeam' && val.submissionType == 'Softcopy: To be Uploaded' && val.requiredSubmission==true) {
                    if (val.attachmentList.length <= 0) {
                        // Add error
                        isAttached = false;
                    }
                }
                // For hard copy
                else if (val.submissionType == 'Hardcopy: To be Mailed') {
                    if (val.isAttested == false) {
                        // Add error
                        isAttached = false;
                    }
                }
            });
            
            // Add errors
            if (!isAttached) {
                
                // Build markup
                errHtml = '<div class="row"><h3>' + errorLabel + ':</h3><div class="errorDetail"><div class="reviewsectionerror"><div><span></span></div></div><p><a id="sec' + orderNumber + 'errorLink" href="#" class="errorLink">' + errorLabel + ' - ' + errorMessage + '</a></p></div></div>';
                
                // Append markup
                $("#appendErrorList").append(errHtml);
                
                $("div[ordernumber='" + orderNumber + "']").removeClass("in-progress").addClass("error");
                
                // Return
                return true;
            } else {
                $("div[ordernumber='" + orderNumber + "']").removeClass("error").addClass("complete");
                return false;
            }
        } else {
            return false;
        }
    },
    
    afterSubmit: function() {
        // Update UI
        // Stop spinner
        
        if (!licGlobalObj.noFeeRequired && !licGlobalObj.isInvoiceRequired&&!licGlobalObj.goToScheduler) {
            // Navigate to cart
            window.location.href = '/Cart';
        }
        else if (licGlobalObj.goToScheduler) {
            // Navigate to scheduler
            window.location.href = '/PlanReviewScheduler?permitid='+licGlobalObj.permitId;
        } else {
            // Navigate to dashboard
            window.location.href = '/Dashboard';
        }
    },
    
    removeErrors: function() {
        // Loop through and build markup
        $.each(validationObj, function(i, val1) {
            
            // Loop through subsections
            $.each(val1.subSectionObjMap, function(j, val2) {
                
                // Loop through fields
                $.each(val2.fieldObjMap, function(k, val3) {
                    
                    // Add error message
                    $("#fl" + val3.id).text('');
                    $("#fl" + val3.id).parent().removeClass("error");
                });
                
            });
        });
    },
    
    validateSubComp: function(){
        var isSubComp = true;
        var orderNumber = 0;
        var progressBarStatus='';
        
        
        // Find Background section
        $.each(validationObj, function(i, val) {
            $.each(val.subSectionObjMap, function(j, val2) {
                if (val2.componentName == 'DelegatedAgentComponent' || val2.componentName == 'ProjectInformationComponent') {
                    orderNumber = val.orderNumber;
                    progressBarStatus = val.progressBarStatus;                   
                }
            });
        });
        
        if(progressBarStatus == 'error'){
            isSubComp= false;
        }
        if(!isSubComp){
            return true;
        }
        else {
            $("div[ordernumber='" + orderNumber + "']").removeClass("error").addClass("complete");
            return false;
        }
        
    },
    validatePersonalInfo: function() {
        var isPersonalInfo = true;
        var orderNumberP = 0;
        var progressBarStatusP='';
        
        
        // Find Personal Info section
        $.each(validationObj, function(i, val) {
            if (val.name == 'Personal Information') {
                orderNumber = val.orderNumber;
                progressBarStatusP = val.progressBarStatus;            
                                
            }
        });
        
        if(progressBarStatusP == 'error'){
            isPersonalInfo = false;
        }
        if(!isPersonalInfo){
            return true;
        }
        else {
            $("div[ordernumber='" + orderNumberP + "']").removeClass("error").addClass("complete");
            return false;
        }
    },
    
    getErrors: function() {
        // If already completed review once
        $(".reviewedErrors").show();
        $(".reviewedComplete").hide();
        
        // Empty div
        $("#appendErrorList").empty();
        
        // Validate sections
        var isQueError = REVIEWCOMPNS.validateQuestions();
        var isAttError = REVIEWCOMPNS.validateAttachments();
        var isSubCompErr = REVIEWCOMPNS.validateSubComp();
        var isPersonalInfoErr= REVIEWCOMPNS.validatePersonalInfo();
        
        // Initialize markup variable
        var errHtml = '';
        
        // Local error variable
        var isErrorNow = false;
        var checkaddress =true;
        
        // Loop through and build markup
        $.each(validationObj, function(i, val1) {
            // Add section name
            errHtml = '<div class="row"><h3>' + val1.name + ':</h3>';
            
            // Loop through subsections
            $.each(val1.subSectionObjMap, function(j, val2) {
                // If it has error message
             
                if ((val2.errorMessage != null&&val2.componentName!="BusinessAddress")||(val2.componentName=="BusinessAddress"&&val2.errorMessage != null&&checkaddress)) {
                    // Set error flag
                    if(val2.componentName=="BusinessAddress")
                    {
                        val2.name='Address';
                    }
                    
                    isErrors = true;
                    isErrorNow = true;
                    shouldReviewAgain = true;
                    
                    // Build markup
                    errHtml += '<div class="errorDetail"><div class="reviewsectionerror"><div><span></span></div></div><p><a id="sec' + val1.orderNumber + 'errorLink' + val2.id + '" href="#" class="errorLink">' + val2.name + ' - ' + val2.errorMessage + '</a></p></div>';
                    
                }
                if(val2.componentName=="BusinessAddress"){
                    checkaddress=false;
                }
                
                // Loop through fields
                $.each(val2.fieldObjMap, function(k, val3) {
                    
                    // If it has error message
                    if (val3.errorMessage != null) {
                        // Set error flag                       
                        isErrors = true;
                        isErrorNow = true;
                        shouldReviewAgain = true;
                        
                        // Build markup
                        errHtml += '<div class="errorDetail"><div class="reviewsectionerror"><div><span></span></div></div><p><a id="sec' + val1.orderNumber + 'errorLink' + val3.id + '" href="#" class="errorLink">' + val3.label + ' - ' + val3.errorMessage + '</a></p></div>';
                        
                        // Add error message
                        $("#fl" + val3.id).text(val3.errorMessage);
                        $("#fl" + val3.id).parent().addClass("error");
                    }
                });
            });
            
            if (isErrorNow) {
                errHtml += '</div>';
            } else {
                errHtml = '';
            }
            
            // Reset isErrorNow variable
            isErrorNow = false;
            
            // Append markup
            $("#appendErrorList").append(errHtml);
            
            
        });
        
        // If no errors found       
        if ((!isErrors) && (!isQueError) && (!isAttError) && (!isSubCompErr) && (!isPersonalInfoErr)) {
            // Proceed to next step
            $(".reviewedErrors").hide();
            $(".reviewedComplete").show();
            REVIEWCOMPNS.removeErrors();
        }
        
        // Reset isErrors
        isErrors = false; 
        
        // Load events
        REVIEWCOMPNS.loadDynamicEvents();
    }
}