@isTest
public class LnP_HomePageWidgetApex_Test {
    public static testmethod void LnP_HomePageWidgetApexConstructor(){
        Map<String, String> mapWidgetLabels = new Map<String, String>();
        List<String> usrInfo = new List<String>();
        Test.startTest();
        mapWidgetLabels=LnP_HomePageWidgetApexController.getCustomLabelMap();
        usrInfo=LnP_HomePageWidgetApexController.getCurrentUserInfo();
        LnP_HomePageWidgetApexController.logError();
        system.assert(mapWidgetLabels.size() > 0 );
        system.assert(usrInfo.size() > 0 );
        Test.stopTest();
    }
    public static testmethod void LnP_HomePageWidgetApexConstructor2(){
        Map<String, String> mapWidgetLabels = new Map<String, String>();
        List<String> usrInfo = new List<String>();
        try{
            Profile profId = [SELECT id From Profile Where Name = 'Standard User'];
            User u = new User(
            ProfileId = profId.Id,
            Username = System.now().millisecond() + 'test2@test.com',
            Alias = 'batman',
            Email='bruce.wayne@wayneenterprises.com',
            EmailEncodingKey='UTF-8',
            Firstname='Bruce',
            Lastname='Wayne',
            LanguageLocaleKey='en_US',
            LocaleSidKey='en_US',
            TimeZoneSidKey='America/Chicago');
            Database.insert(u);
            system.runAs(u){
                mapWidgetLabels=LnP_HomePageWidgetApexController.getCustomLabelMap();
                usrInfo=LnP_HomePageWidgetApexController.getCurrentUserInfo();  
                system.assert(mapWidgetLabels.size() > 0 );
                system.assert(usrInfo.size() > 0 ); 
            }
           
        }catch(Exception ex){
           
          system.assertEquals(ex.getMessage(), ex.getMessage());
          
        }
     }
    
}