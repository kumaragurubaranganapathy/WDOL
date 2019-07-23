public class Add_AssociationController {
	@AuraEnabled
    public static List<MUSW__License2__c> searchForIds(String searchLicense , Id parentLicense) {
        List<MUSW__License2__c> results = [SELECT Id,Name,MUSW__Applicant__c FROM MUSW__License2__c WHERE Name =: searchLicense limit 1];
        
        if(!results.isEmpty()){
            Associations__c assc = new Associations__c();
            assc.Name__c = 'Assoc- '+ results[0].Name ;
            assc.Child_Contact__c = results[0].MUSW__Applicant__c;
            assc.Child_License__c = results[0].Id;
            assc.Parent_License__c = parentLicense;
            assc.Source_Id__c = 'Assoc- '+ results[0].Name ;
            assc.Submitted_Date__c = System.today();
            try{
                insert assc ;	
                System.debug('assc::'+assc);
            }catch(Exception e){
                System.debug('exception::'+e);
            }
        }
        return results;
    }
    
    //Method to get All associations realted to license
    @AuraEnabled
     public static List<Associations__c> getAssociations(Id parentId) {
      	 List<Associations__c> listAssoc = [select id,Name__c,Child_Contact_Name__c,Child_License_Name__c,Parent_License_Name__c,Submitted_Date__c from Associations__c where Parent_License__c =:parentId];
         System.debug('listAssoc::'+listAssoc);
         return listAssoc;
     }
    
    @AuraEnabled
    public static Boolean deleteAssociations(List<Associations__c> listAssoc){
        Boolean issuccess = false;
        if(!listAssoc.isEmpty()){
            delete listAssoc;
            issuccess = true;
        }
        return issuccess;
    }
    
    
}