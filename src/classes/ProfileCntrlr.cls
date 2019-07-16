/*************************************************************************************************************
** User Story: 150 -  MyProfile Page
**************************************************************************************************************
** Class Name       : ProfileCntrlr
** Description      : This is a controller class for MyProfile Page which helps users to change their contact information
as well as military info.
** Version          : 1.0
** Built By         : 
**------------------------------------------------------------------------------------------------------------
** Modification Log:
**------------------
** Developer                  Date          Version               Description
**------------------------------------------------------------------------------------------------------------
** 		
** Review Log:
**---------------
** Reviewer                   Date           Version                Description
**------------------------------------------------------------------------------------------------------------
**
*************************************************************************************************************/
public class ProfileCntrlr {
    
    public Contact contactDummy {get; set;}
    public String pageMode {get; set;}
    public String currentSection {get; set;}
    public Contact conObj {get; set;}
    public User currentUser {get; set;}
    public string parsedDate {get;set;}
    public String birthDateString {get; set;}
    public String milStartDate {get; set;}
    public String milEndDate {get; set;}
    public DBOperationResult result ;
    
    /***************************************************************************************************
* @Description : Constructor
* @Param       : None
* @Return      : NA
***************************************************************************************************/
    
    public ProfileCntrlr() {
        contactDummy = new Contact();
        pageMode = label.Str_pageMode;
        currentUser = [Select Id, contactId, Email, Username from user where id = : UserInfo.getUserId()];
        String contactId = currentUser.contactId;
        
        if (contactId != null) {
            conObj = Utilities.getFullProfileDetails(contactId) ;
            if (conObj.BirthDate != null){
                parsedDate = Date.newInstance(conObj.BirthDate.year(), conObj.BirthDate.month(), conObj.BirthDate.day()).format();
            }
            result = new DBOperationResult(true, Label.Str_Page_loaded_successfully) ;
            result.currentSection = Label.Str_NA ;
        }        
    }
    
    
    /***************************************************************************************************
* @Description : Saves changes made to profile info by the user
* @Param       : None
* @Return      : NA
***************************************************************************************************/
    
    public void saveProfileData() {
        try {
            boolean emailPass = Utilities.checkBlockedEmail (conObj);
            if (!emailPass) {
                result = new DBOperationResult(false, label.Err_You_are_not_allowed_to_register_with_this_Email_Please_choose_a_differentone);
                return;
            }
            
            if (currentSection == Label.Str_personal_info ) {
                if (birthDateString != null && birthDateString != '') {
                    conObj.BirthDate = Date.parse(birthDateString) ;
                }
            }  else if (currentSection == Label.Str_military_info) {
                if (conObj.Served_in_Military__c == 'Yes') {
                    
                    if (milStartDate != null && milStartDate != '') {
                        conObj.Start_Date_Military_Service__c = Date.parse(milStartDate) ;
                    }
                    
                    if (conObj.Still_Serving_in_Military__c == 'No') {
                        if (milEndDate != null & milEndDate != '') {
                            conObj.End_Date_Military_Service__c = Date.parse(milEndDate) ;
                        }
                    } else {
                        conObj.End_Date_Military_Service__c = null;
                    }
                    
                } else {
                    conObj.Start_Date_Military_Service__c = null ;
                    conObj.End_Date_Military_Service__c = null ;
                    conObj.Branch_of_Military_Service__c = null ;
                    conObj.Country_of_Military_Service__c = null ;
                    conObj.Honorable_Discharge__c = null ;
                }
            }
            
            update conObj ;
            pageMode = label.Str_pageMode ;
            result = new DBOperationResult(true, Label.Str_Profile_information_updated_successfully ) ;
            
        } catch (exception ex) {
            result = new DBOperationResult(false, ex.getMessage()) ;
        }
        
        result.currentSection = currentSection ;
        
    }
    
    /***************************************************************************************************
* @Description : Updates email address on User object. Returns error message if thet email is already registered
* @Param       : None
* @Return      : NA
***************************************************************************************************/
    
    public void updateUsername() {
        try {
            if (conObj.Email != currentUser.Username) {
                currentUser.Username = conObj.Email;
                currentUser.Email = conObj.Email;
                update currentUser;
            }
            result = new DBOperationResult(true, Label.Str_Profile_information_updated_successfully ) ;
        } catch (exception ex) {
            String errorMessage = ex.getMessage();
            if (errorMessage.contains('DUPLICATE_USERNAME') || errorMessage.containsIgnoreCase('DUPLICATE USERNAME')) {
                errorMessage = Label.Str_DuplicateUsername;
            }
            result = new DBOperationResult(false, errorMessage) ;
        }
        
        result.currentSection = currentSection;
    }
    
    /* Wrapper class to parse the result */
    
    public class DBOperationResult {
        public Boolean isSuccess {get; set;}
        public String errorMessage {get; set;}
        public String currentSection {get; set;}
        public DBOperationResult(Boolean bSuccess , String errorMessageIn  ) {
            this.isSuccess = bSuccess ;
            this.errorMessage = errorMessageIn ;
        }
    }
    
    public String getResultJSON() {
        return JSON.serialize(result);
    }
}