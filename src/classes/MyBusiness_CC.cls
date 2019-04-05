/*************************************************************************************************************
** User Story: 
**************************************************************************************************************
** Class Name       : MyBusiness_CC
** Description      : 
** Version          : 1.0
** Built By         : Srikanth Kottam
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
public class MyBusiness_CC {
   public Contact contactDummy {get; set;}
  //  public String pageMode {get; set;}
    public String currentSection {get; set;}
    public Contact conObj {get; set;}
    public User currentUser {get; set;}
    
    public MyBusiness_CC() {
        contactDummy = new Contact();
     //   pageMode = label.Str_pageMode;
        currentUser = [Select Id, contactId, Email, Username from user where id = : UserInfo.getUserId()];
        String contactId = currentUser.contactId;

        if (contactId != null) {
            conObj = Utilities.getFullProfileDetails(contactId) ;
            result = new DBOperationResult(true, label.Str_Page_loaded_successfully) ;
            result.currentSection = label.Str_NA;
        }        
    }


    public class DBOperationResult {
        public Boolean isSuccess {get; set;}
        public String errorMessage {get; set;}
        public String currentSection {get; set;}
        public DBOperationResult(Boolean bSuccess , String errorMessageIn  ) {
            this.isSuccess = bSuccess ;
            this.errorMessage = errorMessageIn ;
        }
    }


    public String birthDateString {get; set;}
    public String milStartDate {get; set;}
    public String milEndDate {get; set;}
    public DBOperationResult result ;

    public String getResultJSON() {
        return JSON.serialize(result);
    }

    public void saveProfileData() {
        try {
            boolean emailPass = Utilities.checkBlockedEmail (conObj);
            if (!emailPass) {
                result = new DBOperationResult(false, label.Err_You_are_not_allowed_to_register_with_this_Email_Please_choose_different_one) ;
                return;
            }

            if (currentSection == 'personal_info' ) {
                if (birthDateString != null && birthDateString != '') {
                    conObj.BirthDate = Date.parse(birthDateString) ;
                }
            } else if (currentSection == label.Str_military_info) {
                if (conObj.Served_in_Military__c == label.ST_Yes) {
                    if (milStartDate != null && milStartDate != '') {
                        conObj.Start_Date_Military_Service__c = Date.parse(milStartDate) ;
                    }


                    if (conObj.Still_Serving_in_Military__c == label.ST_No) {
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
        //    pageMode = label.Str_pageMode ;
            result = new DBOperationResult(true, label.Str_Profile_information_updated_successfully ) ;

        } catch (exception ex) {
            result = new DBOperationResult(false, ex.getMessage()) ;
        //    OH_ErrorLogger.logGeneralException(ex, UserInfo.getUserId(), 'OH_ProfileCntrlr', 'Update Contact Records', 'EndorsementGenerateFeeDate', 'OH_ProfileCntrlr', label.Str_Low);
        }

        result.currentSection = currentSection ;

    }

    public void updateUsername() {
        try {
            if (conObj.Email != currentUser.Username) {
                currentUser.Username = conObj.Email;
                currentUser.Email = conObj.Email;
                update currentUser;
            }
            result = new DBOperationResult(true, label.Str_Profile_information_updated_successfully ) ;
        } catch (exception ex) {
            String errorMessage = ex.getMessage();
            if (errorMessage.contains('DUPLICATE_USERNAME') || errorMessage.containsIgnoreCase('DUPLICATE USERNAME')) {
                errorMessage = Label.Str_DuplicateUsername;
            }
            result = new DBOperationResult(false, errorMessage) ;
        //    OH_ErrorLogger.logGeneralException(ex, UserInfo.getUserId(), 'OH_ProfileCntrlr', 'Update User Records', 'updateUsername', 'OH_ProfileCntrlr', label.Str_HIGH);
        }

        result.currentSection = currentSection;
    } 
}