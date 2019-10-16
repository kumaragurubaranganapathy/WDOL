public class Polaris_RefundTriggerHandler {
    static final List<String> APPRAISAL_MGMT_COMPANY_ITEMS = new List<String> {'Appraisal Management Companies'};
    static final List<String> CAMPING_QUEUE_ITEMS = new List<String> {'Camping Resorts'};
    static final List<String> NOTARIES_ITEMS = new List<String>{'Notary Public'};
    static final List<String> RBS_QUEUE_ITEMS = new List<String> {'Geologist','Architects','Funerals','Engineers','On-site Wastewater','Landscape Architects','Cemeteries','Land Surveyors'};
    static final List<String> REAL_ESTATE_APPRAISERS_COURSES_ITEMS = new List<String>{'Appraiser Course'};
    static final List<String> REAL_ESTATE_APPRAISERS_ITEMS = new List<String>{'Real Estate','Appraisers - Real Estate'};
    static final List<String> TIMESHARES_ITEMS = new List<String>{'Timeshares'};
    public static List<String> QueueNames = new List<String>{'Appraisal_Management_Company_Queue','Camping_Resorts_Queue','Notaries_Queue','RBS_Queue','Real_Estate_Appraiser_Courses_Queue','Real_Estate_Appraisers_Queue','Timeshare_Queue'};
        
    public static void handleBeforeUpdate(List<BGBK__Refund2__c> newList, Map<Id,BGBK__Refund2__c> oldMap){
        Map<Id, BGBK__Refund2__c> rejectedStatements = new Map<Id, BGBK__Refund2__c>();
        List<MUSW__Receipt__c> receiptsToBeUpdated = new List<MUSW__Receipt__c>();
        List<BGBK__Receipt_Refund__c> receiptRefundsToBeUpdated = new List<BGBK__Receipt_Refund__c>();
        List<MUSW__Deposit__c> depositsToBeUpdated = new List<MUSW__Deposit__c>();
        List<BGBK__Receipt_Refund__c> receiptRefundList = [Select id, BGBK__Refund2__c,BGBK__Receipt__c,BGBK__Amount__c,BGBK__Receipt__r.MUSW__Amount_Refunded__c,BGBK__Receipt__r.MUSW__Amount_Available__c,BGBK__Deposit__c,BGBK__Deposit__r.MUSW__Refunded_Amount__c from BGBK__Receipt_Refund__c where BGBK__Refund2__c in: newList ];
        List<Group> queueList = [select Id, DeveloperNAME from Group where Type = 'Queue' AND DeveloperNAME In: QueueNames];
        Map<String,Id> QueueNameToIdMap = new Map<String,Id>();
        List<BGBK__Refund2__c> refundsToBeUpdated = new List<BGBK__Refund2__c>();
        for(Group grp : queueList){
            QueueNameToIdMap.put(grp.DeveloperNAME,grp.Id);
        }
        for(BGBK__Refund2__c ref: newList){
            /*Get the old object record, and check if the approval status field has been updated to rejected. If so, put it in a map 
so we only have to use 1 SOQL query to do all checks.
*/
            if(oldMap.get(ref.Id).Approval_Status__c != 'Rejected' && ref.Approval_Status__c == 'Rejected' ){ 
                rejectedStatements.put(ref.Id, ref); 
            }
            if(oldMap.get(ref.Id).status__c != 'Rejected' && oldMap.get(ref.Id).status__c != 'Issued in Error'){
                for(BGBK__Receipt_Refund__c recRefund : receiptRefundList ){
                    if(recRefund.BGBK__Refund2__c == ref.Id && (ref.Status__c == 'Rejected' || ref.Status__c == 'Issued in Error')){
                        if(recRefund.BGBK__Deposit__c != null){ //BUG:4684
                            MUSW__Deposit__c dep = new MUSW__Deposit__c(Id=recRefund.BGBK__Deposit__c);
                            dep.MUSW__Refunded_Amount__c =  recRefund.BGBK__Deposit__r.MUSW__Refunded_Amount__c - ref.BGBK__Amount__c;
                            recRefund.BGBK__Amount__c = recRefund.BGBK__Amount__c - ref.BGBK__Amount__c;
                            receiptRefundsToBeUpdated.add(recRefund);
                            depositsToBeUpdated.add(dep);
                        }else{
                            MUSW__Receipt__c receipt = new MUSW__Receipt__c(Id=recRefund.BGBK__Receipt__c);
                            receipt.MUSW__Amount_Refunded__c = recRefund.BGBK__Receipt__r.MUSW__Amount_Refunded__c - ref.BGBK__Amount__c;
                            receipt.MUSW__Amount_Available__c = recRefund.BGBK__Receipt__r.MUSW__Amount_Available__c + ref.BGBK__Amount__c;
                            recRefund.BGBK__Amount__c = recRefund.BGBK__Amount__c - ref.BGBK__Amount__c;
                            // update the amount of receipt refund
                            receiptRefundsToBeUpdated.add(recRefund);
                            //update the refunded amount and available amount on receipt
                            receiptsToBeUpdated.add(receipt);
                        }
                        
                    }
                }
            }
            if(ref.Fee__c != null && oldMap.get(ref.Id).Fee__c != ref.Fee__c ){
                if(RBS_QUEUE_ITEMS.contains(ref.Program_Type__c)){
                    ref.OwnerId = QueueNameToIdMap.get('RBS_Queue');
                }else if(APPRAISAL_MGMT_COMPANY_ITEMS.contains(ref.Program_Type__c)){
                    ref.OwnerId = QueueNameToIdMap.get('Appraisal_Management_Company_Queue');
                }else if(CAMPING_QUEUE_ITEMS.contains(ref.Program_Type__c)){
                    ref.OwnerId = QueueNameToIdMap.get('Camping_Resorts_Queue');
                }else if(NOTARIES_ITEMS.contains(ref.Program_Type__c)){
                    ref.OwnerId = QueueNameToIdMap.get('Notaries_Queue');
                }else if(REAL_ESTATE_APPRAISERS_COURSES_ITEMS.contains(ref.Program_Type__c)){
                    ref.OwnerId = QueueNameToIdMap.get('Real_Estate_Appraiser_Courses_Queue');
                }else if(REAL_ESTATE_APPRAISERS_ITEMS.contains(ref.Program_Type__c)){
                    ref.OwnerId = QueueNameToIdMap.get('Real_Estate_Appraisers_Queue');
                }else if(TIMESHARES_ITEMS.contains(ref.Program_Type__c)){
                    ref.OwnerId = QueueNameToIdMap.get('Timeshare_Queue');
                }
            }
            //BUG 8215
            if(String.isNotBlank(ref.Status__c) 
                && (ref.Status__c == 'Issued in Error'  || ref.Status__c == 'Unclaimed Property')){
                    ref.Stage__c = 'Send Refund';
            }
        }
        if(!rejectedStatements.isEmpty()){
            // UPDATE 2/1/2014: Get the most recent approval process instance for the object.
            // If there are some approvals to be reviewed for approval, then
            // get the most recent process instance for each object.
            List<Id> processInstanceIds = new List<Id>{};
                for (BGBK__Refund2__c refs : [SELECT (SELECT ID FROM ProcessInstances ORDER BY CreatedDate DESC LIMIT 1)
                                              FROM BGBK__Refund2__c
                                              WHERE ID IN :rejectedStatements.keySet()]){
                                                  
                                                  processInstanceIds.add(refs.ProcessInstances[0].Id);
                                              }
            
            // Now that we have the most recent process instances, we can check
            // the most recent process steps for comments.  
            List<ProcessInstance> piList = [SELECT TargetObjectId,
                                            (SELECT Id, StepStatus, Comments 
                                             FROM Steps
                                             ORDER BY CreatedDate DESC
                                             LIMIT 1 )
                                            FROM ProcessInstance
                                            WHERE Id IN :processInstanceIds
                                            ORDER BY CreatedDate DESC];
            
            for (ProcessInstance pi : [SELECT TargetObjectId,(SELECT Id, StepStatus, Comments FROM Steps ORDER BY CreatedDate DESC LIMIT 1 ) FROM ProcessInstance WHERE Id IN :processInstanceIds ORDER BY CreatedDate DESC] ){
                
                if ((pi.Steps[0].Comments == null || pi.Steps[0].Comments.trim().length() == 0)){
                    rejectedStatements.get(pi.TargetObjectId).addError('Operation Cancelled: Please provide a rejection reason!');
                }
            }
        }
        
        if(receiptsToBeUpdated.size() > 0){
            update receiptsToBeUpdated;
        }
        if(receiptRefundsToBeUpdated.size() >0){
            update receiptRefundsToBeUpdated;
        }
        if(depositsToBeUpdated.size() > 0){
            update depositsToBeUpdated;
        }
        
    }
    public static void handleAfterUpdate(List<BGBK__Refund2__c> newList,Map<Id,BGBK__Refund2__c> oldMap){
        List<BGBK__Refund2__c> refundsWithStatusUpdate = new List<BGBK__Refund2__c>();
        List<String> refundeeIdList = new List<String>();
        for(BGBK__Refund2__c ref: newList){
            if(oldMap.get(ref.Id).status__c != ref.Status__c || oldMap.get(ref.Id).stage__c != ref.Stage__c ){
                refundsWithStatusUpdate.add(ref);
            }
            if(String.isNotBlank(ref.BGBK__Contact__c)){
                refundeeIdList.add(ref.BGBK__Contact__c);
            }
        }
        if(refundsWithStatusUpdate.size() >0){
            updateReceiptRefundStatus(refundsWithStatusUpdate);
        }

        if(!refundeeIdList.isEmpty()){
            updateContactMailingAddress(refundeeIdList);
        }
        
       
    }
    public static void updateReceiptRefundStatus(List<BGBK__Refund2__c> newList){
        List<BGBK__Receipt_Refund__c> receiptRefundList = [Select id, BGBK__Refund2__c,BGBK__Refund2__r.Status__c,BGBK__Refund2__r.Stage__c,Status__c,Stage__c from BGBK__Receipt_Refund__c where BGBK__Refund2__c in: newList ];
        List<BGBK__Receipt_Refund__c> receiptRefundToBeUpdated = new List<BGBK__Receipt_Refund__c>();
        for(BGBK__Receipt_Refund__c recRef: receiptRefundList){
            if(recRef.Status__c != recRef.BGBK__Refund2__r.Status__c || recRef.Stage__c != recRef.BGBK__Refund2__r.Stage__c){
                recRef.Status__c = recRef.BGBK__Refund2__r.Status__c;
                recRef.Stage__c = recRef.BGBK__Refund2__r.Stage__c;
                receiptRefundToBeUpdated.add(recRef);
            }
        }
        if(receiptRefundToBeUpdated.size() >0){
            update receiptRefundToBeUpdated;
        }
    }

    public static void updateContactMailingAddress(List<String> refundeeContactIdList){
       // system.debug('==refundeeContactIdList=='+refundeeContactIdList);
        try{
            if(!refundeeContactIdList.isEmpty()){
                //Fetch the parcel contact using refundee Id
                List<MUSW__Parcel_Contact2__c> parcelContactList = [Select Id,Name, MUSW__Contact__c, MUSW__Contact_Type__c,Mailing__c,
                                                                    MUSW__Parcel__r.MUSW__Street_Number__c,MUSW__Parcel__r.MUSW__Street_Direction__c,MUSW__Parcel__r.MUSW__Street2__c, 
                                                                    MUSW__Parcel__r.MUSW__Street_Suffix__c,MUSW__Parcel__r.MUSW__Unit__c ,MUSW__Parcel__r.MUSW__Unit_Type__c,
                                                                    MUSW__Parcel__r.MUSW__City__c ,MUSW__Parcel__r.MUSW__Post_Zip_Code__c ,MUSW__Parcel__r.MUSW__State__c,
                                                                    MUSW__Parcel__r.Country__c 
                                                                    from MUSW__Parcel_Contact2__c 
                                                                    where MUSW__Contact__c IN: refundeeContactIdList];
                //system.debug('==parcelContactList=='+parcelContactList);
                Map<Id,MUSW__Parcel_Contact2__c> parcelContactMap = new Map<Id,MUSW__Parcel_Contact2__c>();
                if(!parcelContactList.isEmpty()){
                    for(MUSW__Parcel_Contact2__c parcelCont:parcelContactList){
                        if(!parcelContactMap.containsKey(parcelCont.MUSW__Contact__c)){
                            parcelContactMap.put(parcelCont.MUSW__Contact__c,parcelCont);
                        }
                    }
                }
                //system.debug('==parcelContactMap=='+parcelContactMap);
                //Fetch the contact list using refundee Id
                List<Contact> contactList = [select Id,Name,MailingAddress,MailingCity,MailingCountry,
                                            MailingGeocodeAccuracy,MailingLatitude,MailingLongitude,
                                            MailingPostalCode,MailingState,MailingStreet 
                                            from Contact 
                                            where Id IN:refundeeContactIdList];
                //system.debug('==contactList=='+contactList);
                List<Contact> upsertContactList = new List<Contact>(); 
                if(!contactList.isEmpty()){
                    for(Contact cont:contactList){
                        MUSW__Parcel_Contact2__c parcelCont = parcelContactMap.get(cont.Id);
                        if(parcelCont != null){
                            Contact contact = new Contact();
                            contact.Id = cont.Id;
                            String streetValue = '';
                            if(String.isNotBlank(parcelCont.MUSW__Parcel__r.MUSW__Street_Number__c)){
                                streetValue = parcelCont.MUSW__Parcel__r.MUSW__Street_Number__c;
                            }
                            if(String.isNotBlank(parcelCont.MUSW__Parcel__r.MUSW__Street_Direction__c)){
                                if(String.isNotBlank(streetValue)){
                                    streetValue = streetValue+' '+parcelCont.MUSW__Parcel__r.MUSW__Street_Direction__c;
                                }else{
                                    streetValue = parcelCont.MUSW__Parcel__r.MUSW__Street_Direction__c;
                                }
                            }
                            if(String.isNotBlank(parcelCont.MUSW__Parcel__r.MUSW__Street2__c)){
                                if(String.isNotBlank(streetValue)){
                                    streetValue = streetValue+' '+parcelCont.MUSW__Parcel__r.MUSW__Street2__c;
                                }else{
                                    streetValue = parcelCont.MUSW__Parcel__r.MUSW__Street2__c;
                                }
                            }
                            if(String.isNotBlank(parcelCont.MUSW__Parcel__r.MUSW__Street_Suffix__c)){
                                if(String.isNotBlank(streetValue)){
                                    streetValue = streetValue+' '+parcelCont.MUSW__Parcel__r.MUSW__Street_Suffix__c;
                                }else{
                                    streetValue = parcelCont.MUSW__Parcel__r.MUSW__Street_Suffix__c;
                                }
                            }
                            if(String.isNotBlank(parcelCont.MUSW__Parcel__r.MUSW__Unit_Type__c)){
                                if(String.isNotBlank(streetValue)){
                                    streetValue = streetValue+','+parcelCont.MUSW__Parcel__r.MUSW__Unit_Type__c;
                                }else{
                                    streetValue = parcelCont.MUSW__Parcel__r.MUSW__Unit_Type__c;
                                }
                            }
                            if(String.isNotBlank(parcelCont.MUSW__Parcel__r.MUSW__Unit__c)){
                                if(String.isNotBlank(streetValue)){
                                    streetValue = streetValue+' '+parcelCont.MUSW__Parcel__r.MUSW__Unit__c;
                                }else{
                                    streetValue = parcelCont.MUSW__Parcel__r.MUSW__Unit__c;
                                }
                            }
                            if(String.isNotBlank(streetValue)){
                                contact.MailingStreet = streetValue;
                            }
                            if(String.isNotBlank(parcelCont.MUSW__Parcel__r.MUSW__City__c)){
                                contact.MailingCity = parcelCont.MUSW__Parcel__r.MUSW__City__c;
                            }
                            if(String.isNotBlank(parcelCont.MUSW__Parcel__r.Country__c)){
                                contact.MailingCountry = parcelCont.MUSW__Parcel__r.Country__c;
                            }
                            if(String.isNotBlank(parcelCont.MUSW__Parcel__r.MUSW__Post_Zip_Code__c)){
                                contact.MailingPostalCode = parcelCont.MUSW__Parcel__r.MUSW__Post_Zip_Code__c;
                            }
                            if(String.isNotBlank(parcelCont.MUSW__Parcel__r.MUSW__State__c)){
                                contact.MailingState = parcelCont.MUSW__Parcel__r.MUSW__State__c;
                            }
                            upsertContactList.add(contact);
                        }
                    }
               //     system.debug('==upsertContactList=='+upsertContactList);
                    if(!upsertContactList.isEmpty()){
                        upsert upsertContactList;
                    }
                }
            }
        }catch(Exception ex){
             DOL_CreateErrorLog_Exception.logApplicationError(ex);
        }
    }

}