/************************************************************************************************************
** Name             : DOL_Dao
** Description   	: NCR File Data Input
** Version          : 1.0
**-------------------------------------
** Revision History:
**---------------------------
** [Laltu Banerjee]: Created
*************************************************************************************************************/
public class DOL_NCR_Input {
    
	public String FileName;
    public String PolarisRecordID;
    public String ProfCode;
    public String LicenseNumber;
	public String ValidationDate; // in MM/DD/YYYY format
	public String ValidationItemNum;
	public String ValidationSeqNum;
	public String ValidationAmount; 
	public String ImageName;
	public String ncrFileImageURL;
	public String ImageLabel;
    
    
    public static DOL_NCR_Input parse(String json) {
		return (DOL_NCR_Input) System.JSON.deserialize(json, DOL_NCR_Input.class);
	}
	
	public static List<DOL_NCR_Input> parseArray(String json) {
		return (List<DOL_NCR_Input>) System.JSON.deserialize(json, List<DOL_NCR_Input>.class);
	}

}