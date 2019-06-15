// Questions Component Namespace
;
QUESTIONSCOMPNS = {
    getDepedentFields: function() {
        if(licGlobalObj.currentRecId != null) {
            var fieldsQuery = 'SELECT Id';
            $.each(questionsList, function(i, val) {
                if((val.parentFieldObject == currObjName) && (val.parentField != null)) {
                    fieldsQuery = fieldsQuery + ', ' + val.parentField;
                }
                $.each(val.childQueList, function(j, val2) {
                    if(
                        (val2.parentFieldObject == currObjName) && (val2.parentField != null)) {
                        fieldsQuery = fieldsQuery + ', ' + val2.parentField;
                    }
                });
            });
            fieldsQuery = fieldsQuery + " FROM " + currObjName + " WHERE Id = '" + licGlobalObj.currentRecId + "'";
            
            var resultDependentFields = sforce.connection.query(fieldsQuery);
            recordsDependentFields = resultDependentFields.getArray("records");
            
            $.each(questionsList, function(i, val) {
                if(val.parentFieldObject == currObjName) {
                    if(val.parentField != null) {
                        if(val.qualifyingResponseForField == eval('recordsDependentFields[0].' + val.parentField)) {
                            val.show = true;
                            
                        }
                        else {
                            val.show = false;
                            
                        }
                    }
                    else {
                        val.show = true;
                        
                    }
                }
                else if(val.parentFieldObject != null) {
                    val.show = false;
                    
                }
                    else {
                        val.show = true;
                        
                    }
                $.each(val.childQueList, function(j, val2) {
                    if(val2.parentFieldObject == currObjName) {
                        if(val2.parentField != null) {
                            if(val2.qualifyingResponseForField == eval('recordsDependentFields[0].' + val2.parentField)) {
                                val2.show = true;
                                
                            }
                            else {
                                val2.show = false;
                                
                            }
                        }
                        else {
                            val2.show = true;
                            
                        }
                    }
                    else if(val2.parentFieldObject != null) {
                        val2.show = false;
                        
                    }
                        else {
                            val2.show = true;
                            
                        }
                });
                //Loop through Child Group Questions added by shiva 
                if(val.Map_Of_AnswerGroup_childQuestionsGroup_JSON != null) {
                    //looping through the map keys - which are nothing but Answer Group Values
                    Object.keys(val.Map_Of_AnswerGroup_childQuestionsGroup).map(function(key, index) {
                        // looping through values for each Key - i.e, for each Answer Group Value
                        $.each(val.Map_Of_AnswerGroup_childQuestionsGroup[key], function(k, val3) {
                            if(val3.parentFieldObject == currObjName) {
                                if(val3.parentField != null) {
                                    //determining whether to show the question or not based on parent field value
                                    if(val3.qualifyingResponseForField == eval('recordsDependentFields[0].' + val3.parentField)) {
                                        val3.show = true;
                                    }
                                    else {
                                        val3.show = false;
                                    }
                                }
                                else {
                                    val3.show = true;
                                }
                            }
                            else if(val3.parentFieldObject != null) {
                                val3.show = false;
                            }
                                else {
                                    val3.show = true;
                                }
                        });
                    });
                }//added by shiva
            });
        }
    },
    /* Get data, build marup and inject */
    loadRecords: function() {
        // Initialize variables
        var innerHtml = '';
        var innerHtml2 = '';
        var innerHtml3 = '';
        var innerHtml4 = '';
        // Empty list
        $(".injectQuestions").empty();
        try {
            // Loop through parent questions
            // console.log(questionsList);
            
            $.each(questionsList, function(i, val) {
                
                if(val.show) {
                    // Remove null values
                    if(val.answerText == null) {
                        val.answerText = '';
                    }
                    if(val.answerComment == null) {
                        val.answerComment = '';
                    }
                    // If Yes-No type of question
                    if(val.dataType == 'Yes_No') {
                        // Build parent question markup
                        innerHtml += '<div class="form-group formGrp"><fieldset><legend>' + val.questionBody + '</legend><div class="row"><div class="radioWrapper"><input type="radio" class="questionRadio yes" id="radioY' + val.id + '" name="radio' + val.id + '"/><label for="radioY' + val.id + '">Yes</label></div><div class="radioWrapper"><input type="radio" class="questionRadio no" id="radioN' + val.id + '" name="radio' + val.id + '"/><label for="radioN' + val.id + '">No</label></div></div><div class="form-child-panel parentQueComment' + val.id + '" style="display:none"><label></label><textarea class="form-control form-textarea-fixed" rows="4" placeholder="Please enter comments here..." id="parentQueComment' + val.id + '">' + val.answerComment + '</textarea></div><div class="form-child-panel parentQue' + val.id + '" style="display:none;"></div></fieldset></div>';
                    }
                    // If picklist
                    else if(val.dataType == 'Picklist') {
                        // Build parent question markup
                        innerHtml += '<div class="form-group-inanimated label-normal formGrp"><label for="parentPkListAns' + val.id + '">' + val.questionBody + '</label><select class="selectPicker questionPkList" id="parentPkListAns' + val.id + '"><option value=""></option></select><div class="form-child-panel parentQueComment' + val.id + '" style="display:none"><label></label><textarea class="form-control form-textarea-fixed" rows="4" placeholder="Please enter comments here..." id="parentQueComment' + val.id + '">' + val.answerComment + '</textarea></div><div class="form-child-panel parentQue' + val.id + '" style="display:none"></div></div>';
                    }
                    // If text
                        else if(val.dataType == 'Text') {
                            // Build parent question markup
                            innerHtml += '<div class="form-group formGrp"><div class="row"><label for="parentTextAns' + val.id + '">' + val.questionBody + '</label></div><div class=""><input type="text" class="form-control questionText" id="parentTextAns' + val.id + '" value="' + val.answerText + '"/></div>';
                        }
                    // Inject parent markup
                    $(".injectQuestions").append(innerHtml);
                    // Add picklist values
                    var picklistHtml = '';
                    $.each(val.possibleResponses, function(k, val3) {
                        picklistHtml += '<option value="' + val3.trim() + '">' + val3.trim() + '</option>';
                    });
                    $("#parentPkListAns" + val.id).append(picklistHtml);
                    // Loop through child questions
                    $.each(val.childQueList, function(j, val2) {
                        if(val2.show) {
                            // Remove null values
                            if(val2.answerText == null) {
                                val2.answerText = '';
                            }
                            if(val2.answerComment == null) {
                                val2.answerComment = '';
                            }
                            // If Yes-No type of question
                            if(val2.dataType == 'Yes_No') {
                                // Build parent question markup
                                innerHtml2 += '<div class="childQue' + val2.id + '" style="display:none"><div class="form-group"><fieldset><legend>' + val2.questionBody + '</legend><div class="row"><div class="radioWrapper"><input type="radio" class="questionRadio" id="radioY' + val2.id + '" name="radio' + val2.id + '"/><label for="radioY' + val2.id + '">Yes</label></div><div class="radioWrapper"><input type="radio" class="questionRadio" id="radioN' + val2.id + '" name="radio' + val2.id + '"/><label for="radioN' + val2.id + '">No</label></div></div><div class="form-child-panel parentQueComment' + val2.id + '" style="display:none"><label></label><textarea class="form-control form-textarea-fixed" rows="4" placeholder="Please enter comments here..." id="parentQueComment' + val2.id + '">' + val2.answerComment + '</textarea></div></fieldset></div>';
                            }
                            else if(val2.dataType == 'Picklist') {
                                // Build parent question markup
                                innerHtml2 += '<div class="childQue' + val2.id + '" style="display:none"><div class="form-group-inanimated label-normal"><label for="parentPkListAns' + val2.id + '">' + val2.questionBody + '</label><select class="selectPicker questionPkList" id="parentPkListAns' + val2.id + '"><option value=""></option></select></div></div>';
                            }
                                else if(val2.dataType == 'Text') {
                                    // Build parent question markup
                                    innerHtml2 += '<div class="childQue' + val2.id + '" style="display:none"><div class="form-group"><div class=""><label for="textAns' + val2.id + '">' + val2.questionBody + '</label></div><div class=""><input type="text" class="form-control questionText" id="textAns' + val2.id + '" value="' + val2.answerText + '"/></div><div class="parentQue' + val2.id + '" style="display:none"></div></div>';
                                }
                            // Inject parent markup
                            $(".parentQue" + val.id).append(innerHtml2);
                            // Add picklist values
                            var picklistHtml2 = '';
                            $.each(val2.possibleResponses, function(k, val3) {
                                picklistHtml2 += '<option value="' + val3 + '">' + val3 + '</option>';
                            });
                            $("#parentPkListAns" + val2.id).append(picklistHtml2);
                            // Re-initialize markup variable
                            innerHtml2 = '';
                        }
                    });
                    
                    //Loop through Child Group Questions added by Shiva 
                    if(val.Map_Of_AnswerGroup_childQuestionsGroup_JSON != null) {
                        //adds class to the group questions parent Question block
                        $(".parentQue" + val.id).closest(".formGrp").addClass("parentGroup-" + val.QuestionGroup);
                        
                        // loops through AnswerGroup Keys
                        Object.keys(val.Map_Of_AnswerGroup_childQuestionsGroup).sort().map(function(key, index) {
                            
                            //Adding Group Question Block Dynamically
                            innerHtml4 += '<div class="form-child-panel ' + key + '" style="display:none"></div>';
                            
                            //Appending Group Question Block to the Parent Block
                            $(document.getElementsByClassName("parentGroup-" + val.QuestionGroup)[0]).append(innerHtml4);
                            //$(".parentQue" + val.id).css("display", "none");
                            
                            
                            
                            //Below logic loops through Groupquestion list for each answer group key and creates HTML 
                            $.each(val.Map_Of_AnswerGroup_childQuestionsGroup[key], function(k, val3) {
                                if(val3.show) {
                                    // Remove null values
                                    if(val3.answerText == null) {
                                        val3.answerText = '';
                                    }
                                    if(val3.answerComment == null) {
                                        val3.answerComment = '';
                                    }
                                    // If Yes-No type of question
                                    if(val3.dataType == 'Yes_No') {
                                        // Build parent question markup
                                        innerHtml3 += '<div class="childQue' + val3.id + '" style="display:none"><div class="form-group formGrp"><fieldset><legend>' + val3.questionBody + '</legend><div class="row"><div class="radioWrapper"><input type="radio" class="yes questionRadio radioY' + val3.id + key + '" id="radioY' + val3.id + key + '" name="radio' + val3.id + key + '"/><label for="radioY' + val3.id + key + '">Yes</label></div><div class="radioWrapper"><input type="radio" class="no questionRadio radioN' + val3.id + key + '" id="radioN' + val3.id + key + '" name="radio' + val3.id + key + '"/><label for="radioN' + val3.id + key + '">No</label></div></div></fieldset><div class="form-child-panel parentQueComment' + val3.id + key + '" style="display:none"><label for="parentQueComment' + val3.id + key + '" ></label><textarea class="form-control form-textarea-fixed parentQueComment' + val3.id + key + '" rows="4" placeholder="Please enter comments here..." id="parentQueComment' + val3.id + key + '" name="parentQueComment' + val3.id + key + '">' + val3.answerComment + '</textarea></div></div>';
                                    }
                                    else if(val3.dataType == 'Picklist') {
                                        // Build parent question markup
                                        innerHtml3 += '<div class="childQue' + val3.id + '" style="display:none"><div class="form-group-inanimated label-normal formGrp"><label for="parentPkListAns' + val3.id + key + '">' + val3.questionBody + '</label><select class="selectPicker questionPkList parentPkListAns' + val3.id + key + '" id="parentPkListAns' + val3.id + key + '" name="parentPkListAns' + val3.id + key + '"><option value=""></option></select></div></div>';
                                    }
                                        else if(val3.dataType == 'Text') {
                                            // Build parent question markup
                                            innerHtml3 += '<div class="childQue' + val3.id + '" style="display:none"><div class="form-group formGrp"><div class=""><label for="textAns' + val3.id + key + '">' + val3.questionBody + '</label></div><div class=""><input type="text" class="form-control questionText textAns' + val3.id + key + '" id="textAns' + val3.id + key + '" name="textAns' + val3.id + key + '" value="' + val3.answerText + '"/></div><div class="parentQue' + val3.id + '" style="display:none"></div></div>';
                                        }
                                    // Inject parent markup
                                    $(document.getElementsByClassName(key)[0]).append(innerHtml3);
                                    // Add picklist values
                                    var picklistHtml2 = '';
                                    $.each(val3.possibleResponses, function(k, val4) {
                                        picklistHtml2 += '<option value="' + val4 + '">' + val4 + '</option>';
                                    });
                                    $(document.getElementById("parentPkListAns" + val3.id + key)).append(picklistHtml2);
                                    // Re-initialize markup variable
                                    innerHtml3 = '';
                                }
                            });
                            
                            // conditions to show or hide trash icon. When more than one group is on DOM, only then the trash icon will be visible
                            if(Object.keys(val.Map_Of_AnswerGroup_childQuestionsGroup).length <= 1) {
                                $(document.getElementsByClassName(key)[0]).append(' <span title="Delete" tabindex="0" class="glyphicon glyphicon-trash" style="cursor:pointer;display:none;" id="DeleteResponse-' + i + '-' + key + '"></span>');
                            }
                            else{
                                $(document.getElementsByClassName(key)[0]).append(' <span title="Delete" tabindex="0" class="glyphicon glyphicon-trash" style="cursor:pointer;" id="DeleteResponse-' + i + '-' + key + '"></span>');
                            }
                            
                            // Logic to create Add Response button 
                            $(document.getElementsByClassName(key)[0]).append(' <input title="Add Another" type="button" class="btn btn-primary AddResponse" id="AddResponse-' + i + '-' + key + '" value="Add Another"></input>');
                            
                            innerHtml4 = '';
                        });
                        //$(".parentQue" + val.id).append(innerHtml3);
                    }
                }
                // Re-initialize markup variable
                innerHtml = '';
            });
            // Update UI with previous answers
            $.each(questionsList, function(i, val) {
                // If answers are saved
                if(val.answerText != null) {
                    // Set answers
                    if(val.dataType == 'Yes_No') {
                        if(val.answerText == 'Yes') {
                            $("#radioY" + val.id).prop("checked", true);
                            $("#radioN" + val.id).prop("checked", false);
                        }
                        else if(val.answerText == 'No') {
                            $("#radioY" + val.id).prop("checked", false);
                            $("#radioN" + val.id).prop("checked", true);
                        }
                    }
                    else if(val.dataType == 'Picklist') {
                        
                        $("#parentPkListAns" + val.id).val(val.answerText.trim());
                    }
                    if(val.answerText == val.qualifyingResponseForComment) {
                        $(".parentQueComment" + val.id).show();
                    }
                }
                $.each(val.childQueList, function(j, val2) {
                    if(val.answerText == val2.qualifyingParentResponse) {
                        $(".childQue" + val2.id).show();
                        $(".parentQue" + val.id).show();
                    }
                    if(val2.answerText != null) {
                        // Set answers
                        if(val2.dataType == 'Yes_No') {
                            if(val2.answerText == 'Yes') {
                                $("#radioY" + val2.id).prop("checked", true);
                                $("#radioN" + val2.id).prop("checked", false);
                            }
                            else if(val2.answerText == 'No') {
                                $("#radioY" + val2.id).prop("checked", false);
                                $("#radioN" + val2.id).prop("checked", true);
                            }
                        }
                        else if(val2.dataType == 'Picklist') {
                            $("#parentPkListAns" + val2.id).val(val2.answerText);
                        }
                        if(val2.answerText == val2.qualifyingResponseForComment) {
                            $(".parentQueComment" + val2.id).show();
                        }
                    }
                });
                //Loop through Child Group Questions added by Shiva
                //Below logic updates the UI with previous answers for the Groups questions
                if(val.Map_Of_AnswerGroup_childQuestionsGroup_JSON != null) {
                    //$(".parentQue" + val.id).hide();
                    Object.keys(val.Map_Of_AnswerGroup_childQuestionsGroup).map(function(key, index) {
                        $.each(val.Map_Of_AnswerGroup_childQuestionsGroup[key], function(k, val3) {
                            
                            if(val.answerText == val3.qualifyingParentResponse) {
                                $(".childQue" + val3.id).show();
                                $(".childQue" + val3.id).closest('.form-child-panel').show();
                            }
                            if(val3.answerText != null) {
                                
                                // Set answers
                                if(val3.dataType == 'Yes_No') {
                                    if(val3.answerText == 'Yes') {
                                        
                                        $(document.getElementById("radioY" + val3.id + key)).prop("checked", true);
                                        $(document.getElementById("radioN" + val3.id + key)).prop("checked", false);
                                    }
                                    else if(val3.answerText == 'No') {
                                        $(document.getElementById("radioY" + val3.id + key)).prop("checked", false);
                                        $(document.getElementById("radioN" + val3.id + key)).prop("checked", true);
                                    }
                                }
                                else if(val3.dataType == 'Picklist') {
                                    $(document.getElementById("parentPkListAns" + val3.id + key)).val(val3.answerText);
                                }
                                /*if(val3.answerText == val3.qualifyingResponseForComment) {
                                    $(".parentQueComment" + val3.id + key).show();
                                }*/
                            }
                        });
                    });
                }
            });
            QUESTIONSCOMPNS.loadDynEvents();
        }
        catch(e) {
            console.log(e);
        }
    },
    /* Load all dynamic events */
    loadDynEvents: function() {
        // Event to capture parent question's answer
        $(".injectQuestions").off("click", ".questionRadio").on("click", ".questionRadio", function() {
            var currentObjId = '';
            var currentAns = '';
            currentObjId = $(this).attr("id");
            // If yes
            if(currentObjId.indexOf('radioY') >= 0) {
                
                currentAns = 'Yes';
            }
            // If no
            else if(currentObjId.indexOf('radioN') >= 0) {
                
                currentAns = 'No';
            }
            // Process
            currentObjId = currentObjId.substring(6, currentObjId.length);
            
            $.each(questionsList, function(i, val) {
                if(val.id == currentObjId) {
                    if(val.qualifyingResponseForComment == currentAns) {
                        $(".parentQueComment" + val.id).show();
                    }
                    else {
                        $(".parentQueComment" + val.id).hide();
                    }
                    QUESTIONSCOMPNS.showHideChildQuestions(val, currentAns, currentObjId);
                }
                $.each(val.childQueList, function(j, val2) {
                    if(val2.id == currentObjId) {
                        if(val2.qualifyingResponseForComment == currentAns) {
                            $(".parentQueComment" + val2.id).show();
                        }
                        else {
                            $(".parentQueComment" + val2.id).hide();
                        }
                    }
                });
            });
        });
        $(".questionPkList").on("change", function() {
            var currentAns = $(this).val();
            var currentObjId = '';
            if(this.parentElement.classList[3]){
                var quegroupdeletion = $('[id^=DeleteResponse-1-'+this.parentElement.classList[3].substring(12,this.parentElement.classList[3].length)+'-]');
                if(quegroupdeletion!=null&& quegroupdeletion!=undefined)
                {
                    for (var i = 0; i < quegroupdeletion.length; i++) {
                        if(i>0){ quegroupdeletion[i].click()}
                    }
                }
            }
            currentObjId = $(this).attr("id");
            currentObjId = currentObjId.substring(15, currentObjId.length);
            $.each(questionsList, function(i, val) {
                if(val.id == currentObjId) {
                    if(val.qualifyingResponseForComment == currentAns) {
                        $(".parentQueComment" + val.id).show();
                    }
                    else {
                        $(".parentQueComment" + val.id).hide();
                    }
                    QUESTIONSCOMPNS.showHideChildQuestions(val, currentAns, currentObjId);
                }
                $.each(val.childQueList, function(j, val2) {
                    if(val2.id == currentObjId) {
                        if(val2.qualifyingResponseForComment == currentAns) {
                            $(".parentQueComment" + val2.id).show();
                        }
                        else {
                            $(".parentQueComment" + val2.id).hide();
                        }
                    }
                });
            });
        });
        
        //added by Shiva to Dynamically add Groups when Add response button is clicked. 
        // The reason we are using 'off' and 'on' is because, we ran into problems of click event firing twice for dynamically created 'Add response' button
        $(".injectQuestions").off("click", ".AddResponse").on("click", ".AddResponse", function(e) {
            e.preventDefault();
            var parentQueObj = '';
            
            // getting the parent question number 
            parentQueObj = parseInt($(this).attr("id").split("-")[1]);
            
            // Show the trash button for previous group
            $(this).prev('.glyphicon-trash').show();
            var parentanswer= $(this).parent().parent().children().toArray()[1].value;
            var innerhtml = '';
            var innerhtml2 = '';
            var ParentDiv = $(this).closest(".formGrp");
            var Iterator = 0;
            
            //looping through the parent question and corresponding default group questions list to create HTML for the new group to be added
            Object.keys(questionsList[parentQueObj].Map_Of_AnswerGroup_childQuestionsGroup).map(function(key, index) {
                var totalLen = Object.keys(questionsList[parentQueObj].Map_Of_AnswerGroup_childQuestionsGroup).length;
                
                
                if(index == totalLen - 1) {
                    
                    // Generating new key that needs to be added to the map
                    var newIndex = totalLen + 1;
                    var currIndex = parseInt(key.split("-")[1]);
                    if(newIndex == currIndex){
                        newIndex = newIndex + 1;
                    }
                    
                    var newKey = questionsList[parentQueObj].QuestionGroup + '-' + newIndex;
                    if(!questionsList[parentQueObj].Map_Of_AnswerGroup_childQuestionsGroup[newKey]) {
                        //innerhtml += '<div class="form-child-panel parentQue' + questionsList[parentQueObj].id + ' ' + newKey + '"' + '></div>';
                        
                        //creating Tarsh icon and Add Response buttons
                        innerhtml += '<div class="form-child-panel ' + newKey + '"></div>';
                        $(ParentDiv).append(innerhtml);
                        
                        
                        //Below line adds new key to the map
                        questionsList[parentQueObj].Map_Of_AnswerGroup_childQuestionsGroup[newKey] = [];
                        
                        //loops through child groups questions 
                        $.each(questionsList[parentQueObj].Map_Of_AnswerGroup_childQuestionsGroup[key], function(k, val3) {
                            //Below line adds each of the child questions to an array that inturns corresponds to newly generated key in the map
                            //
                            if(parentanswer==val3.qualifyingParentResponse){
                                questionsList[parentQueObj].Map_Of_AnswerGroup_childQuestionsGroup[newKey].push(val3);
                                val3.answerText = '';
                                val3.answerComment = '';
                                val3.answerId = '';
                                val3.AnswerGroup = '';
                                // If Yes-No type of question
                                if(val3.dataType == 'Yes_No') {
                                    // Build parent question markup
                                    innerhtml2 += '<div class="childQue' + val3.id + '" ><div class="form-group formGrp"><fieldset><legend>' + val3.questionBody + '</legend></div><div class="row"><div class="radioWrapper"><input type="radio" class="yes questionRadio radioY' + val3.id + newKey + '" id="radioY' + val3.id + newKey + '" name="radio' + val3.id + newKey + '"/><label for="radioY' + val3.id + newKey + '">Yes</label></div><div class="radioWrapper"><input type="radio" class="no questionRadio radioN' + val3.id + newKey + '" id="radioN' + val3.id + newKey + '" name="radio' + val3.id + newKey + '"/><label for="radioN' + val3.id + newKey + '">No</label></div></div><div class="form-child-panel parentQueComment' + val3.id + newKey + '" style="display:none"><label></label><textarea class="form-control form-textarea-fixed parentQueComment' + val3.id + newKey + '" rows="4" placeholder="Please enter comments here..." id="parentQueComment' + val3.id + newKey + '" name="parentQueComment' + val3.id + newKey + '">' + val3.answerComment + '</textarea></div></fieldset></div>';
                                }
                                else if(val3.dataType == 'Picklist') {
                                    // Build parent question markup
                                    innerhtml2 += '<div class="childQue' + val3.id + '" ><div class="form-group-inanimated label-normal formGrp"><label for="parentPkListAns' + val3.id + newKey + '">' + val3.questionBody + '</label><select class="selectPicker questionPkList parentPkListAns' + val3.id + newKey + '" id="parentPkListAns' + val3.id + newKey + '" name="parentPkListAns' + val3.id + newKey + '"><option value=""></option></select></div></div>';
                                }
                                    else if(val3.dataType == 'Text') {
                                        // Build parent question markup
                                        innerhtml2 += '<div class="childQue' + val3.id + '" ><div class="form-group formGrp"><div class=""><label for="textAns' + val3.id + newKey + '">' + val3.questionBody + '</label></div><div class=""><input type="text" class="form-control questionText textAns' + val3.id + newKey + '" id="textAns' + val3.id + newKey + '" name="textAns' + val3.id + newKey + '" value="' + val3.answerText + '"/></div><div class="parentQue' + val3.id + '" style="display:none"></div></div>';
                                    }
                                // Inject parent markup
                                $(ParentDiv).find(".form-child-panel:last-child").append(innerhtml2);
                                // Add picklist values
                                var picklistHtml2 = '';
                                //    console.log("possibleResponses :  " + val3.possibleResponses);
                                $.each(val3.possibleResponses, function(k, val4) {
                                    picklistHtml2 += '<option value="' + val4 + '">' + val4 + '</option>';
                                });
                                
                                var escapedKey = "parentPkListAns" + val3.id + newKey;
                                escapedKey = escapedKey.replace(/(:|\.|\[|\]|,|=|@)/g, "\\$1");
                                var SelectBox = $('.injectQuestions').find("." + escapedKey);
                                for(i = 0; i < SelectBox.length; i++) {
                                    if($(SelectBox[i]) !== undefined) {
                                        $(SelectBox[i]).append(picklistHtml2);
                                    }
                                }
                                //$(document.getElementById("parentPkListAns" + val3.id + newKey)).append(picklistHtml2);
                                // Re-initialize markup variable
                                innerhtml2 = '';
                            }
                        });
                        
                        $(ParentDiv).find(".form-child-panel:last-child").append(' <span title="Delete" tabindex="0" class="glyphicon glyphicon-trash" style="cursor:pointer;" id="DeleteResponse-' + parentQueObj + '-' + newKey + '"></span>');
                        $(ParentDiv).find(".form-child-panel:last-child").append(' <input title="Add Another" type="button" class="btn btn-primary AddResponse" id="AddResponse-' + parentQueObj + '-' + newKey + '" value="Add Another"></input>');
                    }
                    innerhtml = '';
                }
            });
        });
        
        //Added by Shiva to Dynamically remove or Delete Groups
        //When it removes groups, it also deletes answers corresponding to deleted group if any
        $(".injectQuestions").off("click", ".glyphicon-trash").on("click", ".glyphicon-trash", function(e) {
            //get the parent question to which the group to be deleted belongs to
            var parentObject = parseInt($(this).attr("id").split("-")[1]);
            var totalLen = Object.keys(questionsList[parentObject].Map_Of_AnswerGroup_childQuestionsGroup).length;
            
            if(totalLen > 1){
                //gets the specific group that needs to be deleted
                var ToBeDeletedGroup = $(this).attr("id").split("-")[2] + '-' + (parseInt($(this).attr("id").split("-")[3]).toString());
                //array to store the answers that needs to be deleted when group is deleted
                var recordsAnsIds = [];
                $.each(questionsList[parentObject].Map_Of_AnswerGroup_childQuestionsGroup[ToBeDeletedGroup], function(k, val3) {
                    //populting the existing answers of the group which need to be deleted
                    if(val3.answerId != '') {
                        recordsAnsIds.push(val3.answerId);
                    }
                });
                
                //below line deletes the element from the map
                delete questionsList[parentObject].Map_Of_AnswerGroup_childQuestionsGroup[ToBeDeletedGroup];
                
                //below line removes the mark up from the dom
                var escapedGrpName = ToBeDeletedGroup.replace(/(:|\.|\[|\]|,|=|@)/g, "\\$1");
                $(".injectQuestions").find("."+escapedGrpName).remove();
                
                //below logic deletes the answers of the group which needs to be deletes
                if(recordsAnsIds.length > 0) {
                    
                    var result = sforce.connection.deleteIds(recordsAnsIds);
                    
                    // If insert succeedsOH_Account_TriggerHandler
                    if(result[0].success == 'true') {
                        reloadAttachments();
                        reloadQuestions();
                    }
                }
            }else{
                MODAL_UTILITY.errorMessageModal('At least one set of responses must be provided.');
            }
            
        });
    },
    /* Load all events */
    loadEvents: function() {
        // Event to capture parent question's answer
        $("#saveQuestionsSection").on("click", function() {
            // Call save method
            QUESTIONSCOMPNS.saveRecords();
        });
    },
    /* Show or hide child questions */
    showHideChildQuestions: function(parentQueObj, currentAns, currentObjId) {
        var hasChildQuestions = false;
        var GroupQuestions = false;
        if(parentQueObj.Map_Of_AnswerGroup_childQuestionsGroup_JSON != null) {
            GroupQuestions = true;
        }
        $.each(parentQueObj.childQueList, function(j, val2) {
            if(val2.qualifyingParentResponse == currentAns) {
                
                hasChildQuestions = true;
                
            }
            if(parentQueObj.id == currentObjId) {
                if(val2.qualifyingParentResponse == currentAns) {
                    $(".childQue" + val2.id).show();
                    
                }
                else {
                    $(".childQue" + val2.id).hide();
                    $("#radioY" + val2.id).prop("checked", false);
                    $("#radioN" + val2.id).prop("checked", false);
                    $("#parentPkListAns" + val2.id).val('');
                    $("#textAns" + val2.id).val('');
                    
                }
            }
            else if(val2.id == currentObjId) {
                if(val2.qualifyingResponseForComment == currentAns) {
                    $(".parentQueComment" + val2.id).show();
                }
                else {
                    $(".parentQueComment" + val2.id).hide();
                }
            }
        });
        
        if(hasChildQuestions && parentQueObj.Map_Of_AnswerGroup_childQuestionsGroup_JSON == null) {
            $(".parentQue" + parentQueObj.id).show();
        }
        
        else {
            
            $(".parentQue" + parentQueObj.id).hide();
            $.each(parentQueObj.childQueList, function(j, val2) {
                try {
                    $("#radioY" + val2.id).prop("checked", false);
                    $("#radioN" + val2.id).prop("checked", false);
                    $("#parentPkListAns" + val2.id).val('');
                    $("#textAns" + val2.id).val('');
                    $("#parentQueComment" + val2.id).val('');
                    $(".parentQueComment" + val2.id).hide();
                }
                catch(e) {
                    console.log(e);
                }
            });
        }
        //Loop through Child Group Questions added by Shiva to handle Group Visibility based onn response to parents
        if(parentQueObj.Map_Of_AnswerGroup_childQuestionsGroup_JSON != null) {
            // console.log('Entering the-----'+parentQueObj.Map_Of_AnswerGroup_childQuestionsGroup);
            Object.keys(parentQueObj.Map_Of_AnswerGroup_childQuestionsGroup).map(function(key, index) {
                $.each(parentQueObj.Map_Of_AnswerGroup_childQuestionsGroup[key], function(k, val3) {
                    if(val3.qualifyingParentResponse == currentAns) {
                        hasChildQuestions = true;
                    }
                    if(parentQueObj.id == currentObjId) {
                        if(val3.qualifyingParentResponse == currentAns) {
                            //         console.log('answers match ' + key);
                            //          console.log('html element------'+ $(".childQue" + val3.id).html());
                            $(".childQue" + val3.id).show();
                        }
                        else {
                            $(".childQue" + val3.id).hide();
                            $(document.getElementById("radioY" + val3.id + key)).prop("checked", false);
                            $(document.getElementById("radioN" + val3.id + key)).prop("checked", false);
                            $(document.getElementById("parentPkListAns" + val3.id + key)).val('');
                            $(document.getElementById("textAns" + val3.id + key)).val('');
                        }
                    }
                    else if(val3.id == currentObjId) {
                        if(val3.qualifyingResponseForComment == currentAns) {
                            $(".parentQueComment" + val3.id).hide();
                        }
                        else {
                            $(".parentQueComment" + val3.id).hide();
                        }
                    }
                });
                if(hasChildQuestions) {
                    var escapedKey = key.replace(/(:|\.|\[|\]|,|=|@)/g, "\\$1");
                    $("." + escapedKey).show();
                }
                else {
                    var escapedKey = key.replace(/(:|\.|\[|\]|,|=|@)/g, "\\$1");
                    $("." + escapedKey).hide();
                    $.each(parentQueObj.Map_Of_AnswerGroup_childQuestionsGroup[key], function(k, val3) {
                        try {
                            $(document.getElementById("radioY" + val3.id + key)).prop("checked", false);
                            $(document.getElementById("radioN" + val3.id + key)).prop("checked", false);
                            $(document.getElementById("parentPkListAns" + val3.id + key)).val('');
                            $(document.getElementById("textAns" + val3.id + key)).val('');
                            $(document.getElementById("parentQueComment" + val3.id + key)).val('');
                            $(".parentQueComment" + val3.id).hide();
                        }
                        catch(e) {
                            console.log(e);
                        }
                    });
                }
            });
        }
    },
    deleteRecords: function() {
        var questionIdList = '';
        var recordsAnswers = [];
        var recordsAnsIds = [];
        if(questionsList.length > 0) {
            var isFirstObj = true;
            $.each(questionsList, function(i, val) {
                if(isFirstObj) {
                    
                    questionIdList += "External_id_of_Question__c = '" + val.externalId + "'";
                    isFirstObj = false;
                }
                else {
                    questionIdList += " OR External_id_of_Question__c = '" + val.externalId + "'";
                }
                $.each(val.childQueList, function(j, val2) {
                    
                    questionIdList += " OR External_id_of_Question__c = '" + val2.externalId + "'";
                });
                //Loop through Child Group Questions 
                if(val.Map_Of_AnswerGroup_childQuestionsGroup_JSON != null) {
                    Object.keys(val.Map_Of_AnswerGroup_childQuestionsGroup).map(function(key, index) {
                        $.each(val.Map_Of_AnswerGroup_childQuestionsGroup[key], function(k, val3) {
                            questionIdList += " OR External_id_of_Question__c = '" + val3.externalId + "'";
                        });
                    });
                }
            });
            // Build query string
            var queryAnswers = '';
            queryAnswers = "SELECT Id, Name, Answer_Text__c, Question__c From Answer__c WHERE " + lookupFieldName + " = '" + licGlobalObj.currentRecId + "' AND (" + questionIdList + ")";
            
            // Execute query and get records
            var resultAnswers = sforce.connection.query(queryAnswers);
            recordsAnswers = resultAnswers.getArray("records");
            
            $.each(recordsAnswers, function(i, val) {
                recordsAnsIds.push(val.Id);
            });
            
            $.each(questionsList, function(i, val) {
                val.answerText = '';
                $("#radioY" + val.id).attr(':checked', false);
                $("#radioN" + val.id).attr(':checked', false);
                
                $.each(val.childQueList, function(j, val2) {
                    val2.answerText = '';
                    $("#radioY" + val2.id).attr(':checked', false);
                    $("#radioN" + val2.id).attr(':checked', false);
                    
                });
            });
        }
        // Delete - REST call
        
        var result = sforce.connection.deleteIds(recordsAnsIds);
        
    },
    /****** Delete Expired Question Answers **************/
    /***
    	For example: I have started a license application. Question-x is active when I started the application and I answered Question-x.
    	Tomorrow when I come back to resume my application, the question-x is no longer active which means it is expired. This answer needs to be 
    	deleted since my application is not submitted yet. This deletes happens on save of answers. 
    ***/
    deleteExpiredAnswers: function(){
        try{
            var recordsAnsIds = [];
            if(answerList_ToBeDeleted.length > 0 && answerList_ToBeDeleted.trim()!='') {
                //  console.log('at 674'+answerList_ToBeDeleted);
                $.each(answerList_ToBeDeleted,function(i,val){
                    recordsAnsIds.push(val.Id);
                });
            }
            
            if(recordsAnsIds.length>0)
            {
                var result = sforce.connection.deleteIds(recordsAnsIds);
                //  console.log('---> Delete Complete. Result at 459: ' + result);
            }
        }catch(e){console.log(e);}
        
        
    },
    /* Save answers to Answer object */
    saveRecords: function() {
        //	console.log('at 691--->'+answerList_ToBeDeleted);
        // $("#saveQuestionsSection").attr("disabled", "");
        // Start spinner
        
        // Initialize list
        var answersList = [];
        // Delete previous answers
        // QUESTIONSCOMPNS.deleteRecords();
        
        // Loop through parent questions
        
        QUESTIONSCOMPNS.deleteExpiredAnswers();
        $.each(questionsList, function(i, val) {
            if(val.show) {
                // Initialize object of Answer object
                var ansObj = new sforce.SObject("Answer__c");
                eval("ansObj." + lookupFieldName + " = licGlobalObj.currentRecId");
                
               // ansObj.Question__c = val.id;
                ansObj.Question_Body__c=val.questionBody;
                ansObj.External_id_of_Question__c=val.externalId;
                if(val.QuestionGroup!=null) { 
                    ansObj.NewQuestiongroup__c=val.QuestionGroup;
                }
                ansObj.Answer_Text__c = '';
                ansObj.Comment__c = '';
                //setting submitted by portal user as true
                ansObj.Submitted_By_Portal_User__c = true;
                // If Yes-No type of question
                if(val.dataType == 'Yes_No') {
                    // Answer - Yes
                    
                    if($("#radioY" + val.id).is(':checked')) {
                        ansObj.Answer_Text__c = 'Yes';
                        val.answerText = 'Yes';
                    }
                    // Answer - No
                    else if($("#radioN" + val.id).is(':checked')) {
                        ansObj.Answer_Text__c = 'No';
                        val.answerText = 'No';
                    }
                    // Add comment
                    val.answerComment = $("#parentQueComment" + val.id).val();
                    ansObj.Comment__c = $("#parentQueComment" + val.id).val();
                }
                // If picklist type of question
                else if(
                    (val.dataType == 'Picklist') && ($("#parentPkListAns" + val.id).val() != null)) {
                    ansObj.Answer_Text__c = $("#parentPkListAns" + val.id).val();
                    val.answerText = $("#parentPkListAns" + val.id).val();
                }
                // If text type of question
                    else if(
                        (val.dataType == 'Text') && ($("#parentTextAns" + val.id).val() != null)) {
                        ansObj.Answer_Text__c = $("#parentTextAns" + val.id).val();
                        val.answerText = $("#parentTextAns" + val.id).val();
                    }
                // Push object into array list
                //if((ansObj.Answer_Text__c != '') && (ansObj.Answer_Text__c != null)) {
                answersList.push(ansObj);
                //}
                // Loop through child questions
                var somevariable =val;
                $.each(val.childQueList, function(j, val2) {
                    
                    if(val2.show&&somevariable.answerText==val2.qualifyingParentResponse) {
                        
                        // Initialize object of Answer object
                        var ansObj = new sforce.SObject("Answer__c");
                        eval("ansObj." + lookupFieldName + " = licGlobalObj.currentRecId");
                       // ansObj.Question__c = val2.id;
                        ansObj.Question_Body__c=val2.questionBody;
                        ansObj.External_id_of_Question__c=val2.externalId;
                        ansObj.Parent_Question_External_Id__c= somevariable.externalId;
                        ansObj.NewQuestiongroup__c=val2.QuestionGroup;
                        ansObj.Answer_Text__c = '';
                        ansObj.Comment__c = '';
                        //setting submitted by portal user as true
                        ansObj.Submitted_By_Portal_User__c = true;
                        // If Yes-No type of question
                        if(val2.dataType == 'Yes_No') {
                            // Answer - Yes
                            if($("#radioY" + val2.id).is(':checked')) {
                                ansObj.Answer_Text__c = 'Yes';
                                val2.answerText = 'Yes';
                            }
                            // Answer - No
                            else if($("#radioN" + val2.id).is(':checked')) {
                                ansObj.Answer_Text__c = 'No';
                                val2.answerText = 'No';
                            }
                            // Add comment
                            val2.answerComment = $("#parentQueComment" + val2.id).val();
                            ansObj.Comment__c = $("#parentQueComment" + val2.id).val();
                        }
                        // If picklist
                        else if(val2.dataType == 'Picklist') {
                            ansObj.Answer_Text__c = $("#parentPkListAns" + val2.id).val();
                            val2.answerText = $("#parentPkListAns" + val2.id).val();
                        }
                        // If text
                            else if(
                                (val2.dataType == 'Text') && ($("#textAns" + val2.id).val() != '')) {
                                ansObj.Answer_Text__c = $("#textAns" + val2.id).val();
                                val2.answerText = $("#textAns" + val2.id).val();
                            }
                        // Push object into array list
                        if(
                            (ansObj.Answer_Text__c != '') && (ansObj.Answer_Text__c != null)) {
                            answersList.push(ansObj);
                        }
                    }
                });
                //    console.log(val.Map_Of_AnswerGroup_childQuestionsGroup_JSON);
                //Loop through Child Group Questions to save Group Question Answers
                if(val.Map_Of_AnswerGroup_childQuestionsGroup_JSON != null) {
                    var somevariable =val;
                    Object.keys(val.Map_Of_AnswerGroup_childQuestionsGroup).map(function(key, index) {
                        $.each(val.Map_Of_AnswerGroup_childQuestionsGroup[key], function(k, val3) {
                            
                            if(val3.show&&somevariable.answerText==val3.qualifyingParentResponse) {
                                
                                // Initialize object of Answer object
                                var ansObj = new sforce.SObject("Answer__c");
                                eval("ansObj." + lookupFieldName + " = licGlobalObj.currentRecId");
                                //ansObj.Question__c = val3.id;
                                ansObj.Question_Body__c=val3.questionBody;
                                ansObj.External_id_of_Question__c=val3.externalId;
                                ansObj.NewQuestiongroup__c=val3.QuestionGroup;
                                ansObj.Answer_Text__c = '';
                                ansObj.Comment__c = '';
                                ansObj.Answer_Group__c = key;
                                //setting submitted by portal user as true
                                ansObj.Submitted_By_Portal_User__c = true;
                                
                                // If Yes-No type of question
                                if(val3.dataType == 'Yes_No') {
                                    // Answer - Yes
                                    var Elementname = document.getElementsByName("radio" + val3.id + key);
                                    for(i = 0; i < Elementname.length; i++) {
                                        if(Elementname[i].checked) {
                                            if($(Elementname[i]).hasClass('yes')) {
                                                //       console.log('Selected Answer is Yes');
                                                ansObj.Answer_Text__c = 'Yes';
                                                val3.answerText = 'Yes';
                                            }
                                            else if($(Elementname[i]).hasClass('no')) {
                                                //     console.log('Selected Answer is No');
                                                ansObj.Answer_Text__c = 'No';
                                                val3.answerText = 'No';
                                            }
                                        }
                                    }
                                    // Add comment
                                    val3.answerComment = $(document.getElementById("parentQueComment" + val3.id + key)).val();
                                    ansObj.Comment__c = $(document.getElementById("parentQueComment" + val3.id + key)).val();
                                }
                                // If picklist
                                else if(val3.dataType == 'Picklist') {
                                    var escapedKey = 'parentPkListAns' + val3.id + key;
                                    escapedKey = escapedKey.replace(/(:|\.|\[|\]|,|=|@)/g, "\\$1");
                                    var SelectBox = $('.injectQuestions').find('.' + escapedKey);
                                    for(i = 0; i < SelectBox.length; i++) {
                                        if($(SelectBox[i]).val() != '') {
                                            //console.log('at 814 '+$(SelectBox[i]).val());
                                            ansObj.Answer_Text__c = $(SelectBox[i]).val();
                                            val3.answerText = $(SelectBox[i]).val();
                                        }
                                    }
                                }
                                // If text		                       
                                    else if((val3.dataType == 'Text')) {
                                        var escapedKey = 'textAns' + val3.id + key;
                                        escapedKey = escapedKey.replace(/(:|\.|\[|\]|,|=|@)/g, "\\$1");
                                        var TextInputs = $('.injectQuestions').find('.' + escapedKey);
                                        for(i = 0; i < TextInputs.length; i++) {
                                            //console.log("val3-" + $(TextInputs[i]).val());
                                            if($(TextInputs[i]).val() != '') {
                                                //console.log('at 826 '+$(TextInputs[i]).val());
                                                ansObj.Answer_Text__c = $(TextInputs[i]).val();
                                                val3.answerText = $(TextInputs[i]).val();
                                            }
                                        }
                                        
                                    }
                                // Push object into array list
                                //if((ansObj.Answer_Text__c != '') && (ansObj.Answer_Text__c != null)) {
                                
                                //('ansObj at 837 '+ansObj);
                                answersList.push(ansObj);
                                
                                //}
                            }
                        });
                    });
                }
            }
        });
        
        var questionIdList = '';
        var isFirstObj = true;
        // let set = new Set();
        var uniquequestions = new Map();
        $.each(questionsList, function(i, val) {
            if(isFirstObj) {
                
                questionIdList += "External_id_of_Question__c = '" + val.externalId + "'";
                uniquequestions.set(val.externalId);
                isFirstObj = false;
            }
            else {
                questionIdList += " OR External_id_of_Question__c = '" + val.externalId + "'";
                uniquequestions.set(val.externalId);
            }
            $.each(val.childQueList, function(j, val2) {
                
                questionIdList += " OR External_id_of_Question__c = '" + val2.externalId + "'";
                uniquequestions.set(val2.externalId);
            });
            //Loop through Child Group Questions 
            if(val.Map_Of_AnswerGroup_childQuestionsGroup_JSON != null) {
                Object.keys(val.Map_Of_AnswerGroup_childQuestionsGroup).map(function(key, index) {
                    $.each(val.Map_Of_AnswerGroup_childQuestionsGroup[key], function(k, val3) {
                        questionIdList += " OR External_id_of_Question__c = '" + val3.externalId + "'";
                        uniquequestions.set(val3.externalId);
                    });
                });
            }
        });
        
        // Insert list
        var questionsissue='';
        for (var key in uniquequestions.map)
        {
            questionsissue+="'"+key+"',";
        }
        
        if(questionsissue.length>0)
        {
            questionsissue= questionsissue.substring(0,questionsissue.lastIndexOf(","));
        }
        var queryAnswers = '';
        
        //QuestionGroup__c
        queryAnswers = "SELECT Id,Comment__c, Name, Answer_Text__c,External_id_of_Question__c,Question_Group__c,Answer_group__c,Parent_Question_External_Id__c, Question__c From Answer__c WHERE " + lookupFieldName + " = '" + licGlobalObj.currentRecId + "' AND External_id_of_Question__c IN (" + questionsissue + ")";
        
        // Execute query and get records
        var resultAnswers = sforce.connection.query(queryAnswers);
        recordsAnswers = resultAnswers.getArray("records");
        
        var prevlistanswered = new Map();
        $.each(recordsAnswers, function(i, val) {
            if(val.Answer_Group__c!=''&&val.Answer_Group__c!=null&&val.Answer_Group__c!=undefined){
                var two = val.External_id_of_Question__c+val.Answer_Group__c;
                prevlistanswered.set(two,val);
            }else{
                prevlistanswered.set(val.External_id_of_Question__c,val);
            }
        });
        var currentanswers=[];
        var changeddanswers=[];
        if(answersList.length > 0) {
            // Set Ids
            // Check if the license has previous answers or they are new answers
            // This section works on the principle of finding the items that currently differ from the ones the user has already saved in the backend
            // if the user changes an answers , the script would find the changed answers ,delete the old answer and insert the new answers
            // If the user deletes an answer to a group question, the script would also delete all answers to the child questions of the parent questio
            if(prevlistanswered.size > 0) {
                $.each(answersList, function(i, val) {
                    var val2='';
                    if(val.Answer_Group__c!=''&&val.Answer_Group__c!=null&&val.Answer_Group__c!=undefined){
                        var three = val.External_id_of_Question__c+val.Answer_Group__c;
                        val2= prevlistanswered.get(three);
                    }else{
                        val2= prevlistanswered.get(val.External_id_of_Question__c);
                    }
                    if( val2!=undefined){
                        if( val.Answer_Text__c== val2.Answer_Text__c) {
                            if(val.Comment__c!=''&&val.Comment__c!=null&&val2.Comment__c!=val.Comment__c)
                            {
                                val.Id= val2.Id;
                                currentanswers.push(val);
                            }
                            else{
                                val.Id = val2.Id; 
                            }
                        }
                        else if ( val.Answer_Text__c!= val2.Answer_Text__c) {
                            if( val2.Comment__c!=''&&val2.Comment__c!=null)
                            {
                                val.Comment__c='';
                            }
                            if(val.Answer_Group__c==undefined)
                            {   
                                currentanswers.push(val);
                                changeddanswers.push(val2.Id);
                                for (var key in prevlistanswered.map) {
                                    if(prevlistanswered.get(key).Answer_Group__c!=null&&prevlistanswered.get(key).Answer_Group__c!=undefined){
                                        if (val2.NewQuestiongroup__c!=null&&prevlistanswered.get(key).Answer_Group__c.includes(val2.NewQuestiongroup__c)) {
                                            changeddanswers.push(prevlistanswered.get(key).Id);
                                        }
                                    }
                                   else  if(prevlistanswered.get(key).Parent_Question_External_Id__c!=null&&prevlistanswered.get(key).Parent_Question_External_Id__c!=undefined&&prevlistanswered.get(key).Parent_Question_External_Id__c==val2.External_id_of_Question__c){
                                       changeddanswers.push(prevlistanswered.get(key).Id);
                                    }
                                }
                            }
                            else if((val2.Answer_Text__c!=null&&val.Answer_Text__c=='')||(val2.Answer_Text__c==null&&val.Answer_Text__c=='')||(val2.Answer_Text__c==null&&val.Answer_Text__c!='')||(val2.Answer_Text__c!=null&&val.Answer_Text__c!='')){
                                if( val.Answer_Text__c==''){
                                    val.Answer_Text__c=null}
                                val.Id= val2.Id;
                                currentanswers.push(val);
                            }
                        }
                    }
                    else if( val2==undefined&&val.Answer_Text__c!=null){                       
                        currentanswers.push(val);
                    }
                });
            }
            else{
                $.each(answersList, function(i, val) {          
                    currentanswers.push(val);
                });
            }
            // Upsert
            //Deleting the changed answers and updating the unchanged ones.
            var maxamount=199;
            var temparray=[];
            var result='';
            console.log('%c Oh my heavens! ', 'background: #222; color: #bada55');
            console.log('changeddansers ::', changeddanswers);
            while(changeddanswers.length>0){
                if(changeddanswers.length<maxamount)
                {   
                    result= sforce.connection.deleteIds(changeddanswers);
                    changeddanswers=[];
                }
                else{
                    temparray = changeddanswers.slice(0,maxamount);
                    changeddanswers=changeddanswers.slice(maxamount,changeddanswers.length);
                    sforce.connection.deleteIds(temparray);
                }
                
            }
            
            while(currentanswers.length>0){
                if(currentanswers.length<maxamount)
                {   
                    
                    result= sforce.connection.upsert("Id", currentanswers);
                    currentanswers=[];
                }
                else{
                    temparray = currentanswers.slice(0,maxamount);
                    currentanswers=currentanswers.slice(maxamount,currentanswers.length);
                    sforce.connection.upsert("Id", temparray);
                }
                
            }
            
            //  OH_NOTIFICATIONS.spinnerStart();
            //var result1 = sforce.connection.deleteIds(changeddanswers);
            // var result = sforce.connection.upsert("Id", currentanswers);
            
            // If insert succeeds
            // if(result[0].success == 'true') {
            // Grab Ids
            // for (var i = 0; i < result.length; i++) {
            //     answerIdList.push(result[i].id);
            //     if (answersList[i] != null) {
            //         answersList[i].Id = result[i].id;
            //     }
            // }
            // Initialize array
            //prevAnswersList = [];
            // Store all inserted records
            // $.each(answersList, function(i, val) {
            //     prevAnswersList.push(val);
            //     // $.each(questionsList, function(j, val2) {
            //     //     if(val.Question__c == val2.id) {
            //     //         val2.answerText = val.Answer_Text__c
            //     //     }
            //     //     $.each(val.childQueList, function(k, val3) {
            //     //     });
            //     // });
            // });
            // Load conditional attachments
            try {
                reloadQuestions();
                ATTACHMENTCOMPNS.addConditionalAttachments();
                
                reloadAttachments();
            }
            catch(e) {
                console.log(e);
            }
            
            // Show error
            // OH_MODAL_UTILITY.errorMessageModal('Your answers have been saved.');
            //  }
            // If insert fails
        }
        else {
            // OH_MODAL_UTILITY.errorMessageModal('Please answer the questions.');
        }
        
        //   $("#saveQuestionsSection").removeAttr("disabled");
        // Stop spinner
        // OH_NOTIFICATIONS.spinnerStop();
    }
}