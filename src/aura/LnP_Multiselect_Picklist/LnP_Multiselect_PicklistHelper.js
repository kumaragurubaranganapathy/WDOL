({
    //To update the count of selected options or display the single selected option
    doInit : function(component, event) {
        try{
            var optionsCount = component.get("v.options");
            var count = 0;
            var selectedSingleVal = '';
            var len=optionsCount.length;
            for(var i=0;i< len;i++){
                if(optionsCount[i].isSelected === true){
                    count++;
                    selectedSingleVal = optionsCount[i].Name;
                }
            }
            if(count>1){
                component.set("v.optionsSelected",''+count+' Options Selected');
            }
            else if(count === 1){
                component.set("v.optionsSelected",selectedSingleVal);
            }
                else if(count === 0){
                    component.set("v.optionsSelected",'');    
                }
        }
        catch(e){
            this.consoleLog(e.stack,true);
        }
    },
    //To open/close the picklist dropdown
    toggleOpen : function(component, event) {
        try{
            //document.querySelector('.slds-combobox__input').focus();
            var device = $A.get("$Browser.isIPhone");
            if((event.currentTarget.dataset.attr === 'phone' && device === true) || (event.currentTarget.dataset.attr === 'notIphone' && device === false)){
                //If enter key is pressed or the select input is clicked
                if(event.keyCode === undefined || event.keyCode === 13){
                    var isOpenStatus = component.get("v.isOpen");
                    component.set("v.isOpen", !isOpenStatus);
                    //component.set("v.isOpen", true);
                    this.doInit(component, event);
                }
                //If down arrow key is pressed
                if(event.keyCode === 40){
                    var focusedEle = document.activeElement;
                    var className = component.get('v.listItemClass');
                    var menuItems = document.querySelectorAll('.'+className);
                    menuItems[0].focus();
                    component.set("v.seloptionID",0);
                } 
            } 
        }
        catch(e){
            this.consoleLog(e.stack,true);
        }
    },
    //To remove the pill or deselect an option
    handleRemoveOnly : function(component, event) {
        try{
            var options = component.get("v.options");
            var id = event.currentTarget.name;
            options[id].isSelected = false;
            component.set("v.options", options);
        }
        catch(e){
            this.consoleLog(e.stack,true);
        }
    },
    //To close the picklist on blur of the select input
    closePicklist : function(component, event,flag) {        
        try{
            setTimeout(function(){
                var activeEle;
                try{
                    var ele = document.documentElement.activeElement || document.activeElement;
                    
                    activeEle = ele.className;
                    if((activeEle.indexOf('slds-listbox__item') === -1) && (activeEle.indexOf('slds-media__body') === -1) && (activeEle.indexOf('slds-truncate') === -1) && (activeEle.indexOf('listbox-wrapper') === -1) && (activeEle.indexOf('slds-listbox') === -1)){
                        if(document.activeElement !== event.currentTarget)
                            component.set("v.isOpen", false);
                    }
                    //If browser is IE, and user clicks on scrollbar, pass focus to the input
                    if(navigator.userAgent.match(/Trident/) !== null){
                        if(activeEle.indexOf('listbox-wrapper') > -1){
                            event.target.focus();
                        } 
                    }
                } catch(e){
                    var activeElement = document.body || null;
                    activeEle = activeElement.className;
                    if((activeEle.indexOf('slds-listbox__item') === -1) && (activeEle.indexOf('slds-media__body') === -1) && (activeEle.indexOf('slds-truncate') === -1) && (activeEle.indexOf('listbox-wrapper') === -1)){ 
                        if(activeElement !== event.currentTarget)
                            component.set("v.isOpen", false);
                    }
                    //If browser is IE, and user clicks on scrollbar, pass focus to the input
                    if(navigator.userAgent.match(/Trident/) !== null){
                        if(activeEle.indexOf('listbox-wrapper') > -1){
                            event.target.focus();
                        }  
                    }
                }
            },100);
        }
        catch(e){
            this.consoleLog(e.stack,true);
        }
    }
})