({
    
	handleClick : function(component, event) {
		component.set("v.isOpen",true);
	},
    
    closeModel : function(component,event){
     component.set("v.isOpen",false);
	},
    
    handleSuccess : function(component,event,helper){
        
      var accntId = event.getParams().response.id;
        component.set("v.accountId",accntId);
        helper.addAccountContact(component,event,helper);
        
    },
    fieldchange:function(component,event,helper){
       
      var numbers=event.getSource().get('v.value');
       var fieldname=event.getSource().get('v.fieldName');
      //var fieldlist=component.get('v.fields');
      //  for(var i=0;i<fieldlist.length;i++){
        if(fieldname=="Phone_Primary_Contact__c"||fieldname=="Business_Phone__c"){
               if(numbers.length==10){
                var trimmedNo = ('' + numbers).replace(/\D/g, '');
                    var phone = trimmedNo.slice(0, 3)+'.'+trimmedNo.slice(3,6) + '.' + trimmedNo.slice(6);
                    event.getSource().set('v.value',phone); 
            }
        }
          if(fieldname=="UBI_Number__c"){
               if(numbers.length==9){
                var trimmedNo = ('' + numbers).replace(/\D/g, '');
                    var phone = trimmedNo.slice(0, 3)+'.'+trimmedNo.slice(3,6) + '.' + trimmedNo.slice(6);
                    event.getSource().set('v.value',phone); 
            }
          }
        
    }
})