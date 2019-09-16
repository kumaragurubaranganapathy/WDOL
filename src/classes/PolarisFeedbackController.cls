public with sharing class PolarisFeedbackController {
    @auraEnabled
    public static void createRecord(User_Feedback__c userfeedback){
        try{
            date d = system.today();
            List<sObject> allObjList = new List<sObject>();
            Id portalUser = getCommunityUserContactId(); // Current user id
            DateTime holdCreatedDate;
            String licenseIdNeeded;
            List<User_Feedback__c> userfeedbackObjList = new List<User_Feedback__c>();
            List<MUSW__License2__c> licenseList = [Select id,name,MUSW__Applicant__c, Application_Method__c, Profession_Code__c, createdDate from MUSW__License2__c where MUSW__Applicant__c =:portalUser order by CreatedDate desc limit 1 ];
            allObjList.addAll(licenseList);
            
            List<Renewal_Application__c> renewalList = [select id,License__c,License__r.Profession_Code__c,Applicant__c,Renewal_Reinstatement_Type__c,createdDate from Renewal_Application__c order by createdDate desc limit 1];
            allObjList.addAll(renewalList);
            
            List<Request__c> AMRList = [select id,License__c,License__r.Profession_Code__c,Contact__c,Service_Request_Type__c,createdDate from Request__c order by createdDate desc limit 1];
            allObjList.addAll(AMRList);
                
            List<Endorsement__c> EndorsmentList = [select id,License__c,License__r.Profession_Code__c,License__r.MUSW__Applicant__c,createdDate from Endorsement__c order by createdDate desc limit 1];            
                        
            if(licenseList[0].createdDate > renewalList[0].createdDate){
                licenseIdNeeded = 'license';
                holdCreatedDate = licenseList[0].createdDate;
            }
            else{
                holdCreatedDate = renewalList[0].createdDate;
                licenseIdNeeded = 'Renewal';
            }
            if(holdCreatedDate < AMRList[0].createdDate){
                holdCreatedDate = AMRList[0].createdDate;
                licenseIdNeeded = 'AMR';
            }            
                
            if(holdCreatedDate < EndorsmentList[0].createdDate){
                licenseIdNeeded = 'Endorsment';
                holdCreatedDate = EndorsmentList[0].createdDate;
            }
            System.debug('***licenseIdNeeded***'+licenseIdNeeded);
            System.debug('***holdCreatedDate***'+holdCreatedDate);
            if(licenseIdNeeded =='License'){
                userfeedback.License__c = licenseList[0].Id;
                userfeedback.Name__c = licenseList[0].MUSW__Applicant__c;
                userfeedback.ProfCode__c = licenseList[0].Profession_Code__c;
                userfeedback.Type__c = 'License Application - '+licenseList[0].Application_Method__c;
            }
            if(licenseIdNeeded =='Renewal'){
                userfeedback.Renewal_Reinstatement_Application__c= renewalList[0].Id;
                userfeedback.License__c = renewalList[0].License__c;
                userfeedback.Name__c = renewalList[0].Applicant__c;
                userfeedback.ProfCode__c = renewalList[0].License__r.Profession_Code__c;
                userfeedback.Type__c = renewalList[0].Renewal_Reinstatement_Type__c+'Application';
            }
            if(licenseIdNeeded =='AMR'){
                userfeedback.AMR_Application__c= AMRList[0].Id;
                userfeedback.License__c = AMRList[0].License__c;
                userfeedback.Name__c = AMRList[0].Contact__c;
                userfeedback.ProfCode__c = AMRList[0].License__r.Profession_Code__c;
                userfeedback.Type__c = AMRList[0].Service_Request_Type__c+'(AMR)'; 
            }
            if(licenseIdNeeded =='Endorsment'){
                userfeedback.Endorsement_Application__c= EndorsmentList[0].Id;
                userfeedback.License__c = EndorsmentList[0].License__c;
                userfeedback.Name__c = EndorsmentList[0].License__r.MUSW__Applicant__c;
                userfeedback.ProfCode__c = EndorsmentList[0].License__r.Profession_Code__c;
                userfeedback.Type__c = 'Endorsement Application';
            }
            userfeedbackObjList.add(userfeedback);
            System.debug('***Apex Created Record***'+userfeedback);
            if(userfeedbackObjList != null && userfeedbackObjList.size()>0){
                Utilityclass_withsharing.insertList(userfeedbackObjList);
                System.debug('***Insertion done***');
            }
        }
        catch(Exception ex){
        	DOL_CreateErrorLog_Exception.logApplicationError(ex);
            throw new AuraHandledException('An error occurred: '+ex.getMessage());
        } 
    }//End of CreateRecord method
    
    @auraEnabled
    public static void mapFieldsToFeedback(Id licenseObjId){
        try{
        	System.debug('PolarisFeedbackController'+licenseObjId);
        }catch(Exception ex){
            DOL_CreateErrorLog_Exception.logApplicationError(ex);
            throw new AuraHandledException('***An error occurred: '+ex.getMessage());
        }
    }
    
    private static Id getCommunityUserContactId(){
        try{
            Id contactId;
            for(User userRecord: [Select Id, username, contactId from User where Id = :UserInfo.getUserId() LIMIT 1]){
                contactId = userRecord.contactId;
            }
            System.debug('***contactId***' + contactId);
            return contactId;
        }catch(Exception ex)
        {
            DOL_CreateErrorLog_Exception.logApplicationError(ex);
            return null;
        }
        
    }
        
} //End of Class