({
	setItemsList : function(cmp, event, helper) {
            var itemString = "";
            var urlList = [];
            var labelMap = [];
            try{
                const server = cmp.find('server');
                const anAction = cmp.get('c.getFooterCustomLabels');
                server.callServer(
                    anAction,{},"",
                    $A.getCallback(response => {
                        labelMap = response;
                        cmp.set("v.HiddenFooterHeading",labelMap['Hidden Heading']);
                        cmp.set("v.HiddenFooterListItem",labelMap['Hidden List Item']);
                        
                        for(var key in labelMap){
                            var tempItemString1 = labelMap[key];
                            itemString=itemString+tempItemString1;
                        }
                        if (itemString != '' && itemString != null){
                            var itemArray = itemString.split(',');
                            for (var index = 0; index < itemArray.length; index++) {
                                if(index!=itemArray.length-1){
                                    var itemArrayItem = itemArray[index].split(';');
                                    urlList.push({value:itemArrayItem[1], key:itemArrayItem[0]});
                                }
                            }
                        }
                        cmp.set("v.itemsList",urlList); 
                    }),
                    $A.getCallback(errors => {
                    }),
                    false,""
                );
        } 
        catch(e){
            console.error('Error Stack Message for setItemsList Helper' + e.stack);	
        }
	},
	showOrHide : function(cmp, event) {
        try{
            var showMore = cmp.get("v.showMore");
            cmp.set("v.showMore", !showMore);
            window.scrollTo(0, 5000);
        }
        catch(e){
           console.error('Error Stack Message for showOrHide Helper' + e.stack); 
        }
	},
	changeFontSize : function(cmp, event){
       try{
           var targetId = event.target.id;
           if(targetId!=''&&targetId!=null){
               if(targetId == 'decreaseFont'){
                   document.getElementById("Adjust-Font").style.fontSize = "10px"; 
                   //document.getElementById("ListItem").style.fontSize = "10px";
               }              
               else if(targetId == 'increaseFont'){
                   document.getElementById("Adjust-Font").style.fontSize = "18px";
                   //document.getElementById("ListItem").style.fontSize = "18px"; 
               }
                   else
                       document.getElementById("Adjust-Font").style.fontSize = "15px";
           }
       }
       catch(e){
       		console.error('Error Stack Message for changeFontSize Helper' + e.stack); 
       }
   }
        
})