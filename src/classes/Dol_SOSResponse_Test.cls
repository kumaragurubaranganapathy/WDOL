@isTest
public class Dol_SOSResponse_Test {

    public static String mockSOSserviceResponse = '{"entity":{"businessName":"SEATTLE SOUNDERS, LLC","ubi":"601810719","category":"LLC","businessType":"LLC","typeDescription":"WA LIMITED LIABILITY COMPANY","active":"active","dateOfIncorporation":"8/12/1997 12:00:00 AM","expirationDate":"8/31/2007 12:00:00 AM","dissolutionDate":"12/3/2007 12:00:00 AM","duration":"8/12/2027 12:00:00 AM","registeredAgentName":"ADRIAN HANAUER","registeredAgentAddress":"1964 4TH AVE S  ","registeredAgentCity":"SEATTLE","registeredAgentState":"WA","registeredAgentZip":"98134 ","alternateAddress":"","alternateCity":"","alternateState":"","alternateZip":"","governingPerson":[{"title":"GOVERNOR","lastName":"HANAUER","middleName":"","firstName":"ADRIAN"}]},"error":{"errorCode":"404","errroMsg":"UBI not found","errorDesc":"HTTP GET on resource failed: not found","errorType":"NOT_FOUND","errorTime":"2019-04-25T10:24:16.892Z"}}';
     private static testmethod void test_SOSservice() {
         Test.startTest();
         Dol_SOSResponse res = Dol_SOSResponse.parse(mockSOSserviceResponse);
         Dol_SOSResponse.Entity enitityObj = new Dol_SOSResponse.Entity();
         Dol_SOSResponse.GoverningPersons governingPersonObj = new Dol_SOSResponse.GoverningPersons();
         List<Dol_SOSResponse.GoverningPersons> governingPersonObjList  = new List<Dol_SOSResponse.GoverningPersons>();
         Dol_SOSResponse.Error errorObj = new Dol_SOSResponse.Error();
         
         errorObj.errorCode = '123';
         errorObj.errroMsg = '123';
         errorObj.errorDesc = '123';
         errorObj.errorType = '123';
         errorObj.errorTime = '123';
         
         governingPersonObj.title ='title';
         governingPersonObj.lastName ='lastName';
         governingPersonObj.middleName ='middleName';
         governingPersonObj.firstName ='firstName';
         governingPersonObjList.add(governingPersonObj);
            
         enitityObj.businessName ='businessName';
         enitityObj.ubi ='12345678';
         enitityObj.category ='businessName';
         enitityObj.businessType ='businessType';
         enitityObj.typeDescription ='typeDescription';
         enitityObj.active ='active';
         enitityObj.dateOfIncorporation ='dateOfIncorporation';
         enitityObj.expirationDate ='expirationDate';
         enitityObj.dissolutionDate ='dissolutionDate';
         enitityObj.duration ='duration';
         enitityObj.registeredAgentName ='registeredAgentName';
         enitityObj.registeredAgentAddress ='registeredAgentAddress';
         enitityObj.registeredAgentCity ='registeredAgentCity';
         enitityObj.registeredAgentState ='registeredAgentState';
         enitityObj.registeredAgentZip ='registeredAgentZip';
         enitityObj.alternateAddress ='alternateAddress';
         enitityObj.alternateCity ='alternateCity';
         enitityObj.alternateState ='alternateState';
         enitityObj.alternateZip ='alternateZip';
         enitityObj.governingPerson =governingPersonObjList;
		
         res.entity = enitityObj;
         res.error = errorObj;
         Test.stopTest();
    }
    
}