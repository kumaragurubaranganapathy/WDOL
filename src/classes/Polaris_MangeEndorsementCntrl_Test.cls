@isTest
public class Polaris_MangeEndorsementCntrl_Test {
    @isTest
    public static void testMethod1(){
        Id AccRecTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Business Account').getRecordTypeId();
        Account a = DOL_TestDataFactory.createAccount(AccRecTypeId);
        Id LicRecTypeId1 = Schema.SObjectType.MUSW__License2__c.getRecordTypeInfosByName().get('Business').getRecordTypeId();
        MUSW__License2__c lic1 = DOL_TestDataFactory.createLicense(LicRecTypeId1, a.Id, 'Architects', 'Architect', 'General Application');
        lic1.Application_Type__c = 'Notary Public';
        lic1.Credential_Type__c = 'Notary Public';
        update lic1;
        Request__c req = DOL_TestDataFactory.createRequest(lic1.Id, 'Architects', 'Architect');
        Id quesRecTypeId = Schema.SObjectType.Question__c.getRecordTypeInfosByName().get('License Information').getRecordTypeId();
        Question__c ques = DOL_TestDataFactory.createQuestion(quesRecTypeId);
        ques.Section__c = 'Endorsement';
        update ques;
        Answer__c ans = DOL_TestDataFactory.createAnswer(lic1.Id,ques.Id);
        BGCK__Answer__c bgAns = new BGCK__Answer__c();
        bgAns.QuestionDOL__c = ques.Id;
        bgAns.Request__c = req.Id;
        bgAns.License__c = lic1.Id;
        insert bgAns;
        Polaris_MangeEndorsementCntrl.fetchData(lic1.Id);
    }
    
    @isTest
    public static void testMethod2(){
        Id AccRecTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Business Account').getRecordTypeId();
        Account a = DOL_TestDataFactory.createAccount(AccRecTypeId);
        Id LicRecTypeId1 = Schema.SObjectType.MUSW__License2__c.getRecordTypeInfosByName().get('Business').getRecordTypeId();
        MUSW__License2__c lic1 = DOL_TestDataFactory.createLicense(LicRecTypeId1, a.Id, 'Architects', 'Architect', 'General Application');
        lic1.Application_Type__c = 'Notary Public';
        lic1.Credential_Type__c = 'Notary Public';
        update lic1;
        Request__c req = DOL_TestDataFactory.createRequest(lic1.Id, 'Architects', 'Architect');
        Id quesRecTypeId = Schema.SObjectType.Question__c.getRecordTypeInfosByName().get('License Information').getRecordTypeId();
        Question__c parentQues = new Question__c();
        parentQues.Question_Body__c = 'Total test number of test test full';
        parentQues.Data_Type__c = 'Picklist';
        parentQues.Parent_Object_API_Name__c = 'MUSW__License2__c';
        parentQues.RecordTypeId = quesRecTypeId;
        parentQues.Application_Type__c = 'Notary Public';
        parentQues.External_Id__c = 'abc1223';
        parentQues.QuestionFieldAPI__c = 'Name';
        insert parentQues;
        Question__c ques = DOL_TestDataFactory.createQuestion(quesRecTypeId);
        ques.Section__c = 'Endorsement';
        ques.Parent_Question__c = parentQues.Id;
        ques.Possible_Responses__c = 'test';
        ques.Data_Type__c = 'Radio';
        update ques;
        Answer__c ans = DOL_TestDataFactory.createAnswer(lic1.Id,ques.Id);
        BGCK__Answer__c bgAns = new BGCK__Answer__c();
        bgAns.QuestionDOL__c = ques.Id;
        bgAns.Request__c = req.Id;
        bgAns.License__c = lic1.Id;
        insert bgAns;
        Polaris_MangeEndorsementCntrl.fetchData(lic1.Id);
        Polaris_MangeEndorsementCntrl.fetchAssociations(lic1.Id);
        Polaris_MangeEndorsementCntrl.insertEndorsement(lic1.Id, 'Notary Public');
        Polaris_MangeEndorsementCntrl.fetchProvider('5576vhgftf');
    }
    
    @isTest
    public static void testMethod3(){
        Polaris_MangeEndorsementCntrl.fetchEndorsementTypeData('Notary Public');
    }
    
    @isTest
    public static void testMethod4(){
        try{
            Polaris_MangeEndorsementCntrl.removeProvider('t68686588658');
        }catch(exception ex){}
    }
    
    @isTest
    public static void testMethod5(){
        try{
            Polaris_MangeEndorsementCntrl.removeEndorsement('t68686588658');
        }catch(exception ex){}
    }
    
    @isTest
    public static void testMethod6(){
        Id AccRecTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Business Account').getRecordTypeId();
        Account a = DOL_TestDataFactory.createAccount(AccRecTypeId);
        Id LicRecTypeId1 = Schema.SObjectType.MUSW__License2__c.getRecordTypeInfosByName().get('Business').getRecordTypeId();
        MUSW__License2__c lic1 = DOL_TestDataFactory.createLicense(LicRecTypeId1, a.Id, 'Architects', 'Architect', 'General Application');
        lic1.Application_Type__c = 'Notary Public';
        lic1.Credential_Type__c = 'Notary Public';
        update lic1;
        Request__c req = DOL_TestDataFactory.createRequest(lic1.Id, 'Architects', 'Architect');
        Id quesRecTypeId = Schema.SObjectType.Question__c.getRecordTypeInfosByName().get('License Information').getRecordTypeId();
        Question__c ques = DOL_TestDataFactory.createQuestion(quesRecTypeId);
        ques.Section__c = 'Endorsement';
        update ques;
        Answer__c ans = DOL_TestDataFactory.createAnswer(lic1.Id,ques.Id);
        BGCK__Answer__c bgAns = new BGCK__Answer__c();
        bgAns.QuestionDOL__c = ques.Id;
        bgAns.Request__c = req.Id;
        bgAns.License__c = lic1.Id;
        insert bgAns;
        Polaris_MangeEndorsementCntrl.insertRequest(lic1.Id, 'Notary Public','Notary Public');
    }
    
    @isTest
    public static void testMethod7(){
        Id AccRecTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Business Account').getRecordTypeId();
        Account a = DOL_TestDataFactory.createAccount(AccRecTypeId);
        Id LicRecTypeId1 = Schema.SObjectType.MUSW__License2__c.getRecordTypeInfosByName().get('Business').getRecordTypeId();
        MUSW__License2__c lic1 = DOL_TestDataFactory.createLicense(LicRecTypeId1, a.Id, 'Notary Public', 'Notary Public', 'General Application');
        Endorsement__c endo = new Endorsement__c();
        endo.License__c = lic1.Id;
        endo.Status__c = 'Active';
        endo.Date_Requested_for_Adding_Endorsement__c = system.today();
        endo.Endorsement_Type__c = 'Nuclear';
        endo.License_Type__c = 'Notary Public';
        insert endo;
        Electronic_Notary_Provider_Information__c eProvidr = DOL_TestDataFactory.createElectronicProviderInfo(endo.Id);
        try{
            Polaris_MangeEndorsementCntrl.removeProvider(eProvidr.Id);
            Polaris_MangeEndorsementCntrl.removeEndorsement(endo.Id);
        }catch(exception ex){}
    }
    
    @isTest
    public static void testMethod8(){
        Id AccRecTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Business Account').getRecordTypeId();
        Account a = DOL_TestDataFactory.createAccount(AccRecTypeId);
        Id LicRecTypeId1 = Schema.SObjectType.MUSW__License2__c.getRecordTypeInfosByName().get('Business').getRecordTypeId();
        MUSW__License2__c lic1 = DOL_TestDataFactory.createLicense(LicRecTypeId1, a.Id, 'Architects', 'Architect', 'General Application');
        Endorsement__c endo = DOL_TestDataFactory.createEndorsement(lic1.Id, 'Active');
        Electronic_Notary_Provider_Information__c eProvidr = DOL_TestDataFactory.createElectronicProviderInfo(endo.Id);
        try{
            Polaris_MangeEndorsementCntrl.removeProvider(eProvidr.Id);
            Polaris_MangeEndorsementCntrl.removeEndorsement(endo.Id);
        }catch(exception ex){}
    }
    
    @isTest
    public static void testMethod9(){
        Id AccRecTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Business Account').getRecordTypeId();
        Account a = DOL_TestDataFactory.createAccount(AccRecTypeId);
        Id LicRecTypeId1 = Schema.SObjectType.MUSW__License2__c.getRecordTypeInfosByName().get('Business').getRecordTypeId();
        MUSW__License2__c lic1 = DOL_TestDataFactory.createLicense(LicRecTypeId1, a.Id, 'Notary Public', 'Notary Public', 'General Application');
        
        //list<LnP_ApplyForLicenseWrapper> wrapList = new list<LnP_ApplyForLicenseWrapper>();
        LnP_ApplyForLicenseWrapper licenseWrapper = new LnP_ApplyForLicenseWrapper();
        licenseWrapper.sectionName = 'Attachments';
        licenseWrapper.subheader = 'Attachments';
        licenseWrapper.currentTab = 1;
        licenseWrapper.tabIndex = 1;
        //wrapList.add(licenseWrapper);
        String dataStr = Json.serialize(licenseWrapper);
        try{
            Polaris_MangeEndorsementCntrl.updateEndorsement(dataStr, lic1.Id, 'Notary Public');
        }catch(Exception ex){}
    }
    
    @isTest
    public static void testMethod10(){
        Id AccRecTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Business Account').getRecordTypeId();
        Account a = DOL_TestDataFactory.createAccount(AccRecTypeId);
        Id LicRecTypeId1 = Schema.SObjectType.MUSW__License2__c.getRecordTypeInfosByName().get('Business').getRecordTypeId();
        MUSW__License2__c lic1 = DOL_TestDataFactory.createLicense(LicRecTypeId1, a.Id, 'Notary Public', 'Notary Public', 'General Application');
        Request__c req = DOL_TestDataFactory.createRequest(lic1.Id, 'Architects', 'Architect');
        Id quesRecTypeId = Schema.SObjectType.Question__c.getRecordTypeInfosByName().get('License Information').getRecordTypeId();
        Question__c ques = DOL_TestDataFactory.createQuestion(quesRecTypeId);
        ques.Section__c = 'Endorsement';
        update ques;
        Answer__c ans = DOL_TestDataFactory.createAnswer(lic1.Id,ques.Id);
        BGCK__Answer__c bgAns = new BGCK__Answer__c();
        bgAns.QuestionDOL__c = ques.Id;
        bgAns.Request__c = req.Id;
        bgAns.License__c = lic1.Id;
        insert bgAns;
        list<LnP_ApplyForLicenseWrapper> wrapList = new list<LnP_ApplyForLicenseWrapper>();
        LnP_ApplyForLicenseWrapper licenseWrapper = new LnP_ApplyForLicenseWrapper();
        LnP_ApplyForLicenseWrapper.MapLabelToFields mf = new LnP_ApplyForLicenseWrapper.MapLabelToFields();
        mf.label = 'test';
        mf.value = 'test';
        mf.answerId = bgAns.Id;
        List<LnP_ApplyForLicenseWrapper.MapLabelToFields> mfList = new List<LnP_ApplyForLicenseWrapper.MapLabelToFields>();
        mfList.add(mf);
        licenseWrapper.sectionName = 'Attachments';
        licenseWrapper.subheader = 'Attachments';
        licenseWrapper.currentTab = 1;
        licenseWrapper.tabIndex = 1;
        licenseWrapper.labelFieldsMap = mfList;
        wrapList.add(licenseWrapper);
        String dataStr = Json.serialize(wrapList);
        Endorsement__c endo = DOL_TestDataFactory.createEndorsement(lic1.Id, 'Active');
        try{
            Polaris_MangeEndorsementCntrl.updateEndorsement(dataStr, lic1.Id, 'Notary Public');
        }catch(Exception ex){}
    }
}