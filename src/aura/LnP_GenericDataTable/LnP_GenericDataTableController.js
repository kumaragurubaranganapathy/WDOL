({
	doInit : function(component, event, helper) {
		helper.setColumnData(component, event, helper);
        helper.setRowData(component, event, helper);
	},
    
    loadMoreData: function (cmp, event, helper) {
        //Display a spinner to signal that data is being loaded
        //event.getSource().set("v.isLoading", true);
        //Display "Loading" when more data is being loaded
        cmp.set('v.loadMoreStatus', 'Loading');
        helper.fetchData(cmp, cmp.get('v.rowsToLoad'))
            .then($A.getCallback(function (data) {
                if (cmp.get('v.data').length >= cmp.get('v.totalNumberOfRows')) {
                    cmp.set('v.enableInfiniteLoading', false);
                    cmp.set('v.loadMoreStatus', 'No more data to load');
                } else {
                    var currentData = cmp.get('v.data');
                    //Appends new data to the end of the table
                    var newData = currentData.concat(data);
                    cmp.set('v.data', newData);
                    cmp.set('v.loadMoreStatus', '');
                }
               //event.getSource().set("v.isLoading", false);
            }));
    }

})