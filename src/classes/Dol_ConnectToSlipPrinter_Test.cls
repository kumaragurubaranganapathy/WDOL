@isTest(SeeAllData=true)
public class Dol_ConnectToSlipPrinter_Test {
 @isTest
    public static void testSlipPrinter(){
        //String userName = 'TestClassSlipPrinter';
         //List<SlipPrinterNameToUserMap__mdt> slipprinterDetail = [select IsDebugON__c, PrinterName__c, UserName__c from SlipPrinterNameToUserMap__mdt where  UserName__c=:userName limit 1];
        User admin = [SELECT id from user where Username like '%integrationuser@deloitte.com.polaris%'];
        System.runAs(admin) {

            test.startTest();
                PageReference pageRef = Page.Dol_ConnectToSlipPrinter;
                Test.setCurrentPage(pageRef);
                Dol_ConnectToSlipPrinter slipprinter = new Dol_ConnectToSlipPrinter();
             test.stopTest();
        }
    }
        
}