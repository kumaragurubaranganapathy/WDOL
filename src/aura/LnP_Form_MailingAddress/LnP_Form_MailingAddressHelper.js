({
    doInit : function(component,event) { 
        try{
            var addressList = [
                {
                    'name':'Phil Duck',
                    'address':'600 5th Ave S, Seattle, WA 98104, USA 321 800 8244'            
                },
                {
                    'name':'Norman Carpenter',
                    'address':'99 Parisian Village 657890, USA 321 800 8244'            
                },
                {
                    'name':'Loretta McBride',
                    'address':'98 McClure Common 657890, USA 321 800 8244'            
                },
                {
                    'name':'Marion Strickland',
                    'address':'020 Feest Field Suite 395 657890, USA 321 800 8244'            
                },
                {
                    'name':'Marion Strickland',
                    'address':'020 Feest Field Suite 395 657890, USA 321 800 8244'            
                },
                {
                    'name':'Marion Strickland',
                    'address':'020 Feest Field Suite 395 657890, USA 321 800 8244'            
                }
            ]
            component.set("v.addressList",addressList);
            
            
        }catch(e){
            this.consoleLog(e.stack,true);
        }
    },
    scrollCards : function(component,event){
        try{
        var cards=document.querySelector(".address-cards");
        var target=event.target;
        if(target.className==="arrow-style left")
            cards.scrollLeft-=100;
        else if(target.className==="arrow-style right")
            cards.scrollLeft+=100;
        }catch(e){
            this.consoleLog(e.stack,true);
        }
    }
    /*rightScroll : function(compont,event){
        var right=document.querySelector(".address-cards");
        
    }*/
})