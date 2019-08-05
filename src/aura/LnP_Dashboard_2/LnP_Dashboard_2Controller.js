({
    doInit : function(component, event, helper) {
        helper.setJSON(component, event, helper);
        helper.setCurrentLicensesTableData(component, event, helper);
        helper.setRelationshipTableData(component, event, helper);
        helper.setDraftNewLicenseApplicationsTableData(component, event, helper);
        helper.setDraftRenewalApplicationsTableData(component, event, helper);
        helper.setDraftMaintanceRequestTableData(component, event, helper);
        
        helper.setPendingNewLicenseApplicationsTableData(component, event, helper);
        helper.setPendingRenewalApplicationsTableData(component, event, helper);
        helper.setPendingMaintanceRequestTableData(component, event, helper);
        helper.setCompletedMaintanceRequestTableData(component, event, helper);
        helper.setContactId(component, event, helper);
        helper.getHelptextHelper(component, event, helper);
        //component.set("v.loadingSpinner",false);
        
    },
    getHelpText : function(component, event, helper) {
        var htmap = component.get("v.helptextmap");
        console.log('htmap::'+JSON.stringify(htmap));
        var license_Status = event.currentTarget.getAttribute("data-status");
        var license_Sub_Status = event.currentTarget.getAttribute("data-substatus") ? event.currentTarget.getAttribute("data-substatus") : 'null';
        var obj = event.currentTarget.getAttribute("data-obj");
        console.log("getHelpText @@@@ status -->"+license_Status+"\n license_Sub_Status -->"+license_Sub_Status+"\n obj -->"+obj);
        var key = license_Status + '-' + license_Sub_Status + '-' + obj;
        console.log('key::'+key);
        component.set("v.helptextcontent", htmap[key]);
        var value = component.get("v.helptextcontent");
        console.log('value::'+value);
    },
    handleAssociationSubmissionSuccess: function(component, event, helper){
        
        var params = event.getParams();
        
        var association_Id =  params.response.id;
        
        component.set("v.displayAssociationForm","false");
        
        console.log("handleAssociationSubmissionSuccess....."+association_Id);
        
        var action = component.get("c.createAssociationTask");
        
        action.setParams({"associationID":association_Id});
        
        action.setCallback(this,function(response){
            
            var state = response.getState();
            
            if (state === "SUCCESS") {
                
                if(response.getReturnValue()){
                    
                    helper.showToast(component, event, helper,"Association has been succesfully created ","success");  
                    
                }else{
                    
                    helper.showToast(component, event, helper,"Please contact system administrator","error");
                }
                
            }else if (state === "ERROR") {
                var errors = response.getError();
                console.error(JSON.stringify(errors));
            } 
            
        });
        
        $A.enqueueAction(action); 
    },
    
    handleAssociationSubmissionError: function(component, event, helper){
        
        helper.showToast(component, event, helper,"Please contact system administrator","error");
    },
    
    openAssociationForm: function(component, event, helper){
        
        helper.setAssociationdefaultrecordTypeIdHelper(component, event, helper);
        
        component.set("v.displayAssociationForm","true");
    },
    
    closeModalWindow: function(component, event, helper){
        
        var dataAttribute =   event.currentTarget.getAttribute("closeModalWindow");
        if(dataAttribute = "displayAssociationForm"){
            component.set("v.displayAssociationForm","false");    
        }
        
    },
    
    openExistingApp : function(component, event, helper){
        helper.openExistingAppHelper(component, event, helper);
    },
    renewApplication : function(component, event, helper){
        helper.renewApplicationHelper(component, event, helper);
    },
    renewLicense : function(component, event, helper){         
        helper.renewLicenseHelper(component, event, helper);
    },
    manageEndorsement : function(component, event, helper){         
        helper.manageEndorsementHelper(component, event, helper);
    },
    
    manageLicense : function(component,event,helper){
        helper.manageLicenseHelper(component,event,helper);
    },
    handleValueSelect : function(component, event, helper){        
        var parcedValue = event.getParam("value").split(',');       
        var selectvalue = parcedValue[0];
        var selectedfirst = parcedValue[1];
        var selectedsecond = parcedValue[2];
        if(selectvalue=='PDF')
        {
            window.location.href = '/SaveIncompleteApplication?applicationType='+selectedfirst+'&pid='+selectedsecond;
        }
        else
            helper.manageEndorsementHelper(component, event, helper);
    },
    viewMoreLicenses : function(component, event, helper){
        helper.viewMoreLicenses(component, event, helper);
    },
    
    viewMoreBusLicenses : function(component,event,helper){
        helper.viewMoreBusnesLicenses(component,event,helper);
    },
    
    viewMoreApplications : function(component, event, helper){
        helper.viewMoreApplications(component, event, helper);
    },
    
    generatePDF : function(component, event, helper){
        console.log("License Id== " + event.getSource().get("v.value"));
        var sendDataProc = component.get("v.sendData");
        var dataToSend = {
            "label" : "This is test"
        }; //this is data you want to send for PDF generation
        
        //invoke vf page js method
        sendDataProc(dataToSend, function(){
            //handle callback
        });
    },    
    redirectToCart :  function(component, event, helper){
        
        var portal_Home_URL = component.get("v.portalURL");
        var applicationId = event.getSource().get("v.value");
        var action = component.get("c.checkActiveCart");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var checkResult = response.getReturnValue();
                if(checkResult){
                    var str ='/cart?id='+applicationId;
                    var urlEvent = $A.get("e.force:navigateToURL");
                    urlEvent.setParams({
                        "url": str
                    });
                    urlEvent.fire();
                }else{
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Error!",
                        "message": "You do not have an active cart currently",
                        "type": "error"
                    });
                    toastEvent.fire();
                }
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.error("Error message: " + errors[0].message);
                    }
                } else {
                    console.error("Unknown error");
                }
            }
        });
        $A.enqueueAction(action);
        /*var remove_s = portal_Home_URL.slice(0,-2);
        var PayFee_URI = remove_s+'cart?id='+applicationId;
        window.open(PayFee_URI, "_self"); */        
        
    }, 
    
    
    uploadpendingdocuments :function(component, event, helper){
        console.log('uploadpendingdocuments');
        var license_Id = event.currentTarget.getAttribute("data-id");
        var license_Number = event.currentTarget.getAttribute("data-number");
        helper.uploadPendingdocumentsHelper(component, event, helper,license_Id,license_Number);
    },
    
    updateAdditionalQualification : function(component, event, helper){
        console.log('updateAdditionalQualification');
        var license_Id = event.currentTarget.getAttribute("data-id");
        var sobjectname =  event.currentTarget.getAttribute("data-relatedSobject");
        //var license_Id = event.getSource().get("v.value")
        helper.updateAdditionalQualificationsHelper(component, event, helper,license_Id,sobjectname);
    },
    
    setLicenseToInReview :function(component, event, helper){
        var license_Id = event.currentTarget.getAttribute("data-id");
        helper.setLicenseToInReview(component, event, helper,license_Id);
    },
    
    removeAccountContactRelation : function(component, event, helper){
        
        var account_ContactId = event.currentTarget.getAttribute("data-id");
        helper.removeAccountContactRelationHelper(component, event, helper,account_ContactId); 
        component.set("v.displayRemoveAccountContactModal","false");
        
    },
    closeRemoveAccountContactRelationModal : function(component, event, helper){
        
        component.set("v.displayRemoveAccountContactModal","false");
    },
    
    openRemoveAccountContactRelationModal : function(component, event, helper){
        
        var account_ContactId = event.currentTarget.getAttribute("data-id");
        component.set("v.removeAccountContactRelationId",account_ContactId);
        component.set("v.displayRemoveAccountContactModal","true");
        
    },
    
    closeRemoveAccountContactRelationModal : function(component, event, helper){
        
        component.set("v.displayRemoveAccountContactModal","false");
    },
    
    opendisplayRemoveBusinessRelationShipModal  : function(component, event, helper){
        
        var associateId = event.currentTarget.getAttribute("data-id");
        
        component.set("v.removeAssociationtRelationId",associateId);
        
        component.set("v.displayRemoveBusinessRelationShipModal","true");
    },
    
    closedisplayRemoveBusinessRelationShipModal  : function(component, event, helper){
        
        component.set("v.displayRemoveBusinessRelationShipModal","false");
        
    },
    
    opendisplayRemovePeerRelationShipModal : function(component, event, helper){
        
        var associateId = event.currentTarget.getAttribute("data-id");
        
        component.set("v.removeAssociationtRelationId",associateId);
        
        component.set("v.displayRemovePeerRelationShipModal","true");
    },
    
    closedisplayRemovePeerRelationShipModal : function(component, event, helper){
        component.set("v.displayRemovePeerRelationShipModal","false");
    },
    
    removeAssociationRelation : function(component, event, helper){
        
        var associateId = event.currentTarget.getAttribute("data-id");
        
        helper.removeremoveAssociationRelationHelper(component, event, helper,associateId);  
        
        component.set("v.displayRemovePeerRelationShipModal","false");
        
        component.set("v.displayRemoveBusinessRelationShipModal","false");
        
    },
    
    dsiplayLicenseDetails : function(component, event, helper){
        
        var licenseId = event.target.getAttribute("data-licenseId");
        
        component.set("v.licenseId",licenseId);
        
        helper.fetchLicenseDetails(component, event, helper, licenseId);
        
        helper.fetchEndorsementDetails(component, event, helper, licenseId);
        
        helper.fetchBusinessRelationShipRecords(component, event, helper,licenseId);
        
        helper.setDraftAMRLicenseDetailTableData(component,event,helper,licenseId);
    },
    
    dsiplayPendingLicenseDetails : function(component, event, helper){
        
        var isPendingLicense =true;
        
        var licenseId = event.target.getAttribute("data-licenseId");
        
        component.set("v.licenseId",licenseId);
        
        helper.fetchLicenseDetails(component, event, helper, licenseId);
        
        helper.fetchEndorsementDetails(component, event, helper, licenseId);
        
        
    },
    
    handleProfessionalBreadCrumb : function(component, event, helper){
        
        helper.setDefaults(component, event, helper);
        
    },
    
    editDraftLicenseApplication  : function(component, event, helper){
        var ctarget = event.currentTarget;
        sessionStorage.setItem("applicationId", ctarget.getAttribute("data-recordId"));
        sessionStorage.setItem("licenseType", ctarget.getAttribute("data-licenseType"));
        sessionStorage.setItem("board", ctarget.getAttribute("data-board"));
        sessionStorage.setItem("applicationType", ctarget.getAttribute("data-applicationType"));
        sessionStorage.setItem("flowType", "Application");
        if(ctarget.getAttribute("data-isrenewal") == "true"){
            sessionStorage.setItem("renewalReinstate", "Renewal");
            window.location.href='/lightningwashington/s/polaris-renewal';  
        } else {
            window.location.href='/lightningwashington/s/apply-for-license';  
        }
    },
    deleteDraftLicenseApplication: function(component, event, helper) {
        var ctarget = event.currentTarget;
        var application_Id = ctarget.getAttribute("data-recordId");
    },
    editDraftRenewApplications  : function(component, event, helper){
        var ctarget = event.currentTarget;
        sessionStorage.setItem("applicationId", ctarget.getAttribute("data-recordId"));
        sessionStorage.setItem("licenseType", ctarget.getAttribute("data-licenseType"));
        sessionStorage.setItem("board", ctarget.getAttribute("data-board"));
        sessionStorage.setItem("flowType", "Application");
        sessionStorage.setItem("renewalReinstate", "Renewal");
        window.location.href='/lightningwashington/s/polaris-renewal';  
        
    },
    
    deleteDraftRenewApplications: function(component, event, helper) {
        var ctarget = event.currentTarget;
        var Renew_application_Id = ctarget.getAttribute("data-recordId");
    },
    CEAuditAMR : function(component,event,helper){
        var ctarget = event.currentTarget;
        console.log('inside draftLicense::');
        
        sessionStorage.setItem("ServiceRequestType", ctarget.getAttribute("data-requestType"));                
        sessionStorage.setItem("board", ctarget.getAttribute("data-board"));
        sessionStorage.setItem("licenseType", ctarget.getAttribute("data-licenseType"));
        //     sessionStorage.setItem("applicationType", );
        sessionStorage.setItem("requestId", ctarget.getAttribute("data-recordId"));
        sessionStorage.setItem("recordId", ctarget.getAttribute("data-license"));
        window.location.href = $A.get("$Label.c.Polaris_Portal_Home")+'manage-request'; 
        
        
        var appIsRenewal = ctarget.getAttribute("data-isCeAudit");
        
        if(appIsRenewal == 'true'){
            console.log('inside ce audit request ::');
            sessionStorage.setItem("renewalReinstate", renewreinstate);
            sessionStorage.setItem("flowType", "Application");
            window.location.href='/lightningwashington/s/manage-request';  
        } 
        
    },
    downloadDocument : function(component, event, helper) {
        console.log('Pending Application Button');
        var recordIdForPDF = event.getSource().get("v.value");
        console.log('recordIdForPDF== ' + recordIdForPDF);
        var OrgURLForPDF = $A.get("$Label.c.OrgURLForPDF");
        window.open(OrgURLForPDF+'apex/DOL_PDFGenerator?id=' + recordIdForPDF,'_top');
        
    },
    refreshList : function(component,event,helper){
        helper.refreshList(component,event);
    },
    showMore : function(component,event,helper){
        helper.showMore(component,event);
    },
    backToDashboard : function(component,event,helper){
        helper.backToDashboard(component,event);
    }
    
})