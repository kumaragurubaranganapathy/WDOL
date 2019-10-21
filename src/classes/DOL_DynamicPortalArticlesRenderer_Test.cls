@isTest
public class DOL_DynamicPortalArticlesRenderer_Test {
    @isTest
    public static void getPortalArticlesByDisplayPageTest(){
        Id portalArticleRecType = Schema.SObjectType.Portal_Article__c.getRecordTypeInfosByName().get('Main').getRecordTypeId();
        Portal_Article__c portalArticle = new Portal_Article__c(Article_Title__c='Test Article',RecordTypeId = portalArticleRecType, Article_Status__c = 'Active', Display_Page__c = 'Public Home');
        insert portalArticle;
        Portal_Article__c relatedArticle = new Portal_Article__c(Article_Title__c='Test Article 2',RecordTypeId = portalArticleRecType, Article_Status__c = 'Active', Display_Page__c = 'Public Home',Parent_Article__c = portalArticle.Id);
        insert relatedArticle;  
        portalArticle.Order_of_Display__c = 3; 
        portalArticle.External_Id__c = 'abc123';
        update portalArticle;
        
        try{
        DOL_DynamicPortalArticlesRenderer_Apex.getPortalArticlesByDisplayPage('Public Home');
        //String myJSON = JSON.serialize(portalArticle);
        }catch(Exception e){}
    
        try{
        DOL_DynamicPortalArticlesRenderer_Apex.getPortalArticlesByArticleTitle('Test Article');
        //String myJSON = JSON.serialize(portalArticle);
        }catch(Exception e){}
        
        try{
        DOL_DynamicPortalArticlesRenderer_Apex.getPortalArticlesByArticleExternalId('abc123');
        //String myJSON = JSON.serialize(portalArticle);
        }catch(Exception e){}
        
    }
    
    
    @IsTest
    public static void testCreateErrorLogException(){
        DOL_CreateErrorLog_Exception.addError(new CustomException('An error occurred:'),'An error occurred:','test:');
        DOL_CreateErrorLog_Exception.logApplicationError(new CustomException('An error occurred:'),'An error occurred:','An error occurred:');
        DOL_CreateErrorLog_Exception.logApplicationError(new CustomException('An error occurred:'));
        DOL_CreateErrorLog_Exception.logDeleteDetails('An error occurred:','An error occurred:','An error occurred:');
       // DOL_CreateErrorLog_Exception.logDatabaseError('CustomException','test');
       
        
    }
     
}