/****************************************************************************************************************************************
** Class Name       : Dashboard_CC 
** Description      : This class serves as backend controller for Dashboard component 
**                    (User Story: 138 - Portal Dashboard)
** Version          : 1.0
** Built By         : Srikanth Kottam
**----------------------------------------------------------------------------------------------------------------------------------------
** Modification Log:
**----------------------------------------------------------------------------------------------------------------------------------------
** Developer                        Date            Reference               Description
** 
**----------------------------------------------------------------------------------------------------------------------------------------
** Review Log:
**---------------
** Reviewer                  Date           Version               Description
**-----------------------------------------------------------------------------------------------------------------------------------------
**
*******************************************************************************************************************************************/ 
public class Dashboard_CC {
    public transient List<MUSW__License2__c> licenseList {get; set;}
    public List<HomeAuthService.LicenseObj> appLicenseList {get; set;}
    public List<HomeAuthService.LicenseObj> exLicenseList {get; set;}
    public transient List<HomeAuthService.LicenseObj> allLicenseList {get; set;}
    public Boolean isLicList {get; set;}
    public Boolean isExLicList {get; set;}
    public List<HomeAuthService.RenewReinstateObj> renewReinstateObjList {get; set;}
    public String loadFullData {get; set;}
    public String pageType {get; set;}
    public String pageTypePer {get; set;}
    public String pageTypePlan {get; set;}
    public List<Id> licenseIdList {get; set;}
    public String currentLicenseId {get; set;}
    public String renewReinstateType {get; set;}
    public String licensePermitType {get; set;}
    public String credType {get; set;}
    public String renewReinstateObjSerialized {get; set;}
    // public transient List<MUSW__Permit2__c> planreviewList {get; set;}
    public List<HomeAuthService.permitObj> appPlanReviewList {get; set;}
    public transient List<MUSW__Permit2__c> permitList {get; set;}
    public List<HomeAuthService.permitObj> appPermitList {get; set;}
    public List<Id> planreviewIdList {get; set;}
    public List<Id> permitIdList {get; set;}
    public Boolean isExPerList {get; set;}
    public Boolean isExPlanList {get; set;}
    public Boolean isPlanList {get; set;}
    public Boolean isPerList {get; set;}
    public List<HomeAuthService.PermitObj> exPermitList {get; set;}
    public List<HomeAuthService.PermitObj> exPlanReviewList {get; set;}
    public transient List<HomeAuthService.PermitObj> allPermitList {get; set;}
    public transient List<HomeAuthService.PermitObj> allPlanReviewList {get; set;}
    public String sortParameter {get; set;}
    // Global variables
    public Id contactId;
    public Boolean isAppLic {get; set;}
    public Boolean isAppPer {get; set;}
    public Boolean isAppPlan {get; set;}
    private transient List<Service_Links__mdt> serviceRequests;
    /**
* Method - getAllLicensesSerialized
* @return    String
*/
    public String getAllLicensesSerialized(){
        return JSON.serialize(exLicenseList);
    }
    
    /**
* Method - getAllApplicationsSerialized
* @return    String
*/
    public String getAllApplicationsSerialized(){
        return JSON.serialize(appLicenseList);
    }
    
    /**
* Method - getAllRenewalsSerialized
* @return    String
*/
    public String getAllRenewalsSerialized(){
        return JSON.serialize(renewReinstateObjList);
    }
    
    /**
* Constructor
*/
    public Dashboard_CC(){
        
        // Get page parameter for 'My Licenses' page
        pageType = ApexPages.currentPage().getParameters().get('applicationType');
        system.debug('pageType>>H>'+pageType);
        //defaults to License if blank
        if(pageType == '' || pageType == null){
            pageType = 'Licenses';
        }
        
        pageTypePlan = ApexPages.currentPage().getParameters().get('type');
        if(pageTypePlan == '' || pageTypePlan == null){
            pageTypePlan = 'PlanReview';
        }
        
        pageTypePer = ApexPages.currentPage().getParameters().get('type');
        if(pageTypePer == '' || pageTypePer == null){
            pageTypePer = 'Permit';
        }
        
        // Initialize lists
        initialize();
        
        // Get contact id
        getContactId();
        
        serviceRequests = loadServiceRequests();
        
        // Load Credentials
        loadLicenses(contactId);
        
        //Load Plan Review
        loadPermitPlanReview(contactId);
        
        //Load Permit
        //loadPermit(contactId);
        
        // Load notifications
        //   loadNotifications(contactId);
    }
    
    /**
* Method - To initialize everything
* @return    void
*/
    public void initialize(){
        
        // Initialize lists
        licenseList = new List<MUSW__License2__c>();
        appLicenseList = new List<HomeAuthService.LicenseObj>();
        exLicenseList = new List<HomeAuthService.LicenseObj>();
        allLicenseList = new List<HomeAuthService.LicenseObj>();
        
        appPlanReviewList = new List<HomeAuthService.permitObj>();
        appPermitList = new List<HomeAuthService.permitObj>();
        exPermitList = new List<HomeAuthService.PermitObj>();
        exPlanReviewList = new List<HomeAuthService.PermitObj>();
        
        allPermitList = new List<HomeAuthService.PermitObj>();
        allPlanReviewList = new List<HomeAuthService.PermitObj>();
        
        licenseIdList = new List<Id>();
        loadFullData = 'Yes';
        
        planreviewIdList = new List<Id>();
        permitIdList = new List<Id>();
        
        isLicList = true;
        isPlanList = true;
        isPerList =true;
        isExLicList = false;
        isExPerList = false;
        isExPlanList = false;
        isAppLic = false;
        isAppPer = false;
        isAppPlan = false;
    }
    
    /**
    * Method - To get contact id
    * @return    void
    */
    public void getContactId(){
        
        // Contact Id
        contactId = [Select contactId from user where id =: UserInfo.getUserId()].contactId;
    }
    
    /**
    * Method - To retrieve Credential and applications
    * @param     Contact Id
    * @return    void
    */
    public void loadLicenses(Id contactId){
        
        // Create set of Ids
        Set<Id> contactIds = new Set<Id>();
        Set<Id> accountIds = new Set<Id>();
        
        // Add the first contact Id
        contactIds.add(contactId);
        
        // Get accounts
        try {
            
            // Account-contacts list
            List<MUSW__Account_Contact__c> accountList = [SELECT Id, MUSW__Account__c, MUSW__Account__r.Name FROM MUSW__Account_Contact__c 
                                                          WHERE MUSW__Contact__c = :contactId and Associate_Status__c = 'Active'];
            // Accumulate all account Ids
            for(MUSW__Account_Contact__c ac : accountList) {
                accountIds.add(ac.MUSW__Account__c);
            }
        }
        catch(Exception e){
            system.debug('MUSW__Account_Contact__c List>>>> threw exception');
            ErrorLogger.logGeneralException(e, UserInfo.getUserId(), 'Dashboard_CC', null, 'loadCredentials', 'Dashboard_CC', label.str_HIGH);
        }
        
        // Query license data
        String licenseQuery = 'SELECT Id, Name, MUSW__Applicant__c, MUSW__Issue_Date__c, MUSW__Expiration_Date__c, Application_Type__c, Credential__c, Credential_Type__c, MUSW__Status__c, MUSW__Primary_Licensee__c, Business_License__c ' 
                            +'FROM MUSW__License2__c WHERE (MUSW__Applicant__c IN :contactIds or MUSW__Primary_Licensee__c IN :accountIds ) order by LastModifiedDate DESC  LIMIT 1000';
        system.debug('licenseQuery123 '+licenseQuery);
        licenseList = Database.query(licenseQuery);
        system.debug('licenseList>>>>'+licenseList);
        List<HomeAuthService.LicenseObj> activeLicenses = new List<HomeAuthService.LicenseObj>();
        List<HomeAuthService.LicenseObj> anActiveLicenses = new List<HomeAuthService.LicenseObj>();
        // Load license records into two lists
        for(MUSW__License2__c licObj : licenseList){
            // Applications
            if((licObj.MUSW__Status__c != 'Active') && (licObj.MUSW__Status__c != 'Inactive') && (licObj.MUSW__Status__c != 'Closed') && (licObj.MUSW__Status__c != 'Expired') && (licObj.MUSW__Status__c != 'Late Renewal' && licObj.MUSW__Status__c != 'Canceled')) {
                appLicenseList.add(new HomeAuthService.LicenseObj(licObj.Id, licObj.Name, licObj.Application_Type__c,licObj.Credential__c,
                                                                  licObj.Credential_Type__c, licObj.MUSW__Expiration_Date__c, licObj.MUSW__Status__c, licObj.MUSW__Primary_Licensee__c, licObj.Business_License__c, licObj,licObj.MUSW__Applicant__c));
                isLicList = false;
                isAppLic = true;
            }
            // Licenses
            else{
                if(licObj.MUSW__Status__c == label.ST_Active || licObj.MUSW__Status__c == 'Expired' || licObj.MUSW__Status__c == 'Late Renewal' || licObj.MUSW__Status__c == 'Canceled' ){
                    activeLicenses.add(new HomeAuthService.LicenseObj(licObj.Id, licObj.Name, licObj.Application_Type__c, licObj.Credential__c,
                                                                      licObj.Credential_Type__c, licObj.MUSW__Expiration_Date__c, licObj.MUSW__Status__c, licObj.MUSW__Primary_Licensee__c, licObj.Business_License__c, licObj,licObj.MUSW__Applicant__c));
                    
                }else{
                    anActiveLicenses.add(new HomeAuthService.LicenseObj(licObj.Id, licObj.Name, licObj.Application_Type__c, licObj.Credential__c,
                                                                        licObj.Credential_Type__c, licObj.MUSW__Expiration_Date__c, licObj.MUSW__Status__c, licObj.MUSW__Primary_Licensee__c, licObj.Business_License__c, licObj,licObj.MUSW__Applicant__c));   
                    
                }
                licenseIdList.add(licObj.Id);
                isExLicList = true;
            }
        }
        system.debug('appLicenseListSize>>>>>'+appLicenseList.size());
        system.debug('appLicenseList>>>>>'+appLicenseList);
        if(isExLicList == true ){
            List<HomeAuthService.LicenseObj> sortedActiveLic = new List<HomeAuthService.LicenseObj>();
            sortedActiveLic = HomeAuthService.sortCustomListAsc(activeLicenses, 'expiryDt');
            
            List<HomeAuthService.LicenseObj> sortedInActiveLic = new List<HomeAuthService.LicenseObj>();
            sortedInActiveLic = HomeAuthService.sortCustomListAsc(anActiveLicenses, 'expiryDt');
            
            exLicenseList.addAll(sortedActiveLic);
            exLicenseList.addAll(sortedInActiveLic);
        }
        
        // PREP SR Links to avoid for loop inside for loop which causes CPU timeout if number of records in Dashboard is high
        Map<String,List<Service_Links__mdt>> licenseTypetoSL_License_1 = new Map<String,List<Service_Links__mdt>>();
        Map<String,List<Service_Links__mdt>> licenseTypetoSL_Application_1 = new Map<String,List<Service_Links__mdt>>();
        
        for(Service_Links__mdt svc : serviceRequests){
            if(svc.Existing_Credential__c){
                if(svc.Service_Request_Type__c != 'Enhanced CE' && svc.Service_Request_Type__c != 'Renew/Reinstate review status'){
                    if(licenseTypetoSL_License_1.containskey(svc.Credential__c))
                        licenseTypetoSL_License_1.get(svc.Credential__c).add(svc);
                    else 
                        licenseTypetoSL_License_1.put(svc.Credential__c, new List<Service_Links__mdt>{svc});
                }
            }
            
            if(svc.Application__c){
                if(svc.Service_Request_Type__c != 'Enhanced CE' && svc.Service_Request_Type__c != 'Review Status'){
                    if(licenseTypetoSL_Application_1.containskey(svc.Credential__c))
                        licenseTypetoSL_Application_1.get(svc.Credential__c).add(svc);
                    else 
                        licenseTypetoSL_Application_1.put(svc.Credential__c, new List<Service_Links__mdt>{svc});
                }
            }
        }
        
        
        for(HomeAuthService.LicenseObj lics : exLicenseList){
            
            // Initialize service request list
            lics.serviceRequestList = new List<Service_Links__mdt>();
            
            // Add to another list for 'MyLicenses' page
            if(pageType == 'Licenses'){
                allLicenseList.add(lics);
                isAppLic = true;
            }
            
            // Add service requests
            if(licenseTypetoSL_License_1 != null && licenseTypetoSL_License_1.containskey(lics.Credential))
                lics.serviceRequestList.addAll(licenseTypetoSL_License_1.get(lics.Credential));
            
        }  
        
        for(HomeAuthService.LicenseObj lics : appLicenseList){
            // Initialize service request list
            lics.serviceRequestList = new List<Service_Links__mdt>();
            
            
            // Add to another list for 'MyLicenses' page
            if(pageType == 'Applications'){
                allLicenseList.add(lics);
            }
            
            // Add service requests
            if(licenseTypetoSL_Application_1 != null && licenseTypetoSL_Application_1.containskey(lics.Credential))
                lics.serviceRequestList.addAll(licenseTypetoSL_Application_1.get(lics.Credential));
        }
        System.debug('>>>>>>>all license list>>>>>>>>>>>>>>>::' +allLicenseList);
    }
    
    /**
    * Method - To retrieve Plan Review & Permit and applications
    * @param     Contact Id
    * @return    void
    */
    public void loadPermitPlanReview(Id contactId){
        // Create set of Ids
        Set<Id> cIds = new Set<Id>();
        Set<Id> aIds = new Set<Id>();
        
        // Add the first contact Id
        cIds.add(contactId);
        // Get accounts
        try{
            List<MUSW__Account_Contact__c> acList = [Select Id, MUSW__Account__c, MUSW__Account__r.Name from MUSW__Account_Contact__c 
                                                     where MUSW__Contact__c =: cIds and Associate_Status__c = 'Active'];
            for(MUSW__Account_Contact__c ac: acList){
                aIds.add(ac.MUSW__Account__c);
            }
        }catch(Exception ex){
            system.debug('Load Plan Review Accounts Error'+ex);
        }
        // Query Plan Review data
        string permitQuery = 'SELECT Id, Name, MUSW__Applicant__c, MUSW__Issue_Date__c, MUSW__Expiration_Date__c, Application_Type__c, Program_Area__c, Permit_Type__c, MUSW__Status__c, MUSW__Account__c, Business_License__c,Generate_Invoice__c,MUSW__Total_Balance__c ' 
            +'FROM MUSW__Permit2__c WHERE (MUSW__Applicant__c IN :cIds or MUSW__Account__c IN :aIds ) order by MUSW__Expiration_Date__c DESC NULLS FIRST LIMIT 100';
        permitList = Database.query(permitQuery); 
        //plan Review
        List<HomeAuthService.permitObj> activePlanReviewList = new List<HomeAuthService.permitObj>();
        List<HomeAuthService.permitObj> inactivePlanReviewList = new List<HomeAuthService.permitObj>();
        
        //Permit
        List<HomeAuthService.permitObj> activePermitList = new List<HomeAuthService.permitObj>();
        List<HomeAuthService.permitObj> inactivePermitList = new List<HomeAuthService.permitObj>();
        
        for(MUSW__Permit2__c perObj : permitList){
            if(perObj.Application_Type__c == 'Plan Review'){
                if((perObj.MUSW__Status__c != 'Active') && (perObj.MUSW__Status__c != 'Inactive') && (perObj.MUSW__Status__c != 'Closed') && (perObj.MUSW__Status__c != 'Conditionally Approved') && (perObj.MUSW__Status__c != 'Expired')){
                    appPlanReviewList.add(new HomeAuthService.permitObj(perObj.Id, perObj.Name, 
                                                                        perObj.Application_Type__c, 
                                                                        perObj.Program_Area__c, 
                                                                        perObj.Permit_Type__c, 
                                                                        perObj.MUSW__Expiration_Date__c, 
                                                                        perObj.MUSW__Status__c, 
                                                                        perObj.MUSW__Account__c, 
                                                                        perObj.Business_License__c,
                                                                        perObj,
                                                                        perObj.Generate_Invoice__c,
                                                                        perObj.MUSW__Total_Balance__c));
                    isPlanList = false;
                    isAppPlan = true;
                }else{
                    if((perObj.MUSW__Status__c == label.ST_Active) || (perObj.MUSW__Status__c == 'Conditionally Approved') || (perObj.MUSW__Status__c == 'Expired')){
                        activePlanReviewList.add(new HomeAuthService.permitObj(perObj.Id, perObj.Name, 
                                                                               perObj.Application_Type__c, 
                                                                               perObj.Program_Area__c, 
                                                                               perObj.Permit_Type__c, 
                                                                               perObj.MUSW__Expiration_Date__c, 
                                                                               perObj.MUSW__Status__c, 
                                                                               perObj.MUSW__Account__c, 
                                                                               perObj.Business_License__c,
                                                                               perObj,
                                                                               perObj.Generate_Invoice__c,
                                                                               perObj.MUSW__Total_Balance__c));
                        system.debug('activePlanReviewList>>>>'+activePlanReviewList);
                    }else{
                        inactivePlanReviewList.add(new HomeAuthService.permitObj(perObj.Id, perObj.Name, 
                                                                                 perObj.Application_Type__c, 
                                                                                 perObj.Program_Area__c, 
                                                                                 perObj.Permit_Type__c, 
                                                                                 perObj.MUSW__Expiration_Date__c, 
                                                                                 perObj.MUSW__Status__c, 
                                                                                 perObj.MUSW__Account__c, 
                                                                                 perObj.Business_License__c,
                                                                                 perObj,
                                                                                 perObj.Generate_Invoice__c,
                                                                                 perObj.MUSW__Total_Balance__c));
                    }
                    planreviewIdList.add(perObj.Id);
                    isExPlanList = true;
                }
            }else if(perObj.Application_Type__c == 'Manufactured Homes Communities'){
                if((perObj.MUSW__Status__c != 'Active') && (perObj.MUSW__Status__c != 'Inactive') && (perObj.MUSW__Status__c != 'Closed') && (perObj.MUSW__Status__c != 'Expired')){
                    appPermitList.add(new HomeAuthService.permitObj(perObj.Id, perObj.Name, 
                                                                        perObj.Application_Type__c, 
                                                                        perObj.Program_Area__c, 
                                                                        perObj.Permit_Type__c, 
                                                                        perObj.MUSW__Expiration_Date__c, 
                                                                        perObj.MUSW__Status__c, 
                                                                        perObj.MUSW__Account__c, 
                                                                        perObj.Business_License__c,
                                                                        perObj,
                                                                        perObj.Generate_Invoice__c,
                                                                        perObj.MUSW__Total_Balance__c));
                    isPerList = false;
                    isAppPer = true;
                }else{
                    if(perObj.MUSW__Status__c == label.ST_Active || perObj.MUSW__Status__c == 'Expired'){
                        activePermitList.add(new HomeAuthService.permitObj(perObj.Id, perObj.Name, 
                                                                               perObj.Application_Type__c, 
                                                                               perObj.Program_Area__c, 
                                                                               perObj.Permit_Type__c, 
                                                                               perObj.MUSW__Expiration_Date__c, 
                                                                               perObj.MUSW__Status__c, 
                                                                               perObj.MUSW__Account__c, 
                                                                               perObj.Business_License__c,
                                                                               perObj,
                                                                               perObj.Generate_Invoice__c,
                                                                               perObj.MUSW__Total_Balance__c));
                    }else{
                        inactivePermitList.add(new HomeAuthService.permitObj(perObj.Id, perObj.Name, 
                                                                                 perObj.Application_Type__c, 
                                                                                 perObj.Program_Area__c, 
                                                                                 perObj.Permit_Type__c, 
                                                                                 perObj.MUSW__Expiration_Date__c, 
                                                                                 perObj.MUSW__Status__c, 
                                                                                 perObj.MUSW__Account__c, 
                                                                                 perObj.Business_License__c,
                                                                                 perObj,
                                                                                 perObj.Generate_Invoice__c,
                                                                                 perObj.MUSW__Total_Balance__c));
                    }
                    permitIdList.add(perObj.Id);
                    isExPerList = true;
                }
            }
        }
        
        if(isExPerList == true){
            // Sort the lists for Permits
            List<HomeAuthService.PermitObj> sortedActivePer = new List<HomeAuthService.PermitObj>();
            sortedActivePer = HomeAuthService.sortpermitListAsc(activePermitList, 'expiryDt');
            
            List<HomeAuthService.PermitObj> sortedInActivePer = new List<HomeAuthService.PermitObj>();
            sortedInActivePer = HomeAuthService.sortpermitListAsc(inactivePermitList, 'expiryDt');
            
            exPermitList.addAll(sortedActivePer); 
            exPermitList.addAll(sortedInActivePer);
        }
        
        if(isExPlanList ==  true){
            // Sort the lists for Plan Review
            List<HomeAuthService.PermitObj> sortedActivePlan = new List<HomeAuthService.PermitObj>();
            sortedActivePlan = HomeAuthService.sortpermitListAsc(activePlanReviewList, 'expiryDt');
            
            List<HomeAuthService.PermitObj> sortedInActivePlan = new List<HomeAuthService.PermitObj>();
            sortedInActivePlan = HomeAuthService.sortpermitListAsc(inactivePlanReviewList, 'expiryDt');
            
            exPlanReviewList.addAll(sortedActivePlan); 
            exPlanReviewList.addAll(sortedInActivePlan);
        }
        
        Map<String,List<Service_Links__mdt>> licenseTypetoSL_License_1 = new Map<String,List<Service_Links__mdt>>();
        Map<String,List<Service_Links__mdt>> licenseTypetoSL_Application_1 = new Map<String,List<Service_Links__mdt>>();
        for(Service_Links__mdt svc : serviceRequests){
            if(svc.Existing_Credential__c){
                if(svc.Service_Request_Type__c != 'Enhanced CE' && svc.Service_Request_Type__c != 'Renew/Reinstate review status'){
                    if(licenseTypetoSL_License_1.containskey(svc.Permit_Type__c))
                        licenseTypetoSL_License_1.get(svc.Permit_Type__c).add(svc);
                    else 
                        licenseTypetoSL_License_1.put(svc.Permit_Type__c, new List<Service_Links__mdt>{svc});
                }
            }
            
            if(svc.Application__c){
                if(svc.Service_Request_Type__c != 'Enhanced CE' && svc.Service_Request_Type__c != 'Review Status'){
                    if(licenseTypetoSL_Application_1.containskey(svc.Permit_Type__c))
                        licenseTypetoSL_Application_1.get(svc.Permit_Type__c).add(svc);
                    else 
                        licenseTypetoSL_Application_1.put(svc.Permit_Type__c, new List<Service_Links__mdt>{svc});
                }
            }
        }
        
        // For active Permits
        for(HomeAuthService.permitObj per : exPermitList){
            if(pageTypePer == 'Permit'){
                allPermitList.add(per);
                isAppPer = true;
            }
            
            per.serviceRequestList = new List<Service_Links__mdt>();
            // Add service requests
            system.debug('per.permitType: ' + per.permitType);
            system.debug('licenseTypetoSL_License_1: ' + licenseTypetoSL_License_1.get(per.permitType));
            if(licenseTypetoSL_License_1 != null && licenseTypetoSL_License_1.containskey(per.permitType)){
                per.serviceRequestList.addAll(licenseTypetoSL_License_1.get(per.permitType));
                system.debug('per.serviceRequestList: ' + per.serviceRequestList);
            }
        }
        
        // For application Permits
        for(HomeAuthService.permitObj per : appPermitList){
            if(pageTypePer == 'Applications'){
                allPermitList.add(per);
            }
            
            per.serviceRequestList = new List<Service_Links__mdt>();
            // Add service requests
            system.debug('per.permitType: ' + per.permitType);
            system.debug('licenseTypetoSL_Application_1: ' + licenseTypetoSL_Application_1.get(per.permitType));
            if(licenseTypetoSL_Application_1 != null && licenseTypetoSL_Application_1.containskey(per.permitType)){
                per.serviceRequestList.addAll(licenseTypetoSL_Application_1.get(per.permitType));
                system.debug('per.serviceRequestList: ' + per.serviceRequestList);
            }
        }
        
        // For active Plan Review
        for(HomeAuthService.permitObj plan : exPlanReviewList){
            if(pageTypePlan == 'PlanReview'){
                allPlanReviewList.add(plan);
                isAppPlan = true;
            }
            
            plan.serviceRequestList = new List<Service_Links__mdt>();
            // Add service requests
            if(licenseTypetoSL_License_1 != null && licenseTypetoSL_License_1.containskey(plan.permitType)){
                plan.serviceRequestList.addAll(licenseTypetoSL_License_1.get(plan.permitType));
            }
        }
        
        // For application Plan Review
        for(HomeAuthService.permitObj plan : appPlanReviewList){
            if(pageTypePlan == 'Applications'){
                allPlanReviewList.add(plan);
            }
            
            plan.serviceRequestList = new List<Service_Links__mdt>();
            // Add service requests
            if(licenseTypetoSL_Application_1 != null && licenseTypetoSL_Application_1.containskey(plan.permitType))
                plan.serviceRequestList.addAll(licenseTypetoSL_Application_1.get(plan.permitType));
        }
    }
    
    
    /**
    * Method - To retrieve list of service requrests
    * @return    void
    */
    public List<Service_Links__mdt> loadServiceRequests() {
        List<Service_Links__mdt> serviceRequests = null;
        // Get list of service requests
        try {
            serviceRequests = [SELECT Id, Application__c, Existing_Credential__c, MasterLabel,Credential__c, 
                               Credential_Type__c, OrderNumber__c, URL__c, Service_Request_Type__c, Program_Area__c, Permit_Type__c 
                               FROM Service_Links__mdt ORDER BY OrderNumber__c ASC NULLS LAST];
        }
        catch(Exception e) {
            serviceRequests = new List<Service_Links__mdt>();
            ErrorLogger.logGeneralException(e, UserInfo.getUserId(), 'Dashboard_CC', null, 'loadServiceRequests', 'Dashboard_CC', label.str_HIGH);
        }
        
        return serviceRequests;
    }
    
    /**
     * Method - To change address
     * @return    void
     */
    public void queryAddressChange(){
        system.debug('Entered into Address Change>>>>>>>>');
    }
    
    /**
     * Method - To Renew or Reinstate
     * @return    void
     */
    public void queryRenewReinstate() {
        
        system.debug('Entered into Renew & Reinstate>>>>>>>>');
        // Initialize final list
        renewReinstateObjList = new List<HomeAuthService.RenewReinstateObj>();
        
        // Initialize local variables
        String url = '';
        String currentBoard = '';
        String applicationType = ''; 
        String credentialType = '';
        String credential = ''; 
        string permitType = '';
        string programArea = '';
        String applicationMethod = '';
        Boolean currentEligibility = false;
        Boolean isEndAppEditable = true;
        Boolean canApply = true;
        Boolean isPaymentDue = false;
        Boolean bIsBusinessLicense = false ;
        String businessAccountId = null ;
        Boolean isOnHold = false;
        
        system.debug('licensePermitType>>>'+licensePermitType);
        if(licensePermitType == 'License'){
            // Get parameters of current license record
            String licenseQuery = 'SELECT Id, Name, Application_Type__c, Credential_Type__c, Credential__c, Application_Method__c, '
                                + 'MUSW__Applicant__c, MUSW__Issue_Date__c, MUSW__Expiration_Date__c, App_Submitted_Date__c, '
                                + 'MUSW__Status__c, Sub_Status__c, MUSW__Primary_Licensee__c, Business_License__c, '
                                + 'Is_Renewal_Eligible__c, Is_Late_Renewal_Eligible__c, Is_Reinstatement_Eligible__c, '
                                + 'MUSW__Applicant__r.Contact_Status__c, MUSW__Primary_Licensee__r.Account_Status__c '
                                + 'FROM MUSW__License2__c WHERE Id = \'' + String.escapeSingleQuotes(currentLicenseId) + '\'';
            MUSW__License2__c lic = Database.query(licenseQuery);
            if(lic != null) {
                // Set parameters
                bIsBusinessLicense = lic.Business_License__c;
                businessAccountId = lic.MUSW__Primary_Licensee__c;
                applicationType = EncodingUtil.urlEncode(lic.Application_Type__c, 'UTF-8');
                credentialType = lic.Credential_Type__c;
                credential = lic.Credential__c;
                applicationMethod = lic.Application_Method__c;
                    system.debug('renewReinstateType>>>'+renewReinstateType);
                if(renewReinstateType == 'Renewal') {
                    // If Renewal or Late Renewal is true allow renewal
                    if(lic.Is_Renewal_Eligible__c == true || lic.Is_Late_Renewal_Eligible__c == true){
                        currentEligibility = true;
                    }
                }
                else if(renewReinstateType == 'Reinstatement') {
                    //If Reinstatement is true then allow Reinstatement
                    if(lic.Is_Reinstatement_Eligible__c == true){
                        currentEligibility = true;
                    }
                }
                
                if(lic.MUSW__Applicant__r.Contact_Status__c == 'On Hold' || lic.MUSW__Primary_Licensee__r.Account_Status__c == 'On Hold'){
                    isOnHold = true;
                }
            }
        } else if(licensePermitType == 'Permit'){
            String permitQuery = 'SELECT Id, Name, Application_Type__c, Permit_Type__c, Program_Area__c, Application_Method__c, '
                + 'MUSW__Applicant__c, MUSW__Issue_Date__c, MUSW__Expiration_Date__c, App_Submitted_Date__c, '
                + 'MUSW__Status__c, Sub_Status__c, MUSW__Account__c, Business_License__c, '
                + 'Is_Renewal_Eligible__c, Is_Late_Renewal_Eligible__c, '
                + 'MUSW__Applicant__r.Contact_Status__c, MUSW__Account__r.Account_Status__c '
                + 'FROM MUSW__Permit2__c WHERE Id = \'' + String.escapeSingleQuotes(currentLicenseId) + '\'';
            MUSW__Permit2__c per = Database.query(permitQuery);
            system.debug('Permit Renewal>>>>'+per);
            if(per != null) {
                // Set parameters
                bIsBusinessLicense = per.Business_License__c;
                businessAccountId = per.MUSW__Account__c;
                applicationType = EncodingUtil.urlEncode(per.Application_Type__c, 'UTF-8');
                permitType = per.Permit_Type__c;
                programArea = per.Program_Area__c;
                applicationMethod = per.Application_Method__c;
                if(renewReinstateType == 'Renewal') {
                    // If Renewal or Late Renewal is true allow renewal
                    if(per.Is_Renewal_Eligible__c == true || per.Is_Late_Renewal_Eligible__c == true){
                        currentEligibility = true;
                    }
                }
                
                if(per.MUSW__Applicant__r.Contact_Status__c == 'On Hold' || per.MUSW__Account__r.Account_Status__c == 'On Hold'){
                    isOnHold = true;
                }
            }
        }
        
        
        // If eligible
        if(currentEligibility) 
        { 
            if(licensePermitType == 'License'){
                // Build URL for individual and Business
                if(bIsBusinessLicense) {
                    url = '/ApplyForSObjectInstructions?applicationType=' + applicationType + '&credentialType=' + credentialType + 
                        '&credential=' + credential + '&applicationMethod=' + applicationMethod + '&parentId=' + currentLicenseId + 
                        '&renewalOrReinstatement=' + renewReinstateType + '&accountId=' + businessAccountId ;
                }
                else {
                    url = '/ApplyForSObjectInstructions?applicationType=' + applicationType + '&credentialType=' + credentialType + 
                        '&credential=' + credential + '&applicationMethod=' + applicationMethod + '&parentId=' + currentLicenseId + 
                        '&renewalOrReinstatement=' + renewReinstateType;
                }
            } else if(licensePermitType == 'Permit'){
                // Build URL for individual and Business
                if(bIsBusinessLicense) {
                    url = '/ApplyForSObjectInstructions?applicationType=' + applicationType + '&permitType=' + permitType + 
                        '&programArea=' + programArea + '&applicationMethod=' + applicationMethod + '&parentId=' + currentLicenseId + 
                        '&renewalOrReinstatement=' + renewReinstateType + '&accountId=' + businessAccountId ;
                }
                else {
                    url = '/ApplyForSObjectInstructions?applicationType=' + applicationType + '&permitType=' + permitType + 
                        '&programArea=' + programArea + '&applicationMethod=' + applicationMethod + '&parentId=' + currentLicenseId + 
                        '&renewalOrReinstatement=' + renewReinstateType;
                }
            }
            system.debug('URL>>>>>>>>'+url);
            // If a record is already existing
            try {
                // List of all renewals/reinstatements
                List<Renewal_Application__c> newLicObjList = [SELECT Id, Renewal_Status__c,Generate_Invoice__c,Total_Balance__c FROM Renewal_Application__c 
                                                              WHERE License__c = :currentLicenseId
                                                              AND Renewal_Reinstatement_Type__c = :renewReinstateType];
                
                // Declare a renewal/reinstatement object
                Renewal_Application__c newLicObj;
                
                for(Renewal_Application__c eachObj : newLicObjList) {
                    
                    // Case 1: If an existing record is in progress
                    if(eachObj.Renewal_Status__c == 'Incomplete') {
                        newLicObj = eachObj;
                    }
                    // Case 2: If a similar record is already completed
                    else if((eachObj.Renewal_Status__c == 'Submitted' || eachObj.Renewal_Status__c == 'Generate Fee') && (newLicObj == null)) {
                        newLicObj = eachObj;
                    }
                }
                
                // If one of the two above cases is true
                if(newLicObj != null) {
                    
                    // For case 1
                    if(newLicObj.Renewal_Status__c == 'Incomplete') {
                        url += '&pid=' + newLicObj.Id;
                        canApply = true;
                    }
                    // For case 2
                    else if(newLicObj.Renewal_Status__c == 'Submitted'){
                        //isAppEditable = false;
                        canApply = false;
                    }
                    // For case 3
                    else if(newLicObj.Renewal_Status__c == 'Generate Fee' || (newLicObj.Renewal_Status__c.equals(Label.ST_Submitted) && newLicObj.Generate_Invoice__c && newLicObj.Total_Balance__c > 0)) {
                        isPaymentDue = true;
                        canApply = true;
                    }
                }
                else {
                    canApply = true;
                }
            }
            catch(Exception e) {
                ErrorLogger.logGeneralException(e, UserInfo.getUserId(), 'Dashboard_CC', null, 'queryRenewReinstate', 'Dashboard_CC', label.str_HIGH);
            }
            // Modify URL
            url.replace(' ', '+');
            url.replace('(', '%28');
            url.replace(')', '%29');
            
            if(licensePermitType == 'License'){
                // Add license renewal/reinstatement record
                renewReinstateObjList.add(new HomeAuthService.RenewReinstateObj(currentLicenseId, true, isOnHold, isPaymentDue, canApply, url, 'License'));
            }
            else if(licensePermitType == 'Permit'){
                // Add license renewal/reinstatement record
                renewReinstateObjList.add(new HomeAuthService.RenewReinstateObj(currentLicenseId, true, isOnHold, isPaymentDue, canApply, url, 'Permit'));
            }
            
       }
        
        // Return serialized list for Javascript(UI) to use
        renewReinstateObjSerialized = JSON.serialize(renewReinstateObjList);
    }
    
    /**
     * Method - To call asc sorting method
     * @return    void
     */
    public void sortListByFieldAsc() {
        switch on sortParameter{
            when 'credentialName'{
                DSPSComparator.sort(appLicenseList, new HomeAuthService.CredentialNameComparator()); 
                DSPSComparator.sort(exLicenseList, new HomeAuthService.CredentialNameComparator()); 
            }
            when 'credentialExpiryDt'{
                //Natural Sort by expiryDt
                exLicenseList.sort();
            }
            when 'programArea'{
                DSPSComparator.sort(appPlanReviewList, new HomeAuthService.PermitNameComparator()); 
                DSPSComparator.sort(appPermitList, new HomeAuthService.PermitNameComparator());
                DSPSComparator.sort(exPermitList, new HomeAuthService.PermitNameComparator()); 
                DSPSComparator.sort(exPlanReviewList, new HomeAuthService.PermitNameComparator()); 
            }
            when 'expiryDt'{
                //Natural Sort by expiryDt
                exPermitList.sort();
                exPlanReviewList.sort();
            }
        }
    }

    /**
     * Method - To call dsc sorting method
     * @return    void
     */
    public void sortListByFieldDsc() {
        // Create new list
 /*       List<HomeAuthService.LicenseObj> sortedList = new List<HomeAuthService.LicenseObj>();

        // Call sort method
        sortedList = HomeAuthService.sortCustomListDsc(allLicenseList, sortParameter);

        // Clear and return lists
        allLicenseList.clear();
        allLicenseList.addAll(sortedList);
        sortedList.clear();
*/
    }
}