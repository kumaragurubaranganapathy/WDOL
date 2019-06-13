({
	setFormQuestions : function(component, event, helper) {
        try{
            var pageTitle = window.location.href;
            var labelMap = [];
            var json;
            const server = component.find('server');
            const anAction = component.get('c.getFormsJSON');
            server.callServer(anAction,{}, "", 
                $A.getCallback(response => { 
                    labelMap = response;
                    /*if(pageTitle.includes('file-a-complaint')){*/
                     if(pageTitle.indexOf("/file-a-complaint") > -1) {
                        component.set("v.pageHeader", 'File A Complaint');
                        pageTitle = 'file-a-complaint';
                        json = labelMap['File A Complaint'];
                        component.set("v.showPath", true);
                    }
                   
            
                    var section = JSON.parse(json);
                    component.set("v.section", section);
                    component.set("v.totalTabs", section.length);
                }),
                $A.getCallback(errors => {
                }),
                false,"");
            }
       catch(e){
            console.error('Error Stack Message for setFormQuestions Helper' + e.stack); 
       }
	},
    goToPreviousTab : function(component, event) {
        try{
            var tabNumber = component.get("v.currentTab");
            component.set("v.currentTab", tabNumber-1);
            component.set("v.showSubSection", false);
        }
        catch(e){
            console.error('Error Stack Message for goToPreviousTab Helper' + e.stack); 
       }
    },
    goToNextTab : function(component, event) {
        try{
            var curTab= component.get("v.currentTab");		
            if(curTab==2){
                var validFields = component.find("formFields2").reduce(function (validSoFar, inputCmp) {
                                            inputCmp.showHelpMessageIfInvalid();
                                            return validSoFar && inputCmp.get('v.validity').valid;
                                        }, true);		
                if(validFields){
                    
                    var tabNumber = component.get("v.currentTab");
                    component.set("v.currentTab", tabNumber+1);
                }
                else{
                    const toastEvent = $A.get("e.force:showToast");
                    if (typeof toastEvent !== 'undefined') {
                        toastEvent.setParams({
                            title : 'ERROR!',
                            message : 'Please enter appropriate values!',
                            type : 'error',
                        });
                        toastEvent.fire();
                    }
                }  
                
                component.set("v.showSubSection", false);
                var lastUpdated = component.get("v.lastUpdatedTab");
                if((tabNumber+1)>lastUpdated){
                    component.set("v.lastUpdatedTab",tabNumber+1 );
                }
            }
            else{
                var tabNumber = component.get("v.currentTab");
                component.set("v.currentTab", tabNumber+1);
            }
            component.set("v.prefix",'');
            component.set("v.state",'');
            component.set("v.city",'');
        }
       catch(e){
            console.error('Error Stack Message for goToNextTab Helper' + e.stack); 
       }
    },
	fillSubSections : function(component, event) {
        try{
            var v = component.get("v.showSubSection" );
            var tabNumber = component.get("v.currentTab" );
            if(tabNumber==2){
                component.set("v.attorney", !component.get("v.attorney"));
                //component.find("conField1").set("v.checked", !component.find("conField1").get("v.checked"));
                console.log('d');
            }
            if(tabNumber==3){
                component.set("v.business", !component.get("v.business"));
            }
            if(tabNumber==4){
                component.set("v.witness", !component.get("v.witness"));
            }
            component.set("v.showSubSection", !v);
        }
       catch(e){
            console.error('Error Stack Message for fillSubSections Helper' + e.stack); 
       }
	},
	getAddress : function(component, event) {
        try{
            var getLength = event.getSource().get('v.value').length;
            //console.log("getLength " + getLength);
            console.log("Address_Keyword_Length " + $A.get("$Label.c.Address_Keyword_Length"));
            if(getLength >= $A.get("$Label.c.Address_Keyword_Length")){
                var getAdd = component.get("c.getAutoComplete");
                console.log("getAdd " + getAdd);
                getAdd.setParams({strPrefix : component.get("v.prefix")});
                getAdd.setCallback(this, function(response){
                    var state = response.getState();
                    console.log("state " + state);
                    if(state === "SUCCESS"){
                        console.log("Response :");
                        console.log(JSON.stringify(response.getReturnValue()));
                        component.set('v.lstAddress',response.getReturnValue(
                        ));
                        component.set("v.showResults",true);
                    }
                });
                $A.enqueueAction(getAdd);
            }
            else
                component.set("v.showResults",false);
            
            document.onkeydown = keydown;
            function keydown(event) {
                component.set("v.showResults",false);
            }
            
            document.onclick = click;
            function click(event){
                component.set("v.showResults",false);
            }
          } 
       catch(e){
            console.error('Error Stack Message for getAddress Helper' + e.stack); 
       }
    },        
    selectAddress : function(component, event){
        try{
            var addValue = event.currentTarget.dataset.index;
            var addText = event.currentTarget.dataset.text;
            console.log('address '+ addValue);
            var add = component.get("v.selAddress");
            //JSON.stringify(add);
            console.log('add');
            console.log(add);
            var addlist = addValue.split('_');
            component.set("v.state",addlist[1]);
            component.set("v.city",addlist[0]);
            var addTextSplit = addText.split(',');
            console.log('addTextSplit[0]',addTextSplit[0]);
            component.set("v.prefix", addTextSplit[0]);
            component.set("v.showResults",false);
        }
        catch(e){
            console.error('Error Stack Message for selectAddress Helper' + e.stack); 
       }
    }
   
})