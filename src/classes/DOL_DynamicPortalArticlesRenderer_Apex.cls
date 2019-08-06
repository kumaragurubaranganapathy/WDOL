/**
 * DOL_DynamicPortalArticlesRender_Apex class is used to render dynamically the articles.
 * In the portal dashboard. 
 * 
 * @author Pramod Vemula
 * @date 07/08/2019
 */
 
public class DOL_DynamicPortalArticlesRenderer_Apex {
    
    @AuraEnabled
    public static String getPortalArticlesByDisplayPage(String displayPage){
        

    List<Portal_Article__c>  parentPortalArticlesList =  [SELECT Article_body_sections_to_display__c,Article_Body__c,Article_Content_Type__c,Article_Link_URL__c,
                                                                 Article_Status__c,Article_Sub_description__c,Article_Title__c,Display_Page__c,External_Id__c,
                                                                 Id,Name,Order_of_Display__c,Parent_Article__c,RecordType.name,Internal_Article_Redirection__c,
                                                                 (SELECT Article_body_sections_to_display__c,Article_Body__c,Article_Content_Type__c,Article_Link_URL__c,
                                                                 Article_Status__c,Article_Sub_description__c,Article_Title__c,Display_Page__c,External_Id__c,
                                                                 Id,Name,Order_of_Display__c,Parent_Article__c,RecordType.name,Internal_Article_Redirection__c FROM Related_Articles__r where Article_Status__c = 'Active' ORDER BY Order_of_Display__c,Article_Title__c ASC)
                                                         FROM Portal_Article__c 
                                                         WHERE Parent_Article__c = null AND 
                                                               Order_of_Display__c !=null AND 
                                                               RecordType.name='Main' AND 
                                                               Article_Status__c = 'Active' AND 
                                                               Display_Page__c =: displayPage ORDER BY Order_of_Display__c,Article_Title__c ASC];
                                                               
        return JSON.serialize(segregrateArticles(parentPortalArticlesList)); 
    
    }
    
    @AuraEnabled
    public static String getPortalArticlesByArticleTitle(String articleTitle){
        

    List<Portal_Article__c>  parentPortalArticlesList =  [SELECT Article_body_sections_to_display__c,Article_Body__c,Article_Content_Type__c,Article_Link_URL__c,
                                                                 Article_Status__c,Article_Sub_description__c,Article_Title__c,Display_Page__c,External_Id__c,
                                                                 Id,Name,Order_of_Display__c,Parent_Article__c,RecordType.name,Internal_Article_Redirection__c,
                                                                 (SELECT Article_body_sections_to_display__c,Article_Body__c,Article_Content_Type__c,Article_Link_URL__c,
                                                                 Article_Status__c,Article_Sub_description__c,Article_Title__c,Display_Page__c,External_Id__c,
                                                                 Id,Name,Order_of_Display__c,Parent_Article__c,RecordType.name,Internal_Article_Redirection__c FROM Related_Articles__r where Article_Status__c = 'Active' ORDER BY Order_of_Display__c,Article_Title__c ASC)
                                                         FROM Portal_Article__c 
                                                         WHERE Parent_Article__c = null AND 
                                                               Order_of_Display__c !=null AND 
                                                               RecordType.name='Main' AND 
                                                               Article_Status__c = 'Active' AND 
                                                               Article_Title__c =: articleTitle ORDER BY Order_of_Display__c,Article_Title__c ASC];
                                                               
        return JSON.serialize(segregrateArticles(parentPortalArticlesList)); 
    
    }
    
    @AuraEnabled
    public static String getPortalArticlesByArticleExternalId(String externalId){
        

    List<Portal_Article__c>  parentPortalArticlesList =  [SELECT Article_body_sections_to_display__c,Article_Body__c,Article_Content_Type__c,Article_Link_URL__c,
                                                                 Article_Status__c,Article_Sub_description__c,Article_Title__c,Display_Page__c,External_Id__c,
                                                                 Id,Name,Order_of_Display__c,Parent_Article__c,RecordType.name,Internal_Article_Redirection__c,
                                                                 (SELECT Article_body_sections_to_display__c,Article_Body__c,Article_Content_Type__c,Article_Link_URL__c,
                                                                 Article_Status__c,Article_Sub_description__c,Article_Title__c,Display_Page__c,External_Id__c,
                                                                 Id,Name,Order_of_Display__c,Parent_Article__c,RecordType.name,Internal_Article_Redirection__c FROM Related_Articles__r where Article_Status__c = 'Active' ORDER BY Order_of_Display__c,Article_Title__c ASC)
                                                         FROM Portal_Article__c 
                                                         WHERE Parent_Article__c = null AND 
                                                               Order_of_Display__c !=null AND 
                                                               RecordType.name='Main' AND 
                                                               Article_Status__c = 'Active' AND 
                                                               External_Id__c =:externalId ORDER BY Order_of_Display__c,Article_Title__c ASC];
                                                               
        return JSON.serialize(segregrateArticles(parentPortalArticlesList)); 
    
    }

    
    public static List<DOL_DynamicPortalArticlesRenderer_Apex.PortalArticleWrapper> segregrateArticles(List<Portal_Article__c>  parentPortalArticlesList){
        
        List<DOL_DynamicPortalArticlesRenderer_Apex.PortalArticleWrapper> listPortalArticlesToReturn = new List<PortalArticleWrapper>();
        
        for(Portal_Article__c mainPortalArticle :parentPortalArticlesList){
            
            PortalArticleWrapper wrapObj = new PortalArticleWrapper();
            
            wrapObj.mainArticle = mainPortalArticle;
            
            Decimal given_Article_Sections = mainPortalArticle.Article_body_sections_to_display__c;
            
            Integer no_Of_Sections = 3;
            if(given_Article_Sections != null || given_Article_Sections == 0){
                no_Of_Sections = given_Article_Sections.intValue();   
            }
            
            List<Portal_Article__c> bodyArticlesList = new List<Portal_Article__c>();
            
            for(Portal_Article__c childPortalArticle : mainPortalArticle.Related_Articles__r){
                
                switch on childPortalArticle.RecordType.name {
                    
                    when 'Header'{	
                        
                        wrapObj.childArticlesHeader.add(childPortalArticle);
                    }	
                    when 'Body' {
                        
                        bodyArticlesList.add(childPortalArticle);
                    }
                    when 'Footer'{
                        
                        wrapObj.childArticlesFooter.add(childPortalArticle);
                    }
                }
            }
            
            wrapObj.childArticlesBody = setArticleBodyAsperSections(bodyArticlesList,no_Of_Sections);
            
            listPortalArticlesToReturn.add(wrapObj);
        }
        
        return listPortalArticlesToReturn;
        
    }
    
    public static List<List<Portal_Article__c>> setArticleBodyAsperSections(List<Portal_Article__c>  articlesToArrange, Integer no_Of_Sections){
        
        List<List<Portal_Article__c>> arrangedArticles = new List<List<Portal_Article__c>>();
        
        if(no_Of_Sections != null && no_Of_Sections !=0 ){
            
            for(integer i = 0 ; i < no_Of_Sections ; i++){
                
                arrangedArticles.add(new List<Portal_Article__c>());
                
            }
        }
        
        If(articlesToArrange != null){
            
            Integer totalArticleBodyItems = articlesToArrange.size();
        
            Integer Optimal_Articles_Section = 6;
            
            Integer calculated_Articles_Per_Section = (Math.floor(articlesToArrange.size()/no_Of_Sections)).intValue();
            
            Integer Additional_calculated_Articles_Per_Section = Math.mod(articlesToArrange.size(),no_Of_Sections);
            
            integer i = 0;
            
            for( ; i < (articlesToArrange.size()-Additional_calculated_Articles_Per_Section) ; i++){
                
                Integer selected_Section_To_Push = (Math.floor(i/calculated_Articles_Per_Section)).intValue();
                
                arrangedArticles.get(selected_Section_To_Push).add(articlesToArrange.get(i));
            }
            
            for( ;i<articlesToArrange.size();i++){
                
                arrangedArticles.get(0).add(articlesToArrange.get(i));
            }
             
        }
        
         return arrangedArticles; 
        
    }
    
    
   
       public class PortalArticleWrapper{
        
       public Portal_Article__c mainArticle; /*mainArticle instance must and should only populate the records of Main record type and of the parent article record*/
       
       public List<Portal_Article__c>  childArticlesHeader; /*childArticlesHeader instance must and should only populate the records of Header record type*/
       
       public List<List<Portal_Article__c>> childArticlesBody; /*childArticlesBody instance must and should only populate the records of Body record type*/
       
       public List<Portal_Article__c> childArticlesFooter; /*childArticlesFooter instance must and should only populate the records of Footer record type*/
       
       public boolean hasError;
       
       public String error_Message;
       
       public PortalArticleWrapper(){
           
           mainArticle = new Portal_Article__c();
           
           childArticlesHeader = new List<Portal_Article__c>();
           
           childArticlesBody   = new List<List<Portal_Article__c>>();
           
           childArticlesFooter = new List<Portal_Article__c>();
           
       }
    }
}