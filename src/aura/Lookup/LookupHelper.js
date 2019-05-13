({  

    /*
    * If the sObjectAPIName (the object referenced by the lookup) hasn't been set already, then this will run a query to find it
    * As well, if there's already a search string, then style it as a search result
    * @param component
    *
    */
    getIntialState: function(cmp) {

        if($A.util.isEmpty(cmp.get("v.sObjectAPIName"))) {

            var action = cmp.get("c.getLookupObjectName");
            action.setParams({
                'childAPIName' : cmp.get("v.childAPIName"),
                'fieldName' : cmp.get("v.fieldName")
            });
            action.setCallback(this, function(response){

                if (response.getState() === 'SUCCESS' && cmp.isValid()) {
                    var sObjectAPIName = response.getReturnValue();
                    if (sObjectAPIName) {
                        cmp.set("v.sObjectAPIName", sObjectAPIName);
                    } else {
                       //error handling
                    }
                } else {
                    //error handling
                    
                }
            });
            $A.enqueueAction(action);
        }

        if (cmp.get("v.searchString")) {
            // show the search result pill
            var inputElement = cmp.find('lookup');
            $A.util.addClass(inputElement, 'slds-hide');

            // Show the Lookup pill
            var lookupPill = cmp.find("lookup-pill");
            $A.util.removeClass(lookupPill, 'slds-hide');

            // Lookup Div has selection
            var inputElement = cmp.find('lookup-div');
            $A.util.addClass(inputElement, 'slds-has-selection');
        }
    },

    /*
    * Allows user to retrieve a list without providing a search parameter. 
    * @param component
    */
    doBlankSearch: function(cmp) {
        var searchString = '';
        this.handleSearch(cmp, searchString);
    },
    /**
     * Gets the user's search string
     */
    doSearch : function(cmp) {
        // Get the search string, input element and the selection container
        var searchString = cmp.get('v.searchString');
        
        var lookupList = cmp.find('lookuplist');
        
        // We need at least 2 characters for an effective search
        if (typeof searchString === 'undefined' || searchString.length < 2)
        {
            // Hide the lookuplist
            $A.util.removeClass(lookupList, 'slds-show');
            return;
        }

        this.handleSearch(cmp, searchString);

    },

    /*
    * Perform the SObject search via an Apex Controller
    *
    *
    */
    handleSearch: function(cmp, searchString) {
        var inputElement = cmp.find('lookup');
        // Clear any errors and destroy the old lookup items container
        inputElement.set('v.errors', null);
        var lookupList = cmp.find('lookuplist');
        // Show the lookuplist
        $A.util.addClass(lookupList, 'slds-show');

        // Get the API Name
        var sObjectAPIName = cmp.get('v.sObjectAPIName');


        // get the where clause
        var whereClause = cmp.get("v.whereClause");
        
        // Create an Apex action
        var action = cmp.get('c.getLookupResults');

        // Mark the action as abortable, this is to prevent multiple events from the keyup executing
        action.setAbortable();

        // Set the parameters
        action.setParams({ "searchString" : searchString, "sObjectAPIName" : sObjectAPIName});
                          
        // Define the callback
        action.setCallback(this, function(response) {
            var state = response.getState();

            // Callback succeeded
            if (cmp.isValid() && state === "SUCCESS")
            {
                // Get the search matches
                var matches = response.getReturnValue();

                // If we have no matches, return nothing
                if (matches.length == 0)
                {
                    cmp.set('v.matches', null);
                    return;
                }
                
                // Store the results
                cmp.set('v.matches', matches);
            }
            else if (state === "ERROR") // Handle any error by reporting it
            {
                var errors = response.getError();
                
                if (errors) 
                {
                    if (errors[0] && errors[0].message) 
                    {
                        this.displayToast('Error', errors[0].message);
                    }
                }
                else
                {
                    this.displayToast('Error', 'Unknown error.');
                }
            }
        });
        
        // Enqueue the action                  
        $A.enqueueAction(action);                
    },

    /**
     * Handle the Selection of an Item
     */
    handleSelection : function(cmp, event) {
        // Resolve the Object Id from the events Element Id (this will be the <a> tag)
        var objectId = this.resolveId(event.currentTarget.id);

        // The Object label is the inner text)
        var objectLabel = event.currentTarget.innerText;

        // Create the UpdateLookupId event
        var updateEvent = cmp.getEvent("updateLookupIdEvent");
        
        // Get the Instance Id of the Component
        var instanceId = cmp.get('v.instanceId');

        // Populate the event with the selected Object Id and Instance Id
        updateEvent.setParams({
            "sObjectId" : objectId, "instanceId" : instanceId
        });

        // Fire the event
        updateEvent.fire();

        // Update the Searchstring with the Label
        cmp.set("v.searchString", objectLabel);

        // Hide the Lookup List
        var lookupList = cmp.find("lookuplist");
        $A.util.removeClass(lookupList, 'slds-show');

        // Hide the Input Element
        var inputElement = cmp.find('lookup');
        $A.util.addClass(inputElement, 'slds-hide');

        // Show the Lookup pill
        var lookupPill = cmp.find("lookup-pill");
        $A.util.removeClass(lookupPill, 'slds-hide');

        // Lookup Div has selection
        var inputElement = cmp.find('lookup-div');
        $A.util.addClass(inputElement, 'slds-has-selection');

    },

    /**
     * Clear the Selection
     */
    clearSelection : function(cmp) {
        // Create the ClearLookupId event
        var clearEvent = cmp.getEvent("clearLookupIdEvent");

        // Get the Instance Id of the Component
        var instanceId = cmp.get('v.instanceId');

        // Populate the event with the Instance Id
        clearEvent.setParams({
            "instanceId" : instanceId
        });
        
        // Fire the event
        clearEvent.fire();

        // Clear the Searchstring
        cmp.set("v.searchString", '');

        // Hide the Lookup pill
        var lookupPill = cmp.find("lookup-pill");
        $A.util.addClass(lookupPill, 'slds-hide');

        // Show the Input Element
        var inputElement = cmp.find('lookup');
        $A.util.removeClass(inputElement, 'slds-hide');

        // Lookup Div has no selection
        var inputElement = cmp.find('lookup-div');
        $A.util.removeClass(inputElement, 'slds-has-selection');
    },

    /**
     * Resolve the Object Id from the Element Id by splitting the id at the _
     */
    resolveId : function(elmId)
    {
        var i = elmId.lastIndexOf('_');
        return elmId.substr(i+1);
    },

    /**
     * Display a message
     */
    displayToast : function (title, message) 
    {
        var toast = $A.get("e.force:showToast");

        // For lightning1 show the toast
        if (toast)
        {
            //fire the toast event in Salesforce1
            toast.setParams({
                "title": title,
                "message": message
            });

            toast.fire();
        }
        else // otherwise throw an alert
        {
            alert(title + ': ' + message);
        }
    }
})