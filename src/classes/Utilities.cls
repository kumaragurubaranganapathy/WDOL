/*************************************************************************************************************
** User Story: 
**************************************************************************************************************
** Class Name       : Utilities
** Description      : 
** Version          : 1.0
** Built By         : 
**------------------------------------------------------------------------------------------------------------
** Modification Log:
**------------------
** Developer                  Date          Version               Description
**------------------------------------------------------------------------------------------------------------
**
** Review Log:
**---------------
** Reviewer                   Date           Version                Description
**------------------------------------------------------------------------------------------------------------
**
*************************************************************************************************************/
public class Utilities {
    
    private static String isSandboxCheck = null;
    
    /*
* This method returns the id of record type name
* @param: sObjectAPIName object name.
* @param: strRecordTypeName Record type name.         
* @return Type: Id of the record type name.
*/
    public static Id getRecordTypeForName(String sObjectAPIName, String strRecordTypeName){      
        Schema.DescribeSObjectResult sobjectResult = Schema.getGlobalDescribe().get(sObjectAPIName).getDescribe();      
        Map<String,Schema.RecordTypeInfo> rtMapByName = sobjectResult.getRecordTypeInfosByName();
        Schema.RecordTypeInfo rtByName =  rtMapByName.get(strRecordTypeName);
        Id recordtypeID = rtByName.getRecordTypeId();        
        return recordtypeID;
    }      
    
    public static List<String> getAllFieldsSObject(String objectName, Set<String> fieldsToExclude){
        List<String> lstFieldNames = new List<String>();
        Map <String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
        Map <String, Schema.SObjectField> fieldMap = schemaMap.get(objectName).getDescribe().fields.getMap();
        for(Schema.SObjectField sfield : fieldMap.Values()){
            Schema.describeFieldResult dfield = sfield.getDescribe();
            
            if(!fieldsToExclude.contains(dfield.getName())){
                lstFieldNames.add(dfield.getName());
            }
        }
        
        return lstFieldNames;
    }
    
    public static List<String> getAllFieldsSObject(String objectName, Set<String> fieldsToExclude, Boolean excludeFormulaFields){
        List<String> lstFieldNames = new List<String>();
        Map <String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
        Map <String, Schema.SObjectField> fieldMap = schemaMap.get(objectName).getDescribe().fields.getMap();
        for(Schema.SObjectField sfield : fieldMap.Values()){
            Schema.describeFieldResult dfield = sfield.getDescribe();
            
            if(excludeFormulaFields && dfield.isCalculated()){
                //Do Nothing
            }else{
                if(!fieldsToExclude.contains(dfield.getName())){
                    lstFieldNames.add(dfield.getName());
                }
            }
        }
        
        return lstFieldNames;
    }
    
    public static Contact getFullProfileDetails(String contactId){
        System.debug('ContactId' +contactId);
        System.debug('Entered here');
        return [Select Id ,
                FirstName, 
                Name,
                Contact_Suffix__c,
                Served_in_Military__c,
                Spouse_Served_in_the_Military__c,
                Still_Serving_in_Military__c,
                Branch_of_Military_Service__c,
                Country_of_Military_Service__c,
                Start_Date_Military_Service__c,
                End_Date_Military_Service__c,
                Honorable_Discharge__c,
                Maiden_Name__c ,
                MiddleName,
                Email ,
                Title,
                Phone,
                Fax,
                MobilePhone,
                OtherPhone ,
                Social_Security_Number_Encrypted__c,
                Birthdate ,
                Birth_City__c ,
                Birth_Country__c,
                Birth_State_Province__c ,
                Gender__c ,
                Ethnicity__c , 
                Aliases__c ,
                LastName
                //RecordTypeId
                from Contact Where ID = : contactId ] ;
    }
    
    public static boolean isGuestUserLoggedIn()
    {
        Boolean bRet = (UserInfo.getUserType() == 'Guest');
        
        return bRet ;
    }
    
    public static boolean checkBlockedEmail (Contact con) {
        boolean emailPass = true;
        //list <Blocked_Email_Registration__mdt> blockedEmails = [SELECT Email__c FROM Blocked_Email_Registration__mdt Limit 100];
        for (Blocked_Email_Registration__mdt bemail :[SELECT Email__c FROM Blocked_Email_Registration__mdt Limit 100]){
            if(bemail.Email__c != null){
                if (con.Email.containsIgnoreCase(bemail.Email__c)) {
                    emailPass = false;
                    return emailPass;  
                }
            }
        }
        return emailPass;
    } 
    
    public static Boolean runningInASandbox() {
        Boolean isSandbox = true; //Default to sandbox
        //In order to avoid multiple queries in the same transaction, query the first time and cache the value.
        if(isSandboxCheck == null || isSandboxCheck != 'complete'){
            isSandbox = [SELECT IsSandbox FROM Organization LIMIT 1].IsSandbox;
            isSandboxCheck = DOL_AppConstants.NULL_EMPTY_STRING + 'complete';
        }
        
        return isSandbox;
    }
    /**
* Function get Next Business Day based on Target Date
**/
    public static Date getNextBusinessDay(Id businessHoursId, Date targetDate){
        DateTime targetDateTime = Datetime.newInstance(targetDate.year(), targetDate.month(), targetDate.day());
        return BusinessHours.nextStartDate(businessHoursId, targetDateTime).date();
    } 
    
    public static  Set<String> getallCredentials()
    {
        String allcred = label.Str_All_Credentials;
        List<String> licensessinlabels =allcred.split(';');
        SET<string> allcredentials = new SET<string>();
        allcredentials.addall(licensessinlabels);
        return allcredentials;
        
    }
    
    /*public static  Set<String> getallPlanreviewsandpermits()
    {
        String allperms = label.Str_All_Permits_and_plan_review;
        List<String> permsinlabels =allperms.split(';');
        SET<string> allpermits = new SET<string>();
        allpermits.addall(permsinlabels);
        return allpermits;
        
    }
    
    public static  Set<String> getallPOWTSOffices()
    {
        String powtsoff = label.Str_POWTS_Offices;
        List<String> powtsofflabels =powtsoff.split(';');
        SET<string> offices = new SET<string>();
        offices.addall(powtsofflabels);
        return offices;
        
    }
    
    public static  Set<String> getallMHCOffices()
    {
        String mhcoff = label.Str_MHC_Offices;
        List<String> mhcofflabels =mhcoff.split(';');
        SET<string> offices = new SET<string>();
        offices.addall(mhcofflabels);
        return offices;
        
    }*/
    
    /**
    * Method to create invoice for Permit
    * */
    /*public static void createInvoice(SObject sobj){
        Id recordId = sobj.Id;
        if(sobj instanceof MUSW__Permit2__c){
            MUSW__Permit2__c permitObj = [Select ID,MUSW__Account__c, Generate_Invoice__c,MUSW__Total_Fees__c,
                                          (Select ID,BGBK__Invoice__c from MUSW__Fees__r) from MUSW__Permit2__c where ID = :recordId and Id != null];
            //Generate Invoice only if Flag is checked
            if(permitObj.Generate_Invoice__c){
                BGBK__Bill__c invoice = getInvoice(permitObj.MUSW__Account__c, permitObj.MUSW__Total_Fees__c,permitObj.Id);
                insert invoice;
                assoiceateFeesToInvoice(permitObj.MUSW__Fees__r, invoice);
            } 
        }else if(sobj instanceof Renewal_Application__c){
            Renewal_Application__c renewalApp = [Select ID,Licensee__c, Generate_Invoice__c,Total_Fees__c,Permit__c,
                                                 (Select ID,BGBK__Invoice__c from Fees__r) from Renewal_Application__c where ID = :recordId and ID != null];
            //Generate Invoice only if Flag is checked
            if(renewalApp.Generate_Invoice__c){
                BGBK__Bill__c invoice = getInvoice(renewalApp.Licensee__c, renewalApp.Total_Fees__c,renewalApp.Permit__c);
                insert invoice;
                assoiceateFeesToInvoice(renewalApp.Fees__r, invoice);
            } 
        }
    }*/
    
    /**
    * Assoicate Fees to Invoice
    * */
    /*private static void assoiceateFeesToInvoice(List<MUSW__Fee__c> feeList, BGBK__Bill__c invoice){
        for(MUSW__Fee__c fee : feeList){
            fee.BGBK__Invoice__c = invoice.Id;
        }
        update feeList;
    }*/
    
    /**
    * Get Invoice record
    * */
    /*private static BGBK__Bill__c getInvoice(Id recipient, Decimal totalFees, Id permitId){
        BGBK__Bill__c invoice = new BGBK__Bill__c(BGBK__Recipient2__c = recipient,
                                                  BGBK__Invoice_Date__c = System.today(),
                                                  BGBK__Total_Fees__c = totalFees,
                                                  Permit__c = permitId);
        return invoice;
    }*/
}