@isTest
public class Dol_DeleteAttachmentFromSubmission_test{
    @isTest
    public static void delete_Test(){
        MUSW__License2__c  lic = new MUSW__License2__c(Name = 'System Number', Application_Type__c = 'Notary Public', Credential__c  ='Geologist', Profession_Code__c= '123',Credential_Type__c ='Notary Public');
        insert lic;
        MUSW__Submission__c  sub = new MUSW__Submission__c (Name   ='Title', MUSW__License2__c =lic.id, SAN_Image_Type__c='Renewal',SAN_Image_URL__c='mock url' );
        insert sub;
         test.startTest();
        	Dol_DeleteAttachmentFromSubmission.getRecordName(sub.id);
            Dol_DeleteAttachmentFromSubmission.deleteDocumentLink (sub.id);
         test.stopTest();
    }
}