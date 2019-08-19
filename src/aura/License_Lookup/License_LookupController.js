({	
    doInit : function(component, event, helper) {
        //helper.preventLeaving(event);
        var picklistArray = component.get("v.picklistList");
        var objectApi;
        var fieldsName;
        var auraAttr;
        for(var i=0; i<picklistArray.length; i++){
            objectApi = picklistArray[i].objectApi;
            fieldsName = picklistArray[i].fieldsName;
            auraAttr = picklistArray[i].auraAttr;
            helper.doInit(component, event, objectApi, fieldsName, auraAttr);
        }
        var licenseTypePicklist = component.get("v.picklistListLicenseType");
        var licenseType;
        var auraAttr;
        for(var i=0; i<licenseTypePicklist.length; i++){
            auraAttr = licenseTypePicklist[i].auraAttr;
            licenseType = licenseTypePicklist[i].licenseType;
            helper.fetchLicenseTypes(component, event, auraAttr, licenseType);
        }
	},
    proceedPageAway : function(component, event, helper) {
        component.set("v.popup", false);
		return true;
	},
    stopPageAway : function(component, event, helper) {
        component.set("v.popup", false);
		event.preventDefault();
	},
    navigateToCustomPlace1 : function(component, event, helper) {
		helper.navigateToCustomPlace1(component, event);
	},
    navigateToCustomPlace2 : function(component, event, helper) {
		helper.navigateToCustomPlace2(component, event);
	},
    navigateToCustomPlace3 : function(component, event, helper) {
		event.preventDefault();
	},
    modifySearch : function(component, event, helper) {
		helper.navigateToCustomPlace1(component, event);
	},
    searchWithNum : function(component, event, helper) {
		helper.searchWithNum(component, event);
	},
	cancelSearchWithNum : function(component, event, helper) {
		helper.cancelSearchWithNum(component, event);
	},
    searchWithDetails : function(component, event, helper) {
		helper.searchWithDetails(component, event);
	},
	cancelSearchWithDetails : function(component, event, helper) {
		helper.cancelSearchWithDetails(component, event);
	},
    handleRowAction : function(component, event, helper) {
		var action = event.getParam('action');
        var row = event.getParam('row');
        var licenseId = row.MUSW__License2__r.Name;
        var licenseRecordId = row.MUSW__License2__c;
        var relatedLicense = row.MUSW__License2__r.Related_License__c;
        var licenseType = row.Type;
        component.set("v.licenseRecordType", licenseType);
        switch (action.name) {
            case 'view_details':
             	component.set("v.licenseId",licenseId);
                helper.fetchLicenseDetails(component, event, helper, licenseId, licenseType);
                helper.fetchEndorsementDetails(component, event, helper, licenseRecordId);
                if(relatedLicense!=undefined){
                    helper.fetchParentLicenses(component, event, helper, licenseRecordId);
                } else {
                    helper.fetchChildLicenses(component, event, helper, licenseRecordId); 
                }
                break;
            default:
                break;
        }
	},
    handleSort : function(component,event,helper){
        var sortBy = event.getParam("fieldName");
        var sortDirection = event.getParam("sortDirection");
        component.set("v.sortBy",sortBy);
        component.set("v.sortDirection",sortDirection);
        helper.sortData(component,sortBy,sortDirection);
    },
    downloadCsv : function(component,event,helper){        
        // get the Records list from 'data' attribute 
        var stockData = component.get("v.data");
        
        // call the helper function which "return" the CSV data as a String   
        var csv = helper.convertArrayOfObjectsToCSV(component,stockData);   
        if (csv == null){
            return;
        } 
        
        // ####--code for create a temp. <a> html tag [link tag] for download the CSV file--####     
        var hiddenElement = document.createElement('a');
        hiddenElement.href = 'data:text/csv;charset=utf-8,' + encodeURI(csv);
        hiddenElement.target = '_self'; // 
        hiddenElement.download = 'ExportData.csv';  // CSV file Name* you can change it.[only name not .csv] 
        document.body.appendChild(hiddenElement); // Required for FireFox browser
        hiddenElement.click(); // using click() js function to download csv file
    }
})