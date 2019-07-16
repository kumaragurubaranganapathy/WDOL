public class MaintenancePageCtlr {
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
    public MaintenancePageCtlr() {
        
    }
}