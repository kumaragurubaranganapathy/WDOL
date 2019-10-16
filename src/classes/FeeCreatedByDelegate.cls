/**
* Name: FeeCreatedByDelegate
* Type: Class
* Description: Trigger handler class to handle sharing for fee records with the 
*              the community plus user who also happens to be the applicant of a fee
* Date:        Developer/Company                 	Description
* ---------------------------------------------------------------------------------------------------------------------------------------- *
* 08/22/2018   Srikanth Kottam/Deloitte           Initial Creation
**/
public without sharing class FeeCreatedByDelegate {
		/**
         * @Method name   : shareFeeRecords
         * @Description   : Share the shareFeeRecords records when the Delegated Admin is the applicant  
         * @Return Type   : None
         * @Parameter     : Trigger.new
         **/
    public void shareFeeRecords(List < MUSW__Fee__c > FeeShareRecords) {
        
        //System.debug('FeeShareRecords' +FeeShareRecords);
		List<BGBK__Cart__c> cartList = new List<BGBK__Cart__c>();
        List<Id> FeeIds = new List<Id>();
        Set < Id > ContactIdsSet = new Set < Id > ();
        SharingUtilityController utilityCOntroller = new SharingUtilityController();
        set < Id > CartIds = new set < Id > ();
        
        for (MUSW__Fee__c fee: FeeShareRecords) {
            if (fee.BGBK__Cart__c != null) {
                CartIds.add(fee.BGBK__Cart__c);
            }
            FeeIds.add(fee.Id);
        }

        if (CartIds.size() > 0) {
            try {
                CartList = [select Id, BGBK__Contact__c from BGBK__Cart__c where Id IN: CartIds AND ID != null];
            } catch (exception e) {
                DOL_CreateErrorLog_Exception.logApplicationError(e);
            }
        }
		if (CartList.size() > 0) {
            for (BGBK__Cart__c cart: CartList) {
                if (cart.BGBK__Contact__c != null) {
                    ContactIdsSet.add(cart.BGBK__Contact__c);
                }
            }
        }
        if (FeeIds.size() > 0 && ContactIdsSet.size() > 0) {
            list < Id > contactids = new List < id > ();
            contactids.addAll(ContactIdsSet);
            //System.debug('contactids in 49' +contactids);
            UtilityCOntroller.ShareRecords_CreatedByDelegate(ContactIds, FeeIds, 'MUSW__Fee__c', 'FeeCreatedByDelegate');
        }
    }
}