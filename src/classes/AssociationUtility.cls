/**
 * 
    Trigger Name    : AssociationUtility
    Description     : Utility Methods of Associations__c object. 
    Created By      : Deloitte Inc.,
    Created Date    : 19th June 2019
    Modification Log:
    -------------------------------------------------------------------------------------------------------------
    Developer                   Date                        Description
    --------------------------------------------------------------------------------------------------------------            
    Pramod                   19 june 2019                  Initial Creation

*/
public class AssociationUtility {

    public static void restrictChildLicensesCount(List<Associations__c> triggerNewAssociationList){
        
   	 Set<Id> parentIds =new Set<Id>();
   	 
   	 Map<id,String> parentLicenseId2LicenseNameMap = new Map<id,String>();
   	 
   	 Map<id,String> childLicenseId2LicenseNameMap = new Map<id,String>();
   	 
   	 Map<id,List<Id>> parentLicense2ChildLicenseIdListMap = new Map<id,List<Id>>();
   	 
   	 Map<String,String> parent2ChildLicenseTypes_cstm_mdtMap = new Map<String,String>();
   	 
   	 Set<id> parentIdsMaxedOut = new Set<id>();
   	 
   	 Map<String, Integer> parentLicense2MaxChildCountMap = new Map<String, Integer>();
   	 
   	 Map<String, String> parentLicense2ErrorMessage = new Map<String, String>();
   	 
   	 
   	 
   	 for(Licensing_RelationShip__mdt licenseRelation_Metadata: [SELECT Child_License_Credential__c,Columns_To_Dsiplay_In_Professional_Dashb__c,DeveloperName,Id,Is_Parent__c,Label,Language,MasterLabel,Max_Childs_Allowed__c,NamespacePrefix,Parent_License_Credential__c,Popup_Error_Message__c,QualifiedApiName FROM Licensing_RelationShip__mdt]){
   	     
   	     if(licenseRelation_Metadata.Is_Parent__c && licenseRelation_Metadata.MasterLabel!=null && licenseRelation_Metadata.Child_License_Credential__c != null){
   	         
   	         parent2ChildLicenseTypes_cstm_mdtMap.put(licenseRelation_Metadata.MasterLabel, licenseRelation_Metadata.Child_License_Credential__c);
   	         
   	         parentLicense2MaxChildCountMap.put(licenseRelation_Metadata.MasterLabel, (Integer)licenseRelation_Metadata.Max_Childs_Allowed__c);
   	         
   	         parentLicense2ErrorMessage.put(licenseRelation_Metadata.MasterLabel, licenseRelation_Metadata.Popup_Error_Message__c);
   	         
   	     } 
   	     
   	 }
   	 
   	 for(Associations__c assocObj : triggerNewAssociationList){
   	     
   	     if(assocObj.Parent_License__c != null ){
   	         
   	         parentIds.add(assocObj.Parent_License__c);
   	     }
   	     
   	 }
   	 
   	 List<Associations__c> siblingAssociationRecords = [SELECT Association_Type__c,Child_License__c,Id,Parent_License__c, Parent_License__r.Credential_Type__c, Child_License__r.Credential_Type__c 
   	                                                    FROM Associations__c 
   	                                                    where Status__c = 'Active' AND
   	                                                          Parent_License__c IN: parentIds];
   	 
        
      for(Associations__c siblingassociationRecord :siblingAssociationRecords){

          parentLicenseId2LicenseNameMap.put(siblingassociationRecord.Parent_License__c, siblingassociationRecord.Parent_License__r.Credential_Type__c);
          
          childLicenseId2LicenseNameMap.put(siblingassociationRecord.Child_License__c, siblingassociationRecord.Child_License__r.Credential_Type__c);
          
          if(parentLicense2ChildLicenseIdListMap.containsKey(siblingassociationRecord.Parent_License__c)){
              
            parentLicense2ChildLicenseIdListMap.get(siblingassociationRecord.Parent_License__c).add(siblingassociationRecord.Child_License__c);
            
          }else{
              
              parentLicense2ChildLicenseIdListMap.put(siblingassociationRecord.Parent_License__c, new List<Id>{siblingassociationRecord.Child_License__c});
          }
     }
     
     system.debug('AssociationUtility :: restrictChildLicensesCount all relationships'+JSON.serialize(parentLicense2ChildLicenseIdListMap)); 
     
     for(Id parentLicense_id :parentLicense2ChildLicenseIdListMap.keyset()){
         
         String parentLicenseName = parentLicenseId2LicenseNameMap.get(parentLicense_id);
          
          Integer count_Childs = 0;
          
          Integer Max_Childs_Allowed  = parentLicense2MaxChildCountMap.get(parentLicenseName);
          
          for(Id childLicense_id : parentLicense2ChildLicenseIdListMap.get(parentLicense_id)){
              
              String childLicenseName = childLicenseId2LicenseNameMap.get(childLicense_id);
              
              if(childLicenseName ==  parent2ChildLicenseTypes_cstm_mdtMap.get(parentLicenseName)){
                  
                  count_Childs++;
                  
                  if(count_Childs > Max_Childs_Allowed){
                      
                      parentIdsMaxedOut.add(parentLicense_id);
                      
                  }
                  
              }
          }
         
     }
     
     for(Associations__c assoc_Obj: triggerNewAssociationList){
         
         system.debug('In Restrict CHild license COunt........'+JSON.serialize(assoc_Obj));
         system.debug('In Restrict CHild license COunt........ maxed out'+JSON.serialize(parentIdsMaxedOut));
         
         if(parentIdsMaxedOut.contains(assoc_Obj.Parent_License__c)){
             
             if(parentLicenseId2LicenseNameMap.containsKey(assoc_Obj.Parent_License__c) && parentLicense2ErrorMessage.containsKey(parentLicenseId2LicenseNameMap.get(assoc_Obj.Parent_License__c)) && parentLicense2ErrorMessage.get(parentLicenseId2LicenseNameMap.get(assoc_Obj.Parent_License__c)) != null){
               assoc_Obj.addError(parentLicense2ErrorMessage.get(parentLicenseId2LicenseNameMap.get(assoc_Obj.Parent_License__c)));  
             }else{
                assoc_Obj.addError('You had reached the Maximum Limit of licensees');    
             }
             
             
         }
     }
          
    }
        
        
}