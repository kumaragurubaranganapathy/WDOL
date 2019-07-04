public with sharing class Dol_ASCResponse {
    public DolResponse DolResponse  {get;set;}

    public class DolResponse{
        public String uid {get;set;}
    }
	
    public static Dol_ASCResponse parse(String json) {
            return (Dol_ASCResponse) System.JSON.deserialize(json, Dol_ASCResponse.class);
        }
}