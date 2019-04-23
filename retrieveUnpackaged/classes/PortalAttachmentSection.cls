/*************************************************************************************************************
** User Story: 
**************************************************************************************************************
** Class Name    : PortalAttachmentSection
** Description   : Class for managing attachments
** Version       : 1.0
** Built By      : Vicrumnaug Vuppalapaty
**------------------------------------------------------------------------------------------------------------
** Modification Log:
**------------------
** Developer                         Date                    Version                      Description
**------------------------------------------------------------------------------------------------------------
** Srikanth Kottam                02/19/2018                   2.0           Added exception handling and Logging Errors
** Review Log:
**---------------
** Reviewer                  Date           Version               Description
**------------------------------------------------------------------------------------------------------------
**
**************************************************************************************/
public class PortalAttachmentSection {
    
    // List of all child attachments
    public List<MUSW__Submission__c> attachedFilesList {get; set;}
    
    // List of parent attachments
    public List<SubmissionRecord> attachmentList {get; set;}
    
    /**
* Constructor
* @param     License type, application type, current record Id
*/
    public PortalAttachmentSection(String licenseType, String applicationType, String recordId) {
        
        // Initialize parent questions list
        attachmentList = new List<SubmissionRecord>();
        
        // Get all child attachments
        System.debug('recordid '+recordid);
        String queryAttachedFiles = 'SELECT Id, Name, MUSW__License2__c,MUSW__Permit2__c,Extid_from_Submission_List__c, Description_Long__c, Master_Submission_List__c,Master_Submission_List__r.Required__c, Type__c, Attest__c, Document_API_Name__c, MUSW__BG_File_Location_Type__c FROM MUSW__Submission__c WHERE MUSW__License2__c = :recordId or License_Renewal__c  = :recordId or MUSW__Permit2__c =:recordId or MUSW__Application2__c = :recordId';
        
        attachedFilesList = Database.query(queryAttachedFiles);
        
        //Document API Name provides the name of the document that should be added as a hyperlink with the submission description.
        //Create a map to store corresponding document id for each document name provided.
        Map<String,String> mapDocNameAndId = new Map<String,String>();
        for(MUSW__Submission__c subObj : attachedFilesList) {
            if(subObj.Document_API_Name__c != null && subObj.Document_API_Name__c != ''){
                mapDocNameAndId.put(subObj.Document_API_Name__c, '');
            }
        }
        
        if(mapDocNameAndId.size() > 0){
            for(Document doc : [Select Id, Name, DeveloperName From Document where DeveloperName IN :mapDocNameAndId.keySet()]){
                mapDocNameAndId.put(doc.DeveloperName, doc.Id + ';' + doc.Name);
            }
        }
        
        // Build a list of submission records
        for(MUSW__Submission__c subObj : attachedFilesList) {
            
            // Call constructor and add fields
            attachmentList.add(new SubmissionRecord(subObj.Id, subObj.Name, 
                                                    subObj.Description_Long__c, subObj.Master_Submission_List__c,subObj.Master_Submission_List__c, subObj.Type__c,
                                                    subObj.MUSW__License2__c, subObj.Attest__c, mapDocNameAndId.get(subObj.Document_API_Name__c), subObj.MUSW__BG_File_Location_Type__c,subObj.Master_Submission_List__r.Required__c));
        }
        
        // Get all submission Ids
        Set<Id> submissionSet = new Set<Id>();
        
        for(MUSW__Submission__c subObj : attachedFilesList) {            
            submissionSet.add(subObj.Id);
        }
        
        // Declare attachment list
        List<Attachment> atts;

        // Query attachment objects
        if(submissionSet.size()>0)
            atts = [SELECT Id, Name, Description, ParentId FROM Attachment WHERE ParentId IN :submissionSet];
        
        
        // Add attachments to submission records
        if(atts!= null && atts.size()>0){  //SRN R5 - Added null check to avoid error from test class
            for(Attachment subAttObj : atts) {
                for(SubmissionRecord subObj : attachmentList) {
                    if(subAttObj != null) {
                        if(subAttObj.ParentId == subObj.Id) {
                            subObj.attachmentList.add(subAttObj);
                        }
                    }
                }
            }
        }
        System.debug('Entered Here' +attachmentList);
        // Clear lists
        if(atts!= null) atts.clear();
        attachedFilesList.clear();
        
    }
    
    /**
* Class for Submission and Attachment records
* @version     1.0
*/
    public class SubmissionRecord {
        
        public String id {get; set;}
        public String name {get; set;}
        public String description {get; set;}
        public String parent {get; set;}
        public String submissionType {get; set;}
        public String licenseObjId {get; set;}
        public String renewalReinstatementId {get; set;}
        public String externalIdSubList {get; set;}
        public String endorsementId {get; set;}
        public Boolean isAttested {get; set;}
        public String documentId {get; set;}
        public String fileLocationType {get; set;}
        public List<Attachment> attachmentList {get; set;}
        public Boolean requiredSubmission {get; set;}
        /**
* Constructor
* @param     Record Id, Name, Description, Parent Id, Submission type, License object Id, 
*            Renewal/Reinstatement Id, Endorsement Id, Attestation
*/
        public SubmissionRecord(String id, String name, String description, 
                                String parent,String extid, String submissionType, String licenseObjId,
                                Boolean isAttested, String documentId, String fileLocationType,Boolean requiredSubmission) {
                                    
                                    // Add values
                                    this.id = id;
                                    this.name = name;
                                    this.externalIdSubList=extid;
                                    this.description = description;
                                    this.parent = parent;
                                    this.submissionType = submissionType;
                                    this.licenseObjId = licenseObjId;
                                    this.renewalReinstatementId = renewalReinstatementId;
                                    this.endorsementId = endorsementId;
                                    this.isAttested = isAttested;
                                    this.documentId = documentId;
                                    this.fileLocationType = fileLocationType;
                                    this.attachmentList = new List<Attachment>();
                                    this.requiredSubmission = requiredSubmission;
                                }
    }
}