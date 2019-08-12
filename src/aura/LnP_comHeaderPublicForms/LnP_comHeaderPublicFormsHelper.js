({
    setItemsList: function(component, event, helper) {
        try {
            var pageTitle = window.location.href;
            if (pageTitle.includes('login')) {
                component.set("v.pageTitle", 'Login');
            } else if (pageTitle.includes('file-a-complaint')) {
                component.set("v.pageTitle", 'File A Complaint');
            } else if (pageTitle.includes('dashboard')) {
                component.set("v.pageTitle", 'Dashboard');
            } else {
                component.set("v.pageTitle", 'Verify A License');
            }
            
            var itemString = "";
            var urlList = [];
            var urlListtest=[];
            var labelMap = [];
            var urlListone = [];
            
            const server = component.find('server');
            const anAction = component.get('c.getCommonHeaderCustomLabels');
            server.callServer(
                anAction, {}, "",
                $A.getCallback(function(response) {
                    labelMap = response;
                    console.log('In the menu page...'+JSON.stringify(labelMap));
                    for (var key in labelMap) {
                        var tempItemString1 = labelMap[key];
                        itemString = itemString + tempItemString1;
                    }
                    if (itemString != '' && itemString != null) {
                        var itemArray = itemString.split(',');
                        for (var index = 0; index < itemArray.length; index++) {
                            if (index != itemArray.length - 1) {
                                var itemArrayItem = itemArray[index].split(';');
                                if(itemArrayItem[0]=="To Do"||itemArrayItem[0]=="Individual Account"||itemArrayItem[0]=="Business Management"){
                                    urlListtest.push({
                                        value: itemArrayItem[1],
                                        key: itemArrayItem[0]
                                    });
                                }
                                
                                else{
                                    urlList.push({
                                        value: itemArrayItem[1],
                                        key: itemArrayItem[0]
                                    });
                                }
                                
                            }
                        }
                    }
                    
                    
                    component.set("v.itemsList", urlList);
                    component.set("v.itemsListtest", urlListtest);
                    component.set('v.labelMap', labelMap);
                }),
                $A.getCallback(function(errors) {}),
                false, "");
        } catch (e) {
            console.error('Error Stack Message for setItemsList Helper' + e.stack);
        }
    },
    displayMoreLinks: function(component, event, helper) {
        var displaylinks = component.find('moreLinks');
        $A.util.toggleClass(displaylinks, 'slds-hide');
    },
    handleMenuSelectlink: function(component, event) {
        var selectedMenuItemValue = event.getParam("value");
        window.open(selectedMenuItemValue,"_self");
        
    },
    setUserInfo: function(component, event, helper) {
        var headervalue = component.get("v.header");
        var headerfrmsession = component.get("v.headerfromsession");
        //headerfrmsession=true;
        var conId = component.get("v.conIdfromsession");
        console.log('######conId' + conId);
        console.log('headerfrmsession' + headerfrmsession);
        
        if (headervalue) {
            var action = component.get('c.getContactUserInfo');
            action.setParams({
                "conId": component.get("v.contactRecId")
                //"conId":'003r000000FOq9v'
                
            });
            
            action.setCallback(this, function(actionResult) {
                var state = actionResult.getState();
                if (state === "SUCCESS") {
                    var result = actionResult.getReturnValue();
                    component.set("v.userType", result[0]);
                    var nameArr = result[1].split(' ');
                    var nameInitial = nameArr[0].charAt(0) + nameArr[1].charAt(0);
                    component.set("v.userInitial", nameInitial);
                }
            });
            $A.enqueueAction(action);
            
        } else if (headerfrmsession) {
            var action = component.get('c.getContactUserInfo');
            action.setParams({
                "conId": component.get("v.conIdfromsession")
                //"conId":'003r000000FOq9v'
                
            });
            
            action.setCallback(this, function(actionResult) {
                var state = actionResult.getState();
                if (state === "SUCCESS") {
                    var result = actionResult.getReturnValue();
                    component.set("v.userType", result[0]);
                    var nameArr = result[1].split(' ');
                    var nameInitial = nameArr[0].charAt(0) + nameArr[1].charAt(0);
                    component.set("v.userInitial", nameInitial);
                }
            });
            $A.enqueueAction(action);
            
        } else {
            
            try {
                const server = component.find('server');
                const userInfoAction = component.get('c.getCurrentUserInfo');
                server.callServer(
                    userInfoAction, {}, "",
                    $A.getCallback(function(response) {
                        component.set("v.userType", response[0]);
                        var nameArr = response[1].split(' ');
                        var nameInitial = nameArr[0].charAt(0) + nameArr[1].charAt(0);
                        component.set("v.userInitial", nameInitial);
                        
                    }),
                    $A.getCallback(function(errors) {}),
                    false, "");
            } catch (e) {
                console.error('Error Stack Message for setUserInfo Helper' + e.stack);
            }
        }
    },
    burgerIconClicked: function(component, event) {
        try {
            var varClick = component.get("v.showBurgerIconList");
            varClick = !varClick;
            component.set("v.showBurgerIconList", varClick);
            var appEvent = $A.get("e.c:LnP_VerticalNavEvent");
            appEvent.setParams({
                "showBurgerIconList": varClick
            });
            appEvent.fire();
        } catch (e) {
            console.error('Error Stack Message for burgerIconClicked Helper' + e.stack);
        }
    },
    handleMenuSelect: function(component, event) {
        var selectedMenuItemValue = event.getParam("value");
        if (selectedMenuItemValue == 'Logout') {
            window.location.replace($A.get("$Label.c.Polaris_Portal_URL") + 'secur/logout.jsp');
        }
        if (selectedMenuItemValue == 'Manage Business') {
            window.open($A.get("$Label.c.Polaris_Portal_URL") + 's/add-business', "_blank");
        }
    },
    handleLogout: function(component, event) {
        
        window.location.replace($A.get("$Label.c.Polaris_Portal_URL") + 'secur/logout.jsp');
    },
    toggleMenu: function(component, event) {
        var menu = component.find('hamburger-menu');
        var menuItems = component.find('global-menu');
        $A.util.toggleClass(menu, 'open');
        $A.util.toggleClass(menuItems, 'open');
    },
    checkURL : function(component,event){
        var currURL = document.URL;
        if(/license-lookup/.test(currURL)){            
            component.set("v.urlString","License Lookup"); 
        }
        else if(/file-complaint/.test(currURL)){            
            component.set("v.urlString","Complaints"); 
        }
            else if(/course-search/.test(currURL)){            
                component.set("v.urlString","Course Search"); 
            }
                else if(/newdashboard/.test(currURL)){            
                    component.set("v.urlString","Professional"); 
                }
                    else if(/business/.test(currURL)){            
                        component.set("v.urlString","Business"); 
                    }
                        else if(/license-lookup/.test(currURL)){            
                            component.set("v.urlString","License Lookup"); 
                        }
                            else if(/Help-Topic/.test(currURL)){
                                component.set("v.urlString","Help"); 
                            }
                                else
                                    component.set("v.urlString","Home");
        
    },
    redirectToHome : function(component, event) {
        var str ='/';
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url": str
        });
        urlEvent.fire();
      	component.set("v.urlString","Home");
    }
    
    
})