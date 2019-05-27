({
	setJSON : function(component, event, helper) {
		
		var staticTexts = [];
		var ltngOptions = [];		
		try{
                const server = component.find('server');
                const actionStaticTexts = component.get('c.getAllStaticTexts');
                server.callServer(
                    actionStaticTexts,{},"",
                    $A.getCallback(response => {
						staticTexts=response;
						component.set('v.header', staticTexts['header']);
						component.set('v.noAppTypeMessage', staticTexts['noAppTypeMessage']);
						component.set('v.oneAppTypeMessage', staticTexts['oneAppTypeMessage']);
						component.set('v.multiAppTypeMessage', staticTexts['multiAppTypeMessage']);
                        component.set('v.eligibilityquestion',staticTexts['eligibilityquestion']);
                    }),
                    $A.getCallback(errors => {
                    }),
                    false,""
                );
				
                const actionltngOptions = component.get('c.getPicklistOptions');
                server.callServer(
                    actionltngOptions,{field: "Board__c"},"",
                    $A.getCallback(response => {
						console.log('actionltngOptions');
						ltngOptions=response;
						component.set('v.ltngOptions', ltngOptions);
                    }),
                    $A.getCallback(errors => {
                    }),
                    false,""
                );
        } 
        catch(e){
            console.error('Error Stack Message for setJSON Helper' + e.stack);	
        }
        
    },
	/*radioSelectionHelper : function(component, event, helper) {
        var optionIds=event.getSource().get('v.value');
    },*/
	nextQuestionHelper : function(component, event, helper) {
      // 
		component.set("v.showMessage",false);
		component.set("v.showNextButton",false);
        component.set("v.isEligibleQuestions",false);
		var childQuestionId=[];
        var radOpt=[];
        var radioOptions= component.find('radioOption');
		if(Array.isArray(radioOptions)){
			radioOptions.forEach(radioOptions => {
				radOpt.push(radioOptions.get("v.value"));
				})
		}
        /*var res=[];
        var res= component.get("v.radioGrpValue");*/
        var optionId = event.getSource().get("v.name"); 
        //var optionId=event.currentTarget.id;
        var optionValue=event.getParam("value"); 
        //var optionIds=event.getSource().get('v.value');
        //var optionValue=document.getElementById(optionId).value;
        //res.push(optionValue);
        var questionNo = component.get("v.questionNo");	
		/*if((parseInt(optionId)+1)==questionNo){
           component.set("v.questionNo", questionNo+1);
        }*/
		console.log('questionNo ' + component.get("v.questionNo"));
        var questions =component.get("v.questions");
        var questionsLength=questions.length;
        var board=component.get("v.board");
        var licenseType=component.get("v.licenseType");
		
		switch(board){
			case "Cosmetology and Barber Board":
				switch(licenseType){
					case "Cosmetologist":
					if(radOpt[0]=='Yes' || radOpt[3]=='Yes'){
						component.set("v.applicationTypeText","Examination");
					}
					else{
						component.set("v.applicationTypeText","Score Transfer");
					}	
					break;
					
					case "Aesthetician Instructor":
					if(radOpt[0]=='Yes'){
						component.set("v.applicationTypeText","Experience");
					}
					else if(radOpt[1]=='Yes'){ 
						component.set("v.applicationTypeText","Reciprocity");
					}
					else{
						component.set("v.applicationTypeText","Examination");
					}
					break;
					
					case "Nail Technician":
					if(optionValue=='Yes'){
						component.set("v.applicationTypeText","Reciprocity");
					}
					else{
						component.set("v.applicationTypeText","Examination");
					}
					break;
					
					case "Nail Technician Instructor":
					if(optionValue=='Yes'){
						component.set("v.applicationTypeText","Reciprocity");
					}
					else{
						component.set("v.applicationTypeText","Examination");
					}
					break;
					
					case "Master Barber":
					if(optionValue=='Yes'){
						component.set("v.applicationTypeText","Reciprocity");
					}
					else{
						component.set("v.applicationTypeText","Examination");
					}
					break;
					
					case "Barber":
					if(optionValue=='Yes'){
						component.set("v.applicationTypeText","Reciprocity");
					}
					else{
						component.set("v.applicationTypeText","Examination");
					}
					break;
					
					case "Barber Instructor":
					if(optionValue=='Yes'){
						component.set("v.applicationTypeText","Reciprocity");
					}
					else{
						component.set("v.applicationTypeText","Examination");
					}
					break;
					
					case "Aesthetician":
					if(optionValue=='Yes'){
						component.set("v.applicationTypeText","Reciprocity");
					}
					else{
						component.set("v.applicationTypeText","Examination");
					}
					break;
					
					case "Electrologist":
					if(optionValue=='Yes'){
						component.set("v.applicationTypeText","Reciprocity");
					}
					else{
						component.set("v.applicationTypeText","Examination");
					}
					break;
					
					case "Electrologist Instructor":
					if(optionValue=='Yes'){
						component.set("v.applicationTypeText","Reciprocity");
					}
					else{
						component.set("v.applicationTypeText","Examination");
					}
					break;
					
					case "Cosmetology Instructor":
					if(optionValue=='Yes'){
						component.set("v.applicationTypeText","Reciprocity");
					}
					else{
						component.set("v.applicationTypeText","Examination");
					}
					break;
				}
			break;

    		case "Real Estate":
				switch(licenseType){
					case "Salesperson":
					if(optionValue=='Yes'){
						component.set("v.applicationTypeText","Reciprocity");
					}
					else{
						component.set("v.applicationTypeText","Examination");
					}
					break;
					
					case "Broker":
					if(optionValue=='Yes'){
						component.set("v.applicationTypeText","Reciprocity");
					}
					else{
						component.set("v.applicationTypeText","Examination");
					}
					break;
					
					case "Associate Broker":
					if(optionValue=='Yes'){
						component.set("v.applicationTypeText","Reciprocity");
					}
					else{
						component.set("v.applicationTypeText","Examination");
					}
					break;
				}
			break;
			
			case "Dental Board":
				switch(licenseType){
					case "Dental Hygienist":
					if(optionValue=='Yes'){
						component.set("v.applicationTypeText","Reciprocity");
					}
					else{
						component.set("v.applicationTypeText","Examination");
					}
					break;
				}
			break;
			
			case "Geology":
				switch(licenseType){
					case "Geologist":
					if(optionValue=='Yes'){
						component.set("v.applicationTypeText","Reciprocity");
					}
					else{
						component.set("v.applicationTypeText","Examination");
					}
					break;
				}
			break;
			
			case "Occupational Therapy":
				switch(licenseType){
					case "Occupational Therapist (OT)":
					if(optionValue=='Yes'){
						component.set("v.applicationTypeText","Reciprocity");
					}
					else{
						component.set("v.applicationTypeText","Examination");
					}
					break;
					
					case "Occupational Therapy Assistant (OTA)":
					if(optionValue=='Yes'){
						component.set("v.applicationTypeText","Reciprocity");
					}
					else{
						component.set("v.applicationTypeText","Examination");
					}
					break;
				}
			break;
			
			case "Optometry":
				switch(licenseType){
					case "Therapeutic Optometrist":
					if(optionValue=='Yes'){
						component.set("v.applicationTypeText","Reciprocity");
					}
					else{
						component.set("v.applicationTypeText","Internship");
					}
					break;
				}
			break;
			
			case "Manufactured Home Installation":
				switch(licenseType){
					case "Manufactured Home Installer":
					if(optionValue=='Yes'){
						component.set("v.applicationTypeText","Reciprocity");
					}
					else{
						component.set("v.applicationTypeText","Examination");
					}
					break;
				}
			break;
			
			case "Landscape Architecture":
				switch(licenseType){
					case "Landscape Architect":
					if(optionValue=='Yes'){
						component.set("v.applicationTypeText","Reciprocity");
					}
					else{
						component.set("v.applicationTypeText","Examination");
					}
					break;
					
					case "Certificate of Authorization-Land Arch":
					if(radOpt[0]=='Yes'){
						component.set("v.applicationTypeText","Change Of Ownership");
					}
					else if(radOpt[1]=='Yes'){
						component.set("v.applicationTypeText","Re-application");
					}
                    else{
                     	component.set("v.applicationTypeText","Initial Application");       
                    }
					break;
				}
			break;
			
			case "Board of Electrical Examiners":
				if(licenseType=='Master Electrician' || licenseType=='Master Electrician Special-Elevators' || licenseType=='Master Electrician Special-PDS' || licenseType=='Master Electrician Special-HVAC' || licenseType=='Master Electrician Special-Pools' || licenseType=='Master Electrician Special-Refrigeration' || licenseType=='Master Electrician Special-Elec Signs' || licenseType=='Limited Electrician' || licenseType=='Limited Electrician Special-Elevators' || licenseType=='Limited Electrician Special-HVAC' || licenseType=='Limited Electrician Special-Pools'){
					if(optionValue=='Yes'){
						component.set("v.applicationTypeText","Reciprocity");
					}
					else{
						component.set("v.applicationTypeText","Examination");
					}
				}
				switch(licenseType){
					case "Journeyperson Electrician":
					if(radOpt[0]=='Yes'){
						component.set("v.applicationTypeText","Certificate");
					}
					else if(radOpt[1]=='Yes'){
						component.set("v.applicationTypeText","Reciprocity");
					}
                    else{
                     	component.set("v.applicationTypeText","Examination");       
                    }
					break;
				}
			break;

			case "Architects Board":
				switch(licenseType){
					case "Licensed Architect":
					if(radOpt[0]=='Yes'){
						component.set("v.applicationTypeText","Examination");
						this.showHelper(component, event, helper);
					}
					else if(radOpt[1]=='Yes'){
						component.set("v.applicationTypeText","Reciprocity");
						this.showHelper(component, event, helper);
					}
                    else if(radOpt[2]=='Yes'){
                     	component.set("v.applicationTypeText","Direct Application"); 
						this.showHelper(component, event, helper);
                    }
					else{
						if(radOpt[0]=='No' && radOpt[1]=='No' && radOpt[2]=='No'){
							component.set("v.showText",false);
							component.set("v.showMessage", true);
							component.set("v.showNextButton",false);
                            component.set("v.isEligibleQuestions", false);
							component.set("v.applicationTypeText","Please select either of the above question as Yes!"); 
						}
					}
					break;
				}
			break;
			
			case "Funeral Services":
				switch(licenseType){
					case "Funeral Establishment":
					if(radOpt[0]=='Yes'){
						component.set("v.applicationTypeText","Relocation");
					}
					else if(radOpt[1]=='Yes'){
						component.set("v.applicationTypeText","Ownership Change");
					}
                    else{
                     	component.set("v.applicationTypeText","Initial Application");       
                    }
					break;
					
					case "Crematory Establishment":
					if(radOpt[0]=='Yes'){
						component.set("v.applicationTypeText","Relocation");
					}
					else if(radOpt[1]=='Yes'){
						component.set("v.applicationTypeText","Ownership Change");
					}
                    else{
                     	component.set("v.applicationTypeText","Initial Application");       
                    }
					break;
					
					case "Funeral Director":
					if(radOpt[0]=='Yes'){
						component.set("v.applicationTypeText","Internship");
					}
					else if(radOpt[1]=='Yes'){
						component.set("v.applicationTypeText","Reciprocity");
					}
                    else{
                     	component.set("v.applicationTypeText","Reapplication");       
                    }
					break;
				}
			break;


			case "Board of Dietetics/Nutrition":
				switch(licenseType){
					case "Dietitian/Nutritionist":
					if(radOpt[0]=='Yes'){
						component.set("v.applicationTypeText","CDR Registration");
					}
					else if(radOpt[1]=='Yes'){
						component.set("v.applicationTypeText","Examination");
					}
					else {
						component.set("v.applicationTypeText","Reciprocity");
					}	
					break;
				}
			break;

			case "Board of Pharmacy":
				switch(licenseType){
					case "Pharmacist":
					if(optionValue=='Yes'){
							component.set("v.applicationTypeText","Score Transfer");
						}
					else{
						component.set("v.applicationTypeText","Examination");
					}
					break;
				}
			break;
		}	
        //component.set("v.isEligibleQuestions", false);
		if(((parseInt(optionId)+1)==questionNo && (component.get("v.showMessage")==false && component.get("v.showNextButton")==false))){
           component.set("v.questionNo", questionNo+1);
           component.set("v.isEligibleQuestions", false);
           return;
        }
        
        var eligiblity = component.get("v.hasEligibilityQuestions");
        var applicationTypeText = component.get("v.applicationTypeText");
   
        console.log("applicationTypeText"+ applicationTypeText);
        if(questionNo==questionsLength || questionNo==(questionsLength+1)){
            console.log('showMessage ');
            component.set("v.showNextButton", true);
            component.set("v.showMessage", true);
            if(eligiblity == true){
                component.set("v.isEligibleQuestions", true);
                component.set("v.showNextButton", false);
               // this.showEligibilityQuestionHelper(component, event, helper);
            }
        } else if(optionValue == 'Yes' && questionNo!=questionsLength) {
            component.set("v.isEligibleQuestions", true);
        }
        //component.set("v.isEligibleQuestions", true);
        if(component.get("v.isEligibleQuestions") == true){
            this.showEligibilityQuestionHelper(component, event, helper);
        }

    },
        showApplicationHelper : function(component, event, helper) {
        var board=component.get("v.board");
        var licenseType=component.get("v.licenseType");
		var applicationType='';
		var whichButton = event.getSource().getLocalId();
		if(whichButton=='button1'){
			applicationType=component.get("v.applicationTypeNotNullText");
		}
		else{
			applicationType=component.get("v.applicationTypeText");
		}
        component.set("v.showApplicationFields",true);
        component.set("v.showQuestion",false);
        component.set("v.showTopDiv",false);
        
        sessionStorage.setItem("board", board);
        sessionStorage.setItem("licenseType", licenseType);
        sessionStorage.setItem("applicationType", applicationType);
        var applicationId;
		try{
                const server = component.find('server');
                const startAnApplication = component.get('c.startAnApplication');
                server.callServer(
                    startAnApplication,{board: board,
										licenseType: licenseType,
										applicationType: applicationType},"",
                    $A.getCallback(response => {
						applicationId=response;
						sessionStorage.setItem("applicationId", applicationId);
						console.log('applicationId '+applicationId);
						var accURL=window.location.href;
						var accUrlShort = accURL.slice(0,accURL.lastIndexOf("/"));
						accUrlShort = accUrlShort+"/apply-for-license";//+ applicationId;
						console.log('URL of a particular account: ' + accUrlShort);
						//var url='https://dedpr--licensedev--sitepreview.cs32.force.com/delawareLnP/s/apply-for-license?id='+applicationId;
							var urlEvent = $A.get("e.force:navigateToURL");
							urlEvent.setParams({
								"url": accUrlShort
							});
							urlEvent.fire();
						}),
						$A.getCallback(errors => {
						}),
						false,""
					);
        } 
        catch(e){
            console.error('Error Stack Message for showApplication Helper' + e.stack);	
        }
		
		
	   /*var startAnApplication = component.get("c.startAnApplication");
			startAnApplication.setParams({
			"board": board,
			"licenseType": licenseType,
			"applicationType": applicationType
		});
		startAnApplication.setCallback(this, function(actionResult){
			var state = actionResult.getState();
			console.log('state ' + state);
			if (state === "SUCCESS"){
				console.log('showApplicationv ');
				var result = actionResult.getReturnValue();
				applicationId=result;
				sessionStorage.setItem("applicationId", applicationId);
				console.log('applicationId'+applicationId);
				//console.log('window.location.href '+window.location.href + "/" + applicationId);
				//accURL = URL.getSalesforceBaseUrl().toExternalForm() + '/' + applicationId.Id;
				//console.log('URL of a particular account: ' + accURL);*/
				//sessionStorage.setItem("applicationId", "a2Sr00000004qan");
				/*var accURL=window.location.href;
//                +"/apply-for-license/"+ applicationId;
				var accUrlShort = accURL.slice(0,accURL.lastIndexOf("/"));
				accUrlShort = accUrlShort+"/apply-for-license";//+ applicationId;
				console.log('URL of a particular account: ' + accUrlShort);
				//var url='https://dedpr--licensedev--sitepreview.cs32.force.com/delawareLnP/s/apply-for-license?id='+applicationId;
					var urlEvent = $A.get("e.force:navigateToURL");
					urlEvent.setParams({
						"url": accUrlShort
					});
					urlEvent.fire();
					 }            
					}); 
				$A.enqueueAction(startAnApplication);*/
        
    },
        checkEligibilityHelper : function(component, event, helper) {
        console.log("inside checkEligibility");
        component.set("v.showNextButton",false);
        //console.log("fsdfdg"+ radioOptions);
        var radOpt=[];
        var radioOptions= component.find("eligibilityRadioOption");
        console.log("fsdfdg"+ radioOptions) ;       
		if(Array.isArray(radioOptions)){
			radioOptions.forEach(radioOptions => {
				radOpt.push(radioOptions.get("v.value"));
                console.log("fsdfdg"+ radioOptions.get("v.value"));
				})
		}
        for(var i =0; i< radOpt.length; i++){
               // console.log( "radOpt[i+1]",radOtp[i+1]);
                if(radOpt[i] == "No" || radOpt[i] == undefined){
                    component.set("v.showNextButton",false);
                    component.set("v.showprceedmessage",true);
                    break;
                } else {
                    component.set("v.showNextButton",true);
                    component.set("v.showprceedmessage",false);
                }
            }        

       
    }
})