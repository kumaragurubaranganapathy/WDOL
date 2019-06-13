public class SecurityCodeHelper {
    
    public static boolean isContactSecurityCodeSet = false;
    public static boolean isAccountSecurityCodeSet = false;
    
    public static void setContactSecurityCode(){
        if(SecurityCodeHelper.isContactSecurityCodeSet){ return; }
        SecurityCodeHelper.isContactSecurityCodeSet = true;
        
        
        List<Contact> contactsToUpdate = new List<Contact>();
        Integer len = 5;
        for(Contact contactRecord : (List<Contact>)Trigger.New){
            Blob blobKey = crypto.generateAesKey(128);
            System.debug('blobKey '+blobKey);   
            String key = EncodingUtil.convertToHex(blobKey);
            System.debug('key '+key);   
            String pwd = key.substring(0,len);
            System.debug('pwd '+pwd);   
            //system.debug('security code::' + String.valueOf(contactRecord.Id).substring(10,15)+ pwd);
            String contactId = contactRecord.Id;
            String securityCode = contactId.substring(10,15)+pwd;
            Contact contactToUpdate = new Contact(Id = contactId,
                                                 Security_Code__c = securityCode);
            contactsToUpdate.add(contactToUpdate);
        }
        update contactsToUpdate;
        
    }
    
    public static void setAccountSecurityCode(){
        if(SecurityCodeHelper.isAccountSecurityCodeSet){ return; }
        SecurityCodeHelper.isAccountSecurityCodeSet = true;
        
        
        List<Account> accountsToUpdate = new List<Account>();
        Integer len = 5;
        for(Account accountRecord : (List<Account>)Trigger.New){
            Blob blobKey = crypto.generateAesKey(128);
            System.debug('blobKey '+blobKey);   
            String key = EncodingUtil.convertToHex(blobKey);
            System.debug('key '+key);   
            String pwd = key.substring(0,len);
            System.debug('pwd '+pwd);   
            String accountId = accountRecord.Id;
            String securityCode = accountId.substring(10,15)+pwd;
            Account accountToUpdate = new Account(Id = accountId,
                                                 Security_Code__c = securityCode);
            accountsToUpdate.add(accountToUpdate);
        }
        update accountsToUpdate;
        
    }

}