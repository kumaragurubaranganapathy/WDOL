@isTest
public class mapDemoTest {
    public static testmethod void mapDemoConstructor(){
        MUSW__Parcel__c parcel = TestUtility.getParcel();
        insert parcel;
        MUSW__Inspection__c inspection = TestUtility.getInspection();
        inspection.MUSW__Parcel__c=parcel.id;
        Test.startTest();
        mapDemo.getMarkers();
        mapDemo.getRoute();
        
        Test.stopTest();
    }
    
}