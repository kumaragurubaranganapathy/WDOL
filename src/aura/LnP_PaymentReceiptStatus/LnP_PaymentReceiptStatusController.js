({
	doInit : function(component, event, helper) {
		component.set("v.displayPaymentMethod",false);
        component.set("v.displayCreditCard",false);
        //var d = new Date();
        var today = $A.localizationService.formatDate(new Date(), "YYYY-MM-DD");
        component.set("v.displayTotalAmount",false);
        component.set("v.displayUpdateButton",true);
        //component.set("v.processDate",d.getFullYear() + "-" + d.getMonth()  + "-" + d.getDate());
        component.set("v.processDate",today);
        component.find("ccCheckId").set("v.checked",true);
        helper.hideUnHideCreditCards(component, event, helper);
        component.find("amexCheckId").set("v.checked",true);
        component.find("masterCheckId").set("v.checked",true);
        component.find("visaCheckId").set("v.checked",true);
        component.find("discoverCheckId").set("v.checked",true);
        component.find("achCheckId").set("v.checked",true);
        //helper.doInit(component, event, helper);
        //helper.displayTotalAmounts(component, event, helper);
	},
    hideUnHideCreditCards : function(component, event, helper) {
        helper.hideUnHideCreditCards(component, event, helper);
    },
    displayTotalAmounts : function(component, event, helper) {
        helper.displayTotalAmounts(component, event, helper);
    },
    updateReceiptPayment : function(component, event, helper) {
        helper.paymentReceiptRecordsUpdate(component, event, helper);
    },
    handleCancel : function(component, event, helper) {
        $A.get("e.force:closeQuickAction").fire();
    },
    refreshScreen : function(component, event, helper) {
        $A.get('e.force:refreshView').fire();
    }
})