public without sharing class OwnerDesigner {
    
    @RemoteAction
    public static List<Contact> getContacts(String searchstr){
        List<Contact> lstrsc = [SELECT Id, LastName, FirstName, Email FROM Contact  where Email  LIKE : searchstr  Order by Name ASC];
        return lstrsc;
    }
    
    @RemoteAction
    public static Database.UpsertResult upsertAffiliationRecords(Affiliation__c affiliation){
        Database.UpsertResult srList;
        try{
            if((affiliation.Type__c==Label.Str_Owner||affiliation.Type__c==Label.Str_Designer)&&affiliation.Id==null)
            {
                List<Affiliation__c> owneraffiliations= new  List<Affiliation__c>();
                List<Affiliation__c> designeraffiliations= new  List<Affiliation__c> ();
                List<Affiliation__c> affiliations= [Select id,Type__c from Affiliation__c where Permit_Plan_Review__c=:affiliation.Permit_Plan_Review__c and (Type__c=:Label.Str_Owner or  Type__c=:Label.Str_Designer)];
                for(Affiliation__c aff: affiliations)
                {
                    if(aff.Type__c==Label.Str_Owner)
                    {
                        owneraffiliations.add(aff);
                    }
                    else{
                        designeraffiliations.add(aff);
                    }
                }
                if(owneraffiliations.size()>=1&&affiliation.type__C==Label.Str_Owner)
                {
                    return null;
                }
                else  if(designeraffiliations.size()>=1&&affiliation.type__C==Label.Str_Designer){
                    return null;
                }
            }
            srList = Database.upsert(affiliation, false);
        }
        catch(Exception e){
            ErrorLogger.logGeneralException(e, UserInfo.getUserId(), 'OwnerDesigner', 'Upsert Records', 'upsertAffiliationRecords', 'OwnerDesigner', label.Str_HIGH);
        }
        return srList;
    }
}