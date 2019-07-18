;APPLYFORSOBJECT = {
    
    loadEvents: function() {
        // Continue button
        
        
        $("#saveAndContinue").on("click", function(e) {   
            
            e.preventDefault();
            if(validationMapper.applicationFields.validator.errors().length <= 0 ) {
                
                $('html, body').animate({ scrollTop: 0 }, 'fast');
                // OH_NOTIFICATIONS.spinnerStart();
                var currentSection = 0;
                currentSection = progressBarWidget.progressbar("getActiveSection");   
                var nextSection1 = progressBarWidget.progressbar("getNextSection");
                var item = $('.progress-bar').find('.active');
                item= item[0];
                NOTIFICATIONS.spinnerStart();
                if(item.children[1].innerHTML=='Questions'){
                    saveQuestions();
                    //In this case, only call Save Questions. The saveAndContinue will be called internally after the questions are saved.
                }
                else{
                    saveAndContinue(currentSection, nextSection1);
                }
                isFirstInsert = false;
            }
            else {
                MODAL_UTILITY.errorMessageModal(validationMapper.applicationFields.validator.errorHtml());
            }
            
        });                       
        
        // Cancel button
        $("#cancelButton").on("click", function() {            
            ACTIONS.displayCancelDialog();
        });
        
        // Save button
        $(".saveAndLater").on("click", function() {  
            NOTIFICATIONS.spinnerStart();   
            APPLYFORLICENSE.quickSave();   
        });
        
        // Save and Download Button 
        $(".saveAndDownload").on("click", function() {  
            NOTIFICATIONS.spinnerStart();   
            APPLYFORLICENSE.quickSave();   
        });
    },
    
    buildValidationObject: function() {
        validationMapper.applicationFields = {};
        validationMapper.applicationFields.validationObject = {};
        validationMapper.applicationFields.validationObject.fields = [];
        $.each(validationObj, function(i, val1) {
            if(progressBarWidget.progressbar("getActiveSection") == val1.orderNumber) {
                $.each(val1.subSectionObjMap, function(j, val2) {
                    $.each(val2.fieldObjMap, function(k, val3) {
                        validationMapper.applicationFields.validationObject.fields.push({
                            element : val3.sType == 'Text' ? $("#vald" + val3.id + " input") : $("#vald" + val3.id + " select"),
                            required : false,
                            name : val3.label,
                            validator : val3.validator,
                            watch : true
                        });
                    });
                });
            }
        });
        validationMapper.applicationFields.validator = new ValidationEngine(validationMapper.applicationFields.validationObject);
    }
}

;ACTIONS = {
    displayCancelDialog: function() {
        bootbox.dialog({
            message: "Are you sure you want to cancel?",
            title: "Confirm Exit",
            onEscape: function() {},
            backdrop: true,
            
            /**
             * @optional Boolean
             * @default: true
             * show a close button
             */
            closeButton: false,
            animate: true,
            className: "my-modal",
            buttons: {
                cancel: {   
                    label: "Exit",
                    className: "btn btn-tertiary",                  
                    callback: function() { window.location.href = "/ApplicationSelection"; }
                },
                continue: {   
                label: "Continue Editing",
                className: "btn btn-primary",                  
                callback: function() { }
        }
                       }
                       });            
    },
    
    displaySaveExitDialog: function() {
        bootbox.dialog({
            message: "Are you sure you want to save and come back later?",
            title: "Confirm Exit",
            onEscape: function() {},
            backdrop: true,
            
            /**
             * @optional Boolean
             * @default: true
             * show a close button
             */
            closeButton: false,
            animate: true,
            className: "my-modal",
            buttons: {
                cancel: {   
                    label: "Exit",
                    className: "btn btn-tertiary",                  
                    callback: function() { window.location.href = "/Dashboard"; }
                },
                continue: {   
                label: "Continue Editing",
                className: "btn btn-primary",                  
                callback: function() { }
        }
                       }
                       });            
    }
}   

// All functions to support address functionality
function processLicenseAddressOpResult()
{
    var resultData = JSON.parse($("span[id$='licAddressResultData']").html()) ;
    var resultPermitData = JSON.parse($("span[id$='permitAddressResultData']").html()) ;
    
    if(resultData.isSuccess == true )
    {
        var callBackParameter = new Object() ;
        callBackParameter.primaryEntityType = resultData.primaryEntityType ;
        
        callBackParameter.licenseId = resultData.licenseId ;
        callBackParameter.contactId = resultData.contactId ;
        callBackParameter.accountId = resultData.accountId ;
        callBackParameter.parcelId = resultData.parcelId ;
        callBackParameter.isLPJobRemaining = false ;
        callBackParameter.contextAddressType = resultData.addressType ;
        
        ADDRESS_UTILITY.handleCallbackFromLicenseOperation( callBackParameter ) ;
    }else if(resultPermitData.isSuccess == true )
    {
        var callBackParameter = new Object() ;
        callBackParameter.primaryEntityType = resultPermitData.primaryEntityType ;

        callBackParameter.permitId = resultPermitData.permitId ;
        callBackParameter.contactId = resultPermitData.contactId ;
        callBackParameter.accountId = resultPermitData.accountId ;
        callBackParameter.parcelId = resultPermitData.parcelId ;
        callBackParameter.isPPJobRemaining = false ;
        callBackParameter.contextAddressType = resultPermitData.addressType ;
        
        ADDRESS_UTILITY.handleCallbackFromPermitOperation( callBackParameter ) ;
    }else
    {
        NOTIFICATIONS.spinnerStop();
        MODAL_UTILITY.errorMessageModal(resultData.message);
    }
}

function licenseQuickSaveForAddress(callBackParameter)
{
    if( typeof  licGlobalObj =="object" )
    {
        if(typeof licGlobalObj.licenseId == "string" && licGlobalObj.licenseId.length == 18 )
        {
            
            callBackParameter.licenseId = licGlobalObj.licenseId ;
            callBackParameter.contactId = licGlobalObj.contactId ;
            callBackParameter.accountId = licGlobalObj.accountId ;
            callBackParameter.isLPJobRemaining = true ;
            
            ADDRESS_UTILITY.handleCallbackFromLicenseOperation( callBackParameter ) ;
        }else if(typeof licGlobalObj.permitId == "string" && licGlobalObj.permitId.length == 18 )
        {
            
            callBackParameter.permitId = licGlobalObj.permitId ;
            callBackParameter.contactId = licGlobalObj.contactId ;
            callBackParameter.accountId = licGlobalObj.accountId ;
            callBackParameter.isPPJobRemaining = true ;
            
            ADDRESS_UTILITY.handleCallbackFromPermitOperation( callBackParameter ) ;
        }else
        {
            
            licenseQuickSaveForAddress_AF(callBackParameter.parcelId,callBackParameter.contextAddressType,callBackParameter.primaryEntityType) ;
        }
    }
}

