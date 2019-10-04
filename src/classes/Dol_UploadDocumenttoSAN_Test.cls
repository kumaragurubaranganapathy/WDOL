@isTest(SeeAllData=true)
public class Dol_UploadDocumenttoSAN_Test {

    private static testmethod void test_getUser() {
        test.startTest();
         Dol_UploadDocumenttoSAN.getUser();
         test.stopTest();
    }
    private static testmethod void test_ProfCode() {
        MUSW__License2__c  lic = new MUSW__License2__c(Name = 'System Number', Application_Type__c = 'Notary Public', Credential__c  ='Geologist', Profession_Code__c= '123',Credential_Type__c ='Notary Public');
        insert lic;
        MUSW__Submission__c  sub = new MUSW__Submission__c (Name   ='Title', MUSW__License2__c =lic.id, SAN_Image_Type__c='Renewal',SAN_Image_URL__c='test' );
        insert sub;
        
        Blob bodyBlob = Blob.valueOf('This is version data');
        ContentVersion contentVersion_1 = new ContentVersion(
        Title='Header_Picture1', 
        PathOnClient ='/Header_Picture1.jpg',
        VersionData = bodyBlob, 
        origin = 'H'
        );
        insert contentVersion_1;
        
        ContentVersion contentVersion_2 = [SELECT Id, Title, ContentDocumentId FROM ContentVersion WHERE Id = :contentVersion_1.Id LIMIT 1];
       
        ContentDocumentLink contentlink = new ContentDocumentLink();
        contentlink.LinkedEntityId = sub.id;
        contentlink.contentdocumentid = contentVersion_2.contentdocumentid;
        contentlink.ShareType = 'V';
        insert contentlink; 
        
        Map<String,String> mapSubimissionToFile = new Map<String,String>();
		mapSubimissionToFile.put(sub.id,contentVersion_2.contentdocumentid);
        
        test.startTest();
         Dol_UploadDocumenttoSAN.getSelectOptionValues(sub,'SAN_Image_Type__c');
         Dol_UploadDocumenttoSAN.getImageUrl(sub.id);
         Dol_UploadDocumenttoSAN.getProfCode(sub.id);
         Dol_UploadDocumenttoSAN.getParent(sub.id);
         Dol_UploadDocumenttoSAN.backofficeUplaod(sub.id, 'docName', 'user','Compliance','') ;
        
        MUSW__Complaint2__c  com = new MUSW__Complaint2__c(MUSW__Type__c  = 'Other ', MUSW__Status__c  = 'New', MUSW__Origin__c  ='Phone');
        insert com;
        MUSW__Submission__c  sub2 = new MUSW__Submission__c (Name   ='Title', Complaint__c =com.id, SAN_Image_Type__c='Renewal',SAN_Image_URL__c='test',SAN_Prof_Code__c='123');
        insert sub2;
        Dol_UploadDocumenttoSAN.getParent(sub2.id);
        Dol_UploadDocumenttoSAN.getProfCode(sub2.id);
        
        MUSW__Complaint2__c  com2 = new MUSW__Complaint2__c(MUSW__Type__c  = 'Other ', MUSW__Status__c  = 'New', MUSW__Origin__c  ='Phone',License__c =lic.id);
        insert com2;
        MUSW__Submission__c  sub3 = new MUSW__Submission__c (Name   ='Title', Complaint__c =com.id, SAN_Image_Type__c='Renewal',SAN_Image_URL__c='test');
        insert sub3;
        Dol_UploadDocumenttoSAN.getParent(sub3.id);
        Dol_UploadDocumenttoSAN.getProfCode(sub3.id);
         //Dol_UploadDocumenttoSAN.portalUploadFuture(mapSubimissionToFile) ;
         test.stopTest();
    }
    
}