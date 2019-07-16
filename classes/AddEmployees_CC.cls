/*************************************************************************************************************
** User Story: 
**************************************************************************************************************
** Class Name    : AddEmployees_CC
** Description   : Add employees from Manage Business Page from Portal
** Version       : 1.0
** Built By      : Srikanth Kottam
**------------------------------------------------------------------------------------------------------------
** Modification Log:
**------------------
** Developer              Date                    Version          Description
**************************************************************************************************************/ 
public class AddEmployees_CC {
    public Id ParentId1 {get;set;}
    //, String board
    @RemoteAction
    public static List<MUSW__License2__c> getLicenseRecords(String searchstr){
        List<MUSW__License2__c> lstLicenses = [SELECT Id, Name, Applicant_Full_Name__c,MUSW__Applicant__c From MUSW__License2__c WHERE MUSW__Status__c = :label.ST_Active  AND (Name LIKE :searchstr OR Applicant_Full_Name__c LIKE :searchstr) Order by Name ASC LIMIT 10];
        
        return lstLicenses;
    }
    
 /*   @RemoteAction
    public static Database.UpsertResult upsertAffiliationRecords(License_Relationship__c affiliation){
        affiliation.RecordTypeId = Schema.SObjectType.License_Relationship__c.getRecordTypeInfosByName().get(Label.RT_Employee_Relationship_Record_Type).getRecordTypeId();
        Database.UpsertResult srList1 = Database.upsert(affiliation, false);
        Id ParentId1 = srList1.id;
        system.debug('ParentId--->'+ParentId1);
        return srList1;
    }   */
    /* public Id myId (License_Relationship__c affiliation){
return affiliation.id;
}*/
    @RemoteAction
    public static String doUploadAttachment(String acctId, String attachmentBody, String attachmentName) {
        System.debug(acctId+'  '+attachmentBody+'  '+attachmentName);
        if(acctId != null) {
            Attachment att = new Attachment();
            String newBody = attachmentBody;
            att.Body = EncodingUtil.base64Decode(newBody);
            att.Name = attachmentName;
            att.parentId = acctId;
            insert att;
            return att.Id;
        } else {
            return 'Attachment Body was null';
        }
        
    }
    
    @TestVisible
    private static Account getAccount(String acctId) {
        list<Account> accounts = [SELECT Id, Name
                                  FROM Account
                                  WHERE Id =: acctId];
        if(accounts.isEmpty()) {
            return null;
        } else {
            return accounts[0];
        }
    }
    
}