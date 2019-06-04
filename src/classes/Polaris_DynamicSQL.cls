public class Polaris_DynamicSQL {
    public  String FieldName ;
    public  String Operator ;
    public  String FieldValue;
    
    public String setSOQLCriteria() {
        return fieldName + ' '  + Operator + ' \'' + FieldValue + '\'';
    }
    
    public Boolean IsFieldValueGiven() {
        return FieldValue != null && FieldValue != '';
    }
    public static String generateWhereQuery(List<Polaris_DynamicSQL> criterias) {
        List<String> and_conditions = new List<String>();
        for(Polaris_DynamicSQL single_criteria : criterias) {
            if (single_criteria.IsFieldValueGiven()) {
                and_conditions.add(single_criteria.setSOQLCriteria());
            }
        }
        return String.join(and_conditions, ' AND ');
    }
    
    public static String generateORQuery(List<Polaris_DynamicSQL> ORCriterias) {
        List<String> or_conditions = new List<String>();
        for(Polaris_DynamicSQL single_criteria : ORCriterias) {
            if (single_criteria.IsFieldValueGiven()) {
                or_conditions.add(single_criteria.setSOQLCriteria());
            }
        }
        String sFinal;
        if(!or_conditions.isEmpty())
        sFinal = '('+String.join(or_conditions, ' OR ')+')';
        return sFinal;
    }
    
    @AuraEnabled
    public static List<SObject> generateQueryLimit(String objectName, List<String> lstFieldsName, Map<String,String> mapValues,Integer limitvalue){
        system.debug('inside');
        system.debug('mapValues'+mapValues);
        List<Polaris_DynamicSQL> creterias = new  List<Polaris_DynamicSQL> ();
        for (String attributeName : mapValues.keyset()) {
            Polaris_DynamicSQL sqlObj = new Polaris_DynamicSQL();
            sqlObj.FieldName = attributeName;
            sqlObj.FieldValue = mapValues.get(attributeName);
            sqlObj.Operator = '=';
            creterias.add(sqlObj);
        }
        //system.debug('criterias'+criterias);
        String whereClause = generateWhereQuery(creterias);
        String fieldNames  = String.join(lstFieldsName, ' ,');        
        String query = 'SELECT  '+fieldNames+'  FROM  '+objectName+'  WHERE  '+whereClause+''+' limit '+limitvalue;
        SYSTEM.debug('QUERY'+query);
        List<SObject>  lstRecords  = new List<SObject> () ;
        //List<SObject>  lstRecords  = new List<SObject> () ;
        lstRecords = Utilityclass_withsharing.queryRecords(query); 
        return   lstRecords; 
    }
    
    @AuraEnabled
    public static List<SObject> generateQueryWithGenericOR(String objectName, List<String> lstFieldsName, 
    Map<String,String> mapValues, Map<String, String> mapORValues, Boolean bIsStatusIncluded){
        system.debug('inside');
        system.debug('mapValues'+mapValues);
        List<Polaris_DynamicSQL> creterias = new  List<Polaris_DynamicSQL> ();
        for (String attributeName : mapValues.keyset()) {
            Polaris_DynamicSQL sqlObj = new Polaris_DynamicSQL();
            sqlObj.FieldName = attributeName;
            sqlObj.FieldValue = mapValues.get(attributeName);
            sqlObj.Operator = '=';
            creterias.add(sqlObj);
        }
        List<Polaris_DynamicSQL> orcreterias = new  List<Polaris_DynamicSQL> ();
        for (String attributeName : mapORValues.keyset()) {
            Polaris_DynamicSQL sqlObj = new Polaris_DynamicSQL();
            sqlObj.FieldName = attributeName;
            sqlObj.FieldValue = mapORValues.get(attributeName);
            sqlObj.Operator = '=';
            orcreterias.add(sqlObj);
        }
        Map<String, SObject> mapAllRec = new Map<String, SObject>();
        //system.debug('criterias'+criterias);
        String whereClause = '';
        if(orcreterias <> null && !orcreterias.isEmpty())
        whereClause = generateORQuery(orcreterias);
        if(creterias <> null && !creterias.isEmpty())
        whereClause += 'and '+ generateWhereQuery(creterias);
        String fieldNames  = String.join(lstFieldsName, ' ,');
        String query = 'SELECT  '+fieldNames+'  FROM  '+objectName+'  WHERE  '+whereClause+'';
        SYSTEM.debug('QUERY'+query);
        List<SObject>  lstRecords  = new List<SObject> () ;
        //List<SObject>  lstRecords  = new List<SObject> () ;
        lstRecords = Utilityclass_withsharing.queryRecords(query); 
        
        if(!bIsStatusIncluded && !lstRecords.isEmpty())
        {
            List<SObject>  lstTempRecords = new List<SObject>();
            Set<SObject> setAllRec = new Set<SObject>();
            lstTempRecords.addAll(lstRecords);
            lstRecords = new List<SObject>();
            if(objectName == 'MUSW__License2__c')
            {
                List<MUSW__License2__c> lstSSData = (List<MUSW__License2__c>)lstTempRecords;
                for(MUSW__License2__c oData : lstSSData)
                {
                    if(Label.SearchStatusFilter.contains(oData.MUSW__Status__c))
                    lstRecords.add(oData);
                }
            }
            else if(objectName == 'LnP_Parcel__c')
            {
                List<LnP_Parcel__c> lstSSData = (List<LnP_Parcel__c>)lstTempRecords;
                for(LnP_Parcel__c oData : lstSSData)
                {
                    if(Label.SearchStatusFilter.contains(oData.License__r.MUSW__Status__c))
                    {
                        if(oData.License__c <> null && oData.License__r.Name <> null)
                        {
                            if(mapAllRec <> null && mapAllRec.get(oData.License__r.Name) <> null)
                            {
                            }
                            else
                            {
                                mapAllRec.put(oData.License__r.Name, oData);
                            }
                        }
                    }
                }
            }
            if(mapAllRec <> null && !mapAllRec.isEmpty())
            lstRecords.addAll(mapAllRec.values());
        }
        else if(bIsStatusIncluded)
        {
            if(objectName == 'LnP_Parcel__c')
            {
                List<SObject>  lstTempRecords = new List<SObject>();
                lstTempRecords.addAll(lstRecords);
                lstRecords = new List<SObject>();
                List<LnP_Parcel__c> lstSSData = (List<LnP_Parcel__c>)lstTempRecords;
                for(LnP_Parcel__c oData : lstSSData)
                {
                    if(Label.SearchStatusFilter.contains(oData.License__r.MUSW__Status__c))
                    {
                        if(oData.License__c <> null && oData.License__r.Name <> null)
                        {
                            if(mapAllRec <> null && mapAllRec.get(oData.License__r.Name) <> null)
                            {
                            }
                            else
                            {
                                mapAllRec.put(oData.License__r.Name, oData);
                            }
                        }
                    }
                }
            }
            if(mapAllRec <> null && !mapAllRec.isEmpty())
            lstRecords.addAll(mapAllRec.values());
        }
            
            
        return   lstRecords; 
    } 
    
    @AuraEnabled
    public static List<SObject> generateQueryWithOR(String objectName, List<String> lstFieldsName, 
    Map<String,String> mapValues, Boolean bIsStatusIncluded){
        system.debug('inside');
        system.debug('mapValues'+mapValues);
        List<Polaris_DynamicSQL> creterias = new  List<Polaris_DynamicSQL> ();
        for (String attributeName : mapValues.keyset()) {
            Polaris_DynamicSQL sqlObj = new Polaris_DynamicSQL();
            sqlObj.FieldName = attributeName;
            sqlObj.FieldValue = mapValues.get(attributeName);
            sqlObj.Operator = '=';
            creterias.add(sqlObj);
        }
        //system.debug('criterias'+criterias);
        String whereClause = generateWhereQuery(creterias);
        Map<String, SObject> mapAllRec = new Map<String, SObject>();
        String fieldNames  = String.join(lstFieldsName, ' ,');
        String query = 'SELECT  '+fieldNames+'  FROM  '+objectName+'  WHERE  '+whereClause+'';
        SYSTEM.debug('QUERY'+query);
        List<SObject>  lstRecords  = new List<SObject> () ;
        //List<SObject>  lstRecords  = new List<SObject> () ;
        lstRecords = Utilityclass_withsharing.queryRecords(query); 
        
        if(!bIsStatusIncluded && !lstRecords.isEmpty())
        {
            List<SObject>  lstTempRecords = new List<SObject>();
            lstTempRecords.addAll(lstRecords);
            lstRecords = new List<SObject>();
            if(objectName == 'MUSW__License2__c')
            {
                List<MUSW__License2__c> lstSSData = (List<MUSW__License2__c>)lstTempRecords;
                for(MUSW__License2__c oData : lstSSData)
                {
                    if(Label.SearchStatusFilter.contains(oData.MUSW__Status__c))
                    lstRecords.add(oData);
                }
            }
            else if(objectName == 'LnP_Parcel__c')
            {
                List<LnP_Parcel__c> lstSSData = (List<LnP_Parcel__c>)lstTempRecords;
                for(LnP_Parcel__c oData : lstSSData)
                {
                    if(Label.SearchStatusFilter.contains(oData.License__r.MUSW__Status__c))
                    {
                        if(oData.License__c <> null && oData.License__r.Name <> null)
                        {
                            if(mapAllRec <> null && mapAllRec.get(oData.License__r.Name) <> null)
                            {
                            }
                            else
                            {
                                mapAllRec.put(oData.License__r.Name, oData);
                            }
                        }
                    }
                }
            }
            if(mapAllRec <> null && !mapAllRec.isEmpty())
            lstRecords.addAll(mapAllRec.values());
        }
        else if(bIsStatusIncluded)
        {
            if(objectName == 'LnP_Parcel__c')
            {
                List<SObject>  lstTempRecords = new List<SObject>();
                lstTempRecords.addAll(lstRecords);
                lstRecords = new List<SObject>();
                List<LnP_Parcel__c> lstSSData = (List<LnP_Parcel__c>)lstTempRecords;
                for(LnP_Parcel__c oData : lstSSData)
                {
                    if(Label.SearchStatusFilter.contains(oData.License__r.MUSW__Status__c))
                    {
                        if(oData.License__c <> null && oData.License__r.Name <> null)
                        {
                            if(mapAllRec <> null && mapAllRec.get(oData.License__r.Name) <> null)
                            {
                            }
                            else
                            {
                                mapAllRec.put(oData.License__r.Name, oData);
                            }
                        }
                    }
                }
                if(mapAllRec <> null && !mapAllRec.isEmpty())
                lstRecords.addAll(mapAllRec.values());
            }
            
        }
        return   lstRecords; 
    } 
    
    @AuraEnabled
    public static List<SObject> generateQuery(String objectName, List<String> lstFieldsName, Map<String,String> mapValues){
        system.debug('inside');
        system.debug('mapValues'+mapValues);
        List<Polaris_DynamicSQL> creterias = new  List<Polaris_DynamicSQL> ();
        for (String attributeName : mapValues.keyset()) {
            Polaris_DynamicSQL sqlObj = new Polaris_DynamicSQL();
            sqlObj.FieldName = attributeName;
            sqlObj.FieldValue = mapValues.get(attributeName);
            sqlObj.Operator = '=';
            creterias.add(sqlObj);
        }
        system.debug('criterias'+creterias);
        String whereClause = generateWhereQuery(creterias);
        String fieldNames  = String.join(lstFieldsName, ' ,');
        String query = 'SELECT  '+fieldNames+'  FROM  '+objectName+'  WHERE  '+whereClause+'';
        SYSTEM.debug('QUERY'+query);
        List<SObject>  lstRecords  = new List<SObject> () ;
        //List<SObject>  lstRecords  = new List<SObject> () ;
        lstRecords = Utilityclass_withsharing.queryRecords(query); 
        system.debug('lstRecords----'+lstRecords);
        return   lstRecords; 
    } 
    
    @AuraEnabled
    public static Map<String, List<String>> getPicklistOptions(sObject sObj, String conField, String depField){	
        Map<String, List<String>> mapConDep = new Map<String, List<String>>();
        mapConDep = LnP_dependentPicklist_UpdateCtrl.getDependentMap(sObj, conField, depField);
        system.debug('mapConDepJSON ' + JSON.serialize(mapConDep));
        return mapConDep;
    }
    @AuraEnabled
    public static List<String> getPicklistFieldValues(String objectName, String pickListFieldName){
        List<String> picklistValues = new List<String>();
        SObjectType objectType = Schema.getGlobalDescribe().get(objectName);
        List<Schema.PicklistEntry> pick_list_values = objectType.getDescribe()
            .fields.getMap()
            .get(pickListFieldName)
            .getDescribe().getPickListValues();
        for (Schema.PicklistEntry aPickListValue : pick_list_values) {                   
            picklistValues.add(aPickListValue.getValue()); 
        }
        return picklistValues;
    }
    @AuraEnabled
    public static Map<String,List<String>> fetchMetaDataValues(){
         Map<String, List<String>> PicklistValueMap = new Map <String, List<String>>();
         List<Course_Catalog_Search__mdt> lstValues = new List<Course_Catalog_Search__mdt>();
         
        lstValues = [SELECT License_Type__c,Program_Type__c FROM Course_Catalog_Search__mdt];
        for(Course_Catalog_Search__mdt val : lstValues ){
            List<String> LicenseTypeVal = new List<String>();
			
            if(val.License_Type__c != ''){
               LicenseTypeVal = val.License_Type__c.split(';'); 
                system.debug('LicenseTypeVal==='+LicenseTypeVal);
            }
            PicklistValueMap.put(val.Program_Type__c,LicenseTypeVal);
            system.debug('PicklistValueMap---'+PicklistValueMap);
        }
         return PicklistValueMap;
    }
    
    @AuraEnabled
    public static List<SObject> generateQueryWithORparent(String objectName, List<String> lstFieldsName, 
    Map<String,String> mapValues, Boolean bIsStatusIncluded){
        system.debug('inside');
        system.debug('mapValues'+mapValues);
        List<Polaris_DynamicSQL> creterias = new  List<Polaris_DynamicSQL> ();
        for (String attributeName : mapValues.keyset()) {
            Polaris_DynamicSQL sqlObj = new Polaris_DynamicSQL();
            sqlObj.FieldName = attributeName;
            sqlObj.FieldValue = mapValues.get(attributeName);
            sqlObj.Operator = '=';
            creterias.add(sqlObj);
        }
        //system.debug('criterias'+criterias);
        String whereClause = generateWhereQuery(creterias);
        Map<String, SObject> mapAllRec = new Map<String, SObject>();
        String fieldNames  = String.join(lstFieldsName, ' ,');
        String query = 'SELECT  '+fieldNames+'  FROM  '+objectName+'  WHERE  '+whereClause+'';
        SYSTEM.debug('QUERY'+query);
        List<SObject>  lstRecords  = new List<SObject> () ;
        //List<SObject>  lstRecords  = new List<SObject> () ;
        lstRecords = Utilityclass_withsharing.queryRecords(query); 
        
        if(!bIsStatusIncluded && !lstRecords.isEmpty())
        {
            List<SObject>  lstTempRecords = new List<SObject>();
            lstTempRecords.addAll(lstRecords);
            lstRecords = new List<SObject>();
            if(objectName == 'MUSW__License2__c')
            {
                List<MUSW__License2__c> lstSSData = (List<MUSW__License2__c>)lstTempRecords;
                for(MUSW__License2__c oData : lstSSData)
                {
                    if(Label.SearchStatusFilter.contains(oData.MUSW__Status__c))
                    lstRecords.add(oData);
                }
            }
            else if(objectName == 'LnP_Parcel__c')
            {
                List<LnP_Parcel__c> lstSSData = (List<LnP_Parcel__c>)lstTempRecords;
                for(LnP_Parcel__c oData : lstSSData)
                {
                    if(Label.SearchStatusFilter.contains(oData.License__r.Related_License__r.MUSW__Status__c))
                    {
                        if(oData.License__c <> null && oData.License__r.Related_License__r.Name <> null)
                        {
                            if(mapAllRec <> null && mapAllRec.get(oData.License__r.Related_License__r.Name) <> null)
                            {
                            }
                            else
                            {
                                mapAllRec.put(oData.License__r.Related_License__r.Name, oData);
                            }
                        }
                    }
                }
            }
            if(mapAllRec <> null && !mapAllRec.isEmpty())
            lstRecords.addAll(mapAllRec.values());
        }
        else if(bIsStatusIncluded)
        {
            if(objectName == 'LnP_Parcel__c')
            {
                List<SObject>  lstTempRecords = new List<SObject>();
                lstTempRecords.addAll(lstRecords);
                lstRecords = new List<SObject>();
                List<LnP_Parcel__c> lstSSData = (List<LnP_Parcel__c>)lstTempRecords;
                for(LnP_Parcel__c oData : lstSSData)
                {
                    if(Label.SearchStatusFilter.contains(oData.License__r.Related_License__r.MUSW__Status__c))
                    {
                        if(oData.License__c <> null && oData.License__r.Related_License__r.Name <> null)
                        {
                            if(mapAllRec <> null && mapAllRec.get(oData.License__r.Related_License__r.Name) <> null)
                            {
                            }
                            else
                            {
                                mapAllRec.put(oData.License__r.Related_License__r.Name, oData);
                            }
                        }
                    }
                }
                if(mapAllRec <> null && !mapAllRec.isEmpty())
                lstRecords.addAll(mapAllRec.values());
            }
            
        }
        return   lstRecords; 
    }
}