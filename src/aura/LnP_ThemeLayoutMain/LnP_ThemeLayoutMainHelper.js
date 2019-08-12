({
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