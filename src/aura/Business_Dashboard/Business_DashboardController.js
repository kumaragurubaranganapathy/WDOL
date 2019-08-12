({
	doInit : function(component, event, helper) {
        helper.setDefaultTab(component,event,helper);
		helper.getRecordTypeId(component,event,helper);
        helper.fetchData(component,event, helper);
        helper.getLicenseDetails(component,event,helper);     
	},
    doRender : function(component,event,helper){
        helper.doRender(component,event);
    },
    
    handleActive : function(component,event,helper){
      helper.handleActive(component,event,helper);  
    },
    updateBusinessInfo :function(component,event,helper){
      helper.updateBusinessInfoHelper(component,event,helper);  
    },
    
    handleLicenseLink :  function(component,event,helper){
     /*var link = $A.get("$Label.c.Polaris_Portal_Home")+"licenseSelectionPage";
        var result = component.get("v.mainAccountName");
        var evt = $A.get("e.c:Dol_FetchAccountName");
        evt.setParams({ "acccountName": result});
        evt.fire();
        
     window.open(link, "_self");*/
        var accId = component.get("v.selectedAccount");
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url": "/licenseSelectionPage?accId="+accId
        });
        urlEvent.fire();
    },
    
    businessDetails : function(component, event, helper) {
        console.log("event::"+ event.target.id);
        var accId = event.target.id;
        component.set("v.selectedAccount",accId);
        component.set("v.accountDetail",true);
         component.set("v.licenseDetail",false);
         component.set("v.courseDetail",false);
        component.set("v.breadcrumbLabel","courses");
		helper.businessDetails(component,event,helper);
		helper.setSelectedAccountData(component,event,helper,accId);
	},
    navigateToScreenOne : function(component, event, helper) {
		helper.navigateToScreenOne(component,event,helper);
	},
    navigateToScreenTwo : function(component,event,helper){
        helper.navigateToScreenTwo(component,event);
    },
    licenseScreen : function(component,event,helper){
    	helper.licenseScreen(component,event);
    },
    setBreadCrumb : function(component,event,helper){
        var tab = event.getSource().get('v.id')
        console.log('test::'+ tab);
        component.set("v.breadcrumbLabel",tab); 
        helper.handleActive(component,event,helper);
    },
    
    handleComponentEvent : function(component,event,helper){
        console.log("inside handleCompnent");
        
    	var refresh = event.getParam("refreshFlag");
    	var isbranch = event.getParam("isbranch");
        var licenseId = event.getParam("LicenseId");
        var primaryAccountId = event.getParam("primaryAccountId");
        console.log("licenseId::"+licenseId);
        console.log("primaryAccountId::"+primaryAccountId);
        component.set("v.selectedAccount",primaryAccountId);
        helper.setSelectedAccountData(component,event,helper,primaryAccountId);
        var isDisplayCoursdetails = event.getParam("displayCourseDetails");
        
        var isdisplayLicenseDetails = event.getParam("displayLicenseDetails");
        
        
         console.log("isDisplayCoursdetails.........."+isDisplayCoursdetails);
         
         console.log("isdisplayLicenseDetails.........."+isdisplayLicenseDetails);
         
        if(isbranch){
            component.set("v.branchExam",false);
        } else{
            component.set("v.branchExam",true);
        }
        if(refresh){
            
        	helper.fetchData(component,event,helper);  
        	
        }if(licenseId != null && licenseId !='' && isDisplayCoursdetails === true){
            
            console.log("inside coursedetails......");
            
            component.set("v.isDisplayTabs", false);
            
            component.set("v.accountDetail",false);
            
            component.set("v.licenseId",licenseId);
            
            var tDate = new Date();
            
        	component.set("v.todayDate",tDate);
        	
            helper.getCourseDetails(component,event,helper);
            
            helper.getAddressDetails(component,event,helper);
        }
        if(licenseId != null && licenseId !='' && isdisplayLicenseDetails === true){ 
            
            console.log("inside licenseDetails......");
            
            component.set("v.accountDetail",false);
            
            component.set("v.licenseId",licenseId);
            
            var tDate = new Date();
            
        	component.set("v.todayDate",tDate);
        	
            helper.getLicenseDetails(component,event,helper);
            
            helper.getEndorsementDetails(component,event,helper);
            
            helper.getAddressDetails(component,event,helper);
        }
        console.log('inside refresh::');
	},
    updateContactInfo: function(component, event, helper) {
		helper.updateContactInfo(component, event, helper);
	},
    getAccountName : function (component,event,helper) {
      helper.getAccountName(component, event, helper);  
    },
    BillingCode : function (component,event,helper) {
      helper.BillingCode(component, event, helper);  
    },
    showMoreActions : function(component,event,helper){
        helper.showMoreActions(component,event);
    },
    showMoreDashboard : function(component,event,helper){
    	helper.showMoreDashboard(component,event);
    },
    showMoreAMR : function(component,event,helper){
    	helper.showMoreAMR(component,event);
    },
    addBusiness : function(component,event,helper){
        helper.addBusiness(component,event);
    }    
})