public with sharing class ECart_CC{
	public Contact con { get; set; }
	public String activeTab { get; set; }
	public Id receiptId {get; set;}
	public Boolean renderPaymentForm {get; set;}
    public Payment_Gateway_Settings__mdt paymentGatewaySettings {get; set;}
	private BGBK.CartService m_cs;
	
	public List<SelectOption> payForOptions {get; set;} //Credential, Permit, PTO
    public String selectedPayForOption {get; set;}
    
    public ECart_CC(){
    	activeTab = 'fees';
    	renderPaymentForm = false;
    	m_cs = new BGBK.CartService();
        
        paymentGatewaySettings = [Select Id, DeveloperName, Endpoint__c, Biller_ID__c, Biller_Group_ID__c, Product_Code__c From Payment_Gateway_Settings__mdt where DeveloperName = 'US_Bank_Settings' limit 1];
    }
    
    public void onPageLoad(){
    	system.debug('onPageLoad start');
    	con = m_cs.getActiveContact();
    	
    	Set<String> setRelatedType = new Set<String>();
        for(MUSW__Fee__c f : feeList){
            System.debug('f>>>>>>>>>' +f);
              if(f.Related_To_Type__c!=null)
    			setRelatedType.add(f.Related_To_Type__c);
        }

        payForOptions = new List<SelectOption>();
        payForOptions.add(new SelectOption('None', 'None'));
        for(String relatedType : setRelatedType){
            System.debug(' relatedType '+relatedType);
        	payForOptions.add(new SelectOption(relatedType, relatedType));
        }
        
        if(payForOptions.size() == 2){
            selectedPayForOption = payForOptions[1].getValue();
        }
    }
    
    public List <MUSW__Fee__c> feeList {
        get {
        	system.debug('feeList ' + feeList);
            if (feeList == null) {
                feeList = m_cs.getCartFees(true);
                system.debug('feeList2 ' + feeList);
            }
            return feeList;
        }
        private set;
    }
    
    public List <FeeWrapper> fees {
        get {
            if(fees == null) {
            	fees = new List <FeeWrapper>();
            	
                Map<Id,String> mapHeaderText = new Map<Id,String>();
            	if(!String.isEmpty(selectedPayForOption)){
            		Map<Id, List<MUSW__Fee__c>> mapParentFees = new Map<Id, List<MUSW__Fee__c>>();
            		for (MUSW__Fee__c fee: feeList) {
            			if(fee.BGBK__Cart_Exclude__c) continue;
            			
            			if(fee.Related_To_Type__c == selectedPayForOption){
            				List<MUSW__Fee__c> lstFee = mapParentFees.get(fee.Related_To_Id__c);
            				if(lstFee == null){
            					lstFee = new List<MUSW__Fee__c>();
            				}
            				lstFee.add(fee);
            				mapParentFees.put(fee.Related_To_Id__c, lstFee);
                            mapHeaderText.put(fee.Related_To_Id__c, fee.Related_To_Type__c + ' Fee for ' + fee.Related_To_Name__c);
            			}
            		}
            		
            		for(Id parentId : mapParentFees.keySet()){
                        FeeWrapper feeWrap = new FeeWrapper(false, mapHeaderText.get(parentId), mapParentFees.get(parentId));
            			fees.add(feeWrap);
            		}
            	}
            }
            
            return fees;
        }
        set;
    }
    
    public void resetFeeList() {
        system.debug('in resetFee List');
        fees = null;
    }
    
    public Decimal totalAmount {
        get {
            Decimal amount = 0.0;
            for (FeeWrapper feeWrapper: fees) {
                if (feeWrapper.checked == true) {
                    for (MUSW__Fee__c f: feeWrapper.lstFee) {
                        amount += f.MUSW__Outstanding_Fee__c;
                    }
                }
                
            }
            return amount;
        }
        set;
    }
    
    public void continueToCheckout(){
    	activeTab = 'checkout';
    }
    
    public void backToItems(){
    	activeTab = 'fees';
    }
    
    public void redirectToPaymentGateway(){
    	MUSW__Receipt__c receipt = new MUSW__Receipt__c();
    	receipt.BGBK__Cart__c = m_cs.getCart().Id;
    	receipt.Status__c = 'Draft';
    	
    	List<String> feeIds = new List<String>();
    	for (FeeWrapper feeWrapper: fees) {
            if (feeWrapper.checked == true) {
                for (MUSW__Fee__c f: feeWrapper.lstFee) {
                    feeIds.add(f.Id);
                }
            }
        }
        receipt.Selected_Fees__c = String.join(feeIds, ',');
    	
    	insert receipt;
    	
    	receiptId = receipt.Id;
    	renderPaymentForm = true;
    }
    
    public class FeeWrapper {
    	public Boolean checked {get; set;}
    	public String headerText {get; set;}
    	public List<MUSW__Fee__c> lstFee {get; set;}
    	
        public FeeWrapper(Boolean checked, String headerText, List<MUSW__Fee__c> lstFee){
            this.checked = checked;
            this.headerText = headerText;
            this.lstFee = lstFee;
        }
    }
}