({
    getRecordTypeId : function(component,event,helper) {
        var action = component.get("c.getRecordTypeIdAccount");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                component.set("v.recordTypeId",result);
            } else {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + 
                                    errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
        });        
    },
    fetchData : function (component,event,helper) {
        var action = component.get("c.getAllAccounts");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var data = response.getReturnValue();
                console.log(response.getReturnValue());
                console.log('business::'+ JSON.stringify(data));
                component.set('v.businessList',data);
                component.set("v.businessListLoaded",true);
                for(var item in data){
                    component.set("v.existingAcc",true);
                    break;
                }                    
            }                          
        });
        $A.enqueueAction(action);
    },
    businessDetails : function (component,event,helper) {
        component.set("v.screenOne", false);
        component.set("v.screenTwo", true);
        component.set("v.isDisplayTabs", true);
        console.log('inside businessDetails ::');
        var accntId =  component.get("v.selectedAccount");
        console.log("accntId::"+accntId);
        var accList = component.get("v.businessList");
        console.log("accntList::"+ JSON.stringify(accList));
        for(var i = 0 ;i<accList.length;i++){
            
            if(accList[i].Id == accntId){
                console.log('accntId::'+ accList[i]);
                component.set("v.selectedAccountId",accList[i].Id);
                component.set("v.accEmail",accList[i].Email__c);
                component.set("v.accPhone",accList[i].Business_Phone__c);
                component.set("v.accUBI",accList[i].UBI_Number__c);
            }           
        }
        
    },
    
    setSelectedAccountData : function (component,event,helper,selectedAccountId) {
        console.log("inside selectedAccountData::");
        var action = component.get("c.getAccountData");
        
        action.setParams({'accountId': selectedAccountId});
        
        action.setCallback(this, function(response) {
            
            var state = response.getState();
            
            if (state === "SUCCESS") {
                
                var accountMap = response.getReturnValue();
                
                console.log('dataAccount::'+selectedAccountId+'   '+JSON.stringify(accountMap));
                
                if(accountMap!=null){
                    
                    var accountvar = accountMap["Account"][0];
                    
                    component.set("v.SelectedAccountDetails",accountvar);
                    component.set("v.mainAccountName",accountMap["Account"][0].Name);
                    component.set("v.ParcelObj",accountMap);
                    component.set("v.isCourseProvider",accountMap["Account"][0].Course_Provider__c);
                    
                }
            }
            
        });
        
        $A.enqueueAction(action);
    },
    
    getAccountName : function (component,event,helper) {
        var result = component.get("v.mainAccountName");
        var evt = $A.get("e.c:LnP_FetchAccounId");
        evt.setParams({ "Show_AccountName": result});
        evt.fire();
    },
    navigateToScreenOne : function (component,event,helper) {
        component.set("v.screenOne", true);
        component.set("v.screenTwo", false);
        component.set("v.screenThree", false);
        component.set("v.isDisplayTabs", true);
        component.set("v.courseDetail",false);
    },
    navigateToScreenTwo :  function(component,event){
        component.set("v.screenOne",false);
        component.set("v.screenTwo", true);
        component.set("v.isDisplayTabs", true);
        component.set("v.courseDetail",false);
        component.set("v.screenThree", false);
        component.set("v.accountDetail",true);
        component.set("v.licenseDetail",false);
    },
    licenseScreen :  function(component,event){
        component.set("v.screenOne",false);
        component.set("v.screenTwo", false);
        component.set("v.screenThree", true);
        component.set("v.courseDetail",false);
    },
    
    
    getLicenseDetails : function(component,event,helper){
        var action = component.get("c.getLicenseData");
        action.setParams({'Id': component.get("v.licenseId")});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                console.log('getLicenseDetails -- > return'+response);
                var data = response.getReturnValue();
                console.log('datalicense::'+data);
                component.set("v.LicenseData",data); 
                component.set("v.licenseDetail",true);
            }                          
        });
        $A.enqueueAction(action);
    },
    
    getCourseDetails : function(component,event,helper){
        var action = component.get("c.getLicenseData");
        action.setParams({'Id': component.get("v.licenseId")});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                console.log('getCourseDetails -- > return'+response);
                var data = response.getReturnValue();
                console.log('datalicense::'+data);
                component.set("v.LicenseData",data); 
                component.set("v.licenseDetail",true);
            }                          
        });
        $A.enqueueAction(action);
        console.log('helper.getCourseDetails --> '+JSON.stringify(action));
    },
    
    getEndorsementDetails : function(component,event,helper){
        var action = component.get("c.getEndorsementData");
        action.setParams({'licenseId': component.get("v.licenseId")});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                
                var data = response.getReturnValue();
                console.log('dataEndorsement::'+data);
                component.set("v.EndorsementData",data);
            }                          
        });
        $A.enqueueAction(action);
    },
    
    getAddressDetails : function(component,event,helper){
        var action = component.get("c.getAddressData");
        action.setParams({'Id': component.get("v.licenseId")});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                
                var data = response.getReturnValue();
                console.log('dataAddress::'+data);
                component.set("v.AddressData",data);
            }                          
        });
        $A.enqueueAction(action);
    },
    updateBusinessInfoHelper : function(component, event, helper) {
        var requestId='';
        var ServiceRequestType = 'Update/Close Company';
        
        var action = component.get("c.insertRequest");
        action.setParams({            
            "acctId": component.get("v.SelectedAccountDetails.Id"),            
            "ServiceRequestType": ServiceRequestType,           
        });
        action.setCallback(this, function(actionResult){
            
            var state = actionResult.getState();
            if (state === "SUCCESS"){
                var result = actionResult.getReturnValue();
                requestId = result;
                sessionStorage.setItem("ServiceRequestType", ServiceRequestType);                
                sessionStorage.setItem("board", ServiceRequestType);
                sessionStorage.setItem("licenseType", ServiceRequestType);
                sessionStorage.setItem("applicationType", ServiceRequestType);
                sessionStorage.setItem("requestId", requestId);
                //sessionStorage.setItem("recordId", component.get("v.recordId"));
                window.location.href = $A.get("$Label.c.Polaris_Portal_Home")+'manage-request';                    
            }
        });
        $A.enqueueAction(action);
        console.log('componet.get("v.requestId")',componet.get("v.requestId"));
        
    },
    
    updateContactInfo: function(component, event, helper) {
        var acctId = component.get("v.SelectedAccountDetails.Id");
        var key = 'businesscontact' ;
        window.location.href = $A.get("$Label.c.Polaris_Portal_Self_Service")+'?par1='+acctId+'&par2='+key;
    },
    
    BillingCode: function(component, event, helper) {
        var acctId = component.get("v.SelectedAccountDetails.Id");
        var key = 'billingcode' ;
        
        window.location.href = $A.get("$Label.c.Polaris_Portal_Self_Service")+'?par1='+acctId+'&par2='+key;
       thirdpartybillingcode= true;
    },
    
    handleActive : function(component,event,helper){
        var tab = event.getSource();
        switch (tab.get('v.id')) {
            case 'Courses' :
                var attr = {accountId: component.get("v.selectedAccount")};
                this.injectComponent('c:Course_LicenseScreen',attr, tab);
                break;
            case 'Licenses' :
                var attr = {accountId: component.get("v.selectedAccount")};
                this.injectComponent('c:Business_LicenseScreen',attr, tab);
                break;
            case 'Relationships':
                var attr = {selectedAccount : component.get("v.selectedAccount"), mainAccountName : component.get("v.mainAccountName"),licenseId:component.get("v.licenseId"), licenseDetail: component.get("v.licenseDetail")};
                this.injectComponent('c:Polaris_Relationship',attr,tab);
                break;
            case 'Branches':
                var attr = {accountId: component.get("v.selectedAccount"),licenseId:component.get("v.licenseId"), BranchLicenses : "true"};
                this.injectComponent('c:Business_LicenseScreen',attr, tab);
                break;
            case 'Draft Applications':
                var attr = {accountId: component.get("v.selectedAccount")};
                this.injectComponent('c:BusinessDetails_DraftApplications',attr, tab);
                break;
            case 'Completed Requests':
                var attr = {CompletedRequestData:component.get("v.CompletedRequestData"),CompletedRequestColumns : component.get("v.CompletedRequestColumns")};
                this.injectComponent('c:LnP_CompletedRequest',attr, tab);
                break;
                
            case 'Pending Applications':
                var attr = {accountId: component.get("v.selectedAccount")};
                this.injectComponent('c:BusinessDetails_PendingApplications',attr, tab);
                break;
            case 'Exam':
                var attr = {licenseData: component.get("v.LicenseData")};
                this.injectComponent('c:LnP_ExamReschedule',attr, tab);
                break;
        }
    },
    
    injectComponent: function (name,attribute,target) {
        $A.createComponent(name,attribute, function (contentComponent, status, error) {
            if (status === "SUCCESS") {
                target.set('v.body', contentComponent);
            } else {
                throw new Error(error);
            }
        });
    },   
    /*doRender : function(component,event){
        var actions = component.find("action-item");
        actions.forEach(function(element){
            var elem = element.getElement();
            if(parseInt(elem.dataset.index)>3)
                $A.util.addClass(elem,'slds-hide');
        });
        console.log("actions="+actions);
    },  */
    showMoreActions : function(component,event){        
        var bizWrapper = component.find("biz-wrapper"); 
        $A.util.toggleClass(bizWrapper,'expanded-actions');
        /*var actions = component.find("action-item");
        var flag = component.get("v.expandedMenu");        
        
        actions.forEach(function(element){
            var elem = element.getElement();
            if(parseInt(elem.dataset.index)>3)
                if(flag)
                $A.util.removeClass(elem,'slds-hide');
            	else
                    $A.util.addClass(elem,'slds-hide'); 
                 $A.util.toggleClass(elem,'slds-hide');
        }); */
        component.set("v.expandedMenu",!component.get("v.expandedMenu"));
        
    },
    showMoreDashboard : function(component,event){
        component.set("v.showMoreDashboard",!component.get("v.showMoreDashboard"));
    },
    showMoreAMR : function(component,event){
        component.set("v.showMoreAMR",!component.get("v.showMoreAMR"));
    },
    addBusiness :  function(component,event){
        
        var str ='/new-business'
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url": str
        });
        urlEvent.fire(); 
    }
    
    
})