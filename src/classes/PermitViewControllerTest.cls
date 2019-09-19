@isTest
public class PermitViewControllerTest {
@isTest(seeAllData=true)
static void testLicenseView()
{
    Test.starttest();
    MUSW__Parcel__c p = new MUSW__Parcel__c(Name = DOL_AppConstants.NULL_EMPTY_STRING + '123 Ork Street');
    insert p;
    Contact c = new Contact(Firstname = DOL_AppConstants.NULL_EMPTY_STRING + 'User', Lastname= DOL_AppConstants.NULL_EMPTY_STRING + 'Test', Email= DOL_AppConstants.NULL_EMPTY_STRING + 'abc@basicgov.com');
    insert c;
    
    BGBK.RulesEngineState.setLock();
    
    MUSW__Permit2__c per = new MUSW__Permit2__c(Name= DOL_AppConstants.NULL_EMPTY_STRING + '0001', MUSW__Applicant__c = c.id, MUSW__Type__c = DOL_AppConstants.NULL_EMPTY_STRING + 'Building', Application_Type__c = DOL_AppConstants.NULL_EMPTY_STRING + 'Plan Review', Permit_Type__c = DOL_AppConstants.NULL_EMPTY_STRING + 'POWTS Petition for Variance', Program_Area__c = DOL_AppConstants.NULL_EMPTY_STRING + 'POWTS', MUSW__Parcel__c = p.id, MUSW__Status__c = DOL_AppConstants.NULL_EMPTY_STRING + 'Pending', MUSW__Work_Type__c = DOL_AppConstants.NULL_EMPTY_STRING + 'New Service', MUSW__Valuation__c = 1000);
    insert per;
    
    MUSW__Fee__c fee1 = new MUSW__Fee__c(Application_Type__c = DOL_AppConstants.NULL_EMPTY_STRING + 'Plan Review', MUSW__Type__c = DOL_AppConstants.NULL_EMPTY_STRING + 'POWTS-Holding Tank Individual Site Design', MUSW__Permit2__c = per.Id, MUSW__Amount__c = 80);
    //insert fee1;
    
    MUSW__Fee__c fee2 = new MUSW__Fee__c(MUSW__Type__c = DOL_AppConstants.NULL_EMPTY_STRING + 'POWTS-Holding Tank Individual Site Design', MUSW__Permit2__c = per.Id, MUSW__Amount__c = 1040);
    //insert fee2;
    
    BGBK.RulesEngineState.releaseLock();
    Test.stoptest();
    ApexPages.StandardController sc = new ApexPages.StandardController(per);
    PermitViewController pvc = new PermitViewController(sc);
    pvc.init();
    MUSW__Permit2__c per1 = [select MUSW__Total_Fees__c from MUSW__Permit2__c where id =: per.id];
    //system.assert(per1.MUSW__Total_Fees__c == 1120 , per1.MUSW__Total_Fees__c);  
}
}