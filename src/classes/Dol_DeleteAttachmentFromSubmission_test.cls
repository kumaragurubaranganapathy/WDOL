@isTest
public class Dol_DeleteAttachmentFromSubmission_test{
    @isTest
    public static void delete_Test(){
        MUSW__License2__c  lic = new MUSW__License2__c(Name = DOL_AppConstants.NULL_EMPTY_STRING + 'System Number', Application_Type__c = DOL_AppConstants.NULL_EMPTY_STRING + 'Notary Public', Credential__c  = DOL_AppConstants.NULL_EMPTY_STRING + 'Geologist', Profession_Code__c= DOL_AppConstants.NULL_EMPTY_STRING + '123',Credential_Type__c = DOL_AppConstants.NULL_EMPTY_STRING + 'Notary Public');
        insert lic;
        MUSW__Submission__c  sub = new MUSW__Submission__c (Name   = DOL_AppConstants.NULL_EMPTY_STRING + 'Title', MUSW__License2__c =lic.id, SAN_Image_Type__c= DOL_AppConstants.NULL_EMPTY_STRING + 'Renewal',SAN_Image_URL__c= DOL_AppConstants.NULL_EMPTY_STRING + 'mock url' );
        insert sub;
         test.startTest();
        	Dol_DeleteAttachmentFromSubmission.getRecordName(sub.id);
            Dol_DeleteAttachmentFromSubmission.deleteDocumentLink (sub.id);
         test.stopTest();
    }
}