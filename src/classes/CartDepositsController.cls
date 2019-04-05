public with sharing class CartDepositsController {

    private Map<Id, MUSW__Deposit__c> m_selectedDeposits;

    public CartDepositsController(ApexPages.StandardSetController c) {
        m_selectedDeposits = new Map<Id, MUSW__Deposit__c>((List<MUSW__Deposit__c>)c.getSelected());
    }

    public PageReference initOrder(){
        PageReference cartPage = Page.Cart;
        cartPage.setRedirect(true);

        String depositIds = '';

        for(Id depId : m_selectedDeposits.keySet()){
            depositIds += depId +',';
        }

        PageReference ret = Page.Cart;
        ret.getParameters().put('depositId', depositIds);
        ret.getParameters().put('retURL', System.currentPageReference().getParameters().get('retURL'));
        ret.getParameters().put('id', System.currentPageReference().getParameters().get('id'));

        return ret;
    }
}