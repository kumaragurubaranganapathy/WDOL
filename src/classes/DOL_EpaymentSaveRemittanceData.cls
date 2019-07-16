public class DOL_EpaymentSaveRemittanceData {
    
    public HTTPRestResponse saveRemittanceData(String jsonString){
        HTTPRestResponse response = HTTPRestResponse.getInstance();
        try{
            List<DOL_EpaymentRemittanceInput> remittanceInput = DOL_EpaymentRemittanceInput.parseArray(jsonString);
            EpaymentRemittanceData__c tempObj = null;
            List<EpaymentRemittanceData__c> remittanceDataList = new List<EpaymentRemittanceData__c>();
            for(DOL_EpaymentRemittanceInput input : remittanceInput){
                tempObj = new EpaymentRemittanceData__c();
                tempObj.File_Name__c = input.fileName;
                tempObj.Details__c = JSON.serialize(input);
                remittanceDataList.add(tempObj);
            }
            List<Id> sobjectIds = DOL_Dao.save(remittanceDataList);
            response.addLog('Created record Ids = '+sobjectIds);
            response.addLog('successfully Completed');
            response.setStatusCode(200);
        }catch(Exception error){
            response.addErrorMsg('error occured '+error.getMessage());
            response.addErrorMsg(' stack trace '+error.getStackTraceString());
            response.setStatusCode(400);
        }
        return response;
    }

}