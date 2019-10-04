@isTest
public class ParcelUserSharing_Test {
    @isTest
    public static void ParcelSharing_RecordInsert_Test(){
        Id recTypeId = Schema.SObjectType.MUSW__Parcel__c.getRecordTypeInfosByName().get('Address').getRecordTypeId();
        List<MUSW__Parcel__c> parcelList = new List<MUSW__Parcel__c>();
        parcelList.add(DOL_TestDataFactory.createParcel(recTypeId));
        ParcelUserSharing ps = new ParcelUserSharing();
        ps.ParcelSharing_RecordInsert(parcelList);
    }

}