@isTest
public class DOL_DynamicPortalArticlesRenderer_Test {
	@isTest
    public static void getPortalArticlesByDisplayPageTest(){
        Id portalArticleRecType = Schema.SObjectType.Portal_Article__c.getRecordTypeInfosByName().get('Main').getRecordTypeId();
        Portal_Article__c portalArticle = DOL_TestDataFactory.createPortalArticle('Active','Public Home',portalArticleRecType);       
        DOL_DynamicPortalArticlesRenderer_Apex.getPortalArticlesByDisplayPage('Public Home');
    }
    
    @isTest
    public static void getPortalArticlesByArticleTitleTest(){
        Id portalArticleRecType = Schema.SObjectType.Portal_Article__c.getRecordTypeInfosByName().get('Main').getRecordTypeId();
        Portal_Article__c portalArticle = DOL_TestDataFactory.createPortalArticle('Active','Public Home',portalArticleRecType);       
        DOL_DynamicPortalArticlesRenderer_Apex.getPortalArticlesByArticleTitle('Test Article');
    }
    
    @isTest
    public static void getPortalArticlesByArticleExternalIdTest(){
        Id portalArticleRecType = Schema.SObjectType.Portal_Article__c.getRecordTypeInfosByName().get('Main').getRecordTypeId();
        Portal_Article__c portalArticle = DOL_TestDataFactory.createPortalArticle('Active','Public Home',portalArticleRecType);
        portalArticle.External_Id__c = 'abc123';
        update portalArticle;
        DOL_DynamicPortalArticlesRenderer_Apex.getPortalArticlesByArticleExternalId('abc123');
    }
}