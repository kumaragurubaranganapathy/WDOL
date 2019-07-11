({
    doinit : function(component, event, helper){
        var sectionList = component.get("v.sectionList");
        console.log('List : ',JSON.stringify(sectionList));
        helper.setData(component, event, helper);
        
        //alert(component.get("v.ProviderList").length);
    },
    
    showAddRecord : function(component, event, helper) {       
        
        var addRecord = document.getElementsByClassName('addRecord');
        for (var i = 0; i < addRecord.length; ++i) {
            var item = addRecord[i];  
            item.classList.remove('slds-hide');
        }
        var addRecordBtn = component.find('APdetails');
        $A.util.addClass(addRecordBtn,'slds-hide');
        
    },
    selectChange : function(component, event, helper) { 
        
        if(component.find("picklist").get("v.value")== 'Other')
        {
            component.set("v.showProviderD",true);
        }
        else
        {
            component.set("v.showProviderD",false);
        }
    },
    remove : function(component, event, helper) { 
        helper.removeHelper(component, event, helper);
    },
    
    addDetails : function(component, event, helper) {
        if(component.get("v.effectiveDate")!= null)
        {
            helper.setSelectedValue(component, event, helper); 
        }        	      
    },
    
    handleCancel: function(component, event, helper) {     
        var addRecord = document.getElementsByClassName('addRecord');
        for (var i = 0; i < addRecord.length; ++i) {
            var item = addRecord[i];  
            item.classList.add('slds-hide');
        }
        var addRecordBtn = component.find('APdetails');
        $A.util.removeClass(addRecordBtn,'slds-hide');
        
    },
})