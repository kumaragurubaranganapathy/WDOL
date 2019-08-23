({
	createAccountContact : function(component, event, helper) {
		
	},
    getpattern:function(component, event, helper){
        console.log("in getpattern");
        var numbers=event.getSource().get('v.value'); 
        var testobj=component.get('v.fieldsList');
        var fieldname=event.getSource().get('v.fieldName'); 
        if(fieldname == "Social_Security_Number_Encrypted__c"){
            component.set("v.isSSNchanged", true);
        }
        for(var j=0;j<testobj.length;j++){
            if(testobj[j].patternText!=undefined&&testobj[j].apiname==fieldname){
                var patternArray=testobj[j].patternText.split(",")
                
                var strlength=patternArray[0];
                
                var sliceIndex=patternArray[1];
                var intervalIndex=patternArray[2];
                var delimiter=patternArray[3];
                var endIndex=(+sliceIndex)+(+intervalIndex);
                if(numbers.length==strlength){
                    var trimmedNo = ('' + numbers).replace(/\D/g, '');
                    var phone = trimmedNo.slice(0, sliceIndex)+delimiter+trimmedNo.slice(sliceIndex,endIndex) + delimiter + trimmedNo.slice(endIndex);
                    event.getSource().set('v.value',phone);    
                }
                else {
                    return numbers;
                }
            }
            else if(testobj[j].apiname=="Birthdate"){
                console.log("found birthday");
               
            }
            
        }
    }
})