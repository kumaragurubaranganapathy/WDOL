({
    setData : function(component, event, helper) {
        var recordList =[];
        var sectionName = component.get('v.sectionName');
        var sectionList = component.get('v.sectionList');
        sectionList = sectionList.labelFieldsMap;
        var strArray = [];
        for(var i=0;i<sectionList.length;i++)
        {
            
            if(sectionList[i].questionSectionClass== sectionName && sectionList[i].fieldObjName == 'Endorsement__c' && sectionList[i].fieldType == 'Picklist')
            {                       
                recordList.push({"fieldName": sectionList[i].fieldAPIName,"fieldType":sectionList[i].fieldType ,"value":sectionList[i].value,"fieldValueOptions" :sectionList[i].fieldValueOptions,"label": sectionList[i].label});
                component.set("v.SelectedMultiValues",sectionList[i].multiValues);
            }                    
        }
        var strData = component.get("v.SelectedMultiValues");
        
        if(strData.length>0)
        {
            for(var i=0;i<strData.length;i++)
            {            
                strArray.push({"proname":strData[i].split(",")[0],"effdate":strData[i].split(",")[1],"number":i,"pDetails":strData[i].split(",")[2]});          //strArrayAdj.push(strData[i].split(",")[1]);              
                
            }   
            
            component.set("v.ProviderList",strArray);
        }
        component.set('v.recordList', recordList);
    },
    
    setSelectedValue : function(component, event, helper) {
        debugger;
        var sectionName = component.get('v.sectionName');
        var sectionList = component.get('v.sectionList');
        var str = '';
        var strArray = [];
                    
        str = component.find("picklist").get("v.value") + ','+ component.get("v.effectiveDate")+','+component.get("v.pDetails");
        sectionList = sectionList.labelFieldsMap;
        component.set("v.selectionString",strArray);
        
        for(var i=0;i<sectionList.length;i++)
        {
            
            if(sectionList[i].questionSectionClass== sectionName && sectionList[i].fieldObjName == 'Endorsement__c' && sectionList[i].fieldType == 'Picklist' )
            {  
                sectionList[i].multiValues.push(str);         
                //component.set("v.selectionString",sectionList[i].multiValues);
            }
            
        }
        
        
        var strData = component.get("v.selectionString");
        strArray = component.get("v.ProviderList");
        var count = 0;
        for(var i=0;i<strArray.length;i++)
        {
            count++;
        }
        if(strArray.length>=0)
        {
            strArray.push({"proname":component.find("picklist").get("v.value"),"effdate":component.get("v.effectiveDate"),"number":count,"pDetails":component.get("v.pDetails")});  
        }
        
        
        /*for(var i=0;i<strData.length;i++)
        {            
            strArray.push({"proname":strData[i].split(",")[0],"effdate":strData[i].split(",")[1]});          //strArrayAdj.push(strData[i].split(",")[1]);              
            
        }   */
        
        component.set("v.ProviderList",strArray);
        console.log("v.ProviderList",component.get("v.ProviderList"));
    },
    removeHelper : function(component, event, helper) {
        var arrayList = component.get("v.ProviderList");
        var sectionName = component.get('v.sectionName');
        var removeNumber = event.getSource().get("v.value");       
         arrayList.splice(removeNumber,1);
        component.set("v.ProviderList",arrayList);
         var sectionList = component.get('v.sectionList');
        //sectionList = sectionList.labelFieldsMap;
       
        for(var i=0;i<sectionList.labelFieldsMap.length;i++)
        {            
            
            if(sectionList.labelFieldsMap[i].questionSectionClass == sectionName && sectionList.labelFieldsMap[i].fieldObjName == 'Endorsement__c' && sectionList.labelFieldsMap[i].fieldType == 'Picklist' 
               && sectionList.labelFieldsMap[i].multiValues.length !=0)
            {  
                sectionList.labelFieldsMap[i].multiValues.splice(removeNumber,1);
                
            }
            
        }
        component.set('v.sectionList',sectionList);
        
    },
})