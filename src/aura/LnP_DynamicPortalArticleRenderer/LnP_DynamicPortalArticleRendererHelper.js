({
    doInit : function(component,event) {
        
        var action;
        var loggedIn = component.get("v.isLoggedIn");        
        var queryString = decodeURIComponent(window.location.search.substring(1));
        var allParams = queryString.split("&");
        var query_String_values = [];
        if(loggedIn){
            component.set("v.articleTitle","Other Professions")
        }
        for(var i = 0; i<allParams.length; i++){
          var key_value_Pair = allParams[i].split("=");
              var key;
              var value;   
        for(var j = 0; j<key_value_Pair.length; j++){
        
              if(j == 0 ){key = key_value_Pair[0]}if(j==1){ value = key_value_Pair[1]}
               
           }
           query_String_values.push({"key":key,"value":value});
        }
        
        console.log(query_String_values);
        
        if(query_String_values[0]["key"] == 'Help-Topic'){
            
            action = component.get('c.getPortalArticlesByDisplayPage');
            
            action.setParams({"displayPage":  query_String_values[0]["value"]}); 
            
        }else if(query_String_values[0]["key"] =="ArticlesExternalId"){
            
            action = component.get('c.getPortalArticlesByArticleExternalId');
            
            action.setParams({"externalId": query_String_values[0]["value"]});
            
        }else if(component.get("v.articleTitle") != null){
            
            action = component.get('c.getPortalArticlesByArticleTitle');
            
            action.setParams({"articleTitle": component.get("v.articleTitle")});            
            
        }else if(component.get("v.displayPage") != null){
            
            action = component.get('c.getPortalArticlesByDisplayPage');
            
            action.setParams({"displayPage": component.get("v.displayPage")});            
            
        } else{
            
            action = component.get('c.getPortalArticlesByArticleTitle');
            
            action.setParams({"articleTitle": component.get("v.articleTitle")});
        }
        
        
        action.setCallback(this,function(response){
            var state = response.getState();
            if (state === "SUCCESS") {                
                var result = response.getReturnValue();
                
                console.log(JSON.parse(result));
                
                component.set("v.articleList",JSON.parse(result));
            }
            else if (state === "INCOMPLETE") {
                console.log("Unknown error");
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    console.log("Error message: " + JSON.stringify(errors));
                } else {
                    console.log("Unknown error");
                }
            } 
            component.set("v.articlesLoaded",true);
        });
        $A.enqueueAction(action);
    },
    
    handleFooterButtonActionHelper : function(component,event) {
        
        var has_Internal_Article_Redirection = event.currentTarget.hasAttribute('data-Internal_Article_Redirection__c');
        
        var has_url_Redirection = event.currentTarget.hasAttribute('data-article_link_url__c');
        
        if(has_url_Redirection == true){
            
            var url_String = event.currentTarget.getAttribute('data-article_link_url__c');
            
            this.gotoURL(component, event, url_String);
            
        }else if( has_Internal_Article_Redirection == true ){
            
            var article_External_Id = event.currentTarget.getAttribute('data-Internal_Article_Redirection__c');
            
            var redirect_To_Internal_Article =  $A.get("$Label.c.Polaris_Portal_Home")+'?ArticlesExternalId='+article_External_Id;
            
            console.log('redirect_To_Internal_Article --> '+redirect_To_Internal_Article);
            
            this.gotoURL(component, event, redirect_To_Internal_Article);
            
        }else{
            console.log("The respective button has no action");
        }
    },
    handleBodyButtonActionnHelper : function(component,event) {

        var has_Internal_Article_Redirection = event.currentTarget.hasAttribute('data-Internal_Article_Redirection__c');
        
        var has_url_Redirection = event.currentTarget.hasAttribute('data-article_link_url__c');
        
        if(has_url_Redirection == true){
            
            var url_String = event.currentTarget.getAttribute('data-article_link_url__c');
            
            this.gotoURL(component, event, url_String);
            
        }else if( has_Internal_Article_Redirection == true ){
            
            var article_External_Id = event.currentTarget.getAttribute('data-Internal_Article_Redirection__c');
            
            var redirect_To_Internal_Article =  $A.get("$Label.c.Polaris_Portal_Home")+'?ArticlesExternalId='+article_External_Id;
            
            this.gotoURL(component, event, redirect_To_Internal_Article);
            
        }else{
            console.log("The respective button has no action");
        }
    },
    
    gotoURL : function (component, event, urlString) {
        /*var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
          "url": urlString
        });
        urlEvent.fire();*/
        window.open(urlString);
    },
    
    showMore : function(component,event){
        component.set("v.isShowMore",true);
    },
    showLess : function(component,event){
        component.set("v.isShowMore",false);
    }
})