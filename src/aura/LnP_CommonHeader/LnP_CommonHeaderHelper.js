({
    toggleMenu : function(component,event) {
        try{
            var toggleState=component.get("v.toggleNav"); 
            var mainWrapper = document.querySelector('.mainWrapper');
            if(!toggleState){
                
                component.set("v.toggleNav",true);        
                component.set("v.toggleNavText","Close");
                mainWrapper.classList.add('moveToRight');
                
            }
            else{
                component.set("v.toggleNav",false);        
                component.set("v.toggleNavText","Menu");
                mainWrapper.classList.remove('moveToRight');
            }
        }
        catch(e){
            this.consoleLog(e.stack, true);
        }
    },
    
    serviceMenuOpen : function(component,event){
        try{
            //event.preventDefault();
            component.set("v.serviceMenu",true);
       
        } catch(e){
            this.consoleLog(e.stack,true);
        }
    },
    closeServiceMenu : function(component,event){
        try{
           
            //var toggle=component.get("v.serviceMenu");
            component.set('v.serviceMenu',false);
          
        }catch(e){
            this.consoleLog(e.stack,true);
        }
    },
    loginUser : function(component,event){
        try{
            component.set("v.loginCheck",true);
        } catch(e){
            this.consoleLog(e.stack,true);
        }
    }
    
    
})