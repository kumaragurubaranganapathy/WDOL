/*
Name: LnP_generateFeeRecords_Class
Description: LnP_generateFeeRecords_Class is used to generate the fee records for License.
Created By:Chiranrh Aradhya 
Created Date: 08/20/2019
*/
public with sharing class LnP_generateFeeRecords_Class {
 @AuraEnabled
    public static String generateFeeRecords(Id licenseId) {
        try{
            
            MUSW__License2__c license_Rec = new MUSW__License2__c();
            license_Rec = [Select Id,MUSW__Status__c,Manual_Fee_Generation__c,MUSW__Primary_Licensee__r.business_structure__c,Credential_Type__c,Initial_Contracts__c,Application_Type__c,Application_Method__c,Is_Reinstatement_Eligible__c,Application__c,Number_of_Units__c,Is_Renewal_Eligible__c FROM MUSW__License2__c  where Id =:licenseId ];
                    
            String FeeGenartionCheckStatus = Label.Fee_Generation_Check_Status;
            String FeeGenartionCompletedStatus = Label.Fee_Generation_Completed_Status;
            String FeeGenarationStatusError =Label.Fee_Generation_Status_Error;
            
            String DuplicateFeeGenarationError = Label.Duplicate_Fee_Generation_Error;
            
            if(license_Rec.MUSW__Status__c != FeeGenartionCheckStatus){
                return FeeGenarationStatusError;
            }else if(license_Rec.Manual_Fee_Generation__c == True){
                return DuplicateFeeGenarationError;
            }else{
                license_Rec.Manual_Fee_Generation__c = True;
                update license_Rec;
                return 'true';
            }          
            
        }catch(Exception ex)
        {
            DOL_CreateErrorLog_Exception.logApplicationError(ex);
            throw new AuraHandledException('An error occurred: '+ex.getMessage());
        }
    }
    
    @AuraEnabled
    public static String generateFeeRecords_Renewals(Id renewalId) {
        try{
                   

            String FeeGenartionCheckStatus = Label.Fee_Generation_Check_Status;
            String FeeGenartionCompletedStatus = Label.Fee_Generation_Completed_Status_Renewal;
            String FeeGenarationStatusError =Label.Fee_Generation_Status_Error;
            String DuplicateFeeGenarationError = Label.Duplicate_Fee_Generation_Error;
            
            Renewal_Application__c renewal_Rec = new Renewal_Application__c();
            
            renewal_Rec =[Select Id,Renewal_Status__c,Manual_Fee_Generation__c,Renewal_Reinstatement_Type__c,Credential_Type__c,Application_Type__c,Applicant__c,License_Account__c,License__c,License__r.Is_Late_Renewal_Eligible__c, License__r.Deployed__c from Renewal_Application__c where Id =:renewalId];
            
            if(renewal_Rec.Renewal_Status__c != FeeGenartionCheckStatus){
                return FeeGenarationStatusError;
            }else if(renewal_Rec.Manual_Fee_Generation__c == True){
                return DuplicateFeeGenarationError;
            }else{
                renewal_Rec.Manual_Fee_Generation__c=True;
                update renewal_Rec;
                return 'True';
            }

            
        }catch(Exception ex)
        {
            DOL_CreateErrorLog_Exception.logApplicationError(ex);
            throw new AuraHandledException('An error occurred: '+ex.getMessage());
        }
    }
}