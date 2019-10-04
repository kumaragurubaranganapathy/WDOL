@isTest
public class LnP_dependentPicklist_UpdateCtrlTest {

    public static testMethod void testDependentPicklistMethod(){
        MUSW__Deposit__c dep = new MUSW__Deposit__c();
        
        test.startTest();
        LnP_dependentPicklist_UpdateCtrl.getDependentMap( (sObject)dep, 'wadol_Program_Type__c' , 'Form_number__c');
        test.stopTest();
    }
}