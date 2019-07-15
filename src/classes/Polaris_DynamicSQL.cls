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
    public static String addComplaint()
    {
        MUSW__Complaint2__c complaint = new MUSW__Complaint2__c();
        complaint.MUSW__Type__c = 'Other';
        complaint.MUSW__Status__c = 'Draft';
        complaint.Name = 'System Number';
        insert complaint;
        return complaint.id;
        
    }
    @AuraEnabled
    public static String saveComplaint(String dataString,String applicationId)
    {
        Map<String, Object> message = (Map<String, Object>)JSON.deserializeUntyped(dataString);
        system.debug('message : ' + message);
        
        Boolean AgreeCheck = (Boolean)message.get('agreeCheck');
        
        //for business Data
        Map<String, Object> bdata = (Map<String, Object>)message.get('businessData');
        /*String bdaddress = (String)bdata.get('address');
        String bdbusinessName = (String)bdata.get('businessName');
        String bdcounty = (String)bdata.get('county');
        String bddoingBusinessAs = (String)bdata.get('doingBusinessAs');
        String bdemail = (String)bdata.get('email');
        String bdlicenseStatus = (String)bdata.get('licenseStatus');
        String bdphone = (String)bdata.get('phone');*/
        
        //for information Data
        Map<String, Object> idata = (Map<String, Object>)message.get('information');
        /*String iaddress = (String)idata.get('address');
        String icity = (String)idata.get('city');
        String ifirstName = (String)idata.get('firstName');
        String ilastName = (String)idata.get('lastName');
        String imiddleName = (String)idata.get('middleName');
        String istate = (String)idata.get('state');
        String izipcode = (String)idata.get('zipcode');
        String iphone = (String)idata.get('phone');
        String iemail = (String)idata.get('email');*/
        
        //for professional Data
        Map<String, Object> pdata = (Map<String, Object>)message.get('professionalData');
       /* String paddress = (String)pdata.get('address');        
        String pfirstName = (String)pdata.get('firstName');
        String plastName = (String)pdata.get('lastName');
        String pcounty = (String)pdata.get('county');
        String plicenseNumber = (String)pdata.get('licenseNumber');        
        String pphone = (String)pdata.get('phone');
        String pemail = (String)pdata.get('email');*/
        MUSW__Complaint2__c complaint = [Select id, Name FROM MUSW__Complaint2__c Where id=:applicationId];
        
        complaint.Program_Type__c = (String)message.get('selectedProfession');
          complaint.Complaint_Submission_Agree__c  = (Boolean)message.get('agreeCheck');
        complaint.Anonymous__c  = (Boolean)message.get('anonymous');
            complaint.MUSW__Description__c = (String)message.get('complaintSummary');
        complaint.MUSW__Status__c = 'Intake';
        if(pdata != null)
            {
            complaint.Respondent_First_Name__c = (String)pdata.get('firstName');
            complaint.Respondent_Last_Name__c= (String)pdata.get('lastName');
            complaint.Respondent_License_Number__c= (String)pdata.get('licenseNumber');
            complaint.Respondent_Email__c = (String)pdata.get('email');
            complaint.Respondent_Phone_Number__c = (String)pdata.get('phone');
            complaint.Respondent_Mailing_Address__c = (String)pdata.get('address');
            complaint.Respondent_City__c = (String)pdata.get('city');
            complaint.Respondent_State__c = (String)pdata.get('state');
            complaint.Respondent_County__c = (String)pdata.get('county');
            }
        
            if(bdata != null)
            {
            complaint.Respondent_Business_Name__c = (String)bdata.get('businessName');
            complaint.Respondent_Doing_Business_As__c = (String)bdata.get('doingBusinessAs');
            complaint.Respondent_Business_License_Number__c = (String)bdata.get('licenseNumber');
            complaint.Respondent_Business_Email__c = (String)bdata.get('email');
            complaint.Respondent_Business_Phone__c = (String)bdata.get('phone');
            complaint.Respondent_Business_Mailing_Address__c = (String)bdata.get('address');
            complaint.Respondent_Business_City__c = (String)bdata.get('city');
            complaint.Respondent_Business_State__c = (String)bdata.get('state');
            complaint.Respondent_Business_County__c = (String)bdata.get('county');   
            }
            
            if(idata != null)
            {
            complaint.Complainant_First_Name__c = (String)idata.get('firstName');
            complaint.Complainant_Last_Name__c = (String)idata.get('lastName');
            complaint.Complainant_Information_Business_Name__c = (String)idata.get('businessName');
            complaint.Complainant_Email__c = (String)idata.get('email');
            complaint.Complainant_Phone_Main__c =(String)idata.get('phone');
            complaint.Complainant_Mailing_Address__c = (String)idata.get('address'); 
            complaint.Complainant_City__c =(String)idata.get('city');
            complaint.Complainant_State__c = (String)idata.get('state');
            complaint.Complainant_Zipcode__c =  (String)idata.get('zipcode');
            }
        
        system.debug('complaint : '+complaint);
        update complaint;
            system.debug('AgreeCheck : '+AgreeCheck);
        system.debug('bdata : '+bdata);
        
        return complaint.Name;
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
                                                               system.debug(' sumeet OR Check '+mapORValues);
                                                               List<Polaris_DynamicSQL> creterias = new  List<Polaris_DynamicSQL> ();
                                                               for (String attributeName : mapValues.keyset()) {
                                                                   Polaris_DynamicSQL sqlObj = new Polaris_DynamicSQL();
                                                                   sqlObj.FieldName = attributeName;
                                                                   sqlObj.FieldValue = mapValues.get(attributeName);
                                                                   sqlObj.Operator = '=';
                                                                   creterias.add(sqlObj);
                                                               }
                                                               List<Polaris_DynamicSQL> orcreterias = new  List<Polaris_DynamicSQL> ();
                                                               for (String mainKey : mapORValues.keyset()) {
                                                                   String sAllAttributes = mapORValues.get(mainKey);
                                                                   List<String> lstAllAttributesPieces = sAllAttributes.split('=');
                                                                   Polaris_DynamicSQL sqlObj = new Polaris_DynamicSQL();
                                                                   sqlObj.FieldName = lstAllAttributesPieces[0];
                                                                   sqlObj.FieldValue = lstAllAttributesPieces[1];//mapORValues.get(attributeName);
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
    public class businessDataClass
    {
        @AuraEnabled public String address{set;get;}
        @AuraEnabled public String businessName{set;get;}
        @AuraEnabled public String county{set;get;}
        @AuraEnabled public String doingBusinessAs{set;get;}
        @AuraEnabled public String email{set;get;}
        @AuraEnabled public String licenseStatus{set;get;}
        @AuraEnabled public String phone{set;get;}
    }
    public class informationClass
    {
        @AuraEnabled public String address{set;get;}
        @AuraEnabled public String city{set;get;}
        @AuraEnabled public String firstName{set;get;}
        @AuraEnabled public String lastName{set;get;}
        @AuraEnabled public String email{set;get;}
        @AuraEnabled public String middleName{set;get;}
        @AuraEnabled public String phone{set;get;}
        @AuraEnabled public String state{set;get;}
        @AuraEnabled public String zipcode{set;get;}            
    }
    public class professionalDataClass
    {
        @AuraEnabled public String address{set;get;}
        @AuraEnabled public String county{set;get;}
        @AuraEnabled public String firstName{set;get;}
        @AuraEnabled public String lastName{set;get;}
        @AuraEnabled public String email{set;get;}
        @AuraEnabled public String licenseStatus{set;get;}
        @AuraEnabled public String licenseNumber{set;get;}
        @AuraEnabled public String phone{set;get;}
        @AuraEnabled public String city{set;get;}            
    }
}