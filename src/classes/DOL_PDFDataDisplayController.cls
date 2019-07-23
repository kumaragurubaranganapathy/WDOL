/*
* classname     :  DOL_PDFDataDisplayController
* @description  :  This class is used to get license data for generating PDF
* @author       :  Gunjit Kaur
* @date         :  07/08/2019
* MODIFICATION LOG:
* DEVELOPER                     DATE                               DESCRIPTION
* ---------------------------------------------------------------------------------------------
* Gunjit Kaur         07/10/2019          Added SOQL to get Question data
**/

public with sharing class DOL_PDFDataDisplayController {
    private final MUSW__License2__c licenseData;
    public MUSW__License2__c licenseRecordData {get;set;}
    public RecordType recordtypeName{get;set;}
    public List<Question__c> questionRecordList {get;set;}
    public List<MUSW__Parcel__c> addressRecordList {get;set;}
    public DOL_PDFDataDisplayController(ApexPages.StandardController stdController) {
        this.licenseData = (MUSW__License2__c)stdController.getRecord();
        system.debug('MUSW__License2__c: '+licenseData);
        licenseRecordData = new MUSW__License2__c(); 
        questionRecordList = new List<Question__c>();
        addressRecordList = new List<MUSW__Parcel__c>();
        // query for getting specific License Data
        for(MUSW__License2__c licenseRecordInstance : [Select Id, Name, CreatedDate, Application_Type__c, Credential_Type__c, MUSW__Status__c,
                                                       Application_Method__c, Ultimate_Parent_Account__r.Name, MUSW__Primary_Licensee__r.Name, Owner.Name,
                                                       Sub_Status__c, Original_Issue_Date__c, MUSW__Applicant__r.Name,
                                                       MUSW__Applicant__r.LastName, MUSW__Applicant__r.FirstName, MUSW__Applicant__r.MiddleName,
                                                       MUSW__Applicant__r.Contact_Suffix__c, MUSW__Applicant__r.ContactName__c, MUSW__Applicant__r.Birthdate,
                                                       MUSW__Applicant__r.Unique_ID_To_Provide__c, MUSW__Applicant__r.Social_Security_Number_Encrypted__c,
                                                       MUSW__Applicant__r.MobilePhone, MUSW__Applicant__r.OtherPhone, MUSW__Applicant__r.Email, 
                                                       MUSW__Applicant__r.ITIN__c, MUSW__Applicant__r.Other_Email__c, MUSW__Total_Fees__c, 
                                                       MUSW__Total_Balance__c, MUSW__Total_Payments__c, (Select Id, Name, Question_Section__c, 
                                                                                                         Answer_Text__c, QuestionDOL__r.Question_Body__c, QuestionDOL__r.Record_Type_Name__c, 
                                                                                                         QuestionDOL__r.Question_Sub_Section__c,QuestionDOL__r.Sub_Sub_Header__c, QuestionDOL__r.Section__c 
                                                                                                         From Answers2__r),(Select Id, Name, MUSW__Description__c From  MUSW__Submissions__r), Application__r.Id
                                                       From MUSW__License2__c Where Id = :licenseData.Id LIMIT 1]){
                                                           licenseRecordData = licenseRecordInstance;
                                                       }
        System.debug('licenseRecordData== ' + licenseRecordData);
        recordtypeName = [Select Id, Name From RecordType Where Id = :licenseData.RecordTypeId LIMIT 1];
        System.debug('recordtypeName==' + recordtypeName);
        if(String.isNotBlank(licenseRecordData.Application__r.Id)){
            for(MUSW__Parcel__c allAddressRecord : [Select Id, Address_Type__c, is_Physical_and_Mailing_Address_Same__c, MUSW__Street2__c, MUSW__Unit__c, 
                                                    MUSW__City__c,MUSW__State__c, Canadian_provinces__c, County__c, Country__c, Zip_Postal_Code__c,
                                                    Application_BG__c FROM MUSW__Parcel__c WHERE Application_BG__c=: licenseRecordData.Application__r.Id]){
                                                      addressRecordList.add(allAddressRecord);
                                                  }
        }
        System.debug('addressRecordList== ' + addressRecordList);
        Id questionRecordTypeId = Schema.SObjectType.Question__c.getRecordTypeInfosByName().get('Review and Submit').getRecordTypeId() ;
        for(Question__c questionRecordInstance : [Select Id, Question_Body__c, Order_Number__c, Status__c, Section__c From Question__c 
                                                  Where Application_Type__c = :licenseRecordData.Application_Type__c
                                                  AND Credential_Type__c = :licenseRecordData.Credential_Type__c
                                                  AND Application_Method__c = :licenseRecordData.Application_Method__c
                                                  AND Status__c = 'Active'
                                                  AND Section__c = 'Certifications'
                                                  AND Parent_Object_API_Name__c = 'MUSW__License2__c'
                                                  AND RecordTypeId = :questionRecordTypeId Order By Order_Number__c ASC]){
                                                      questionRecordList.add(questionRecordInstance);
                                                  }
        System.debug('questionRecordList==' + questionRecordList);
        Apexpages.currentPage().getHeaders().put('content-disposition', 'attachment; filename=DownloadApplication.pdf'); 
        
    } 
    
    
    
}