/*************************************************************************************************************
**  
**************************************************************************************************************
** Class Name    : Resources_CC
** Description   : 
** Version       : 1.0
** Built By      :  
**------------------------------------------------------------------------------------------------------------
** Modification Log:
**------------------
** Developer                         Date                    Version                      Description
** 
**------------------------------------------------------------------------------------------------------------
** Review Log:
**---------------
** Reviewer                  Date           Version               Description
**------------------------------------------------------------------------------------------------------------
**
**  **********************************************************************************************************/
public with sharing class Resources_CC {
    
    public Boolean isActiveMessage {get;set;}
    public Boolean inMaintenancePeriod {get;set;}
    public Boolean inPreMaintenancePeriod {get;set;}
    public Boolean isHost {get;set;}
    public Boolean isHomepage {get;set;}
    public Boolean isMaintenancepage {get;set;}
  //  public CommunityMessages__c cm {get;set;}
    
    public string getPageInfo(){
        return JSON.serialize(gpi);
    }
    
    
    public class GlobalPageInfo{
        public Boolean isGuestUser {get;set;}
        public String PageURL {get;set;} 

    }

    GlobalPageInfo gpi;  


    public Resources_CC() {

            gpi = new GlobalPageInfo();

            gpi.isGuestUser = Utilities.isGuestUserLoggedIn();
            gpi.PageURL = ApexPages.currentPage().getUrl();
            isActiveMessage = false;
            inMaintenancePeriod = false;
            inPreMaintenancePeriod = false;
            isHost = false;
            isHomepage = false;
            isMaintenancepage = false;
            Datetime preMaintenanceStart;
            Datetime preMaintenanceEnd;
        //    cm = CommunityMessages__c.getInstance(label.Str_Maintenance_Message); 

            if(ApexPages.currentPage().getHeaders().get('Host') == URL.getSalesforceBaseUrl().getHost()){
                isHost = true;
            }


            String currentURL = ApexPages.currentPage().getUrl();
            currentURL = currentURL.toLowerCase();
            System.debug('---> '+currentURL);
            if(currentURL.contains('homepage')){
                isHomepage = true;  
            }
            if(currentURL.contains('maintenance_page')){
                isMaintenancepage = true;   
            }
/*
            if(cm == null){
                isActiveMessage = false;
            }else{
                preMaintenanceStart = cm.StartDateTime__c.addHours(-(Integer.valueOf(cm.NumHours__c)));
                preMaintenanceEnd = cm.StartDateTime__c;
            }


            if(cm != null && (datetime.now() < preMaintenanceStart && datetime.now() > cm.EndDateTime__c)){
                isActiveMessage = false;
            }
            if(cm != null && (datetime.now() > preMaintenanceStart && datetime.now() < preMaintenanceEnd)){
                isActiveMessage = true;
                inPreMaintenancePeriod = true;
            }
            if(cm != null && (datetime.now() > cm.StartDateTime__c && datetime.now() < cm.EndDateTime__c)){
                isActiveMessage = true;
                inMaintenancePeriod = true;
            } */

    }

}
/*public class Resources_CC {
    public Boolean isActiveMessage {get;set;}
    public Boolean inMaintenancePeriod {get;set;}
    public Boolean inPreMaintenancePeriod {get;set;}
    public Boolean isHost {get;set;}
    public Boolean isHomepage {get;set;}
    public Boolean isMaintenancepage {get;set;}
    
    public string getPageInfo(){
        return JSON.serialize(gpi);
    }
    public class GlobalPageInfo{
        public Boolean isGuestUser {get;set;}
        public String PageURL {get;set;} 
        
    }
    
    GlobalPageInfo gpi; 
    public Resources_CC() {
        
    }
} */