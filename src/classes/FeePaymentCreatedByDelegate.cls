/**
* Name: FeePaymentCreatedByDelegate
* Type: Class
* Description: Trigger handler class to handle sharing for fee payment records with the 
*              the community plus user who also happens to be the applicant of a fee payment
* Date:        Developer/Company                 	Description
* ---------------------------------------------------------------------------------------------------------------------------------------- *
* 08/21/2018   Srikanth Kottam/Deloitte           Initial Creation
**/
public class FeePaymentCreatedByDelegate {
	/**
         * @Method name   : shareFeePaymentRecords
         * @Description   : Share the feepayment records when the Delegated Admin is the applicant on the feepayment 
         * @Return Type   : None
         * @Parameter     : Trigger.new
         **/
        public void shareFeePaymentRecords(List < MUSW__Fee_Payment__c > FeePaymentShareRecords) {
            List < MUSW__Receipt__c > ReceiptList = new List<MUSW__Receipt__c>();
            List<MUSW__Fee__c> feelist = new List<MUSW__Fee__c>();
            List<Id> feePaymentIds = new List<Id>();
            Set < Id > ContactIdsSet = new Set < Id > (); 
            Set < Id > ContactIdsSet1 = new Set < Id > (); 
            set<Id> ReceiptIds = new Set<Id>();
            Map<id,id> Feeids = new map<id,id>();
            set<Id> Accountids = new Set<Id>();
            Map<id,id> feeacc = new map<id,id>();
            Map<id,id> feecon = new map<id,id>();
            SharingUtilityController utilityCOntroller = new SharingUtilityController();
            
            for (MUSW__Fee_Payment__c feepayment: FeePaymentShareRecords) {
                if (feepayment.MUSW__Receipt__c != null) {
                    ReceiptIds.add(feepayment.MUSW__Receipt__c);
                }
                if(feepayment.MUSW__Fee__c != null) {
                    Feeids.put(feepayment.MUSW__Fee__c,feepayment.id);
                    //Accountids.add(feepayment.MUSW__Fee__r.MUSW__License2__r.MUSW__Primary_Licensee__c);
                   // system.debug('feepayment.MUSW__Fee__r.MUSW__License2__r.MUSW__Primary_Licensee__c'+feepayment.MUSW__Fee__r.MUSW__License2__r.MUSW__Primary_Licensee__c);
                }
                feePaymentIds.add(feepayment.Id);
            }
            system.debug('Feeids.size()'+Feeids.size());
            if(Feeids.size() > 0)
            {
                try {
                    system.debug('here to check fee');
                    for(MUSW__Fee__c fee: [select Id, MUSW__License2__c, MUSW__License2__r.Business_License__c, MUSW__License2__r.MUSW__Primary_Licensee__c from MUSW__Fee__c where Id IN: Feeids.keyset() AND ID != null]){
                        
                        system.debug('fee shravan:'+fee.id+fee.MUSW__License2__c +'test'+fee.MUSW__License2__r.MUSW__Primary_Licensee__c);
                        if(fee.MUSW__License2__r.MUSW__Primary_Licensee__c  != null && fee.MUSW__License2__r.Business_License__c){
                            Accountids.add(fee.MUSW__License2__r.MUSW__Primary_Licensee__c );
                            feeacc.put(fee.MUSW__License2__r.MUSW__Primary_Licensee__c,fee.id);
                        }
                    }
                }
                catch(Exception e)
                {
                    ErrorLogger.logGeneralException(e, UserInfo.getUserId(), 'FeePaymentCreatedByDelegate', 'Error Occured while Querying cart List in receipt by Delegate Class', 'sharefeeRecords', 'FeePaymentCreatedByDelegate', 'HIGH');
                }
            }
            system.debug('Accountids for share:'+Accountids);
            
            if(ReceiptIds.size() > 0)
            {
                try {
                ReceiptList = [select Id, MUSW__Receipt_Paid_By__c from MUSW__Receipt__c where Id IN: ReceiptIds AND id != null];
                }
                catch(Exception e)
                {
                    ErrorLogger.logGeneralException(e, UserInfo.getUserId(), 'FeePaymentCreatedByDelegate', 'Error Occured while Querying cart List in receipt by Delegate Class', 'sharefeeRecords', 'FeePaymentCreatedByDelegate', 'HIGH');
                }
            }
            if (ReceiptList.size() > 0) {
                for (MUSW__Receipt__c receipt: ReceiptList) {
                    if (receipt.MUSW__Receipt_Paid_By__c != null) {
                        ContactIdsSet.add(receipt.MUSW__Receipt_Paid_By__c);
                    }
                }
            }
            if(Accountids.size() > 0){
                for(Musw__Account_Contact__c acccon: [select id, MUSW__Account__c, MUSW__Contact__r.User__c, MUSW__Contact__c from Musw__Account_Contact__c where  MUSW__Account__c IN: Accountids AND MUSW__Account__c != null]){
                    If(!ContactIdsSet.contains(acccon.MUSW__Contact__c) && acccon.MUSW__Contact__r.User__c != null){
                       ContactIdsSet1.add(acccon.MUSW__Contact__c);
                       feecon.put(acccon.MUSW__Contact__r.User__c,acccon.MUSW__Account__c);
                    }
                    
                }
            }
            if (feePaymentIds.size() > 0 && ContactIdsSet.size() > 0) {
                list < Id > contactids = new List < id > ();
                contactids.addAll(ContactIdsSet);
                UtilityCOntroller.ShareRecords_CreatedByDelegate(ContactIds, feePaymentIds, 'MUSW__Fee_Payment__c', 'FeePaymentCreatedByDelegate');
            }
            list<MUSW__Fee_Payment__share> fshare = new list<MUSW__Fee_Payment__share>();
            for(id i:feecon.keyset()){
                MUSW__Fee_Payment__share share  =  new MUSW__Fee_Payment__share();
                share.AccessLevel =  DOL_AppConstants.EDIT_STRING;
                share.ParentId = feeids.get(feeacc.get(feecon.get(i)));
                share.RowCause = DOL_AppConstants.ROW_CAUSE_STRING_CREATE_FEE_PAYMENT_BY_DELEGATE;
                share.UserOrGroupId = i;
                fshare.add(share);
            }
            system.debug('fshare:'+fshare);
            insert fshare;
        }
}