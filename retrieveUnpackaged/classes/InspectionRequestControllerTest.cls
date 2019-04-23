@isTest
public class InspectionRequestControllerTest {
	@isTest(SeeAllData=true)
    private static void testCon_withParent()
    {
        MUSW__Parcel__c par = new MUSW__Parcel__c(Name='zsdfsf');
        insert par;
        MUSW__Permit2__c p = new MUSW__Permit2__c(MUSW__Parcel__c=par.Id, Application_Type__c = 'Plan Review', Permit_Type__c = 'POWTS Petition for Variance', Program_Area__c = 'POWTS');
        insert p;
        
        pageReference pr = Page.InspectionRequest;
        pr.getParameters().put('pid', p.id );
        Test.setCurrentPage( pr );
        
        InspectionRequestController c = new InspectionRequestController();
        c.insSelectIndex = 0;
        c.save();
    }
}