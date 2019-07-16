({
    init: function(cmp, event, helper) {
        helper.setItemsList(cmp, event, helper);
    },  
    showMore: function(cmp, event, helper) {
        helper.showOrHide(cmp, event);
    },   
    changeFont: function(cmp, event, helper) {
        helper.changeFontSize(cmp, event);
    }, 
})