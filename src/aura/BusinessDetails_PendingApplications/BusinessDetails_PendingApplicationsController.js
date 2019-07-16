({
	doInit : function(component, event, helper) {
      var accId = component.get("v.accountId");      
      helper.fetchPendingCourseData(component,event, helper,accId);
      helper.setPendingNewLicenseApplicationsTableData(component, event, helper);
      helper.setPendingRenewalApplicationsTableData(component, event, helper,accId);
      helper.setPendingMaintanceRequestTableData(component, event, helper,accId);
        helper.getHelptextHelper(component, event, helper);
    },
    
    getHelpText: function (component, event, helper) {
        var htmap = component.get("v.helptextmap");
        console.log('htmap::' + JSON.stringify(htmap));
        var license_Status = event.currentTarget.getAttribute("data-status");
        var license_Sub_Status = event.currentTarget.getAttribute("data-substatus") ? event.currentTarget.getAttribute("data-substatus") : 'null';
        var obj = event.currentTarget.getAttribute("data-obj");
        console.log("getHelpText @@@@ status -->" + license_Status + "\n license_Sub_Status -->" + license_Sub_Status + "\n obj -->" + obj);
        var key = license_Status + '-' + license_Sub_Status + '-' + obj;
        console.log('key::' + key);
        component.set("v.helptextcontent", htmap[key]);
        var value = component.get("v.helptextcontent");
        console.log('value::' + value);
    },

    redirectToCart : function(component, event, helper){
        var portal_Home_URL = component.get("v.portalURL");
        var applicationId = event.getSource().get("v.value");
        var remove_s = portal_Home_URL.slice(0,-2);
        var PayFee_URI = remove_s+'cart?id='+applicationId;
        console.log(PayFee_URI);
    	window.open(PayFee_URI, "_self");
    },
    
    uploadpendingdocuments :function(component, event, helper){
        console.log('uploadpendingdocuments');
        /*
        var license_Id = event.currentTarget.getAttribute("data-id");
        var license_Number = event.currentTarget.getAttribute("data-number");
        helper.uploadPendingdocumentsHelper(component, event, helper,license_Id,license_Number);
        */
    },
    /*
    downloadDocument : function(component, event, helper) {
        console.log('Pending Application Button');
        var recordIdForPDF = event.getSource().get("v.value");
        console.log('recordIdForPDF== ' + recordIdForPDF);
        var OrgURLForPDF = $A.get("$Label.c.OrgURLForPDF");
        window.open(OrgURLForPDF+'apex/DOL_PDFGenerator?id=' + recordIdForPDF,'_top');

    },
	*/    
    updateAdditionalQualification : function(component, event, helper){
        console.log('updateAdditionalQualification..');
        /*
         console.log('updateAdditionalQualification');
        var license_Id = event.getSource().get("v.value")
        helper.updateAdditionalQualificationsHelper(component, event, helper,license_Id);
        */
    },
})