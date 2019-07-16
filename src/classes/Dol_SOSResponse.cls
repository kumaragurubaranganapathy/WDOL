public class Dol_SOSResponse{
	public Entity entity {get;set;}
    public Error error {get;set;}
    
	public class Entity {
		public String businessName {get;set;}
		public String ubi {get;set;}
		public String category {get;set;}
		public String businessType {get;set;}
		public String typeDescription {get;set;}
		public String active {get;set;}
		public String dateOfIncorporation {get;set;}
		public String expirationDate {get;set;}
		public String dissolutionDate {get;set;}
		public String duration {get;set;}
		public String registeredAgentName {get;set;}
		public String registeredAgentAddress {get;set;}
		public String registeredAgentCity {get;set;}
		public String registeredAgentState {get;set;}
		public String registeredAgentZip {get;set;}
		public String alternateAddress {get;set;}
		public String alternateCity {get;set;}
		public String alternateState {get;set;}
		public String alternateZip {get;set;}
		public GoverningPersons[] governingPerson {get;set;}
	}
	public class GoverningPersons {
		public String title {get;set;}
		public String lastName {get;set;}
		public String middleName {get;set;}
		public String firstName {get;set;}
	}
    public class Error {
       public String errorCode {get;set;}
       public String errroMsg {get;set;}
       public String errorDesc {get;set;}
       public String errorType {get;set;}
       public String errorTime {get;set;}
    }   
	public static Dol_SOSResponse parse(String json){
		return (Dol_SOSResponse) System.JSON.deserialize(json, Dol_SOSResponse.class);
	}
}