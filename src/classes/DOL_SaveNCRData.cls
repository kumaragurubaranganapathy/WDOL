public class DOL_SaveNCRData {
    
    public HTTPRestResponse saveNCRData(String jsonString){
        HTTPRestResponse response = HTTPRestResponse.getInstance();
        try{
        	List<DOL_NCR_Input> inputList = DOL_NCR_Input.parseArray(jsonString);
        	// create a temp object to save the data into DB
            List<NCR_File_Data__c> ncrFileDataList = new List<NCR_File_Data__c>();
            NCR_File_Data__c tempNCRFileDataObj = null;
        	for(DOL_NCR_Input input : inputList){
            	tempNCRFileDataObj = new NCR_File_Data__c();
                tempNCRFileDataObj.File_Name__c = input.fileName;
                tempNCRFileDataObj.Details__c = JSON.serialize(input);
                ncrFileDataList.add(tempNCRFileDataObj);
        	}
            List<Id> sobjectIds = DOL_Dao.save(ncrFileDataList);
            response.addLog('Created record Ids = '+sobjectIds);
            response.addLog('successfully Completed');
            response.setStatusCode(200);
        }
        catch(Exception error){
            response.addErrorMsg('error occured '+error.getMessage());
            response.addErrorMsg(' stack trace '+error.getStackTraceString());
            response.setStatusCode(400);
        }
        return response;
    }

}