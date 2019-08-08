@isTest
public class Dol_UploadDocumenttoSAN_Test {

    private static testmethod void test_getUser() {
        test.startTest();
         Dol_UploadDocumenttoSAN.getUser();
         test.stopTest();
    }
    private static testmethod void test_ProfCode() {
        MUSW__License2__c  lic = new MUSW__License2__c(Name = 'System Number', Application_Type__c = 'Notary Public', Credential__c  ='Geologist', Profession_Code__c= '123',Credential_Type__c ='Notary Public');
        insert lic;
        MUSW__Submission__c  sub = new MUSW__Submission__c (Name   ='Title', MUSW__License2__c =lic.id, SAN_Image_Type__c='Renewal' );
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
         Dol_UploadDocumenttoSAN.getProfCode(sub.id);
         Dol_UploadDocumenttoSAN.backofficeUplaod(sub.id, 'docName', 'user') ;
         Dol_UploadDocumenttoSAN.portalUploadFuture(mapSubimissionToFile) ;
         test.stopTest();
    }
    
}