({
	setFormQuestions : function(component, event, helper) {
        try{
            var pageTitle = window.location.href;
            var labelMap = [];
            var json;
            const server = component.find('server');
            const anAction = component.get('c.getFormsJSON');
            server.callServer(anAction,{}, "", 
                $A.getCallback(function(response)  { 
                    labelMap = response;               
                        component.set("v.pageHeader", 'Login');
                        pageTitle = 'login';
                        var json = labelMap['Login'];
                        console.log(JSON.stringify(json));                
                        var section = JSON.parse(json);
                        component.set("v.section", section);
                        component.set("v.totalTabs", section.length);
                }),
                $A.getCallback(function(errors) {
                }),
                false,"");
            }
       catch(e){
            console.error('Error Stack Message for setFormQuestions Helper' + e.stack); 
       }
	},
   
	
    loginUser : function(component, event, helper){
        try{
            
            component.set("v.spinner",true);
            var nmePsw='';
            var usrDetails= component.find('formFieldsRest');
            console.log('usrDetails '+ component.find('formFieldsRest'));
            usrDetails.forEach(function(usrDetails){
            // do stuff...
                console.log('vvv '+usrDetails.get("v.value"));	
                nmePsw=nmePsw+usrDetails.get("v.value")+',';
            })
            console.log('nmePsw '+nmePsw);
            var nmePswArr= nmePsw.split(',');
            /*var usrNme = document.getElementById("{!Component.usrNme}");
            console.log('getElement0 ' + document.getElementsByName("Username").length + usrNme);*/
            const server = component.find('server');
            const anAction = component.get('c.userlogin');
            var resp;
            server.callServer(anAction,{usrnm:nmePswArr[0],pwd:nmePswArr[1]}, "", 
                $A.getCallback(function(response){ 
                    //helper.setFormQuestions(component, event, response);
                  
                    if(response!='Success'){
                        
                           component.set("v.spinner",false);
                          component.set('v.errortext',response);
                            console.log('Response00 '+ response);
                            const toastEvent = $A.get("e.force:showToast");
                            if (typeof toastEvent !== 'undefined') {
                            toastEvent.setParams({
                                title : 'Invalid Username/Password',
                                message : response,
                                type : 'error',
                            });
                            toastEvent.fire();
                        }
                    }
                }),
                
                $A.getCallback(function(errors){
                }),
                false,"");
          
            }
            catch(e){
            	console.error('Error Stack Message for loginUser Helper' + e.stack); 
       		}
    },
    search:function(component, event, helper){
        if(event.which==13){
            console.log("event13");
            this.loginUser(component, event, helper); 
           
        }
        
    },
    clearfields:function(component, event, helper){
    var cmplist=component.find(formFieldsRest);
    if(cmplist[0].get('v.value')==""&&cmplist[1].get('v.value')==""){
    component.set('v.errortext',"");
}
}
   
    
})