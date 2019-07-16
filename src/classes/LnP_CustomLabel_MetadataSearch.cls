public class LnP_CustomLabel_MetadataSearch {
    @AuraEnabled
    public static List<String> listMetadata()
    {
        List<String> fullNameSet = new List<String>();
        MetadataService.MetadataPort service = createService();		
        List<MetadataService.ListMetadataQuery> queries = new List<MetadataService.ListMetadataQuery>();		
        MetadataService.ListMetadataQuery queryWorkflow = new MetadataService.ListMetadataQuery();
        queryWorkflow.type_x = 'CustomLabel';
        queries.add(queryWorkflow);		
        MetadataService.FileProperties[] fileProperties = service.listMetadata(queries, 32);
        for(MetadataService.FileProperties fileProperty : fileProperties) {
            //System.debug(fileProperty.fullName);
            //System.debug(fileProperty.label);
            fullNameSet.add(fileProperty.fullName);
        }
        return fullNameSet;
    }
    
    public static MetadataService.MetadataPort createService()
    { 
        String restUrl = 'callout:ApexMDAPI/services/data/v39.0/limits';
        Http h = new Http();
        HttpRequest req = new HttpRequest();
        req.setEndpoint(restUrl);
        req.setMethod('GET');
        HttpResponse res = h.send(req);
        MetadataService.MetadataPort service = new MetadataService.MetadataPort();
        service.SessionHeader = new MetadataService.SessionHeader_element();
        //service.SessionHeader.sessionId = UserInfo.getSessionId();
        service.SessionHeader.sessionId = '{!$Credential.OAuthToken}';
        //service.SessionHeader.sessionId = '00Dr000000017Hn!AR0AQAUCLW1AGkJr4l1bkxPUDhk806kRqHqLox9qjMWt56K.g6G8fU4bzq9mt3ySRY_91pw.YTkgI2MWacVWOBxqbPhmmuy7';
        return service;		
    }
}