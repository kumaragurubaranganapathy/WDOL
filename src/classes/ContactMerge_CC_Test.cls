@isTest
private class ContactMerge_CC_Test {
    public static testMethod void MergeTest () {
        Global_Settings__c gs= new Global_Settings__c(SetupOwnerId=UserInfo.getUserId(), Disable_Triggers__c=true);
        insert gs;
        Account acc = CreateTestDataUtility.createAccount();
        insert acc;
        PageReference pageRef = Page.ContactMerge;
        
        Test.setCurrentPage(pageRef);
        
         ContactMerge_CC controller = new  ContactMerge_CC ();
        
        System.assertEquals(1, controller.lstFilterOptions.size());
        
        controller.addFilterOption();
        controller.addFilterOption();
        
        System.assertEquals(3, controller.lstFilterOptions.size());
        
        controller.currentRow = '2';
        controller.removeFilterOption();
        
        System.assertEquals(2, controller.lstFilterOptions.size());
        
        Contact objContact = new Contact(FirstName = 'Test', LastName = 'Bob', Birthdate = Date.today().addYears(-20));
        insert objContact;
        
        
         ContactMerge_CC.FilterOption fo = controller.lstFilterOptions[0];
        fo.selectedField = 'FirstName';
        fo.selectedOperator = '=';
        fo.objContact = new Contact(FirstName = 'Test');
        
         ContactMerge_CC.FilterOption fo2 = controller.lstFilterOptions[1];
        fo2.selectedField = 'LastName';
        fo2.selectedOperator = '=';
        fo2.objContact = new Contact(LastName = 'Bob');
        
        controller.strQueryFields = 'Firstname';
        controller.searchContacts();
        
        System.assertEquals(controller.cwList.size(), 1);	
        
        controller.ShowMergeTable();
        
        System.assertEquals(controller.lockMergeTable, true);
        
        Contact objContact2 = new Contact(FirstName = 'Amy', LastName = 'Aboud', Birthdate = Date.today().addYears(-19));
        insert objContact2;	
        
        Contact objContact3 = new Contact(FirstName = 'Beth', LastName = 'Barns', Birthdate = Date.today().addYears(-18));
        insert objContact3;
        delete gs;
        test.startTest();
        controller.selectTo();
        list< ContactMerge_CC.ContactWrapper> cwList = controller.cwList;
        for( ContactMerge_CC.ContactWrapper cw:cwList){
            if(cw.con.Id==objContact.Id){
                System.assertEquals (cw.isTo, false);
            }
        }
        ApexPages.currentPage().getParameters().put('mergeTo', objContact.Id);
        controller.selectTo();
        
        cwList = controller.cwList;
        for( ContactMerge_CC.ContactWrapper cw:cwList){
            if(cw.con.Id==objContact.Id){
                System.assertEquals (cw.isTo, true);
            }
        }
        
        ApexPages.currentPage().getParameters().put('mergeFrom', objContact2.Id);
        ApexPages.currentPage().getParameters().put('isChecked','false');
        controller.selectFrom();
        
        list< ContactMerge_CC.ContactWrapper> cwList2 = controller.cwList;
        for( ContactMerge_CC.ContactWrapper cw:cwList2){
            if(cw.con.Id==objContact2.Id){
                System.assertEquals (cw.isFrom, false);
            }
        }
        
        ApexPages.currentPage().getParameters().put('mergeFrom', objContact3.Id);
        ApexPages.currentPage().getParameters().put('isChecked','false');
        controller.selectFrom();
        list< ContactMerge_CC.ContactWrapper> cwList3 = controller.cwList;
        for( ContactMerge_CC.ContactWrapper cw:cwList3){
            if(cw.con.Id==objContact3.Id){
                System.assertEquals (cw.isFrom, false);
            }
        }
        
        controller.currentRow = '1';
        controller.filterOptionChanged();
        
        System.assertEquals (2, controller.lstFilterOptions.size());
        
        
        //What to setup before? Master Contact, Child Contacts
        controller.masterContact = objContact;
        controller.childContacts.add(objContact2);
        controller.childContacts.add(objContact3);
        controller.ShowSelectedContacts();
        controller.MergeSelectedContacts();
        
        controller.getHeadWrap ();
        //System.assertEquals(); What?
        
        controller.getRowWrappers();
        //System.assertEquals(); What?
        
        ApexPages.currentPage().getParameters().put('fieldName', 'FirstName');
        ApexPages.currentPage().getParameters().put('fieldValue', 'FirstName');
        controller.selectedFieldValue();
        //System.assertEquals();What?
        
         ContactMerge_CC.ContactWrapper cwrapper = new   ContactMerge_CC.ContactWrapper();
         ContactMerge_CC.ContactWrapper cwrapper1 = new   ContactMerge_CC.ContactWrapper(objContact);
        List<String> strings = new List<String>();
        string str1 = 'test123';
        string str2 = 'testing';
        string str3 = 'tester';
        strings.add(str1);
        strings.add(str2);
        strings.add(str3);
        cwrapper.labels = strings;
        cwrapper.isPortalUser = 'true';
        cwrapper1.isTo = true;
        
        controller.ShowSelectedContacts();
        
        controller.MergeTableFields = strings;
        test.stopTest();
    }  
    
    
    public static testMethod void MergeSelectedContacts(){
        test.startTest();
        Global_Settings__c gs= new Global_Settings__c(SetupOwnerId=UserInfo.getUserId(), Disable_Triggers__c=true);
        insert gs;
        Account testAccount = CreateTestDataUtility.createAccount();
        testAccount.Security_Code__c='test123';
        insert testAccount;
        Contact testContact = CreateTestDataUtility.createContact(testAccount.id);  
        insert testContact;
        
        Account testAccount1 = CreateTestDataUtility.createAccount();
        testAccount.Security_Code__c='test124';
        insert testAccount1;
        Contact testContact1 = CreateTestDataUtility.createContact(testAccount.id);  
        insert testContact1;
        delete gs;
        List<Contact> ctlist = new List<Contact>();
        ctlist.add(testContact);
        ctlist.add(testContact1);
        
        Set<ID> idlist = new Set<ID>();
        Map<String,String> arnamedmap = new Map<String, String>();
        
        //ID id1 = 'dfd235654545454545';
        //ID id2 = '235654errff';
        //ID id3 = 'dgfd2356dfv54';
        //ID id4 = '23dsf5654';
         ContactMerge_CC ctrl = new  ContactMerge_CC();
        System.debug('Ctrl' +ctrl.archivedFieldNameMap);
        ctrl.con = testContact;
        ctrl.nameFilter = 'namefilter';
        ctrl.MasterContactBeforeUpdate = testContact1;
        ctrl.AcrhivedQueryContacts = ctlist;
        //ctrl.ArchivedContacts = ctlist;
        ctrl.ArchivedContactFileds = 'ArchivedContactFileds';
        ctrl.SelectedContacts = ctrl.ShowSelectedContacts();
        
        
        ctrl.ArchivedFieldNameMap = arnamedmap;
        
        ctrl.SelectedContacts.addAll(ctlist);
        ctrl.MergeTableIds = new Set<Id>{testContact.Id};
            ctrl.getRowWrappers();
        //ctrl.MergeSelectedContacts();
        test.stopTest();
    }   
}