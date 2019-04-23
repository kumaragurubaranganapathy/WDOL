public class HomeAuthService {
	
    public class LicenseObj implements Comparable{

        // Class variables
        public Id id {get; set;}
        public String name {get; set;}
       // public String board {get; set;}
        public String applicationType {get; set;}
        public String credential {get; set;}
        public String credentialType {get; set;}
        public Date expiryDt {get; set;}
        public String expiryDate {get; set;}
        public Decimal completedHours {get; set;}
        public Decimal totalHours {get; set;}
        public String status {get; set;}
        public String accountId {get; set;}
        public String contactId {get; set;}
        public String parcelId {get; set;}
        public Boolean businessLicense {get; set;}
        
        public MUSW__License2__c licenseObject {get; set;}
        public String endorsementLabel{get;set;}
        public String subStatus {get;set;}
        public String businessName {get;set;}
        public String businessalias {get;set;}
        
        public List<Service_Links__mdt> serviceRequestList {get; set;}
        
        /**
         * Constructor
         * @param     Record Id, name, applicationType, credential, credentialType, expiry date, status, account Id, license object
         */
        public LicenseObj(Id id, String name, string applicationType, String credential, String credentialType, Date expiryDate, String status, String accountId, Boolean businessLicense, MUSW__License2__c licenseObject, String contactId) {

            // Assign values
            this.id = id;
            this.name = name;
          //  this.board = board;
            this.applicationType = applicationType;
            this.credential = credential;
            this.credentialType = credentialType;
            this.status = status;
            this.accountId = accountId;
            this.contactId = contactId;
            this.expiryDt = expiryDate;
            this.businessLicense = businessLicense;
            this.licenseObject = licenseObject;
            
          //  this.subStatus = subStatus;
          //  this.businessName = businessName;
          //  this.businessalias = businessalias;

            // Get date in desired format
            if(expiryDate != null) {
                this.expiryDate = expiryDate.month() + '/' + expiryDate.day() + '/' + expiryDate.year();
            }
        }
        
        /**
         * Method - Returns corresponding field based on parameter
         * @param     Field name
         * @return    String
         */
        public String getField(String fieldName) {
            
            if(fieldName == 'id')
                return this.id;
          //  else if(fieldName == label.Str_board)
          //      return this.board;
            else if(fieldName == 'credential')
                return this.credential;
            else if(fieldName == 'expiryDate')
                return this.expiryDate;
          //   else if(fieldName == label.Str_businessName)
          //      return this.businessName;
            else
                return null;
        }
        
        /**
         * Method - Returns corresponding date field based on parameter
         * @param     Field name
         * @return    Date
         */
        public Date getDateField(String fieldName) {

            if(fieldName == 'expiryDt')
                return this.expiryDt;
            else
                return null;
        }

        /**
         * Method - Returns field type based on parameter passed
         * @param     Field name
         * @return    String
         */
        public String getFieldType(String fieldName) {

            if(fieldName == 'licenseType')
                return label.Str_String;
            else if(fieldName == 'expiryDt')
                return label.Str_Date;
             else if(fieldName == 'businessName')
                return label.Str_String;
            else
                return null;
        }
        public Integer compareTo(Object compareTo) {
            LicenseObj compartToObj = (LicenseObj) compareTo;
            if (compartToObj.expiryDt < this.expiryDt) return +1;
            if (compartToObj.expiryDt > this.expiryDt) return -1;
            return 0; 
        }
    }
    /**
     * Class for renewal-reinstatement object
     * @version     1.0
     */
    public class RenewReinstateObj {

        // Class variables
        public String id {get; set;}
        public Boolean isLicense {get; set;}
        //public Boolean isEndorsement {get; set;}
        public Boolean isPaymentDue {get; set;}
        public Boolean canApply {get; set;}
        public String url {get; set;}
        public String label {get; set;}
        public Boolean isOnHold {get; set;}

        /**
         * Constructor
         * @param Record Id, isLicense variable, isEndorsement variable, URL, label
         */
        public RenewReinstateObj(String id, Boolean isLicense, /*Boolean isEndorsement, */Boolean isPaymentDue, Boolean canApply, String url, String label) {

            // Assign values
            this.id = id;
            this.isLicense = isLicense;
           // this.isEndorsement = isEndorsement;
            this.isPaymentDue = isPaymentDue;
            this.canApply = canApply;
            this.url = url;
            this.label = label;
        }
        
        public RenewReinstateObj(String id, Boolean isLicense, Boolean isOnHold, Boolean isPaymentDue, Boolean canApply, String url, String label) {

            // Assign values
            this.id = id;
            this.isLicense = isLicense;
            this.isOnHold = isOnHold;
            this.isPaymentDue = isPaymentDue;
            this.canApply = canApply;
            this.url = url;
            this.label = label;
        }
    }
    
    
    
    /**
     * Method - sortCustomListAsc
     * @param     List to be sorted, field name
     * @return    List of LicenseObj records
     */
    public static List<LicenseObj> sortCustomListAsc(List<LicenseObj> listToSort, String sortBasedOnField) {

        // Initialize lists
        List<LicenseObj> sortedList = new List<LicenseObj>();
        List<String> stringList = new List<String>();
        List<Date> dateList = new List<Date>();
        String fieldDataType = '';
        // Add all strings for sorting
        for(LicenseObj lObj : listToSort) {
            fieldDataType = lObj.getFieldType(sortBasedOnField);
            if(fieldDataType == label.Str_Date)
                dateList.add(lObj.getDateField(sortBasedOnField));
            else 
                stringList.add(lObj.getField(sortBasedOnField));
        } 

        // Sort if type date
        if(fieldDataType == label.Str_Date) {
            dateList.sort();
        }
        // Sort if type string
        else {
            stringList.sort();
        }

        // Add to set
        if(fieldDataType == label.Str_Date) {

            // Build a set of date values
            Set<Date> dateSet = new Set<Date>();
            dateSet.addAll(dateList);

            // Build sorted list
            for(Date strSetObj : dateSet) {
                for(LicenseObj lObj : listToSort) {
                    if(strSetObj == lObj.getDateField(sortBasedOnField)) {
                        sortedList.add(lObj);
                    }
                }
            }
        }
        else {
            // Build a set of string values
            Set<String> stringSet = new Set<String>();
            stringSet.addAll(stringList);

            if(sortBasedOnField == 'businessName')
            {
                 List<LicenseObj> sortedList2 = new List<LicenseObj>();
                 for(String strSetObj : stringSet) {
                for(LicenseObj lObj : listToSort) {
                    if(strSetObj == lObj.getField(sortBasedOnField)) {
                    if(lObj.businessLicense){
                        sortedList.add(lObj);
                    }
                    else{
                        sortedList2.add(lObj);
                    }
                }
                }
            }
                sortedList.addAll(sortedList2);
            }
            else{
            // Build sorted list
            for(String strSetObj : stringSet) {
                for(LicenseObj lObj : listToSort) {
                    if(strSetObj == lObj.getField(sortBasedOnField)) {
                        sortedList.add(lObj);
                    }
                }
            }
            }
        }
        // Optimize lists
        listToSort.clear();
        // Return list
        return sortedList; 

    }
    
    public class permitObj implements Comparable{

        // Class variables
        public Id id {get; set;}
        public String name {get; set;}
        public String applicationType {get; set;}
        public String programArea {get; set;}
        public String permitType {get; set;}
        public Date expiryDt {get; set;}
        public String expiryDate {get; set;}
        public Decimal completedHours {get; set;}
        public Decimal totalHours {get; set;}
        public String status {get; set;}
        public String accountId {get; set;}
        public Boolean businessLicense {get; set;}
        
        public MUSW__Permit2__c permitObject {get; set;}
        public String endorsementLabel{get;set;}
        public String subStatus {get;set;}
        public String businessName {get;set;}
        public String businessalias {get;set;}
        public Boolean isInvoiceRequested {get;set;}
        public Decimal totalBalance {get;set;}
        public Boolean isPaymentPending {get;set;}
        public List<Service_Links__mdt> serviceRequestList {get; set;}
        
        /**
         * Constructor
         * @param     Record Id, name, applicationType, programArea, permitType, expiry date, status, account Id, license object
         */
        public permitObj(Id id, String name, string applicationType, String programArea, String permitType, Date expiryDate, String status, String accountId, Boolean businessLicense, MUSW__Permit2__c permitObject, Boolean isInvoiceRequested, Decimal totalBalance) {

            // Assign values
            this.id = id;
            this.name = name;
          //  this.board = board;
            this.applicationType = applicationType;
            this.programArea = programArea;
            this.permitType = permitType;
            this.status = status;
            this.accountId = accountId;
            this.expiryDt = expiryDate;
            this.businessLicense = businessLicense;
            this.permitObject = permitObject;
            this.isInvoiceRequested = isInvoiceRequested;
            this.totalBalance = totalBalance;
            this.isPaymentPending = (this.status == Label.St_Generate_Fee || (this.status == Label.ST_Submitted && this.totalBalance >0 && this.isInvoiceRequested )) ? true : false;
          //  this.subStatus = subStatus;
          //  this.businessName = businessName;
          //  this.businessalias = businessalias;

            // Get date in desired format
            if(expiryDate != null) {
                this.expiryDate = expiryDate.month() + '/' + expiryDate.day() + '/' + expiryDate.year();
            }
        }
        
        /**
         * Method - Returns corresponding field based on parameter
         * @param     Field name
         * @return    String
         */
        public String getField(String fieldName) {
            
            if(fieldName == 'id')
                return this.id;
            else if(fieldName == 'credential')
                return this.programArea;
            else if(fieldName == 'expiryDate')
                return this.expiryDate;
          //   else if(fieldName == label.Str_businessName)
          //      return this.businessName;
            else
                return null;
        }
        
        /**
         * Method - Returns corresponding date field based on parameter
         * @param     Field name
         * @return    Date
         */
        public Date getDateField(String fieldName) {

            if(fieldName == 'expiryDt')
                return this.expiryDt;
            else
                return null;
        }

        /**
         * Method - Returns field type based on parameter passed
         * @param     Field name
         * @return    String
         */
        public String getFieldType(String fieldName) {

            if(fieldName == 'licenseType')
                return label.Str_String;
            else if(fieldName == 'expiryDt')
                return label.Str_Date;
             else if(fieldName == 'businessName')
                return label.Str_String;
            else
                return null;
        }
        
        public Integer compareTo(Object compareTo) {
            permitObj compartToObj = (permitObj) compareTo;
            if (compartToObj.expiryDt < this.expiryDt) return +1;
            if (compartToObj.expiryDt > this.expiryDt) return -1;
            return 0; 
        }
        
    }
    /**
     * Method -   sortpermitListAsc
     * @param     List to be sorted, field name
     * @return    List of planreviewObj records
     */
    public static List<permitObj> sortpermitListAsc(List<permitObj> listToSort, String sortBasedOnField) {

        // Initialize lists
        List<permitObj> sortedList = new List<permitObj>();
        List<String> stringList = new List<String>();
        List<Date> dateList = new List<Date>();
        String fieldDataType = '';
        // Add all strings for sorting
        for(permitObj permitObj : listToSort) {
            fieldDataType = permitObj.getFieldType(sortBasedOnField);
            if(fieldDataType == label.Str_Date)
                dateList.add(permitObj.getDateField(sortBasedOnField));
            else 
                stringList.add(permitObj.getField(sortBasedOnField));
        } 

        // Sort if type date
        if(fieldDataType == label.Str_Date) {
            dateList.sort();
        }
        // Sort if type string
        else {
            stringList.sort();
        }

        // Add to set
        if(fieldDataType == label.Str_Date) {

            // Build a set of date values
            Set<Date> dateSet = new Set<Date>();
            dateSet.addAll(dateList);

            // Build sorted list
            for(Date strSetObj : dateSet) {
                for(PermitObj pObj : listToSort) {
                    if(strSetObj == pObj.getDateField(sortBasedOnField)) {
                        sortedList.add(pObj);
                    }
                }
            }
        }
        else {
            // Build a set of string values
            Set<String> stringSet = new Set<String>();
            stringSet.addAll(stringList);

            if(sortBasedOnField == 'businessName')
            {
                 List<PermitObj> sortedList2 = new List<PermitObj>();
                 for(String strSetObj : stringSet) {
                for(PermitObj pObj : listToSort) {
                    if(strSetObj == pObj.getField(sortBasedOnField)) {
                    if(pObj.businessLicense){
                        sortedList.add(pObj);
                    }
                    else{
                        sortedList2.add(pObj);
                    }
                }
                }
            }
                sortedList.addAll(sortedList2);
            }
            else{
            // Build sorted list
            for(String strSetObj : stringSet) {
                for(PermitObj pObj : listToSort) {
                    if(strSetObj == pObj.getField(sortBasedOnField)) {
                        sortedList.add(pObj);
                    }
                }
            }
            }
        }
        // Optimize lists
        listToSort.clear();
        // Return list
        return sortedList; 

    }
    
    public class CredentialNameComparator extends DSPSComparator{
        public override Integer compare(Object a, Object b) {
            return ((LicenseObj)a).credential.compareTo(((LicenseObj)b).credential );
        }
    }
    
    public class PermitNameComparator extends DSPSComparator{
        public override Integer compare(Object a, Object b) {
            return ((permitObj)a).permitType.compareTo(((permitObj)b).permitType );
        }
    }

}