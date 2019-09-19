@isTest
public class Dol_SOSResponse_Test {

    public static String mockSOSserviceResponse = DOL_AppConstants.NULL_EMPTY_STRING + '{"entity":{"businessName":"SEATTLE SOUNDERS, LLC","ubi":"601810719","category":"LLC","businessType":"LLC","typeDescription":"WA LIMITED LIABILITY COMPANY","active":"Inactive","dateOfIncorporation":"8/12/1997 12:00:00 AM","expirationDate":"8/31/2007 12:00:00 AM","dissolutionDate":"12/3/2007 12:00:00 AM","duration":"8/12/2027 12:00:00 AM","registeredAgentName":"ADRIAN HANAUER","registeredAgentAddress":"1964 4TH AVE S  ","registeredAgentCity":"SEATTLE","registeredAgentState":"WA","registeredAgentZip":"98134 ","alternateAddress":"","alternateCity":"","alternateState":"","alternateZip":"","governingPerson":[{"title":"GOVERNOR","lastName":"HANAUER","middleName":"","firstName":"ADRIAN"}]},"error":{"errorCode":"404","errroMsg":"UBI not found","errorDesc":"HTTP GET on resource failed: not found","errorType":"NOT_FOUND","errorTime":"2019-04-25T10:24:16.892Z"}}';
     private static testmethod void test_SOSservice() {
        Dol_SOSResponse res = Dol_SOSResponse.parse(mockSOSserviceResponse);
    }
    
}