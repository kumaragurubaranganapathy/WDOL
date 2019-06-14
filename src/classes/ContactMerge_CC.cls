/*************************************************************************************************************
** User Story: 
**************************************************************************************************************
** Class Name       : ContactMerge_CC
** Description      : Utility for Contact Merge Controller 
** Version          : 1.0
** Built By         : S

**------------------------------------------------------------------------------------------------------------
** Modification Log:
**------------------
** Developer                  Date          Version               Description
   
**-----------------------------------------------------------------------------------------------------------
** 
** Review Log:
**---------------
** Reviewer                  Date          Version               Description
**------------------------------------------------------------------------------------------------------------
**
**********************************************************************************/

public with sharing class ContactMerge_CC{

    /****************************Predetermined Merge Criteria Variables ***************************************/ 
    public contact con{get{if(con==null) con = new contact(); return con;}set;}
    
    Public Boolean showCustomCriteriaBlock{get;set;}
    /****************************End Predetermined Merge Criteria Variables**************************************/
    public List<ContactWrapper> cwList{get{if(cwList==null)cwList=new List<ContactWrapper>();return cwList;}set;}
    public String nameFilter{get;set;}
    public Id MasterContactId{get;set;}
    public Contact MasterContact{get;set;}
    public Contact MasterContactBeforeUpdate{get;set;}
    public Set<Id> ChildContactsIds{get{if(ChildContactsIds==null) ChildContactsIds = new Set<Id>(); return ChildContactsIds;}set;}
    public List<Contact> ChildContacts{get;set;}
    public Set<Id> MergeTableIds{get{if(MergeTableIds==null) MergeTableIds = new Set<Id>(); return MergeTableIds;}set;}
    public List<Contact> SelectedContacts{get{if(SelectedContacts==null) SelectedContacts = new List<Contact>(); return SelectedContacts;}set;}
    public List<Contact> AcrhivedQueryContacts{get{if(AcrhivedQueryContacts==null) AcrhivedQueryContacts = new List<Contact>(); return AcrhivedQueryContacts;}set;}
    //list of row wrappers that contain a transposed view of the contacts
    public list<rowWrapper> rows{get;set;}
    public list<String> rowIndex{get;set;}
    public list<ContactMergeFields__mdt> MergeFields{get{if(MergeFields==null) MergeFields = [select ArchivedContactFieldName__c, label, ContactFieldName__c, showOnMergeTable__c from ContactMergeFields__mdt where ArchivedContactFieldName__c != null Limit 1000] ; return MergeFields;}set;}
    public list<String> MergeTableFields{get;set;}
    public Map<String, String> fieldLabelMap{get;set;}
    public list<String> MergeTableFieldLabels{get;set;}
    public String strQueryFields {get; set;}
    public String ArchConstrQueryFields{get;set;}
    public String ArchivedContactFileds{get;set;}
    public Boolean ChildContactLimitExceeded{get;set;}
    public List<ArchivedContact__c> ArchivedContacts{get;set;}
    public List<Id> mergedIds{get;set;}
    public Boolean SuccessfulMerge{get;set;}
    public Boolean lockMergeTable{get;set;}
    public Boolean errorMsg{get;set;}
    public Boolean noSearchResults{get;set;}
    //public Boolean mergeErrorforCasino{get;set;}
    public Map<String,String> ArchivedFieldNameMap{
        get{
            if(ArchivedFieldNameMap==null)
            {
                ArchivedFieldNameMap = new Map<String,String>();
                for(Integer i=0;i<MergeFields.size();i++)
                { 
                    ArchivedFieldNameMap.put(MergeFields[i].ContactFieldName__c,MergeFields[i].ArchivedContactFieldName__c);
                }
            }
            return ArchivedFieldNameMap;
        }set;}
    // the headings for the row wrappers table
    private RowWrapper headings;
    /***************************** Filter Variables********************************/ 
    public List<SelectOption> lstFieldNames {get; set;}
    public List<SelectOption> lstOperators {get; set;}
    
    public List<FilterOption> lstFilterOptions {get; set;}
    public String filterLogic {get; set;}
    public String defaultFilterLogic {get; set;}
    public String searchQuery {get; set;}
    public String currentRow {get; set;}
    public String selectedFilterLogic {get; set;}
    Public Map<String, Schema.SObjectField> M{get;set;}
    
    /****************************End of Filter Variables ************************************/
    
    /**************************Constructor Start ******************************************/ 
    Public ContactMerge_CC()
    {
        errorMsg=false;
        noSearchResults=false;
        //mergeErrorforCasino = false;
        M = Schema.SObjectType.Contact.fields.getMap();
        system.debug(ApexPages.currentPage().getHeaders().get('Host'));
        showCustomCriteriaBlock = false;
        MergeTableFields = new List<String>();
        fieldLabelMap = new Map<String,String>();
        MergeTableFieldLabels = new List<String>();
        SuccessfulMerge = false;
        lockMergeTable = false;
        ChildContactLimitExceeded = false;
        strQueryFields = '';
        ArchConstrQueryFields='';
            for(Integer i=0;i<MergeFields.size();i++)
            {
                if(MergeFields[i].showOnMergeTable__c==true){
                    MergeTableFields.add(MergeFields[i].ContactFieldName__c);
                    MergeTableFieldLabels.add(MergeFields[i].label);
                    fieldLabelMap.put(MergeFields[i].ContactFieldName__c, MergeFields[i].Label);
                    strQueryFields = strQueryFields + ',' + MergeFields[i].ContactFieldName__c;
                    }
                ArchConstrQueryFields=ArchConstrQueryFields + ',' + MergeFields[i].ContactFieldName__c;
            }
            strQueryFields = strQueryFields.substring(1,strQueryFields.length());
            ArchConstrQueryFields = ArchConstrQueryFields.substring(1,ArchConstrQueryFields.length());
        
        /********************Filter Constructor Code**********************/ 
        lstFieldNames = new List<SelectOption>();
        lstFieldNames.add(new SelectOption('','-None-'));
        lstFieldNames.add(new SelectOption('Name', 'FullName'));
        
        String type=label.Str_Contact;
        Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
        Schema.SObjectType leadSchema = schemaMap.get(type);
        Map<String, Schema.SObjectField> fieldMap = leadSchema.getDescribe().fields.getMap();
            for(ContactMergeFields__mdt fieldrecord: MergeFields){
                String fieldName = fieldrecord.ContactFieldName__c;
                    if(fieldMap.get(fieldName).getDescribe().isfilterable() && fieldrecord.showOnMergeTable__c==true){
                        SelectOption so = new SelectOption(fieldrecord.ContactFieldName__c, fieldrecord.label);
                        lstFieldNames.add(so);
                    }
             }
        lstFieldNames.sort();
        //"Not Equal to" and "Does Not Contain" added by Donnie 
        
        lstOperators = new List<SelectOption>();
        lstOperators.add(new SelectOption('=','Equals'));
        lstOperators.add(new SelectOption('<>','Not Equal to'));    
        lstOperators.add(new SelectOption('<','Less Than'));
        lstOperators.add(new SelectOption('<=','Less Than or Equals'));
        lstOperators.add(new SelectOption('>','Greater Than'));
        lstOperators.add(new SelectOption('>=','Greater Than or Equals'));
        lstOperators.add(new SelectOption('Contains','Contains'));
        lstOperators.add(new SelectOption('Does Not Contain','Does Not Contain'));

        
        FilterOption pickFirst = new FilterOption ();
        pickFirst.selectedField = label.API_Name;
        
        lstFilterOptions = new List<FilterOption>();
        lstFilterOptions.add(pickFirst);
        selectedFilterLogic = label.Str_Default;
        defaultFilterLogic = '1';
        filterLogic = '1';
        
        /******************End of Filter Code **************************/ 
    }
   /**********************************Constructor Ending Here **********************************/
   
   /***************************** Code Block to Select Master Contact ******************************/
   
   /**
    * Method name   : selectTo
    * Description   : Gets the Id of the Master Contact being selected and also unselects the other radio buttons. 
    * Return Type   : None
    * Parameter     : None
    **/
    public void selectTo(){
        Id selectedId = ApexPages.currentPage().getParameters().get(label.Str_mergeTo);
        for(ContactWrapper cw:cwList){
            if(cw.con.Id==selectedId){
                cw.isTo=true;
            } else{
                cw.isTo=false;
                cw.isFrom=false;
            }
        }
    }
    
    /***************************** Code Block to Select the Child Contact ******************************/
   
   /**
    * Method name   : selectFrom
    * Description   : Gets the Ids of the Child Contacts being selected. Multiple Child Contacts can be selected
    * Return Type   : None
    * Parameter     : None
    **/
    public void selectFrom(){
        Id selectedId = ApexPages.currentPage().getParameters().get(label.Str_mergeFrom);
        Boolean isChecked = Boolean.valueOf(ApexPages.currentPage().getParameters().get('isChecked'));
        for(ContactWrapper cw: cwList) {
            if(cw.con.Id==selectedId){
                 cw.isFrom=isChecked;
            }else{
                cw.isFrom = (cw.isFrom) ? true : false;
            }
        }
    }
   /************ Code Block to to Show selected Contacts in Merge Comparisions Table ******************************/
   
   /**
    * Method name   : ShowMergeTable
    * Description   : Calls Show Selected Contacts function and lock the Merge Table so that selection cannot be modified. 
    * Return Type   : None
    * Parameter     : None
    **/
    public void ShowMergeTable()
    {
        ShowSelectedContacts();
        lockMergeTable = true;
    }
    
   
   /**
    * Method name   : ShowSelectedContacts
    * Description   : Get Master Contact Selected in SelectTo, Get Child Contacts selected in SelectFrom. Add them to one list and shows them in the Merge Comparision Table
    * Return Type   : list of selected contacts
    * Parameter     : None
    **/
    Public List<Contact> ShowSelectedContacts()
    {
        System.debug('In Showselectedcontacts');
        try{
            List<Id> contactIds = new List<Id>();
            // List<Id> ChildContact
            for(ContactWrapper cw:cwList){
                //Query Master Contact from the Id fetched in SelectTo function and Set is Master Contact Flag to True
                if(cw.isTo){
                //String MasterContactQuery = 'select '+strQueryFields+' from Contact where Id ='+'\''+MasterContactId+'\'';
                    MasterContactId = cw.con.Id;
                
                }
                // Create a list of Child Contact Ids
                if(cw.isFrom)
                {
                ChildContactsIds.add(cw.con.Id); 
                }
                //Create a list that is a combination of Master and Child Contact Ids
                if(cw.isFrom||cw.isTo){
                    contactIds.add(cw.con.Id);
                }
            
            }
            if(MasterContact==null && MasterContactId!=null){
                    MasterContact=database.query('select '+strQueryFields+' from Contact where Id ='+'\''+MasterContactId+'\'');
                    //MasterContact.isMasterContact__c = True;
            }
            //Query all the Child Contacts
            List<Id> ChildContactQueryIdList = new List<Id>(ChildContactsIds);
            String ChildContactsQuery = 'select '+strQueryFields+' from Contact where Id in :ChildContactQueryIdList';
            
            ChildContacts=database.query(ChildContactsQuery);
            if(contactIds.size()>0)
            {  
                // Query to get all the selected contacts which includes Master and the Child
                // Querying again to form one more list for Archived Contacts
                String ArchivedContactQuery = 'select '+ArchConstrQueryFields+' from Contact where Id in :contactIds';
               //SelectedContacts=database.query(SelectedContactsQuery); 
                              
               selectedContacts.add(MasterContact);
               
               selectedContacts.addAll(ChildContacts);
               AcrhivedQueryContacts = database.query(ArchivedContactQuery);
            }
            return SelectedContacts;
            }catch(exception ex){
            ErrorLogger.logGeneralException(ex, UserInfo.getUserId(), 'ContactMergeController', null, 'ShowSelectedContacts', 'ContactMergeController', label.str_HIGH);
                return null;
            }
        
    }

    /**
    * Method name   : getHeadWrap
    * Description   : Prepare Headings for the Merge Table
    * Return Type   : headings
    * Parameter     : None
    **/
    public RowWrapper getHeadWrap()
    {
        System.debug('In head Wrap');
        // set up the headings
            headings=new RowWrapper();
            rowIndex = new List<String>();
            for (Integer idx=0; idx<=SelectedContacts.size(); idx++)
            {
                if(idx==0)
                {
                   headings.addValue('Field Name ');
                    rowIndex.add('Row'+idx);  
                }
                else if(idx==1)
                {
                    headings.addValue('Master Contact');
                    rowIndex.add('Row'+idx);
                }
                else{
                headings.addValue('Child Contact - ' + (idx-1));
                rowIndex.add('Row'+idx);
                }
            }
                                     
        return headings;
    }
    /**
    * Method name   : getRowWrappers
    * Description   : Prepare the Rows, and Cell Values. 
    * Return Type   : rows
    * Parameter     : None
    **/
    // retrieves the list of row wrappers
    public List<RowWrapper> getRowWrappers()
    {
            rows=new List<RowWrapper>();
            System.debug('contact merge - MergeTableFields '+ MergeTableFields);
            // create a row for each field 
            for (Integer idx=0; idx<MergeTableFields.size(); idx++)
            {
                rows.add(new RowWrapper());
                rows[idx].fieldName=MergeTableFields[idx];
                rows[idx].fieldLabel = MergeTableFieldLabels[idx];
            }
        	System.debug('contact merge - rows '+ rows);
        	System.debug('contact merge - MergeTableFields '+ MergeTableFields);
        	System.debug('contact merge - MergeTableFieldLabels '+ MergeTableFieldLabels);
            //Create Cell and populate the cell in each rows with field values
            List<Contact> contacts = SelectedContacts;
        	System.debug('contact merge- SelectedContacts 0 '+ SelectedContacts);
        	System.debug('contact merge- contacts 1 '+ contacts);
        	for (Integer idx=0; idx<contacts.size(); idx++)
            {
                for(Integer fidx=0; fidx<MergeTableFields.size(); fidx++)
                {
                    rows[fidx].addValue('' + String.ValueOf(contacts[idx].get(MergeTableFields[fidx])));
                }
            }
        return rows;
    }
    /**
    * Method name   : MergeSelectedContacts
    * Description   : Step1: Updates the master Contact with the Selected Value. and the ContactIdnts of all the Contacts are stored in a Text area of Field of the master COntact
    *                 Step2: Inserts contacts to be deleted and the master in Archived COntacts Objects.
    *                 Step3: Merges the Child Contacts along with Related List and deletes the Child Contacts once Merge Process is Completed
    *                 Step4: If Merge is successful, Email is sent to a Distribution list with Links to Archived Contacts and the Master Conta
    * Return Type   : rows
    * Parameter     : None
    **/
    public Void MergeSelectedContacts()
    {
        String MergedSecuritycodes = '';
        List<contact> contacts = SelectedContacts;
        for(contact onecontact:contacts){
            onecontact.ownerId = UserInfo.getUserId();
        }
        System.debug('contact merge- contacts 2 '+ contacts);
        Update contacts;
        Integer casinoRecordsCount = 0;
        Integer nonCasinoRecordsCount = 0;
        //String casinoRecordId = Utilities.getRecordTypeForName(label.Str_Contact, 'Casino Contact' );
        try{
        for(integer i=0;i<SelectedContacts.size();i++)
        {   
            //if(casinoRecordId == SelectedContacts[i].RecordTypeId){
                //casinoRecordsCount++;
            //}
            //else{
                nonCasinoRecordsCount++;
            //}
            MergedSecuritycodes = MergedSecuritycodes+';'+SelectedContacts[i].Security_Code__c;
            System.debug('MergedSecuritycodes1>>>>>>>>>>>>' +MergedSecuritycodes);
        }

        //mergeErrorforCasino = false;
        MergedSecuritycodes=MergedSecuritycodes.substring(1,MergedSecuritycodes.length());
        MasterContact.MergedSecuritycodes__c = MergedSecuritycodes;
        MasterContact.IsMasterContact__c = true;
        MasterContact.Duplicate_Override__c = True;
       System.debug('MergedSecuritycodes2>>>>>>>>>>>>' +MergedSecuritycodes);
           ArchivedContacts = new List<ArchivedContact__c>();     
           for(Integer i=0;i<AcrhivedQueryContacts.size();i++)
           {
                 ArchivedContact__c ArchivedContact = new ArchivedContact__c();
                for (String ContactField : ArchivedFieldNameMap.keySet()){
                    String ArchivedContactField = ArchivedFieldNameMap.get(ContactField);
                    ArchivedContact.put(ArchivedContactField,AcrhivedQueryContacts[i].get(ContactField));
                    ArchivedContact.Contact__c = MasterContact.Id;
                }
               ArchivedContacts.add(ArchivedContact);
            }
                if(ArchivedContacts!=null)
                {
                    Database.SaveResult[] results = Database.insert(ArchivedContacts,false);
                    for(Database.SaveResult sr: results){
                        if(sr.isSuccess()){                            
                            // Below Operation will Merge all the Child Contacts to the Master Contact and Delete the Child Contacts
                                Database.MergeResult[] Mergeres = Database.merge(MasterContact, ChildContacts, false);

                                for(Database.MergeResult Mres : Mergeres) {
                                    if (Mres.isSuccess()) {
                                        // Get the master ID from the result and validate it               
                                         MasterContact.Duplicate_Override__c = false; 
                                         Database.update(MasterContact);
                                        // Get the IDs of the merged records and display them
                                        mergedIds = Mres.getMergedRecordIds();
                                        SuccessfulMerge = true;              
                                        
                                        // Get the ID of the reparented record and 
                                        // validate that this the contact ID.

                                       // sendingEmail();            
                                    }
                                    else {
                                        for(Database.Error err : Mres.getErrors()) {
                                            // Write each error to the debug output
                                            System.debug(err.getMessage());
                                        }
                                    }
                                }
                            //End of Merge Operation 
                        }
                        else{
                            for(Database.Error err : sr.getErrors()) {                
                                System.debug(err.getStatusCode() + ': ' + err.getMessage());
                            }
                        }
                    }
                }
                
                Database.update(MasterContact);
        }
        catch(DmlException e){
            //ErrorLogger.logGeneralException(e, UserInfo.getUserId(), 'User', 'getting user Id', 'sonstructor', 'ContactMergeController', 'HIGH'); 
           // ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error '+e));
        }
    }
    // nested class that wraps information about a row - in this case simply a list of strings 
    public class RowWrapper
    {
        public String fieldName{get;set;}
        public String fieldLabel{get;set;}
        // the values (cells) making up this row
        public List<String> values {get; set;}
        
        // constructor
        public RowWrapper()
        {
            values=new List<String>();
        }
        
        // append a value (cell) to the row
        public void addValue(String value)
        {
            values.add(value);
        }
    }
    /**
    * Method name   : selectedFieldValue
    * Description   : Captures the Selected Field Value for a respective field in Merge Table and the Master Contact is updated with New Values
    * Return Type   : None
    * Parameter     : None
    **/
    public void selectedFieldValue()
    {
        String SelectedFieldName = ApexPages.currentPage().getParameters().get(label.Str_fieldName);
        String SelectedFieldValu = ApexPages.currentPage().getParameters().get(label.Str_fieldValue);
        
        /****Dealing with Issues related to Date Fields***/ 
        
        String objType=label.Str_Contact;
        Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
        Schema.SObjectType leadSchema = schemaMap.get(objType);
        Map<String, Schema.SObjectField> fieldMap = leadSchema.getDescribe().fields.getMap();
        
        //String FieldLabel = fieldMap.get(SelectedFieldName).getDescribe().getLabel();
        Schema.DisplayType fielddataType = fieldMap.get(SelectedFieldName).getDescribe().getType();
        
        /*******End of date issues code***/ 
        if(fielddataType != Schema.DisplayType.Date)
           {
               MasterContact.put(SelectedFieldName,SelectedFieldValu);
           }
        else if(fielddataType == (Schema.DisplayType.Date)){
                MasterContact.put(SelectedFieldName,Date.valueOf(SelectedFieldValu));
        }
        else if(fielddataType == (Schema.DisplayType.Datetime)){
                MasterContact.put(SelectedFieldName,Datetime.valueOf(SelectedFieldValu));
        }
    }

    // Nested Class for Wrapping the Contacts, Radio Buttons and Check Boxes
    public class ContactWrapper{
        public Contact con{get;set;}
        public Boolean isTo{get;set;}
        public Boolean isFrom{get;set;}
        public List<String> labels{get;set;}
        public String isPortalUser{get;set;}
        
        public ContactWrapper(){
            isTo=false;
            isFrom=false;
        }
        public ContactWrapper(Contact c){
            con = c;
            isTo=false;
            isFrom=false;
        }
    }
    
    /***********************Aayush`s Filter FUnctions ******************/ 
    public void filterOptionChanged(){
        Integer index = Integer.valueOf(currentRow);
        FilterOption objFilterOption = lstFilterOptions[index];
        System.debug('objFilterOption.selectedField>>>' +objFilterOption.selectedField);
        if(objFilterOption.selectedField == null || objFilterOption.selectedField == label.API_Birth_State || objFilterOption.selectedField == label.API_Name || objFilterOption.selectedField == 'Birth_Country__c' || objFilterOption.selectedField == 'LastName' || objFilterOption.selectedField == 'Birth_City__c' || objFilterOption.selectedField == 'Email'){
            System.debug('Entered here');
            objFilterOption.value = '';
        }else{
            objFilterOption.objContact.put(objFilterOption.selectedField,null);
        }
    }
    
    public void addFilterOption(){
        
        try{
            lstFilterOptions.add(new FilterOption());
        
            defaultFilterLogic = '';
            filterLogic = '';
            for(Integer i=1; i <= lstFilterOptions.size(); i++){
                defaultFilterLogic = defaultFilterLogic + i + ' AND ';
                filterLogic = filterLogic + i + ' AND '; 
            }
        
            if(defaultFilterLogic.endsWith(' AND ')){
            defaultFilterLogic = defaultFilterLogic.substring(0, defaultFilterLogic.length() - 5);
            filterLogic = filterLogic.substring(0, filterLogic.length() - 5); 
            }
        }catch(exception ex){
            ErrorLogger.logGeneralException(ex, UserInfo.getUserId(), 'ContactMergeController', null, 'addFilterOption', 'ContactMergeController', label.str_HIGH);
        }
        
    }
    
    public void removeFilterOption(){
        Integer index = Integer.valueOf(currentRow);
        lstFilterOptions.remove(index);
          // if(selectedFilterLogic != 'Default')
           
            errorMsg = false;
            noSearchResults = false;
            String newLength;
            String building = '';         
            String[] splitted = filterLogic.split('\\s+');
            Integer num = splitted.size();
                for(Integer i=0; i<num-2; i++){
                    newLength = splitted.remove(0);
                    building += newLength + ' ';
                }
                filterLogic = building;
        
    }
    
    public void searchContacts(){
        String limitPart = ' limit 200 ';
        String whereClause = ' where ';
        searchQuery = 'Select '+strQueryFields+' From Contact ';  
               
        //String formattedFilterLogic = defaultFilterLogic;
        String formattedFilterLogic  = filterLogic;
        //if(selectedFilterLogic != 'Default'){
            //formattedFilterLogic = filterLogic;
        //}
        
        List<String> filterValues = new List<String>();
        for(Integer i=1; i <= lstFilterOptions.size(); i++){
            formattedFilterLogic = formattedFilterLogic.replace(i + '', '{' + (i-1) + '}');
            
            FilterOption fo = lstFilterOptions.get(i-1);
            if(fo.selectedField == null || fo.selectedField == ''){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, label.Err_Error_Populate_all_Filters));
                return;
            }
            
            String type=label.Str_Contact;
            Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
            Schema.SObjectType leadSchema = schemaMap.get(type);
            Map<String, Schema.SObjectField> fieldMap = leadSchema.getDescribe().fields.getMap();
            
            fo.fieldType = fieldMap.get(fo.selectedField).getDescribe().getType();
            filterValues.add(fo.getSearchString());
        }
        
        formattedFilterLogic = String.format(formattedFilterLogic, filterValues);
        
        //Perform a simple query to see if the filter logic is wrong
        
        List<Contact> sqCon;
        String simpleQuery = 'SELECT Id FROM Contact WHERE ' + formattedFilterLogic + ' LIMIT 1';
        errorMsg =false;
        if (simpleQuery!=null){ 
            try{
                sqCon = Database.Query(simpleQuery); 
            }
            catch (Exception e){
//              ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Error: Please check the filter logic. For example: (1 AND 2) OR 3'));
                errorMsg=true;
                ErrorLogger.logGeneralException(e, UserInfo.getUserId(), 'ContactMergeController', null, 'searchContacts', 'ContactMergeController', label.str_HIGH);
                
            }
        }      
        searchQuery = searchQuery + whereClause + formattedFilterLogic + limitPart; 
        noSearchResults = false;      
        if(searchQuery!=null && sqCon!=null){
           List<Contact> contacts = Database.Query(searchQuery);
           Integer s = contacts.size();
           if (s == 0){
            noSearchResults = true;
           }
           
           map<Id,Id> mapContactIdUserId = new map<Id,Id>();
           for(User u : [Select Id, ContactId From User where ContactId IN :contacts]){
                mapContactIdUserId.put(u.contactId, u.Id);
           }
           
            cwList = new List<ContactWrapper>();
            for(Contact c:contacts){
                ContactWrapper cw = new ContactWrapper(c);
                
                if(mapContactIdUserId.get(c.Id) != null){
                    cw.isPortalUser = '<a target=\'_blank\' href=/' + mapContactIdUserId.get(c.Id) + '>Yes</a>';
                }else{
                    cw.isPortalUser = 'No';
                }
                
                cwList.add(cw);
                
            } 
        }
    }
    
    public class FilterOption{
        public Contact objContact {get; set;}
        public String selectedField {get; set;}
        public String selectedOperator {get; set;}
        public String value {get; set;}
        public Schema.DisplayType fieldType {get; set;}
        
        public FilterOption(){
            objContact = new Contact();
        }
        
        public String getSearchString(){
            String searchString = ' ' + String.escapeSingleQuotes(selectedField) + ' ' + String.escapeSingleQuotes(selectedOperator);
            
            String likeChar = '';
            if(selectedOperator == 'Contains'){
                 System.debug('Entered if for contains');
                searchString = ' ' + String.escapeSingleQuotes(selectedField) + ' LIKE ';
                System.debug('searchString>>>' +searchString);
                likeChar = '%';
            }
            //"Does not contain" code by Donnie (by example)
             if(selectedOperator == 'Does Not Contain'){
                searchString = ' ' + '(NOT' + ' ' + String.escapeSingleQuotes(selectedField) + ' LIKE ';
                likeChar = '%';  
            }
               
            String quoteChar = '';
            if(singleQuotesNeeded()) quoteChar = '\'';
            
            String val = '';
            if(value != null && value != ''){
                val = value;
            }else{
                if(fieldType == Schema.DisplayType.Date){
                    Value = null;
                    DateTime dt = (DateTime)objContact.get(selectedField);
                    val = (dt+1).format('yyyy-MM-dd'); 
                    system.debug(system.now().format());
                }else{
                    val = objContact.get(selectedField) + '';
                }
            }
            
            if(val == 'null'){
                val = '';
            }
            
            //"Does not contain" code by Donnie (using existing code and modifying)
             if (selectedOperator == 'Does Not Contain'){
                searchString = searchString + ' ' + quoteChar + likeChar + val +likeChar+quoteChar  + ') ';
            }
            else {
                searchString = searchString + ' ' + quoteChar + likeChar + val +likeChar+quoteChar  + ' ';
            }                      
  
            return searchString;
        }
        
        private boolean singleQuotesNeeded(){
            boolean required = false;
            if(fieldType == Schema.DisplayType.reference || fieldType == Schema.DisplayType.Email
                || fieldType == Schema.DisplayType.EncryptedString || fieldType == Schema.DisplayType.Id
                || fieldType == Schema.DisplayType.MultiPicklist || fieldType == Schema.DisplayType.Phone
                || fieldType == Schema.DisplayType.Picklist || fieldType == Schema.DisplayType.String
                || fieldType == Schema.DisplayType.TextArea || fieldType == Schema.DisplayType.URL){
                required = true;
            }
            
            return required;
        }
    }

    
}