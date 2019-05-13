({
    /*
    * Check if the browser is ie 11 if so display not support message
    */
	onInit : function(component, event, helper) {
       
       var isIE11 = !!window.MSInputMethodContext && !!document.documentMode;
       component.set('v.isIE11', isIE11);
    },
        
    
    /* 
    * finds the sectionNumber from the event that called this method. Passes sectionNumber to helper method to close current section and either open next Section or complete the checklist
    * @return void
    */
    openNextSection : function(component, event, helper) {
       
        var sectionNumber = event.getParam("sectionNumber");
        var isBeingSaved = true;
        helper.closeCurrentSection(component, sectionNumber, isBeingSaved);
        
    },

    /*
    * finds the sectionNumber from the event that called this method. Passes sectionNumber to helper method to close current section and open previous section
    * @return void
    */

    handlePrevious : function(component, event, helper) {

        var sectionNumber = event.getParam("sectionNumber");
        var isBeingSaved = false;
        helper.closeCurrentSection(component, sectionNumber, isBeingSaved);

        var previous = sectionNumber - 1;
        helper.openSection(component, previous);
    },


    /*
    *
    * This function checks for the number of completed sections and 
    * updates the progress bar appropriately. It is triggered on the initial rendering event, and anytime
    * a section's status changes.
    * @return void
    *
    */
    updateProgress : function(component, event, helper) {


        var totalQuestions = component.get("v.totalNumQuestions");

        if (totalQuestions) {

            var sections = component.find("section");
            var percent = 0;
            
            var isArray = $A.util.isArray(sections);
            if (isArray) {
                
                sections.forEach(function(section){

                    var status = section.get("v.status");
                    var numQuestions = section.get("v.length");
                    
                    if (status === "complete") {
                        percent += Math.round((numQuestions / totalQuestions) * 100);
                    } 

                });

                component.set("v.percentCompleted", percent);
                var header = component.find("checklist-header");
                header.set("v.percentCompleted", percent);

            }
        }

    },

    /*
    * Calls the method in the header to navigate back to the parent record
    *
    */

    clickToParentRecord : function(component, event, helper) {

        var header = component.find("checklist-header");
        header.leaveChecklist();
    },

    showWarning : function(component, event, helper) {

        helper.showErrorMessage(component);
    }
})