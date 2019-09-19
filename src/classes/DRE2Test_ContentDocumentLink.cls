//@isTest private class DRE2Test_ContentDocumentLink { @isTest static void insertUpdateDelete() { DRE.DRETestExternalManager.run('ContentDocumentLink'); } }
@isTest private class DRE2Test_ContentDocumentLink { 
    @isTest static void insertUpdateDelete() {
        insert new Account(Name= DOL_AppConstants.NULL_EMPTY_STRING + 'Test Account');        

        insert new ContentVersion(
            Title = DOL_AppConstants.NULL_EMPTY_STRING + 'Test File',
            PathOnClient = DOL_AppConstants.NULL_EMPTY_STRING + 'File.txt',
            VersionData = Blob.valueOf('Test Content'),
            IsMajorVersion = true
        );
        
        ContentDocumentLink cdl = New ContentDocumentLink(
            LinkedEntityId = [SELECT Id FROM Account LIMIT 1].Id,
            ContentDocumentId = [SELECT Id FROM ContentDocument LIMIT 1].Id,
            shareType = DOL_AppConstants.NULL_EMPTY_STRING + 'V'
        );
        insert cdl;
        
        update cdl;
        
        delete cdl;
    } 
}