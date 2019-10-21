@isTest
public class Dol_ImageTokenResponse_Test {

    public static String mockResponse = DOL_AppConstants.NULL_EMPTY_STRING + '{"ImageToken":{"ErrorCode":null,"ErrorMessage":null,"ImageLink":"","ImageName":"070192890010","ImageTokenDate":null,"ImageTokenID":"2703000003","ImageType":"Supporting","ProfessionCode":"27030","SourceIP":"67.188.30.169","UserName":"nswain@deloitte.com","ValidToken":false},"Message":"Successfull","Request":{"Token":{"ErrorCode":null,"ErrorMessage":null,"ImageLink":null,"ImageName":"070192890010","ImageTokenDate":null,"ImageTokenID":null,"ImageType":null,"ProfessionCode":"27030","SourceIP":"67.188.30.169","UserName":"nswain@deloitte.com","ValidToken":false}},"HasErrors":false,"Errors":[]}';
     private static testmethod void test_ImageTokenResponse() {
         Test.startTest();
        	Dol_ImageTokenResponse res = Dol_ImageTokenResponse.parse(mockResponse);
         
         Dol_ImageTokenResponse.Error error = new Dol_ImageTokenResponse.Error();
         List<Dol_ImageTokenResponse.Error> errorList = new List<Dol_ImageTokenResponse.Error>();
         error.ErrorMessage = 'ErrorMessage';
         List<String> MemberNamelist = new List<String> ();
         error.MemberNames = MemberNamelist;
         errorList.add(error);
         
         Dol_ImageTokenResponse.Request request = new Dol_ImageTokenResponse.Request();
          Dol_ImageTokenResponse.ImageToken imageTokenObj = new Dol_ImageTokenResponse.ImageToken();
          List<Dol_ImageTokenResponse.ImageToken> imageTokenList = new List<Dol_ImageTokenResponse.ImageToken>();
         imageTokenObj.ErrorCode ='123';
         imageTokenObj.ErrorMessage ='ErrorMessage';
         imageTokenObj.ImageLink ='ImageLink';
         imageTokenObj.ImageName ='ImageName';
         imageTokenObj.ImageTokenDate ='ImageTokenDate';
         imageTokenObj.ImageTokenID ='ImageTokenID';
         imageTokenObj.ProfessionCode ='ProfessionCode';
         imageTokenObj.SourceIP ='SourceIP';
         imageTokenObj.UserName ='UserName';
         imageTokenObj.ValidToken = true;
         imageTokenList.add(imageTokenObj);
		
         request.imageTokenReq = imageTokenObj;
         res.imageToken= imageTokenObj;
		 res.message  ='message';
		 res.request = request;
		 res.hasErrors = false;
		 res.errors = errorList;
         Test.stopTest();
    }
    
}