/**
* Name: EducationalQualController
* Description: This is a class
* Date:        - Case#/Project:            - Developer/Company                         - Description
* ------------------------------------------------------------------------------------------------------------------------- *
*
*/
public without sharing class EducationHistoryCompCC  {
    
    
    
    @RemoteAction
    public static List<Account> getAccountRecords(String searchstr){
        List<Account> lstAccounts = [SELECT Id, Name From Account WHERE Type = 'Education Institution' AND Account_Status__c =: Label.ST_Active AND Name LIKE : searchstr Order by Name ASC];
       system.debug('lstAccounts---'+lstAccounts);
        return lstAccounts;
    }
    
        @RemoteAction
    public static List<Account> getAllInstitutionNames(){
        List<Account> lstAccounts = [SELECT Id, Name From Account WHERE Type = 'Education Institution' AND Account_Status__c =: Label.ST_Active order by Name ASC];
        return lstAccounts;
    }
}