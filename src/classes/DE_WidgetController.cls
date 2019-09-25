public class DE_WidgetController {
    @AuraEnabled
    public static Map<String,String> getCustomLabelMap(){
        try{
           Map<String, String> mapWidgetLabels = new Map<String, String>();
           mapWidgetLabels = DE_LandingPageCustomLabels.getWidgetLabels();
    
           return mapWidgetLabels;
        }
          catch(Exception ex)
        {
            DOL_CreateErrorLog_Exception.logApplicationError(ex);
            throw new AuraHandledException('An error occurred: '+ex.getMessage());
        }
    }
    @AuraEnabled
    public static DE_CreateLightningServerResponse errorLogger(){
        Boolean bSuccessful = true;       
        map<String,Object> mapStrObjs = new map<String,object>();
        Map<String,Object> mapErrorInfo = new Map<String, Object>{};		
        list<SObject> lstToUpdate = new list<SObject>();
        try{
            Account a = new Account();
            insert a;
        } catch(Exception e){
            bSuccessful = false;
            String lan=UserInfo.getLanguage();
            String uid=UserInfo.getUserId();
            String sessid=UserInfo.getSessionId().substring(15);
            LoginHistory lh=[SELECT Browser,LoginTime,SourceIp,UserId,Platform FROM LoginHistory WHERE UserId =:uid ORDER BY LoginTime DESC NULLS LAST LIMIT 1];
            //HandleException.LogException(e,'AccountTestClass','MainProcessing',lan,sessid,lh);
            throw new AuraHandledException('An error occurred: '+e.getMessage());
            
        }
        return new DE_CreateLightningServerResponse(bSuccessful, mapErrorInfo, mapStrObjs);
    }
    @AuraEnabled
    public static void errorLogger22(){
        Boolean bSuccessful = true;       
        try{
            Account a = new Account();
            insert a;
        } catch(Exception e){
            bSuccessful = false;
            String lan=UserInfo.getLanguage();
            String uid=UserInfo.getUserId();
            String sessid=UserInfo.getSessionId().substring(15);
            LoginHistory lh=[SELECT Browser,LoginTime,SourceIp,UserId,Platform FROM LoginHistory WHERE UserId =:uid ORDER BY LoginTime DESC NULLS LAST LIMIT 1];
            //HandleException.LogException(e,'AccountTestClass','MainProcessing',lan,sessid,lh);
            throw new AuraHandledException('An error occurred: '+e.getMessage());
            
        }
    }
}