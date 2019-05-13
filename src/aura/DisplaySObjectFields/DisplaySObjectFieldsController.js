({
    doInit : function(component, event, helper) {
        
        var config = component.get("v.componentConfig");
        
        config.attributes.label = '';
        config.attributes.title = '';
        
        config = JSON.parse(JSON.stringify(config)); // need to copy the config obj so that only are giving the current cell the value ref

        var path = config.path;

        var obj = component.get("v.objSobject");
        if ($A.util.isUndefined(obj[path])) {
                obj[path] = null;
                obj = JSON.parse(JSON.stringify(obj));
        }
        component.set("v.objSobject", obj);
        
        if (config.componentDef === 'BGCK:LightningLookup') {
                config.attributes.instanceId = component.get("v.objSobject.Id");
                config.attributes.updateLookupIdEvent = component.getReference("c.handleLookupChange");
                config.attributes.clearLookupIdEvent = component.getReference("c.handleLookupChange");
                path = path.replace('__c', '__r.Name');
                config.attributes.searchString = component.get("v.objSobject." + path);
        }
        else {
                config.attributes.value = component.getReference("v.objSobject." + path);
        }
        
        $A.createComponent( 
                config.componentDef, 
                config.attributes,
            function(cmp) {
                component.set("v.body", cmp);
            }
                );      
        var value = component.get("v.objSobject." + config.path);
        component.set("v.value", value);
        component.set("v.hasChanges", false);
    },

    /*
    * Change handler for the component's objSobject. Used to indicate that the record has been modified by the user,
    * so will need to get sent to database when user saves all changes
    *
    *
    */
    handleChange: function(component, event, helper) {
        component.set("v.hasChanges", true);
    },

    /*
    * Event handler for the lookup's events (updateId, clearId)
    * 
    *
    */
    handleLookupChange: function(component, event, helper) {
        var instanceId = event.getParam('instanceId');
        if (instanceId === component.get("v.objSobject.Id")) {
            var path = component.get("v.componentConfig.path");
            var record = component.get("v.objSobject");
            if (event.getParam('sObjectId')){
                    
                    record[path] = event.getParam('sObjectId');
            } else {
                    record[path] = null;
            }
            record = JSON.parse(JSON.stringify(record));
            component.set("v.hasChanges", true);
            component.set("v.objSobject", record);
        }
    }
})