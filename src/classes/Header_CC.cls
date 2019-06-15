/*******************************************************************************
* Name          :   Header_CC
* Author        :   
* Date          :   
* Description   :   Controller for Header Component
*-------------------------------------------------------------------------------
UPDATES
Version         Developer               Date            Description
--------------------------------------------------------------------------------


--------------------------------------------------------------------------------
Test class Name
                
*******************************************************************************/

public with sharing class Header_CC {
    public Contact userContact {get; set;}
    public Integer cartCount {
    	get{
    		BGBK.CartService bgCartService = new BGBK.CartService();
            cartCount = 0;
            Set<Id> feeParentIds = new Set<Id>();
            List<MUSW__Fee__c> feeList = bgCartService.getCartFees(true);
            for (MUSW__Fee__c fee: feeList) {
            	if(fee.BGBK__Cart_Exclude__c || fee.Related_To_Id__c == null) continue;
            	feeParentIds.add(fee.Related_To_Id__c);
            }
            cartCount = feeParentIds.size();
            
            return cartCount;
    	}
    	set;
	}
    
    public Header_CC(){
        try{
            User currentUser = [Select Id, contactId From User where Id = :UserInfo.getUserId()];
            userContact = [Select Id, FirstName, LastName, Contact_Status__c From Contact Where Id = :currentUser.contactId];
            }
        catch(Exception ex){
            userContact = new Contact();
        }
    }

}