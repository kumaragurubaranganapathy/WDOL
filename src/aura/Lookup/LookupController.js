({
    /**
    * Initialize component
    */
    doInit: function(cmp, event, helper) {
        helper.getIntialState(cmp);
    },
    /**
     * Search an SObject for a match
     */
	search : function(cmp, event, helper) {
		helper.doSearch(cmp);        
    },

    /**
     * Select an SObject from a list
     */
    select: function(cmp, event, helper) {
    	helper.handleSelection(cmp, event);
    },
    
    /**
     * Clear the currently selected SObject
     */
    clear: function(cmp, event, helper) {
    	helper.clearSelection(cmp);    
    },

    /**
    *  Click handler for the search icon, to allow users to search for 10 most recent records.
    *
    */
    clickSearch: function(cmp, event, helper) {
        helper.doBlankSearch(cmp);
    }
})