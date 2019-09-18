({
	doInit : function(component, event, helper) {
        helper.doInit(component, event);
        helper.fetchData(component,event);
        helper.showBusinessAccountAlert(component, event);
        helper.showLicenseAlert(component, event);
    },
    declineRequest : function(component, event, helper) {
        var taskId = event.getSource().get("v.name");
        console.log("taskdId::"+ taskId);
        component.set("v.taskId",taskId);
        component.set("v.actionclicked",'Declined');
        
        helper.actionRequest(component, event);
    },
    acceptRequest : function(component, event, helper) {
        console.log("inside acceptd");
        var ctarget = event.currentTarget;
        var taskId = ctarget.getAttribute("data-id");
        var acctName = ctarget.getAttribute("data-acctname");
       // console.log("dcp::"+ ctarget.getAttributes("data-DCP"));
        var DCP = ctarget.getAttribute("data-DCP");
        var designation = ctarget.getAttribute("data-designation");
        var subject = ctarget.getAttribute("data-subject");
        console.log("acctName::"+acctName);
        console.log("taskdId::"+ taskId);
        component.set("v.taskId",taskId);
        component.set("v.board","Appraisal Management Companies");
        component.set("v.licenseType","Appraisal Management Company");
        component.set("v.ServiceRequestType","AMC Controlling Person Registration");
        component.set("v.actionclicked",'Accepted');
        component.set("v.accountContact",ctarget.getAttribute("data-whatid"));
        //debugger;
        console.log("DCP::"+DCP);
        if(acctName == 'Appraisal Management Companies' && (designation == 'Designated Controlling Person' || designation == 'Controlling person')){
            console.log("acctName::"+acctName);
            console.log( "v.accountContact"+ ctarget.getAttribute("data-whatid"));
            helper.insertRequest(component,event); 
        }else{
        	helper.actionRequest(component, event,subject);    
        }
        
    },
    proceedRequest : function(component, event) {
        //helper.proceedRequest(component, event);
        
    },
    renewRequest : function(component, event, helper) {
        helper.proceedRequest(component, event);
    },
    payFees : function(component, event, helper) {
        helper.payFees(component, event);
    },
    StartPayment:function(component, event, helper) {
        helper.StartPaymentHelper(component, event);
    },
    updateRequest : function(component, event, helper) {
        helper.updateRequest(component, event);
    },
    handleClick : function(component, event){
        var portal_Home_URL = component.get("v.portalURL");
        var licenseSelectionPage_URI = portal_Home_URL+'licenseSelectionPage';
    	window.open(licenseSelectionPage_URI, "_self");
    },
    //Close popup 
    closeModel: function(component, event, helper) {
		helper.closeModel(component, event);
	},
    
    acceptLicenseRequest : function(component, event, helper) {
        var ctarget = event.currentTarget;
        var taskId = ctarget.getAttribute("data-id");
        console.log("taskdId::"+ taskId);
        component.set("v.taskId",taskId);
        component.set("v.actionclicked",'Accepted');
        helper.actionRequest(component, event);
    },
    StartCEAuditAMR:function(component, event) {
        var ctarget = event.currentTarget;
        console.log('inside draftLicense::');
        
        sessionStorage.setItem("ServiceRequestType", ctarget.getAttribute("data-requestType"));                
        sessionStorage.setItem("board", ctarget.getAttribute("data-board"));
        sessionStorage.setItem("licenseType", ctarget.getAttribute("data-licenseType"));        
        sessionStorage.setItem("requestId", ctarget.getAttribute("data-recordId"));
        sessionStorage.setItem("recordId", ctarget.getAttribute("data-license"));
        window.location.href = $A.get("$Label.c.Polaris_Portal_Home")+'manage-request';
    },
    openModelReschedule : function(component, event) {
        var taskRecordForModel = event.getSource().get("v.value");
        console.log('Value==' + JSON.stringify(taskRecordForModel));
        component.set("v.taskRecordForModel", taskRecordForModel);
        console.log('subject==' + component.get("v.taskRecordForModel"));
        component.set("v.isOpenExam", true);
    },
    
    closeModelExamReschedule : function(component, event) {
        component.set("v.isOpenExam", false);
        
    } ,
    linkProfLic : function(component,event,helper){
        helper.linkProfLic(component);
    },
    linkBizLic : function(component,event,helper){
        helper.linkBizLic(component);
    },
    redirectLicense : function(component,event,helper){
        helper.redirectLicense(component);
    },
    redirectBusiness : function(component,event,helper){
        helper.redirectBusiness(component);
    },
    
    goToProfDashboard : function(component,event,helper){
        helper.goToProfDashboard(component);
    },
    bizLicApp : function(component,event,helper){
        helper.bizLicApp(component);
    },
    goToBizDashboard : function(component,event,helper){
        helper.goToBizDashboard(component);
    },
    openTrainingApp : function(component,event,helper){
        helper.openTrainingApp(component);
    },
    StartRequestInformation : function(component,event,helper){
        helper.StartRequestInformationHelper(component,event);
    },
    StartRequestEducationInformation : function(component,event,helper){
        helper.StartRequestEducationInformationHelper(component,event);
    },
 
})