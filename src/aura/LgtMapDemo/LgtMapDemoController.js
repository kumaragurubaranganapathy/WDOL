({
    init: function (cmp, event, helper) {
        console.log('Inside Init');
var container = cmp.find("mapcontainer");
        var markers = cmp.get('v.mapMarkers');
        var action = cmp.get('c.getMarkers');
        action.setCallback(this, function(response){
                    
            console.log('Inside callback');
            markers = response.getReturnValue();
            console.log('The markers are :'+markers);
                cmp.set('v.mapMarkers', markers);
                cmp.set('v.center', {
                    location: {
                        City: 'Seattle'
                    }
                });
                cmp.set('v.zoomLevel', 13);
                cmp.set('v.markersTitle', 'Inspections');
                cmp.set('v.showFooter', true);
            	var center = cmp.get('v.center');
            var zoomLevel = cmp.get('v.zoomLevel');
            var markersTitle = cmp.get('v.markersTitle');
            var showFooter = cmp.get('v.showFooter');
            if(markers!=undefined && markers!="" && markers!=null ){
                console.log('Inside Markers has value'+markers);
        		$A.createComponent("lightning:map",{
                    mapMarkers: markers,
                    center: center,
                zoomLevel: zoomLevel,
                    markersTitle: markersTitle,
                    showFooter: showFooter
                    
            },function(cmp) {
                               container.set("v.body", [cmp]);
                           });
            }else{
                console.log('Inside Markers does not have value'+markers);
               component.set( "v.message", 'Completed Successfully!');
                $A.createComponent("lightning:formattedText ",{
                    value: 'You do not have any inspection'
                    
            },function(cmp) {
                               container.set("v.body", [cmp]);
                           });               
            }
        });
        var action2 = cmp.get('c.getRoute');
        action2.setCallback(this, function(response){
            var route = response.getReturnValue();
            console.log('The route is:'+route);
            cmp.set('v.route', route);
        });
        $A.enqueueAction(action);
        $A.enqueueAction(action2);
    },
    goToExternalSite: function(component, event, helper) {
		var route = component.get('v.route');
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url": route
        });
        urlEvent.fire();
	}
})