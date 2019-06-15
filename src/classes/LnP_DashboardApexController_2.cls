public class LnP_DashboardApexController_2 {
	    @AuraEnabled
    public static Map<String,String> getDBJSON(){
         Map<String, String> mapJSON = new Map<String, String>();
        try{
         System.debug('mapJSON::');
         mapJSON = getDashboardJSON(); 
         System.debug('mapJSON: after::'+ mapJSON );
        }
         catch(Exception e){
             HandleException.LogException(e,'LnP_DashboardApexController','getDBJSON');
        }
         return mapJSON;
    }
   
    @AuraEnabled
    public static List<genericDataTableCoulumnWrapper> setCurrentLicenseTableColumnsMap(){
        genericDataTableCoulumnWrapper wrapperObj;
        /*
        {
        'Name':'LICENSE#',
        'Application_Type__c':'PROFESSION',
        'Credential_Type__c':'LICENSE TYPE',
        'MUSW__Expiration_Date__c':'EXPIRATION DATE',
        'MUSW__Status__c':'STATUS',
        'Sub_Status__c':'SUB-STATUS'
        }

        */
        return null;
    }

    @AuraEnabled
    public static void setDraftLicenseTableColumnsMap(){

    }
    @AuraEnabled
    public static void setDraftRenewLicenseTableColumnsMap(){

    }

    @AuraEnabled
    public static void setDraftMaintanceRequestTableColumnsMap(){

    }
    
    public static Map<String, String> getDashboardJSON() {
        Map <String, String> mapJSON = new Map <String, String>();
        //mapJSON.put('Card Menu List','[{"header":"Notifications", "url":"/dashboard", "icon": "LnP__Notification_E.svg", "class":"slds-small-size_1-of-1 slds-medium-size_1-of-2 slds-large-size_1-of-3"},{"header":"Service Requests:", "url":"/dashboard", "icon": "LnP__ServiceRequest_E.svg", "class":"slds-small-size_1-of-1 slds-medium-size_1-of-2 slds-large-size_1-of-3"},{"header":"My To Do List", "url":"/dashboard", "icon": "LnP__ToDoList_E.svg", "class":"slds-small-size_1-of-1 slds-medium-size_1-of-2 slds-large-size_1-of-3"},{"header":"All Applications", "url":"/dashboard", "icon": "LnP__Applications_E.svg", "class":"slds-small-size_1-of-1 slds-medium-size_1-of-1 slds-large-size_1-of-1"}]');
        mapJSON.put('Card Menu List','[{"header":"All Applications", "url":"/dashboard", "icon": "LnP__Applications_E.svg", "class":"slds-small-size_1-of-1 slds-medium-size_1-of-1 slds-large-size_1-of-1"}]');
        mapJSON.put('Application Header List','["Number","Type", "Status", "Created Date", "Link", "Expiration Date", "Add Association"]');        
       //CR start 
         System.debug('User@@@'+userInfo.getUserId());
        List<User> userInfoData = new  List<User>();
        String queryCondition = ' Id=\''+UserInfo.getUserId()+'\'';//0050b000004XiXjAAK
       // String queryCondition1 = ' Id=\''+UserInfo.getUserId()+'\'';
        String queryStr = 'SELECT ContactId FROM User WHERE  '+queryCondition;
        system.debug('queryStr@@@ '+queryStr);
        userInfoData = Utilityclass_withsharing.queryRecords(queryStr);
        //String queryCondition1 = ' MUSW_Applicant__c =\''+userInfoData[0].ContactId+'\'';
        system.debug('userInfoData[0].ContactId@@@ '+userInfoData[0].ContactId);
        list<MUSW__License2__c> lstLicenses;
        list<MUSW__Application2__c> applicationList;
        if(userInfoData[0].ContactId != null){
          //applicationList = [select Id, isRenewal__c,License_Type__c,Board__c,Application_Type__c, Status__c ,CreatedDate from MUSW__Application2__c WHERE Status__c= 'Pending' AND MUSW_Applicant__c =: userInfoData[0].ContactId ORDER BY CreatedDate desc limit 5];
          applicationList = [select Id,Application_Number__c, isRenewal__c,Credential_Type__c,Application_Type__c,Application_Method__c, MUSW__Status__c ,CreatedDate from MUSW__Application2__c WHERE MUSW__Status__c= 'Pending' AND isRenewal__c=false AND MUSW__Applicant__c =: userInfoData[0].ContactId ORDER BY CreatedDate asc ];
        } 
        if(userInfo.getUserId() != null){
         //applicationList = [select Id, isRenewal__c,License_Type__c,Board__c,Application_Type__c, Status__c ,CreatedDate from MUSW_Application2__c WHERE Status__c= 'Pending' AND CreatedById =: userInfo.getUserId() ORDER BY CreatedDate desc limit 5];
         applicationList = [select Id,Application_Number__c, isRenewal__c,Credential_Type__c,Application_Type__c,Application_Method__c, MUSW__Status__c ,CreatedDate from MUSW__Application2__c WHERE MUSW__Status__c= 'Pending' AND isRenewal__c=false AND MUSW__Applicant__c =: userInfoData[0].ContactId ORDER BY CreatedDate asc ];
        } 
        //For License
        if(userInfoData[0].ContactId != null){
          lstLicenses = [select Id,Name,RecordType.Name,Is_Renewal_Eligible__c, Is_Late_Renewal_Eligible__c,Is_Reinstatement_Eligible__c,Credential_Type__c,Application__c,Application__r.isRenewal__c,Application_Type__c,Application_Method__c, MUSW__Status__c ,CreatedDate,MUSW__Expiration_Date__c from MUSW__License2__c WHERE MUSW__Applicant__c =: userInfoData[0].ContactId ORDER BY CreatedDate asc ];
        } 
        if(userInfo.getUserId() != null){
         lstLicenses = [select Id,Name,RecordType.Name,Is_Renewal_Eligible__c,Is_Late_Renewal_Eligible__c,Is_Reinstatement_Eligible__c,  Credential_Type__c,Application_Type__c,Application_Method__c, MUSW__Status__c ,Application__c,Application__r.isRenewal__c,CreatedDate,MUSW__Expiration_Date__c from MUSW__License2__c WHERE CreatedById =: userInfo.getUserId() ORDER BY CreatedDate asc ];
        }
        
        Map<Id,Map<String,String>> mapLicenses = new Map<Id,Map<String,String>>();
        Map<Id,Map<String,String>> mapBusLicenses = new Map<Id,Map<String,String>>();
        Map<Id,Map<String,String>> applicationMap = new Map<Id,Map<String,String>>();
        for(MUSW__Application2__c app: applicationList){
            Map<String,String> temp = new Map<String,String>();
            if(!applicationMap.containsKey(app.Id)){
                temp.put('Name',app.Application_Number__c);
                temp.put('type',app.Credential_Type__c);
                temp.put('board',app.Application_Type__c);
                temp.put('Id',app.Id);
                temp.put('status', app.MUSW__Status__c);
                temp.put('date', String.valueOf(app.CreatedDate));
                temp.put('applicationType',app.Application_Method__c);
                temp.put('renewal',String.valueOf(app.isRenewal__c));
                applicationMap.put(app.Id,temp); 
            }
        }
        //For mapLicense
        for(MUSW__License2__c lic: lstLicenses){
            Map<String,String> temp = new Map<String,String>();
            if(lic.RecordType.Name == 'Individual'){
                if(!mapLicenses.containsKey(lic.Id)){
                    temp.put('Name',lic.Name);
                    temp.put('type',lic.Credential_Type__c);
                    temp.put('board',lic.Application_Type__c);
                    temp.put('Id',lic.Id);
                    temp.put('status', lic.MUSW__Status__c);
                    temp.put('renewal', String.valueOf(lic.Is_Renewal_Eligible__c));
                    temp.put('lateRenewal', String.valueOf(lic.Is_Late_Renewal_Eligible__c));
                    temp.put('reinstate', String.valueOf(lic.Is_Reinstatement_Eligible__c));
                    temp.put('date', String.valueOf(lic.CreatedDate));
                    temp.put('expiryDate', String.valueOf(lic.MUSW__Expiration_Date__c));
                    temp.put('applicationType',lic.Application_Method__c);
                    temp.put('licenseAppId',lic.Application__c);
                    temp.put('appIsRenewal',String.valueOf(lic.Application__r.isRenewal__c));
                  
                    
                    mapLicenses.put(lic.Id,temp); 
                }}
             if(lic.RecordType.Name == 'Business'){
                 if(!mapBusLicenses.containsKey(lic.Id)){
                    temp.put('Name',lic.Name);
                    temp.put('type',lic.Credential_Type__c);
                    temp.put('board',lic.Application_Type__c);
                    temp.put('Id',lic.Id);
                    temp.put('status', lic.MUSW__Status__c);
                    temp.put('renewal', String.valueOf(lic.Is_Renewal_Eligible__c));
                    temp.put('lateRenewal', String.valueOf(lic.Is_Late_Renewal_Eligible__c));
                    temp.put('reinstate', String.valueOf(lic.Is_Reinstatement_Eligible__c));
                    temp.put('date', String.valueOf(lic.CreatedDate));
                    temp.put('expiryDate', String.valueOf(lic.MUSW__Expiration_Date__c));
                    temp.put('applicationType',lic.Application_Method__c);
                    temp.put('licenseAppId',lic.Application__c);
                    temp.put('appIsRenewal',String.valueOf(lic.Application__r.isRenewal__c));
                    mapBusLicenses.put(lic.Id,temp); 
                }
             } 
             }
        
        List<MUSW__Account_Contact__c> AcctConList = [ select id,Account_Admin__c,Associate_Status__c from MUSW__Account_Contact__c where OwnerId =:userInfo.getUserId() and Account_Admin__c = true and Associate_Status__c =:'Active' ];
        system.debug(JSON.serialize(applicationMap));
        mapJSON.put('Application Item List',JSON.serialize(applicationMap));
        mapJSON.put('License Item List',JSON.serialize(mapLicenses));
        String businessFlag = 'false';
        if(!AcctConList.isEmpty()){
            if(AcctConList[0].Account_Admin__c){
              mapJSON.put('BusinessLicense',JSON.serialize(mapBusLicenses));  
              businessFlag = 'true';
            }
        }
        mapJSON.put('businessFlag',businessFlag );
        System.debug('mapJSON :'+mapJSON);
        return mapJSON;
    }

    public class genericDataTableCoulumnWrapper{
        public String label;
        public String fieldName;
        genericDataTableCoulumnWrapper(String label, String fieldName){
            this.label = label;
            this.fieldname = fieldName;
        }
    }
}