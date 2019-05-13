({
    getAddressHelper : function(component, event) {
        try{
            var getLength = event.getSource().get('v.value').length;
            if(getLength >= $A.get("$Label.c.Address_Keyword_Length")){
                var getAdd = component.get("c.getAutoComplete");
                
                getAdd.setParams({strPrefix : component.get("v.parcel.Street__c")});
                getAdd.setCallback(this, function(response){
                    var state = response.getState();
                     if(state === "SUCCESS"){
                        component.set('v.lstAddress',response.getReturnValue());
                        component.set("v.showResults",true);
                    }
                });
                $A.enqueueAction(getAdd);
            }
            else
                component.set("v.showResults",false);
            
            document.onkeydown = keydown;
            function keydown(event) {
                component.set("v.showResults",false);
            }
            
            document.onclick = click;
            function click(event){
                component.set("v.showResults",false);
            }
        } 
        catch(e){
            console.error('Error Stack Message for getAddress Helper' + e.stack); 
        }
    },
    
    selectAddress : function(component, event){
        try{
            var addValue = event.currentTarget.dataset.index;
            var addText = event.currentTarget.dataset.text;
            var add = component.get("v.selAddress");
            
            var addlist = addValue.split('_');
            // component.set("v.parcel.Street__c",addlist);
            component.set("v.parcel.State_Province__c",addlist[1]);
            component.set("v.parcel.City__c",addlist[0]);
            var addTextSplit = addText.split(',');
            //console.log('addTextSplit[0]',addTextSplit[0]);
            component.set("v.prefix", addTextSplit[0]);
            component.set("v.showResults",false);
        }
        catch(e){
            console.error('Error Stack Message for selectAddress Helper' + e.stack); 
        }
    },
    
    saveAddressHelper : function(component, event, helper) {
        var address = component.get("v.parcel");
        if(address.City__c==''||address.State_Province__c==''||address.Country__c==''||address.Zip_Postal_Code__c==''||address.Street__c==''||address.Address_Type__c==''){
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Missing fields!",
                "message": "Missing required fields."
            });
            toastEvent.fire();
        } else{
            helper.getData(component, event, helper);
            var elements = document.getElementsByClassName("addAddress");
            for(var i=0; i<elements.length; i++) {
                elements[i].classList.add('slds-hide');
            }
        }
    },
    
    cancelAdressHelper: function(component, event){
        var elements = document.getElementsByClassName("addAddress");
        for(var i=0; i<elements.length; i++) {
            elements[i].classList.add('slds-hide');
        }
        document.getElementsByClassName("addressTypeSelection")[0].classList.add('slds-hide');
        component.set("v.parcel.Street__c","");
        component.set("v.parcel.City__c","");
        component.set("v.parcel.State_Province__c","");
        component.set("v.parcel.Country__c","");
        component.set("v.parcel.Zip_Postal_Code__c","");
        component.set("v.parcel.Address_Type__c","--None--");
    },    
    getData : function(component, event, helper) {
        var address = component.get("v.parcel");
        var applicationId = component.get("v.applicationId");
        component.set('v.parcel.Application_BG__c', applicationId);
        var action=component.get("c.getAddressLines");
        if(address.Address_Type__c==''){
            action.setParams({ addr : null, applicationId:applicationId });
        }else{
            action.setParams({ addr : address, applicationId:applicationId });
        }
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.LicenseAddressList", response.getReturnValue());
                component.set("v.isHide",true);
                component.set("v.parcel.Street__c","");
                component.set("v.parcel.City__c","");
                component.set("v.parcel.State_Province__c","");
                component.set("v.parcel.Country__c","");
                component.set("v.parcel.Zip_Postal_Code__c","");
                component.set("v.parcel.Address_Type__c","--None--");
            }
            else
            {
                alert('failed');
            }
        });
        $A.enqueueAction(action);
        
    },
    selectExistingAddressHelper : function(component, event, helper) {
        try{
            var CompExAddr = component.get("v.existingAddr");
            var applicationId = component.get("v.applicationId");
            var parentDiv = event.target.parentNode;
            var appId = parentDiv.className;
            var addlist = CompExAddr.split(',');
            var addressType = component.get("v.parcel.Address_Type__c");
            component.set("v.parcel.Address_Type__c ",addressType);
            component.set("v.parcel.Street__c",addlist[0]);
            component.set("v.parcel.City__c",addlist[1]);
            component.set("v.parcel.State_Province__c",addlist[2]);
            component.set("v.parcel.Zip_Postal_Code__c",addlist[4]);
            component.set("v.parcel.Country__c",addlist[3]); 
            component.set('v.parcel.Application_BG__c', applicationId);
        }
        catch(e){
            console.error('Error Stack Message for selectAddress Helper' + e.stack); 
        }
    },
    deleteRecordHelper : function(component, event, helper){
        var parentDiv = event.target.parentNode;
        var appId = parentDiv.firstElementChild.className;
        var addressType = event.getSource().get("v.name");
        var recordId = parentDiv.firstElementChild.id;
        //    var recordToDelelte = event.target.parentNode.getAttribute("data-data");
        console.log("recordToDelelte"+recordId);  
        console.log('appId'+appId);
        console.log('addressType'+addressType);
        component.get("v.sObjParcel");
        console.log('component.get("v.sObjParcel")'+component.get("v.sObjParcel"));
        var sObj = component.get("v.sObjParcel");
        var action = component.get("c.deleteTableRecord");
        action.setParams({
            recordId : recordId,addrType : addressType,sobjectType : sObj,applicationId : appId 
        });
        action.setCallback(this,function(response){
            var state = response.getState();
            if(state === "SUCCESS"){
                var resultsToast = $A.get("e.force:showToast");
                resultsToast.setParams({
                    "title": "Deleted",
                    "message": "The record was deleted.",
                    "type": "success"
                });
                resultsToast.fire();
                component.set("v.LicenseAddressList", response.getReturnValue());
            }
            else{
                console.log("--Failed--"+state);
            }
        });
        $A.enqueueAction(action);
    }
})