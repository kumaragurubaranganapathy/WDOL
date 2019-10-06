@isTest
public class Dol_ViewTiffFile_Test {
    
    public static final String sUrl = DOL_AppConstants.NULL_EMPTY_STRING + 'testImage';
    
    @isTest
    private static void testViewURL(){
        MUSW__Submission__c submission = new MUSW__Submission__c(MUSW__BG_File_Location_Type__c = DOL_AppConstants.NULL_EMPTY_STRING + 'Salesforce',Name = DOL_AppConstants.NULL_EMPTY_STRING + 'Test Submission',
                                                                 SAN_Image_Type__c='Renewal',SAN_Image_URL__c=sUrl,SAN_Prof_Code__c= DOL_AppConstants.NULL_EMPTY_STRING +'34345');
        insert submission;
        test.startTest();
        pagereference testPage = page.Dol_ViewTiffFile;
        test.setcurrentpage(testPage);
        ApexPages.StandardController standCont = new ApexPages.StandardController(submission);
        Dol_ViewTiffFile contRoller1 = new Dol_ViewTiffFile(standCont); 
        test.stopTest();
        
    }

}