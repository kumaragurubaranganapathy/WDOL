@isTest(SeeAllData=true)
private class Dol_Batch_UpdateASCFlagOnLicense_Test {
    
    @isTest static void test_method_one() {
    	Account acc = new Account(name = DOL_AppConstants.NULL_EMPTY_STRING + 'testaccount');
         insert acc;
         contact con = new contact(LastName = DOL_AppConstants.NULL_EMPTY_STRING + 'test Last' , Accountid = acc.id, UBI_Number__c = DOL_AppConstants.NULL_EMPTY_STRING + 'ubi',IsContactRecordUpdatedForASC__c= true);
         insert con;
         
        MUSW__Parcel__c parcel = new MUSW__Parcel__c();
        parcel.Name = DOL_AppConstants.NULL_EMPTY_STRING + 'License Parcel';
        parcel.MUSW__Street2__c = DOL_AppConstants.NULL_EMPTY_STRING + '231 west 4th st';
        parcel.MUSW__City__c = DOL_AppConstants.NULL_EMPTY_STRING + 'Milpitas';
        parcel.IsParcelRecordUpdatedForASC__c = true;
        insert parcel;
        
        con.LastName = DOL_AppConstants.NULL_EMPTY_STRING + 'LastName';
        upsert con;
        
        parcel.MUSW__State__c= DOL_AppConstants.NULL_EMPTY_STRING + 'CA';
        upsert parcel;
        
        MUSW__License2__c license1  = new MUSW__License2__c();
        license1.Name= DOL_AppConstants.NULL_EMPTY_STRING + 'System Number';
        license1.Application_Type__c = DOL_AppConstants.NULL_EMPTY_STRING + 'Engineers';
        license1.Credential_Type__c = DOL_AppConstants.NULL_EMPTY_STRING + 'Engineer in Training';
        license1.MUSW__Applicant__c = con.id;
        insert license1;
        
        MUSW__License2__c license2  = new MUSW__License2__c();
        license2.Name= DOL_AppConstants.NULL_EMPTY_STRING + 'System Number';
        license2.Application_Type__c = DOL_AppConstants.NULL_EMPTY_STRING + 'Engineers';
        license2.Credential_Type__c = DOL_AppConstants.NULL_EMPTY_STRING + 'Engineer in Training';
        license2.MUSW__Parcel__c = parcel.id;
        insert license2;
        
    	test.startTest();
    		Dol_Batch_UpdateASCFlagOnLicense batchObj = new Dol_Batch_UpdateASCFlagOnLicense();
			id batchJob = database.executeBatch(batchObj);
    	test.stopTest();

    }
}