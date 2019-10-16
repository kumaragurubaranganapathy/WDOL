public class DOL_AppConstants {

    public static final String NULL_EMPTY_STRING = '';
    public static final String ePaymentEncryptionKeyLabel = 'ePayment Encryption Key';
    public static final String ePaymentEncryptionIVLabel = 'ePayment Encryption Init Vector';
    public static final String ePaymentEncryptionAlgoLabel = 'ePayment Encryption Algo Name';
    public static final String ePaymentReturnUrlPortalUser = 'ePayment Return Url Portal User';
    public static final String ePaymentReturnUrlNonPortalUser = 'ePayment Return Url Non Portal User';
    public static final String ePaymentSessionValuesSeperator = '|';
    public static final String ePaymentUrlListValuesSeperator = 'SEPARATOR';
    public static final List<String> PORTAL_PROFILES = new List<String>{'eSLA Customer Community Plus Login User','eSLA Customer Community Login User'};
    
    public static final string PREPEND_ASSOC_NAME = 'Assoc- ';
    //Class DOL_JITHandler
    public static final String sJITErrorMessageOne = 'An SAML error occurred. Please contact us for assistance.';
    public static final String sJITErrorMessageTwo = 'Configuration';
    public static final String sJITErrorMessageThree = 'Missing SAML attributes. Cant initiate JIT creation process. Please check if Custom Label for SAML attributes are set appropriately.';
    public static final String sJITException = 'DOL_JITHandler.JitException';
    public static final String sJITKey = 'IX6Wjpic/pToPXTvi6J0slh9nJuR0sH82+BFsCW13XA=';
    public static final String sJITAlgorithm = 'AES256';
    
    //Class Journal_Voucher_Trigger_Handler
    public static final String sJVTriggerOne = 'Manual CreditJournal - User Created';
    public static final String sJVTriggerTwo = 'Manual JV -User Created - Correction JV or one system to another JV';
    public static final String sJVTriggerThree = 'RemittanceTransfer in POLARIS - User Created';
    public static final String sJVTriggerFour = 'Manual JV -Remittance JV from a validation number';
    public static final String sJVTriggerFive = 'ManualTransfer - User Created';
    public static final String sJVTriggerSix = 'ManualTransfer - System Generated to other agencies';
    public static final String sJVTriggerSeven = 'Manual CRJSfor Daily -Lockbox  240Q';
    public static final String sJVTriggerEight = 'Manual IAP -user created to ensure document # matches OFM/AFRS';
    
    //Class LnP_SaveBackGroundDetails
    public static final String sSuccessResponse = 'Successfull';
    public static final String sFailedResponse = 'Fail';
    
    //Class Lnp_Journal_Voucher_Generic
    public static final String sJVAutomated = 'Journal Voucher Automated';
    public static final String sJVAFRES = 'AFRS';
    public static final String sJVTMS = 'TMS';
    
    //Class Polaris_AMRLinkCntrl
    public static final String sContactId = '003r000000EOhBB';
    
    //Class mapDemo
    public static final String sRoute = 'https://www.google.com/maps/dir';
    public static final String sIcon = 'utility:salesforce1';
    
    
    //Class batchSendLicenseCertification
    public static final String sSubjectLine = 'Dept of Licensing – License Certificate';
    public static final String sMailBody = 'Please find attached a copy of your License Certificate';
    
    public static Map<String,String> integrationSettingsMetadataMap = new Map<String,String>();
    
    static{
        for(Dol_Integration_Settings__mdt metadata : [select label,Value__c from Dol_Integration_Settings__mdt]){
            integrationSettingsMetadataMap.put(metadata.label,metadata.Value__c);
        }
    }
    
    //Add_BusinessController Constants
    public static final String PENDING = 'Pending';
    public static final String INVITATION_TO_BE_BUSINESS_ADMIN = 'Invitation to be a Business Admin';
    public static final String CONTACT_RELATIONSHIP = 'Contact Relationship';
    public static final String ADD_BUSINESSCONTROLLER = 'Add_BusinessController';
    public static final String CREATETASK = 'createTask';
    
    //Polaris_RenewLicenseController constants 
    public static final String ATTACHMENT = 'Attachment';
    public static final String SOFTCOPY_TO_BE_UPLOADED = 'Softcopy: To be Uploaded';
    public static final String HARDCOPY_TO_BE_UPLOADED  = 'Hardcopy: To be Mailed';
    public static final String SEMI_COLON = ';';
    public static final String LICENSE_INFORMATION  ='License Information';
    public static final String QUESTIONS = 'Questions';
    public static final String ATTACHMENTS = 'Attachments';
    public static final String FINANCIAL_GUARANTEE = 'Financial Guarantee';
    public static final String REVIEW_AND_SUBMIT = 'Review and Submit';
    public static final String CERTIFICATIONS = 'Certifications';
    public static final String NONE = '--None--';
    public static final String SELECT_ONE = '--Select one--';
    public static final String COMMA = ',';
    public static final String ENDORSEMENT = 'Endorsement';
    public static final String COURSE ='Course';
    public static final String APPLICATION_FEES = 'Application Fees';
    public static final String PHYSICAL_ADDRESS = 'Physical Address';
    public static final String MAILING_ADDRESS = 'Mailing Address';
    public static final String CAP_PHYSICAL_ADDRESS = 'PHYSICAL ADDRESS';
    public static final String CAP_MAILING_ADDRESS = 'MAILING ADDRESS';
    public static final String QUALIFYING_EDUCATION ='Qualifying Education';
    public static final String QUALYFYING_TRAINING ='Qualifying Training';
    public static final String QUALYFYING_EXPERIENCE ='Qualifying Experience';
    public static final String SUBMITTED = 'Submitted';
    public static final String NOTARY_PUBLIC = 'Notary Public';
    public static final String PICKLIST = 'Picklist';
    public static final String RENEWAL_APPLICATION = 'Renewal_Application__c';
    public static final String LICENSE = 'MUSW__License2__c';
    public static final String ANSWER_TEXT = 'Answer_Text__c';
    public static final String QUESTIONDOL = 'QuestionDOL__c';
    public static final String APPLICATION_BG = 'Application_BG__c';
    public static final String APPLICATION2= 'MUSW__Application2__c';
    public static final String DESCRIPTION = 'MUSW__Description__c';
    public static final String CONTENTDOCUMENTID ='ContentDocumentId__c';
    public static final String POST = 'POST';
    public static final String AUTHORIZATION = 'Authorization';
    public static final String BEARER = 'Bearer';
    public static final String CONTENTTYPE = 'Content-Type';
    public static final String POLARIS_RENEWLICENSECONTROLLER ='Polaris_RenewLicenseController';
    public static final String CALLCOMPOSITEAPILSTEDUHIST ='callCompositeAPI-lstEduHist';
    public static final String APPRAISERCOURSE = 'Appraiser Course';
    public static final String COURSE_INFORMATION = 'Course Information';
    public static final String EMAIL = 'Email__c';
    public static final String PHONE = 'Phone__c';
    public static final String WEBSITE = 'Website__c';
    public static final String IDECC_APPROVAL_EXPIRATION ='IDECC_Approval_Expiration_Date__c'; 
    public static final String PREAPPROVAL = 'Pre_Approval__c'; 
    public static final String IS_PROVIDER_AN_ACCREDITED_COLLEGE = ' Is the Provider an accredited college?';
    public static final String YES = 'Yes';
    public static final String COLLEGE = 'College';
    public static final String WHEN_DOES_YOUR_IDECC_APPROVAL_EXPIRE = 'When does your IDECC approval expire?';
    public static final String IDECC = 'IDECC';
    public static final String DELIVERY_METHOD = 'Delivery_Method__c';
    public static final String IS_THIS_DISTANCE_ONLINE_COURSE = 'Is this is a Distance / On-line course?';
    public static final String DISTANCE_ONLINE ='Distance / On-Line';
    public static final String CLASSROOM_INSTRUCTOR = 'Classroom (Instructor in room with students)';
    public static final String YES_NO = 'Yes_No';
    public static final String ACTIVE = 'Active';
	public static final String INACTIVE = 'Inactive';
    public static final String NOTARY = 'Notary';
    public static final String CALLCOMPOSITEAPTLST_ENDORSEMENT='callCompositeAPI-lstEndorsements';
    public static final String CALLCOMPOSITEAPI_lSTANSWERS = 'callCompositeAPI-lstAnswers';
    public static final String CALLCOMPOSITEAPT_LSTPROVIDERS = 'callCompositeAPI-lstProviders';
    public static final String CALLCOMPOSITEAPI_RENEWALOBJ = 'callCompositeAPI-RenewalObj';
    public static final String CALLCOMPOSITEAPI_LSTSUBMISSION = 'callCompositeAPI-lstSubmissions';
    public static final String CALLCOMPOSITEAPI_APPLIST = 'callCompositeAPI-appList[0]';
    public static final String BUSINESS = 'Business';
    public static final String INDIVIDUAL = 'Individual';
    public static final String GENERATE_FEE = 'Generate Fee';
    public static final String BACKGROUND_QUESTIONS = 'Background_Questions';
    public static final String HOW_WILL_YOUR_NAME_APPEAR = 'How will your name appear';
    public static final String FIRST_NAME_INITIAL = 'First Name or initial';
    Public static final String DOING_BUSINESS_AS ='Doing Business As';
    public static final String MIDDLE_NAME_INITIAL = 'Middle Name or initial';
    public static final String LASTNAME = 'Last Name';
    public static final String HOW_DO_YOU_WANT_YOUR_NAME_DISPLAYED_ON_YOUR_LICENSE = 'How do you want your name displayed on your license';
    public static final String USE_MY_FULL_LEGAL_NAME = 'Use my full legal name';
    public static final String TEXTAREA = 'TEXTAREA';
    public static final String MULTIPICKLIST = 'MULTIPICKLIST';
    public static final String TEXT ='TEXT';
    public static final String DOUBLE_DATA = 'DOUBLE';
    public static final String BOND_POLICY_NUMBER = 'Bond / Policy Number';
    public static final String BOND_INSURANCE_COMPANY = 'Bond / Insurance Company Name';
    public static final String BOND_POLICY_AMOUNT ='Bond / Policy Amount';
    public static final String EFFECTIVE_DATE ='Effective Date';
    public static final String EXPIRATION_DATE = 'Expiration Date';
    public static final String DEFAULT_LICENSE_RECORDTYPE = 'Universal_Default_License_Record_Type';
    public static final String INSERTLICENSE_LSTLICENSE_INSERT = 'insertLicense - lstLicense-Insert';
    public static final String INSERTLICENSE_lSTLICENSE_UPDATE = 'insertLicense-lstLicens-Update';
    public static final String RENEW ='Renew';
    public static final String ELECTRONIC_NOTARY ='Electronic Notary';
    public static final String IN_REVIEW = 'In-Review';
    public static final String COMPLETE = 'Complete'; //CartController.cls,
    public static final String COMPLETED = 'Completed';
    public static final String APPROVED = 'Approved';
    public static final String EXPIRED = 'Expired';
    public static final String INSERTLICENSE_LSTENDO = 'insertLicense-lstEndo';
    public static final String INSERTLICENSE_APPLICATIONLIST = 'insertLisence-applicationlist';
    public static final String GET_TOTAL_BALANCE = 'getTotalBalance';
    public static final String UPDATEADDRESSMODIFIED = 'updateAddressModified';
    public static final String UPDATELINKEDENTITYID = 'updateLinkedEntityId';
    public static final String RADIO = 'Radio';
    public static final String CHECKBOX ='Checkbox';
    public static final String PERSONAL_INFORMATION = 'Personal Information';
    public static final String CONTACT = 'Contact';
    public static final String ICON = ' icon';
    public static final String ACCOUNT = 'Account';
    public static final String NULL_STRING = 'null';
    public static final String BUSINESS_INFORMATION = 'Business Information';
    public static final String SUBMISSION = 'Submission'; 
    public static final String SECONDARYPROVIDER = 'Secondary Provider';
    
    //Class BusinessUtility
    public static final String COMMUNITY_PLUS_PROFILE = 'eSLA Customer Community Plus Login User' ;
    public static final String PREFIX_OLD_FIRSTNAME = 'Old-' ;
    public static final String EN_US_LANGUAGE_LOCALE = 'en_US' ;
    public static final String AMERICA_TIMEZONE_KEY = 'America/New_York' ;
    public static final String UTF_8_ENCODING_KEY = 'UTF-8' ;
    public static final String EMAIL_SERVICE_ADDRESS_DELEGATED_ADMIN = 'delegateadminemailservice@';
    public static final String EMAIL_SERVICE_ADDRESS_TEST = 'test@salesforce.com@';
    public static final String ACTIVE_STATUS_STRING = 'Active';
    
    //Class CartController
    public static final String CASHIER_CHECK = 'Check/Cashier\'s Check';
    public static final String CONFIRM_STRING = 'confirm';
    public static final String FEE_STRING = 'fees';
    public static final String REVIEW_STRING = 'review';
    public static final String DEPOSIT_STRING = 'Deposit';
    public static final String COMPLETE_STRING = 'Complete';
    public static final String TEMP_STRING = 'temp';
    public static final String COUNTER_STRING = 'Counter';
    public static final String PORTAL_STRING = 'Portal';
    public static final String SELECT_STRING_WITH_SPACE = 'SELECT ';

    Public static final String FEE_PAYMENT_SOQL_QUERY_STRING = 'SELECT MUSW__Fee__r.License_Number__c, MUSW__Fee__r.portal_name__c, MUSW__Fee__r.Application_Type__c,'
            +'MUSW__Fee__r.License_Type__c, MUSW__Fee__r.Application_Method__c, MUSW__Fee__r.MUSW__Amount__c, MUSW__Payment_Amount__c,'
            +'MUSW__Fee__r.MUSW__Outstanding_Fee__c, Id, MUSW__Fee__c,BGBK__Invoice__c,'
            +'BGBK__Invoice__r.Name,BGBK__Invoice__r.BGBK__Balance_Due__c,BGBK__Invoice__r.BGBK__Invoice_Date__c,MUSW__Receipt__c '
            +'FROM MUSW__Fee_Payment__c '
            +'WHERE MUSW__Receipt__c = :receiptId';
            
    //Class ClassTriggerHandler
    public static final String CLASS_SOBJECT_STATUS_APPLIED = 'Applied';
    
    //Class CommunitiesRegistrationController
    public static final String CONTACT_ACCOUNT_RELATIONSHIP_OWNER = 'Owner';
    
    //class ContactTriggerHandler
    public static final String CONTACT_STATUS_ON_HOLD = 'On Hold';
    
    //class ContactValidator
    public static final String SOQL_WHERE_FILTER_EQUALS_TRUE =  '= true';
    public static final String SOQL_CREDENTIAL_TYPE_FILTER = 'Select Name From Application_Field__c where Required__c = true and Object_Name__c = \'Contact\' and Parent__r.Parent__r.Parent__r.Credential__c = :licenseType and ' + 
            ' Parent__r.Parent__r.Parent__r.Credential_Type__c = :grouping and ';
    public static final String SOQL_PROGRAM_AREA_FILTER = 'Select Name From Application_Field__c where Required__c = true and Object_Name__c = \'Contact\' and Parent__r.Parent__r.Parent__r.Credential__c = :licenseType and ' + 
            ' Parent__r.Parent__r.Parent__r.Program_Area__c = :grouping and '; 
    
    //CreateInspectiononCompletingReview
    public static final String INSPECTION_CHECKLIST_MHC_INSPECTION_CHECKLIST = 'MHC Inspection checklist';
    public static final String INSPECTION_CHECKLIST_POWTS_INSPECTION_REPORT  = 'POWTS INSPECTION REPORT';
    public static final String ANSWER_OBJECT_NAME_NOT_ANSWERED_YET_STRING  = 'Not Answered Yet';
    
    //CredAnsSubmissionTriggerHandler
    public static final String SUBMISSION_OBJECT_FILE_LOCATION_SALESFORCE_STRING = 'Salesforce';
    
    //CredCEhoursFix
    public static final String DOCUMENT_NAME_CE_HOUR_REPORT = 'CEhourreport-';
    public static final String CSV_COLUMN_HEADER = 'Id, Credential CE hours, Actual CE hours, CE Difference\n';
    public static final String CE_HOURS_REPORT_STRING = 'CE Hours Report';
    
    //CredCEhoursScheduler
    public static final String QUERY_LICENSE_ELIGIBLE_STRING = 'Select id, name, CE_Hours__c, Renewal_Cycle_End_Date__c, ' + 
                     'Renewal_window__c, MUSW__Expiration_Date__c, LastModifiedBy.Name ' +
                     'from MUSW__License2__c where CE_Eligible__c = true limit 200';
                     
    //CredentialNotificationScheduler
    public static final String QUERY_CREDENTIAL_NOTIFICATION_SCHEDULER = 'Select Id, Name, MUSW__Applicant__r.FirstName, MUSW__Applicant__r.LastName, MUSW__Applicant__r.Name, MUSW__Primary_Licensee__r.Email_Primary_Contact__c, MUSW__Status__c, ' + 
            'MUSW__Expiration_Date__c, Next_Notification_Date__c, Next_Notification_Attempt__c, Business_License__c, OwnerId,Credential__c, ' + 
            'Is_Renewal_Eligible__c, Account_Email__c,Sub_Status__c ' + 
            ' From MUSW__License2__c where Next_Notification_Date__c = TODAY '+
            ' and (MUSW__Status__c = \'Active\'' +
            ' or (MUSW__Status__c = \'Inactive\' AND Sub_Status__c = \'Expired\'))' ;
    
    //DOL_Batch_ApplictionsStatusUpdate
    public static final String QUERY_DRAFT_APPLICATIONS = 'select id,LastModifiedDate,MUSW__Status__c from MUSW__Application2__c where ((MUSW__Status__c=\'Draft\' OR MUSW__Status__c=\'Withdrawn\') OR (MUSW__Status__c=\'Pending\' OR MUSW__Status__c=\'Under Review\')) OR MUSW__Status__c=\'Abandoned\'';
    public static final String ABANDONED_STRING = 'Abandoned';
    
    //DOL_Batch_LicenseReminderEmail
    public static final String QUERY_ACTIVE_LICENSES = 'select id,LastModifiedDate,MUSW__Status__c,MUSW__Expiration_Date__c,MUSW__Applicant__c,MUSW__Applicant__r.Email,MUSW__Applicant__r.Other_Email__c from MUSW__License2__c where MUSW__Status__c=\'Active\'';
    
    
    //DOL_ContentVersionUtility
    public static final String CONTENT_LOCATION_SALESFORCE_STRING = 'S';
    public static final String CONTENT_DOC_LINK_SHARE_TYPE = 'V';
    
    //DOL_Epayment_ProcessRemittanceData
    public static final String PROCESS_COMPLETED_SUCCESSFULLY = 'Process Completed Successfully';
    public static final String SUCCESSFULL_STRING = 'SUCCESSFUL';
    public static final String FAILED_STRING = 'FAILED';
    
    //DOL_ProcessIntContentDoc_Batch
    public static final String DATA_LOADING_COMPLETED_STRING ='DATA LOADING COMPLETED' ;
    public static final String NCR_STRING = 'NCR';
    public static final String UNPROCESSED_STRING = 'UNPROCESSED';
    public static final String REMITTANCE_STRING = 'REMITTANCE';
    public static final String DOR_STRING = 'DOR';
    
    //DOL_SaveDataForIntegrationBatch
    public static final String CONTENT_VERSION_CREATED_STRING = 'CONTENT VERSION CREATED';
    public static final String INFO_STRING = 'Content Version created , contentDocumentId is ';
    
    //DOL_ePaymentRTPC
    public static final String CREDIT_CARD_STRING = 'Credit Card';
    
    public static final String OUT_OF_THE_STATE = 'Out Of State';
    
    //Dol_BatchMonitoring
    public static final String FAILED_STRING_LOWERCASE = 'failed';
    public static final String SUCCESS_STRING_LOWERCASE = 'success';
    public static final String RUNNING_STRING_SENTANCECASE = 'Running';
    
    //Dol_Batch_UpdtErrorPostElpasedTime
    public static final String ERROR_STRING = 'Error';
    
    //Dol_DeleteAttachmentFromSubmission
    public static final String NO_IMAGE_URL = 'No Image url';
    public static final String FAIL_STRING = 'fail';
    
    //Dol_LoggerInput
    public static final String INFO_STRING_UPPERCASE = 'INFO';
    public static final String ERROR_STRING_UPPERCASE = 'ERROR';
    
    //Dol_RestAPIservice
    public static final string DEV_POLARIS_V1_API_URL = 'https://dol-polaris-exp-dev.us-e2.cloudhub.io/api/v1/sosUbi';
    public static final string DEV_POLARIS_V1_API_URL_GENERATEIMAGETOKEN_URI = 'https://dol-polaris-exp-dev.us-e2.cloudhub.io/api/v1/generateImageToken';
    
    //Dol_ViewTiffFile
    public static final String IMAGE_TOKEN_STRING = 'imageToken';
    
    //ECart_CC
    public static final String CHECKOUT_STRING = 'checkout';
    public static final String DRAFT_STRING = 'Draft';
    
    //Email_Utility
    public static final String THREE_STRING = '3';
    
    public static final String NORMAL_STRING = 'Normal';
    //ExamReschedule
    public static final String EMPTY_SPACE = ' ';
    public static final String ID_STRING = 'Id';
    public static final String SELECT_STRING = 'SELECT'; 
    public static final String CONTACT_ID_EXPLICIT_STRING = '003r000000EOhBB';
    
    //FeePaymentCreatedByDelegate
    public static final String EDIT_STRING = 'Edit';
    public static final String ROW_CAUSE_STRING_CREATE_FEE_PAYMENT_BY_DELEGATE = 'create_Fee_Payment_By_Delegate__c';
    
    //FeePaymentReminderScheduler
    public static final String FINE_PAYMENT_PAST_DUE_STRING = 'Fine Payment Past Due';
    public static final String NOTICE_OF_COLLECTIONS_STRING = 'Notice of Collections';
	
	//MuleApiHeaderConstant
    public static final String MULE_AUTHORIZATION_KEY = 'Authorization';
    public static final String MULE_AUTHORIZATION_VALUE_METADATA_LABEL = 'Mule Authorization Code';
    public static final String MULE_AUTHORIZATION_VALUE_CONSTANT = 'Basic ';
}