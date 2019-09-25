({
    
    doInit: function(component, event) {
        var getCLN = component.get("c.listMetadata");
        //var bShowError = false;
        getCLN.setParams({
            strPrefix: component.get("v.autopop")
        });
        getCLN.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                console.log("Response :" + state);
                var storeResponse = response.getReturnValue();
                console.log('storeResponse');
                console.log(storeResponse);
                component.set('v.listlabel', response.getReturnValue());
                component.set("v.showResults", true);
                var list = [];
                for (var i = 0; i < storeResponse.length; i++) {
                    var map = new Object();
                    map.key = storeResponse[i];
                    var getStoreRes = $A.get("$Label.c." + storeResponse[i]);
                    map.value = getStoreRes;
                    list.push(map);
                }
            }
            
        });
        $A.enqueueAction(getCLN);
    },
    
    fetchCLN: function(component, event) {
        var emptyShow = false;
        var isEmpty = $A.util.isEmpty(component.get("v.cSelect"));
        console.log("isEmpty" + isEmpty);
        if (isEmpty) {
            emptyShow = true;
        } else {
            var getCLN = component.get("c.listMetadata");
            var bShowError = false;
            var checkLength = false;
            component.set('v.isSending', true);
            getCLN.setParams({
                strPrefix: component.get("v.autopop")
            });
            getCLN.setCallback(this, function(response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    console.log("Response :" + state);
                    var storeResponse = response.getReturnValue();
                    console.log('storeResponse');
                    console.log(storeResponse);
                    //component.set('v.listlabel',response.getReturnValue());
                    //component.set("v.showResults",true);
                    var list = [];
                    var cSelect = component.get('v.cSelect').toLowerCase();
                    var count = 0;
                    var len = storeResponse.length;
                    //console.log("dynamicValue"+dynamicValue);
                    for (var i = 0; i < len; i++) {
                        if (storeResponse[i].toLowerCase().indexOf(cSelect) > -1) {
                            count++;
                            var map = new Object();
                            map.key = storeResponse[i];
                            var getStoreRes = $A.get("$Label.c." + storeResponse[i]);
                            //component.set("v.cValue",getStoreRes);
                            //map.value = component.get("v.cValue");
                            map.value = getStoreRes;
                            list.push(map);
                            var key = map.key;
                            var value = map.value;
                        }
                        if (count > 100) {
                            console.log('in if');
                            bShowError = true;
                            break;
                        }
                        
                        component.set('v.columns', [{label: 'Custom Label',fieldName: 'key',type: 'text',sortable: true},{label: 'Value',fieldName: 'value',type: 'text',sortable: true}]);
                    }
                    
                    //***********************************************
                    component.set("v.totalPages", Math.ceil(response.getReturnValue().length / component.get("v.pageSize")));
                    component.set("v.searchList", list);
                    component.set("v.currentPageNumber", 1);
                    this.buildData(component, this);
                    
                    //***********************************************
                    
                    
                    if (count == 0) {
                        checkLength = true;
                    }
                    //list.splice(20);
                    component.set("v.bShowError", bShowError);
                    component.set("v.checkLength", checkLength);
                    //component.set("v.searchList",list);
                    //console.log("List Value "+ JSON.stringify(list));
                    console.log("List Value " + list.length);
                    console.log('bShowError' + component.get("v.bShowError"));
                }
                
            });
            
            var requestInitiatedTime = new Date().getTime();
            $A.enqueueAction(getCLN);
        }
        
        component.set("v.emptyShow", isEmpty);
        
    },
    
    buildData: function(component, helper) {
        var data = [];
        var pageNumber = component.get("v.currentPageNumber");
        var pageSize = component.get("v.pageSize");
        var searchList = component.get("v.searchList");
        var x = (pageNumber - 1) * pageSize;
        
        //creating data-table data
        for (; x <= (pageNumber) * pageSize; x++) {
            if (searchList[x]) {
                data.push(searchList[x]);
            }
        }
        component.set("v.data", data);
        console.log("Yaha hai data -"+component.get("v.data"));
        helper.generatePageList(component, pageNumber);
    },
    
    selectCLN: function(component, event) {
        var addLabel = event.getSource().get('v.value');
        component.set("v.cSelect", addLabel);
        console.log("Label Name " + addLabel);
        //var customLabelName = 'LnP_Elg_Ques_3';
        var dynamicLabel = $A.getReference("$Label.c." + addLabel);
        component.set("v.cValue", dynamicLabel);
        console.log('Custom Label value ' + component.get("v.cValue"));
        //component.set("v.showResults",false);
        component.set("v.showResults", false);
    },
    
    /*
  * this function generate page list
  * */
    generatePageList: function(component, pageNumber, helper) {
        pageNumber = parseInt(pageNumber);
        var pageList = [];
        var totalPage = component.get("v.totalPages");
        if (pageNumber < 5) {
            pageList.push(2, 3, 4, 5, 6);
        } else if (pageNumber > (totalPage - 5)) {
            pageList.push(totalPage - 5, totalPage - 4, totalPage - 3, totalPage - 2, totalPage - 1);
        } else {
            pageList.push(pageNumber - 2, pageNumber - 1, pageNumber, pageNumber + 1, pageNumber + 2);
        }
        component.set("v.pageList", pageList);
    }
})