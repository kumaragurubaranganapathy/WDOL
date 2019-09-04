({
    doInit : function(component,event){
        var browserUsed = window.navigator.userAgent;
        var url = window.location.href;
        var isIE = browserUsed.indexOf("MSIE ") > -1 || browserUsed.indexOf("Trident/") > -1;
        console.log(isIE + " = IE Browser");
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
    
    closeServiceMenu : function(component,event){
        try{
            var header=component.find("header");            
            var target=event.target;
            
            if(target){
                
                if(target.className!=="service-wrapper"&&target.className!=='service'){                                      
                    header.closeServiceMenu(header,event);	          		
                }
                
            }
            
            
            
            
        }catch(e){
            console.log(e.stack,true);
        }
    }
})