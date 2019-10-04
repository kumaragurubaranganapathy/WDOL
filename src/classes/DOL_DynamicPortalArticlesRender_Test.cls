@isTest
public class DOL_DynamicPortalArticlesRender_Test {
	@isTest
    public static void getPortalArticlesTest(){
        Id portalArticleRecType = Schema.SObjectType.Portal_Article__c.getRecordTypeInfosByName().get('Main').getRecordTypeId();
        Portal_Article__c portalArticle = DOL_TestDataFactory.createPortalArticle('Active','Public Home',portalArticleRecType);       
        DOL_DynamicPortalArticlesRender_Apex.getPortalArticles();
    }
}