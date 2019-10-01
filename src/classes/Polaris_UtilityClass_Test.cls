/* 
*Class Name   : Polaris_UtilityClass_Test
* Description  : Testclass for Polaris_UtilityClass
* Created By   : Shreya Surabhi
* Created On   : 19/09/2019 
* Modification Log:  
*------------------------------------------------------------------------------------------------------------------------------------------------------------------------
* Developer                    Date                        Description
*------------------------------------------------------------------------------------------------------------------------------------------------------------------------
*
*/
@isTest(SeeAllData=true)
public class Polaris_UtilityClass_Test{
    static testMethod void testMethod1(){
    User presentUser = [select id, Name from User where id =: UserInfo.getUserId() limit 1];
    System.runAs(presentUser){
    Polaris_UtilityClass testUtility = new Polaris_UtilityClass();
    
    //Folder newFolder = new Folder(Name='James Bond',AccessType='Public',DeveloperName='James_Bond',IsReadonly=False,Type='Email');
    //insert newFolder;
    EmailTemplate newEmailTemp = new EmailTemplate(Name='Bond Cancellation',DeveloperName='Bond_Cancellation',TemplateType='Text',FolderId=UserInfo.getUserId());
    insert newEmailTemp;
    OrgWideEmailAddress newOrgAdd = [SELECT Id, Address FROM OrgWideEmailAddress LIMIT 1];
    
    Test.startTest();
    EmailTemplate returntemplate = testUtility.getEmailTemplate(newEmailTemp.Name);
    returntemplate = testUtility.getEmailTemplate(null);
    Id returnValue = testUtility.getOrgWideEmailAddressId(newOrgAdd.Address);
    List<String> returnPicklist = Polaris_UtilityClass.getPicklist();
    List<String> returnProgramPicklist = Polaris_UtilityClass.getProgramPicklist();
    Test.stopTest();
    }
        
    }
}