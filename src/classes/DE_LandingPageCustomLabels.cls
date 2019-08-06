public class DE_LandingPageCustomLabels {
    
    public static Map<String, String> getFooterLabels(){
        Map<String, String> mapFooterLabels = new Map<String, String>();
        mapFooterLabels.put('FootListItems1',Label.DE_Portal_Home_Foot_List_Items);
        mapFooterLabels.put('FootListItems2',Label.DE_Portal_Home_Foot_List_Items2);
        mapFooterLabels.put('FootListHiddenItems',Label.DE_Portal_Home_Foot_Hidden_List_Items);
        mapFooterLabels.put('FootListHiddenItems2',Label.DE_Portal_Home_Foot_Hidden_List_Items2);
        mapFooterLabels.put('Hidden Heading',Label.DE_Portal_Home_Foot_Hidden_Heading);
        mapFooterLabels.put('Hidden List Item',Label.DE_Portal_Home_Foot_Hidden_Li);
        
        return mapFooterLabels ;
    }
    
   public static Map<String, String> getWidgetLabels(){
        Map<String, String> mapWidgetLabels = new Map<String, String>();
        String userType= UserInfo.getUserType();
        System.debug('userType '+ userType);
        if(userType=='Standard'){
           mapWidgetLabels.put('ApplyForLicenseHeader',Label.DE_Portal_Home_Apply_For_License+','+Label.DE_Portal_Home_Apply_For_License_Content+','+'./dashboard');
        }
        else{
           mapWidgetLabels.put('ApplyForLicenseHeader',Label.DE_Portal_Home_Apply_For_License+','+Label.DE_Portal_Home_Apply_For_License_Content+','+'./login/');
        }
        mapWidgetLabels.put('FileAComplaint',Label.DE_Portal_Home_Filing_A_Complaint+','+Label.DE_Portal_Home_Filing_A_Complaint_Content+','+'./file-a-complaint');
        mapWidgetLabels.put('GuideToInfo',Label.de_portal_home_guide_to_info+','+Label.DE_Portal_Home_Guide_To_Info_Content+','+Label.DE_Portal_Home_Apply_For_License_Url);
        mapWidgetLabels.put('OnlineServices',Label.DE_Portal_Home_Online_Services+','+Label.DE_Portal_Home_Online_Services_Content+','+Label.DE_Portal_Home_Apply_For_License_Url);
        mapWidgetLabels.put('PublicMeetings',Label.DE_Portal_Home_Public_Meetings+','+Label.DE_Portal_Home_Public_Meetings_Content+','+Label.DE_Portal_Home_Apply_For_License_Url);
        mapWidgetLabels.put('SearchVerifyLicense',Label.DE_Portal_Home_Search_Verify_License+','+Label.DE_Portal_Home_Search_Verify_License_Content+','+Label.DE_Portal_Home_Apply_For_License_Url);
        return mapWidgetLabels ;
    }
    
    public static Map<String, String> getCommonHeaderLabels(){
        
        Map<String, String> mapCommonHeaderLabels = new Map<String, String>();
        
        Boolean isValidUser = isValidCommunityUser();
        mapCommonHeaderLabels.put('Home','Home;'+System.Label.Polaris_Portal_Home+',');
        
        if(isValidUser){
            
            //mapCommonHeaderLabels.put('License Management','License Management;JavaScript:Void(0);,');
            
            //mapCommonHeaderLabels.put('Professional','Professional;'+System.Label.Polaris_Portal_Dashboard+',');
            
        	//mapCommonHeaderLabels.put('To Do','To Do;'+System.Label.Polaris_Portal_To_Do+','); 
        	
        	mapCommonHeaderLabels.put('Professional','Professional;'+System.Label.Polaris_Portal_NewDashboard+',');
        	
        	mapCommonHeaderLabels.put('Business','Business;'+System.Label.Polaris_Portal_Business_Dashboard+',');
        	
            //user feedback link
            //mapCommonHeaderLabels.put('User Feedback','User Feedback;'+System.Label.Polaris_Portal_UserFeedback+',');
        
        }
        
        mapCommonHeaderLabels.put('License Lookup','License Lookup;'+System.Label.Polaris_Portal_LicenseLookup+',');
        
        mapCommonHeaderLabels.put('Course Search','Course Search;'+System.Label.Polaris_Portal_Education+',');
        
        mapCommonHeaderLabels.put('File a Complaint','File a Complaint;'+System.Label.Polaris_Portal_Complaint+',');
        
        if(isValidUser){
            
            mapCommonHeaderLabels.put('Help','Help;'+System.Label.Polaris_Portal_Home+'?Help-Topic=Help-Topic'+',');
        }
        
        //mapCommonHeaderLabels.put('File a Complaint','File a Complaint;https://deloittelnp.force.com/s/file-a-complaint,');
        //mapCommonHeaderLabels.put('Log In','Log In;#,');
        return mapCommonHeaderLabels ;
    }
    
    public static Map<String, String> getCommonFooterLabels(){
        Map<String, String> mapCommonFooterLabels = new Map<String, String>();
        mapCommonFooterLabels.put('ABOUT DPR','ABOUT DPR;https://dpr.delaware.gov/aboutagency/,');
        mapCommonFooterLabels.put('FAX US','FAX US;https://dpr.delaware.gov/aboutagency/,');
        mapCommonFooterLabels.put('FREQUENTLY ASKED QUESTIONS','FREQUENTLY ASKED QUESTIONS;https://dpr.delaware.gov/faqs/,');
        mapCommonFooterLabels.put('FOIA REQUEST FORM','FOIA REQUEST FORM;http://delaware.gov/help/foia_request.shtml?subj=DOS,');
        return mapCommonFooterLabels ;
    }
               
    public static Map<String, String> getPublicFormsJSON() {
        Map <String, String> mapJSON = new Map <String, String>();
        mapJSON.put('Login','[{"staticText1":"To use these services, you must already hold or have applied for a Washington professional license. Click on your profession to find out how to apply.","staticText2":"Do you need help registering? Click here","staticText3":"Forgot Username?","staticText4":"Forgot Password?", "header": "Welcome to Washington", "fields": [ {"title": "Username", "placeholder": "Username", "type": "string", "Id":"usrNme"}, {"title": "Password", "placeholder": "Password", "type":"password", "Id":"pssWrd"}]}]');
        mapJSON.put('File A Complaint','[{"staticText": "To file a complaint, select the appropriate Board from the dropdown list. Then, provide the necessary contact information for each field.", "icon": "1.ComplaintInformation_E.svg", "header": "Complaint Information", "class":"slds-small-size_1-of-1 slds-medium-size_1-of-2 slds-large-size_1-of-2", "fields": [ {"title": "Profession of person you are complaining about", "type": "picklist", "options":[{"id":"Accountancy"},{"id":"Acupunture"}]},{"title":"Type(s) of complaint:","type":"text-for-checkbox", "checklist": [{"title":"Unprofessional Conduct","type":"checkbox"}, {"title":"Fraudulent Activity","type":"checkbox"}, {"title":"Practicing Beyond Scope of License","type":"checkbox"}, {"title":"Unlicensed Activity","type":"checkbox"}]}]}, {"staticText": "To file a complaint, select the appropriate Board from the dropdown list. Then, provide the necessary contact information for each field. Each field noted by (*) is a required field.", "icon": "2.ComplainantINfo_E.svg", "header": "Complainant Information", "class":"slds-small-size_1-of-1 slds-medium-size_1-of-2 slds-large-size_1-of-3", "fields": [ {"title": "First Name", "placeholder": "First Name", "type": "String", "required": true}, {"title": "Last Name", "placeholder": "Last Name", "type": "String", "required": true}, {"title": "Middle Initial", "placeholder": "Middle Initial", "type": "String"}, {"title": "Street Address", "placeholder": "3303 Boulevard", "type": "String", "required": true}, {"title": "City", "placeholder": "Plano", "type": "String", "required": true}, {"title": "State", "placeholder": "Delaware", "type": "String", "required": true}, {"title": "Zip", "placeholder": "xxxxxx", "type": "String", "required": true, "pattern":"[0-9]{6}"}, {"title": "Home Phone", "placeholder": "xxx-xxx-xxxx", "type": "tel", "required": true, "pattern":"[0-9]{3}[ -][0-9]{3}[ -][0-9]{4}"}, {"title": "Cell Phone", "placeholder": "xxx-xxx-xxxx", "type": "tel", "required": true, "pattern":"[0-9]{3}[ -][0-9]{3}[ -][0-9]{4}"}, {"title": "Work Phone", "placeholder": "xxx-xxx-xxxx", "type": "tel"},{"title": "Email", "placeholder": "example@domain.com", "type": "email"}],"subHeader":"Enter your Attorney details","controlField":"Check the box if you have any attorney", "subfields": [ {"title": "First Name", "placeholder": "First Name", "type": "String", "required": true}, {"title": "Last Name", "placeholder": "Last Name", "type": "String", "required": true}, {"title": "Middle Initial", "placeholder": "Middle Initial", "type": "String"}, {"title": "Street Address", "placeholder": "3303 Boulevard", "type": "String", "required": true}, {"title": "City", "placeholder": "Plano", "type": "String", "required": true}, {"title": "State", "placeholder": "Delaware", "type": "String", "required": true}, {"title": "Zip", "placeholder": "xxxxxx", "type": "String", "required": true, "pattern":"[0-9]{6}"}, {"title": "Home Phone", "placeholder": "xxx-xxx-xxxx", "type": "tel", "required": true, "pattern":"[0-9]{3}[ -][0-9]{3}[ -][0-9]{4}"}, {"title": "Cell Phone", "placeholder": "xxx-xxx-xxxx", "type": "tel", "required": true, "pattern":"[0-9]{3}[ -][0-9]{3}[ -][0-9]{4}"}, {"title": "Work Phone", "placeholder": "xxx-xxx-xxxx", "type": "tel"},{"title": "Email", "placeholder": "example@domain.com", "type": "email"}]}, {"staticText": "", "icon": "3.ComplaintSubject_E.svg","header": "Complaint Subject", "class":"slds-small-size_1-of-1 slds-medium-size_1-of-2 slds-large-size_1-of-3", "fields": [ {"title": "First Name", "placeholder": "First Name", "type": "String"}, {"title": "Last Name", "placeholder": "Last Name", "type": "String"}, {"title": "Middle Initial", "placeholder": "Middle Initial", "type": "String"}, {"title": "Street Address", "placeholder": "3303 Boulevard", "type": "String"}, {"title": "City", "placeholder": "Plano", "type": "String"}, {"title": "State", "placeholder": "Delaware", "type": "String"}, {"title": "Zip", "placeholder": "xxxxx", "type": "Number"}, {"title": "Phone", "placeholder": "xxx-xxx-xxxx", "type": "tel", "pattern":"[0-9]{3}[ -][0-9]{3}[ -][0-9]{4}"}, {"title": "License #", "placeholder": "xxx-xxx-xxxx", "type": "Number"},{"title": "Profession", "placeholder": "Dental", "type": "String"},{"title": "Email", "placeholder": "example@domain.com", "type": "email"}],"subHeader":"Details Of Business Involved","controlField":"Check if Business Involved", "subfields": [ {"title": "Business Name", "placeholder": "Business Name", "type": "String"}, {"title": "Business Type", "placeholder": "Business Type", "type": "String"}, {"title": "Street Address", "placeholder": "3303 Boulevard", "type": "String"}, {"title": "City", "placeholder": "Plano", "type": "String"}, {"title": "State", "placeholder": "Delaware", "type": "String"}, {"title": "Zip", "placeholder": "xxxxxx", "type": "String", "pattern":"[0-9]{6}"}, {"title": "Home Phone", "placeholder": "xxx-xxx-xxxx", "type": "tel", "pattern":"[0-9]{3}[ -][0-9]{3}[ -][0-9]{4}"}, {"title": "Phone", "placeholder": "xxx-xxx-xxxx", "type": "tel", "pattern":"[0-9]{3}[ -][0-9]{3}[ -][0-9]{4}"},{"title": "Owner Name", "placeholder": "Owner Name", "type": "String"}, {"title": "Email", "placeholder": "example@domain.com", "type": "email"}]}, {"staticText": "","icon": "4.WitnessInformation_E.svg", "header": "Witness Information", "class":"slds-small-size_1-of-1 slds-medium-size_1-of-2 slds-large-size_1-of-3", "fields": [ {"title": "First Name", "placeholder": "First Name", "type": "String"}, {"title": "Last Name", "placeholder": "Last Name", "type": "String"}, {"title": "Middle Initial", "placeholder": "Middle Initial", "type": "String"}, {"title": "Street Address", "placeholder": "3303 Boulevard", "type": "String"}, {"title": "City", "placeholder": "Plano", "type": "String"}, {"title": "State", "placeholder": "Delaware", "type": "String"}, {"title": "Zip", "placeholder": "xxxxx", "type": "Number"}, {"title": "Home Phone", "placeholder": "xxx-xxx-xxxx", "type": "tel", "pattern":"[0-9]{3}[ -][0-9]{3}[ -][0-9]{4}"}, {"title": "Cell Phone", "placeholder": "xxx-xxx-xxxx", "type": "tel"},{"title": "Work Phone", "placeholder": "xxx-xxx-xxxx", "type": "tel"},{"title": "Email", "placeholder": "example@domain.com", "type": "email"},{"title": "Are you willing to appear at a hearing if needed?", "type": "picklist", "options":[{"id":"Yes"},{"id":"No"}]},{"title":"If needed, is this witness willing to support your complaint by appearing at a hearing?","type":"text-for-checkbox", "checklist": [{"title":"Yes","type":"checkbox"}, {"title":"No","type":"checkbox"}, {"title":"Unknown","type":"checkbox"}]}],"subHeader":"Enter Name and Address details","controlField":"Check to add a second witness", "subfields": [ {"title": "First Name", "placeholder": "First Name", "type": "String"}, {"title": "Last Name", "placeholder": "Last Name", "type": "String"}, {"title": "Middle Initial", "placeholder": "Middle Initial", "type": "String"}, {"title": "Street Address", "placeholder": "3303 Boulevard", "type": "String"}, {"title": "City", "placeholder": "Plano", "type": "String"}, {"title": "State", "placeholder": "Delaware", "type": "String"}, {"title": "Zip", "placeholder": "xxxxx", "type": "Number"}, {"title": "Home Phone", "placeholder": "xxx-xxx-xxxx", "type": "tel", "pattern":"[0-9]{3}[ -][0-9]{3}[ -][0-9]{4}"}, {"title": "Cell Phone", "placeholder": "xxx-xxx-xxxx", "type": "tel"},{"title": "Work Phone", "placeholder": "xxx-xxx-xxxx", "type": "tel"},{"title": "Email", "placeholder": "example@domain.com", "type": "email"}]}, {"staticText": "Please describe your complaint in detail below. List services provided by the licensee, registrant, certificate holder or individual. Include the dates, times and locations where you believe offenses occurred and the nature of your complaint. To the best of your ability, outline how you believe the subject of your complaint has committed unprofessional conduct, unlicensed activity, or other violation. If applicable, you may submit documents in support of your complaint by faxing them to the Investigative Unit at (302) 739-2711 or email them to investigations.dpr@state.de.us", "icon": "5.ComplaintDescription_E.svg", "header": "Complaint Description", "class":"slds-size--1-of-1", "fields": [ {"title": "Description Of Complainant", "placeholder": "Description Of Complainant", "type": "textarea"}]}, {"staticText": "","icon": "6.ComplaintSubmission_E.svg", "header": "Complaint Submission", "class":"slds-size--1-of-1", "fields": [ {"title": "Send Copy of Complaint to your Email Address?", "placeholder": "", "type": "checkbox"},{"title": "Email", "placeholder": "example@domain.com", "type": "email"}]}]');
        mapJSON.put('Verify A License','[{"staticText":"To verify a license, select Individual or Business, enter search criteria and click Search to see the results.", "header": "", "fields": [ {"title": "Individual", "type": "radio"}, {"title": "Business", "type":"radio"}]},{"staticText":"Enter Individual details", "header": "", "fields": [ {"title": "First Name", "type": "String"}, {"title": "Last Name", "type":"String"}]},{"staticText":"Enter Business details", "header": "", "fields": [ {"title": "Business Name", "type": "String"}, {"title": "Board Name", "type":"String"}]}]');
        return mapJSON;
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
             if(lic.RecordType.Name == 'Business' || lic.RecordType.Name == 'Course' ){
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
  
  public static Map<String, String> getWizardStaticTexts(){
        Map<String, String> mapWizardStaticTexts = new Map<String, String>();
        mapWizardStaticTexts.put('header','LICENSE SELECTION');
        mapWizardStaticTexts.put('noAppTypeMessage','Your License Type does not have any Application Type. Please proceed with your Application.');
        mapWizardStaticTexts.put('oneAppTypeMessage','Based on your selection your Application Type is ');
        mapWizardStaticTexts.put('multiAppTypeMessage','Based on your answers your Application Type is ');
        //Added label  for eligibility question
        mapWizardStaticTexts.put('eligibilityquestion', 'Please answer following eligibility questions');
        return mapWizardStaticTexts ;
    }
    
    public static boolean isValidCommunityUser(){
        String validProfileName = 'eSLA Customer Community Plus Login User';
        Boolean isValid = true;
        User u  = [select id,Profile.name from user where id  =: UserInfo.getUserId() LIMIT 1];
        if(u != null){
            if(u.Profile.name != validProfileName){
                isValid = false;
            }
        }        
        return isValid;
    }
}