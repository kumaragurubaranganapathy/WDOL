({
   init : function(component, event, helper) {
       helper.selectDashboardRow(component, event, helper);  
  },
  handleApplicationEvent : function(cmp, event) {
        var message = event.getParam("showBurgerIconList");
        cmp.set("v.showBurgerIconList", message);
  }
})