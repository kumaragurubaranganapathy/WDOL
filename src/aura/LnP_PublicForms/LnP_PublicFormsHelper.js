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
                        component.set("v.pageHeader", 'Login');
                        pageTitle = 'login';
                        var json = labelMap['Login'];
                        console.log(JSON.stringify(json));                
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
   
	
    loginUser : function(component, event, helper){
        try{
            var nmePsw='';
            var usrDetails= component.find('formFieldsRest');
            console.log('usrDetails '+ component.find('formFieldsRest'));
            usrDetails.forEach(usrDetails => {
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
            server.callServer(anAction,{usrnm:nmePswArr[0],pwd:nmePswArr[1]}, "", 
                $A.getCallback(response => { 
                    //helper.setFormQuestions(component, event, response);
                    
                    if(response!='Success'){	
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
                $A.getCallback(errors => {
                }),
                false,"");
            }
            catch(e){
            	console.error('Error Stack Message for loginUser Helper' + e.stack); 
       		}
    }
    
})