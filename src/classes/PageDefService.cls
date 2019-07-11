/*************************************************************************************************************
** User Story: 
**************************************************************************************************************
** Name                : PageDefService
** Description         : 
**                       It also provides the data structure to determine the state for the Progress Bar
**                       The Progress Bar keeps track of what sections the user has visited/not visited, if the sections is complete/incomplete
**                       and if the Application has been reviewed and no errors were found. 
** Version             : 1.0
** Built By            : 
**------------------------------------------------------------------------------------------------------------
** Modification Log:
**------------------
** Developer                         Date                    Version                      Description
**------------------------------------------------------------------------------------------------------------
** Akosa Okwudiafor                  8/17/2018
** Review Log:
**---------------
** Reviewer                  Date           Version               Description
**------------------------------------------------------------------------------------------------------------
**
************************************************************************************/
public class PageDefService {
    
    // public PageObj pageObj {get; set;}
    
    /**
* enum to determine the type of application we are working on
*/
    public enum ApplicationType { License, Renewal, Reinstatement, Permit, ServiceRequest,PermitRenewal}
    public PageObj pageObj {get; set;}
    
    public PageDefService(String board, String licenseType, ApplicationType t,String apptype) { 
        pageObj = new PageObj(board, licenseType, t,apptype, null);
    }
    public PageDefService(String board, String licenseType, ApplicationType t,String apptype, String serviceRequestType) { 
        pageObj = new PageObj(board, licenseType, t,apptype, serviceRequestType);
    }
    /**
* get the filter for the application type
*/
    public static String getApplicationTypeFilter(ApplicationType t) {
        String param = '';
        if (ApplicationType.License == t) {
            param = 'and License__c = true ';
        }
        if ((ApplicationType.Renewal == t)) {
            param = 'and License_Renewal__c = true ';
        }
        if ((ApplicationType.Reinstatement == t) ) {
            param = 'and License_Reinstatement__c = true ';
        }
        if (ApplicationType.Permit == t) {
            param = 'and Permit__c = true ';
        }
         if (ApplicationType.PermitRenewal == t) {
            param = 'and Permit_Renewal__c  = true ';
        }
        if (ApplicationType.ServiceRequest == t) {
            param = 'and Service_Request__c = true ';
        }
        return param;
    }
    
    /**
* this method handles the result of a save operation
* It determines if there were errors during the operation, if so, it changes the section
* status accordingly
* @see ValidationError
*/
    public void handleSaveOperation(Map<String,ValidationError.FieldError> errorMap) {
        // clear all the errors first
        //pageObj.removeFieldErrors(); not needed Save clears errors before upserting
        
        // for each error, find the Error under the pageObj and copy the error message
        // also, flag the section as incomplete if there was an error under that section
        
        for(String k: errorMap.keySet()) {
            //FieldObj fieldObj = pageObj.findField(k);
            //fieldObj.errorMessage =  errorMap.get(k).errorMessage;
            pageObj.setFieldError( k, errorMap.get(k).errorMessage );
        }
    }
    
    /** 
* conveninience method
* return the Serialized version of the sections
*/
    public String getAllSectionsSerialized() {
        return JSON.serialize( pageObj.sectionObjMap );
    }
    
    public String getAllSectionsAsListSerialized() {
        return JSON.serialize( pageObj.sectionObjMap.values() );
    }
    
    /**
* method to deserailize the page reference - this is when the user wants to do an edit operation
*/
    public void setAllSectionsAsList(String serializedListOfSections) {
        List<SectionObj> listSections = (List<SectionObj>)JSON.deserialize(serializedListOfSections, List<SectionObj>.class);
        pageObj = new PageObj(listSections);     
    }
    
    /**
* convenience method to serialized the State of the Page for the Progress Bar
* TODO: there could be a potential issue/errors when the serialized state of this Page 
*          is different from the current Page Definition because there have been updates 
*          to the metadata
*/
    public String getPageObjSerialized() {
        return JSON.serialize( pageObj );
    }
    
    /**
* convenience method to set the ProgressBarStatus
*/
    public void setSectionProgressBarStatus(Integer orderNumber, String status) {
        pageObj.findSection(orderNumber).progressBarStatus = status;
    }
    
    /**
* convenience method to get the Section Maps for a page as a List
*/    
    public List<SectionObj> allSectionsAsList {
        get{ return pageObj.sectionObjMap.values(); }
    }
    
    /**
* class representing a Field**/
    public class FieldObj {
        public String id {get; set;}
        public String name {get; set;}
        public String label {get; set;}
        public String sType {get; set;}        
        public String parent {get; set;}
        public String errorMessage {get; set;}
        public String className {get; set;}
        public Boolean readOnly {get; set;}
        public Boolean required {get; set;}
        public String objectName {get; set;}
        public String validator {get; set;}
        /**
* constructor
*/
        
        public FieldObj(String id, String name, String label, String sType, String parent, String className, Boolean readOnly, Boolean required, String objectName, String validator) {
            this.id = id;
            this.name = name;
            this.label = label;
            this.sType = sType;
            this.parent = parent;
            this.className = className;
            this.readOnly = readOnly;
            this.required = required;
            this.objectName = objectName;
            this.validator = validator;
        }
        
        public String debug() {
            return '---> field: ' + this.name + ' type: ' + sType;
        }
    }
    
    /**
* class representing a Sub-Section
* Ideally, we would want a subsection to use a reference to its parent as an object, but SFDC JSON.serialize method chokes
* complaining about a cycle reference
*/
    public class SubSectionObj {
        public String id {get; set;}
        public String componentName {get; set;}
        public String name {get; set;}
        public String description {get; set;}
        public String videoUrl {get;set;}
        public Decimal orderNumber {get; set;}
        public String sType {get; set;}
        public String parent {get; set;}
        public String progressBarStatus {get; set;}
        public String errorMessage {get; set;}
        public Map<String, FieldObj> fieldObjMap {get; set;}
        //added for DOL
        public boolean isRequired {get; set;}
        
        
        //added for DOL
        /************/
        public SubSectionObj(boolean isRequired,String name, String description, String componentName, Decimal orderNumber, String id, String sType, String parent, ApplicationType t) 
        {
            this.isRequired = isRequired;
            this.fieldObjMap = new Map<String, FieldObj>();
            this.name = name;
            this.description = description;
            this.componentName = componentName;  
            this.orderNumber = orderNumber;
            this.id = id;   
            this.sType = sType;
            this.parent = parent;
            String qry = 'select id, Name, Label__c, Type__c, Parent__c, Class_Name__c, Read_Only__c, Required__c, Object_Name__c, Validator__c ' +
                'from Application_Field__c ' +
                'where Parent__c = :id ' +
                getApplicationTypeFilter(t) +
                'order by Order_Number__c ASC';
            
            System.debug('qry '+qry);
            System.debug('Id '+Id);
            List<Application_Field__c> fieldList = Database.query(qry);
            
            // for each Field__c build a custom FieldObj
            for( Application_Field__c sObj: fieldList ) {
                fieldObjMap.put(sObj.Name, 
                                new FieldObj( sObj.Id, 
                                             sObj.Name,
                                             sObj.Label__c, 
                                             sObj.Type__c, 
                                             id,
                                             sObj.Class_Name__c,
                                             sObj.Read_Only__c,
                                             sObj.Required__c,
                                             sObj.Object_Name__c,
                                             sObj.Validator__c) );
                
            }
        }
        /************/
        
        // constructor
        public SubSectionObj(String name, String description, String componentName, Decimal orderNumber, String id, String sType, String parent, ApplicationType t) 
        {
            this.fieldObjMap = new Map<String, FieldObj>();
            this.name = name;
            this.description = description;
            this.componentName = componentName;  
            this.orderNumber = orderNumber;
            this.id = id;   
            this.sType = sType;
            this.parent = parent;
            String qry = 'select id, Name, Label__c, Type__c, Parent__c, Class_Name__c, Read_Only__c, Required__c, Object_Name__c, Validator__c ' +
                'from Application_Field__c ' +
                'where Parent__c = :id ' +
                getApplicationTypeFilter(t) +
                'order by Order_Number__c ASC';
            
            System.debug('qry '+qry);
            System.debug('Id '+Id);
            List<Application_Field__c> fieldList = Database.query(qry);
            
            // for each Field__c build a custom FieldObj
            for( Application_Field__c sObj: fieldList ) {
                fieldObjMap.put(sObj.Name, 
                                new FieldObj( sObj.Id, 
                                             sObj.Name,
                                             sObj.Label__c, 
                                             sObj.Type__c, 
                                             id,
                                             sObj.Class_Name__c,
                                             sObj.Read_Only__c,
                                             sObj.Required__c,
                                             sObj.Object_Name__c,
                                             sObj.Validator__c) );
                
            }
        }
        
        public SubSectionObj(String videoLink , String name, String description, String componentName, Decimal orderNumber, String id, String sType, String parent, ApplicationType t) 
        {
            this.videoUrl = videoLink ;            
            this.fieldObjMap = new Map<String, FieldObj>();
            this.name = name;
            this.description = description;
            this.componentName = componentName;  
            this.orderNumber = orderNumber;
            this.id = id;   
            this.sType = sType;
            this.parent = parent;
            String qry = 'select id, Name, Label__c, Type__c, Parent__c, Class_Name__c, Read_Only__c, Required__c, Object_Name__c, Validator__c ' +
                'from Application_Field__c ' +
                'where Parent__c = :id ' +
                getApplicationTypeFilter(t) +
                'order by Order_Number__c ASC';
            
                        System.debug('qry '+qry);
            System.debug('Id '+Id);
            List<Application_Field__c> fieldList = Database.query(qry);
            
            // for each Field__c build a custom FieldObj
            for( Application_Field__c sObj: fieldList ) {
                fieldObjMap.put(sObj.Name, 
                                new FieldObj( sObj.Id, 
                                             sObj.Name,
                                             sObj.Label__c, 
                                             sObj.Type__c, 
                                             id,
                                             sObj.Class_Name__c,
                                             sObj.Read_Only__c,
                                             sObj.Required__c,
                                             sObj.Object_Name__c,
                                             sObj.Validator__c) );
                
            }
        }
        
        public String debug() {
            String val =  '---> ' + label.Str_subsection + ': ' + this.name + label.Str_Contains + '' + fieldObjMap.values().size() + '' + label.Str_fields;
            for( FieldObj f: fieldObjMap.values() ) {
                val = val + f.debug();
            }
            return val;
        }
    }
    
    
    public class SectionObj {
        public String id {get; set;}
        public String name {get; set;}
        public Decimal orderNumber {get; set;}        
        public String progressBarStatus {get; set;}
        public Map<String, SubSectionObj> subSectionObjMap {get; set;}
        
        /**
* utility method used for debgging
*/
        public String debug() {
            String val =  '--->' + this.name + label.Str_Contains + '' + subSectionObjMap.values().size() + '' + label.Str_subsections;
            for( SubSectionObj ss: subSectionObjMap.values() ) {
                val = val = ss.debug();
            }
            return val;
        }
        
        public void flagSectionWithError() {
            this.progressBarStatus = label.Err_Error;
        }
        
        public void flagSectionAsInProgress() {
            this.progressBarStatus = label.ST_In_Progress;
        }
        
        public void flagSectionAsComplete() {
            this.progressBarStatus = label.Str_complete;
        }        
        
        public void flagSectionAsActive() {
            this.progressBarStatus = this.progressBarStatus + '' + label.ST_in_progress_active;
        }
        
        /**
* constructor
*/
        public SectionObj(String name, Decimal orderNumber, String id, String progressBarStatus, ApplicationType t) {
            this(name, orderNumber, id, t);
            this.progressBarStatus = label.ST_NOT_VISITED;
        }
        
        /**
* constructor
*/             
        public SectionObj(String name, 
                          Decimal orderNumber, 
                          String id,
                          ApplicationType t) {
                              this.subSectionObjMap = new Map<String, subSectionObj>();
                              this.name = name;
                              this.orderNumber = orderNumber;
                              this.id = id;   
                              // set by default the first section as active
                              if ( this.orderNumber == 1 ) {
                                  this.progressBarStatus = label.ST_in_progress_active;
                              }
                              // 20-03-19 - modified for DOL
                              String qry = 'select Id,Required__c , Video_URL__c ,Component_Name__c, Name, Description__c, Order_Number__c, Type__c, Parent__c ' +
                                  'from Application_Subsection__c ' +
                                  'where Parent__c = :id  and  active__c=true ' +
                                  getApplicationTypeFilter(t) +
                                  'order by Order_Number__c asc';
                              
                              List<Application_Subsection__c> subSectionList = Database.query(qry);
                              // for each SubSection__c build a custom SubSectionObj
                              // 20-03-19 - modified for DOL
                              for( Application_Subsection__c sObjSection: subSectionList ) {                             
                                  subSectionObjMap.put(sObjSection.Name, 
                                                                       new SubSectionObj( 
                                                                           sObjSection.Required__c,
                                                                           sObjSection.Name, 
                                                                           sObjSection.Description__c, 
                                                                           sObjSection.Component_Name__c, 
                                                                           sObjSection.Order_Number__c, 
                                                                           sObjSection.Id, 
                                                                           sObjSection.Type__c, 
                                                                           id,
                                                                           t
                                                                       ) 
                                                      );
                              }
                              
                          }
    }
    
    
    public class PageObj {
        public String pageName {get; set;}
        public ApplicationType t {get; set;}
        public Map<String, SectionObj> sectionObjMap {get; set;}
        public Integer reviewSectionNumber {get; set;} // the page knows the last section
        
        /**
* Need to determine when the user click on the reviewSection.
* When that happens, we need to tell that to validation logic - by setting
* the value to 99
* for instance , if on the UI the review section number is 6, 
* on the page Def service is also 6, but on the DB, it's 99
*/
        public Integer mapToDBSectionNumber(Integer iNumber) {
            if (iNumber == this.reviewSectionNumber) {
                return 99;
            }
            else {
                return iNumber;
            }
        }
        
        public String debug() {
            String val =  '--->' + this.pageName + label.Str_Contains + '' + sectionObjMap.values().size() + '' + label.Str_Sections;
            for( SectionObj sec: sectionObjMap.values() ) {
                val = val + sec.debug();
            }
            return val;
        }
        
        public PageObj(List<SectionObj> listSections) {
            this.sectionObjMap = new Map<String, SectionObj>();
            for( SectionObj s: listSections) {
                this.sectionObjMap.put(s.Name, s);  
            }            
        }
        
        // constructor
        public PageObj(String credentialtype, String credential, ApplicationType t,String apptype, String serviceRequestType) {
            
                 Set<String> allcredentials =Utilities.getallCredentials();
        Set<String> allplanreviewsandpermits =Utilities.getallPlanreviewsandpermits();
            this.t = t;
            System.debug(' credentialtype '+credentialtype);
             System.debug(' credential '+credential);
            sectionObjMap = new Map<String, SectionObj>();
            String qry='';
            if(allcredentials.contains(apptype)||apptype == Label.RNT_Renewal||apptype == Label.RNT_Reinstatement){
             qry = 'select id, Name, Order_Number__c, Parent__r.Name ,Parent__r.Credential__c, Parent__r.Credential_Type__c,License__c,License_renewal__c from Application_Section__c where ' +
                'Parent__r.Credential__c =:credential  and Parent__r.Credential_Type__c=: credentialtype ' +
                getApplicationTypeFilter(t) +
                'order by Order_Number__c asc';
            } 
            else if (allplanreviewsandpermits.contains(apptype )|| apptype == Label.Str_ManufacturedHomesRenewal){
                 qry = 'select id, Name, Order_Number__c, Parent__r.Name ,Parent__r.Credential__c, Parent__r.Credential_Type__c,License__c,License_renewal__c from Application_Section__c where ' +
                'Parent__r.Program_Area__c =: credentialtype and Parent__r.Permit_Type__c=:credential  ' +
                getApplicationTypeFilter(t) + 
                'order by Order_Number__c asc';
            }
            else if (apptype == Label.Str_Service_Request){
                Id pageId = null;
                for(Application_Page__c appPage : [Select Id, Credential__c, Credential_Type__c From Application_Page__c where Service_Request_Type__c = :serviceRequestType and Service_Request__c = true]){
                    if(appPage.Credential__c == credential && appPage.Credential_Type__c == credentialtype){
                        pageId = appPage.Id;
                    }else if((appPage.Credential__c == '' || appPage.Credential__c == null) && (appPage.Credential_Type__c == '' || appPage.Credential_Type__c == null)){
                        pageId = appPage.Id;
                    }
                }
                 qry = 'select id, Name, Order_Number__c, Parent__r.Name ,Parent__r.Credential__c, Parent__r.Credential_Type__c,License__c,License_renewal__c from Application_Section__c where ' +
                ' parent__c = :pageId order by Order_Number__c asc';
            }
            
            System.debug('qry '+qry);
            System.debug('credentialtype '+credentialtype);
            System.debug('credential '+credential);
            List<Application_Section__c> sectionList = Database.query(qry);
            this.buildSections(sectionList, t);           
            
        }
        
        /**
* method to set all sections as completed 
* when there aren't any errors during review and submit
*/
        public void handleReviewAndSubmitSuccess() {
            for( SectionObj sec : sectionObjMap.values() ) {
                if ( sec.orderNumber != reviewSectionNumber ) sec.flagSectionAsComplete();
            }        
        }        
        
        public void flagSectionAsActive(Integer sectionNum) {
            
            try{
                for( SectionObj sec : sectionObjMap.values() ) {
                    // Clear previously active section
                    if(sec.progressBarStatus == label.ST_in_progress_active){
                        sec.progressBarStatus = null;
                    }
                    // Add active section
                    if (sec.orderNumber == sectionNum) {
                        sec.progressBarStatus = label.ST_in_progress_active;
                    }
                }
            }catch(System.Exception e){
            SYstem.debug('e '+E);
            }
            
        }
        
        /**
* loop through all the sections for the page and build it 
*/
        private void buildSections(List<Application_Section__c> sectionList, ApplicationType t) {
            // for each Section__c build a custom SectionObj
            for( Application_Section__c sObjSection: sectionList ) {
                sectionObjMap.put(sObjSection.Name, 
                                  new SectionObj(sObjSection.Name, 
                                                 sObjSection.Order_Number__c, 
                                                 sObjSection.Id,
                                                 t) );
                this.reviewSectionNumber = (Integer)sObjSection.Order_Number__c; // set the value of the last section;
            }             
        }        
        
        /**
* find the parent section for the specified field
*/
        public SectionObj findSectionForField(String fieldName) {
            for( SectionObj sectionObj: sectionObjMap.values() ) {
                for( SubSectionObj ssObj: sectionObj.subSectionObjMap.values() ) {
                    if (ssObj.Name == fieldName) {
                        return sectionObj;
                    }                    
                }
            }    
            return null;            
        }
        
        /**
* find the specified field 
*/
        public FieldObj findField(String fieldName) {
            for( SectionObj sectionObj: sectionObjMap.values() ) {
                for( SubSectionObj sSectionObj: sectionObj.subSectionObjMap.values() ) {
                    for( FieldObj fieldObj : sSectionObj.fieldObjMap.values() ) {
                        if ( fieldObj.Name == fieldName) {
                            return fieldObj;
                        }
                    }    
                }
            } 
            return null;              
        }
        
        /**
* When a validation error occurs, we store the error message and flag the field.SubSection.Section as INCOMPLETE
* this had to be written in this way, ideally, we could just find a field and set its error value,
* then navigate the object tree to the field.subsection.section to set the section status
* but trying object references from child to parent caused JSON.serialize to choke - cycled object error
*/
        public void setFieldError(String fieldName, String errorMessage) {
            for( SectionObj sectionObj: sectionObjMap.values() ) {
                for( SubSectionObj sSectionObj: sectionObj.subSectionObjMap.values() ) {
                    for( FieldObj fieldObj : sSectionObj.fieldObjMap.values() ) {
                        if ( fieldObj.Name == fieldName) {
                            fieldObj.errorMessage = errorMessage;
                            sSectionObj.progressBarStatus = label.Err_Error;
                            sectionObj.progressBarStatus = label.Err_Error;
                        }
                    } 
                    
                    if(sSectionObj.componentName == fieldName) {
                        sSectionObj.errorMessage = errorMessage;
                        sSectionObj.progressBarStatus = label.Err_Error;
                        sectionObj.progressBarStatus = label.Err_Error;
                    }   
                }
            }            
        }
        
        /**
* clear all the fields error messages
* this is needed before save operations - right before we run the validations
*/
        public void removeFieldErrors() {
            for( SectionObj sectionObj: sectionObjMap.values() ) {
                for( SubSectionObj sSectionObj: sectionObj.subSectionObjMap.values() ) {
                    sSectionObj.errorMessage = null;
                    sSectionObj.progressBarStatus = null;
                    sectionObj.progressBarStatus = null;
                    for( FieldObj fieldObj : sSectionObj.fieldObjMap.values() ) {
                        fieldObj.errorMessage = null;
                        sSectionObj.progressBarStatus = null;
                        sectionObj.progressBarStatus = null;
                    }    
                }
            }            
        }
        
        /**
* utility method to get a list of all the fields that contain an error message
* When the save method completes, the pageDefinition is passed a list of errors and those error messages
* are populated on the appropriate field
* usefull for Test classes
*/
        public List<FieldObj> getAllFieldsWithError() {
            
            try{
                List<FieldObj> fieldObjList = new List<FieldObj>();
                for( SectionObj sectionObj: sectionObjMap.values() ) {
                    for( SubSectionObj sSectionObj: sectionObj.subSectionObjMap.values() ) {
                        for( FieldObj fieldObj : sSectionObj.fieldObjMap.values() ) {
                            if (fieldObj.errorMessage != null) {
                                fieldObjList.add(fieldObj);
                            }
                        }    
                    }
                } 
                return fieldObjList; 
            }catch(System.Exception e){
                 SYstem.debug('e '+E);
                return null;
            }
            
        }        
        
        /**
* return all the fields names for the sections
* if any field is not added SQOL field missing exception occurs
*/
        public List<String> getAllFields() {
            List<String> fieldListName = new List<String>();
            
            for( SectionObj sectionObj: sectionObjMap.values() ) {
                for( SubSectionObj sSectionObj: sectionObj.subSectionObjMap.values() ) {
                    for( FieldObj fieldObj: sSectionObj.fieldObjMap.values() ) {
                        fieldListName.add( fieldObj.Name );
                    }
                }
            }
            return fieldListName;
        }
        
        /**
* return all the fields names for the sections
* if any field is not added SQOL field missing exception occurs
*/
        public List<FieldObj> getAllFieldObjects() {
            List<FieldObj> fieldList = new List<FieldObj>();
            
            for( SectionObj sectionObj: sectionObjMap.values() ) {
                for( SubSectionObj sSectionObj: sectionObj.subSectionObjMap.values() ) {
                    for( FieldObj fieldObj: sSectionObj.fieldObjMap.values() ) {
                        fieldList.add( fieldObj );
                    }
                }
            }
            return fieldList;
        }
        
        /**
* return all the fields names for the sections
* if any field is not added SQOL field missing exception occurs
*/
        public String getAllFieldsAsString() {
            List<String> fieldListName = new List<String>();
            
            for( SectionObj sectionObj: sectionObjMap.values() ) {
                for( SubSectionObj sSectionObj: sectionObj.subSectionObjMap.values() ) {
                    for( FieldObj fieldObj: sSectionObj.fieldObjMap.values() ) {
                        
                        if(fieldObj.objectName == label.Str_Main_Object||fieldObj.objectName == 'Parent of Main Object') {
                            fieldListName.add( fieldObj.Name );
                        }
                        else if(fieldObj.objectName == label.API_Contact) {
                            if(ApplicationType.License == t||ApplicationType.Permit == t) {
                                fieldListName.add( label.API_MUSW_Applicant_r + '.' + fieldObj.Name );
                            }
                            else {
                                fieldListName.add(label.API_Applicant_r + '.' + fieldObj.Name );
                            }
                        }
                        else if(fieldObj.objectName == label.API_Account) {
                            if(ApplicationType.License == t) {
                                fieldListName.add(label.API_MUSW_Primary_Licensee_r + '.' + fieldObj.Name );
                            }
                            else if(ApplicationType.Permit == t) {
                                //changed to Api_account_rel
                                fieldListName.add('MUSW__Account__r' + '.' + fieldObj.Name );
                            }
                            else {
                                fieldListName.add(label.API_Licensee_r + '.' + fieldObj.Name );
                            }
                        }
                    }
                }
            }
            // we need to add a ', ' to the query 
            if ( fieldListName.size() > 0 ) {
                return ', ' + String.join(fieldListName, ', ');
            }
            else {
                return '';
            }
        }        
        
        /**
* return the section identified by the orderNumber
*/
        public SectionObj findSection(Integer orderNumber) {
            List<SectionObj> sectionList = sectionObjMap.values();
            SectionObj section;
            for( SectionObj s: sectionList ) {
                if ( s.orderNumber == orderNumber ) {
                    section = s;
                    break;
                }
            }
            return section;
        }
        
    }
    
    
    
    
    
}