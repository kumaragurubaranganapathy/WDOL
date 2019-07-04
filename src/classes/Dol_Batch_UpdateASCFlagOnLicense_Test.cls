@isTest(SeeAllData=true)
private class Dol_Batch_UpdateASCFlagOnLicense_Test {
    
    @isTest static void test_method_one() {
    	Account acc = new Account(name = 'testaccount');
         insert acc;
         contact con = new contact(LastName = 'test Last' , Accountid = acc.id, UBI_Number__c = 'ubi',IsContactRecordUpdatedForASC__c= true);
         insert con;
         
        MUSW__Parcel__c parcel = new MUSW__Parcel__c();
        parcel.Name = 'License Parcel';
        parcel.MUSW__Street2__c = '231 west 4th st';
        parcel.MUSW__City__c = 'Milpitas';
        parcel.IsParcelRecordUpdatedForASC__c = true;
        insert parcel;
        
        con.LastName = 'LastName';
        upsert con;
        
        parcel.MUSW__State__c= 'CA';
        upsert parcel;
        
        MUSW__License2__c license1  = new MUSW__License2__c();
        license1.Name= 'System Number';
        license1.Application_Type__c ='Engineers';
        license1.Credential_Type__c = 'Engineer in Training';
        license1.MUSW__Applicant__c = con.id;
        insert license1;
        
        MUSW__License2__c license2  = new MUSW__License2__c();
        license2.Name= 'System Number';
        license2.Application_Type__c ='Engineers';
        license2.Credential_Type__c = 'Engineer in Training';
        license2.MUSW__Parcel__c = parcel.id;
        insert license2;
        
    	test.startTest();
    		Dol_Batch_UpdateASCFlagOnLicense batchObj = new Dol_Batch_UpdateASCFlagOnLicense();
			id batchJob = database.executeBatch(batchObj);
    	test.stopTest();

    }
}