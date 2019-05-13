({
    /*
    * Calls the apex controller ChecklistController and gets a list of all the Lightning Component names in the org. Then
    * calls the loadChecklist function to load the actual checklist.
    * @param component
    * @return void
    *
    */

	getChecklist : function(component) {
		
        this.toggleSpinner(component);
        
        var action = component.get("c.getLigtningComponentNames");
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === 'SUCCESS' && component.isValid()) {
                
                var respString = response.getReturnValue();
                var allComponents = respString.split(',');
                component.set("v.allValidComponents", allComponents);
                this.loadChecklist(component);
            } 
        });
        $A.enqueueAction(action);
        
	},
    /*
    * Calls the apex controller ChecklistController and gets the JSON 'checklist', and handles
    * the initilization of the app.
    * @param component
    * @return void
    *
    */
    loadChecklist: function(component) {
        var parentId = component.get("v.pid");
        var action = component.get("c.getSectionsQuestions");
        action.setParams({"parentRecord" : parentId});

        action.setCallback(this, function(response){
            var state = response.getState();

            if (component.isValid() && state === 'SUCCESS') {
                var checklist = JSON.parse(response.getReturnValue());
                checklist = this.sortChecklist(checklist);
                component.set("v.checklist", checklist);
                var title = ($A.util.isEmpty(checklist.title)) ? 'Previous Page' : checklist.title;
                component.set("v.parentName", title);
                this.toggleSpinner(component);
                this.getTotalNumQuestions(component);
                this.initProgressBar(component, checklist);
                var myself = this;
                var sections = component.find("section");
                if ($A.util.isArray(sections)) {
                    if (sections[0].get("v.status") === 'complete' && component.get("v.mode") !== 'read') {
                        // iterate through sections to find first one that is not complete and set to open
                        // unless in read mode, then the first section should open
                        var opened = false;
                        sections.forEach(function(section){
                            if (section.get("v.status") !== 'complete' && !opened) {
                                opened = true;
                                myself.openSection(component, section.get("v.index"));
                            }
                        });
                    }
                }

            } else {
                this.toggleSpinner(component);
                //error reporting in case of not being able to retrieve questions
                this.showErrorMessage(component);
            }
        });

        $A.enqueueAction(action);

    },

    /*
    * Method to sort checkist sections by the order property.
    * @param checklist Checklist object
    * @return checklist Checklist object with it's sections array property sorted by 'order'
    */
    sortChecklist : function(checklist) {

        var sections = checklist.sections;
        sections.sort(function (s1, s2) {

            var sorter = 0;
            if(s1.order > s2.order) {
                sorter = 1;
            }

            if (s1.order < s2.order) {
                sorter = -1;
            }

            return sorter;
        });

        checklist.sections = sections;
        return checklist;
    },

    /*
    * Shows the spinner .gif while the app is loading its JSON from the server. Hides it once the data has been retrived
    * @param component The current component
    * @return void
    */
    toggleSpinner : function(component) {
        var spinner = component.find("spinner");
        $A.util.toggleClass(spinner, "slds-hide");
    },

    /*
    * Adds the slds-hide class to the js-toggle elements (questions and section description) of the section at indexSectionNumber
    * @param component The component where this method is called
    * @param sectionNumber Integer value of the section to close
    * @return void
    */
    closeCurrentSection : function(component, sectionNumber, isBeingSaved) {
              
        var allSections = component.find("section");
        var thisSection;
        if ($A.util.isArray(allSections)) {
            thisSection = allSections[sectionNumber];
        } else {
            thisSection = allSections;
        }
        
        var next = sectionNumber + 1;
        var elementsToHide = thisSection.find("js-toggle");
        
        elementsToHide.forEach(function(elem) {
            $A.util.addClass(elem, "slds-hide");
        });

        if (isBeingSaved) {
            thisSection.set("v.status", "complete");

            if (next < this.getTotalNumSections(component) ) {
                thisSection.hideWarning();
                this.openSection(component, next);
          
            } else {
                
                // check for warnings on other sections

                var hasErrors = false;

                if ($A.util.isArray(allSections)) {
                    allSections.forEach(function(section){
                        if (section.get("v.hasError")) {
                            hasErrors = true;
                        } else {
                            section.set("v.status", 'complete'); // mark sections without errors as complete so that the modal about unsaved answers doesn't show up
                        }                                        
                    }); 
                } else {
                    if (thisSection.get("v.hasError")) {
                        hasErrors = true;
                       
                    }
                }
 
                if (! hasErrors) {

                   var header = component.find("checklist-header");
                   header.leaveChecklist(); 
                }
                
            }
        }

    },

    /*
    * Finds the requested section, sets its v.opened attribute to true (so that it will instantiate its questions if needed). Then adds the slds-hide class to all the elements marked js-toggle (questions and section description)
    * Sets the focus to the first input element of the section that is to open.
    * @param component The component where this method is called
    * @param sectionNumber Integer value of the section to close
    * @return void
    */

    openSection : function (component, sectionNumber) {
        
        var allSections = component.find("section");
        var nextSection = allSections[sectionNumber];
        var currentStatus = nextSection.get("v.status");
            
        nextSection.set("v.status", "open");
        nextSection.set("v.opened", true);

        var elementsToShow = nextSection.find("js-toggle");

        elementsToShow.forEach(function(elem) {
            $A.util.removeClass(elem, "slds-hide");
        });
        
    },
    
    /*
    * A helper function so the app can check if the current section is the last section
    * @param component Reference to the component
    * @return Integer
    *
    */
    getTotalNumSections : function(component) {
        var checklist = component.get("v.checklist");
        var numSections = checklist.sections.length;
        if (numSections < 1) {
            // if there aren't any sections, show an error message to the user.
            this.showErrorMessage(component);
        }
        return numSections;
    },

    /*
    * A helper function so the app component knows how many total questions there are
    * for updating the progress bar
    * @param component Reference to the component
    * @return void
    *
    */

    getTotalNumQuestions : function(component) {

        var checklist = component.get("v.checklist.sections");
        var numQuestions = 0;

        checklist.forEach(function(section){

            numQuestions += section.questions.length;
        });

        if (numQuestions < 1) {
            // if ther aren't any questions, show an error message to the user
            this.showErrorMessage(component);
        }
        component.set("v.totalNumQuestions", numQuestions);
        return numQuestions;
    },

    /*
    * Once the component has a checklist object (from server), this function gets called
    * It initializes the header's progress bar with the pre-exisiting progress
    * @param component
    * @param checklist full checklist object
    * @return void
    *
    */

    initProgressBar : function(component, checklist) {
        
        var sections = checklist.sections;
        var length = 0;
        var complete = 0;
        sections.forEach(function(section, index) {

            var questions = section.questions;
            

            questions.forEach(function(question){

                if (question.type.BGCK__Type__c !== "Label" && !question.response.BGCK__Page_Question__r.BGCK__Parent_Page_Question__c) {
                    length += 1; // only count actual questions that are also top-level towards the total length

                    if (question.response.BGCK__Actual_Value2__c || question.response.Name === "Skipped") {

                        complete += 1; // only count previously answered/skipped questions towards completion
                    }
                }

            });
        });

        var percent = (length === 0) ? 0 : Math.round(100 * complete / length); //to accomodate for when parent questions aren't in the currently accessed checklist, could lead to divide by 0
        var header = component.find("checklist-header");
        header.set("v.percentCompleted", percent);
        component.set("v.percentCompleted", percent);

    },

    /*
    * Calls in the event of user getting to a checklist page that doesn't have questions configured properly. 
    * If there are no sections, no questions, or an error getting the checklist object from the server.
    * @param component
    * @return void
    *
    */

    showErrorMessage : function(component) {

        var modal = component.find("error-warning");
        var backdrop = component.find("error-warning-backdrop");
        $A.util.addClass(modal, "slds-fade-in-open");
        $A.util.addClass(backdrop, "slds-backdrop--open");
    }
    
})