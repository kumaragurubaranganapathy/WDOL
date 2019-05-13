public class DOL_Dao {

    public Contact getContactDetailsForSessionTransfer(Id contactId){
        Contact outputContact = [ select lastName, firstName, mailingstreet, mailingcity, mailingstate, mailingcountry , email, MobilePhone, MailingPostalCode from contact where id =: contactId];
        return outputContact;
    }
}