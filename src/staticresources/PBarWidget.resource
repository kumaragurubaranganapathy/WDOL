/**
 * progress bar widget definition
 */
$.widget('dd.progressbar', {      
    options: {
        activeSection: 0,
        reviewSection: 0,
        nextSection: 0,
        errorList: []
    },
    
    getActiveSection: function() {
        return this.options.activeSection;
    },
    
    getNextSection: function() {
        return this.options.nextSection;
    },
    
    setActiveSection: function(val) {
        this.options.activeSection = val;
        var currentDiv = $("div[orderNumber='" + val + "']");                
        currentDiv.addClass( 'active' );       
    },
    
    setNextSection: function(val) {
        this.options.nextSection = val;      
    },
    
    getReviewSection: function() {
        return this.options.reviewSection;
    },
    
    addError: function(iSectionNum, iSubSectionNum, sFieldName, sErrorMessage, bIsLicenseObjError) {
        var ValidationError = {sectionNum: iSectionNum, subSectionNum: iSubSectionNum, fieldName: sFieldName, errorMessage: sErrorMessage, isLicenseObjError: bIsLicenseObjError};
        this.options.errorList.push(ValidationError);
    },
    
    removeError: function(iSectionNum, iSubSectionNum, sFieldName) {
        for( var i = 0; i < this.options.errorList.length; i++) {
            var currentError = this.options.errorList[i];
            if ( currentError.sectionNum === iSectionNum && currentError.subSectionNum === iSubSectionNum && currentError.fieldName === sFieldName ) {
                this.option.errorList.splice(i, 1);
                break;
            }
        }
    },
    
    // remove all errors that apply to the license object only - leaves all other errors in the list
    removeAllLicenseErrors: function() {
        for( var i = 0; i < this.options.errorList.length; i++) {
            var currentError = this.options.errorList[i];
            if ( currentError.isLicenseObjError ) {
                this.option.errorList.splice(i, 1);
            }
        }        
    },
    
    getAllErrors: function() {
        return this.options.errorList;
    },
    
    /**
     * method that updates the visual state of the progress bar when the "model" for 
     * the prgress bar has changed
     */
    update: function() {
        
        // read the progress bar data again bc it was updated
        try {
            // Get progressbar data
            var pBarData = validationObj; 
            var that = this;
            $.each(pBarData, function(i, section) {
                var currentDiv = $("div[orderNumber='" + section.orderNumber + "']");                
                currentDiv.removeClass( 'active' );
                currentDiv.addClass( section.progressBarStatus );
                
                if(currentDiv.hasClass('error') && currentDiv.hasClass('in-progress'))
                    currentDiv.removeClass( 'in-progress' );
                
                if(currentDiv.hasClass('complete') && currentDiv.hasClass('in-progress'))
                {
                    //currentDiv.removeClass( 'complete' ); Bug 40215 -changed by Akosa Okwudiafor.
                     if( $("div[orderNumber='" + section.orderNumber + "']")[0].classList.length==3)
                    {
                        if( $("div[orderNumber='" + section.orderNumber + "']")[0].classList[1]=='in-progress')
                        {
                            currentDiv.removeClass( 'in-progress' );   
                        }
                        else if( $("div[orderNumber='" + section.orderNumber + "']")[0].classList[1]=='complete')
                        {
                            currentDiv.removeClass( 'complete' );   
                        }
                            else{
                                currentDiv.removeClass( 'complete' );   
                            }
                    }
                    else{
                        currentDiv.removeClass( 'complete' );   
                    }
                   // currentDiv.removeClass( 'in-progress' );
                }
                if(currentDiv.hasClass('error') && currentDiv.hasClass('complete'))
                {
                    if( $("div[orderNumber='" + section.orderNumber + "']")[0].classList.length==3)
                    {
                        if( $("div[orderNumber='" + section.orderNumber + "']")[0].classList[1]=='complete')
                        {
                            currentDiv.removeClass( 'complete' );   
                        }
                        else if( $("div[orderNumber='" + section.orderNumber + "']")[0].classList[1]=='error')
                        {
                            currentDiv.removeClass( 'error' );   
                        }
                            else{
                                currentDiv.removeClass( 'complete' );   
                            }
                    }
                    else{
                        currentDiv.removeClass( 'complete' );   
                    }
                    // Bug 40215 -changed by Akosa Okwudiafor.
                    //currentDiv.removeClass( 'complete' );  
                }
                
                // logic to build a list of errors - starts here
                if (section.hasOwnProperty('subSectionObjMap') ) {
                    $.each( section.subSectionObjMap, function(i, subSection) {
                        if(subSection.progressBarStatus == 'error') {
                            $.each( subSection.fieldObjMap, function(i, field ) {
                                // all the errors from the Server are for the license2 object (for now)
                                that.addError(section.orderNumber, subSection.orderNumber, field.name, field.errorMessage, true);
                            });
                        } 
                    });
                } 
                
                
                // logic to build a list of errors - ends here
                
                if ( section.progressBarStatus && section.progressBarStatus.includes('active') ) {    
                    that.options.activeSection = section.orderNumber;
                    if(that.options.activeSection != that.options.reviewSection) {
                        that.options.nextSection = validationObj[i+1].orderNumber;
                    }
                    else {
                        that.options.nextSection = validationObj[0].orderNumber;
                    }
                }
            }); 
        }
        catch(err) { 
            // TODO: need logic to handle errors!!!
            console.log(err);
        }  
        
        // Build validation object
        APPLYFORSOBJECT.buildValidationObject();                    
    },
    
    _create: function() {     
        
        // Get progressbar data     
        var pBarData = validationObj;         
        var container = $('<div>').attr( {class: 'progress-bar' } );  
        
        var that = this;
        try {
            $.each(pBarData, function(i, val) {
                
                var progressSection = $('<div>').attr( {class: 'progress-section ' + val.progressBarStatus, orderNumber: val.orderNumber, tabindex: 0, role: 'button' } );
                if ( val.progressBarStatus && val.progressBarStatus.includes('active') ) {
                    that.options.activeSection = val.orderNumber;
                    
                    
                    if(that.options.activeSection != that.options.reviewSection) {
                        that.options.nextSection = validationObj[i+1].orderNumber;
                        
                    }
                    else {
                        that.options.nextSection = validationObj[0].orderNumber;
                    }
                }  
                // Set review section
                that.options.reviewSection = val.orderNumber;   
                
                $('<span>').appendTo( $('<div>').appendTo(progressSection) );
                $('<h6>').html( val.name ).appendTo(progressSection);
                progressSection.appendTo(container);                        
            });
        }
        catch(e) {
            OH_MODAL_UTILITY.errorMessageModal('Invalid data in configuration. Please check.' + e);
        }
        
        
        container.appendTo(this.element);
        
        var that = this;
        // handle on click event -- 
        $( '.progress-section' ).on('click', function() {                   
            that._trigger( "navigate", null, { nextSection: Number($(this).attr('orderNumber')), currentSection: that.options.activeSection } );
        });
        $( '.progress-section' ).on('keydown', function(e) {       
            var code = e.which;
            if ((code === 13) || (code === 32)) {
                $(this).click();
            }
        });
    },                
    
    _destroy: function() {},
    
    _setOption: function(key, value) {}
});

;PBAR = {       
    handleSaveAndContinue: function() {
        // If first insert
        if(isFirstInsert) {
            ATTACHMENTCOMPNS.loadRecords();
            isFirstInsert = false;
        }
        
        progressBarWidget.progressbar("update"); 
        currentSec = progressBarWidget.progressbar("getActiveSection");
        $(".pageSection").hide();
        $("#section" + currentSec).show();
        $(".progress-section.active").focus();
        $('.animated-input-group.error').find("span.errorHidden").remove();
        $('.animated-input-group.error').find("label").prepend("<span class='errorHidden'>error</span>");
        
        if( currentSec == progressBarWidget.progressbar("getReviewSection") ) {
            $(".buttonGroupFooter").hide();
             REVIEWCOMPNS.getErrors();
        } 
        else {
            $(".buttonGroupFooter").show();
        }  

        //forces YouTube video to pause if there is a video component on the page and when you change between tabs/save the record
        if($("#ik_player_iframe").length > 0){
            ik_player.pauseVideo();
        }

        NOTIFICATIONS.spinnerStop();
    },
    
    handleJustContinue: function() {
        currentSec = progressBarWidget.progressbar("getActiveSection");
        $(".pageSection").hide();
        $("#section" + currentSec).show(); 
        $(".progress-section.active").focus();
        $('.animated-input-group.error').find("span.errorHidden").remove();
        $('.animated-input-group.error').find("label").prepend("<span class='errorHidden'>error</span>");
        
        if( currentSec == progressBarWidget.progressbar("getReviewSection") ) {
            $(".buttonGroupFooter").hide();
            REVIEWCOMPNS.getErrors();
        } 
        else {
            $(".buttonGroupFooter").show();
        }      
        
        NOTIFICATIONS.spinnerStop();
    }
}

