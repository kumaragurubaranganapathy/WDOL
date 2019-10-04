@isTest
public class DOL_SharingBypass_Test {
    @isTest
    public static void dmlOnGenericSobjectListTest(){
        test.startTest();
        Id accRecTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Business Account').getRecordTypeId();
        List<Account> accList = new List<Account>();
        accList.add(new Account(Name= 'Test Account',RecordTypeId=accRecTypeId));
        DOL_SharingBypass.dmlOnGenericSobjectList(accList,'insert');
        Account acc = DOL_TestDataFactory.createAccount(accRecTypeId);
        List<Account> accListtoBeUpdated = new List<Account>();
        acc.Name = 'Updated Name';
        accListtoBeUpdated.add(acc);
        DOL_SharingBypass.dmlOnGenericSobjectList(accListtoBeUpdated,'update');
        List<Account> accListtoBeUpserted = new List<Account>();
        acc.Name = 'Upsert Name';
        accListtoBeUpserted.add(acc);
        DOL_SharingBypass.dmlOnGenericSobjectList(accListtoBeUpserted,'upsert');
        DOL_SharingBypass.dmlOnGenericSobjectList(accListtoBeUpserted,'delete');
        
        
    }

}