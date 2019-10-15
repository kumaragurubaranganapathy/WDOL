public class ContactTriggerHandler implements BGCM.ITriggerHandler {
public void onAfterDelete() {}
    public void onAfterInsert() {
     if(DOL_AppUtility.isContactTrigger == false){
        DOL_AppUtility.isContactTrigger = true;
         AfterMethod();
        }
    }
    public void onAfterUndelete() {}
    public void onAfterUpdate() {
      if(DOL_AppUtility.isContactTrigger == false){
        DOL_AppUtility.isContactTrigger = true;
         AfterMethod();
        }
    }
    public void onBeforeDelete() {}
    public void onBeforeInsert() {
        last4SSN();
        duplicateFieldHelper();
        BeforeMethod();
    }
    public void onBeforeUndelete() {}
    public void onBeforeUpdate() {
    
    if(DOL_AppUtility.isContactTrigger == false){

         /* Added this part of code to change last 4 digits of SSN when SSN is changed in ViewPII page */
        list<Contact> triggerNew = trigger.new;
        for(Contact con: triggerNew){
            Contact oldcon = new Contact();
            if(Trigger.oldMap != null){
                oldcon = (Contact)Trigger.oldMap.get(con.ID);
            }
            if(con.Social_Security_Number_Encrypted__c!= oldcon.Social_Security_Number_Encrypted__c ){
                last4SSN();
            }
            
            duplicateFieldHelper();
        }
        
        BeforeMethod();
        }
    }
    
    public void last4SSN(){
        for(Contact c: (list<contact>)Trigger.New){
            if(c.Social_Security_Number_Encrypted__c != null){
                c.Last_4_Digits_of_SSN__c = c.Social_Security_Number_Encrypted__c.right(4);
                system.debug('Last 4 SSN:>>>>'+c.Last_4_Digits_of_SSN__c);
            } 
        }
    }
    
    public void duplicateFieldHelper(){
        for(Contact c: (list<contact>)Trigger.New){
            if(c.Last_4_Digits_of_SSN__c != null&&c.FirstName!=null&&c.lastname!=null&c.birthdate!=null){
                c.Dedup_Id__c = c.FirstName.trim()+c.lastname.trim()+c.birthdate+c.Last_4_Digits_of_SSN__c.right(4);
            } 
        }
    }
    
    public void BeforeMethod(){
        Set<String> deceasedcontacts = new Set<String> ();
        for(Contact c: (list<contact>)Trigger.New){
            // Set Contact Status to Inactive if Deceased Date is entered and move Email to Archived Email Address field
            if(c.Deceased_Date__c != null){
                c.Contact_Status__c = Label.St_Inactive;
                c.Archived_Email_Address__c = c.Email;
                c.Email = ''; // Initializing to null to block email sends
                deceasedcontacts.add(String.valueOf(c.Id).substring(0, 15));
            }
            system.debug('deceasedcontacts-->'+deceasedcontacts);
            //Update Contact Status if DOR Response Code was received
            if(c.Contact_Status__c == 'On Hold'){
                if(c.Dor_Response__c == 'CL' || c.Dor_Response__c == 'IC' || c.Dor_Response__c == 'HO' || c.Dor_Response__c == 'OK'){
                    c.Contact_Status__c = 'Active';
                    c.DOR_Response_Date__c = null;
                }
            }else{
                if(c.Dor_Response__c == 'CD' || c.Dor_Response__c == 'HD' || c.Dor_Response__c == 'AA'){
                    c.Contact_Status__c = 'On Hold';
                }
            }
        }
        
        //Deactivate Affiliations for
        
 List<Affiliation__c> deceasedAffiliations = [ Select id,Status__c from Affiliation__c  where (Contact_Id__c=:deceasedcontacts or related_contact__c=:deceasedcontacts) and Permit_Plan_Review__c!=null ];
      
        if(deceasedAffiliations.size()>0){
            for(Affiliation__c dcAff : deceasedAffiliations)
          {
            dcAff.status__c = Label.St_Inactive;
          }
            update deceasedAffiliations;
            system.debug('update success');
       }
    }
    
    public void AfterMethod(){
            if(!SecurityCodeHelper.isContactSecurityCodeSet){
                SecurityCodeHelper.setContactSecurityCode();
         }
    }
}