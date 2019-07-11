public class Polaris_UtilityClass {
    
    public  EmailTemplate getEmailTemplate(string templateName) {
        List<EmailTemplate> emailTemplateList = [SELECT Id, Subject, HtmlValue
                                                 FROM EmailTemplate
                                                 WHERE Name =: templateName
                                                 LIMIT 1];
        if(!emailTemplateList.isEmpty()) {
            return emailTemplateList[0];
        } else {
            return null;
        }
    }
    
    public  Id getOrgWideEmailAddressId(string senderAddress) {
        List<OrgWideEmailAddress> emailAddressList = [SELECT Id
                                                      from OrgWideEmailAddress
                                                      WHERE Address = :senderAddress
                                                      LIMIT 1];
        if(!emailAddressList.isEmpty()) {
            return emailAddressList[0].Id;
        } else {
            return null;
        }
    }
}