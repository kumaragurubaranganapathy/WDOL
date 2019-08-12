({
    doInit : function(component,event) {
        var ratingValues = [
            {
                "index":1,                 
                
            },
            {	
                "index":2,                          
            },
            {
                "index":3,                
            },
            {
                "index":4,                
            },
            {	
                "index":5,             
            }
        ];
        component.set("v.ratingValues",ratingValues);
    }, 
    starClick : function(component,event){
        var target = event.target;
        var index = target.dataset.index; 
        
        /* var fullStarArray = document.querySelectorAll(".full");
        var emptyStarArray = document.querySelectorAll(".empty");
        var halfStarArray = document.querySelectorAll(".half");	  */  
        var fullStarArray = component.find("full-star");
        var emptyStarArray = component.find("empty-star");
        var halfStarArray = component.find("half-star"); 
        var className = target.className;
        var value = 0;
        if(className==="empty"){
            var halfId = 'half'+ index;
            var emptyId = 'empty'+ index;
            
            var halfStar = document.querySelector("#"+halfId);
            var emptyStar = document.querySelector("#"+emptyId);
            halfStarArray.forEach(function(element){
                var elem = element.getElement();
                if(elem.dataset.index===index)
                    $A.util.removeClass(elem, 'slds-hide'); 
                else 
                    $A.util.addClass(elem, 'slds-hide'); 
            });           
            
            fullStarArray.forEach(function(element){
                var elem = element.getElement();
                if(elem.dataset.index<index)
                    $A.util.removeClass(elem, 'slds-hide');                     
            });
            
            emptyStarArray.forEach(function(element){
                var elem = element.getElement();
                if(elem.dataset.index<=index)
                    $A.util.addClass(elem, 'slds-hide');                         
            });
            value = index-0.5;
        }
        if(className==="half"){
            var halfId = 'half'+ index;
            var fullId = 'full'+ index;
            
            var halfStar = document.querySelector("#"+halfId);
            var fullStar = document.querySelector("#"+fullId);
            $A.util.removeClass(fullStar, 'slds-hide');
            $A.util.addClass(halfStar, 'slds-hide');            
            value = index;     
        }
        if(className==="full"){
            var full = 'full'+ index;
            var emptyId = 'empty'+ index;
            
            /*var halfStar = document.querySelector("#"+halfId);
            var emptyStar = document.querySelector("#"+emptyId);   */                     
            
            fullStarArray.forEach(function(element){
                var elem = element.getElement();
                if(elem.dataset.index>=index)
                    $A.util.addClass(elem, 'slds-hide');                     
            });
            halfStarArray.forEach(function(element){
                var elem = element.getElement();
                if(elem.dataset.index>index)
                    $A.util.addClass(elem, 'slds-hide');  
                if(elem.dataset.index===index)
                    $A.util.removeClass(elem, 'slds-hide');  
            });
            emptyStarArray.forEach(function(element){
                var elem = element.getElement();
                if(elem.dataset.index>index)
                    $A.util.removeClass(elem, 'slds-hide');                         
            });
            
            value = index-0.5; 
            
        }
        component.set("v.starValue",value);
        console.log('star value==' + component.get('v.starValue'));
        var feedback = component.get("v.userfeedback");
        feedback.Grade__c = String(component.get('v.starValue'));
        console.log('feedback.Grade__c===' + feedback.Grade__c);
        component.set("v.userfeedback", feedback);
    },
    
    saveFeedbackForm : function(component, event){
        console.log('FeedBack value==' + JSON.stringify(component.get("v.userfeedback")));
        console.log('Create Record...');
        var userfeedback = component.get("v.userfeedback");
        var action = component.get("c.createRecord");
        action.setParams({
            userfeedback : userfeedback
        });
        
        action.setCallback(this,function(a){
            var state = a.getState();  
            if(state =="SUCCESS"){
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "type": "Success",
                    "message": "The Feedback has been submitted!",
                });
                toastEvent.fire();
                var newUserfeedback = {'sObjectType':'User_Feedback__c',
                                       'Comments__c':'',
                                       'Grade__c':''
                                      }
                component.set("v.userfeedback",newUserfeedback);
				var sPageURL = document.URL;
                var isbusiness;
                if(sPageURL.includes('isBizLic=')){
                    var sURLVariables = sPageURL.split('=');
                    isbusiness= sURLVariables[1];
                }
                var str = isbusiness ? '/business' : '/newdashboard';
                var urlEvent = $A.get("e.force:navigateToURL");
                urlEvent.setParams({
                    "url": str
                });
                urlEvent.fire();
            }
            
        });
        $A.enqueueAction(action);
        //window.location.href='/lightningwashington/s/newdashboard';
        
    },
    skipFeedback : function(component,event) {
		var sPageURL = document.URL;
        var isbusiness;
        if(sPageURL.includes('isBizLic=')){
        	var sURLVariables = sPageURL.split('=');
        	isbusiness= sURLVariables[1];
        }
        var str =  isbusiness ? '/business' : '/newdashboard';
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url": str
        });
        urlEvent.fire();
    }
})