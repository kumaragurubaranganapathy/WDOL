@isTest
private class Dol_Batch_UpdateASCFlagOnLicense_Test {
    
    @isTest static void test_method_one() {
    	Account acc = new Account(name = DOL_AppConstants.NULL_EMPTY_STRING + 'testaccount');
         insert acc;
         contact con = new contact(LastName = DOL_AppConstants.NULL_EMPTY_STRING + 'test Last' , Accountid = acc.id, UBI_Number__c = DOL_AppConstants.NULL_EMPTY_STRING + 'ubi',IsContactRecordUpdatedForASC__c= true, Unique_ID_To_Provide__c= 'SSN' );
         insert con;
        
        MUSW__License2__c license1  = new MUSW__License2__c();
        license1.Name= DOL_AppConstants.NULL_EMPTY_STRING + 'System Number';
        license1.Application_Type__c = DOL_AppConstants.NULL_EMPTY_STRING + 'Appraisers - Real Estate';
        license1.Credential_Type__c = DOL_AppConstants.NULL_EMPTY_STRING + 'Certified Residential Appraiser';
        license1.MUSW__Applicant__c = con.id;
        license1.Send_information_to_ASC__c = false;
        insert license1;
        
        license1.Send_information_to_ASC__c = false;
        upsert license1;
         
        MUSW__Parcel__c parcel = new MUSW__Parcel__c();
        parcel.Name = DOL_AppConstants.NULL_EMPTY_STRING + 'License Parcel';
        parcel.MUSW__Street2__c = DOL_AppConstants.NULL_EMPTY_STRING + '231 west 4th st';
        parcel.MUSW__City__c = DOL_AppConstants.NULL_EMPTY_STRING + 'Milpitas';
        parcel.IsParcelRecordUpdatedForASC__c = true;
        insert parcel;
        
        MUSW__License_Parcel__c  licPar1 = new MUSW__License_Parcel__c();
        licPar1.MUSW__Parcel__c  = parcel.id;
        licPar1.MUSW__License2__c  = license1.id;
        licPar1.Mailing__c  = true;
        licPar1.IsLicenseParcelUpdatedForASC__c = true;
        insert licPar1;
        List<MUSW__License_Parcel__c> licParList = new List<MUSW__License_Parcel__c>();
        licParList.add(licPar1);
    	test.startTest();
    		Dol_Batch_UpdateASCFlagOnLicense batchObj = new Dol_Batch_UpdateASCFlagOnLicense();
			id batchJob = database.executeBatch(batchObj);
    	test.stopTest();

    }
}