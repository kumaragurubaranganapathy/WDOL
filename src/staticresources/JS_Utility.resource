$(function() {
    // Date picker
    $('.customDateNow').datepicker({
        onSelect: function()
        {
            $(this).parent().removeClass("error") ;
            $(this).parent().removeClass("errorElement") ;
            
            // LOGIC TO HANDLE ANIMATION
            $(this).parent().find(".InputLabel").removeClass('InputLabel_Out').addClass('InputLabel_In');
        }
    });

    // Date picker
    $('.customDatePicker').datepicker({
        onSelect: function(){
            $(this).parent().removeClass("error") ;
            $(this).parent().removeClass("errorElement") ;
            var curDate = $(this).val();
            var date = new Date(curDate);
            var day = '' + date.getDate();
            if(day.length < 2) {
                day = '0' + day;
            }
            var month = '' + (date.getMonth() + 1);
            if(month.length < 2) {month = '0' + month;}
            var year = '' + date.getFullYear();
            $(this).val(year + '-' + month + '-' + day);
            console.log(year + '-' + month + '-' + day);
        }
    });

    // Hide suggested date
    $(".dateFormat").hide();

    //apply lookup style on element that has a lookup field
    $('.lookupInput').find('input').attr('disabled', true);
    $('.lookupInput').find('a').removeClass().addClass("lookup-icon glyphicon glyphicon-search");
    
});



NOTIFICATIONS = {

    spinnerStart : function(){
        $('.notification').html('');
        $('.notification').append('<p>Application Loading</p>');
        // IF SPINNER IS ALREADY started , go back
        if($("#oh_app_page_spinner_inline_div").length > 0 )
        {
            return false ;
        }
 		
        var overlaySpinner = $("<div>").attr({"id":"oh_app_page_spinner_inline_div"}).addClass("spinner")
        .append($("<div>").addClass("spinner-icon"));
       
        $("body").append(overlaySpinner);
        
     },

    spinnerStop  : function(){
        $('.notification').html('');
        $('.notification').append('<p>Loading completed</p>');
        $("#oh_app_page_spinner_inline_div").remove();
        
    },

    showSuccessMessage : function(title,errorMessage,targetElement){
        var err = $("<div>").addClass("alert alert-success").attr("role","alert").append(
            $("<span>").addClass("glyphicon glyphicon-exclamation-sign").attr("aria-hidden",true).html($("<b>").html(" " + title )),
            $("<p>").html(errorMessage)).attr("title","Click to hide this  message ");
        targetElement.html(err).show();
        targetElement.click(function(){
            $(this).hide();
        });
    },

    showWarningMessage : function(title,errorMessage,targetElement){
        var err = $("<div>").addClass("alert alert-warning").attr("role","alert").append(
            $("<span>").addClass("glyphicon glyphicon-exclamation-sign").attr("aria-hidden",true).html($("<b>").html(" " + title )),
            $("<p>").html(errorMessage)).attr("title","Click to hide this  message ");
        targetElement.html(err).show();
        targetElement.click(function(){
            $(this).hide();
        });
    },

    showErrorMessage : function(title,errorMessage,targetElement)
    {
        var err = $("<div>").addClass("alert alert-danger").attr("role","alert").append(
            $("<span>").addClass("glyphicon glyphicon-exclamation-sign").attr("aria-hidden",true).html($("<b>").html(" " + title )),
            $("<p>").html(errorMessage)).attr("title","Click to hide this  message ");
        targetElement.html(err).show();
        targetElement.click(function(){
            $(this).hide();
        });
    }
}



;OH_MODAL_UTILITY = {
    openDeleteConfirmationModal : function(deleteConfirmationMessage , deleteWarningTitle , callBackParameters , callbackFunctionOnDelete )
    {
        bootbox.dialog({
        message:deleteConfirmationMessage ,
        title: deleteWarningTitle,
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
                label: "Cancel",
                className: "btn btn-tertiary",
                callback: function() { }
            },
            continue: {
                    label: "Delete",
                    className: "btn btn-primary",
                    callback: function()
                    {
                        if(typeof callbackFunctionOnDelete === "function")
                        {
                            callbackFunctionOnDelete(callBackParameters);
                        }
                    }
            }
           }
          });


    },

    openContinueConfirmationModal : function(contConfirmationMessage , contWarningTitle , callBackParameters , callbackFunctionOnContinue )
    {
        bootbox.dialog({
        message:contConfirmationMessage ,
        title: contWarningTitle,
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
                label: "Cancel",
                className: "btn btn-tertiary",
                callback: function() { }
            },
            continue: {
                    label: "Continue",
                    className: "btn btn-primary",
                    callback: function()
                    {
                        if(typeof callbackFunctionOnContinue === "function")
                        {
                            callbackFunctionOnContinue(callBackParameters);
                        }
                    }
            }
           }
          });


    },

    openCancelConfirmationModal : function(cancelConfirmationMessage , cancelWarningTitle , callBackParameters , callbackFunctionOnCancel )
    {
        bootbox.dialog({
        message:cancelConfirmationMessage ,
        title: cancelWarningTitle,
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
                label: "No",
                className: "btn btn-tertiary",
                callback: function() { }
            },
            continue: {
                    label: "Yes",
                    className: "btn btn-primary",
                    callback: function()
                    {
                        if(typeof callbackFunctionOnCancel === "function")
                        {
                            callbackFunctionOnCancel(callBackParameters);
                        }
                    }
            }
           }
          });


    },

    errorMessageModal : function(errorMessage , errorTitle)
    {
        bootbox.dialog({
            message:errorMessage ,
            title: errorTitle,
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
                        label: "OK",
                        className: "btn btn-primary",
                        callback: function() {}
                }
            }
        });
        $(this).init(function(){
            setTimeout(function(){
                $('.modal-body').attr('tabindex','0').focus();
            }, 1000);
        });

    },

     successMessageModal : function(successMessage , successTitle, callackParameters, callbackFunctionOnOk)
    {
        bootbox.dialog({
            message:successMessage ,
            title: successTitle,
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
                        label: "OK",
                        className: "btn btn-primary",
                        callback: function() {
                            if(typeof callbackFunctionOnOk === "function"){
                                callbackFunctionOnOk(callackParameters);
                            }
                        }
                }
            }
        });


    },

    openModalWithOptions : function(modalContent,modalTitle){
        bootbox.dialog({
            onEscape: true,
            backdrop: undefined,
            closeButton: false,
            animate: true,
            message : modalContent ,
            title : modalTitle,
            className: "my-modal"
        });
    },

    openModalWithOptions2 : function(modalContent,modalTitle){
        bootbox.dialog({
            onEscape: function() {},
            backdrop: true,
            closeButton: false,
            animate: true,
            message : modalContent ,
            title : modalTitle,
            className: "my-modal"
        });
    }
}



;OH_GLOBALINFO = {
    getProfileId :function()
    {
        if(typeof licGlobalObj !== "undefined")
        {
            return licGlobalObj.contactId ;
        }else{
            return null ;
        }
    },

    getLicenseId : function()
    {
        if(typeof licGlobalObj !== "undefined")
        {
            return licGlobalObj.licenseId ;
        }else{
        return null ;
       }
    }
}

;OH_ID_UTILITY = {
    escVFId : function(myid)
    {
     return '#' + myid.replace(/(:|\.)/g,'\\\\$1');
    }
}


jQuery.fn.extend({
      bindAnimatedForm: function() {
        this.find(".animated-input-group").each(function(index,val)
        {
            if($(val).find('input:text').hasClass('inAnimate')){
                 $(val).find(".InputLabel").removeClass('InputLabel_Out').addClass('InputLabel_In');
                return
            }
            // BIND RESPECTIVE EVENTS TO EACH ELEMNENTS
            if($(val).find("input:text").length == 1 || $(val).find("input:password").length == 1 || $(val).find("textarea").length == 1)
            {
                var inputElement = null;
                if($(val).find("input:text").length == 1){
                  inputElement = $(val).find("input:text");
                } else if($(val).find("input:password").length == 1){
                  inputElement = $(val).find("input:password");
                } else if ($(val).find("textarea")){
                  inputElement = $(val).find("textarea");
                } else {
                  inputElement = null;
                }

                // var inputElement = $(val).find("input:text").length == 1 ? $(val).find("input:text") : $(val).find("textarea") ;

                if(inputElement.val() == '')
                {
                    $(val).find(".InputLabel").removeClass("InputLabel_In").addClass("InputLabel_Out") ;
                }else
                {
                    $(val).find(".InputLabel").removeClass("InputLabel_Out").addClass("InputLabel_In") ;
                }

                inputElement.on('focus',function()
                {
                    $(val).find(".bottomShade").addClass("activeSpan");
                    $(val).find(".InputLabel").removeClass("InputLabel_Out").addClass("InputLabel_In") ;
                });

                // Below function is required , DO NOT REMOVE - BW

                 inputElement.on('blur',function()
                 {
                     $(val).find(".bottomShade").removeClass("activeSpan");

                     if($(this).val().trim().length == 0 )
                     {
                         $(val).find(".InputLabel").removeClass('InputLabel_In').addClass('InputLabel_Out');
                     }else
                     {
                         $(val).find(".InputLabel").removeClass('InputLabel_Out').addClass('InputLabel_In');
                     }
                 });

                 // To validate Numeric inputs
                 if($(val).hasClass("NumberOnly"))
                 {
                    inputElement.on("keyup",function(e)
                    {
                        if($.isNumeric($(this).val()) == false )
                        {
                            $(this).val('') ;
                        }
                    });
                 }

            }else if($(val).find("select").length == 1)
            {
                $(val).find(".InputLabel").removeClass("InputLabel_Out").addClass("InputLabel_In") ;
            }
            ///***********  BINDING ENDS *********
        });
      },
      unBindAnimatedForm: function()
        {
            // ADD SOME CODE TO REMOVE ALL BINDINGS
        }
    });