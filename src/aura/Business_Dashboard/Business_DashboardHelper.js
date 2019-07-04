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
        
        var action = component.get("c.getAccountData");
        
        action.setParams({'accountId': selectedAccountId});
        
        action.setCallback(this, function(response) {
            
            var state = response.getState();
            
            if (state === "SUCCESS") {
                    
                    var accountMap = response.getReturnValue();
                    
                     console.log('data::'+selectedAccountId+'   '+JSON.stringify(accountMap));
                     
                    if(accountMap!=null){
                        
                        var accountvar = accountMap["Account"][0];
                        
                        component.set("v.SelectedAccountDetails",accountvar); 
                        
                        component.set("v.ParcelObj",accountMap);
                
                }
            }
            
        });
        
        $A.enqueueAction(action);
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
                
                var data = response.getReturnValue();
                console.log('data::'+data);
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
                
                var data = response.getReturnValue();
                console.log('data::'+data);
                component.set("v.LicenseData",data); 
                component.set("v.courseDetail",true);
            }                          
        });
        $A.enqueueAction(action);
    },
    
    getEndorsementDetails : function(component,event,helper){
        var action = component.get("c.getEndorsementData");
        action.setParams({'Id': component.get("v.licenseId")});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                
                var data = response.getReturnValue();
                console.log('data::'+data);
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
                console.log('data::'+data);
                component.set("v.AddressData",data);
            }                          
        });
        $A.enqueueAction(action);
    },
    
    updateContactInfo: function(component, event, helper) {
        var acctId = component.get("v.SelectedAccountDetails.Id");
        var key = 'businesscontact' ;
        window.location.href = $A.get("$Label.c.Polaris_Portal_Self_Service")+'?par1='+acctId+'&par2='+key;
	}
    
})