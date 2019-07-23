({
    doInit : function(component, event) {
        try{
            //initial settings
            var fullList = component.get("v.fullList");
            var fullListLen = component.get("v.fullList").length;
            var actPg = component.get("v.actPg");
            
            //set pagination pages
            var pgSize = component.get("v.pgSize");
            var totalLen = Math.ceil(fullListLen/pgSize);
           var pgArr = Array.from({ length: totalLen }, function (x, i) { return i + 1; });
            component.set("v.pgArr",pgArr);
            
            component.set("v.dispList",this.setActiveList(component, actPg));
        }
        catch(e){
            console.log(e);
        }
    },
    showPrev : function(component, event) {
        var actPg = component.get("v.actPg")-1;
        component.set("v.dispList",this.setActiveList(component, actPg));
        component.set("v.actPg",actPg);
    },
    showNo : function(component, event) {
        var actPg = parseInt(event.target.dataset.label);
        component.set("v.dispList",this.setActiveList(component, actPg));
        component.set("v.actPg",actPg);
    },
    showNext : function(component, event) {
        var actPg = component.get("v.actPg")+1;
        component.set("v.dispList",this.setActiveList(component, actPg));
        component.set("v.actPg",actPg);
    },
    //logic to set active list
    setActiveList: function(component, actPg){
        try{
            var fullList = component.get("v.fullList");
            var pgSize = component.get("v.pgSize");
            
            var startInd = (actPg-1)*pgSize;
            var endInd = actPg*pgSize-1;
            var dispList = [];
            fullList.forEach(function(item,index){
                if(index>=startInd && index<=endInd)
                dispList.push(item);
            })
            return dispList;
        }
        catch(e){
            console.log(e);
        }
    }
})