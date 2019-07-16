public without sharing class ProjectCreation {
    
    @RemoteAction
    public static MUSW__Project_Parcel__c createproject(Musw__Project2__c proj,String permitId,String location,String parcelId){
        Savepoint sp = Database.setSavepoint();
        try{
        upsert proj;
        Musw__Permit2__c permit = new Musw__Permit2__c();
        permit.Id= permitId;
        permit.MUSW__Project2__c= proj.Id;
        update permit;
            if(parcelId!=null&&parcelId!=''){
                Delete [ Select id from MUSW__Project_Parcel__c where MUSW__Parcel__c=:parcelId];
                Delete [ Select id from MUSW__Permit_Parcel__c where MUSW__Parcel__c=:parcelId];
            }
        MUSW__Parcel__c parc = new MUSW__Parcel__c();
        parc.MUSW__State__c='WI';
        parc.MUSW__Street2__c=location;
        parc.Country__c='United States';
        parc.Status__c=Label.ST_Active;
      insert parc;
        MUSW__Project_Parcel__c projparc = new MUSW__Project_Parcel__c();
        projparc.MUSW__Project2__c=proj.Id;
        projparc.MUSW__Parcel__c=parc.Id;
         insert projparc;
        MUSW__Permit_Parcel__c permparc = new MUSW__Permit_Parcel__c();
        permparc.MUSW__Permit2__c=permit.Id;
        permparc.MUSW__Parcel__c=parc.Id;
        permparc.Site__c=true;
        insert permparc;
      MUSW__Project_Parcel__c projparc2= [select id,MUSW__Project2__c,MUSW__Parcel__c,MUSW__Project2__r.Site_Id__c from MUSW__Project_Parcel__c where id=:projparc.id limit 1 ];
       return projparc2;
        }
        catch(Exception e)
        {
             Database.rollback(sp);
             return null;
        }
    }
    
    
    @RemoteAction
    public static List<MUSW__Project2__c> getSite(String searchstr){
        List<MUSW__Project2__c> lstrsc = [Select id,County_Name__c ,Name,MUSW__Description__c ,Municipality_Type__c,Municipality_Name__c,Site_Id__c  from MUSW__Project2__c  where Site_Id__c  LIKE : searchstr  Order by Name ASC];
        return lstrsc;
    }
}