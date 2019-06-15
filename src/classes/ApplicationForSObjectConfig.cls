/*************************************************************************************************************
** User Story:
**************************************************************************************************************
** Name                : ApplyForSObjectConfig
** Description         : Configuration class for ApplyForSObjectCtlr class
** Version             : 1.0
** Built By            : 
**------------------------------------------------------------------------------------------------------------
** Modification Log:
**------------------
** Developer                         Date                    Version                      Description
**------------------------------------------------------------------------------------------------------------
**
** Review Log:
**---------------
** Reviewer                  Date           Version               Description
**------------------------------------------------------------------------------------------------------------
**
************************************************************************************/
public class ApplicationForSObjectConfig {
    
    /***************************************************************************************************
* Method       : Factory method
* @Description : We are using the strategy pattern do drive the configuration of the 6
*                different types of objects that the Pages can support
*                (License, Renewal, Permit, Reinstatement, PermitRenewal)
* @see         : ApplyForSObjectCtlr
* @Param       : Application type
* @Return      : ApplyForSObjectConfig object
***************************************************************************************************/
    public static ApplyForSObjectConfig factoryMethod(String applicationType) {
        Set<String> allcredentials =Utilities.getallCredentials();
        Set<String> allplanreviewsandpermits =Utilities.getallPlanreviewsandpermits();
        if (allcredentials.contains(applicationType)) return new LicenseConfig();
        else if (label.RNT_Renewal == applicationType) return new RenewalConfig();
        else if (label.RNT_Reinstatement == applicationType) return new ReinstatementConfig();
        else if (allplanreviewsandpermits.contains(applicationType)) return new PermitConfig();
        else if (label.Str_ManufacturedHomesRenewal  == applicationType) return new RenewalPermitConfig();
        else if (label.STR_Service_Request == applicationType) return new ServiceRequestConfig();
        return null;
    }
    
    /***************************************************************************************************
* Interface for all methods
* @Description : The ApplyForSObjectCtlr, expects a specific subclass of this interface.
*                This interface provides what's different for each subclass.
* @version     : 1.0
***************************************************************************************************/
    public interface ApplyForSObjectConfig {
        String getContactRelationship();
        SObject createInstance();
        String getObjectName();
        String getCurrentRecordWhereClause();
        String getFeeRequirementWhereClause(String currentId);
        String setPageTitle();
        String getQuestionObjectLookup();
        String getAttachmentObjectLookup();
        String getStatusField();
        void getBoardLicenseType(ApplyForSObjectCtlr ctlr);
        void getExistingRecord(ApplyForSObjectCtlr ctlr);
        void setFieldValues(ApplyForSObjectCtlr ctlr);
        void setRecordTypeField(ApplyForSObjectCtlr ctlr);
        void setBoardLicenseType(ApplyForSObjectCtlr ctlr);
        void setLicenseId(ApplyForSObjectCtlr ctlr);
        String getLegalText(ApplyForSObjectCtlr ctlr);
        String getAffidavitLink(ApplyForSObjectCtlr ctlr);
    }
    
    /***************************************************************************************************
* Class for License configuration
* @version     1.0
***************************************************************************************************/
    public class LicenseConfig implements ApplyForSObjectConfig {
        
        /***************************************************************************************************
* @Description : Method to get contact relationship API name
* @Param       : None
* @Return      : String
***************************************************************************************************/
        public String getContactRelationship() {
            return 'MUSW__Applicant__r';
        }
        
        /***************************************************************************************************
* @Description : Method to create instance of main object
* @Param       : None
* @Return      : Instance of main object
***************************************************************************************************/
        public SObject createInstance() {
            return new MUSW__License2__c();
        }
        
        /***************************************************************************************************
* @Description : Method to get main object API name
* @Param       : None
* @Return      : String
***************************************************************************************************/
        public String getObjectName() {
            return label.API_License2;
        }
        
        /***************************************************************************************************
* @Description : Method to get current record where clause
* @Param       : None
* @Return      : String
***************************************************************************************************/
        public String getCurrentRecordWhereClause() {
            return ' from MUSW__License2__c where Id =: existingRecId ';
        }
        
        /***************************************************************************************************
* @Description : Method to get fee requirement where clause
* @Param       : Current record Id
* @Return      : String
***************************************************************************************************/
        public String getFeeRequirementWhereClause(String currentId) {
            return ' No_Fee__c from MUSW__License2__c where Id = \'' + currentId + '\'';
        }
        
        /***************************************************************************************************
* @Description : Method to set page title
* @Param       : None
* @Return      : String
***************************************************************************************************/
        public String setPageTitle() {
            return 'New License Application';
        }
        
        /***************************************************************************************************
* @Description : Method to get endorsement lookup field
* @Param       : None
* @Return      : String
***************************************************************************************************/
        public String getQuestionObjectLookup() {
            return label.API_License_Field;
        }
        
        /***************************************************************************************************
* @Description : Method to get attachment object lookup field
* @Param       : None
* @Return      : String
***************************************************************************************************/
        public String getAttachmentObjectLookup() {
            return label.API_License22;
        }
        
        /***************************************************************************************************
* @Description : Method to get status field
* @Param       : None
* @Return      : String
***************************************************************************************************/
        public String getStatusField() {
            return label.Api_Musw_Status;
        }
        
        /***************************************************************************************************
* @Description : Method to get global parameters
* @Param       : ApplyForSObjectCtlr instance
* @Return      : void
***************************************************************************************************/
        public void getBoardLicenseType(ApplyForSObjectCtlr ctlr) {
            String existingId = ctlr.existingRecId;
            if ( ctlr.existingRecId != null ) {
                String currQuery = 'SELECT Id, MUSW__Type__c, Application_Type__c, Application_method__C,Credential__c,Credential_Type__c, MUSW__Primary_Licensee__c, Business_License__c '
                    + ' from MUSW__License2__c where Id = :ctlr.existingId ';
                SObject existingObj = Database.query(currQuery);
                ctlr.credentialtype = (String) existingObj.get(label.Api_credential_type);                
                ctlr.credential = (String) existingObj.get(label.API_credential);
                ctlr.applicationmethod = (String) existingObj.get(label.API_Application_method);
                ctlr.applicationType =  (String) existingObj.get(label.Api_Application_Type);
                ctlr.licenseGlobalData.licenseId = existingId;                
                if ((existingObj.get(label.API_MUSW_Primary_Licensee_c) != null) && (existingObj.get(label.API_Business_License) == true)) {
                    ctlr.accountId = (String) existingObj.get(label.API_MUSW_Primary_Licensee_c);
                }
            }
        }
        
        /***************************************************************************************************
* @Description : Method to get existing main object record
* @Param       : ApplyForSObjectCtlr instance
* @Return      : void
***************************************************************************************************/
        public void getExistingRecord(ApplyForSObjectCtlr ctlr) {
            String parentId = ctlr.parentId;
            String credentialtype = ctlr.credentialtype;
            String credential = ctlr.credential;
            String applicationmethod = ctlr.applicationmethod;
            String contactId = ctlr.contactId;
            String accountId = ctlr.accountId;
            List<MUSW__License2__c> newLicObj = new List<MUSW__License2__c>();
          // try {
                //todo Licensed_By__c = :licenseBy    
                System.debug('credentialtype '+ credentialtype +'  '+contactid);                         
                newLicObj = [SELECT Id,Credential__c,MUSW__Status__c FROM MUSW__License2__c
                             WHERE Credential__c = :credential
                             AND MUSW__Applicant__c = :contactId];

                if (String.isNotBlank(accountId)) {
                    newLicObj = [SELECT Id,Credential__c, MUSW__Status__c FROM MUSW__License2__c
                                 WHERE Credential__c = :credential
                                 AND MUSW__Applicant__c = :contactId
                                 AND MUSW__Primary_Licensee__c = :accountId];
                }
                for (MUSW__License2__c l : newLicObj) {
                    if(Label.CR_Manufactured_Homes_Certificate_of_Title!=l.credential__c){
                    if (l.MUSW__Status__c == label.ST_Pending) {
                        ctlr.existingRecId = l.Id;
                    } /*else if ((ctlr.pageName.containsIgnoreCase('Application')) && (l.MUSW__Status__c == label.ST_Generate_Fee || l.MUSW__Status__c == label.ST_Submitted || l.MUSW__Status__c == label.ST_Complete || l.MUSW__Status__c == label.ST_Active)) {
                         throw new CustomException('Cannot apply for new license when an existing record has a status of ' + l.MUSW__Status__c);
                        
                    }*/
                    }
                }
                
           // }
           // catch(Exception e) { System.debug('--->No existing license record. ' + e); }
        }
        
        /***************************************************************************************************
* @Description : Method to set field values into main object
* @Param       : ApplyForSObjectCtlr instance
* @Return      : void
***************************************************************************************************/
        public void setFieldValues(ApplyForSObjectCtlr ctlr) {
            // Set field values
            ctlr.lic.put(label.Api_Credential_Type, ctlr.credentialtype);
            
            ctlr.lic.put(label.Api_Credential, ctlr.credential);
            ctlr.lic.put(label.Api_Application_type, ctlr.applicationtype);
            ctlr.lic.put(label.API_MUSW_Applicant, ctlr.contactObj.Id);
            ctlr.lic.put(label.API_Application_Method, ctlr.applicationmethod);
            if (ctlr.accountId != null) {
                ctlr.lic.put(label.API_MUSW_Primary_Licensee_c, ctlr.accountId);
            }
        }
        
        /***************************************************************************************************
* @Description : Method to set record type
* @Param       : ApplyForSObjectCtlr instance
* @Return      : void
***************************************************************************************************/
        public void setRecordTypeField(ApplyForSObjectCtlr ctlr) {
            // Set field values
           ctlr.lic.put('RecordTypeId', ctlr.findRecordTypeIdForBoardAndLicenseType(ctlr.credentialtype, ctlr.credential, getObjectName()));
        }
        
        /***************************************************************************************************
* @Description : Method to set Functionalarea and license type
* @Param       : ApplyForSObjectCtlr instance
* @Return      : void
***************************************************************************************************/
        public void setBoardLicenseType(ApplyForSObjectCtlr ctlr) {}
        
        /***************************************************************************************************
* @Description : Method to set license Id in global license object
* @Param       : ApplyForSObjectCtlr instance
* @Return      : void
***************************************************************************************************/
        public void setLicenseId(ApplyForSObjectCtlr ctlr) {
            
        System.debug('ctrl.lic '+ctlr.lic);
             System.debug((String)ctlr.lic.get('Id'));
            ctlr.licenseGlobalData.licenseId = (String)ctlr.lic.get('Id');
        }
        
        /***************************************************************************************************
* @Description : Method to get legal text
* @Param       : ApplyForSObjectCtlr instance
* @Return      : String
***************************************************************************************************/
        public String getLegalText(ApplyForSObjectCtlr ctlr) {
           /* String legalText = [SELECT Instructions__c FROM Newsfeed__c
                                WHERE Application_Type__c = :ctlr.applicationType
                                AND Credential_Type__c = :ctlr.credentialType
                                AND Credential__c = :ctlr.credential
                                AND (Application_Method__c = :ctlr.applicationMethod OR Application_Method__c = 'All')
                                //AND RecordType.Name = :label.RT_Attestation_Line
                                //AND Show_For__c INCLUDES (:label.Str_Credential)
                                LIMIT 1].Instructions__c;*/
            String legalText='';
           // List<String> listLegalText = new List<String>();
           List<Newsfeed__c> listLegalText = [SELECT Instructions__c FROM Newsfeed__c
                                WHERE Application_Type__c = :ctlr.applicationType
                                AND Credential_Type__c = :ctlr.credentialType
                                AND Credential__c = :ctlr.credential
                                AND (Application_Method__c = :ctlr.applicationMethod OR Application_Method__c = 'All')
                                LIMIT 1];
            if(listLegalText != null){
                legalText = String.valueof(listLegalText[0].Instructions__c);
            } else {
                legalText ='';
            }
            
            return legalText;
        }
        
        /***************************************************************************************************
* @Description : Method to get affidavit link
* @Param       : ApplyForSObjectCtlr instance
* @Return      : String
***************************************************************************************************/
        public String getAffidavitLink(ApplyForSObjectCtlr ctlr) {
            String affidavitLink = [SELECT Link__c FROM Newsfeed__c
                                    WHERE Application_Type__c = :ctlr.applicationType
                                    AND Credential_Type__c = :ctlr.credentialType
                                    AND Credential__c = :ctlr.credential
                                    AND (Application_Method__c = :ctlr.applicationMethod OR Application_Method__c = 'All')
                                    AND RecordType.Name = :label.RT_Affidavit_Link
                                    AND Show_For__c INCLUDES (:label.Str_Credential)
                                    LIMIT 1].Link__c;
            
            return affidavitLink;
        }
    }
    
    /***************************************************************************************************
* Class for License configuration
* @version     1.0
***************************************************************************************************/
    public class PermitConfig implements ApplyForSObjectConfig { 
         
        /***************************************************************************************************
* @Description : Method to get contact relationship API name
* @Param       : None
* @Return      : String
***************************************************************************************************/
        public String getContactRelationship() {
            return 'MUSW__Applicant__r';
        }
        
        /***************************************************************************************************
* @Description : Method to create instance of main object
* @Param       : None
* @Return      : Instance of main object
***************************************************************************************************/
        public SObject createInstance() {
            return new MUSW__Permit2__c();
        }
        
        /***************************************************************************************************
* @Description : Method to get main object API name
* @Param       : None
* @Return      : String
***************************************************************************************************/
        public String getObjectName() {
            return label.API_MUSW_Permit2;
        }
        
        /***************************************************************************************************
* @Description : Method to get current record where clause
* @Param       : None
* @Return      : String
***************************************************************************************************/
        public String getCurrentRecordWhereClause() {
            return ' from MUSW__Permit2__c where Id =: existingRecId ';
        }
        
        /***************************************************************************************************
* @Description : Method to get fee requirement where clause
* @Param       : Current record Id
* @Return      : String
***************************************************************************************************/
        public String getFeeRequirementWhereClause(String currentId) {
            return ' Generate_Invoice__c from MUSW__Permit2__c where Id = \'' + currentId + '\'';
        }
        
        /***************************************************************************************************
* @Description : Method to set page title
* @Param       : None
* @Return      : String
***************************************************************************************************/
        public String setPageTitle() {
            return 'New Application';
        }
        
        /***************************************************************************************************
* @Description : Method to get endorsement lookup field
* @Param       : None
* @Return      : String
***************************************************************************************************/
        public String getQuestionObjectLookup() {
            //todo
            return label.Api_Permitfield;
        }
        
        /***************************************************************************************************
* @Description : Method to get attachment object lookup field
* @Param       : None
* @Return      : String
***************************************************************************************************/
        public String getAttachmentObjectLookup() {
            return label.Api_Permitfield;
        }
        
        /***************************************************************************************************
* @Description : Method to get status field
* @Param       : None
* @Return      : String
***************************************************************************************************/
        public String getStatusField() {
            return label.Api_Musw_Status;
        }
        
        /***************************************************************************************************
* @Description : Method to get global parameters
* @Param       : ApplyForSObjectCtlr instance
* @Return      : void
***************************************************************************************************/
        public void getBoardLicenseType(ApplyForSObjectCtlr ctlr) {
            String existingId = ctlr.existingRecId;
            if ( ctlr.existingRecId != null ) {
                String currQuery = 'SELECT Id, MUSW__Type__c,Application_Type__c,Program_Area__c ,Business_License__c, Permit_Type__c,MUSW__Applicant__c, MUSW__Account__c '
                    + ' from MUSW__Permit2__c where Id = :ctlr.existingId ';
                SObject existingObj = Database.query(currQuery);
                ctlr.permittype = (String) existingObj.get(label.Api_Permit_Type);
                ctlr.applicationType = label.API_Permit;
                ctlr.licenseGlobalData.permitid = existingId;
                   ctlr.applicationType =  (String) existingObj.get(label.Api_Application_Type);
                ctlr.programArea= (String) existingObj.get(label.Api_Program_Area);
                if ((existingObj.get(Label.API_Account_Permit) != null) && (existingObj.get(label.API_Business_License) == true)) {
                    ctlr.accountId = (String) existingObj.get(Label.API_Account_Permit);
                }
            }
        }
        
        /***************************************************************************************************
* @Description : Method to get existing main object record
* @Param       : ApplyForSObjectCtlr instance
* @Return      : void
***************************************************************************************************/
        public void getExistingRecord(ApplyForSObjectCtlr ctlr) {
            String parentId = ctlr.parentId;
            String programArea = ctlr.programArea;
            String permitType = ctlr.permitType;
            String applicationmethod = ctlr.applicationmethod;
            String contactId = ctlr.contactId;
            String accountId = ctlr.accountId;
            
            /*List<MUSW__Permit2__c> newPermitObj = new List<MUSW__Permit2__c>();
                try {
                //todo Licensed_By__c = :licenseBy                             
                newPermitObj = [SELECT Id,MUSW__Status__c FROM MUSW__Permit2__c
                                WHERE Permit_Type__c = :permitType
                                AND MUSW__Applicant__c = :contactId];
                if (String.isNotBlank(accountId)) {
                    newPermitObj = [SELECT Id, MUSW__Status__c FROM MUSW__Permit2__c
                                    WHERE Permit_Type__c = :permitType
                                    AND MUSW__Applicant__c = :contactId
                                    AND MUSW__Account__c     = :accountId];
                }
                for (MUSW__Permit2__c l : newPermitObj) {
                    System.debug('l.MUSW__Status__c '+l.MUSW__Status__c);
                    if (l.MUSW__Status__c == label.ST_Pending) {
                        ctlr.existingRecId = l.Id;
                    } else if ((ctlr.pageName.containsIgnoreCase('Application')) && (l.MUSW__Status__c == label.ST_Generate_Fee || l.MUSW__Status__c == label.ST_Submitted || l.MUSW__Status__c == label.ST_Complete || l.MUSW__Status__c == label.ST_Active)) {
                         throw new CustomException('Cannot apply for new license when an existing record has a status of ' + l.MUSW__Status__c);
 
                    }
                }
                
           }
           catch(Exception e) { System.debug('--->No existing license record. ' + e); }
*/
        }
        
        /***************************************************************************************************
* @Description : Method to set field values into main object
* @Param       : ApplyForSObjectCtlr instance
* @Return      : void
***************************************************************************************************/
        public void setFieldValues(ApplyForSObjectCtlr ctlr) {
            // Set field values
             ctlr.lic.put(label.Api_Application_type, ctlr.applicationtype);
            ctlr.lic.put(label.Api_Permit_Type, ctlr.permitType);
            ctlr.lic.put(label.API_Program_Area, ctlr.programArea);
            ctlr.lic.put(label.API_MUSW_Applicant, ctlr.contactObj.Id);
            if(label.Str_plan_review == ctlr.applicationType){
                 ctlr.lic.put(label.Api_Object_Type,label.Str_plan_review);
            }
            else{
                ctlr.lic.put(label.Api_Object_Type, label.Str_Permit );
            }
            if (ctlr.accountId != null) {
                ctlr.lic.put(label.API_Account_Permit, ctlr.accountId);
            }
        }
        
        /***************************************************************************************************
* @Description : Method to set record type
* @Param       : ApplyForSObjectCtlr instance
* @Return      : void
***************************************************************************************************/
        public void setRecordTypeField(ApplyForSObjectCtlr ctlr) {
            // Set field values
            ctlr.lic.put('RecordTypeId', ctlr.findRecordTypeIdForBoardAndLicenseType(ctlr.programArea, ctlr.permitType, getObjectName()));
        }
        
        /***************************************************************************************************
* @Description : Method to set Functionalarea and license type
* @Param       : ApplyForSObjectCtlr instance
* @Return      : void
***************************************************************************************************/
        public void setBoardLicenseType(ApplyForSObjectCtlr ctlr) {}
        
        /***************************************************************************************************
* @Description : Method to set license Id in global license object
* @Param       : ApplyForSObjectCtlr instance
* @Return      : void
***************************************************************************************************/
        public void setLicenseId(ApplyForSObjectCtlr ctlr) {
            ctlr.licenseGlobalData.permitid = (String)ctlr.lic.get('Id');
        }
        
        /***************************************************************************************************
* @Description : Method to get legal text for Permit
* @Param       : ApplyForSObjectCtlr instance
* @Return      : String
***************************************************************************************************/
        public String getLegalText(ApplyForSObjectCtlr ctlr) { 
            String legalText = [SELECT Instructions__c FROM Newsfeed__c
                                         WHERE Application_Type__c = :ctlr.applicationType
                                         AND Program_Area__c = :ctlr.programArea                                
                                         AND Permit_Type__c = :ctlr.permitType
                                         AND RecordType.Name = :label.RT_Attestation_Line
                                         AND Show_For__c INCLUDES (:label.Str_Permit)
                                         LIMIT 1].Instructions__c;
            return legalText;
        }
        
        /***************************************************************************************************
* @Description : Method to get affidavit link
* @Param       : ApplyForSObjectCtlr instance
* @Return      : String
***************************************************************************************************/
        public String getAffidavitLink(ApplyForSObjectCtlr ctlr) {
             String affidavitLink = [SELECT Link__c FROM Newsfeed__c
                                 WHERE Application_Type__c = :ctlr.applicationType
                                 AND Program_Area__c = :ctlr.programArea                                
                                 AND Permit_Type__c = :ctlr.permitType
                                 AND RecordType.Name = :label.RT_Affidavit_Link
                                 AND Show_For__c INCLUDES (:label.Str_Permit)
                                 LIMIT 1].Link__c;
          
            
            return affidavitLink;
        }
    }
    
    public class RenewalConfig implements ApplyForSObjectConfig {
        
        /***************************************************************************************************
* @Description : Method to get contact relationship API name
* @Param       : None
* @Return      : String
***************************************************************************************************/
        public String getContactRelationship() {
            return 'Applicant__r';
        }
        
        /***************************************************************************************************
* @Description : Method to create instance of main object
* @Param       : None
* @Return      : Instance of main object
***************************************************************************************************/
        public SObject createInstance() {
            return new Renewal_Application__c();
        }
        
        /***************************************************************************************************
* @Description : Method to get main object API name
* @Param       : None
* @Return      : String
***************************************************************************************************/
        public String getObjectName() {
            return label.API_Renewal_Application;
        }
        
        /***************************************************************************************************
* @Description : Method to get current record where claus
* @Param       : None
* @Return      : String
***************************************************************************************************/
        public String getCurrentRecordWhereClause() {
            return ' from Renewal_Application__c where Id =: existingRecId ';
        }
        
        /***************************************************************************************************
* @Description : Method to get fee requirement where clause
* @Param       : Current record Id
* @Return      : String
***************************************************************************************************/
        public String getFeeRequirementWhereClause(String currentId) {
            return 'Id,No_Fee__c,Generate_Invoice__c from Renewal_Application__c where Id = \'' + currentId + '\'';
        }
        
        /***************************************************************************************************
* @Description : Method to set page title
* @Param       : None
* @Return      : String
***************************************************************************************************/
        public String setPageTitle() {
            return label.Str_Renewal_Application;
        }
        
        /***************************************************************************************************
* @Description : Method to get endorsement lookup field
* @Param       : None
* @Return      : String
***************************************************************************************************/
        public String getQuestionObjectLookup() {
            return label.API_Renewal_Application;
        }
        
        /***************************************************************************************************
* @Description : Method to get attachment object lookup field
* @Param       : None
* @Return      : String
***************************************************************************************************/
        public String getAttachmentObjectLookup() {
            return label.API_Renewal_Application;
        }
        
        /***************************************************************************************************
* @Description : Method to get status field
* @Param       : None
* @Return      : String
***************************************************************************************************/
        public String getStatusField() {
            return label.API_Renewal_Status;
        }
        
        /***************************************************************************************************
* @Description : Method to get global parameters
* @Param       : ApplyForSObjectCtlr instance
* @Return      : void
***************************************************************************************************/
        public void getBoardLicenseType(ApplyForSObjectCtlr ctlr) {
            String existingId = ctlr.existingRecId;
            if ( ctlr.existingRecId != null ) {
                String currQuery = 'SELECT Id, Credential_Type__c,Credential__c, Licensee__c, Business_license__c'
                    + ' from Renewal_Application__c where Id = :existingId ';
                SObject existingObj = Database.query(currQuery);
                ctlr.credential = (String) existingObj.get(label.Api_Credential);
                ctlr.credentialtype = (String) existingObj.get(label.Api_Credential_Type);

                
                if ((existingObj.get(label.Api_Licensee) != null) && (existingObj.get(label.API_Business_License) == true)) {
                    ctlr.accountId = (String) existingObj.get(label.Api_Licensee);
                }
            }
            ctlr.licenseGlobalData.licenseId = ctlr.parentId;
        }
        
        /***************************************************************************************************
* @Description : Method to get existing main object record
* @Param       : ApplyForSObjectCtlr instance
* @Return      : void
***************************************************************************************************/
        public void getExistingRecord(ApplyForSObjectCtlr ctlr) {
            
            String parentId = ctlr.parentId;
            String credentialtype = ctlr.credentialtype;
            String credential = ctlr.credential;
            String licenseBy = ctlr.licenseBy;
            String contactId = ctlr.contactId;
            String accountId = ctlr.accountId;
            List<Renewal_Application__c> newLicObj = new List<Renewal_Application__c>();
            newLicObj = [SELECT Id, Renewal_Status__c FROM Renewal_Application__c
                         WHERE License__c = :parentId
                         AND Renewal_Reinstatement_Type__c = :label.RNT_Renewal
                         AND Credential_Type__c = :credentialtype
                         AND Applicant__c = :contactId];
            
            for (Renewal_Application__c l : newLicObj) {
                if (l.Renewal_Status__c == label.ST_Incomplete) {
                    ctlr.existingRecId = l.Id;
                } else if ((ctlr.pageName.containsIgnoreCase('Application')) && (l.Renewal_Status__c == label.ST_Generate_Fee || l.Renewal_Status__c == label.ST_Submitted)) {
                      throw new CustomException('Cannot apply for Credential renewal when an existing record has a status of ' + l.Renewal_Status__c);
                }
            }
        }
        
        /***************************************************************************************************
* @Description : Method to set field values into main object
* @Param       : ApplyForSObjectCtlr instance
* @Return      : void
***************************************************************************************************/
        public void setFieldValues(ApplyForSObjectCtlr ctlr) {
            
            // Set field values
            ctlr.lic.put(label.Api_Credential_Type, ctlr.credentialtype);
            ctlr.lic.put(label.Api_Credential, ctlr.credential);
            ctlr.lic.put(label.API_License_Field, ctlr.parentId);
            ctlr.lic.put(label.Api_Renewal_Type, Label.RNT_Renewal);
            ctlr.lic.put(label.Api_Applicant_c, ctlr.contactObj.Id);
            ctlr.lic.put(label.Api_Renewal_Status, label.ST_Incomplete);
            // For business application
            if (ctlr.accountId != null) {
                ctlr.lic.put(label.API_Licensee, ctlr.accountId);
            }
        }
        
        /***************************************************************************************************
* @Description : Method to set record type
* @Param       : ApplyForSObjectCtlr instance
* @Return      : void
***************************************************************************************************/
        public void setRecordTypeField(ApplyForSObjectCtlr ctlr) {
            // Set field values
            ctlr.lic.put('RecordTypeId', ctlr.findRecordTypeIdForBoardAndLicenseType(ctlr.credentialtype, ctlr.credential, getObjectName()));
        }
        
        /***************************************************************************************************
* @Description : Method to set board and license type
* @Param       : ApplyForSObjectCtlr instance
* @Return      : void
***************************************************************************************************/
        public void setBoardLicenseType(ApplyForSObjectCtlr ctlr) {}
        
        /***************************************************************************************************
* @Description : Method to set license Id in global license object
* @Param       : ApplyForSObjectCtlr instance
* @Return      : void
***************************************************************************************************/
        public void setLicenseId(ApplyForSObjectCtlr ctlr) {
            ctlr.licenseGlobalData.licenseId = ctlr.parentId;
        }
        
        /***************************************************************************************************
* @Description : Method to get legal text for License/Credential Renewal
* @Param       : ApplyForSObjectCtlr instance
* @Return      : String
***************************************************************************************************/
        public String getLegalText(ApplyForSObjectCtlr ctlr) {
            String query= '   '+ctlr.credentialType+'  '+ctlr.credential+'  '+ctlr.applicationMethod+'  '+label.RT_Attestation_Line+'  '+label.Str_Credential_Renewal;
            String legalText = [SELECT Instructions__c FROM Newsfeed__c
                                WHERE Credential_Type__c = :ctlr.credentialType
                                AND Credential__c = :ctlr.credential
                                AND (Application_Method__c = :ctlr.applicationMethod OR Application_Method__c = 'All')
                                AND RecordType.Name = :label.RT_Attestation_Line
                                AND Show_For__c INCLUDES (:label.Str_Credential_Renewal)
                                LIMIT 1].Instructions__c;           
            return legalText;
        }
        
        /***************************************************************************************************
* @Description : Method to get affidavit link
* @Param       : ApplyForSObjectCtlr instance
* @Return      : String
***************************************************************************************************/
        public String getAffidavitLink(ApplyForSObjectCtlr ctlr) {
            String affidavitLink = [SELECT Link__c FROM Newsfeed__c
                                    WHERE Application_Type__c = :ctlr.applicationType
                                    AND Credential_Type__c = :ctlr.credentialType
                                    AND Credential__c = :ctlr.credential
                                    AND (Application_Method__c = :ctlr.applicationMethod OR Application_Method__c = 'All')
                                    AND RecordType.Name = :label.RT_Affidavit_Link
                                    AND Show_For__c INCLUDES (:label.Str_Credential_Renewal)
                                    LIMIT 1].Link__c;
            
            return affidavitLink;
        }
    }
    
    public class RenewalPermitConfig implements ApplyForSObjectConfig {
        
        /***************************************************************************************************
* @Description : Method to get contact relationship API name
* @Param       : None
* @Return      : String
***************************************************************************************************/
        public String getContactRelationship() {
            return 'Applicant__r';
        }
        
        /***************************************************************************************************
* @Description : Method to create instance of main object
* @Param       : None
* @Return      : Instance of main object
***************************************************************************************************/
        public SObject createInstance() {
            return new Renewal_Application__c();
        }
        
        /***************************************************************************************************
* @Description : Method to get main object API name
* @Param       : None
* @Return      : String
***************************************************************************************************/
        public String getObjectName() {
            return label.API_Renewal_Application;
        }
        
        /***************************************************************************************************
* @Description : Method to get current record where clause
* @Param       : None
* @Return      : String
***************************************************************************************************/
        public String getCurrentRecordWhereClause() {
            return ' from Renewal_Application__c where Id =: existingRecId ';
        }
        
        /***************************************************************************************************
* @Description : Method to get fee requirement where clause
* @Param       : Current record Id
* @Return      : String
***************************************************************************************************/
        public String getFeeRequirementWhereClause(String currentId) {
            return 'Id,No_Fee__c,Generate_Invoice__c from Renewal_Application__c where Id = \'' + currentId + '\'';
        }
        
        /***************************************************************************************************
* @Description : Method to set page title
* @Param       : None
* @Return      : String
***************************************************************************************************/
        public String setPageTitle() {
            return label.Str_Renewal_Application;
        }
        
        /***************************************************************************************************
* @Description : Method to get endorsement lookup field
* @Param       : None
* @Return      : String
***************************************************************************************************/
        public String getQuestionObjectLookup() {
            return label.API_Renewal_Application;
        }
        
        /***************************************************************************************************
* @Description : Method to get attachment object lookup field
* @Param       : None
* @Return      : String
***************************************************************************************************/
        public String getAttachmentObjectLookup() {
            return label.API_Renewal_Application;
        }
        
        /***************************************************************************************************
* @Description : Method to get status field
* @Param       : None
* @Return      : String
***************************************************************************************************/
        public String getStatusField() {
            return label.API_Renewal_Status;
        }
        
        /***************************************************************************************************
* @Description : Method to get global parameters
* @Param       : ApplyForSObjectCtlr instance
* @Return      : void
***************************************************************************************************/
        public void getBoardLicenseType(ApplyForSObjectCtlr ctlr) {
            String existingId = ctlr.existingRecId;
            if ( ctlr.existingRecId != null ) {
                String currQuery = 'SELECT Id,Program_Area__c, Renewal_Reinstatement_Type__c , Licensee__c, Business_License__c,Credential__c, Credential_Type__c, Permit_Type__c '
                    + ' from Renewal_Application__c where Id = :existingId ';
                SObject existingObj = Database.query(currQuery);
                ctlr.programarea = (String) existingObj.get(label.Api_Program_Area);
                ctlr.permittype = (String) existingObj.get(label.Api_Permit_Type);
                
                if ((existingObj.get(label.Api_Licensee) != null) && (existingObj.get(label.API_Business_License) == true)) {
                    ctlr.accountId = (String) existingObj.get(label.Api_Licensee);
                }
            }
            ctlr.licenseGlobalData.permitid = ctlr.parentId;
        }
        
        /***************************************************************************************************
* @Description : Method to get existing main object record
* @Param       : ApplyForSObjectCtlr instance
* @Return      : void
***************************************************************************************************/
        public void getExistingRecord(ApplyForSObjectCtlr ctlr) {
            
            String parentId = ctlr.parentId;
            String programarea = ctlr.programarea;
            String permittype = ctlr.permittype;
            String licenseBy = ctlr.licenseBy;
            String contactId = ctlr.contactId;
            String accountId = ctlr.accountId;

            List<Renewal_Application__c> newLicObj = new List<Renewal_Application__c>();
            newLicObj = [SELECT Id, Renewal_Status__c FROM Renewal_Application__c
                         WHERE Permit__c = :parentId
                         AND Renewal_Reinstatement_Type__c = :label.RNT_RenewalPTO
                         AND Permit_Type__c = :permittype
                         AND Applicant__c = :contactId];
            
            for (Renewal_Application__c l : newLicObj) {
                if (l.Renewal_Status__c == label.ST_Incomplete) {
                    ctlr.existingRecId = l.Id;
                } else if ((ctlr.pageName.containsIgnoreCase('Application')) && (l.Renewal_Status__c == label.ST_Generate_Fee || l.Renewal_Status__c == label.ST_Submitted)) {
                     throw new CustomException('Cannot apply for Permit renewal when an existing record has a status of ' + l.Renewal_Status__c);
                }
            }
        }
        
        /***************************************************************************************************
* @Description : Method to set field values into main object
* @Param       : ApplyForSObjectCtlr instance
* @Return      : void
***************************************************************************************************/
        public void setFieldValues(ApplyForSObjectCtlr ctlr) {
            
            // Set field values
            ctlr.lic.put(label.Api_Program_Area, ctlr.programarea);
            ctlr.lic.put(label.Api_Permit_Type, ctlr.permittype);
            ctlr.lic.put(label.Api_Permitfield, ctlr.parentId);
            ctlr.lic.put(label.Api_Renewal_Type, Label.RNT_RenewalPTO);
            ctlr.lic.put(label.Api_Applicant_c, ctlr.contactObj.Id);
            ctlr.lic.put(label.Api_Renewal_Status, label.ST_Incomplete);
            
            // For business application
            if (ctlr.accountId != null) {
                ctlr.lic.put(label.API_Licensee, ctlr.accountId);
            }
        }
        
        /***************************************************************************************************
* @Description : Method to set record type
* @Param       : ApplyForSObjectCtlr instance
* @Return      : void
***************************************************************************************************/
        public void setRecordTypeField(ApplyForSObjectCtlr ctlr) {
            // Set field values
            ctlr.lic.put('RecordTypeId', ctlr.findRecordTypeIdForBoardAndLicenseType(ctlr.programarea, ctlr.permittype, getObjectName()));
        }
        
        /***************************************************************************************************
* @Description : Method to set board and license type
* @Param       : ApplyForSObjectCtlr instance
* @Return      : void
***************************************************************************************************/
        public void setBoardLicenseType(ApplyForSObjectCtlr ctlr) {}
        
        /***************************************************************************************************
* @Description : Method to set license Id in global license object
* @Param       : ApplyForSObjectCtlr instance
* @Return      : void
***************************************************************************************************/
        public void setLicenseId(ApplyForSObjectCtlr ctlr) {
            ctlr.licenseGlobalData.permitId = ctlr.parentId;
        }
        
        /***************************************************************************************************
* @Description : Method to get legal text
* @Param       : ApplyForSObjectCtlr instance
* @Return      : String
***************************************************************************************************/
        public String getLegalText(ApplyForSObjectCtlr ctlr) { 
            String legalText = [SELECT Instructions__c FROM Newsfeed__c
                                         WHERE Program_Area__c = :ctlr.programArea                                
                                         AND Permit_Type__c = :ctlr.permitType
                                         AND RecordType.Name = :label.RT_Attestation_Line
                                         AND Show_For__c INCLUDES (:label.Str_Permit_Renewal)
                                         LIMIT 1].Instructions__c;
            return legalText;
        }
        
        /***************************************************************************************************
* @Description : Method to get affidavit link
* @Param       : ApplyForSObjectCtlr instance
* @Return      : String
***************************************************************************************************/
        public String getAffidavitLink(ApplyForSObjectCtlr ctlr) {
             String affidavitLink = [SELECT Link__c FROM Newsfeed__c
                                 WHERE Program_Area__c = :ctlr.programArea                                
                                 AND Permit_Type__c = :ctlr.permitType
                                 AND RecordType.Name = :label.RT_Affidavit_Link
                                 AND Show_For__c INCLUDES (:label.Str_Permit_Renewal)
                                 LIMIT 1].Link__c;
          
            
            return affidavitLink;
        }
    
    }
     
    public class ReinstatementConfig implements ApplyForSObjectConfig {
        
        /***************************************************************************************************
* @Description : Method to get contact relationship API name
* @Param       : None
* @Return      : String
***************************************************************************************************/
        public String getContactRelationship() {
            return 'Applicant__r';
        }
        
        /***************************************************************************************************
* @Description : Method to create instance of main object
* @Param       : None
* @Return      : Instance of main object
***************************************************************************************************/
        public SObject createInstance() {
            return new Renewal_Application__c();
        }
        
        /***************************************************************************************************
* @Description : Method to get main object API name
* @Param       : None
* @Return      : String
***************************************************************************************************/
        public String getObjectName() {
            return label.API_Renewal_Application;
        }
        
        /***************************************************************************************************
* @Description : Method to get current record where claus
* @Param       : None
* @Return      : String
***************************************************************************************************/
        public String getCurrentRecordWhereClause() {
            return ' from Renewal_Application__c where Id =: existingRecId ';
        }
        
        /***************************************************************************************************
* @Description : Method to get fee requirement where clause
* @Param       : Current record Id
* @Return      : String
***************************************************************************************************/
        public String getFeeRequirementWhereClause(String currentId) {
            return 'Id ,No_Fee__c,Generate_Invoice__c from Renewal_Application__c where Id = \'' + currentId + '\'';
        }
        
        /***************************************************************************************************
* @Description : Method to set page title
* @Param       : None
* @Return      : String
***************************************************************************************************/
        public String setPageTitle() {
            return label.Str_Reinstatement_Application;
        }
        
        /***************************************************************************************************
* @Description : Method to get endorsement lookup field
* @Param       : None
* @Return      : String
***************************************************************************************************/
        public String getQuestionObjectLookup() {
            return label.API_Renewal_Application;
        }
        
        /***************************************************************************************************
* @Description : Method to get attachment object lookup field
* @Param       : None
* @Return      : String
***************************************************************************************************/
        public String getAttachmentObjectLookup() {
            return label.API_Renewal_Application;
        }
        
        /***************************************************************************************************
* @Description : Method to get status field
* @Param       : None
* @Return      : String
***************************************************************************************************/
        public String getStatusField() {
            return label.API_Renewal_Status;
        }
        
        /***************************************************************************************************
* @Description : Method to get global parameters
* @Param       : ApplyForSObjectCtlr instance
* @Return      : void
***************************************************************************************************/
        public void getBoardLicenseType(ApplyForSObjectCtlr ctlr) {
            String existingId = ctlr.existingRecId;
            if ( ctlr.existingRecId != null ) {
                String currQuery = 'SELECT Id, Program_Area__c, Renewal_Reinstatement_Type__c , Licensee__c, Business_License__c ,Credential__c, Credential_Type__c, Permit_Type__c'
                    + ' from Renewal_Application__c where Id = :existingId ';
                SObject existingObj = Database.query(currQuery);
                ctlr.credentialtype = (String) existingObj.get(label.Api_Credential_type);
                ctlr.credential = (String) existingObj.get(label.Api_Credential);
                System.debug('tata');
                if ((existingObj.get(label.Api_Licensee) != null) && (existingObj.get(label.API_Business_License) == true)) {
                    ctlr.accountId = (String) existingObj.get(label.Api_Licensee);
                }
                System.debug('tata');
            }
            System.debug('ctlr.licenseGlobalData.licenseId = ctlr.parentId; '+ctlr.licenseGlobalData.licenseId +'  '+ctlr.parentId);
            ctlr.licenseGlobalData.licenseId = ctlr.parentId;
        }
        
        /***************************************************************************************************
* @Description : Method to get existing main object record
* @Param       : ApplyForSObjectCtlr instance
* @Return      : void
***************************************************************************************************/
        public void getExistingRecord(ApplyForSObjectCtlr ctlr) {
            
            String parentId = ctlr.parentId;
            String credentialtype = ctlr.credentialtype;
            String credential = ctlr.credential;
            String licenseBy = ctlr.licenseBy;
            String contactId = ctlr.contactId;
            String accountId = ctlr.accountId;
            List<Renewal_Application__c> newLicObj = new List<Renewal_Application__c>();
            newLicObj = [SELECT Id, Renewal_Status__c FROM Renewal_Application__c
                         WHERE License__c = :parentId
                         AND Renewal_Reinstatement_Type__c = :label.RNT_Reinstatement
                         AND Credential__c = :credential
                         AND Applicant__c = :contactId];
            
            for (Renewal_Application__c l : newLicObj) {
                if (l.Renewal_Status__c == label.ST_Incomplete) {
                    ctlr.existingRecId = l.Id;
                } else if ((ctlr.pageName.containsIgnoreCase('Application')) && (l.Renewal_Status__c == label.ST_Generate_Fee || l.Renewal_Status__c == label.ST_Submitted)) {
                      throw new CustomException('Cannot apply for Credentail reinstatement when an existing record has a status of ' + l.Renewal_Status__c);
                }
            }
        }
        
        /***************************************************************************************************
* @Description : Method to set field values into main object
* @Param       : ApplyForSObjectCtlr instance
* @Return      : void
***************************************************************************************************/
        public void setFieldValues(ApplyForSObjectCtlr ctlr) {
            
            // Set field values
            ctlr.lic.put(label.Api_Credential_Type, ctlr.credentialtype);
            ctlr.lic.put(label.Api_Credential, ctlr.credential);
            ctlr.lic.put(label.API_License_Field, ctlr.parentId);
            ctlr.lic.put(label.Api_Renewal_Type, ctlr.applicationType);
            ctlr.lic.put(label.Api_Applicant_c, ctlr.contactObj.Id);
            ctlr.lic.put(label.API_Renewal_Status, label.ST_Incomplete);
            System.debug('whaaaaa');
            // For business application
            if (ctlr.accountId != null) {
                ctlr.lic.put(label.API_Licensee, ctlr.accountId);
            }
            

        }
        
        /***************************************************************************************************
* @Description : Method to set record type
* @Param       : ApplyForSObjectCtlr instance
* @Return      : void
***************************************************************************************************/
        public void setRecordTypeField(ApplyForSObjectCtlr ctlr) {
            // Set field values
            ctlr.lic.put('RecordTypeId', ctlr.findRecordTypeIdForBoardAndLicenseType(ctlr.credentialtype, ctlr.credential, getObjectName()));
        }
        
        /***************************************************************************************************
* @Description : Method to set board and license type
* @Param       : ApplyForSObjectCtlr instance
* @Return      : void
***************************************************************************************************/
        public void setBoardLicenseType(ApplyForSObjectCtlr ctlr) {}
        
        /***************************************************************************************************
* @Description : Method to set license Id in global license object
* @Param       : ApplyForSObjectCtlr instance
* @Return      : void
***************************************************************************************************/
        public void setLicenseId(ApplyForSObjectCtlr ctlr) {
            ctlr.licenseGlobalData.licenseId = ctlr.parentId;
        }
        
        /***************************************************************************************************
* @Description : Method to get legal text for License/Credential Reinstatement
* @Param       : ApplyForSObjectCtlr instance
* @Return      : String
***************************************************************************************************/
        public String getLegalText(ApplyForSObjectCtlr ctlr) {
            String legalText = [SELECT Instructions__c FROM Newsfeed__c
                                WHERE Credential_Type__c = :ctlr.credentialType
                                AND Credential__c = :ctlr.credential
                                AND (Application_Method__c = :ctlr.applicationMethod OR Application_Method__c = 'All')
                                AND RecordType.Name = :label.RT_Attestation_Line
                                AND Show_For__c INCLUDES (:label.Str_Credential_Reinstatement)
                                LIMIT 1].Instructions__c;
            
            return legalText;
        }
        
        /***************************************************************************************************
* @Description : Method to get affidavit link
* @Param       : ApplyForSObjectCtlr instance
* @Return      : String
***************************************************************************************************/
        public String getAffidavitLink(ApplyForSObjectCtlr ctlr) {
            String affidavitLink = [SELECT Link__c FROM Newsfeed__c
                                    WHERE Credential_Type__c = :ctlr.credentialType
                                    AND Credential__c = :ctlr.credential
                                    AND Application_Method__c = :ctlr.applicationMethod
                                    AND RecordType.Name = :label.RT_Affidavit_Link
                                    AND Show_For__c INCLUDES (:label.Str_Credential_Reinstatement)
                                    LIMIT 1].Link__c;
            
            return affidavitLink;
        }
    }
    
    /***************************************************************************************************
* Class for Service Request configuration
* @version     1.0
***************************************************************************************************/
    public class ServiceRequestConfig implements ApplyForSObjectConfig {
        
        /***************************************************************************************************
* @Description : Method to get contact relationship API name
* @Param       : None
* @Return      : String
***************************************************************************************************/
        public String getContactRelationship() {
            return 'MUSW__Applicant__r';
        }
        
        /***************************************************************************************************
* @Description : Method to create instance of main object
* @Param       : None
* @Return      : Instance of main object
***************************************************************************************************/
        public SObject createInstance() {
            return new MUSW__Application2__c();
        }
        
        /***************************************************************************************************
* @Description : Method to get main object API name
* @Param       : None
* @Return      : String
***************************************************************************************************/
        public String getObjectName() {
            return label.API_Service_Request;
        }
        
        /***************************************************************************************************
* @Description : Method to get current record where clause
* @Param       : None
* @Return      : String
***************************************************************************************************/
        public String getCurrentRecordWhereClause() {
            return ' from MUSW__Application2__c where Id =: existingRecId ';
        }
        
        /***************************************************************************************************
* @Description : Method to get fee requirement where clause
* @Param       : Current record Id
* @Return      : String
***************************************************************************************************/
        public String getFeeRequirementWhereClause(String currentId) {
            return 'Id from MUSW__Application2__c where Id = \'' + currentId + '\'';
        }
        
        /***************************************************************************************************
* @Description : Method to set page title
* @Param       : None
* @Return      : String
***************************************************************************************************/
        public String setPageTitle() {
            return 'New Service Request';
        }
        
        /***************************************************************************************************
* @Description : Method to get endorsement lookup field
* @Param       : None
* @Return      : String
***************************************************************************************************/
        public String getQuestionObjectLookup() {
            return 'Service_Request__c';
        }
        
        /***************************************************************************************************
* @Description : Method to get attachment object lookup field
* @Param       : None
* @Return      : String
***************************************************************************************************/
        public String getAttachmentObjectLookup() {
            return 'MUSW__Application2__c';
        }
        
        /***************************************************************************************************
* @Description : Method to get status field
* @Param       : None
* @Return      : String
***************************************************************************************************/
        public String getStatusField() {
            return label.Api_Musw_Status;
        }
        
        /***************************************************************************************************
* @Description : Method to get global parameters
* @Param       : ApplyForSObjectCtlr instance
* @Return      : void
***************************************************************************************************/
        public void getBoardLicenseType(ApplyForSObjectCtlr ctlr) {
            String existingId = ctlr.existingRecId;
            if ( ctlr.existingRecId != null ) {
                String currQuery = 'SELECT Id, MUSW__Type__c '
                    + ' from MUSW__Application2__c where Id = :ctlr.existingId ';
                SObject existingObj = Database.query(currQuery);
                ctlr.credentialtype = (String) existingObj.get('MUSW__Type__c');                
                ctlr.applicationType = label.Str_Service_Request;
                ctlr.licenseGlobalData.licenseId = existingId;                
            }
        }
        
        /***************************************************************************************************
* @Description : Method to get existing main object record
* @Param       : ApplyForSObjectCtlr instance
* @Return      : void
***************************************************************************************************/
        public void getExistingRecord(ApplyForSObjectCtlr ctlr) {
            //Implementation not required for Service Request
        }
        
        /***************************************************************************************************
* @Description : Method to set field values into main object
* @Param       : ApplyForSObjectCtlr instance
* @Return      : void
***************************************************************************************************/
        public void setFieldValues(ApplyForSObjectCtlr ctlr) {
            // Set field values
            ctlr.lic.put(label.API_MUSW_Type, ctlr.serviceRequestType);
            ctlr.lic.put(label.API_MUSW_Applicant, ctlr.contactObj.Id);
            
            
            if(ctlr.parentId != null){
                Id pid = (Id) ctlr.parentId;
                if(pid.getsObjectType().getDescribe().getName() == Label.API_License2){
                    ctlr.lic.put('license__c', pid);
                    ctlr.lic.put(label.Api_Credential_Type, ctlr.credentialType);
                    ctlr.lic.put(label.Api_Credential, ctlr.credential);
                     ctlr.lic.put(label.API_Account_Permit,ctlr.accountId);
                }else if(pid.getsObjectType().getDescribe().getName() == Label.API_Permit){
                    ctlr.lic.put('permit__c', pid);
                    ctlr.lic.put(label.Api_Permit_Type, ctlr.credential);
                    ctlr.lic.put(label.Api_Program_Area, ctlr.credentialType);
                     ctlr.lic.put(label.API_Account_Permit,ctlr.accountId);
                }
            }
        }
        
        /***************************************************************************************************
* @Description : Method to set record type
* @Param       : ApplyForSObjectCtlr instance
* @Return      : void
***************************************************************************************************/
        public void setRecordTypeField(ApplyForSObjectCtlr ctlr) {
            // Set field values
           ctlr.lic.put('RecordTypeId', ctlr.findRecordTypeIdForBoardAndLicenseType(ctlr.credentialtype, ctlr.credential, getObjectName()));
        }
        
        /***************************************************************************************************
* @Description : Method to set Functionalarea and license type
* @Param       : ApplyForSObjectCtlr instance
* @Return      : void
***************************************************************************************************/
        public void setBoardLicenseType(ApplyForSObjectCtlr ctlr) {}
        
        /***************************************************************************************************
* @Description : Method to set license Id in global license object
* @Param       : ApplyForSObjectCtlr instance
* @Return      : void
***************************************************************************************************/
        public void setLicenseId(ApplyForSObjectCtlr ctlr) {
            
        System.debug('ctrl.lic '+ctlr.lic);
             System.debug((String)ctlr.lic.get('Id'));
            ctlr.licenseGlobalData.licenseId = (String)ctlr.lic.get('Id');
        }
        
        /***************************************************************************************************
* @Description : Method to get legal text
* @Param       : ApplyForSObjectCtlr instance
* @Return      : String
***************************************************************************************************/
        public String getLegalText(ApplyForSObjectCtlr ctlr) {
            return '';
        }
        
        /***************************************************************************************************
* @Description : Method to get affidavit link
* @Param       : ApplyForSObjectCtlr instance
* @Return      : String
***************************************************************************************************/
        public String getAffidavitLink(ApplyForSObjectCtlr ctlr) {
            return '';
        }
    }
}