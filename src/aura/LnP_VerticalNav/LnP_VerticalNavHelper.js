({
	selectDashboardRow : function(component, event, helper) {
	   var pageTitle = window.location.href;
       var json = '[{"label":"Dashboard", "target":"/dashboard", "icon": "LnP__MyDashboard_E.svg"}, {"label":"Notifications", "target":"notifications", "icon": "LnP__Notification_E.svg"}, {"label":"Applications", "target":"applications", "icon": "LnP__Applications_E.svg"}, {"label":"Service Requests", "target":"service-requests", "icon": "LnP__ServiceRequest_E.svg"}, {"label":"My To Do List", "target":"to-do-list", "icon": "LnP__ToDoList_E.svg"}]';
       var menuList = JSON.parse(json);
       component.set("v.menuList", menuList);
       if(pageTitle.includes('dashboard')){
           component.set("v.activeMenu", 'Dashboard');
       }
	}
})