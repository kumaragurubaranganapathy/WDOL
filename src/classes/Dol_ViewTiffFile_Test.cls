@isTest
public class Dol_ViewTiffFile_Test {
    
    @isTest
    private static void testViewURL(){
        MUSW__Submission__c submission = new MUSW__Submission__c(MUSW__BG_File_Location_Type__c ='Salesforce',Name ='Test Submission',
                                                                 SAN_Image_URL__c='http://seikichi.github.io/tiff.js/images/quad-tile.jpg.tiff');
        insert submission;
        test.startTest();
        pagereference testPage = page.Dol_ViewTiffFile;
        test.setcurrentpage(testPage);
        ApexPages.StandardController standCont = new ApexPages.StandardController(submission);
        Dol_ViewTiffFile contRoller1 = new Dol_ViewTiffFile(standCont); 
        test.stopTest();
        
    }

}