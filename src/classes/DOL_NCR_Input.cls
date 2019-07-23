public class DOL_NCR_Input {
    
	public String fileName;
    public String licenseSFDCId;
    public String programArea;
    public String profCode;
	public String licenseIdentifier;
	public String valItem;
	public String valSeq;
	public String valDate; // in MM/DD/YYYY format
	public String valAmount;
	public String imageId;
    
    
    public static DOL_NCR_Input parse(String json) {
		return (DOL_NCR_Input) System.JSON.deserialize(json, DOL_NCR_Input.class);
	}
	
	public static List<DOL_NCR_Input> parseArray(String json) {
		return (List<DOL_NCR_Input>) System.JSON.deserialize(json, List<DOL_NCR_Input>.class);
	}

}