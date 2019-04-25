/**
* Name: ApexUserSharingModel
* Type: Class
* Description: Apex Class for Sharing records with Customer Community Plus Portal user.
* Date:        Developer/Company                 	Description
* ---------------------------------------------------------------------------------------------------------------------------------------- *
* 08/16/2018   Srikanth Kottam/Deloitte           Initial Creation
**/
public class ApexUserSharingModel {
    //List to store the records of an sObject which are to be shared 
    public List < sObject > ShareRecords {
        get {
            if (ShareRecords == null) ShareRecords = new List < sObject > ();
            return ShareRecords;
        }
        set;
    }

    //List to store the records of an share sObject to which the records will be inserted so that community plus user can Access
    public List < sObject > ShareObjectRecords {
            get {
                if (ShareObjectRecords == null) ShareObjectRecords = new List < sObject > ();
                return ShareObjectRecords;
            }
            set;
        }
        //ContactUserMap to store contact and User. User Id can be fetched using the contact as Key. UserId has to be mentioned while inserting record in Share Object
    public Map < Id, Id > ContactUserMap {
        get {
            if (ContactUserMap == null) ContactUserMap = new Map < Id, Id > ();
            return ContactUserMap;
        }
        set;
    }

    //List of Users for contacts in AccountContact Map
    Public List < User > users {
        get {
            if (users == null) users = new List < User > ();
            return users;
        }
        set;
    }

    Public map < Id, Id > AccountContactMap {
        get {
            if (AccountContactMap == null) AccountContactMap = new Map < Id, Id > ();
            return AccountContactMap;
        }
        set;
    }

    public set < Id > AccountIds {
        get {
            if (AccountIds == null) AccountIds = new set < Id > ();
            return AccountIds;
        }
        set;
    }

    Public map < Id, Id > AccountContactMapOld {
        get {
            if (AccountContactMapOld == null) AccountContactMapOld = new Map < Id, Id > ();
            return AccountContactMapOld;
        }
        set;
    }

    public set < Id > AccountIdsOld {
        get {
            if (AccountIdsOld == null) AccountIdsOld = new set < Id > ();
            return AccountIdsOld;
        }
        set;
    }

    public Map < Id, Id > Account_AccountContactMapOld {
        get {
            if (Account_AccountContactMapOld == null) Account_AccountContactMapOld = new Map < Id, Id > ();
            return Account_AccountContactMapOld;
        }
        set;
    }
    Public Map < Id, Id > AccountContact_ContactMapOld {
        get {
            if (AccountContact_ContactMapOld == null) AccountContact_ContactMapOld = new Map < Id, Id > ();
            return AccountContact_ContactMapOld;
        }
        set;
    }
    Public Map < Id, Id > AccountContact_ContactMapNew {
        get {
            if (AccountContact_ContactMapNew == null) AccountContact_ContactMapNew = new Map < Id, Id > ();
            return AccountContact_ContactMapNew;
        }
        set;
    }
    public Map < Id, Id > Account_AccountContactMapNew {
        get {
            if (Account_AccountContactMapNew == null) Account_AccountContactMapNew = new Map < Id, Id > ();
            return Account_AccountContactMapNew;
        }
        set;
    }

    //List to store the records of an share sObject whichwill be deleted when access is revoked or status turn inactive
    Public List < sObject > ShareObjectToBeDeletedRecords {
        get {
            if (ShareObjectToBeDeletedRecords == null) ShareObjectToBeDeletedRecords = new List < sObject > ();
            return ShareObjectToBeDeletedRecords;
        }
        set;
    }
    Public List < sObject > ToBeDeletedRecords {
        get {
            if (ToBeDeletedRecords == null) ToBeDeletedRecords = new List < sObject > ();
            return ToBeDeletedRecords;
        }
        set;
    }
    Public List < sObject > ShareObjectToBeUpdatedRecords {
        get {
            if (ShareObjectToBeUpdatedRecords == null) ShareObjectToBeUpdatedRecords = new List < sObject > ();
            return ShareObjectToBeUpdatedRecords;
        }
        set;
    }

    //Initializing Utility Class
    public SharingUtilityController utilityController {
        get {
            if (utilityController == null) utilityController = new SharingUtilityController();
            return utilityController;
        }
        set;
    }
    public void getAccountIds(Boolean isInsert, Boolean isUpdate, Map < Id, MUSW__Account_Contact__c > AccountContactTriggerOld, Map < Id, MUSW__Account_Contact__c > AccountContactTriggerNew) {
        //Prepare an Account Contact Map. This Map will be used to fetch the user from the contact based on Account Id
        AccountContactMap = new Map < Id, Id > ();

        //Set of unique Account Ids that are created in Account Contact Object
        AccountIds = new Set < Id > ();

        // Variables used when Recalculate Sharing Flag is checked 
        /*
         * @. List of AccountContactList to be updated when the recalculate sharing flag is checked to True
         * @. List of Users for whom the sharing should be recalculated when recalculate sharing flag is checked to true
         * @. Map of Account Contact when recalculate sharing is checked to true      
         * @. Map of Contact user when recalculate sharing is checked to true
         */
        List < MUSW__Account_Contact__c > Recalculate_Sharing_AccountContactList = new List < MUSW__Account_Contact__c > ();
        List < User > Recalculate_Sharing_Users = new List < User > ();
        Map < Id, Id > Recalculate_Sharing_AccountContactMap = new Map < Id, Id > ();
        Map < Id, Id > Recalculate_sharing_ContactUserMap = new Map < Id, Id > ();

        /*
         * @. Prepare set of Account Ids for new Account Contact records
         * @. Prepare AccountContactMap for New Account Contact records 
         * @. Prepare Account_AccountContactMap for the new Account Contact records        
         * @. Prepare Account_ContactMap for the new Account Contact records 
         */
        if (AccountContactTriggerNew.size() > 0) {
            for (MUSW__Account_Contact__c accountContact: AccountContactTriggerNew.values()) {
                if (accountContact.Associate_Status__c == label.ST_Active) {
                    AccountIds.add(accountContact.MUSW__Account__c);
                    AccountContactMap.put(accountContact.MUSW__Account__c, accountContact.MUSW__Contact__c);
                    Account_AccountContactMapNew.put(accountContact.MUSW__Account__c, accountContact.Id);
                    AccountContact_ContactMapNew.put(accountContact.Id, accountContact.MUSW__Contact__c);
                }
            }
        }

        /*
         * @. Compare old and new Account Contact List 
         * @. Check if the recalculate sharing flag value is changed before and after the Account Contact Update  
         * @. Check if the recalculate sharing falg is changed to true         
         * @. Populate 'Recalculate sharing Account Contact List' and 'Sharing flag Account Contact Map'  
         */
        if (AccountContactTriggerOld!=null && AccountContactTriggerOld.size() > 0) {
            for (Id id: AccountContactTriggerOld.keySet()) {
                MUSW__Account_Contact__c oldAccCon = AccountContactTriggerOld.get(id);
                MUSW__Account_Contact__c newAccCon = AccountContactTriggerNew.get(id);

                if (oldAccCon.Associate_Status__c == label.ST_Active) {
                    // Check if the recalculate sharing flag was updated to true
                    if (oldAccCon.Recalculate_Sharing__c != newAccCon.Recalculate_Sharing__c && newAccCon.Recalculate_Sharing__c == true) {
                        Recalculate_Sharing_AccountContactList.add(newAccCon);
                        Recalculate_Sharing_AccountContactMap.put(newAccCon.MUSW__Account__c, newAccCon.MUSW__Contact__c);
                    }
                    system.debug('recalcMap1>' + Recalculate_Sharing_AccountContactMap);

                    AccountIdsold.add(oldAccCon.MUSW__Account__c);
                    AccountContactMapold.put(oldAccCon.MUSW__Account__c, oldAccCon.MUSW__Contact__c);
                    Account_AccountContactMapOld.put(oldAccCon.MUSW__Account__c, oldAccCon.Id);
                    AccountContact_ContactMapOld.put(oldAccCon.Id, oldAccCon.MUSW__Contact__c);
                }
            }

        }

        /*
         * @. Query the users for new Account Contact Map 
         * @. Populate ContactUser map for the Above queried users   
         */
        try {
            if (AccountContactMap != null) {
                users = [Select Id, ContactId from User where ContactId in: AccountContactMap.values()AND UserType = 'PowerCustomerSuccess'];
            }
        } catch (Exception e) {
            ErrorLogger.logGeneralException(e, UserInfo.getUserId(), label.Str_User, 'getting users', 'getAccountIds', 'ApexUserSharingModel', label.Str_High); 
            //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error '+e));
        }

        if (users.size() > 0) {
            for (User u: users) {
                ContactUserMap.put(u.contactId, u.Id);
            }
        }

        /*
         * @. Query the users for when the recalculate sharing flag is checked  
         * @. Populate ContactUser map for the above users   
         */
        try {
            if (Recalculate_Sharing_AccountContactMap != null) {
                Recalculate_Sharing_Users = [Select Id, ContactId from User where ContactId in: Recalculate_Sharing_AccountContactMap.values() AND UserType = 'PowerCustomerSuccess'];
            }
        } catch (exception e) {
            ErrorLogger.logGeneralException(e, UserInfo.getUserId(), label.Str_User, 'getting recalculate sharing users', 'getAccountIds', 'ApexUserSharingModel', label.Str_High); 
            //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error '+e));
        }

        if (Recalculate_Sharing_Users.size() > 0) {
            for (User u: Recalculate_Sharing_Users) {
                Recalculate_sharing_ContactUserMap.put(u.contactId, u.Id);
            }
            system.debug(Recalculate_sharing_ContactUserMap);
        }

        system.debug('ContactUserMap>>' + ContactUserMap);
        AccountContactMapOld = new Map < Id, Id > ();

        //Set of unique Account Ids that are created in Account Contact Object
        AccountIdsOld = new Set < Id > ();

        /*
         * @. Share all the related records of Account Contact when ever a record is inserted with Status equal to Active   
         */
        if (isInsert) {
            if (AccountContactMap != null && ContactUserMap != null) {
                shareRecords_on_Insert(AccountContactMap, ContactUserMap);
            }
        }

        /*
         * @. Check if the Account Contact Has been Updated
         * @. if the Contact on Account Contact has been updated, Call AccountContactUpdate Method
         * @. if the status on the Account Contact is updated, Call AccountContactStatusUpdate Method
         * @. if the Recalculate Sharing flag is checked to true, Call RecalculateSharing_on_FlagCheck Method
         */
        if (isUpdate) {
            AccountContactUpdate(Account_AccountContactMapOld, AccountContact_ContactMapOld, Account_AccountContactMapNew, AccountContact_ContactMapNew);
            AccountContactStatusUpdate(AccountContactTriggerOld, AccountContactTriggerNew);
            if (Recalculate_Sharing_AccountContactMap != null && Recalculate_sharing_ContactUserMap != null) {
                system.debug('Map1>' + Recalculate_Sharing_AccountContactMap);
                system.debug('Map2>' + Recalculate_sharing_ContactUserMap);
                RecalculateSharing_on_FlagCheck(Recalculate_Sharing_AccountContactMap, Recalculate_sharing_ContactUserMap);
            }
        }
    }

    /**
     * Method name   : shareRecords_on_Insert
     * Description   : 1. Whenever an record in AccountContact is inserted,Share all the related Objects with the user on the Account Contact   
     *                 2. Gets list of records from Custom Metadata Type where triggering Object is Account Contact
     *                 3. Loop through records on Custom Metadata type list
     *                 4. for the current iteration of the custom metadata loop, get the list of sObject records
     *                 5. Loop through the List of sObject records to create records to be shared 
     *                 6. Insert the Records 
     * Return Type   : None
     * Parameter     : AccountContactMapforInsert, ContactUserMapforInsert
     **/


    public void shareRecords_on_Insert(Map < Id, Id > AccountContactMapforInsert, Map < Id, Id > ContactUserMapforInsert) {
        //Fetching all the records from the Custom Metadata Type. 
        //The trigger loops over the custom Meta data Type records and builds a dyunamic query get the list of records from the Object which have to be shared. 


        List < User_Sharing_Model__mdt > customMdtShareRecords = utilityController.Sharing_Utility_queryCustomMetaDataRecords('MUSW__Account_Contact__c', 'After Insert');
        system.debug('customMdtShareRecords-->' + customMdtShareRecords);

        if (AccountContactMapforInsert.size() > 0) {
            //loop over all the custom Metadata Type records to prepare a Query String for each Record
            for (User_Sharing_Model__mdt customMdtShareRecord: customMdtShareRecords) {
                if (customMdtShareRecord.Shared_Object__c != null) {
                    //Map < String, Schema.SObjectType > schemaMap = Schema.getGlobalDescribe();
                    //Schema.SObjectType leadSchema = schemaMap.get(customMdtShareRecord.Shared_Object__c);
                    Map < String, Schema.SObjectField > fieldMap = utilityController.Sharing_Utility_getfieldMap(customMdtShareRecord.Shared_Object__c);
                    ContactUserMap = new map < Id, Id > ();

                    system.debug('ContactUserMap>>' + ContactUserMapforInsert);
                    try {

                        //prepare list of account ids that can be used inthe where clause of the Query
                        List < Id > accids = new List < Id > ();
                        accids.addAll(AccountContactMapforInsert.keySet());
                        system.debug(accids);
                        //system.debug('AccountIds>>'+AccountIds);

                        //Generate Query String if it is Account or a Custom Object 
                        String QueryString = '';
                        if (customMdtShareRecord.Shared_Object__c == 'Account') {
                            QueryString = 'select Name,' + customMdtShareRecord.Object_Relationship__c + ' from ';
                            QueryString = QueryString + customMdtShareRecord.Shared_Object__c + ' where ';
                            QueryString = QueryString + customMdtShareRecord.Object_Relationship__c + ' IN :accids';
                        } else {
                            QueryString = 'select Id, Name,' + customMdtShareRecord.Object_Relationship__c + ' from ';
                            QueryString = QueryString + customMdtShareRecord.Shared_Object__c + ' where ';
                            QueryString = QueryString + customMdtShareRecord.Object_Relationship__c + ' IN :accids';
                        }

                        //QueryString=QueryString+accids;

                        system.debug('QueryString>>' + QueryString);

                        //Query the records from the Object which need to be Shared 
                        if (QueryString != '') {
                            ShareRecords = Database.Query(QueryString);
                        }

                        // Loop through all the queried records
                        if (ShareRecords.size() > 0) {

                            //Initialist shareObject list that needs to be shared
                            ShareObjectRecords = new List < sObject > ();

                            //Loop through Queried records 
                            for (sObject recordtobeShared: ShareRecords) {
                                Id contactId = null;

                                // Break the Object relationship to get the contact Id 
                                if ((customMdtShareRecord.Object_Relationship__c).indexOf('.') != -1) {
                                    String[] objectRel = (customMdtShareRecord.Object_Relationship__c).split('\\.');
                                    sObject sobj = recordtobeShared;
                                    for (Integer i = 0; i < objectRel.size(); i++) {
                                        if (i == objectRel.size() - 1) {
                                            system.debug(sobj.get(objectRel[i]));
                                            contactId = AccountContactMapforInsert.get((Id) sobj.get(objectRel[i]));
                                        } else {
                                            sobj = sobj.getSObject(objectRel[i]);
                                        }
                                    }
                                } else {
                                    system.debug(fieldMap);
                                    system.debug(fieldMap.get(customMdtShareRecord.Object_Relationship__c));
                                    system.debug(recordtobeShared.get(fieldMap.get(customMdtShareRecord.Object_Relationship__c)));
                                    contactId = AccountContactMapforInsert.get((Id) recordtobeShared.get(fieldMap.get(customMdtShareRecord.Object_Relationship__c)));
                                }

                                system.debug('contactId>>' + contactId);
                                system.debug(customMdtShareRecord.Object_to_Share__c);

                                //Initialize share Object. For Example: if you want to share License, this sObject will be MUSW__License2__share
                                sObject sObj = Schema.getGlobalDescribe().get(customMdtShareRecord.Object_to_Share__c).newSObject();

                                if (contactId != null) {
                                    system.debug('sObj>>' + sObj);
                                    system.debug('ContactUserMap user' + ContactUserMapforInsert.get(contactId));

                                    system.debug('recordtobeShared.Id>>' + recordtobeShared.Id);

                                    // Create shareObject record with Approriate field values
                                    // There are two conditions here, if the sObject is AccountShare, populate the corresponding field values
                                    // If the sObject is a custom object, populate the corresponding field values  

                                    if ((String.valueOf(Schema.getGlobalDescribe().get(customMdtShareRecord.Object_to_Share__c))) == 'AccountShare') {
                                        sObj.put('accountId', recordtobeShared.Id); 
                                        sObj.put('UserOrGroupId', ContactUserMapforInsert.get(contactId));
                                        sObj.put('AccountAccessLevel', customMdtShareRecord.User_Access_Level__c);
                                        sObj.put('OpportunityAccessLevel', customMdtShareRecord.User_Access_Level__c);

                                        ShareObjectRecords.add(sObj);
                                        system.debug('ShareObjectRecords' + ShareObjectRecords);

                                    } else {
                                        sObj.put('parentId', recordtobeShared.Id);
                                        sObj.put('UserOrGroupId', ContactUserMapforInsert.get(contactId));
                                        sObj.put('AccessLevel', customMdtShareRecord.User_Access_Level__c);
                                        sObj.put('RowCause', customMdtShareRecord.Sharing_Reason__c);
                                        ShareObjectRecords.add(sObj);
                                        system.debug('ShareObjectRecords' + ShareObjectRecords);
                                    }


                                }
                            }
                        }
                    } catch (Exception e) {
                        ErrorLogger.logGeneralException(e, UserInfo.getUserId(),label.Str_User, '', label.Str_shareRecords_on_Insert, label.Str_UserprofileChangedToCommunityPlus, label.Str_High);
                        //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error '+e));
                    }

                    //Insert the Records 
                    system.debug('ShareObjectRecords-->>' + ShareObjectRecords);
                    utilityController.Sharing_Utility_InsertRecords(ShareObjectRecords);
                }
            }
        }
    }

    /**
     * Method name   : AccountContactUpdate
     * Description   : 1. This method is called whenever a contact on the AccountContact is updated 
     *                 2. Prepare necessary maps to be passed as parameters to the other RecalculateSharingonConatctUpdate Method 
     * Return Type   : None
     * Parameter     : AccountAccountContactOld, AccountContactContactOld,AccountAccountContactNew, AccountContactContactNew
     **/
    public void AccountContactUpdate(Map < Id, Id > AccountAccountContactOld, Map < Id, Id > AccountContactContactOld, Map < Id, Id > AccountAccountContactNew, Map < Id, Id > AccountContactContactNew) {

        //Query Custom MetadataType Records for AccountContact
        List < User_Sharing_Model__mdt > customMdtShareRecords = [select Id, DeveloperName, Object_Relationship__c, Shared_Object__c, Object_to_Share__c, Triggering_Event__c, Triggering_Object__c, User_Access_Level__c from User_Sharing_Model__mdt where Triggering_Object__c = 'MUSW__Account_Contact__c'];

        // Account - AccountContact Delete Map 
        Map < Id, Id > AccountAccountContactDeleteMap = new Map < Id, Id > ();

        // Account - AccountContact Update Map 
        Map < Id, Id > AccountAccountContactUpdateMap = new Map < Id, Id > ();

        // AccountContact - Contact Delete Map 
        Map < Id, Id > AccountContactContactDeleteMap = new Map < Id, Id > ();

        // AccountContact - Contact Update Map 
        Map < Id, Id > AccountContactContactUpdateMap = new Map < Id, Id > ();

        // Populate the above maps 
        for (Id OldAccContactAccount: AccountAccountContactOld.keyset()) {
            for (Id NewAccContactAccount: AccountAccountContactNew.keyset()) {

                // if the accounts are same 
                if (AccountAccountContactOld.get(OldAccContactAccount) == AccountAccountContactNew.get(NewAccContactAccount)) {

                    // Contacts have changed
                    if (AccountContactContactOld.get(AccountAccountContactOld.get(OldAccContactAccount)) != AccountContactContactNew.get(AccountAccountContactNew.get(NewAccContactAccount))) {
                        AccountAccountContactDeleteMap.put(OldAccContactAccount, AccountAccountContactOld.get(OldAccContactAccount));
                        AccountAccountContactUpdateMap.put(NewAccContactAccount, AccountAccountContactNew.get(NewAccContactAccount));
                        AccountContactContactDeleteMap.put(AccountAccountContactOld.get(OldAccContactAccount), AccountContactContactOld.get(AccountAccountContactOld.get(OldAccContactAccount)));
                        AccountContactContactUpdateMap.put(AccountAccountContactNew.get(NewAccContactAccount), AccountContactContactNew.get(AccountAccountContactNew.get(NewAccContactAccount)));
                    }
                }
            }
        }

        if (AccountAccountContactDeleteMap != null && AccountAccountContactUpdateMap != null) {

            // Recalculate sharing on contact update on Account Contact 
            reCalculateRecordSharingonContactUpdate(AccountAccountContactDeleteMap, AccountAccountContactUpdateMap, AccountContactContactDeleteMap, AccountContactContactUpdateMap);

        }

    }

    /**
     * Method name   : reCalculateRecordSharingonContactUpdate
     * Description   : 1. This method is called in AccountContactUpdate method with Necessary maps as parameters 
     *                 2. Delete the sharing for the previous Contact on Account Contact
     *                 3. Grant Access for sharing records to the new contact on the Account Contact 
     * Return Type   : None
     * Parameter     : AccountContactMapforInsert, ContactUserMapforInsert
     **/
    Public void reCalculateRecordSharingonContactUpdate(Map < Id, Id > AccountAccountContactDelMap, Map < Id, Id > AccountAccountContactUpdMap, Map < Id, Id > AccountContactContactDelMap, Map < Id, Id > AccountContactCOntactUpdMap) {
        Map < Id, Id > ContactUserDelMap = new Map < Id, Id > ();
        Map < Id, Id > ContactUserUpdMap = new Map < Id, Id > ();
        List < User > User_revokeAccessList = new List < User > ();
        List < User > User_GrantAccessList = new List < User > ();
        if (AccountContactContactDelMap != null) {

            //User for whom the record sharing should be deleted
            //Map of Contact user Delete map
            try {
                User_revokeAccessList = [select Id, ContactId from User where ContactId IN: AccountContactContactDelMap.values() AND UserType = 'PowerCustomerSuccess'];
            } catch (exception e) {
                ErrorLogger.logGeneralException(e, UserInfo.getUserId(), label.Str_User, 'recalculate sharing on contact update on Account Contact', 'reCalculateRecordSharingonContactUpdate', 'ApexUserSharingModel', label.Str_High); 
                //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error '+e));
            }
            if (User_revokeAccessList.size() > 0) {
                for (User tobeRevokedAccessContact: User_revokeAccessList) {
                    ContactUserDelMap.put(tobeRevokedAccessContact.ContactId, tobeRevokedAccessContact.Id);
                }

            }
        }
        if (AccountContactContactUpdMap != null) {

            //new users for whom the record sharing need to be enabled 
            //Prepare ContactUserUpdMap 
            try {
                User_GrantAccessList = [select Id, ContactId from User where ContactId IN: AccountContactContactUpdMap.values() AND UserType = 'PowerCustomerSuccess'];
            } catch (exception e) {
                ErrorLogger.logGeneralException(e, UserInfo.getUserId(), label.Str_User, 'User_GrantAccessList', 'reCalculateRecordSharingonContactUpdate', 'ApexUserSharingModel', label.Str_High); 
                //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error '+e));
            }
            if (User_GrantAccessList.size() > 0) {
                for (User tobeGrantedAccessContact: User_GrantAccessList) {
                    ContactUserUpdMap.put(tobeGrantedAccessContact.ContactId, tobeGrantedAccessContact.Id);
                }
            }
        }

        // Query Custom Meta Data Records 
        List < User_Sharing_Model__mdt > customMdtShareRecords = [select Id, DeveloperName, Object_Relationship__c, Shared_Object__c, Object_to_Share__c, Triggering_Event__c, Sharing_Reason__c, Triggering_Object__c, User_Access_Level__c from User_Sharing_Model__mdt where Triggering_Object__c = 'MUSW__Account_Contact__c'
            and Triggering_Event__c = 'After Update'
        ];
        system.debug('customMdtShareRecords>>' + customMdtShareRecords);

        for (User_Sharing_Model__mdt customMdtShareRecord: customMdtShareRecords) {
            if (customMdtShareRecord.Object_to_Share__c != null) {

                //Field Map for the share Object
                Map < String, Schema.SObjectField > fieldMap = utilityController.Sharing_Utility_getfieldMap(customMdtShareRecord.Shared_Object__c);

                try {
                    if (ContactUserDelMap != null && ContactUserUpdMap != null) {

                        //List of user ids with which the records to be shared
                        List < Id > Uids = new List < Id > ();
                        Uids.addAll(ContactUserDelMap.values());

                        // prepare the existing share Object records for the previopus user on the Account Contact  
                        String QueryString = 'select Id, ParentId,UserorGroupId,RowCause' + ' from ';
                        QueryString = QueryString + customMdtShareRecord.Object_to_Share__c + ' where ';
                        QueryString = QueryString + 'UserorGroupId IN :Uids';


                        system.debug('QueryString>>' + QueryString);

                        //Records whose sharing needs to be updated with access to the new user on the account COntact 
                        ShareObjectToBeUpdatedRecords = new List < sObject > ();

                        //Records whose sharing needs to be deleted for the previous user on the account COntact 
                        ShareObjectToBeDeletedRecords = new List < sObject > ();

                        //Query to be deleted records with the Query string generated 
                        ShareObjectToBeDeletedRecords = Database.Query(QueryString);

                        //Initialize share Object to which the records needs to be inserted 
                        sObject sObj = Schema.getGlobalDescribe().get(customMdtShareRecord.Object_to_Share__c).newSObject();

                        //Loop through the records which need to be deleted
                        // All the information will remain same here except the userorGroup id information. 
                        //So just change the user and insert the records with the new user and delete the old records with previous user
                        for (sObject ShareObjectToBeUpdated: ShareObjectToBeDeletedRecords) {
                            Id userId = null;
                            system.debug('409>' + ShareObjectToBeUpdated.get('UserOrGroupId'));
                            if (ShareObjectToBeUpdated != null && ShareObjectToBeUpdated.get('UserOrGroupId') != null) {

                                for (Id con: ContactUserDelMap.keySet()) {

                                    // checking if the user on the contactusermap and the uyser on the record to be updated are the same 
                                    if (ContactUserDelMap.get(con) == ShareObjectToBeUpdated.get('UserorGroupId')) {
                                        system.debug('user on contactuserdel map and shareObject are same');


                                        for (Id a: AccountContactContactDelMap.keyset()) {

                                            //checking if the AccountContactContactDelete map has this contact 
                                            if (AccountContactContactDelMap.get(a) == con) {
                                                system.debug('422');
                                                if (AccountAccountContactDelMap != null && AccountContactCOntactUpdMap != null) {
                                                    system.debug('a>' + a);
                                                    for (Id d: AccountAccountContactDelMap.keyset()) {

                                                        //comparing the if the AccountContact for the above contact exists in the AccountContactContactDelete Map
                                                        if (a == AccountAccountContactDelMap.get(d)) {

                                                            //get the new userId with whom the records will be shared. 
                                                            //AccountContactContact map has the new contact with whom the record to be shared 
                                                            //ContactuserUpdMap has the portal user id
                                                            userId = ContactUserUpdMap.get(AccountContactCOntactUpdMap.get(a));
                                                            system.debug('userId>' + userId);
                                                        }
                                                    }

                                                }
                                            }
                                        }
                                    }
                                }
                                //Records on which the user information is changed need to be deleted. Below is the list which need to be deleted. 
                                ToBeDeletedRecords.add(ShareObjectToBeUpdated);


                                if (userId != null) {
                                    sObj.put('parentId', ShareObjectToBeUpdated.get('parentId'));
                                    sObj.put('AccessLevel', 'Edit');
                                    sObj.put('RowCause', customMdtShareRecord.Sharing_Reason__c);
                                    sObj.put('UserOrGroupId', userId);

                                   

                                    //Records which need to be inserted 
                                    ShareObjectToBeUpdatedRecords.add(sObj);
                                }
                            }

                        }
                    }
                } catch (exception e) {
                    ErrorLogger.logGeneralException(e, UserInfo.getUserId(), label.Str_User, 'Error caused when looping through Account Contact Records', 'reCalculate Record Sharing on Contact Update', 'ApexUserSharingModel',label.str_HIGH); 
                    //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error '+e));
                }
            }
            //Delete the old records 
        system.debug('ToBeDeletedRecords' + ToBeDeletedRecords);
        utilityController.Sharing_Utility_DeleteRecords(ToBeDeletedRecords);

        //Insert the records with the new user
        if (ShareObjectToBeUpdatedRecords.size() > 0) {
            system.debug('ShareObjectToBeUpdatedRecords>' + ShareObjectToBeUpdatedRecords);
            utilityController.Sharing_Utility_InsertRecords(ShareObjectToBeUpdatedRecords);
        }
            
       }

    }

    /**
     * Method name   : AccountContactStatusUpdate
     * Description   : 1. This method is called whenever a status on the AccountContact is updated from Active to Inactive
     *                 2. Prepare necessary maps to be passed as parameters to the other recalculateSharing_on_AccountContactStatusUpdate Method 
     * Return Type   : None
     * Parameter     : AccountContactOld,AccountContactNew
     **/
    public void AccountContactStatusUpdate(Map < Id, MUSW__Account_Contact__c > AccountContactOld, Map < Id, MUSW__Account_Contact__c > AccountContactNew) {

        Map < Id, Id > UpdatedAccountContact = new Map < Id, Id > ();
        for (Id OldAC: AccountContactOld.keySet()) {
            if (AccountContactNew.containsKey(OldAC)) {

                //Check if the status on Account Contact is updated from Active to Inactive 
                if ((AccountContactOld.get(OldAC)).Associate_Status__c != (AccountContactNew.get(OldAC)).Associate_Status__c && (AccountContactNew.get(OldAC)).Associate_Status__c == 'Inactive') {

                    //prepare the Map of Account Contact which need to be deleted
                    UpdatedAccountContact.put((AccountContactOld.get(OldAC)).MUSW__Account__c, (AccountContactOld.get(OldAC)).MUSW__Contact__c);
                }

            }
        }

        if (UpdatedAccountContact != null) {

            //Call the method which recalculates the sharing when status is changed from Active to Iactive
            recalculateSharing_on_AccountContactStatusUpdate(UpdatedAccountContact);
        }
    }

    /**
     * Method name   : recalculateSharing_on_AccountContactStatusUpdate
     * Description   : 1. Delete the sharing for records whose status is changed to Inactive                 
     * Return Type   : None
     * Parameter     : UpdAccountContactMap
     **/
    public void recalculateSharing_on_AccountContactStatusUpdate(Map < Id, Id > UpdAccountContactMap) {

        //List of records which need to be deleted will be queried in to the below list 
        List < sObject > StatusUpdate_TobeDeletedRecords = new List < sObject > ();

        //List of records which need to be deleted will be added to the below list 
        List < sObject > DeleteList = new List < sObject > ();
        if (UpdAccountContactMap != null) {
            List < User_Sharing_Model__mdt > customMdtShareRecords = [select Id, DeveloperName, Object_Relationship__c, Shared_Object__c, Object_to_Share__c, Triggering_Event__c, Triggering_Object__c, Sharing_Reason__c, User_Access_Level__c from User_Sharing_Model__mdt where Triggering_Object__c = 'MUSW__Account_Contact__c'
                and Triggering_Event__c = 'After Update'
            ];
            system.debug('customMdtShareRecords>>' + customMdtShareRecords);

            //List of Users for whom the access should be removed 
            List < User > users = new List < User > ();
            List < Id > contactIds = new List < Id > ();
            contactIds.addAll(UpdAccountContactMap.values());
            users = [Select Id, ContactId from User where ContactId IN: contactIds AND UserType = 'PowerCustomerSuccess'];
            Map < Id, Id > statusUpdateContactUserMap = new Map < Id, Id > ();

            //Corresponding Contact user Map
            if (users.size() > 0) {
                for (User u: users) {
                    if (u.ContactId != null && u.Id != null) {
                        statusUpdateContactUserMap.put(u.ContactId, u.Id);
                    }
                }
            }

            // Loop through the Custom Metadata records 
            for (User_Sharing_Model__mdt customMdtShareRecord: customMdtShareRecords) {
                if (customMdtShareRecord.Object_to_Share__c != null) {

                    Map < String, Schema.SObjectField > fieldMap = utilityController.Sharing_Utility_getfieldMap(customMdtShareRecord.Shared_Object__c);

                    try {

                        //List of users id which will be used in the where clause 
                        List < Id > Uids = new List < Id > ();
                        Uids.addAll(statusUpdateContactUserMap.values());

                        //Prepare Query String for to query share object Records which need to be deleted 
                        String QueryString = 'select Id, ParentId,UserorGroupId,RowCause' + ' from ';
                        QueryString = QueryString + customMdtShareRecord.Object_to_Share__c + ' where ';
                        QueryString = QueryString + 'UserorGroupId IN :Uids';
                        system.debug('QueryString>>' + QueryString);

                        //Query records to the below List 
                        StatusUpdate_TobeDeletedRecords = Database.Query(QueryString);
                        sObject sObj = Schema.getGlobalDescribe().get(customMdtShareRecord.Object_to_Share__c).newSObject();

                        for (sObject ToBeDeletedRecord: StatusUpdate_TobeDeletedRecords) {
                            sObj = ToBeDeletedRecord;
                            DeleteList.add(sObj);
                        }
                    } catch (Exception e) {
                         ErrorLogger.logGeneralException(e, UserInfo.getUserId(), label.Str_User, 'Error caused when looping through Account Contact Records', 'reCalculate Record Sharing on Contact Update', 'ApexUserSharingModel',label.str_HIGH);
						 //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error '+e));
                    }
                }
            }
            system.debug('ToBeDeletedRecords' + DeleteList);
            utilityController.Sharing_Utility_DeleteRecords(DeleteList);
        }
    }

    /**
     * Method name   : RecalculateSharing_on_FlagCheck
     * Description   : 1. Futiure method which will be called when Rcalculate Sharing Fal is checked                  
     * Return Type   : None
     * Parameter     : RecalcAccountContactMap,RecalcContactUserMap
     **/
    @future
    public static Void RecalculateSharing_on_FlagCheck(Map < Id, Id > RecalcAccountContactMap, Map < Id, Id > RecalcContactUserMap) {
        system.debug('e');
        ApexUserSharingModel c = new ApexUserSharingModel();
        //This calls the method which create share objects records when account contact is inserted 
        c.shareRecords_on_Insert(RecalcAccountContactMap, RecalcContactUserMap);
    }
}