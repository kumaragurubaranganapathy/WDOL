({
    //Select or unselect the option
	toggleSelection : function(component, event) {
      try{
        var checkboxselection =  component.get('v.itemObj'); 
        var className = component.get('v.listItemClass');
        var menuItems = document.querySelectorAll('.'+className);
        var seloptionID = component.get("v.seloptionID");
            //If option is clicked or enter key is pressed
            if(event.keyCode === undefined || event.keyCode === 13){
                var index = component.get("v.optionID");
                var options = component.get("v.options");
                var selectionEvent = component.getEvent('OptionSelection');
                if(component.get('v.singleSelectitem')){
                    //var selectedOptionIndex;
                    options.forEach(function(element,indice) {
                    indice === index ? options[indice]['isSelected'] = !checkboxselection.isSelected :  options[indice]['isSelected'] = false;   
                        if(options[indice]['isSelected']){
                           selectionEvent.setParams({"selectedItem" : options[indice].Name});
                        }
                    });
                    
                    selectionEvent.fire(); 
                }
                else options[index]['isSelected'] = !checkboxselection.isSelected;
                component.set("v.options", options);
                //If browser is IE, explicitly set focus to the clicked li element
                if(navigator.userAgent.match(/Trident/) !== null){
                    var liEle = document.activeElement.parentElement.parentElement;
                    if(liEle.className.indexOf('slds-listbox__item') > -1)
                    liEle.focus();
                }
            }
            //If down arrow is pressed
            else if(event.keyCode === 40){
                //If last option is in focus and down arrow is pressed
                if(seloptionID === (menuItems.length - 1)){
                    menuItems[0].focus();
                    component.set("v.seloptionID",0);
                }
                //If any other option is in focus and down arrow is pressed
                else if(seloptionID < (menuItems.length - 1)){
                    this.setFocusToNextItem(component, event, seloptionID);
                }
            }
            //If escape key is pressed
            else if(event.keyCode === 27){
                component.set("v.isOpen", false);
            }
            //If up arrow is pressed
            else if(event.keyCode === 38){
                //If the first option is in focus and up arrow is pressed
                if(seloptionID === 0){
                    menuItems[menuItems.length - 1].focus();
                    component.set("v.seloptionID",menuItems.length - 1);
                }
                //If any other option is in focus and up arrow is pressed
                else{
                    this.setFocusToPrevItem(component, event, seloptionID);
                } 
            }
      	}
        catch(e){
            this.consoleLog(e.stack,true);
        }
	},
    //To move focus to next option
    setFocusToNextItem : function(component, event, seloptionID){
        try{
            var className = component.get('v.listItemClass');
        	var menuItems = document.querySelectorAll('.'+className);
            if(seloptionID !== undefined){
                menuItems[seloptionID + 1].focus();
                component.set("v.seloptionID",seloptionID + 1);
            }
        }
        catch(e){
            this.consoleLog(e.stack,true);
        }
    },
    //To move focus to previous option
    setFocusToPrevItem : function(component, event, seloptionID){
        try{
            var className = component.get('v.listItemClass');
        	var menuItems = document.querySelectorAll('.'+className);
            if(seloptionID !== undefined){
                menuItems[seloptionID - 1].focus();
                component.set("v.seloptionID",seloptionID - 1);
            }
        }
        catch(e){
            this.consoleLog(e.stack,true);
        }
    }
})