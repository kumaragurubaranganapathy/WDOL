({
	doInit : function(component, event, helper) {
        helper.doInit(component, event, helper);
    },
    declineRequest : function(component, event, helper) {
        var taskId = event.getSource().get("v.name");
        console.log("taskdId::"+ taskId);
        component.set("v.taskId",taskId);
        component.set("v.actionclicked",'Declined');
        
        helper.actionRequest(component, event, helper);
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
        debugger;
        console.log("DCP::"+DCP);
        if(acctName == 'Appraisal Management Companies' && (designation == 'Designated Controlling Person' || designation == 'Controlling person')){
            console.log("acctName::"+acctName);
            console.log( "v.accountContact"+ ctarget.getAttribute("data-whatid"));
            helper.insertRequest(component,event,helper); 
        }else{
        	helper.actionRequest(component, event, helper,subject);    
        }
        
    },
    proceedRequest : function(component, event, helper) {
        //helper.proceedRequest(component, event, helper);
        
    },
    renewRequest : function(component, event, helper) {
        helper.proceedRequest(component, event, helper);
    },
    payFees : function(component, event, helper) {
        helper.payFees(component, event, helper);
    },
    updateRequest : function(component, event, helper) {
        helper.updateRequest(component, event, helper);
    },
    handleClick : function(component, event, helper){
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
        helper.actionRequest(component, event, helper);
    },
    
    openModelReschedule : function(component, event, helper) {
        var taskRecordForModel = event.getSource().get("v.value");
        console.log('Value==' + taskRecordForModel);
        component.set("v.taskRecordForModel", taskRecordForModel);
        console.log('subject==' + component.get("v.taskRecordForModel"));
        component.set("v.isOpenExam", true);
    },
    
    closeModelExamReschedule : function(component, event, helper) {
        component.set("v.isOpenExam", false);
        
    } ,
    linkProfLic : function(component,event,helper){
        helper.linkProfLic(component,event);
    },
    linkBizLic : function(component,event,helper){
        helper.linkBizLic(component,event);
    },
    redirectLicense : function(component,event,helper){
        helper.redirectLicense(component,event);
    },
    redirectBusiness : function(component,event,helper){
        helper.redirectBusiness(component,event);
    }    
 
})