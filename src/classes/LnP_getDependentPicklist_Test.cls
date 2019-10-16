@isTest
public class LnP_getDependentPicklist_Test {
 
    public static testmethod void LnP_getDependentPicklistConstructor(){
        MUSW__License2__c licenseObj = new MUSW__License2__c();
        Test.startTest();
        try{
        Map<String, List<String>> returnValue = LnP_getDependentPicklist.getDependentMap(licenseObj,'Credential_Type__c','Application_Method__c');
        Map<String, List<String>> returnValue1 = LnP_getDependentPicklist.getDependentMap(licenseObj,'Credential_Type__c',null);
            Map<String, List<String>> returnValue2 = LnP_getDependentPicklist.getDependentMap(null,'Credential_Type__c','Application_Method__c');}
        catch(Exception e){
            DOL_CreateErrorLog_Exception.logApplicationError(e);
          //  System.debug('Error Occured');
        }
        Test.stopTest();
    }
}