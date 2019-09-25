public class mapDemo {
    
    @AuraEnabled
    public static List<MapMarker> getMarkers(){
        try{
        List<MapMarker> markers = new List<MapMarker>();
        ID userID = UserInfo.getUserID();
        /*List<MUSW__Inspection__c> inspections = [Select id, name,MUSW__Parcel__r.MUSW__Street__c, 
                                                 MUSW__Parcel__r.MUSW__City__c, MUSW__Parcel__r.Zip_Postal_Code__c,
                                                 MUSW__Parcel__r.MUSW__State__c, MUSW__Parcel__r.Country__c
                                                 from MUSW__Inspection__c where MUSW__Parcel__c <> null   ]; */
        String route = DOL_AppConstants.sRoute;
        for(MUSW__Inspection__c inspection: [Select id, name,MUSW__Parcel__r.MUSW__Street__c, 
                                                 MUSW__Parcel__r.MUSW__City__c, MUSW__Parcel__r.Zip_Postal_Code__c,
                                                 MUSW__Parcel__r.MUSW__State__c, MUSW__Parcel__r.Country__c
                                                 from MUSW__Inspection__c where MUSW__Parcel__c <> null   ]){
            route+='/';
            mapDemo.MapMarker marker = new mapDemo.MapMarker();
            mapDemo.Location location = new mapDemo.Location();
            location.Street = inspection.MUSW__Parcel__r.MUSW__Street__c;
            location.City = inspection.MUSW__Parcel__r.MUSW__City__c;
            location.PostalCode = inspection.MUSW__Parcel__r.Zip_Postal_Code__c;
            location.State = inspection.MUSW__Parcel__r.MUSW__State__c;
            location.Country = inspection.MUSW__Parcel__r.Country__c;
            if(location.Street!=null){
                route+=location.Street.replace(' ','+')+',';
            }
            if(location.City!=null){
                route+=location.City.replace(' ','+')+',';
            }
            if(location.State!=null){
                route+=location.State.replace(' ','+')+',';
            }
            if(location.PostalCode!=null){
                route+=location.PostalCode.replace(' ','+');
            }
            marker.location = location;
            marker.icon = DOL_AppConstants.sIcon;
            marker.title = inspection.name;
            marker.description = DOL_AppConstants.NULL_EMPTY_STRING + '<a href="'+URL.getSalesforceBaseUrl().toExternalForm()+'/'+inspection.id+'">'+inspection.name+'</a>';
            markers.add(marker);
        }
        return markers;
        }
         catch(Exception ex)
        {   DOL_CreateErrorLog_Exception.logApplicationError(ex);
            throw new AuraHandledException('An error occurred: '+ex.getMessage());
        }
    }
    
    @AuraEnabled
    public static String getRoute(){
        try{
       /* List<MUSW__Inspection__c> inspections = [Select id, name,MUSW__Parcel__r.MUSW__Street__c, 
                                                 MUSW__Parcel__r.MUSW__City__c, MUSW__Parcel__r.MUSW__Post_Zip_Code__c,
                                                 MUSW__Parcel__r.MUSW__State__c, MUSW__Parcel__r.Country__c
                                                 from MUSW__Inspection__c where MUSW__Parcel__c <> null ]; */
        String route = DOL_AppConstants.sRoute;
        for(MUSW__Inspection__c inspection: [Select id, name,MUSW__Parcel__r.MUSW__Street__c, 
                                                 MUSW__Parcel__r.MUSW__City__c, MUSW__Parcel__r.MUSW__Post_Zip_Code__c,
                                                 MUSW__Parcel__r.MUSW__State__c, MUSW__Parcel__r.Country__c
                                                 from MUSW__Inspection__c where MUSW__Parcel__c <> null ]){
            route+='/';
            route+=inspection.MUSW__Parcel__r.MUSW__Street__c.replace(' ','+')+','+inspection.MUSW__Parcel__r.MUSW__City__c.replace(' ','+')+','+
                inspection.MUSW__Parcel__r.MUSW__State__c.replace(' ','+')+'+'+inspection.MUSW__Parcel__r.MUSW__Post_Zip_Code__c.replace(' ','+');
        }
        return route;
        }
         catch(Exception ex)
        {DOL_CreateErrorLog_Exception.logApplicationError(ex);
            throw new AuraHandledException('An error occurred: '+ex.getMessage());
        }
    }
    class MapMarker{
        @AuraEnabled public mapDemo.Location location{get;set;}
        @AuraEnabled public String icon{get;set;}
        @AuraEnabled public String title{get;set;}
        @AuraEnabled public String description{get;set;}
    }

    class Location{
        @AuraEnabled public String Street{get;set;}
        @AuraEnabled public String City{get;set;}
        @AuraEnabled public String PostalCode{get;set;}
        @AuraEnabled public String State{get;set;}
        @AuraEnabled public String Country{get;set;}
    }
}