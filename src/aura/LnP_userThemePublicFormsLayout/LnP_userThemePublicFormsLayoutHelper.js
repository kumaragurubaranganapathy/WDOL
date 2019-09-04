({
    checkForBrowser : function(component,event){
        var browserUsed = window.navigator.userAgent;
        var isIE = browserUsed.indexOf("MSIE ") > -1 || browserUsed.indexOf("Trident/") > -1;
        if(isIE && !url.includes('explorer-error-page')){
            //window.location.href("https://dev-polaris.cs32.force.com/lightningwashington/s/explorer-error-page?IE-error");
         
          window.location.href($A.get("$Label.c.Polaris_Portal_Home") + 'explorer-error-page?IE-error');/*var str = '/explorer-error-page?IE-error';
          var urlEvent = $A.get("e.force:navigateToURL");
          urlEvent.setParams({
              "url": str
          });
          urlEvent.fire();*/
      }
        
    },
    /*showNavigation : function(component, event, helper) {
        var pageTitle = window.location.href;
        if(pageTitle.includes('dashboard')){
            component.set("v.showSideNav", true);
        }	
    }, */
    setBackground : function(component, event, helper){
        var pageTitle=window.location.href;
        if(pageTitle.includes('wizard')){
            component.set("v.pageTitle","wizard");
            
        }
    }
})