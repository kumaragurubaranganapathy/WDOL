public class Dol_ImageTokenResponse{
    public ImageToken imageToken {get;set;}
	public String message {get;set;}	//Service Error
	public Request request{get;set;}
	public boolean hasErrors{get;set;}
	public Error[] errors{get;set;}
    
	public class ImageToken {
		public string ErrorCode{get;set;}
		public string ErrorMessage{get;set;}
		public string ImageLink{get;set;}
		public String ImageName{get;set;}	//20190912142589701
		public string ImageTokenDate;
		public String ImageTokenID {get;set;}	//2700000010
		public String ProfessionCode{get;set;}	//27010
		public String SourceIP{get;set;}	//67.188.30.169
		public String UserName{get;set;}	//nswain@deloitte.com
		public boolean ValidToken{get;set;}
	}
    public class Request {
       public ImageToken imageTokenReq{get;set;}
    }
    public class Error {
       public String ErrorMessage {get;set;}
       public String[] MemberNames{get;set;}
    }
    public static Dol_ImageTokenResponse parse(String json){
		return (Dol_ImageTokenResponse) System.JSON.deserialize(json, Dol_ImageTokenResponse.class);
	}
}