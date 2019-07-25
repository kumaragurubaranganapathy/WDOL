/************************************************************************************************************
** Name             : DOL_SaveDataForIntegrationBatch
** Description   	: Save the input to ContentVersion for integration batch and call the batch with parentId
                        to parse the json and save records into DB.
** Version          : 1.0
** Story			: US-****
**-------------------------------------
** Revision History:            
**---------------------------
** [Laltu Banerjee]: Created   
*************************************************************************************************************/
public class DOL_SaveDataForIntegrationBatch {
    
     /**
    ** Name 			: saveDataForIntegrationBatch
    ** Input			: Input :- jsonString : Input from Mulesoft, inputType : Type of input 
    **                        e.g DOR, NCR, Remittance 
    ** Functionality	: Save input to content version and call batch
    ** Return			: HTTPRestResponse
    ** Author			: Laltu Banerjee
    ** Date             : 
    */
    public HTTPRestResponse saveDataForIntegrationBatch(String jsonString,String inputType){
        HTTPRestResponse response = HTTPRestResponse.getInstance();
        try{
            if(inputType.equals('RTPC')){
                DOL_RTPC_Input rtpcInput = DOL_RTPC_Input.parse(jsonString);
                DOL_Integration_Batch_Input__c batchInput = new DOL_Integration_Batch_Input__c();
                batchInput.Input_Type__c = inputType;
                batchInput.Input__c = JSON.serialize(rtpcInput);
                insert batchInput;
                response.addLog('Batch input created :- '+batchInput.Id);
                response.addLog('Process successfully Completed');
            }
            else{
                // create the temp file name and create DOL_Integration_Batch_Input__c record
                String fileName = inputType+'_'+DOL_AppUtility.getDate('ddMMYYhhmmss')+'.txt';
                DOL_Integration_Batch_Input__c batchInput = new DOL_Integration_Batch_Input__c();
                batchInput.Input_Type__c = inputType;
                batchInput.File_Name__c = fileName;
                insert batchInput;
                response.addLog('Batch Input Created, id = '+batchInput.Id);
                // create the content version record and update the DOL_Integration_Batch_Input__c record
                Id contentDocId = DOL_ContentVersionUtility.createNewFile(batchInput.Id, jsonString, fileName);
                batchInput.INFO__c = 'Content Version created , contentDocumentId is '+contentDocId;
                batchInput.Status__c = 'CONTENT VERSION CREATED';
                upsert batchInput;
                // add log in response
                response.addLog('Content Version created , contentDocumentId is '+contentDocId);
                response.addLog('Process successfully Completed');
                // add the id in the List and call the batch to execute the batch DOL_ProcessIntContentDoc_Batch
                List<Id> idList = new List<Id>();
                idList.add(batchInput.Id);
                Database.executeBatch(new DOL_ProcessIntContentDoc_Batch(idList));
            }
            response.setStatusCode(200);
        }catch(Exception error){
            response.addErrorMsg('error occured '+error.getMessage());
            response.addErrorMsg(' stack trace '+error.getStackTraceString());
            response.setStatusCode(400);
            DOL_CreateErrorLog_Exception.logApplicationError(error);
        }
        return response;
    }
}