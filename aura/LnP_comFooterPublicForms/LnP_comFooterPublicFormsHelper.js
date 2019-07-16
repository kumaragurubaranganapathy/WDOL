({
	setItemsList : function(cmp, event, helper) {
        try{
            var itemString = "";
            var urlList = [];
            var labelMap = [];
            const server = cmp.find('server');
            const anAction = cmp.get('c.getCommonFooterCustomLabels');
            server.callServer(
                    anAction,{},"",
                    $A.getCallback(response => {
                        labelMap = response;
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
})