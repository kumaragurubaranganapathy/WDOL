/************************************************************************************************************
** Name             : DOL_ContentVersionUtility
** Description   	: Save the input into content version
** Version          : 1.0
** Story			: US-****
**-------------------------------------
** Revision History:            
**---------------------------
** [Laltu Banerjee]: Created   
*************************************************************************************************************/
public class DOL_ContentVersionUtility {
	/**
    * Helps creating content file againt the parent object
    * @param ParentRecordId -- Id against which the documents will be saved
    * @param Filedata -- File content in string format
    * @param FileName -- Name of the file to be saved
    * @return void - return ContentDocumentId in ContentVersion
    * @authod Laltu Banerjee 
    */
    public static Id createNewFile(string ParentRecordId, string Filedata, string FileName){
        //Create ContentVersion Record
        ContentVersion objContentVersionRecord = new ContentVersion();
        objContentVersionRecord.ContentLocation = 'S'; // S = within Salesforce, E = External
        objContentVersionRecord.VersionData = blob.valueOf(Filedata);
        objContentVersionRecord.Title = FileName;
        objContentVersionRecord.isMajorVersion = false;
        //cv1.ContentType = contentType;
        objContentVersionRecord.PathOnClient = FileName;
        insert objContentVersionRecord;

        list<ContentVersion> lstContentVersions = [SELECT Id, ContentDocumentId 
                                              FROM ContentVersion 
                                              WHERE Id = :objContentVersionRecord.id];                                              
    
        ContentDocumentLink objContentDocLink = new ContentDocumentLink();
        objContentDocLink.ContentDocumentId = lstContentVersions[0].ContentDocumentId;
        objContentDocLink.LinkedEntityId = ParentRecordId;
        objContentDocLink.ShareType = 'V';
        insert objContentDocLink;
        return objContentDocLink.ContentDocumentId;
    }
    
    /**
    * retriveDatafromContent --- Retrive Content version data in string format by ParentId and Name
    * @param   Id : Paernt Object Id, string : FileName
    * @return  string : Retrived data in string format
    */
    public static string retriveDatafromContent(string ParentRecordId, string FileName){
        try{
            set<id> setContentDocumentIds = new set<id>();
            if(ParentRecordId != null && FileName != null && string.isNotEmpty(ParentRecordId) && string.isNotEmpty(FileName)){
                List<ContentDocumentLink> listContentDocumentLinks = [select id, LinkedEntityId, ContentDocumentId from ContentDocumentLink where LinkedEntityId = :ParentRecordId];
                for(ContentDocumentLink objContentDocumentLink : listContentDocumentLinks){
                    setContentDocumentIds.add(objContentDocumentLink.ContentDocumentId);
                }
                if(listContentDocumentLinks != null && !listContentDocumentLinks.isEmpty()){
                    List<contentVersion> lstContentVersions = [select id, VersionData,Title,ContentDocumentId from contentVersion where ContentDocumentId = :setContentDocumentIds and title= :FileName  Order By CreatedDate DESC];
                    
                    if(lstContentVersions != null && !lstContentVersions.isEmpty()){
                        if(lstContentVersions[0].VersionData != null)
                            return lstContentVersions[0].VersionData.toString();
                    }        
                }
            }
            return null;
        }catch(exception ex){
            throw ex;
        }
    }
}