/*
* classname 	:  DOL_AbondonedPendingActions
* @description 	:  This is schedulable class used to set status for pending Applicant as "Abandoned"
* @author 		:  Gunjit Kaur
* @date 		:  07/15/2019
* MODIFICATION LOG:
* DEVELOPER                     DATE                               DESCRIPTION
* ---------------------------------------------------------------------------------------------
* Gunjit Kaur	     
**/

global class DOL_AbondonedPendingActions implements Schedulable {
    public static final String PENDING_ACTION = 'Pending action';
    public static final String ABANDONED = 'Abandoned';
    
    /**
	* method 		: getPendingActionLicenseData
	* @description 	: This method is used to fetch licenses having pending action as status from last 120 days
	* @author 		: Gunjit Kaur
	* @return 		: void 
	* */
    global void execute(SchedulableContext ctx) {
        List<Database.SaveResult> srList = new List<Database.SaveResult>();
        String outputResponse;
        List<MUSW__License2__c> licenseRecordList = new List<MUSW__License2__c>();
        for(MUSW__License2__c licenseRecords: [Select Id, Name, LastModifiedDate, MUSW__Status__c From MUSW__License2__c 
                                               Where MUSW__Status__c = :PENDING_ACTION And LastModifiedDate <= :DATE.TODAY()-120]){
                                                  licenseRecords.MUSW__Status__c = ABANDONED;
                                                  licenseRecordList.add(licenseRecords);
            
        } 
        if(!licenseRecordList.isEmpty()){
            srList = Database.update(licenseRecordList, false);
        }
        // Iterate through each returned result
        for (Database.SaveResult sr : srList) {
            if (sr.isSuccess()) {
                // Operation was successful, so get the ID of the record that was processed
                //System.debug('Successfully updated license record. review ID: ' + sr.getId());
                outputResponse ='Successfull';
            }
            else {
                // Operation failed, so get all errors                
                for(Database.Error err : sr.getErrors()) {
                    System.debug('The following error has occurred.');                    
                    System.debug(err.getStatusCode() + ': ' + err.getMessage());
                    System.debug('License fields that affected this error: ' + err.getFields());
                }
                outputResponse ='Fail';
            }
        }
    }
}