public class DOL_AppConstants {

    public static final String ePaymentEncryptionKeyLabel = 'ePayment Encryption Key';
    public static final String ePaymentEncryptionIVLabel = 'ePayment Encryption Init Vector';
    public static final String ePaymentEncryptionAlgoLabel = 'ePayment Encryption Algo Name';
    public static final String ePaymentReturnUrlPortalUser = 'ePayment Return Url Portal User';
    public static final String ePaymentReturnUrlNonPortalUser = 'ePayment Return Url Non Portal User';
    public static final String ePaymentSessionValuesSeperator = '|';
    public static final String ePaymentUrlListValuesSeperator = 'SEPARATOR';
    public static final String sJITErrorMessageOne = 'An SAML error occurred. Please contact us for assistance.';
    public static final String sJITErrorMessageTwo = 'Configuration';
    public static final String sJITErrorMessageThree = 'Missing SAML attributes. Cant initiate JIT creation process. Please check if Custom Label for SAML attributes are set appropriately.';
    public static final String sJITException = 'DOL_JITHandler.JitException';
    public static final String sJITKey = 'IX6Wjpic/pToPXTvi6J0slh9nJuR0sH82+BFsCW13XA=';
    public static final String sJITAlgorithm = 'AES256';
    
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

    
}