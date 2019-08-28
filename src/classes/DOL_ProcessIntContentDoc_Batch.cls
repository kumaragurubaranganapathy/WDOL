/************************************************************************************************************
** Name             : DOL_ProcessIntContentDoc_Batch
** Description   	: Process ContentVersion Document and save the record to DOL_Integration_Batch_Input__c.
** Version          : 1.0
** Story			: US-****
**-------------------------------------
** Revision History:
**---------------------------
** [Laltu Banerjee]: Created
*************************************************************************************************************/
global class DOL_ProcessIntContentDoc_Batch implements Database.Batchable<sObject> {
    private List<Id> dolIntegrationBatchIds; 
    
    global DOL_ProcessIntContentDoc_Batch(List<Id> ids){
        this.dolIntegrationBatchIds = ids;
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator([ select Id, INFO__c, Input__c, File_Name__c, Input_Type__c, Status__c from DOL_Integration_Batch_Input__c where Id IN :dolIntegrationBatchIds ]);
    }
    
    global void execute(Database.BatchableContext BC, List<DOL_Integration_Batch_Input__c> records){
        List<DOL_Integration_Batch_Input__c> tempBatchInputList = new List<DOL_Integration_Batch_Input__c>();
        String tempFileData;
        for(DOL_Integration_Batch_Input__c input : records){
            try{
                tempFileData = DOL_ContentVersionUtility.retriveDatafromContent(input.Id, input.File_Name__c);
                tempBatchInputList.addAll(getDOLIntegrationBatchInputs(input, tempFileData));
                input.Status__c = 'DATA LOADING COMPLETED';
            }
            catch(Exception error){
                DOL_CreateErrorLog_Exception.logApplicationError(error, 'DOL_ProcessIntContentDoc_Batch', 'execute');
                input.Status__c = 'FAILED';
                input.INFO__c += ' '+'error occured :- '+error.getMessage()+' stack trace '+error.getStackTraceString();
            }
        }
        DOL_Dao.save(records);
        if(!tempBatchInputList.isEmpty())
            DOL_Dao.save(tempBatchInputList);
    }
    
    global void finish(Database.BatchableContext BC){}
    
    
    private List<DOL_Integration_Batch_Input__c> getDOLIntegrationBatchInputs(DOL_Integration_Batch_Input__c input, String fileData){
        if(input.Input_Type__c == 'DOR')
            return getBatchInputsForDOR(fileData);
        else if(input.Input_Type__c == 'REMITTANCE')
            return getBatchInputsForRemittance(fileData);
        else if(input.Input_Type__c == 'NCR')
            return getBatchInputsForNCR(fileData);
        else
            return new List<DOL_Integration_Batch_Input__c>();
    }
    
    private List<DOL_Integration_Batch_Input__c> getBatchInputsForNCR(String fileData){
        List<DOL_NCR_Input> dolInputs = DOL_NCR_Input.parseArray(fileData);
        List<DOL_Integration_Batch_Input__c> batchInputs = new List<DOL_Integration_Batch_Input__c>();
        DOL_Integration_Batch_Input__c tempBatchInput;
        for(DOL_NCR_Input rec : dolInputs){
            tempBatchInput = new DOL_Integration_Batch_Input__c();
            tempBatchInput.File_Name__c = rec.fileName;
            tempBatchInput.Input__c = JSON.serialize(rec);
            tempBatchInput.Input_Type__c = 'NCR';
            tempBatchInput.Status__c = 'UNPROCESSED';
            batchInputs.add(tempBatchInput);
        }
        return batchInputs;
    }
    
    private List<DOL_Integration_Batch_Input__c> getBatchInputsForRemittance(String fileData){
        List<DOL_EpaymentRemittanceInput> dolInputs = DOL_EpaymentRemittanceInput.parseArray(fileData);
        List<DOL_Integration_Batch_Input__c> batchInputs = new List<DOL_Integration_Batch_Input__c>();
        DOL_Integration_Batch_Input__c tempBatchInput;
        for(DOL_EpaymentRemittanceInput rec : dolInputs){
            tempBatchInput = new DOL_Integration_Batch_Input__c();
            tempBatchInput.File_Name__c = rec.fileName;
            tempBatchInput.Input__c = JSON.serialize(rec);
            tempBatchInput.Input_Type__c = 'REMITTANCE';
            tempBatchInput.Status__c = 'UNPROCESSED';
            batchInputs.add(tempBatchInput);
        }
        return batchInputs;
    }
    
    private List<DOL_Integration_Batch_Input__c> getBatchInputsForDOR(String fileData){
        List<DOL_DOR_Input> dolDorInputs = DOL_DOR_Input.parseArray(fileData);
        List<DOL_Integration_Batch_Input__c> batchInputs = new List<DOL_Integration_Batch_Input__c>();
        DOL_Integration_Batch_Input__c tempBatchInput;
        for(DOL_DOR_Input rec : dolDorInputs){
            tempBatchInput = new DOL_Integration_Batch_Input__c();
            tempBatchInput.File_Name__c = rec.fileName;
            tempBatchInput.Input__c = JSON.serialize(rec);
            tempBatchInput.Input_Type__c = 'DOR';
            tempBatchInput.Status__c = 'UNPROCESSED';
            batchInputs.add(tempBatchInput);
        }
        return batchInputs;
    }
	
}