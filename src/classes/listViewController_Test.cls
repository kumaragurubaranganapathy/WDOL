@isTest
public class listViewController_Test {
    
    @isTest
    public static void listViewData(){
       
        String ObjInfo = 'MUSW__License2__c';
        Test.startTest();
     
         String listViewDetails = (listViewController.listValues(ObjInfo) != null) ? ('Success'):('Fail');
        Test.stopTest();
      //   system.debug('listViewDetails---'+listViewDetails);
    }
}